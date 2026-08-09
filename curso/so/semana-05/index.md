---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 5 - Condición de carrera (U2)

La semana pasada tu servidor sumó uno mil veces y no le dio mil. Esta semana vas a entender exactamente por qué, y no con una explicación general: vas a poder señalar **la instrucción concreta** donde se pierde el dato y **el instante** en que se pierde.

Esto no es una curiosidad académica. Es el error más caro que existe en el software de servidores, y es caro por una razón particular: **no falla siempre**. Falla una de cada mil veces, en producción, con carga, y nunca cuando lo estás observando. Al terminar la semana vas a tener en tu proyecto un inventario que se descuadra de verdad, con la evidencia de tus propias corridas, y esa es la mitad del examen de la Unidad 2.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: la sección crítica, a mano](#bloque-1)
    - [Bloque 2: rompe tu inventario](#bloque-2)
    - [Bloque extra: hacer que falle siempre](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Trazas a mano el intercalado que pierde el dato | Tu tabla de intercalado y tu peor caso |
| 2 | Escribes tu inventario y lo rompes, cinco veces | `src/GestorInventario.java`, `src/PruebaCarrera.java`, `evidencias/carrera.txt` |
| Extra | Buscas la configuración que falla el 100% de las veces | Tu tabla de hilos contra tasa de fallo |

Esta semana el bloque 2 sí corre, y **tiene que correr varias veces**: el fenómeno no se ve en una sola ejecución. Es el punto del ejercicio.

Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: la sección crítica, a mano {#bloque-1}

#### Una línea que no es una línea

Este es el centro de todo. En tu servidor tienes algo así:

```java
existencia = existencia - 1;
```

Se ve atómica: una instrucción, una asignación. **No lo es.** El procesador no sabe restar directamente sobre la memoria; tiene que traerse el valor, operarlo y devolverlo. Esa línea son en realidad **tres pasos**:

```
1. LEER      traer el valor de existencia de la memoria a un registro
2. RESTAR    calcular valor - 1 en el registro
3. ESCRIBIR  guardar el resultado de vuelta en la memoria
```

Y ahora recuerda la semana 4: el SO puede **interrumpir a un hilo entre cualquier par de instrucciones** y darle el procesador a otro. No espera a que termines tu línea de Java. No sabe siquiera que existe tu línea de Java.

#### El intercalado que pierde el dato

Dos cajeros piden el mismo producto. Quedan 10 piezas. Los dos hilos ejecutan `existencia = existencia - 1`. Sigue esto renglón por renglón:

| Instante | Hilo A (cajero 1) | Hilo B (cajero 2) | Valor en memoria |
|---|---|---|---|
| 1 | LEE existencia -> 10 | | 10 |
| 2 | | LEE existencia -> 10 | 10 |
| 3 | RESTA -> 9 (en su registro) | | 10 |
| 4 | | RESTA -> 9 (en su registro) | 10 |
| 5 | ESCRIBE 9 | | **9** |
| 6 | | ESCRIBE 9 | **9** |

**Se vendieron dos piezas y el inventario bajó una.** Nadie se equivocó, ningún código está mal escrito, no hay un bug de lógica. El problema es que la operación completa **no se ejecutó de un tirón**.

Lo que hizo el daño está en los instantes 1 y 2: el hilo B leyó un valor que **ya estaba obsoleto**, porque A iba a cambiarlo pero todavía no lo había escrito. B tomó una decisión con información vieja.

Esto se llama **condición de carrera**: el resultado del programa depende de en qué orden se intercalen los hilos, y ese orden lo decide el SO, no tú. Como el SO decide distinto cada vez, **el mismo programa con los mismos datos da resultados distintos en cada ejecución**.

#### La sección crítica

Al pedazo de código donde ocurre el problema se le llama **sección crítica**: el fragmento que toca un recurso compartido y que **no debe ejecutarse por dos hilos a la vez**.

Cuidado con esto, porque es donde se equivoca casi todo el mundo: la sección crítica **no es siempre una línea**. Mira esta versión, que es la que de verdad vas a tener en tu servidor:

```java
if (existencia >= cantidad) {      // (1) consulto
    existencia = existencia - cantidad;   // (2) descuento
    return true;                   // (3) confirmo la venta
}
return false;
```

Aquí el problema es peor y más realista. Los dos hilos pueden pasar la comprobación (1) cuando queda **una sola pieza**, porque los dos leen "1 >= 1" y los dos entran. Después los dos descuentan, y el inventario queda en **-1**: vendiste una pieza que no tenías.

O sea: la sección crítica va **desde la consulta hasta el descuento**. Si proteges solo el descuento y dejas la consulta fuera, el error sigue ahí. Guárdate esa frase, porque la semana que viene, cuando pongas el candado, es exactamente el error que vas a estar tentado a cometer.

#### Por qué es tan difícil de atrapar

Tres razones, y vale la pena que las tengas claras porque explican por qué este tema ocupa tres semanas del curso:

- **No es determinista.** El mismo programa, los mismos datos, resultados distintos. No puedes depurarlo corriéndolo otra vez.
- **La ventana es diminuta.** Entre el LEER y el ESCRIBIR hay nanosegundos. La probabilidad de que el SO interrumpa justo ahí es baja... con dos hilos. Con doscientos y con carga, deja de ser baja.
- **Depende de la máquina.** En tu laptop con 8 núcleos y sin carga puede no fallar nunca. En el servidor del cliente, con 200 cajeros, falla el martes a las 2 de la tarde. Y cuando vas a reproducirlo, no falla.

Por eso este error se descubre en producción, y por eso en una entrevista de trabajo para backend te lo van a preguntar.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **Tu propia tabla de intercalado.** Copia el formato de arriba, pero con **tu dominio** y con estos datos: quedan **3 unidades**, llega un pedido de 2 y otro de 2 **al mismo tiempo**. Traza los pasos de los dos hilos sobre el código de la consulta y el descuento (el de tres líneas), y muestra un intercalado que deje el inventario en un número imposible. Di cuál es ese número y por qué es imposible.

2. **Cuál es exactamente tu sección crítica.** Escribe el fragmento de código de tu servidor que no puede ejecutarse por dos hilos a la vez, y **justifica dónde empieza y dónde termina**. La justificación es lo que vale.

3. **El costo en tu negocio.** En una frase de cada una: qué le pasa a tu negocio si el inventario dice que tienes 3 y no tienes ninguno, y qué le pasa si dice que tienes 0 y en realidad tienes 3. Las dos son fallas, y no cuestan lo mismo.

```bash
git add .
git commit -m "s05 bloque 1: seccion critica e intercalado"
git push
```

---

### Bloque 2: rompe tu inventario {#bloque-2}

Ahora a reproducirlo. La meta de este bloque **no es que tu programa funcione**: es que falle, y que puedas demostrarlo con números.

#### El gestor de inventario

Crea `src/GestorInventario.java`. Esta es la clase que va a vivir el resto del semestre, así que vale la pena hacerla bien. Por ahora **sin ninguna protección**, a propósito:

```java
// GestorInventario.java - el inventario compartido, todavia SIN proteger
import java.util.HashMap;
import java.util.Map;

public class GestorInventario {

    // Este mapa lo van a tocar todos los hilos a la vez.
    private Map<String, Integer> existencias = new HashMap<>();

    // Contadores para poder auditar lo que paso.
    private int ventasConfirmadas = 0;
    private int ventasRechazadas = 0;

    public void agregar(String producto, int cantidad) {
        existencias.put(producto, cantidad);
    }

    // ESTA es la seccion critica del curso completo.
    public boolean vender(String producto, int cantidad) {

        Integer disponible = existencias.get(producto);
        if (disponible == null) return false;

        if (disponible >= cantidad) {

            // Esta pausa no cambia la logica: solo ensancha la ventana
            // para que el problema se vea sin necesidad de 10000 hilos.
            try { Thread.sleep(1); } catch (InterruptedException e) { }

            existencias.put(producto, disponible - cantidad);
            ventasConfirmadas++;
            return true;
        }

        ventasRechazadas++;
        return false;
    }

    public int existencia(String producto) {
        return existencias.getOrDefault(producto, 0);
    }

    public int getVentasConfirmadas() { return ventasConfirmadas; }
    public int getVentasRechazadas() { return ventasRechazadas; }

    // TODO: agrega un metodo cargarDesde(String archivo) que lea tu
    //       datos/catalogo.txt con el formato ID;NOMBRE;PRECIO;EXISTENCIA
    //       y llene el mapa. En la semana 13 lo vamos a instrumentar.
    //       pista: Files.readAllLines y split(";")
}
```

Ese `Thread.sleep(1)` en medio merece una explicación, porque es una trampa honesta. **No introduce el error**: el error ya está ahí sin él. Lo único que hace es alargar la ventana entre la consulta y el descuento, de nanosegundos a un milisegundo, para que el intercalado ocurra de forma visible en tu laptop en vez de una vez cada diez mil corridas. Es la técnica que se usa de verdad para reproducir estos fallos, y en la sesión vas a quitarlo para ver la diferencia.

#### La prueba

Crea `src/PruebaCarrera.java`. Este programa no es tu servidor: es un banco de pruebas que lanza muchos cajeros pidiendo el mismo producto a la vez.

```java
// PruebaCarrera.java - N cajeros peleando por el mismo producto
public class PruebaCarrera {

    public static void main(String[] args) throws InterruptedException {

        // TODO: cambia estos valores por un producto de TU catalogo
        String producto = "paracetamol";
        int existenciaInicial = 10;
        int cajeros = 10;

        GestorInventario inventario = new GestorInventario();
        inventario.agregar(producto, existenciaInicial);

        Thread[] hilos = new Thread[cajeros];

        // Cada cajero intenta comprar UNA pieza.
        for (int i = 0; i < cajeros; i++) {
            final int numero = i + 1;
            hilos[i] = new Thread(() -> {
                boolean vendido = inventario.vender(producto, 1);
                System.out.println("Cajero " + numero + ": "
                        + (vendido ? "VENDIDO" : "rechazado"));
            });
        }

        // Arrancan todos lo mas junto posible.
        for (Thread h : hilos) h.start();

        // Esperamos a que todos terminen antes de contar.
        for (Thread h : hilos) h.join();

        System.out.println("---------------------------------------");
        System.out.println("Existencia inicial:   " + existenciaInicial);
        System.out.println("Cajeros:              " + cajeros);
        System.out.println("Ventas confirmadas:   " + inventario.getVentasConfirmadas());
        System.out.println("Ventas rechazadas:    " + inventario.getVentasRechazadas());
        System.out.println("Existencia final:     " + inventario.existencia(producto));
        System.out.println("---------------------------------------");
        System.out.println("CUADRA? inicial - confirmadas == final ?  "
                + ((existenciaInicial - inventario.getVentasConfirmadas())
                    == inventario.existencia(producto)));
    }
}
```

`h.join()` es nuevo y es importante: hace que el hilo principal **espere** a que ese hilo termine. Sin eso, el `main` imprimiría el resumen antes de que los cajeros acabaran y los números no querrían decir nada. Es el equivalente para hilos del `waitFor()` que usaste con procesos en la semana 3.

#### Córrelo cinco veces

```bash
cd ~/so-proyecto/src
javac GestorInventario.java PruebaCarrera.java
```

Ahora, y esto es lo importante, **cinco corridas**, guardando todo:

```bash
cd ~/so-proyecto
for i in 1 2 3 4 5; do
  echo "===== CORRIDA $i ====="
  java -cp src PruebaCarrera
done > evidencias/carrera.txt 2>&1

cat evidencias/carrera.txt
```

Ese `for` de bash repite el comando cinco veces. Lo vas a usar el resto del semestre.

Lo que vas a ver, y tiene que verse: los números **no son los mismos en las cinco corridas**. En algunas cuadra, en otras no. En algunas se venden más piezas de las que había.

Si te cuadran las cinco, no está mal tu código: es que tu máquina no alcanzó a intercalar. Sube `cajeros` a 50 y vuelve a correr. Si aun así cuadra, sube `existenciaInicial` a 3 y `cajeros` a 50: con más competencia por menos piezas, la ventana se ensancha sola.

#### Lee tus resultados

La línea que importa es la última. Y hay dos síntomas distintos, no confundas uno con otro:

| Síntoma | Qué significa |
|---|---|
| Se confirmaron **más ventas que existencias había** | Varios hilos pasaron la comprobación con la misma existencia. Vendiste lo que no tenías |
| `inicial - confirmadas` **no es igual a** `final` | Se perdieron descuentos: dos hilos escribieron encima del otro |

El primero es el que le duele al negocio. El segundo es el que te vuelve loco depurando.

**Lo que entregas de este bloque**

1. `src/GestorInventario.java` con el `TODO` de `cargarDesde` resuelto y productos de **tu** catálogo.
2. `src/PruebaCarrera.java` configurado con tu producto.
3. `evidencias/carrera.txt` con las **cinco corridas completas**.

4. En `BITACORA.md`, bajo `### Antes de la clase`, esta tabla llena con tus cinco corridas:

   | Corrida | Confirmadas | Rechazadas | Existencia final | Cuadra? |
   |---|---|---|---|---|
   | 1 | | | | |
   | 2 | | | | |
   | 3 | | | | |
   | 4 | | | | |
   | 5 | | | | |

   Y debajo, tres cosas escritas:

   - **Cuál de los dos síntomas de la tabla de arriba te salió**, y en qué corrida se ve más claro.
   - **Qué configuración necesitaste** para que fallara (cuántos cajeros, cuánta existencia). Si te falló a la primera, dilo también.
   - **Qué le habrías cobrado de más o de menos a tus clientes** en la peor de tus cinco corridas, en tu dominio y con números.

```bash
git add .
git commit -m "s05 bloque 2: condicion de carrera reproducida"
git push
```

---

### Bloque extra: hacer que falle siempre {#bloque-extra}

Opcional. Reproducir un fallo una de cada cinco veces está bien para entenderlo. Para **probar que lo arreglaste** la semana que viene, necesitas algo mejor: una configuración que falle **el 100% de las veces**.

Esto es lo que en la industria se llama construir un caso de prueba reproducible, y es la diferencia entre "creo que ya quedó" y "puedo demostrar que quedó".

Busca esa configuración de forma sistemática. Modifica `PruebaCarrera` para que lea los parámetros de la línea de comandos:

```java
int cajeros = Integer.parseInt(args[0]);
int existenciaInicial = Integer.parseInt(args[1]);
```

Y barre el espacio de configuraciones con un script:

```bash
cd ~/so-proyecto/src
for cajeros in 2 5 10 50 100 500; do
  fallos=0
  for i in $(seq 1 20); do
    java PruebaCarrera $cajeros 10 | grep -q "CUADRA.*false" && fallos=$((fallos+1))
  done
  echo "cajeros=$cajeros  fallos en 20 corridas: $fallos"
done
```

Llena tu tabla:

| Cajeros | Existencia inicial | Fallos en 20 corridas | Tasa |
|---|---|---|---|
| 2 | 10 | | |
| 5 | 10 | | |
| 10 | 10 | | |
| 50 | 10 | | |
| 100 | 10 | | |
| 500 | 10 | | |

Y después la prueba de fuego: **quita el `Thread.sleep(1)`** del `GestorInventario` y repite el barrido completo. Anota la segunda columna de tasas al lado de la primera.

Dos preguntas para escribir, y son de las buenas del curso:

1. **Sin el `sleep`, cuántos cajeros necesitaste** para conseguir la misma tasa de fallo? Ese número te dice cuánto se estrechó la ventana.
2. Si en tu máquina, sin el `sleep`, con 2 cajeros nunca falla: **quiere decir que ese código es seguro?** Piensa qué pasa en un servidor con 32 núcleos y 400 cajeros reales. Esta pregunta la voy a hacer en la revisión.

```bash
git add .
git commit -m "s05 extra: barrido de configuraciones y tasa de fallo"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu inventario roto y tus cinco corridas guardadas. Hoy comparamos, medimos y dejamos armado el problema que la semana que viene se resuelve.

#### 0. Rescate de atorones

Lo de siempre, con los atorones documentados.

#### 1. El pizarrón de los descuadres

Cada quien pasa a anotar en el pizarrón tres datos de su peor corrida: **cajeros, existencia inicial y existencia final**. Con 15 columnas ahí arriba se ve algo que no se puede ver en una sola máquina:

- A quiénes les falló y a quiénes no, con la misma configuración.
- Que las máquinas con más núcleos fallan más. Compruébenlo con `nproc`.
- Que **nadie obtuvo el mismo resultado dos veces**.

La conclusión es la que hay que dejar escrita: si el mismo código da resultados distintos en máquinas distintas y en corridas distintas, **una prueba que pasa no demuestra nada**. Es la frase de la semana.

#### 2. Sin la trampa

Quiten el `Thread.sleep(1)` del `vender` y corran de nuevo con 10 cajeros. A casi todos les va a cuadrar.

Ahora súbanle a 500 cajeros y 100 piezas:

```bash
java PruebaCarrera 500 100
```

Vuelve a fallar. La conversación que sale de aquí es la que importa: **el error no se fue cuando quitamos el `sleep`, solo se volvió menos probable**. Y "menos probable" en un servidor que atiende 100000 pedidos al día significa que ocurre todos los días.

#### 3. El intercalado en el pizarrón, entre todos

Tomamos la peor corrida del grupo y **reconstruimos a mano el intercalado exacto** que produjo ese número, con la tabla del bloque 1, en el pizarrón, entre todos. Con tres hilos, no con dos.

Es el ejercicio que más cuesta y el que más rinde: si puedes reconstruir el orden de instrucciones que produjo un número imposible, entendiste el tema completo.

#### 4. Las tres soluciones que se les ocurren

Antes de que yo diga nada, la lluvia de ideas: **cómo lo arreglarían?** Van a salir estas tres, y todas van a estar en el pizarrón sin corregirse:

1. "Que el segundo hilo espere a que el primero termine."
2. "Volver a comprobar la existencia después de descontar."
3. "Que solo un hilo toque el inventario."

Las dejamos anotadas tal cual. La semana que viene vamos a ver cuál de las tres es la que funciona, cuál funciona pero cuesta carísimo, y cuál **parece** que funciona y no funciona. Anota las tres en tu bitácora hoy, con tu apuesta de cuál es cuál.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Conecta tu `GestorInventario` al servidor.** Hasta ahora vive solo en la prueba. Haz que `ServidorPedidos` cree un `GestorInventario`, lo cargue desde `datos/catalogo.txt` al arrancar, y que el método `atender` de cada hilo llame a `vender` con el producto y la cantidad del pedido.

2. **Que el servidor diga qué pasó con cada pedido.** Si `vender` devuelve `false`, el pedido se rechaza y se registra como tal. Ahí es donde por fin sirve el campo `estado` que modelaste en la semana 3.

3. **Deja el descuadre a la vista.** Al terminar la corrida, que tu servidor imprima el resumen: pedidos recibidos, confirmados, rechazados y existencia final de cada producto. **No lo arregles todavía.** El sistema tiene que estar roto y tú tienes que poder demostrarlo, porque la semana que viene la evidencia es "antes y después".

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es una condición de carrera, con tus palabras y con tu tabla de intercalado.
   - Dónde está exactamente la sección crítica de **tu** servidor, con el código pegado.
   - Por qué este error es distinto de todos los que has depurado antes en otras materias.
   - Las tres soluciones del pizarrón y tu apuesta sobre cuál es la buena.

   ```bash
   git add .
   git commit -m "s05 proyecto: inventario compartido y descuadre demostrado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Reproduzcan el descuadre en las tres sucursales** y junten las tres evidencias en el repositorio del equipo, cada una con su configuración y su máquina (`nproc`). Tres máquinas distintas fallando distinto es un dato que en la revisión vale.

2. **Identifiquen la sección crítica del Servidor Central**, que es más difícil que la de una sucursal. Si las tres sucursales le mandan pedidos al mismo tiempo, qué estructura compartida tiene el central? Déjenlo escrito en el README del equipo, aunque todavía no lo hayan programado.

3. **Discutan y anoten:** si cada sucursal tiene su propio inventario en su propio proceso, hay condición de carrera **entre sucursales**? Con lo de la semana 3 sobre espacios de direcciones separados ya tienen con qué contestarla, y la respuesta no es la que parece a primera vista.
