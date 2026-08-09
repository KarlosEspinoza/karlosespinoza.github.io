---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 13 - Llamadas al sistema y E/S (U4)

En la semana 1 dijimos que tu programa nunca toca el hardware: le pide todo al sistema operativo mediante llamadas al sistema, como quien entrega una solicitud en una ventanilla. Doce semanas después, esta semana **las vas a ver ocurrir**, una por una, en tu propio proceso, con nombre y con argumentos.

Y de paso se resuelve un misterio que quedó colgado desde la semana 2: aquel log que estaba vacío aunque el servidor claramente estaba imprimiendo. La explicación es el **buffering**, y entenderlo bien es la diferencia entre un servidor que escribe 8000 veces al disco por minuto y uno que escribe 8. Al terminar la semana tu servidor va a emitir un recibo por cada venta, y vas a poder demostrar con números cuánto le cuesta cada uno.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: la ventanilla por dentro](#bloque-1)
    - [Bloque 2: los recibos, vistos con strace](#bloque-2)
    - [Bloque extra: contar las llamadas con strace -c](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes el trap, los descriptores y el buffering | Tu explicación del log vacío de la semana 2 |
| 2 | Escribes recibos y observas las llamadas con `strace` | `src/GestorArchivos.java` y `evidencias/strace.txt` |
| Extra | Cuentas las llamadas con y sin buffer | Tu tabla de llamadas al sistema por recibo |

Necesitas `strace` instalado:

```bash
sudo apt install strace -y
strace -V
```

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: la ventanilla por dentro {#bloque-1}

#### Cómo se cruza la frontera

Tu programa corre en modo usuario y el kernel en modo núcleo. Entre los dos hay una frontera que el procesador hace cumplir. La pregunta es cómo se cruza, y la respuesta es más concreta de lo que parece.

Tu programa **no puede llamar a una función del kernel** como llama a un método normal: eso sería saltar a código privilegiado, y el procesador lo impide. Lo que hace es provocar deliberadamente una **interrupción por software**, también llamada **trap**:

```
1. El programa pone en registros del procesador el NUMERO de la llamada
   que quiere (por ejemplo 1 = write) y sus argumentos.
2. Ejecuta una instruccion especial (syscall).
3. El procesador CAMBIA A MODO NUCLEO y salta a una direccion fija
   que el kernel registro al arrancar.
4. El kernel mira el numero, busca en su tabla, y ejecuta la funcion.
5. Al terminar, deja el resultado en un registro y regresa a MODO USUARIO,
   en la instruccion siguiente del programa.
```

Ese ida y vuelta es lo que cuesta. No es carísimo (del orden de **1 a 2 microsegundos**), pero comparado con una llamada a método normal, que son nanosegundos, es **mil veces más caro**. Y ahí está la clave de toda la semana: **las llamadas al sistema son caras en cantidad, no en tamaño**. Escribir 4 KB de una vez cuesta casi lo mismo que escribir 1 byte.

Guárdate esa frase, porque es la que explica el buffering entero.

#### Los descriptores de archivo

Cuando tu programa abre un archivo, el kernel no le devuelve una dirección ni un objeto: le devuelve **un número entero**, el **descriptor de archivo** (*file descriptor*, `fd`). Ese número es un índice en una tabla que el kernel mantiene para tu proceso, y que ya viste mencionada en la semana 3, entre lo que guarda el descriptor de proceso.

Todo proceso arranca con tres descriptores abiertos:

| `fd` | Nombre | Qué es | En Java |
|---|---|---|---|
| **0** | Entrada estándar (`stdin`) | De dónde lee | `System.in` |
| **1** | Salida estándar (`stdout`) | A dónde escribe | `System.out` |
| **2** | Salida de errores (`stderr`) | A dónde reporta errores | `System.err` |

Y aquí encaja algo que usaste desde la semana 2 sin entenderlo:

```bash
java ServidorPedidos > ../datos/servidor.log 2>&1 &
```

Ese `2>&1` dice literalmente "**haz que el descriptor 2 apunte a donde apunta el 1**". Por eso los errores acaban en el mismo archivo. No es sintaxis mágica: son los números de la tabla.

Puedes ver los descriptores abiertos de tu servidor en marcha:

```bash
ls -l /proc/TU_PID/fd
```

```
lrwx------ 1 karlos karlos 64 ... 0 -> /dev/pts/0
lrwx------ 1 karlos karlos 64 ... 1 -> /home/karlos/so-proyecto/datos/servidor.log
lrwx------ 1 karlos karlos 64 ... 2 -> /home/karlos/so-proyecto/datos/servidor.log
l-wx------ 1 karlos karlos 64 ... 5 -> /home/karlos/so-proyecto/datos/recibos/r-1.txt
```

Cada archivo que abres y no cierras ocupa un descriptor, y **hay un límite**:

```bash
ulimit -n
```

Suele ser 1024. Un servidor que abre un archivo por pedido y no lo cierra se muere con `Too many open files` después de 1024 pedidos. Es exactamente el mismo tipo de agotamiento de recurso que los PIDs con los zombis en la semana 2: un descuido que se cobra horas después.

#### Las llamadas que te importan

De los cientos que hay, con estas entiendes tu servidor:

| Llamada | Qué hace | Cuándo la vas a ver |
|---|---|---|
| `openat` | Abre un archivo y devuelve un `fd` | Al cargar el catálogo, al crear un recibo |
| `read` | Lee bytes de un `fd` | Al leer el catálogo o los pedidos |
| `write` | Escribe bytes a un `fd` | Cada `System.out.println`, cada recibo |
| `close` | Cierra un `fd` y lo libera | Al terminar con un archivo |
| `lseek` | Mueve la posición dentro del archivo | Semana 15, para el índice |
| `fsync` | Fuerza que lo escrito llegue **al disco físico** | Cuando de verdad no se puede perder |
| `mmap` | Mapea un archivo en memoria | La JVM la usa muchísimo al arrancar |
| `futex` | Espera y despierta hilos | **Tus candados de la semana 6, por debajo** |

Esa última fila vale la pena: cuando en la semana 6 un hilo se bloqueó esperando un `synchronized`, lo que pasó por debajo fue una llamada `futex`. La vas a ver aparecer en tu `strace` y ahí se cierra el círculo entre la Unidad 2 y la 4.

#### El buffering, y el misterio del log vacío

Ahora sí, la explicación de la semana 2.

Si las llamadas al sistema son caras en cantidad, escribir un `println` de 30 caracteres directo al disco es un desperdicio: pagas la ida y vuelta al kernel para mover 30 bytes. La solución universal es el **buffer**: acumular en memoria y escribir cuando haya suficiente.

Hay **dos niveles de buffer**, y confundirlos es lo que produce la mitad de los problemas:

| Nivel | Dónde vive | Quién lo maneja | Cómo se vacía |
|---|---|---|---|
| **Buffer de la aplicación** | En tu proceso, en el heap | Java (`BufferedWriter`, `PrintStream`) | `flush()`, `close()`, o cuando se llena |
| **Caché del kernel** | En el kernel | El SO | `fsync()`, o cuando el SO decide |

Cuando llamas a `write`, los datos **no llegan al disco**: llegan a la caché del kernel, que los escribirá cuando le convenga. Si la máquina se apaga de golpe en ese momento, se pierden. Por eso existe `fsync`, y por eso las bases de datos lo llaman en cada transacción confirmada.

Y ahora el misterio. En la semana 2 hiciste esto:

```bash
java ServidorPedidos > ../datos/servidor.log 2>&1 &
tail -f ../datos/servidor.log      # vacio, o muy atrasado
```

La razón es que **`System.out` cambia de comportamiento según a dónde apunte**:

| Salida conectada a | Modo de buffer | Se ve de inmediato? |
|---|---|---|
| Una terminal | Por líneas | Sí, cada `\n` la vacía |
| Un archivo o una tubería | Por bloques (unos 8 KB) | **No.** Hasta juntar 8 KB o cerrar |

Cuando redirigiste a un archivo, Java pasó a modo bloque: tu servidor imprimía, los datos se quedaban en el buffer de la aplicación, y el archivo seguía vacío. Al matar el proceso con `Ctrl + C` o al llenarse el buffer, aparecía todo de golpe.

**No era un error de tu programa. Era una optimización funcionando exactamente como está diseñada.** Y la solución es una línea, que vas a poner en el bloque 2:

```java
// Un PrintStream con autoflush: vacia en cada linea, siempre
System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true));
```

O, en el lugar correcto, un `flush()` explícito cuando importa.

Y ahí está la decisión de ingeniería de la semana, que no tiene respuesta única: **buffer grande es rápido y pierde datos; buffer chico es lento y seguro.** Un log de depuración quiere lo primero; un recibo fiscal quiere lo segundo.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **La explicación del log vacío de la semana 2**, con tus palabras y con los dos niveles de buffer. Di exactamente en cuál de los dos se quedaron tus líneas.

2. **Los descriptores de tu servidor.** Córrelo, saca `ls -l /proc/TU_PID/fd` y explica qué es cada uno de los que aparecen. Si tienes más de tres, di de dónde salió cada extra.

3. **Tu decisión de buffering, por tipo de dato.** Con tu dominio:

   | Qué escribe mi servidor | Se puede perder si se apaga la máquina? | Buffer o `flush` inmediato? |
   |---|---|---|
   | El log de actividad | | |
   | El recibo de una venta | | |
   | El descuento del inventario | | |

   La segunda columna es la que decide, y hay que justificarla con el negocio, no con el rendimiento.

```bash
git add .
git commit -m "s13 bloque 1: llamadas al sistema, descriptores y buffering"
git push
```

---

### Bloque 2: los recibos, vistos con strace {#bloque-2}

#### El gestor de archivos

Crea `src/GestorArchivos.java`. Es la pieza que concentra toda la escritura a disco de tu servidor, y va a crecer en la semana 15:

```java
// GestorArchivos.java - toda la escritura a disco del servidor
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class GestorArchivos {

    private final Path carpetaRecibos;
    private final BufferedWriter log;

    public GestorArchivos(String carpetaDatos) throws IOException {

        this.carpetaRecibos = Path.of(carpetaDatos, "recibos");
        Files.createDirectories(carpetaRecibos);      // openat + mkdir

        // El log se abre UNA vez y se mantiene abierto: un solo descriptor
        // para toda la vida del servidor, en vez de abrir y cerrar por linea.
        this.log = new BufferedWriter(
                new FileWriter(Path.of(carpetaDatos, "pedidos.log").toFile(), true));
    }

    // Un recibo por venta. Archivo nuevo cada vez.
    public synchronized void escribirRecibo(Pedido p, double total) throws IOException {

        Path archivo = carpetaRecibos.resolve("recibo-" + p.getId() + ".txt");

        // TODO: escribe el recibo de TU dominio. Minimo:
        //       encabezado con el nombre del negocio, fecha y hora,
        //       el producto, la cantidad, el precio unitario y el total.
        //       pista: Files.writeString(archivo, contenido)
    }

    // Una linea por pedido en el log comun.
    public synchronized void registrarPedido(Pedido p, boolean aceptado) throws IOException {

        String linea = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)
                + ";" + p.getId()
                + ";" + p.getProducto()
                + ";" + p.getCantidad()
                + ";" + (aceptado ? "ATENDIDO" : "RECHAZADO");

        log.write(linea);
        log.newLine();

        // TODO: decide si aqui va un log.flush() o no.
        //       Escribe tu razon en la bitacora. Las dos son defendibles,
        //       pero tienes que saber cual elegiste y que estas arriesgando.
    }

    public synchronized void cerrar() throws IOException {
        log.flush();       // lo que quede en el buffer, al kernel
        log.close();       // y liberamos el descriptor
    }
}
```

Los dos `synchronized` no son decoración: varios hilos van a llamar a estos métodos a la vez, y sin protección el log queda con líneas entrelazadas. Es la semana 6 aplicada a un recurso nuevo. **Ojo con el orden de candados de la semana 7**: si dentro de la sección crítica del inventario llamas al gestor de archivos, ahí tienes dos candados anidados. Revísalo contra tu orden global.

Conéctalo en tu servidor: créalo al arrancar, llama a `escribirRecibo` cuando una venta se confirma, a `registrarPedido` siempre, y a `cerrar()` desde el shutdown hook de la semana 8.

#### Ahora míralo con `strace`

`strace` intercepta y muestra **todas las llamadas al sistema** que hace un proceso. Es la herramienta que hace visible lo que hasta hoy era teoría.

Empieza con algo chico, para aprender a leerlo:

```bash
cd ~/so-proyecto/src
strace -f -e trace=openat,read,write,close java Vacio 2>&1 | tail -30
```

| Opción | Qué hace |
|---|---|
| `-f` | Sigue también los **hilos**. Sin esto no ves casi nada de una JVM |
| `-e trace=...` | Filtra a las llamadas que te interesan. Sin filtro son miles |
| `-c` | Cuenta en vez de listar (bloque extra) |
| `-p PID` | Se engancha a un proceso **ya corriendo** |
| `-T` | Muestra cuánto tardó cada llamada |

Vas a ver algo así:

```
openat(AT_FDCWD, "/home/karlos/so-proyecto/datos/recibos/recibo-1.txt",
       O_WRONLY|O_CREAT|O_TRUNC, 0666) = 5
write(5, "FARMACIA SALUDYA\nRecibo 1\n...", 128) = 128
close(5)                                = 0
write(1, "[14:22:03.412] pedido-1 termino\n", 32) = 32
```

Léelo así: `openat` devolvió **5**, que es el descriptor. El `write` usa ese 5 y devuelve 128, que son los bytes escritos. `close(5)` lo libera y devuelve 0, que es éxito. Y el último `write` usa el descriptor **1**, la salida estándar.

**Ahí está el recibo de tu venta, convertido en tres llamadas al sistema.** Eso es todo lo que ocurre por debajo.

#### La corrida completa

```bash
cd ~/so-proyecto
strace -f -e trace=openat,write,close -o evidencias/strace.txt \
  java -cp src ServidorPedidos < <(java -cp src GeneradorPedidos 5)

wc -l evidencias/strace.txt
grep -c "recibo-" evidencias/strace.txt
grep "write(1," evidencias/strace.txt | wc -l
```

Con `-o` la salida va a un archivo y no se mezcla con la de tu programa, que si no se vuelve ilegible.

**Lo que entregas de este bloque**

1. `src/GestorArchivos.java` con los dos `TODO` resueltos.
2. `datos/recibos/` con al menos 5 recibos generados. Sube 2 o 3 de ejemplo, no los 200.
3. `datos/pedidos.log` con las líneas de la corrida.
4. `evidencias/strace.txt` con la corrida completa.

5. En `BITACORA.md`, bajo `### Antes de la clase`:
   - **Las tres líneas de `strace` de un recibo tuyo** (`openat`, `write`, `close`), pegadas, y la explicación de qué significa cada número.
   - **Cuántas llamadas `write` hizo tu servidor** para 5 pedidos y cuántas de ellas fueron al descriptor 1 contra a los recibos.
   - **Qué decidiste con el `flush` del log** y qué estás arriesgando con esa decisión.
   - **Busca una llamada `futex` en tu `strace`** y explica de dónde salió. (Pista: la semana 6.)

```bash
git add .
git commit -m "s13 bloque 2: recibos y llamadas al sistema con strace"
git push
```

---

### Bloque extra: contar las llamadas con strace -c {#bloque-extra}

Opcional. Listar llamadas sirve para entender; **contarlas** sirve para decidir.

```bash
strace -f -c -o evidencias/strace_resumen.txt java -cp src ServidorPedidos ...
cat evidencias/strace_resumen.txt
```

```
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 41.23    0.018432          12      1502           write
 22.10    0.009876          19       512           openat
 15.44    0.006901           4      1502           close
 ...
```

Ahora la medición que importa. Compara **con y sin buffer** en el log:

**Versión A, sin buffer:** cambia el `BufferedWriter` por un `FileWriter` directo y pon `flush()` en cada línea.

**Versión B, con buffer:** como está, con `BufferedWriter` de 8 KB y sin `flush` por línea.

```bash
for v in A B; do
  echo "===== version $v ====="
  strace -f -c -e trace=write java -cp src ServidorPedidos ... 2>&1 | tail -5
done
```

| | Llamadas `write` | Tiempo en `write` | Tiempo total del programa | Bytes por `write` |
|---|---|---|---|---|
| Sin buffer (`flush` por línea) | | | | |
| Con buffer (8 KB) | | | | |

La diferencia típica es de **uno o dos órdenes de magnitud** en el número de llamadas. Mismos datos escritos, mismo resultado en el archivo, mil veces menos cruces de la frontera.

Y para cerrar, mide el nivel de abajo. Agrega un `fsync` de verdad, que fuerza la escritura al disco físico:

```java
try (FileOutputStream fos = new FileOutputStream(archivo)) {
    fos.write(contenido.getBytes());
    fos.getFD().sync();          // fsync: hasta el disco, de verdad
}
```

| | Recibos por segundo |
|---|---|
| Con buffer, sin `fsync` | |
| Sin buffer, sin `fsync` | |
| Con `fsync` en cada recibo | |

El tercero va a ser dramáticamente más lento, y esa es la lección final: **la seguridad de los datos se paga en rendimiento, siempre**. Cuando una base de datos te dice que confirmó una transacción, pagó ese precio. Cuando tu servidor dice que guardó un recibo y no hizo `fsync`, te está diciendo "se lo di al kernel", que no es lo mismo.

Anota tu decisión: **tus recibos llevan `fsync` o no?** En una farmacia con receta controlada la respuesta puede no ser la misma que en un puesto de tacos.

```bash
git add .
git commit -m "s13 extra: conteo de llamadas y costo del fsync"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu servidor emitiendo recibos y con tu `strace`. Hoy espiamos procesos ajenos y medimos el costo real de cruzar la frontera.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. El misterio del log vacío, resuelto en vivo

Reproduzcan el fenómeno de la semana 2, ahora sabiendo qué pasa:

```bash
cd ~/so-proyecto/src

# A la terminal: se ve al instante
java ServidorPedidos < /dev/null &

# A un archivo: no se ve
java ServidorPedidos < /dev/null > /tmp/vacio.log 2>&1 &
sleep 5
wc -c /tmp/vacio.log        # cero, o casi
```

Ahora las tres formas de destaparlo, y comparen:

```bash
# 1. Matarlo: el buffer se vacia al cerrar
kill %2; wc -c /tmp/vacio.log

# 2. stdbuf, que le cambia el modo de buffer desde fuera
stdbuf -oL java ServidorPedidos < /dev/null > /tmp/lineas.log 2>&1 &

# 3. El autoflush en el codigo
# System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true));
```

Y para ver el buffer llenándose de verdad, con `strace` enganchado a un proceso vivo:

```bash
strace -p $(pgrep -f ServidorPedidos) -e trace=write
```

Van a ver que **no hay un `write` por cada línea que imprime**: hay uno cada tanto, con miles de bytes de golpe. Ese es el buffer vaciándose, en directo.

#### 2. Espiar un proceso ajeno

Por parejas. Uno corre su servidor, el otro se engancha desde fuera **sin tener el código**:

```bash
strace -f -p $(pgrep -f ServidorPedidos) -e trace=openat,write,close -T
```

Con eso hay que contestar tres preguntas sobre un programa que no escribiste:

1. **Qué archivos abre** y en qué orden.
2. **Cuántas veces escribe por pedido** y a qué descriptores.
3. **Cuál es la llamada más lenta** (la columna de `-T`).

Esto es exactamente lo que se hace para diagnosticar un binario del que no tienes el fuente, que en soporte y en operaciones pasa todo el tiempo.

#### 3. La medición del costo del cruce

Un programa que escribe un millón de bytes de tres formas distintas. Cada quien lo corre:

```java
// CostoIO.java
public static void main(String[] args) throws Exception {
    int n = 100000;
    byte[] dato = "linea de prueba del servidor\n".getBytes();

    // A: sin buffer, una llamada por linea
    long t1 = System.nanoTime();
    try (FileOutputStream f = new FileOutputStream("/tmp/a.txt")) {
        for (int i = 0; i < n; i++) f.write(dato);
    }
    long t2 = System.nanoTime();

    // B: con buffer de 8 KB
    try (BufferedOutputStream f = new BufferedOutputStream(
             new FileOutputStream("/tmp/b.txt"), 8192)) {
        for (int i = 0; i < n; i++) f.write(dato);
    }
    long t3 = System.nanoTime();

    // C: con buffer y fsync al final
    try (FileOutputStream fos = new FileOutputStream("/tmp/c.txt");
         BufferedOutputStream f = new BufferedOutputStream(fos, 8192)) {
        for (int i = 0; i < n; i++) f.write(dato);
        f.flush();
        fos.getFD().sync();
    }
    long t4 = System.nanoTime();

    System.out.println("sin buffer: " + (t2-t1)/1_000_000 + " ms");
    System.out.println("con buffer: " + (t3-t2)/1_000_000 + " ms");
    System.out.println("con fsync:  " + (t4-t3)/1_000_000 + " ms");
}
```

Y el conteo de llamadas de cada versión:

```bash
strace -c -e trace=write java CostoIO 2>&1 | tail -5
```

Al pizarrón las tres columnas de todo el grupo. La conversación: **por qué la versión con buffer escribe los mismos bytes con mil veces menos llamadas**, y por qué eso se traduce en tiempo.

#### 4. El servidor que se queda sin descriptores

Demostración del límite. Un programa que abre archivos y no los cierra:

```java
// FugaDescriptores.java
List<FileOutputStream> abiertos = new ArrayList<>();
int i = 0;
while (true) {
    abiertos.add(new FileOutputStream("/tmp/fd-" + i + ".txt"));
    if (i % 100 == 0) System.out.println("abiertos: " + i);
    i++;
}
```

```bash
ulimit -n                      # el limite, tipicamente 1024
java FugaDescriptores
```

Muere con `Too many open files` cerca del límite. Compruébenlo con `ls /proc/PID/fd | wc -l` mientras corre.

En tu servidor: **si abres un archivo por recibo y no lo cierras, cuántos pedidos aguantas?** Ese número es el mismo tipo de límite que los PIDs de la semana 2 y las pilas de hilos de la semana 11. Es el patrón de la Unidad 3 y 4 completo: **todo recurso del SO es finito, y todo descuido lo agota**.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu servidor emitiendo un recibo por venta confirmada** en `datos/recibos/`, con el formato de tu dominio, y registrando todos los pedidos en `datos/pedidos.log`.

2. **Cierra todo lo que abres.** Usa `try-with-resources` en cada escritura de recibo, y el `cerrar()` del gestor desde el shutdown hook. Comprueba con `ls /proc/TU_PID/fd | wc -l` que el número no crece con la carga: si crece, tienes una fuga de descriptores.

3. **Arregla el log de tu servidor** para que se pueda seguir con `tail -f`. Ya sabes por qué no se veía y ya sabes las tres formas de arreglarlo: elige una y explica en la bitácora por qué esa.

4. **Deja `datos/recibos/` con unos pocos ejemplos** en el repositorio, no con doscientos. Agrega un `.gitignore` si hace falta.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es una llamada al sistema y qué pasa exactamente cuando se hace una, paso por paso.
   - Qué son los descriptores 0, 1 y 2, y qué significa `2>&1`.
   - Los dos niveles de buffer, con la explicación del log vacío de la semana 2.
   - Cuántas llamadas al sistema cuesta un recibo tuyo, con tu conteo.

   ```bash
   git add .
   git commit -m "s13 proyecto: recibos, log y control de descriptores"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

La revisión de la semana 14 es la siguiente. Este es el último avance antes de ella.

1. **Cada sucursal emite sus propios recibos**, en su propia carpeta, con su propio formato de encabezado. El Servidor Central lleva el log consolidado de las tres.

2. **Midan el costo de E/S del sistema completo** con `strace -c` sobre los cuatro procesos, y guarden el resumen. Con tres sucursales escribiendo a la vez, cuántas llamadas `write` por segundo produce el sistema?

3. **Cada integrante actualiza su archivo de autoevaluación entre pares** y hace push antes de la revisión.

4. **Repasen la lista de la [semana 14](/curso/so/semana-14)** y marquen qué falta. Es el momento de preguntar, no el día de la revisión.
