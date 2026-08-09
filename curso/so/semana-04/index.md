---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 4 - Hilos: pedidos concurrentes (U2)

La semana pasada cerramos con una pregunta que dejamos abierta: tu servidor atiende un pedido, se bloquea esperando a que termine, y mientras tanto los otros cuatro cajeros esperan. Esta semana la contestamos, y la respuesta cambia la forma de tu servidor para el resto del semestre.

La respuesta son los **hilos**. Un hilo es una linea de ejecución dentro de tu propio proceso: comparte su memoria, comparte sus archivos abiertos, y aun así puede estar corriendo mientras las otras esperan. Al terminar esta semana tu servidor va a atender varios pedidos a la vez, y en la sesión vas a poder verlos con tus propios ojos dentro de un solo proceso. Lo que no te vamos a decir todavía es que acabas de meter en tu sistema el problema más famoso de los sistemas operativos. Eso es la semana que viene.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: estados de un proceso y qué es un hilo](#bloque-1)
    - [Bloque 2: un hilo por pedido](#bloque-2)
    - [Bloque extra: un pool de hilos con ExecutorService](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes los estados de un proceso y qué comparte un hilo | Tu diagrama de estados aplicado a tu servidor |
| 2 | Haces que tu servidor atienda cada pedido en su propio hilo | `src/ServidorPedidos.java` y `evidencias/hilos.txt` |
| Extra | Cambias los hilos sueltos por un pool acotado | La comparación de las dos versiones |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: estados de un proceso y qué es un hilo {#bloque-1}

#### Los estados, ahora en serio

En la semana 2 leíste la columna `STAT` de `ps` y aprendiste sus letras. Ahora vamos a ver **cómo se pasa de una a otra**, porque esas transiciones son las que explican todo lo que va a hacer tu servidor de aquí en adelante.

Un proceso, desde que nace hasta que muere, se mueve entre tres situaciones básicas:

```
                    +--------------+
        admitido    |              |   elegido por el planificador
   ----------------->    Listo     ------------------------+
                    |              |                       |
                    +--------------+                       v
                          ^                        +----------------+
       se acabo su turno  |                        |   Ejecutando   |
       (interrupcion)     +------------------------|                |
                          |                        +----------------+
                          |                               |
                    +--------------+                      | pide algo
       llego lo que |              |                      | (disco, red, sleep)
       esperaba     |  Bloqueado   <----------------------+
                    |              |
                    +--------------+
```

Léelo con tu servidor en la cabeza:

| Estado | Letra en `ps` | Qué está pasando |
|---|---|---|
| **Listo** | `R` | Puede correr, pero el procesador está ocupado con otro. Solo espera turno |
| **Ejecutando** | `R` | Está usando el procesador en este instante |
| **Bloqueado** | `S` o `D` | Pidió algo y no puede seguir hasta que llegue. **No compite por el procesador** |

Fíjate en algo que confunde a todos: **`ps` usa la misma letra `R` para "listo" y "ejecutando"**. Desde fuera no se distinguen, porque en el instante en que `ps` mira, el proceso o está corriendo o podría estarlo. La diferencia es real dentro del kernel, pero no la vas a ver en esa columna.

Y las dos transiciones que importan:

- **De Ejecutando a Bloqueado.** Tu servidor llama a `Thread.sleep`, o lee un archivo, o espera un pedido. El SO se lo lleva del procesador **de inmediato**, sin esperar a que se acabe su turno, porque no tiene sentido darle procesador a alguien que no puede avanzar. Ese es el motivo real de que tu servidor estuviera en `S` con 0% de CPU.
- **De Ejecutando a Listo.** No pidió nada, simplemente **se le acabó el turno**. El SO lo interrumpe a media instrucción y le da el procesador a otro. Eso es el cambio de contexto de la semana 3, y ese turno tiene nombre: se llama **quantum**, y lo vamos a medir en la semana 10.

La conclusión práctica, y es la que abre el tema de hoy: **un proceso bloqueado no estorba a los demás, pero tampoco avanza**. Si tu servidor se bloquea atendiendo un pedido, no es que esté gastando recursos: es que **no está atendiendo a nadie más**.

#### El problema con tu servidor de la semana pasada

Tu `main` hace esto:

```
recibe un pedido
   atiende el pedido   <- aqui se tarda: consulta, descuenta, escribe
recibe el siguiente
   atiende el siguiente
```

Si atender un pedido tarda 2 segundos y llegan 5 pedidos a la vez, el último cajero espera **10 segundos**. Y lo peor es que durante casi todo ese tiempo tu servidor **no está trabajando**: está bloqueado esperando al disco o a la red. Un procesador ocioso y cuatro cajeros esperando al mismo tiempo.

En la semana 3 se te ocurrió la solución obvia: un proceso por cajero. Y midieron por qué no sirve: crear un proceso cuesta unos 100 ms, y además cada proceso tiene su propio espacio de direcciones, así que **no podrían compartir el inventario**. Necesitamos algo más barato y que sí comparta memoria.

#### El hilo

Un **hilo** (o hebra, o proceso ligero) es una línea de ejecución **dentro del mismo proceso**. Un proceso arranca con un hilo, el que corre tu `main`, y puede crear más. Todos viven en el mismo proceso, con el mismo PID, y el SO los planifica **de forma independiente**: mientras uno está bloqueado esperando al disco, otro puede estar ejecutando.

Lo decisivo es qué comparten y qué no:

| Recurso | Entre procesos | Entre hilos del mismo proceso |
|---|---|---|
| Espacio de direcciones (el heap) | Separado | **Compartido** |
| Variables de objeto y estáticas | Separadas | **Compartidas** |
| Archivos abiertos | Separados | **Compartidos** |
| Pila (variables locales) | Separada | **Separada.** Cada hilo tiene la suya |
| Contador de programa y registros | Separados | Separados |
| Costo de crearlo | Alto (~100 ms) | Bajo (~0.1 ms) |

Las dos filas que tienes que grabarte son la segunda y la cuarta, porque juntas explican todo lo que viene:

- **El montón es compartido.** Si tienes un objeto `inventario` y dos hilos lo modifican, están tocando **el mismo objeto**. Eso es exactamente lo que necesitas para que dos cajeros descuenten del mismo stock. Y es exactamente lo que va a romper tu sistema la semana que viene.
- **La pila es propia.** Las variables locales de un hilo son suyas y nadie más las ve. Por eso dos hilos pueden ejecutar el mismo método al mismo tiempo sin pisarse las variables locales.

Un hilo es tan barato porque **no hay que crear un espacio de direcciones nuevo**: se reutiliza el que ya existe. Lo único propio que hay que darle es su pila y su juego de registros. De ahí el factor de mil en el costo.

#### Cómo se ven desde fuera

Aquí hay algo que vale la pena que anticipes, porque va a salir en tu evidencia: **`ps -ef` no muestra los hilos**. Muestra procesos. Tu servidor con 5 hilos sigue siendo **una sola línea** con un solo PID.

Para verlos hay que pedirlo:

```bash
ps -o pid,nlwp,stat,cmd -C java
```

`nlwp` es *number of light-weight processes*, o sea el número de hilos. Y para verlos uno por uno:

```bash
top -H
```

La `H` es la tecla que ya conocías de la semana 2. Ahí cada renglón deja de ser un proceso y pasa a ser un hilo.

Y en la ficha de `/proc` que leíste en el bloque extra de la semana 2:

```bash
grep Threads /proc/TU_PID/status
```

Ese `Threads: 19` que te sorprendió entonces ya tiene explicación: eran los hilos internos de la JVM (recolector de basura, compilador). Hoy le vas a agregar los tuyos y vas a ver subir el número.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **El recorrido de estados de tu servidor atendiendo un pedido.** Escribe la secuencia de estados por los que pasa, desde que llega el pedido hasta que termina de atenderlo, y **qué provoca cada transición**. Mínimo cuatro transiciones. Usa tu dominio.

2. **Esta tabla, con ejemplos de tu propio sistema:**

   | Cosa de mi servidor | Va en la pila o en el montón? | La comparten los hilos? |
   |---|---|---|
   | El objeto que guarda mi inventario | | |
   | La variable local con el pedido que estoy atendiendo | | |
   | El archivo de log abierto | | |

3. **Una predicción.** Si dos hilos atienden dos pedidos del mismo producto al mismo tiempo, y los dos descuentan del mismo objeto de inventario, **qué crees que puede salir mal?** No importa si aciertas: importa que quede escrito antes de comprobarlo. Lo vamos a leer en la semana 5.

```bash
git add .
git commit -m "s04 bloque 1: estados e hilos"
git push
```

---

### Bloque 2: un hilo por pedido {#bloque-2}

Ahora el código. Tu servidor va a dejar de atender un pedido a la vez.

#### Primero, el pedido tiene que llegar de algún lado

Hasta hoy tu servidor no recibía nada: dormía. Vamos a que lea pedidos **desde la consola**, una línea por pedido, con el formato que acordaron en la semana 3:

```
ID;PRODUCTO;CANTIDAD
```

Así puedes teclearlos tú, o mandárselos desde tu `GeneradorPedidos` con una tubería, que es lo que vas a hacer en la sesión.

#### El código

Reescribe el `main` de `src/ServidorPedidos.java` así:

```java
// ServidorPedidos.java - un hilo por pedido
import java.util.Scanner;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class ServidorPedidos {

    // TODO: el nombre de tu negocio
    static final String NEGOCIO = "Farmacia SaludYa";

    public static void main(String[] args) {

        long pid = ProcessHandle.current().pid();
        registrar("Servidor de " + NEGOCIO + " listo. PID " + pid);
        registrar("Escribe pedidos con el formato ID;PRODUCTO;CANTIDAD");

        Scanner entrada = new Scanner(System.in);
        int contador = 0;

        while (entrada.hasNextLine()) {

            String linea = entrada.nextLine().trim();
            if (linea.isEmpty()) continue;
            if (linea.equals("salir")) break;

            contador++;
            final String pedido = linea;
            final int numero = contador;

            // Aqui esta lo nuevo de la semana: no atendemos el pedido,
            // creamos un hilo que lo atienda, y seguimos escuchando.
            Thread hilo = new Thread(() -> atender(pedido, numero));
            hilo.setName("pedido-" + numero);
            hilo.start();

            registrar("Recibido el pedido " + numero + ". Hilos vivos: "
                      + Thread.activeCount());
        }

        registrar("Servidor detenido tras " + contador + " pedidos");
    }

    // Este metodo lo ejecuta CADA hilo, por su cuenta.
    static void atender(String linea, int numero) {

        String nombreHilo = Thread.currentThread().getName();
        registrar(nombreHilo + " empieza a atender: " + linea);

        // TODO: parte la linea en ID;PRODUCTO;CANTIDAD y construye
        //       un objeto Pedido con lo que hiciste en la semana 3.
        //       pista: linea.split(";")

        // Simulamos que atender cuesta trabajo: consultar, cobrar, imprimir.
        // En la semana 13 esto se va a volver escritura real a disco.
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            registrar(nombreHilo + " fue interrumpido");
            return;
        }

        // TODO: imprime aqui el pedido usando el toString() de tu clase Pedido

        registrar(nombreHilo + " termino");
    }

    static void registrar(String mensaje) {
        String hora = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss.SSS"));
        System.out.println("[" + hora + "] " + mensaje);
    }
}
```

Fíjate en el formato de la hora: le agregué **milisegundos** (`.SSS`). No es capricho. A partir de esta semana los eventos ocurren tan cerca unos de otros que sin milisegundos no vas a poder saber cuál pasó primero, y esa información es justo la que necesitas para entender lo que ocurre.

#### Tres cosas que están pasando ahí

**`new Thread(() -> atender(pedido, numero))`** crea el hilo, pero **no lo arranca**. El hilo nace en estado "nuevo" y no existe todavía para el SO. Quien lo arranca de verdad es `hilo.start()`, y en ese momento el SO le da su pila y lo pone en estado **Listo**. Un error clásico es llamar a `hilo.run()` en vez de `start()`: eso ejecuta el método en el hilo actual, sin crear nada, y tu servidor se queda exactamente igual de lento que antes. Si tu programa se comporta como si los hilos no existieran, revisa esto primero.

**El `while` no espera a nadie.** Esa es la diferencia completa con la semana 3. Ahí tenías un `waitFor()` que bloqueaba al padre; aquí, después de `start()`, el ciclo vuelve de inmediato a leer la siguiente línea. Tu servidor puede recibir el pedido 2 mientras el 1 todavía se está atendiendo.

**`final String pedido = linea;`** parece burocracia de Java y tiene un motivo de fondo. El hilo nuevo va a leer esa variable **más tarde**, cuando el ciclo ya vaya en otra línea. Java te obliga a que sea final justamente para que no le cambies el valor por debajo al hilo. Es la primera vez en el curso que el lenguaje te frena por un problema de concurrencia, y no va a ser la última.

#### Compílalo y míralo

```bash
cd ~/so-proyecto/src
javac ServidorPedidos.java
java ServidorPedidos
```

Teclea tres pedidos seguidos, rápido, uno tras otro:

```
1;paracetamol;2
2;ibuprofeno;1
3;amoxicilina;3
```

Lo que tiene que pasar, y es el punto de toda la semana: los tres mensajes de "empieza a atender" salen **casi al mismo tiempo**, y los tres "termino" salen juntos dos segundos después. No uno tras otro. Si los ves de dos en dos segundos, el `start()` no está donde debe.

Para salir, escribe `salir`.

#### Ahora míralos desde fuera

Con el servidor corriendo y tres pedidos en curso, desde otra terminal:

```bash
ps -o pid,nlwp,stat,cmd -C java
```

```
    PID NLWP STAT CMD
    812   22 Sl   java ServidorPedidos
```

**Un solo proceso, un solo PID, 22 hilos.** Esa es la evidencia de la semana. Y uno por uno:

```bash
top -H -p TU_PID
```

Ahí vas a ver tus hilos con el nombre que les pusiste (`pedido-1`, `pedido-2`), mezclados con los internos de la JVM.

**Lo que entregas de este bloque**

1. `src/ServidorPedidos.java` con los tres `TODO` resueltos y usando tu clase `Pedido`.

2. La evidencia de los hilos vivos, tomada **mientras hay pedidos atendiéndose**:

   ```bash
   cd ~/so-proyecto
   ps -o pid,nlwp,stat,cmd -C java > evidencias/hilos.txt
   ```

3. En `BITACORA.md`, bajo `### Antes de la clase`:
   - Cuántos hilos tenía tu servidor **antes** de recibir pedidos y cuántos **durante**. Explica la diferencia entre los dos números y de dónde salen los que no creaste tú.
   - Pega las tres líneas de tu log donde se ve que los pedidos se atendieron traslapados, y **señala con los milisegundos** por qué eso demuestra que fueron simultáneos.
   - Por qué `ps -ef` sigue mostrando una sola línea aunque tengas varios hilos.

```bash
git add .
git commit -m "s04 bloque 2: un hilo por pedido"
git push
```

---

### Bloque extra: un pool de hilos con ExecutorService {#bloque-extra}

Opcional. Tu servidor tiene un problema que no se nota con tres pedidos y se nota muchísimo con mil.

Crear un hilo es barato comparado con un proceso, pero **no es gratis**. Si tu servidor crea un hilo por cada pedido que llega y le entran 10000 pedidos, va a crear 10000 hilos, cada uno con su pila reservada. La máquina se ahoga: no por el trabajo, sino por administrar hilos.

La solución estándar en la industria es un **pool**: creas un número fijo de hilos al arrancar y los reutilizas. Los pedidos se forman en una cola y los hilos van tomando el siguiente que haya.

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

// Al arrancar el servidor, antes del while:
ExecutorService pool = Executors.newFixedThreadPool(4);

// En vez de crear un hilo por pedido:
pool.submit(() -> atender(pedido, numero));

// Al salir del while, para un apagado limpio:
pool.shutdown();
```

Pruébalo con 10 pedidos seguidos y un pool de 4. Vas a ver algo distinto: **solo 4 pedidos empiezan a la vez**, y los demás esperan turno.

Anota en tu bitácora:

| | Un hilo por pedido | Pool de 4 |
|---|---|---|
| `nlwp` con 10 pedidos en curso | | |
| Cuántos pedidos empiezan al mismo tiempo | | |
| Cuánto tarda el último en terminar | | |
| Qué pasa si llegan 10000 pedidos | | |

Y la pregunta buena, que no tiene respuesta única: **cuántos hilos debería tener tu pool?** Piensa en cuántos núcleos tiene tu máquina (`nproc`) y en si tus pedidos gastan procesador o se pasan el tiempo esperando al disco. Es una decisión de diseño real y en la semana 10 vas a tener las herramientas para justificarla.

```bash
git add .
git commit -m "s04 extra: pool de hilos"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu servidor atendiendo un hilo por pedido. Hoy lo medimos, lo saturamos, y al final lo rompemos.

#### 0. Rescate de atorones

Los primeros minutos, con los atorones documentados del lunes.

#### 1. Alimentar al servidor sin teclear

Teclear pedidos a mano no sirve para medir nada. Vamos a conectarle tu generador de la semana 3 con una **tubería**:

```bash
cd ~/so-proyecto/src
java GeneradorPedidos 20 | java ServidorPedidos
```

Esa barra vertical le entrega la salida del generador directamente a la entrada del servidor. Es la misma idea de la ventanilla que va a tener nombre propio en la semana 8, cuando se llame *pipe*.

Guarda la corrida completa para poder leerla con calma:

```bash
java GeneradorPedidos 20 | java ServidorPedidos > ../evidencias/carga20.txt 2>&1
```

#### 2. Secuencial contra concurrente: la medición

Vamos a poner número a lo que ganamos. Necesitas las dos versiones. Haz una copia de tu servidor llamada `ServidorSecuencial.java` y en ella cambia una sola línea:

```java
// En lugar de:
Thread hilo = new Thread(() -> atender(pedido, numero));
hilo.start();

// Deja solo esto:
atender(pedido, numero);
```

Nada más. Es el mismo programa, atendiendo igual, sin hilos.

```bash
javac ServidorSecuencial.java
time (java GeneradorPedidos 10 | java ServidorSecuencial > /dev/null)
time (java GeneradorPedidos 10 | java ServidorPedidos   > /dev/null)
```

Llena la tabla con tus números:

| | Tiempo `real` | Cuánto tarda cada pedido | 10 pedidos deberían tardar... |
|---|---|---|---|
| `ServidorSecuencial` | | 2 s | |
| `ServidorPedidos` (hilos) | | 2 s | |

La pregunta que hay que contestar: el servidor con hilos atendió 10 pedidos de 2 segundos cada uno en poco más de 2 segundos. **De dónde salió ese tiempo?** No se hizo menos trabajo. Piensa en qué estaba haciendo el procesador durante esos `Thread.sleep`.

#### 3. Hasta dónde aguanta

Ahora al revés: cuántos hilos soporta antes de portarse mal.

```bash
java GeneradorPedidos 200 | java ServidorPedidos > ../evidencias/carga200.txt 2>&1 &
```

Mientras corre, desde otra terminal, mira el número de hilos subir:

```bash
watch -n 1 'ps -o pid,nlwp,stat,%cpu,%mem -C java'
```

`watch` repite el comando cada segundo. Sales con `Ctrl + C`.

Anota el **valor máximo** de `nlwp` que alcanzaste y el `%mem`. Después súbele a 2000 y vuelve a mirar. Quien haya hecho el bloque extra, corre lo mismo con su versión de pool y compara las dos columnas: ahí se ve para qué sirve un pool.

Si a alguien le sale un `OutOfMemoryError: unable to create native thread`, que no lo borre: **eso es la evidencia**, y es el mismo tipo de límite del sistema que vimos con los PIDs y los zombis.

#### 4. La grieta

Esto es lo último y es lo que abre la semana que viene. Vamos a darles a todos los hilos algo que compartir.

Agrega a tu `ServidorPedidos.java` un contador de piezas vendidas, así de simple:

```java
// Una variable compartida por todos los hilos.
static int piezasVendidas = 0;
```

Y dentro de `atender`, justo antes del último `registrar`:

```java
piezasVendidas = piezasVendidas + 1;
```

Al salir del `while`, en el `main`:

```java
registrar("Pedidos recibidos: " + contador);
registrar("Piezas vendidas segun el contador: " + piezasVendidas);
```

Espera. Antes de correrlo, **escribe en tu bitácora qué número esperas ver** en las dos líneas si mandas 1000 pedidos.

Ahora bájale el `Thread.sleep(2000)` a `Thread.sleep(1)` para que 1000 pedidos terminen rápido, y corre:

```bash
java GeneradorPedidos 1000 | java ServidorPedidos | tail -5
```

Córrelo **cinco veces** y anota los cinco resultados.

No vamos a explicar hoy lo que viste. Lo que sí vamos a hacer es comparar los números de todo el grupo en el pizarrón, y dejar planteada la pregunta que es la semana 5 completa: **cómo puede ser que sumar uno mil veces no dé mil?**

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu servidor recibiendo pedidos por consola** en el formato `ID;PRODUCTO;CANTIDAD` y atendiendo cada uno en su propio hilo. Que funcione tanto tecleando a mano como con la tubería del generador.

2. **Haz que `atender` use de verdad tu clase `Pedido`**: que parta la línea, construya el objeto y lo imprima con su `toString()`. Si el formato de entrada y el de salida no coinciden, arréglalo ahora: en la semana 15 vas a tener que volver a leer esas líneas desde un archivo.

3. **Deja el contador de piezas vendidas en tu código**, con los números raros y todo. No lo arregles. La semana que viene vas a entender por qué falla y lo vas a resolver bien; si lo parchas hoy a ciegas, te pierdes el tema.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es un hilo y en qué se diferencia de un proceso, con tus palabras y con la tabla de qué comparten.
   - Por qué a tu servidor le conviene un hilo por pedido y no un proceso por pedido. Dos razones, y las dos las mediste.
   - Los cinco resultados del contador y **tu hipótesis** de qué está pasando. Aunque esté equivocada.

   ```bash
   git add .
   git commit -m "s04 proyecto: servidor concurrente con un hilo por pedido"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Las tres sucursales ya atienden en paralelo. Ahora hay que ponerse de acuerdo en cuánto es "en paralelo".

1. **Midan las tres sucursales con la misma carga.** Cada quien corre `java GeneradorPedidos 200 | java ServidorPedidos` y anotan el tiempo y el `nlwp` máximo. Pónganlo en una tabla en el README del equipo.

2. **Decidan el modelo de concurrencia del equipo** y déjenlo escrito: un hilo por pedido, o pool con un tamaño fijo. Si eligen pool, cuál es el tamaño y con qué argumento lo eligieron. En la semana 16, cuando los cajeros lleguen por socket, esta decisión va a definir cuántos cajeros simultáneos aguanta el sistema.

3. **Anoten la pregunta que van a tener que contestar en la revisión de la semana 9:** su Servidor Central va a recibir pedidos de las tres sucursales al mismo tiempo. Qué van a compartir esos hilos y qué no? Todavía no la contesten. Con lo de las semanas 5 y 6 van a tener con qué.
