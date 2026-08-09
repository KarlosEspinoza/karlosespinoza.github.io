---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 8 - Comunicación entre procesos (U2)

Cierra la Unidad 2. Hasta hoy todo lo que has coordinado ocurría **dentro de un proceso**: hilos que comparten el mismo montón, candados sobre los mismos objetos. Esta semana salimos de ahí y resolvemos el problema que dejamos planteado desde la semana 3: **dos procesos distintos no comparten memoria**, entonces cómo se dicen algo.

Y de paso contestamos la pregunta que quedó abierta la semana pasada, cuando `kill` normal no mató a tu proceso trabado y `kill -9` sí. La respuesta son las **señales**, que son el mecanismo con el que el sistema operativo y los demás procesos le hablan al tuyo. Al terminar la semana tu servidor va a apagarse de forma ordenada en vez de morirse a media venta, que es la diferencia entre un programa y un servicio.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: señales, o cómo se le habla a un proceso](#bloque-1)
    - [Bloque 2: apagado ordenado y comunicación por tubería](#bloque-2)
    - [Bloque extra: una tubería con nombre](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes las señales y por qué `SIGKILL` no se atrapa | Tu tabla de señales y tu plan de apagado |
| 2 | Le pones apagado ordenado a tu servidor y lo comunicas con otro proceso | `src/ServidorPedidos.java` y `evidencias/senales.txt` |
| Extra | Comunicas dos procesos que no son padre e hijo, con `mkfifo` | La evidencia de la tubería con nombre |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: señales, o cómo se le habla a un proceso {#bloque-1}

#### El problema de fondo

En la semana 3 quedó establecido: **cada proceso tiene su propio espacio de direcciones**, y el SO garantiza que ninguno pueda leer el del otro. Es la base del aislamiento y no es negociable.

Pero entonces, si tu `ServidorPedidos` y tu `GeneradorPedidos` son dos procesos distintos, cómo se pasan un pedido? No pueden compartir un objeto: la dirección de memoria de uno no significa nada en el otro. Necesitan que **el kernel les preste un canal**, y ese es todo el tema de la comunicación entre procesos (IPC, *inter-process communication*).

Linux ofrece varios canales. Los que importan para ti:

| Mecanismo | Qué transporta | Cuándo se usa |
|---|---|---|
| **Señales** | Un número, nada más. Un aviso | Avisarle a un proceso que pasó algo (apágate, se acabó tu hijo) |
| **Tuberías (pipes)** | Un flujo de bytes en un solo sentido | Encadenar procesos: la salida de uno es la entrada de otro |
| **Tuberías con nombre (FIFO)** | Igual, pero con un archivo | Comunicar procesos que no son parientes |
| **Sockets** | Bytes, y además entre máquinas distintas | Semana 16. Es a donde va tu proyecto |
| Memoria compartida | Una región de memoria de verdad compartida | Cuando el rendimiento manda. No lo vemos en este curso |

Fíjate en la primera fila: una señal **no lleva datos**. Es un golpe en la puerta, no una carta. Lleva un número y punto.

#### Las señales

Una **señal** es una interrupción por software que se le manda a un proceso. Es el mecanismo más antiguo de Unix y sigue siendo el que usas cada vez que aprietas `Ctrl + C`.

Cuando llega una señal, el proceso puede hacer tres cosas: **atenderla** con una función propia (un manejador), **ignorarla**, o dejar que ocurra el **comportamiento por omisión**, que para casi todas es morirse.

Las que tienes que conocer:

| Señal | Número | Qué significa | Se puede atrapar? | Cómo se manda |
|---|---|---|---|---|
| `SIGINT` | 2 | Interrupción del usuario | Sí | `Ctrl + C` |
| `SIGTERM` | 15 | Petición educada de terminar | Sí | `kill PID` |
| `SIGKILL` | 9 | Muerte inmediata | **No** | `kill -9 PID` |
| `SIGHUP` | 1 | Se colgó la terminal | Sí | Cerrar la terminal |
| `SIGSTOP` | 19 | Suspender | **No** | `Ctrl + Z` |
| `SIGSEGV` | 11 | Violación de segmento | Sí (pero no deberías) | Acceso a memoria que no es tuya |
| `SIGCHLD` | 17 | Un hijo terminó | Sí | El kernel, cuando muere un hijo |

Dos apariciones de semanas pasadas encajan aquí: el `SIGHUP` es lo que mató al servidor de quien cerró la terminal sin usar `&` en la semana 2, y el `SIGCHLD` es la señal que le avisa al padre que tiene un hijo que recoger, o sea el mecanismo que hay detrás del zombi.

#### Por qué `SIGKILL` no se atrapa

Aquí está la respuesta a la pregunta de la semana pasada, y es una decisión de diseño muy deliberada del sistema operativo.

`SIGTERM` (el `kill` normal) es una **petición**: "por favor termina". Para atenderla, el proceso tiene que ejecutar su manejador, y para ejecutar su manejador **tiene que poder ejecutar algo**. Tu proceso trabado en un interbloqueo no puede: todos sus hilos están bloqueados esperando candados que nunca van a soltarse. La señal llega, se queda encolada, y nadie la atiende nunca.

`SIGKILL` no le llega al proceso en absoluto. **La ejecuta el kernel sobre el proceso**, sin pedirle opinión: le quita el procesador, libera su memoria, cierra sus archivos y borra su entrada de la tabla de procesos. El proceso no se entera de que murió.

Por eso existe y por eso no se puede atrapar: **es la garantía de último recurso del sistema operativo**. Si un proceso pudiera ignorar `SIGKILL`, un programa mal escrito o malicioso podría volverse inmortal y no habría forma de recuperar la máquina sin apagarla.

Y de ahí sale la consecuencia práctica que te importa como programador: **con `SIGKILL` no puedes limpiar nada**. No se ejecuta tu código de cierre, no se cierran tus archivos ordenadamente, no se guarda lo que estaba en memoria. Si tu servidor tenía 40 pedidos en un buffer sin escribir, se perdieron los 40.

Por eso el orden correcto para apagar un servicio es siempre: `SIGTERM` primero, esperar unos segundos, y solo si no obedece, `SIGKILL`. Es exactamente lo que hace `systemd` cuando paras un servicio en un servidor de verdad.

#### El apagado ordenado

Lo que quieres es que tu servidor, al recibir `SIGTERM` o `Ctrl + C`, no muera a media venta sino que:

1. Deje de aceptar pedidos nuevos.
2. Termine los que ya empezó.
3. Escriba lo que tenga pendiente y cierre sus archivos.
4. Imprima un resumen y entonces sí termine.

Java te da esto envuelto en un **shutdown hook**: un hilo que registras y que la JVM ejecuta justo antes de terminar.

```java
Runtime.getRuntime().addShutdownHook(new Thread(() -> {
    registrar("Recibi la senal de apagado. Cerrando ordenadamente.");
    // ... aqui va la limpieza ...
}));
```

Ese hook se ejecuta con `SIGINT`, con `SIGTERM` y con un `System.exit()` normal. **No se ejecuta con `SIGKILL`**, y comprobarlo es parte del bloque 2.

#### Las tuberías

El otro mecanismo. Una **tubería** es un canal de un solo sentido que el kernel crea entre dos procesos: uno escribe en un extremo y el otro lee en el otro extremo.

Ya la usaste sin saber cómo se llamaba. Esto, de la semana 4:

```bash
java GeneradorPedidos 20 | java ServidorPedidos
```

Esa barra vertical le pide al shell que cree una tubería, conecte la **salida estándar** del generador con la **entrada estándar** del servidor, y lance los dos procesos a la vez. Los dos corren simultáneamente; el generador no espera a terminar para que el servidor empiece.

Tres propiedades que hay que tener claras:

- **Es un flujo de bytes, no de objetos.** Por eso acordaron un formato de línea en la semana 3: es lo único que sabe transportar. Ahí está el motivo de fondo de `ID;PRODUCTO;CANTIDAD`.
- **Tiene capacidad limitada** (64 KB en Linux). Si el que escribe va más rápido que el que lee, **se bloquea** hasta que haya espacio. Eso es sincronización automática, gratis, cortesía del kernel.
- **Va en un solo sentido.** Para respuesta hace falta una segunda tubería.

Y las tuberías anónimas tienen un límite grande: **solo funcionan entre procesos emparentados**, porque el canal se hereda del padre al hijo. Dos programas lanzados desde terminales distintas no pueden. Para eso está el bloque extra.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **Por qué `SIGKILL` no se puede atrapar**, con tus palabras, y qué le pasó a tu proceso trabado de la semana 7 con `kill` normal. Une las dos cosas.

2. **Tu plan de apagado ordenado.** Lista concreta de qué tiene que hacer **tu** servidor antes de morir, en orden. Mínimo tres cosas, y que sean de tu dominio: qué queda a medias en tu negocio si el servidor muere en seco?

3. **La tabla de mecanismos aplicada a tu proyecto:**

   | Necesito... | Qué mecanismo uso | Por qué |
   |---|---|---|
   | Avisarle a mi servidor que se apague | | |
   | Mandarle pedidos desde el generador | | |
   | Que un cajero en otra máquina me mande pedidos | | |

```bash
git add .
git commit -m "s08 bloque 1: senales y comunicacion entre procesos"
git push
```

---

### Bloque 2: apagado ordenado y comunicación por tubería {#bloque-2}

#### Parte A: que tu servidor se apague bien

Agrega esto a `ServidorPedidos.java`, al principio del `main`, antes del ciclo:

```java
// Bandera compartida: los hilos la consultan para saber si deben seguir.
static volatile boolean apagando = false;
```

```java
// Dentro del main, antes del while:
Runtime.getRuntime().addShutdownHook(new Thread(() -> {

    apagando = true;
    registrar("Senal de apagado recibida. No se aceptan pedidos nuevos.");

    // TODO: espera a que terminen los pedidos en curso.
    //       pista: si usaste ExecutorService, es pool.shutdown() y
    //       pool.awaitTermination(10, TimeUnit.SECONDS).
    //       Si usas hilos sueltos, guardalos en una lista y haz join().

    registrar("Resumen final:");
    registrar("  Pedidos recibidos:  " + contador);
    registrar("  Ventas confirmadas: " + inventario.getVentasConfirmadas());
    registrar("  Ventas rechazadas:  " + inventario.getVentasRechazadas());

    // TODO: cierra aqui tus archivos abiertos y escribe lo pendiente.
    //       En la semana 13 esto va a importar mucho mas de lo que parece.

    registrar("Servidor apagado ordenadamente.");
}, "apagado"));
```

Esa palabra `volatile` en la bandera no es decorativa y vale la pena que la entiendas, porque es concurrencia de la semana 6 en versión sutil. Sin `volatile`, cada hilo puede tener una copia en caché del valor de la variable y **no enterarse nunca** de que otro hilo la cambió. `volatile` le dice a la JVM que esa variable se lee y se escribe siempre desde la memoria principal. Para una bandera que un hilo escribe y otros leen, es exactamente lo que hace falta.

#### Pruébalo con las tres señales

Lanza tu servidor en segundo plano y mándale cada señal, guardando lo que pasa:

```bash
cd ~/so-proyecto/src
javac ServidorPedidos.java

# 1. SIGTERM, la peticion educada
java ServidorPedidos > /tmp/s1.log 2>&1 &
PID=$!
sleep 2
kill $PID          # equivale a kill -15
sleep 2
echo "--- SIGTERM ---"; cat /tmp/s1.log

# 2. SIGINT, el Ctrl + C
java ServidorPedidos > /tmp/s2.log 2>&1 &
PID=$!
sleep 2
kill -2 $PID
sleep 2
echo "--- SIGINT ---"; cat /tmp/s2.log

# 3. SIGKILL, la ejecucion sumaria
java ServidorPedidos > /tmp/s3.log 2>&1 &
PID=$!
sleep 2
kill -9 $PID
sleep 2
echo "--- SIGKILL ---"; cat /tmp/s3.log
```

Lo que tiene que pasar, y es el punto del bloque:

| Señal | Se ve el mensaje de apagado? | Se ve el resumen? |
|---|---|---|
| `SIGTERM` (15) | Sí | Sí |
| `SIGINT` (2) | Sí | Sí |
| `SIGKILL` (9) | **No** | **No** |

Con `SIGKILL` el log se corta a media línea. Eso no es un error de tu programa: es la demostración de que el kernel no le dio oportunidad de nada.

Guarda la evidencia:

```bash
cd ~/so-proyecto
{ echo "=== SIGTERM ==="; cat /tmp/s1.log;
  echo "=== SIGINT ===";  cat /tmp/s2.log;
  echo "=== SIGKILL ==="; cat /tmp/s3.log; } > evidencias/senales.txt
```

#### Parte B: la tubería, ahora desde Java

En la semana 3 lanzaste un hijo con `inheritIO()`, que le prestaba tu terminal. Ahora vas a hacer lo que de verdad sirve: **leer lo que el hijo escribe**.

Agrega un método a tu `ServidorPedidos`:

```java
// Lanza al generador como hijo y lee sus pedidos por la tuberia.
static void recibirDelGenerador(int cuantos) throws Exception {

    ProcessBuilder pb = new ProcessBuilder("java", "GeneradorPedidos",
                                           String.valueOf(cuantos));
    pb.redirectErrorStream(true);

    Process hijo = pb.start();
    registrar("Generador lanzado con PID " + hijo.pid());

    // ESTO es la tuberia: la salida del hijo es un flujo que yo leo.
    try (BufferedReader tuberia = new BufferedReader(
             new InputStreamReader(hijo.getInputStream()))) {

        String linea;
        while ((linea = tuberia.readLine()) != null) {
            // TODO: filtra las lineas que no sean pedidos (las de "arrancado"
            //       y "termina") y manda las buenas a atender() en un hilo,
            //       igual que haces con las que llegan por consola.
            registrar("Por la tuberia llego: " + linea);
        }
    }

    int salida = hijo.waitFor();
    registrar("El generador termino con codigo " + salida);
}
```

La línea clave es `hijo.getInputStream()`. Ese nombre confunde a todos: es el *input* **del padre**, o sea la salida del hijo. Es el extremo de lectura de la tubería que el kernel creó cuando llamaste a `start()`.

Compara los dos modos:

| | `inheritIO()` (semana 3) | `getInputStream()` (hoy) |
|---|---|---|
| Quién ve lo que imprime el hijo | La terminal | **Tu programa** |
| Puedes procesarlo? | No | **Sí** |
| Hay tubería? | No, se comparte el descriptor | Sí, la crea el kernel |

**Lo que entregas de este bloque**

1. `src/ServidorPedidos.java` con el shutdown hook completo (los dos `TODO`) y con el método que lee del generador por la tubería.

2. `evidencias/senales.txt` con las tres corridas.

3. En `BITACORA.md`, bajo `### Antes de la clase`:
   - **Las tres salidas comparadas**, y qué se ve en cada una. Señala exactamente dónde se corta el log de `SIGKILL`.
   - **Qué se perdió** con `SIGKILL` en tu dominio, en concreto. No "datos": qué venta, qué recibo, qué línea del inventario.
   - **Por qué la bandera es `volatile`**, con tus palabras, y qué podría pasar sin esa palabra.

```bash
git add .
git commit -m "s08 bloque 2: apagado ordenado y tuberia con el generador"
git push
```

---

### Bloque extra: una tubería con nombre {#bloque-extra}

Opcional. La tubería del bloque 2 tiene una limitación grande: **solo funciona entre padre e hijo**, porque el canal se hereda. Si quieres que un cajero lanzado desde otra terminal le mande pedidos a tu servidor, no sirve.

La solución de Unix es la **tubería con nombre** o **FIFO**: una tubería que existe como **un archivo en el sistema de archivos**, así que cualquier proceso que conozca la ruta puede abrirla.

```bash
cd ~/so-proyecto/datos
mkfifo cajero.pipe
ls -l cajero.pipe
```

```
prw-r--r-- 1 karlos karlos 0 ... cajero.pipe
```

Mira la primera letra: `p` de *pipe*. No es un archivo normal (`-`) ni un directorio (`d`). Y fíjate en el tamaño: **0 bytes, siempre**, aunque pasen megabytes por ahí. No guarda nada; es un canal, no un archivo.

Pruébalo con dos terminales. En la primera:

```bash
cat ~/so-proyecto/datos/cajero.pipe
```

Se queda esperando. En la segunda:

```bash
echo "1;paracetamol;2" > ~/so-proyecto/datos/cajero.pipe
```

La línea aparece en la primera terminal. Dos procesos sin ningún parentesco, comunicados.

Ahora en tu servidor. Leer de un FIFO es leer de un archivo normal:

```java
// El servidor escucha por la tuberia con nombre
try (BufferedReader fifo = new BufferedReader(
         new FileReader("datos/cajero.pipe"))) {

    String linea;
    while ((linea = fifo.readLine()) != null) {
        // TODO: manda esta linea a atender() en su propio hilo
        registrar("Del FIFO: " + linea);
    }
}
```

Y el cajero, desde cualquier terminal:

```bash
echo "1;paracetamol;2" > ~/so-proyecto/datos/cajero.pipe
java GeneradorPedidos 50 > ~/so-proyecto/datos/cajero.pipe
```

Dos comportamientos que te van a sorprender y que hay que anotar:

1. **Abrir un FIFO para leer se bloquea** hasta que alguien lo abra para escribir. Y al revés. Es sincronización de arranque, incorporada.
2. **Cuando el escritor cierra, el lector recibe fin de archivo** y tu `while` termina. Si quieres que el servidor siga escuchando al siguiente cajero, tienes que volver a abrirlo.

Anota en tu bitácora la comparación completa, que es la que explica hacia dónde va el curso:

| | Tubería anónima | FIFO | Socket (semana 16) |
|---|---|---|---|
| Procesos emparentados? | Obligatorio | No hace falta | No hace falta |
| Existe en el sistema de archivos? | No | Sí | No |
| Entre máquinas distintas? | No | **No** | **Sí** |
| Sentidos | Uno | Uno | Dos |

Esa fila de "entre máquinas distintas" es la razón de que la Unidad 6 exista.

```bash
git add .
git commit -m "s08 extra: tuberia con nombre"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu servidor apagándose ordenadamente. Hoy cerramos la Unidad 2 y preparamos la revisión.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. La carrera de las señales

Por parejas. Uno lanza su servidor con carga:

```bash
java GeneradorPedidos 200 | java ServidorPedidos > /tmp/carga.log 2>&1 &
```

El otro le manda señales desde otra terminal, **sin avisar cuál**, mientras el primero mira el log:

```bash
kill -15 PID      # o -2, o -9, o -19 y luego -18
```

Quien mira el log tiene que decir **qué señal recibió**, por lo que ve. Es más fácil de lo que parece y enseña a leer un cierre incompleto, que es lo que te vas a encontrar en un log de producción.

El caso más interesante es el par `-19` (SIGSTOP) y `-18` (SIGCONT): el proceso se congela sin morir, `ps` lo muestra en `T`, y al mandarle `-18` sigue exactamente donde iba. Es el `Ctrl + Z` de la semana 2, ahora con nombre.

#### 2. Cuántos pedidos se pierden

La medición que le da sentido a todo el bloque. Lanza 200 pedidos y mátalo a la mitad, de las dos formas:

```bash
# Con SIGTERM
java GeneradorPedidos 200 | java ServidorPedidos > /tmp/term.log 2>&1 &
sleep 3; kill -15 $(pgrep -f ServidorPedidos)
grep -c "termino" /tmp/term.log

# Con SIGKILL
java GeneradorPedidos 200 | java ServidorPedidos > /tmp/kill.log 2>&1 &
sleep 3; kill -9 $(pgrep -f ServidorPedidos)
grep -c "termino" /tmp/kill.log
```

| | Pedidos recibidos | Pedidos terminados | Perdidos | Hay resumen final? |
|---|---|---|---|---|
| `SIGTERM` | | | | |
| `SIGKILL` | | | | |

Ese número de perdidos, en tu dominio, son ventas cobradas y no surtidas, o recetas despachadas sin descontar. Ponle nombre en la bitácora.

#### 3. El servidor que no se deja apagar

Para que quede claro por qué existe `SIGKILL`. Agrega esto al principio de tu shutdown hook:

```java
// A proposito: un hook que tarda una eternidad
try { Thread.sleep(600000); } catch (InterruptedException e) { }
```

Ahora `kill -15` **no lo apaga**: el proceso sigue vivo, ejecutando su hook, indefinidamente. Compruébalo con `ps`. Solo `kill -9` lo termina.

La lección para escribir: **un shutdown hook lento es un servidor que no se puede apagar**. Si tu limpieza tarda más que el tiempo que espera `systemd` (30 segundos por omisión), tu servicio se va a morir a la mala en cada reinicio del servidor, y nunca vas a saber por qué. Deja el hook corto y con su propio tiempo límite.

#### 4. La cadena completa

Cierre de la Unidad 2. Armamos el sistema entero con lo que se hizo en las semanas 4 a 8:

```bash
java GeneradorPedidos 500 | java ServidorPedidos > evidencias/unidad2.txt 2>&1 &
sleep 5
jstack $(pgrep -f ServidorPedidos) | grep -c "pedido-"    # los hilos vivos
kill -15 $(pgrep -f ServidorPedidos)                       # apagado ordenado
tail -10 evidencias/unidad2.txt                            # el resumen cuadra
```

Un proceso, varios hilos, un inventario compartido protegido, sin interbloqueo, alimentado por una tubería desde otro proceso, que se apaga cuando se lo piden y deja las cuentas cuadradas. **Eso es la Unidad 2 completa**, y es lo que se revisa la semana que viene.

#### 5. Preparación de la revisión

Los últimos minutos, con la lista de la [semana 9](/curso/so/semana-09) en pantalla. Cada quien marca qué tiene y qué le falta, y pregunta lo que no le quede claro. Es el último momento para hacerlo.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

Esta semana el avance del proyecto **es la preparación de la revisión**. La lista completa está en la [semana 9](/curso/so/semana-09); esto es lo que se agrega hoy.

1. **Deja el apagado ordenado funcionando.** Que `SIGTERM` produzca el resumen y `SIGKILL` no. Es una de las cosas que voy a pedir que demuestres en vivo.

2. **Deja tu servidor recibiendo pedidos por tubería** desde el generador, además de por consola. Si hiciste el bloque extra, también por FIFO.

3. **Revisa tu `BITACORA.md` completa, de la semana 1 a la 8.** Que cada semana tenga sus dos subsecciones, que los atorones estén documentados con sus cuatro partes, y que las explicaciones estén con tus palabras. Vale el 30% de la revisión y es lo que más se nota cuando se hace a última hora.

4. **Haz `push` de todo antes de la fecha de entrega**, que es antes del día de la revisión. Sin push a tiempo, la revisión cuenta como no entregada.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es una señal y por qué `SIGKILL` no se puede atrapar.
   - Qué hace tu servidor al apagarse y por qué ese orden.
   - Cómo se comunican dos procesos que no comparten memoria, con los mecanismos que usaste.
   - Cuántos pedidos perdiste con cada señal, con tus números.

   ```bash
   git add .
   git commit -m "s08 proyecto: apagado ordenado y comunicacion entre procesos"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Que todas las sucursales se apaguen ordenadamente** con el mismo criterio, y que el Servidor Central se entere cuando una sucursal se va. Con lo de hoy ya pueden: la sucursal avisa antes de cerrar.

2. **Cada integrante actualiza su archivo de autoevaluación entre pares** (`<codigo>.csv` en su repositorio privado) y hace push **antes de la revisión**. Vale el 10% de la calificación del integrador en esta revisión, y si no hay push, se pierde.

3. **Ensayen la demostración completa.** Tres sucursales corriendo, pedidos concurrentes, el descuadre demostrado y resuelto, un interbloqueo diagnosticado con `jstack`, y el apagado ordenado. Cronométrenlo: si no cabe en el tiempo, recorten y elijan qué enseñar, pero decídanlo antes y no en el momento.
