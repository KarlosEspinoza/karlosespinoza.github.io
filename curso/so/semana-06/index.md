---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 6 - Exclusión mutua y semáforos (U2)

Esta semana arreglas tu inventario. Y no de cualquier forma: vas a poder correr la misma prueba que la semana pasada te daba números distintos cada vez y obtener **el mismo resultado correcto en las cinco corridas**, con la evidencia lado a lado.

De paso queda contestada la pregunta que dejamos abierta en la semana 2, cuando comparaste tu servidor dormido al 0% contra el ciclo vacío al 100%. Resulta que las dos formas de esperar reaparecen aquí, en el corazón de cómo se implementa un candado, y elegir mal cuesta un núcleo completo de tu servidor.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: cómo se cierra una sección crítica](#bloque-1)
    - [Bloque 2: tu inventario protegido](#bloque-2)
    - [Bloque extra: cuánto cuesta el candado](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes espera activa, `synchronized` y `Semaphore` | Tu comparación de los tres mecanismos |
| 2 | Proteges tu inventario y repites las cinco corridas | `src/GestorInventario.java` y `evidencias/carrera_resuelta.txt` |
| Extra | Mides lo que cuesta el candado | Tu tabla de rendimiento con y sin protección |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: cómo se cierra una sección crítica {#bloque-1}

#### Lo que hay que garantizar

Antes de ver mecanismos, hay que tener claro qué se le pide a cualquier solución. Son tres cosas, y una solución que cumpla dos de tres no sirve:

| Propiedad | Qué quiere decir |
|---|---|
| **Exclusión mutua** | Si un hilo está dentro de la sección crítica, ningún otro puede entrar |
| **Progreso** | Si nadie está dentro, alguno de los que quieren entrar tiene que poder hacerlo. No se puede quedar la puerta trabada con la casa vacía |
| **Espera acotada** | Un hilo no puede quedarse esperando para siempre mientras otros entran y salen. A eso se le llama inanición (*starvation*) |

De las tres, la primera es la obvia. Las otras dos son las que se olvidan, y son la razón por la que **no debes inventar tu propio mecanismo de sincronización**: se ve fácil y casi todos los intentos caseros fallan en la segunda o en la tercera.

#### El primer intento, y por qué no funciona

Al que se le ocurre lo primero es a todo el mundo: una bandera.

```java
// NO FUNCIONA. Esto es para entender por que no funciona.
private boolean ocupado = false;

public boolean vender(String producto, int cantidad) {

    while (ocupado) { }      // espero a que se desocupe
    ocupado = true;          // lo marco como mio

    // ... seccion critica ...

    ocupado = false;
    return true;
}
```

Léelo con lo de la semana pasada en la cabeza y vas a ver el problema solo: entre el `while (ocupado)` y el `ocupado = true` **hay una ventana**. Dos hilos pueden ver `ocupado == false` los dos, salir los dos del `while`, y entrar los dos. Es exactamente la misma condición de carrera de la semana 5, ahora en el código que iba a resolverla.

La lección de fondo, y es la razón de que este tema exista: **no se puede resolver una condición de carrera solo con instrucciones normales**. Hace falta una operación que el hardware garantice **atómica**, es decir, que no se pueda interrumpir a la mitad. Los procesadores modernos traen instrucciones para eso (`test-and-set`, `compare-and-swap`), y sobre ellas se construye todo lo demás. Tú no las vas a escribir: las vas a usar envueltas.

#### Espera activa: la respuesta a la pregunta de la semana 2

Fíjate en ese `while (ocupado) { }`. Es un ciclo vacío dando vueltas hasta que una condición cambie. Tiene nombre: **espera activa** o *busy waiting*, y es literalmente el `EstadoR.java` que corriste en la semana 2 al 100% de CPU.

Ahí está la respuesta a la pregunta que dejamos abierta. Los dos programas esperaban lo mismo, pero:

| Forma de esperar | Estado en `ps` | %CPU | Qué hace el SO |
|---|---|---|---|
| **Espera activa** (ciclo vacío) | `R` | ~100 | Le sigue dando turnos de procesador, porque el proceso dice estar listo |
| **Espera pasiva** (bloqueo) | `S` | ~0 | Lo saca de la lista de candidatos y se lo da a otro. Lo despierta cuando llegue lo que espera |

El SO **no tiene forma de saber** que tu ciclo vacío no está haciendo nada útil. Ve un proceso que quiere procesador y se lo da. Por eso la espera activa quema un núcleo completo para no hacer nada.

Y sin embargo no siempre es mala. Si sabes que la espera va a durar menos de lo que cuesta dormir y despertar a un hilo (unos microsegundos), dar tres vueltas en un ciclo sale más barato que ir al kernel. De ahí que existan los *spinlocks* dentro del propio kernel de Linux. Pero para tu servidor, donde una venta tarda milisegundos, la regla es simple: **espera pasiva siempre**.

#### `synchronized`: el candado de Java

La forma más directa en Java. Marcas el método y listo:

```java
public synchronized boolean vender(String producto, int cantidad) {
    // ...
}
```

Qué hace por debajo: cada objeto en Java tiene asociado un **monitor**, que es un candado. Cuando un hilo entra a un método `synchronized`, **adquiere el candado del objeto**. Si otro hilo intenta entrar mientras tanto, el SO lo **bloquea** (estado `S`, no gasta CPU) y lo forma en una cola. Cuando el primero sale, el candado se libera y el SO despierta a uno de los que esperaban.

Tres cosas que hay que saber y que casi nadie tiene claras:

- **El candado es del objeto, no del método.** Si tu clase tiene tres métodos `synchronized`, los tres comparten el mismo candado: dos hilos no pueden estar en métodos distintos de ese objeto al mismo tiempo. A veces es lo que quieres y a veces es demasiado.
- **Se libera solo.** Al salir del método, aunque salga por una excepción. Eso lo hace muy difícil de usar mal, y es su principal virtud.
- **También existe por bloque**, para proteger solo unas líneas en vez del método entero:

  ```java
  synchronized (this) {
      // solo esto queda protegido
  }
  ```

#### `Semaphore`: contar permisos

Un **semáforo** es más general. En vez de "un candado", es **un contador de permisos** con dos operaciones:

| Operación | Nombre clásico | En Java | Qué hace |
|---|---|---|---|
| Pedir permiso | `wait` o `P` | `acquire()` | Si hay permisos, toma uno y sigue. Si no hay, **se bloquea** |
| Devolver permiso | `signal` o `V` | `release()` | Devuelve un permiso y despierta a alguien que esperaba |

```java
import java.util.concurrent.Semaphore;

private Semaphore candado = new Semaphore(1);   // un solo permiso

public boolean vender(String producto, int cantidad) throws InterruptedException {

    candado.acquire();          // pido permiso, aqui me puedo bloquear
    try {
        // ... seccion critica ...
        return true;
    } finally {
        candado.release();      // devuelvo el permiso, SIEMPRE
    }
}
```

Un semáforo inicializado en **1** se comporta como un candado y se le llama **mutex** (de *mutual exclusion*). Pero puede inicializarse en cualquier número, y ahí está su gracia: un semáforo en 3 deja pasar a **tres hilos a la vez** y bloquea al cuarto.

Eso sirve de verdad en tu dominio. Si tienes 3 consultorios, 4 técnicos o 20 cajones de estacionamiento, un `Semaphore(3)` modela ese límite directamente: los hilos que quieren un consultorio piden permiso, y el cuarto espera a que alguien salga.

Y el `finally` no es opcional. Si la sección crítica lanza una excepción y el `release()` no está en un `finally`, el permiso **no se devuelve nunca** y tu servidor se queda trabado para siempre. Es el error más común con semáforos, y el motivo por el que `synchronized` es más seguro para el caso simple.

#### Cuál usar

| Necesitas... | Usa |
|---|---|
| Que solo un hilo toque el inventario | `synchronized` |
| Limitar a N el número de hilos simultáneos (3 consultorios, 4 técnicos) | `Semaphore(N)` |
| Poder intentar sin quedarte bloqueado, o poner un tiempo límite | `ReentrantLock` (semana 7) |

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **Por qué la bandera `boolean ocupado` no funciona.** Traza el intercalado de dos hilos que consiguen entrar los dos, con la tabla de la semana 5. Es el mismo ejercicio, aplicado al código que pretendía arreglarlo.

2. **La respuesta a la pregunta de la semana 2**, ahora que ya tienes con qué: por qué el ciclo vacío gastaba 100% de CPU y el `Thread.sleep` no, si los dos esperaban lo mismo? Y qué tiene que ver eso con `synchronized`.

3. **Tu decisión, justificada.** Qué mecanismo vas a usar en tu `vender` y por qué. Si tu dominio tiene un recurso que se ocupa y se libera (consultorios, técnicos, cajones, herramientas), di además **dónde te conviene un `Semaphore(N)` con N mayor que 1** y cuál sería ese N en tu negocio.

```bash
git add .
git commit -m "s06 bloque 1: exclusion mutua, espera activa y semaforos"
git push
```

---

### Bloque 2: tu inventario protegido {#bloque-2}

Ahora lo arreglas. Y lo demuestras.

#### La corrección

Abre `src/GestorInventario.java`. **No borres nada todavía**: vas a necesitar la versión rota para comparar. Guarda una copia:

```bash
cd ~/so-proyecto/src
cp GestorInventario.java GestorInventario_roto.java.txt
```

Le ponemos `.txt` al final a propósito para que `javac` no intente compilarla como una clase con el nombre equivocado.

Ahora protege el `vender`. Lo mínimo es agregar una palabra:

```java
public synchronized boolean vender(String producto, int cantidad) {
```

Pero antes de escribirla, para y piensa **dónde tiene que empezar y terminar la protección**. En la semana 5 lo escribiste: la sección crítica va **desde la consulta hasta el descuento**, las dos dentro. Si proteges solo la línea del `put`, el error sigue ahí completo, porque dos hilos habrían pasado el `if` con la misma existencia.

Revisa también los otros métodos que tocan el mapa. Este es el punto que se pasa por alto:

- `existencia(String)` **lee** el mapa. Si otro hilo lo está modificando mientras tanto, puede leer un valor intermedio.
- Los contadores `ventasConfirmadas++` y `ventasRechazadas++` tienen exactamente el mismo problema del contador de la semana 4. Si están dentro del método protegido, ya quedaron cubiertos; si los mueves fuera, no.

Deja tu clase así:

```java
// GestorInventario.java - ahora con exclusion mutua
import java.util.HashMap;
import java.util.Map;

public class GestorInventario {

    private Map<String, Integer> existencias = new HashMap<>();
    private int ventasConfirmadas = 0;
    private int ventasRechazadas = 0;

    public synchronized void agregar(String producto, int cantidad) {
        existencias.put(producto, cantidad);
    }

    // Seccion critica completa: consulta Y descuento bajo el mismo candado.
    public synchronized boolean vender(String producto, int cantidad) {

        Integer disponible = existencias.get(producto);
        if (disponible == null) return false;

        if (disponible >= cantidad) {

            // Dejamos el sleep A PROPOSITO. Si el candado sirve,
            // el resultado tiene que ser correcto aunque la ventana sea enorme.
            try { Thread.sleep(1); } catch (InterruptedException e) { }

            existencias.put(producto, disponible - cantidad);
            ventasConfirmadas++;
            return true;
        }

        ventasRechazadas++;
        return false;
    }

    public synchronized int existencia(String producto) {
        return existencias.getOrDefault(producto, 0);
    }

    public synchronized int getVentasConfirmadas() { return ventasConfirmadas; }
    public synchronized int getVentasRechazadas() { return ventasRechazadas; }

    // TODO: tu metodo cargarDesde(String archivo) de la semana pasada.
    //       Piensa si necesita synchronized o no, y escribe por que en tu bitacora.
}
```

Dejar el `Thread.sleep(1)` dentro del candado es la parte más interesante de este bloque. La semana pasada ese `sleep` era lo que hacía visible el error; hoy, con el candado bien puesto, **el resultado tiene que ser correcto de todas formas**. Si sigue fallando con el `sleep` ahí, el candado está mal puesto. Es la mejor prueba que puedes tener.

#### Las mismas cinco corridas

Sin cambiar nada de `PruebaCarrera.java`, exactamente la misma prueba de la semana pasada:

```bash
cd ~/so-proyecto/src
javac GestorInventario.java PruebaCarrera.java

cd ~/so-proyecto
for i in 1 2 3 4 5; do
  echo "===== CORRIDA $i ====="
  java -cp src PruebaCarrera
done > evidencias/carrera_resuelta.txt 2>&1

cat evidencias/carrera_resuelta.txt
```

Ahora las cinco corridas tienen que dar **exactamente lo mismo**, y `CUADRA` tiene que decir `true` en las cinco. Si con 10 cajeros y 10 piezas se venden 10, con 50 cajeros y 10 piezas se tienen que confirmar 10 y rechazar 40. Siempre. Sin variación.

Compara los dos archivos lado a lado:

```bash
diff evidencias/carrera.txt evidencias/carrera_resuelta.txt | head -40
```

**Lo que entregas de este bloque**

1. `src/GestorInventario.java` protegido, y `GestorInventario_roto.java.txt` conservado.
2. `evidencias/carrera_resuelta.txt` con las cinco corridas.

3. En `BITACORA.md`, bajo `### Antes de la clase`, la tabla del antes y el después:

   | Corrida | Antes: confirmadas | Antes: final | Después: confirmadas | Después: final |
   |---|---|---|---|---|
   | 1 | | | | |
   | 2 | | | | |
   | 3 | | | | |
   | 4 | | | | |
   | 5 | | | | |

   Y debajo:

   - **Dónde empieza y dónde termina tu sección crítica**, con el código pegado, y qué habría pasado si hubieras protegido solo el descuento.
   - **Por qué el resultado ahora es el mismo las cinco veces.** Lo que hay que decir es qué dejó de poder ocurrir.
   - **Si tu método `cargarDesde` necesita `synchronized` o no**, con tu razonamiento. (Pista: piensa cuándo se llama y si en ese momento hay más de un hilo.)

```bash
git add .
git commit -m "s06 bloque 2: inventario protegido con exclusion mutua"
git push
```

---

### Bloque extra: cuánto cuesta el candado {#bloque-extra}

Opcional. Los candados no son gratis, y saber cuánto cuestan es lo que separa a quien los usa de quien los usa bien.

Cuando un hilo se topa con un candado ocupado, el SO lo bloquea, lo saca del procesador, y más tarde lo despierta. Eso son dos cambios de contexto por cada vez que hay competencia. Si tu sección crítica es corta, **puedes gastar más tiempo administrando el candado que trabajando dentro de él**.

Vamos a medirlo. Primero quita el `Thread.sleep(1)` de `vender` en las dos versiones, porque un milisegundo artificial tapa cualquier medición real. Después haz una prueba de rendimiento:

```java
// PruebaRendimiento.java - cuanto tarda en atender N ventas
public class PruebaRendimiento {

    public static void main(String[] args) throws InterruptedException {

        int cajeros = Integer.parseInt(args[0]);
        int ventasPorCajero = 1000;

        GestorInventario inv = new GestorInventario();
        inv.agregar("prueba", cajeros * ventasPorCajero);

        Thread[] hilos = new Thread[cajeros];
        for (int i = 0; i < cajeros; i++) {
            hilos[i] = new Thread(() -> {
                for (int j = 0; j < ventasPorCajero; j++) {
                    inv.vender("prueba", 1);
                }
            });
        }

        long inicio = System.nanoTime();
        for (Thread h : hilos) h.start();
        for (Thread h : hilos) h.join();
        long fin = System.nanoTime();

        long ms = (fin - inicio) / 1_000_000;
        int total = cajeros * ventasPorCajero;
        System.out.println("hilos=" + cajeros + "  ventas=" + total
                + "  tiempo=" + ms + " ms"
                + "  throughput=" + (total * 1000L / Math.max(ms, 1)) + " ventas/s");
    }
}
```

Córrelo con las dos versiones del gestor y varios números de hilos:

```bash
for h in 1 2 4 8 16 32; do java PruebaRendimiento $h; done
```

Llena la tabla:

| Hilos | Sin `synchronized` (ventas/s) | Con `synchronized` (ventas/s) | Cuánto se perdió |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 4 | | | |
| 8 | | | |
| 16 | | | |
| 32 | | | |

Tres cosas que vas a ver y que hay que explicar en la bitácora:

1. **Con 1 hilo casi no hay diferencia.** Adquirir un candado que nadie disputa es baratísimo. El costo aparece con la competencia, no con el candado.
2. **La versión protegida no escala.** Al subir hilos, el throughput se estanca o **baja**. Con el candado, tu inventario atiende de uno en uno pase lo que pase: agregar hilos solo agrega gente formada.
3. **La versión sin candado sube y da resultados incorrectos.** Es rápida y está mal. Es más rápido no hacer el trabajo bien.

Y la pregunta de diseño, que es real y no tiene respuesta única: si el candado te limita a un hilo a la vez, **cómo hace un sistema de verdad para atender a 500 cajeros?** Piensa en qué pasaría si en vez de un candado para todo el inventario tuvieras **un candado por producto**. Anota tu propuesta: es la idea de granularidad del candado, y en la semana 7 vas a ver el problema nuevo que trae.

```bash
git add .
git commit -m "s06 extra: costo del candado medido"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu inventario arreglado y las dos evidencias. Hoy comprobamos que de verdad quedó, y rompemos la solución de tres formas distintas.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. El pizarrón, otra vez

Mismas tres columnas que la semana pasada: cajeros, existencia inicial, existencia final. Ahora **todo el grupo tiene el mismo resultado**, en todas las máquinas, en todas las corridas.

Esa uniformidad es el punto. La semana pasada 15 máquinas dieron 15 respuestas; hoy dan una. Vale la pena decir en voz alta lo que significa: **el programa dejó de depender del orden en que el SO decida intercalar**, que era justo lo que no controlábamos.

#### 2. El candado mal puesto

Ahora vamos a romperlo a propósito, con el error que se comete de verdad. Quita el `synchronized` del método y protege **solo el descuento**:

```java
public boolean vender(String producto, int cantidad) {

    Integer disponible = existencias.get(producto);
    if (disponible == null) return false;

    if (disponible >= cantidad) {
        try { Thread.sleep(1); } catch (InterruptedException e) { }

        synchronized (this) {                       // candado solo aqui
            existencias.put(producto, disponible - cantidad);
            ventasConfirmadas++;
        }
        return true;
    }
    ventasRechazadas++;
    return false;
}
```

Corre `PruebaCarrera` con 50 cajeros y 10 piezas.

**Vuelve a fallar.** Y falla de la peor manera: la existencia queda **negativa**, porque los 50 hilos pasaron el `if` con el mismo valor y después los 50 descontaron, uno por uno, muy ordenaditos.

La conversación que sale: hay un candado, el código se ve sincronizado, cualquiera diría que está protegido. Y está mal. **Un candado en el lugar equivocado no protege menos: no protege nada**, y encima da una falsa sensación de seguridad. Escribe en tu bitácora la regla que sale de aquí: la sección crítica empieza donde se **lee** el dato con el que se va a decidir, no donde se escribe.

#### 3. El candado demasiado grande

El error opuesto. Pon `synchronized` en el método `atender` completo de tu `ServidorPedidos`, es decir, protege todo el trabajo del hilo y no solo el inventario:

```java
static synchronized void atender(String linea, int numero) {
```

Corre 10 pedidos con el `Thread.sleep(2000)` de la semana 4 puesto.

Los resultados son correctos, y el servidor tarda **20 segundos** en vez de 2. Acabas de deshacer toda la semana 4: si solo un hilo puede estar dentro de `atender`, tu servidor volvió a ser secuencial. Con más pasos y más candados, pero secuencial.

De aquí sale el criterio de diseño de toda la unidad, y conviene escribirlo tal cual: **la sección crítica tiene que ser lo más chica posible, pero no más chica que el conjunto de operaciones que tienen que ocurrir juntas.**

#### 4. El semáforo que cuenta

Para quien tiene un dominio con recursos que se ocupan y se liberan (consultorios, técnicos, cajones, herramientas), y como demostración para todos:

```java
// tres consultorios, tres permisos
Semaphore consultorios = new Semaphore(3);

// dentro del hilo que atiende:
consultorios.acquire();
try {
    registrar("entro a consultorio, libres: " + consultorios.availablePermits());
    Thread.sleep(2000);
} finally {
    consultorios.release();
}
```

Lanza 10 pedidos y mira el log: entran de tres en tres. Los otros siete no están dando vueltas, **están bloqueados**. Compruébalo:

```bash
ps -o pid,nlwp,stat,%cpu -C java
```

Diez hilos vivos y el `%CPU` cercano a cero. Ahí está, otra vez, la diferencia entre esperar bien y esperar mal.

#### 5. La grieta de la semana que viene

Cerramos plantando el problema siguiente. Dos hilos, dos candados:

```
Hilo A: toma el candado del inventario, y luego necesita el del log
Hilo B: toma el candado del log,       y luego necesita el del inventario
```

Dibújalo en tu bitácora y contesta: **qué pasa?** Ninguno de los dos suelta lo que tiene. Ninguno de los dos puede seguir. Y a diferencia de la condición de carrera, aquí el programa no da un número raro: **se queda quieto para siempre**.

Eso es un interbloqueo, y es la semana 7.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu `GestorInventario` protegido y correcto**, con la sección crítica completa. Verifica con `PruebaCarrera` que cuadra las cinco veces, y con carga alta (50 cajeros, 10 piezas).

2. **Corre tu servidor completo con carga** y comprueba que ahora el resumen final cuadra:

   ```bash
   java GeneradorPedidos 200 | java ServidorPedidos > evidencias/servidor_protegido.txt 2>&1
   ```

   La existencia inicial menos lo confirmado tiene que ser igual a la existencia final, para cada producto.

3. **Si tu dominio tiene un recurso que se ocupa y se libera**, modélalo con un `Semaphore(N)`. Es el caso más interesante para la revisión y el que mejor se defiende en las preguntas.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es la exclusión mutua y qué tres propiedades tiene que cumplir una solución.
   - Cuál mecanismo elegiste, dónde exactamente lo pusiste y por qué ahí.
   - El antes y el después de tus corridas, con los números.
   - Qué pasó cuando pusiste el candado mal (los dos casos: demasiado chico y demasiado grande) y qué regla sacaste de cada uno.

   ```bash
   git add .
   git commit -m "s06 proyecto: inventario con exclusion mutua"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Este es el avance más importante del integrador hasta ahora, porque se acerca la revisión de la semana 9.

1. **Unifiquen el mecanismo de sincronización del equipo.** Las tres sucursales tienen que usar el mismo criterio, y tiene que estar escrito en el README: qué se protege, con qué, y dónde empieza y termina cada sección crítica.

2. **Identifiquen las secciones críticas del Servidor Central.** Si el central recibe pedidos de tres sucursales a la vez, todo lo que compartan esos hilos es sección crítica: el registro de pedidos, los contadores globales, cualquier caché.

3. **Preparen la demostración para la revisión de la semana 9.** Tiene que ser: aquí está la evidencia del sistema roto, aquí la del sistema arreglado, y aquí la explicación de por qué el arreglo funciona. Las tres cosas, con archivos en el repositorio. Es lo que más peso tiene en las evidencias de esa revisión.
