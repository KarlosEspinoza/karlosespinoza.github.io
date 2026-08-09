---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 7 - Bloqueos y sincronización (U2)

La semana pasada resolviste la condición de carrera con candados, y al final planteamos el problema que traen los candados consigo: dos hilos, cada uno con lo que el otro necesita, esperándose para siempre. Esta semana lo vas a provocar en tu propio servidor y, más importante, vas a aprender a **diagnosticarlo con la máquina en la mano**.

Ese último punto es el que vale para tu carrera. Un interbloqueo no imprime un error, no lanza una excepción, no escribe nada en el log: el servidor simplemente **deja de responder** y todo se ve normal desde fuera. Al terminar la semana vas a poder tomar un proceso Java colgado, sacarle una radiografía y señalar con el dedo qué hilo tiene qué candado y a quién está esperando.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: las cuatro condiciones de Coffman](#bloque-1)
    - [Bloque 2: provoca el bloqueo y diagnostícalo](#bloque-2)
    - [Bloque extra: tryLock con tiempo límite](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes las cuatro condiciones y las traduces a tu dominio | Tu tabla de Coffman y tu escenario de bloqueo |
| 2 | Provocas el interbloqueo y lo diagnosticas con `jstack` | `src/PruebaBloqueo.java` y `evidencias/deadlock.txt` |
| Extra | Lo evitas con `tryLock` y tiempo límite | La comparación de las dos estrategias |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: las cuatro condiciones de Coffman {#bloque-1}

#### Qué es un interbloqueo

Un **interbloqueo** (o *deadlock*, o abrazo mortal) es una situación en la que un conjunto de hilos o procesos está esperando, cada uno, por un recurso que tiene otro del mismo conjunto. Ninguno puede avanzar y ninguno va a soltar lo que tiene, porque para soltarlo necesita terminar, y para terminar necesita lo que no le van a dar.

El ejemplo clásico son dos coches en un puente de un solo carril, cada uno desde una orilla. Ninguno puede pasar y ninguno quiere retroceder.

En tu servidor se ve así:

```
Hilo A (pedido 1)                    Hilo B (pedido 2)
-----------------                    -----------------
toma el candado del INVENTARIO       toma el candado del LOG
   ...                                  ...
pide el candado del LOG              pide el candado del INVENTARIO
   -> bloqueado                         -> bloqueado
```

Los dos quedan en estado bloqueado. Para siempre.

Lo que hace a este error distinto de todos los anteriores es cómo se manifiesta: **no hay síntoma**. El proceso sigue vivo, `ps` lo muestra normal, no consume CPU (los hilos están bloqueados, así que 0%), no hay excepción ni línea en el log. Simplemente los cajeros dejan de recibir respuesta. Diagnosticarlo desde fuera, sin herramientas, es prácticamente imposible.

#### Las cuatro condiciones

En 1971, Edward Coffman demostró algo muy útil: un interbloqueo **solo puede ocurrir si se cumplen cuatro condiciones a la vez**. Si rompes una sola, es imposible que ocurra. Esa es la base de todas las estrategias de prevención.

| # | Condición | Qué significa | En tu servidor |
|---|---|---|---|
| 1 | **Exclusión mutua** | El recurso no se puede compartir: o lo tiene uno, o lo tiene otro | El candado del inventario. Es lo que agregaste la semana pasada |
| 2 | **Retención y espera** | Un hilo que ya tiene un recurso pide otro sin soltar el primero | El hilo tiene el inventario y pide el log sin soltar el inventario |
| 3 | **Sin expropiación** | No se le puede quitar el recurso por la fuerza; solo lo suelta quien lo tiene, cuando quiere | El SO no le puede arrebatar un `synchronized` a un hilo |
| 4 | **Espera circular** | Existe un ciclo: A espera a B, B espera a C, C espera a A | A espera el log que tiene B, B espera el inventario que tiene A |

Las cuatro tienen que cumplirse **simultáneamente**. Si falta una, no hay interbloqueo posible.

#### Cómo se rompe cada una

Aquí está lo práctico, y también por qué en la vida real casi siempre se ataca la cuarta:

| Condición | Cómo se rompería | Por qué casi nunca se hace |
|---|---|---|
| 1. Exclusión mutua | No usar candados | Vuelves a la semana 5. No es opción |
| 2. Retención y espera | Pedir **todos** los recursos de golpe al inicio, o ninguno | Difícil de saber por adelantado, y desperdicia recursos que tienes tomados sin usar |
| 3. Sin expropiación | Quitarle el candado a un hilo por la fuerza | Lo dejarías a media sección crítica, con los datos inconsistentes. Peor el remedio |
| 4. **Espera circular** | **Que todos pidan los candados en el mismo orden** | **Esta es la buena.** Es fácil, es barata y no cuesta rendimiento |

La solución de la cuarta merece que te detengas, porque es la que vas a usar y es sorprendentemente simple: **numera tus recursos y exige que todos los hilos los pidan en orden creciente**.

Si el inventario es el recurso 1 y el log es el 2, entonces todo hilo que necesite los dos pide primero el 1 y luego el 2. Nunca al revés. Con esa sola regla el ciclo se vuelve imposible: para que hubiera ciclo, alguien tendría que pedir el 1 teniendo el 2, y eso está prohibido.

No hace falta que el orden sea lógico ni que signifique algo. Solo que sea **el mismo para todos**.

#### Prevenir, evitar, detectar

Las tres estrategias que existen, para que sepas de qué se habla cuando alguien las menciona:

- **Prevención:** diseñar el sistema de modo que una de las cuatro condiciones no se pueda cumplir nunca. Es lo que hace el orden global de candados. Es lo que vas a hacer tú.
- **Evitación:** decidir en tiempo de ejecución si conceder un recurso, calculando si eso podría llevar a un estado inseguro. El algoritmo clásico es el del **banquero**, de Dijkstra. Se estudia siempre y se usa casi nunca: necesita saber por adelantado cuántos recursos va a pedir cada proceso, cosa que en la práctica no se sabe.
- **Detección y recuperación:** dejar que ocurra, detectarlo, y matar a alguien para romper el ciclo. Es lo que hacen las bases de datos: si dos transacciones se bloquean, el gestor elige una **víctima**, la aborta y la reintenta. Si alguna vez viste un error de "deadlock detected, transaction rolled back" en MySQL o PostgreSQL, era exactamente esto.

Linux, para los procesos normales, **no hace nada de esto**. No detecta interbloqueos entre tus hilos ni te avisa. Si tu servidor se traba, se queda trabado hasta que alguien lo mate. Por eso la parte de diagnóstico del bloque 2 es tan importante.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **Tu escenario de interbloqueo, en tu dominio.** Escribe dos hilos concretos de **tu** servidor (dos pedidos, o un pedido y una consulta) y dos recursos concretos de tu sistema que se puedan pedir en orden cruzado. Descríbelo con el formato de arriba, paso por paso.

2. **La tabla de Coffman aplicada a tu escenario:**

   | Condición | Se cumple en mi escenario? Por qué |
   |---|---|
   | Exclusión mutua | |
   | Retención y espera | |
   | Sin expropiación | |
   | Espera circular | |

3. **Tu orden global de recursos.** Haz la lista numerada de todos los recursos de tu servidor que puedan estar bajo candado (inventario, log, contadores, archivo de recibos, lo que tengas), en un orden fijo, y escribe la regla que vas a seguir. Esa lista la vas a usar el resto del semestre, así que déjala completa.

```bash
git add .
git commit -m "s07 bloque 1: condiciones de Coffman y orden de recursos"
git push
```

---

### Bloque 2: provoca el bloqueo y diagnostícalo {#bloque-2}

Ahora lo provocas. En este bloque el objetivo **es** que tu programa se cuelgue.

#### El programa que se traba

Crea `src/PruebaBloqueo.java`:

```java
// PruebaBloqueo.java - dos hilos que se abrazan hasta morir
public class PruebaBloqueo {

    // Dos recursos distintos. En tu servidor serian el inventario y el log.
    static final Object INVENTARIO = new Object();
    static final Object LOG = new Object();

    public static void main(String[] args) {

        System.out.println("PID " + ProcessHandle.current().pid());

        Thread cajero1 = new Thread(() -> {
            synchronized (INVENTARIO) {
                System.out.println("cajero-1: tomo INVENTARIO");
                dormir(500);                       // le doy tiempo al otro
                System.out.println("cajero-1: quiero LOG");
                synchronized (LOG) {
                    System.out.println("cajero-1: tengo los dos");
                }
            }
        }, "cajero-1");

        Thread cajero2 = new Thread(() -> {
            synchronized (LOG) {                   // orden INVERTIDO a proposito
                System.out.println("cajero-2: tomo LOG");
                dormir(500);
                System.out.println("cajero-2: quiero INVENTARIO");
                synchronized (INVENTARIO) {
                    System.out.println("cajero-2: tengo los dos");
                }
            }
        }, "cajero-2");

        cajero1.start();
        cajero2.start();

        System.out.println("Los dos hilos arrancaron. Si no ves 'tengo los dos', hay bloqueo.");
    }

    static void dormir(long ms) {
        try { Thread.sleep(ms); } catch (InterruptedException e) { }
    }
}
```

Ese `dormir(500)` es lo que hace que el bloqueo ocurra **siempre** en vez de a veces. Sin él, es probable que el primer hilo alcance a tomar los dos candados antes de que el segundo empiece, y el programa termine bien. Con la pausa, garantizas que los dos tengan uno cada quien antes de pedir el segundo. Es la misma técnica de ensanchar la ventana que usaste en la semana 5.

Córrelo:

```bash
cd ~/so-proyecto/src
javac PruebaBloqueo.java
java PruebaBloqueo
```

Vas a ver cuatro líneas y después **nada**. El programa no termina, no da error, no vuelve al prompt. Está trabado. Déjalo así: lo vamos a diagnosticar vivo.

#### Míralo desde fuera, primero sin herramientas

Desde otra terminal, con el PID que imprimió:

```bash
ps -o pid,nlwp,stat,%cpu,%mem,etime,cmd -p TU_PID
```

```
    PID NLWP STAT %CPU %MEM     ELAPSED CMD
   1204   21 Sl    0.0  1.1       02:31 java PruebaBloqueo
```

Y aquí está el problema de este error, hecho evidente: **todo se ve perfectamente sano**. Estado `S`, 0% de CPU, memoria normal, el proceso vivo desde hace dos minutos. Exactamente igual que tu servidor bien portado de la semana 2 esperando pedidos.

Un servidor trabado y un servidor ocioso **son indistinguibles desde `ps`**. Ese es el punto que hay que llevarse.

#### La radiografía: `jstack`

`jstack` viene con el JDK y hace algo muy útil: le pide a una JVM viva que reporte **qué está haciendo cada uno de sus hilos en este instante**, con su pila de llamadas y sus candados.

```bash
jstack TU_PID
```

Es larga. Ve directo a las dos partes que importan.

**Primero, tus hilos.** Busca los que nombraste:

```
"cajero-1" #21 prio=5 os_prio=0 tid=0x... nid=0x4b5 waiting for monitor entry
   java.lang.Thread.State: BLOCKED (on object monitor)
        at PruebaBloqueo.lambda$main$0(PruebaBloqueo.java:18)
        - waiting to lock <0x00000000ffd2a1c8> (a java.lang.Object)
        - locked <0x00000000ffd2a1b8> (a java.lang.Object)

"cajero-2" #22 prio=5 os_prio=0 tid=0x... nid=0x4b6 waiting for monitor entry
   java.lang.Thread.State: BLOCKED (on object monitor)
        at PruebaBloqueo.lambda$main$1(PruebaBloqueo.java:30)
        - waiting to lock <0x00000000ffd2a1b8> (a java.lang.Object)
        - locked <0x00000000ffd2a1c8> (a java.lang.Object)
```

Léelo despacio, porque esto es lo que vas a saber hacer al terminar la semana:

- `BLOCKED (on object monitor)`: el hilo está bloqueado esperando un candado.
- `locked <0x...ffd2a1b8>`: el candado que **ya tiene**.
- `waiting to lock <0x...ffd2a1c8>`: el candado que **está esperando**.

Y ahora cruza los números. El `cajero-1` tiene el `...1b8` y espera el `...1c8`. El `cajero-2` tiene el `...1c8` y espera el `...1b8`. **Ahí está el ciclo, con nombres y direcciones.** Esa es la espera circular de Coffman, hecha visible.

**Segundo, el diagnóstico automático.** Al final de la salida, `jstack` te lo dice directamente:

```
Found one Java-level deadlock:
=============================
"cajero-1":
  waiting to lock monitor 0x00007f..., which is held by "cajero-2"
"cajero-2":
  waiting to lock monitor 0x00007f..., which is held by "cajero-1"

Found 1 deadlock.
```

La JVM detecta los interbloqueos entre monitores y te los reporta con nombre y apellido. Por eso vale la pena que **le pongas nombre a tus hilos** con `setName`: en esta salida, `cajero-1` es infinitamente más útil que `Thread-0`.

#### Guarda la evidencia

```bash
cd ~/so-proyecto
jstack TU_PID > evidencias/deadlock.txt 2>&1
grep -A 12 "Found one Java-level deadlock" evidencias/deadlock.txt
```

Y para matarlo, porque no se va a ir solo:

```bash
kill -9 TU_PID
```

Ese `-9` es lo único que lo mata. Un `kill` normal no funciona aquí, y en la semana 8 vas a entender por qué.

#### Arréglalo

Ahora aplica tu orden global del bloque 1. Cambia el `cajero-2` para que pida los candados **en el mismo orden** que el `cajero-1`:

```java
synchronized (INVENTARIO) {
    System.out.println("cajero-2: tomo INVENTARIO");
    dormir(500);
    synchronized (LOG) {
        System.out.println("cajero-2: tengo los dos");
    }
}
```

Corre otra vez. Ahora los dos terminan. Uno espera al otro un momento, pero **ninguno espera para siempre**, porque el ciclo ya no puede formarse.

**Lo que entregas de este bloque**

1. `src/PruebaBloqueo.java` con los dos recursos nombrados según **tu** dominio.
2. `evidencias/deadlock.txt` con la salida completa de `jstack`, incluyendo la sección `Found one Java-level deadlock`.

3. En `BITACORA.md`, bajo `### Antes de la clase`:
   - **Las cuatro líneas de `jstack` que prueban el ciclo**, pegadas, con tu explicación de qué dice cada `locked` y cada `waiting to lock` y cómo se cierra el ciclo.
   - **Por qué `ps` no sirve para detectar esto.** Pega tu salida de `ps` del proceso trabado y explica por qué se ve idéntica a la de un servidor sano.
   - **Cuál de las cuatro condiciones rompiste** al arreglarlo, y por qué elegiste esa y no otra.

```bash
git add .
git commit -m "s07 bloque 2: interbloqueo provocado y diagnosticado"
git push
```

---

### Bloque extra: tryLock con tiempo límite {#bloque-extra}

Opcional. El orden global previene el interbloqueo, pero tiene un límite: solo funciona si **tú controlas todo el código**. En un sistema grande, con bibliotecas de terceros que toman sus propios candados, no siempre puedes garantizar el orden.

Para esos casos existe otra herramienta: en vez de pedir el candado y bloquearte para siempre, **lo intentas con un tiempo límite**, y si no lo consigues, sueltas lo que tienes y reintentas.

Eso `synchronized` no lo sabe hacer. Hace falta `ReentrantLock`:

```java
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.TimeUnit;

static final ReentrantLock INVENTARIO = new ReentrantLock();
static final ReentrantLock LOG = new ReentrantLock();

static boolean intentarLosDos(String quien) throws InterruptedException {

    if (!INVENTARIO.tryLock(200, TimeUnit.MILLISECONDS)) {
        return false;
    }
    try {
        if (!LOG.tryLock(200, TimeUnit.MILLISECONDS)) {
            return false;              // el finally suelta INVENTARIO
        }
        try {
            System.out.println(quien + ": tengo los dos");
            return true;
        } finally {
            LOG.unlock();
        }
    } finally {
        INVENTARIO.unlock();
    }
}
```

Y el hilo reintenta hasta lograrlo:

```java
int intentos = 0;
while (!intentarLosDos(nombre)) {
    intentos++;
    System.out.println(nombre + ": no pude, reintento " + intentos);
    Thread.sleep((long) (Math.random() * 100));   // espera aleatoria
}
```

Dos detalles que no son decorativos:

- **Los `finally` son obligatorios.** Con `ReentrantLock` el candado no se suelta solo al salir del bloque, como pasaba con `synchronized`. Si te saltas un `unlock`, dejaste el candado tomado para siempre y acabas de crear un problema peor que el que querías resolver.
- **La espera aleatoria** antes de reintentar. Si los dos hilos reintentan exactamente al mismo tiempo, vuelven a chocar exactamente igual, y pueden quedarse rebotando indefinidamente. Eso se llama **livelock**: no están bloqueados, están trabajando muchísimo, y aun así ninguno avanza. Es peor que un deadlock porque además consume CPU. Un retardo aleatorio los desincroniza.

Compara las dos estrategias en tu bitácora:

| | Orden global de candados | `tryLock` con timeout |
|---|---|---|
| Previene o detecta? | | |
| Qué pasa cuando hay competencia | | |
| Costo en rendimiento | | |
| Funciona con código de terceros? | | |
| Qué problema nuevo introduce | | |

```bash
git add .
git commit -m "s07 extra: tryLock con timeout y livelock"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu interbloqueo provocado y tu `jstack` guardado. Hoy diagnosticamos a ciegas, que es como pasa en el trabajo.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. Diagnóstico a ciegas

La actividad central de la semana. Se hace en parejas.

Cada quien modifica su `PruebaBloqueo.java` para que se trabe **de una forma distinta**, elegida entre estas tres:

1. Dos hilos, dos candados, orden cruzado (el clásico).
2. **Tres** hilos y tres candados en ciclo: A espera a B, B espera a C, C espera a A.
3. Un hilo que se traba consigo mismo intentando tomar dos veces un `ReentrantLock` no reentrante... o mejor, un hilo que hace `join()` sobre otro hilo que a su vez hace `join()` sobre el primero.

Después intercambian máquinas. **Tu compañero no te dice cuál eligió.** Tú tienes que:

```bash
ps -C java -o pid=            # encontrar el proceso
jstack PID > /tmp/diag.txt    # sacar la radiografía
grep -A 20 "deadlock" /tmp/diag.txt
```

Y contestar tres cosas: **cuántos hilos están en el ciclo, qué candado tiene cada uno, y en qué línea del código está trabado cada uno.**

Escribe tu diagnóstico antes de que te digan la respuesta. Eso es exactamente lo que vas a hacer el día que te toque un servidor colgado en producción.

#### 2. El interbloqueo realista

El caso de arriba es didáctico y un poco artificial: nadie escribe dos hilos con los candados al revés a propósito. Vamos a ver el que sí pasa de verdad.

Agrega a tu `GestorInventario` un método para mover existencias entre dos productos, con un candado por producto:

```java
// Un candado por producto. Mas paralelismo... y un problema nuevo.
private Map<String, Object> candados = new HashMap<>();

public boolean transferir(String desde, String hacia, int cantidad) {
    synchronized (candados.get(desde)) {
        synchronized (candados.get(hacia)) {
            // mover cantidad de un producto a otro
            return true;
        }
    }
}
```

Se ve razonable y es **exactamente** lo que sugirió el bloque extra de la semana 6 para ganar paralelismo. Ahora lanza dos hilos:

```java
new Thread(() -> inv.transferir("paracetamol", "ibuprofeno", 5)).start();
new Thread(() -> inv.transferir("ibuprofeno", "paracetamol", 3)).start();
```

Bloqueo. Y aquí nadie invirtió el orden a propósito: **el orden lo pusieron los datos**. Este es el interbloqueo que de verdad ocurre en producción, y es el mismo que tienen las transferencias entre cuentas en un banco.

La solución, entre todos en el pizarrón: cómo se impone un orden global cuando los recursos son datos y no variables? La respuesta es ordenar por algo que los datos ya tengan, por ejemplo el nombre del producto:

```java
String primero = desde.compareTo(hacia) < 0 ? desde : hacia;
String segundo = desde.compareTo(hacia) < 0 ? hacia : desde;
synchronized (candados.get(primero)) {
    synchronized (candados.get(segundo)) {
```

Da igual qué orden sea mientras sea **el mismo para todos**. Ese truco vale una pregunta de entrevista de trabajo.

#### 3. Por qué `kill` normal no lo mata

Prueba, con tu proceso trabado:

```bash
kill TU_PID          # no pasa nada
kill -9 TU_PID       # muere
```

Deja la observación anotada y sin resolver: **por qué uno funciona y el otro no?** La respuesta es la semana que viene, y tiene que ver con que el primero es una petición educada que alguien tiene que atender, y no hay nadie disponible para atenderla.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja `src/PruebaBloqueo.java` en tu repositorio**, con el bloqueo provocado a propósito y con tus dos recursos nombrados según tu dominio. Es evidencia, no es un error: coméntalo así en el código.

2. **Documenta tu orden global de candados** en el README de tu proyecto, con la lista numerada. Es una decisión de diseño y tiene que estar visible, no escondida en un comentario.

3. **Revisa tu servidor real buscando el riesgo.** Si en tu `atender` tomas más de un candado (inventario y log, o inventario y contadores), verifica que siempre los tomas en el orden de tu lista. Si solo tomas uno, dilo explícitamente en la bitácora: no tener el problema también es un resultado, siempre que lo hayas comprobado.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es un interbloqueo y las cuatro condiciones, con tu escenario de tu dominio.
   - Cómo se diagnostica: los comandos exactos y qué buscar en la salida.
   - Cuál condición decidiste romper en tu sistema y con qué mecanismo concreto.
   - Por qué un servidor trabado y uno ocioso se ven iguales en `ps`, con tus dos salidas pegadas.

   ```bash
   git add .
   git commit -m "s07 proyecto: prevencion de interbloqueos"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

La revisión de la semana 9 está a dos semanas. Este es el momento de cerrar la Unidad 2.

1. **Acuerden el orden global de candados del equipo** y déjenlo en el README, numerado. Todas las sucursales y el Servidor Central tienen que respetarlo. Es la clase de acuerdo que si no se escribe, no existe.

2. **Provoquen un interbloqueo entre dos componentes del equipo** (una sucursal y el central, por ejemplo) y guarden el `jstack` como evidencia. Después arréglenlo y guarden el segundo `jstack` limpio. El antes y el después es lo que se evalúa.

3. **Preparen el guion de la demostración de la semana 9.** Tienen tres cosas que enseñar en pocos minutos: el sistema con la condición de carrera, el sistema arreglado, y el interbloqueo diagnosticado. Ensáyenlo: en la revisión el tiempo es corto y una demo que no arranca cuesta caro.
