---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 15 - Sistemas de archivos (U5)

La semana pasada tu servidor empezó a escribir en disco y viste las llamadas al sistema que lo hacen posible. Esta semana vas un nivel más abajo: **qué es de verdad un archivo** para el sistema operativo, y por qué las respuestas te van a sorprender. Un archivo no tiene nombre. Borrar un archivo no borra su contenido. Dos nombres distintos pueden ser el mismo archivo, y un archivo de un gigabyte puede ocupar cero bytes en disco.

Y la parte práctica es la que tu servidor necesita de verdad. Tu `pedidos.log` crece indefinidamente, y buscar un pedido ahí significa leerlo entero desde el principio. Con 100000 pedidos eso deja de funcionar. Vas a construir un **índice** que te lleve directo a la línea que buscas, saltándote todo lo demás, y a medir cuánto ganas.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: qué es un archivo por dentro](#bloque-1)
    - [Bloque 2: el log en append y el índice](#bloque-2)
    - [Bloque extra: secuencial contra seek en 100000 líneas](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes inodos, enlaces y cómo mide el espacio Linux | Tu análisis de `stat`, `df` y `du` de tu proyecto |
| 2 | Escribes el log en append y le construyes un índice | `src/GestorArchivos.java` y `evidencias/indice.txt` |
| Extra | Mides búsqueda secuencial contra acceso directo | Tu tabla de tiempos con 100000 líneas |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: qué es un archivo por dentro {#bloque-1}

#### El inodo

En Linux, un archivo **no es el nombre**. El nombre está en otro lado.

Un archivo es una estructura del sistema de archivos llamada **inodo** (*index node*), que contiene todo lo que se sabe del archivo **menos su nombre**:

| El inodo guarda | El inodo NO guarda |
|---|---|
| Tipo (archivo, directorio, enlace, tubería) | **El nombre** |
| Permisos y dueño | La ruta |
| Tamaño en bytes | |
| Fechas de acceso, modificación y cambio | |
| Número de enlaces que apuntan a él | |
| **Las direcciones de los bloques de datos en el disco** | |

Y entonces dónde está el nombre? En el **directorio**. Un directorio es simplemente un archivo especial que contiene una lista de pares:

```
nombre                 numero de inodo
------------------     ---------------
pedidos.log            1573922
catalogo.txt           1573925
recibos                1573930
```

O sea que **el nombre es una propiedad del directorio, no del archivo**. Míralo en tu proyecto:

```bash
cd ~/so-proyecto/datos
ls -li
```

```
1573922 -rw-r--r-- 1 karlos karlos  4821 nov 12 14:22 pedidos.log
1573925 -rw-r--r-- 1 karlos karlos   312 nov 12 09:15 catalogo.txt
```

Esa primera columna es el número de inodo. Y con `stat` ves el inodo completo:

```bash
stat pedidos.log
```

```
  File: pedidos.log
  Size: 4821       Blocks: 16         IO Block: 4096   regular file
Device: 8,32   Inode: 1573922     Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/ karlos)   Gid: ( 1000/ karlos)
Access: 2026-11-12 14:22:31
Modify: 2026-11-12 14:22:31
Change: 2026-11-12 14:22:31
```

Fíjate en `Blocks: 16` y en `IO Block: 4096`. El archivo mide 4821 bytes pero el disco no se reparte por bytes: se reparte por **bloques**. Un archivo de 1 byte ocupa un bloque completo. Es la misma idea de las páginas de memoria de la semana 11, aplicada al disco.

Y en las tres fechas hay una distinción que confunde a todos:

| Campo | Cambia cuando... |
|---|---|
| `Access` (atime) | Se **lee** el archivo |
| `Modify` (mtime) | Cambia el **contenido** |
| `Change` (ctime) | Cambia el **inodo**: permisos, dueño, o el contenido |

Renombrar un archivo cambia el `ctime` pero no el `mtime`, porque el contenido no se tocó.

#### Enlaces duros y simbólicos

De separar nombre y archivo sale una consecuencia interesante: **un mismo inodo puede tener varios nombres**.

```bash
cd /tmp
echo "un pedido" > original.txt
ln original.txt duro.txt          # enlace duro: otro nombre, mismo inodo
ln -s original.txt suave.txt      # enlace simbolico: un archivo que apunta al nombre
ls -li original.txt duro.txt suave.txt
```

```
1573940 -rw-r--r-- 2 karlos karlos  10 ... original.txt
1573940 -rw-r--r-- 2 karlos karlos  10 ... duro.txt
1573941 lrwxrwxrwx 1 karlos karlos  12 ... suave.txt -> original.txt
```

`original.txt` y `duro.txt` tienen **el mismo número de inodo**: son dos nombres del mismo archivo, con los mismos derechos. Ninguno es "el original". Y fíjate en la columna de enlaces: dice **2**.

`suave.txt` tiene otro inodo: es un archivo distinto cuyo contenido es la ruta del primero.

Ahora la prueba que aclara todo:

```bash
rm original.txt
cat duro.txt      # "un pedido". Sigue ahi
cat suave.txt     # error: No such file or directory
```

**Borrar no borra el archivo: borra un nombre.** La llamada al sistema se llama `unlink`, y lo que hace es quitar la entrada del directorio y restarle uno al contador de enlaces del inodo. El contenido se libera **solo cuando el contador llega a cero**.

Y aquí está la consecuencia que de verdad te va a servir en un servidor: **un archivo abierto por un proceso también cuenta como referencia**. Si borras el log de un servidor que lo tiene abierto, el nombre desaparece de `ls` pero el proceso sigue escribiendo, y **el espacio no se libera**. Es la causa clásica del disco lleno que no se arregla borrando nada: `du` no ve el archivo, `df` dice que no hay espacio, y nadie entiende. Se resuelve reiniciando el proceso, y el diagnóstico es:

```bash
lsof +L1        # archivos abiertos con cero enlaces
```

#### `df` contra `du`

Dos herramientas para medir espacio que responden preguntas distintas y siempre discrepan un poco:

```bash
df -h ~/so-proyecto      # cuanto queda en el sistema de archivos completo
du -sh ~/so-proyecto     # cuanto ocupa este directorio
du -h --max-depth=1 ~/so-proyecto | sort -h
```

`df` le pregunta al sistema de archivos cuántos bloques tiene libres. `du` recorre los archivos y suma. Discrepan por archivos borrados pero abiertos, por espacio reservado para el administrador, y por los bloques a medio llenar.

Hay otro recurso que se puede agotar y que casi nadie mira: **los inodos**.

```bash
df -i ~/so-proyecto
```

Un sistema de archivos tiene un número fijo de inodos, decidido al formatearlo. Si tu servidor crea un recibo por venta y nunca los borra, **puedes quedarte sin inodos con el disco medio vacío**: millones de archivos diminutos consumen millones de inodos. El síntoma es "No space left on device" con `df -h` mostrando 40% libre, y es de los diagnósticos que más rápido te distinguen.

#### El acceso directo: `seek`

Lo último, y es lo que necesitas para el bloque 2.

Un archivo abierto tiene una **posición actual**, y cada `read` o `write` avanza desde ahí. La llamada `lseek` mueve esa posición **a donde quieras, sin leer nada en el camino**.

Eso es lo que separa el acceso **secuencial** del **directo**:

| | Secuencial | Directo (con `seek`) |
|---|---|---|
| Para llegar al byte 900000 | Lee 900000 bytes | Salta ahí |
| Costo | Proporcional a la posición | Constante |
| Sirve para | Recorrer todo | Ir a un lugar conocido |

Y la condición para usar el directo es tener **el número de byte donde empieza lo que buscas**. Ese número se llama **desplazamiento** (*offset*), y guardarlos es exactamente lo que hace un índice. Es la misma idea que hay debajo de un índice de base de datos.

En Java, `RandomAccessFile`:

```java
RandomAccessFile raf = new RandomAccessFile("datos/pedidos.log", "r");
raf.seek(900000);            // lseek: la posicion, sin leer nada
String linea = raf.readLine();
```

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **El inodo de tu `pedidos.log`.** Pega la salida de `stat` y explica: su número de inodo, su tamaño en bytes contra sus bloques, y qué significa que `Links` diga 1.

2. **La prueba del enlace duro, hecha por ti.** Haz el experimento de arriba con un archivo de tu proyecto (una copia, no el original) y pega las salidas de `ls -li` antes y después del `rm`. Explica **por qué el contenido sobrevivió**.

3. **El espacio de tu proyecto:**

   | Medida | Valor |
   |---|---|
   | `du -sh` de `so-proyecto` | |
   | `du -sh` de `datos/recibos` | |
   | Cuántos recibos hay | |
   | Espacio promedio por recibo | |
   | Inodos usados en el sistema (`df -i`) | |

   Y la pregunta: si tu servidor emite 500 recibos al día durante un año, **cuánto espacio y cuántos inodos consume?** Con tus números.

```bash
git add .
git commit -m "s15 bloque 1: inodos, enlaces y espacio en disco"
git push
```

---

### Bloque 2: el log en append y el índice {#bloque-2}

#### Por qué append

Tu log tiene que cumplir dos cosas que se pelean entre sí: no perder nada, y no volverse lento. La estructura que resuelve las dos es el **append-only**: solo se escribe al final, nunca se modifica lo escrito.

Es la estructura de datos más usada en sistemas de verdad: los logs de transacciones de las bases de datos, Kafka, el journal de los sistemas de archivos. Y las razones son concretas:

- **Escribir al final es la operación más barata** que hay en un disco.
- **No hay que sincronizar posiciones**: el sistema de archivos garantiza que dos `write` en modo append no se pisan.
- **Lo escrito nunca cambia**, así que un índice de posiciones no se invalida.

Esa última es la que hace posible el resto del bloque.

#### El log con índice

Amplía `src/GestorArchivos.java`:

```java
// GestorArchivos.java - log append-only con indice de posiciones
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.HashMap;
import java.util.Map;

public class GestorArchivos {

    private final Path rutaLog;
    private final BufferedWriter log;

    // El indice: id del pedido -> byte donde empieza su linea en el log.
    private final Map<Integer, Long> indice = new HashMap<>();

    // Cuantos bytes lleva escritos el log. Es la posicion de la proxima linea.
    private long posicionActual;

    public GestorArchivos(String carpetaDatos) throws IOException {

        this.rutaLog = Path.of(carpetaDatos, "pedidos.log");
        Files.createDirectories(Path.of(carpetaDatos, "recibos"));

        // Si el log ya existia, arrancamos donde quedo y reconstruimos el indice.
        this.posicionActual = Files.exists(rutaLog) ? Files.size(rutaLog) : 0;
        if (posicionActual > 0) reconstruirIndice();

        // true = modo append. Nunca sobrescribe.
        this.log = new BufferedWriter(new FileWriter(rutaLog.toFile(), true));
    }

    public synchronized void registrarPedido(Pedido p, boolean aceptado)
            throws IOException {

        String linea = p.getId()
                + ";" + p.getProducto()
                + ";" + p.getCantidad()
                + ";" + (aceptado ? "ATENDIDO" : "RECHAZADO")
                + ";" + System.currentTimeMillis();

        // Apuntamos DONDE empieza esta linea antes de escribirla.
        indice.put(p.getId(), posicionActual);

        log.write(linea);
        log.newLine();
        log.flush();          // sin esto, posicionActual mentiria

        // +1 por el salto de linea. Ojo: solo vale si no hay acentos.
        posicionActual += linea.getBytes(StandardCharsets.UTF_8).length + 1;
    }

    // Busqueda DIRECTA: va al byte exacto, sin leer nada antes.
    public synchronized String buscarPedido(int id) throws IOException {

        Long posicion = indice.get(id);
        if (posicion == null) return null;

        try (RandomAccessFile raf = new RandomAccessFile(rutaLog.toFile(), "r")) {
            raf.seek(posicion);                    // lseek
            return raf.readLine();
        }
    }

    // Busqueda SECUENCIAL: lee desde el principio hasta encontrarlo.
    // La dejamos a proposito para poder comparar las dos.
    public String buscarPedidoSecuencial(int id) throws IOException {
        try (BufferedReader br = Files.newBufferedReader(rutaLog)) {
            String linea;
            while ((linea = br.readLine()) != null) {
                if (linea.startsWith(id + ";")) return linea;
            }
        }
        return null;
    }

    private void reconstruirIndice() throws IOException {
        // TODO: recorre el log desde el principio y llena el indice.
        //       Por cada linea, guarda el id y la posicion donde empezo.
        //       pista: lleva un contador de bytes, igual que posicionActual.
        //       Esto es lo que hace una base de datos al arrancar.
    }

    public synchronized void guardarIndice(String ruta) throws IOException {
        // TODO: escribe el indice a un archivo, una linea por "id;posicion".
        //       Asi el siguiente arranque no tiene que reconstruirlo leyendo
        //       el log completo.
    }

    public synchronized void cerrar() throws IOException {
        log.flush();
        log.close();
    }

    public synchronized int tamanoIndice() { return indice.size(); }
}
```

Dos cosas de ese código que merecen atención.

**El `flush()` obligatorio.** Si el `BufferedWriter` guarda la línea en memoria, el archivo todavía no la tiene, pero tu `posicionActual` ya avanzó. La siguiente búsqueda con `seek` iría a un byte que aún no existe. Es un ejemplo perfecto del choque entre los dos niveles de buffer de la semana 13: **si llevas la cuenta de posiciones, no puedes bufferizar**. Ahí está el precio del índice, y hay que saberlo.

**El `+1` por el salto de línea, y el `getBytes`.** El tamaño en bytes no es el número de caracteres. Una `á` ocupa dos bytes en UTF-8, y si cuentas caracteres tu índice se va desalineando poco a poco. Por eso hay que medir en bytes, y por eso conviene que los nombres de productos del log vayan sin acentos.

#### Pruébalo

Genera un log grande y busca en él:

```bash
cd ~/so-proyecto
java -cp src GeneradorPedidos 20000 | java -cp src ServidorPedidos RECHAZAR 4 1000

wc -l datos/pedidos.log
ls -lh datos/pedidos.log
```

Y una prueba de búsqueda, `src/PruebaIndice.java`:

```java
public class PruebaIndice {
    public static void main(String[] args) throws Exception {

        GestorArchivos ga = new GestorArchivos("datos");
        System.out.println("Indice reconstruido: " + ga.tamanoIndice() + " entradas");

        int[] buscar = {1, 5000, 10000, 19999};

        for (int id : buscar) {
            long t1 = System.nanoTime();
            String d = ga.buscarPedido(id);
            long t2 = System.nanoTime();

            long t3 = System.nanoTime();
            String s = ga.buscarPedidoSecuencial(id);
            long t4 = System.nanoTime();

            System.out.printf("id=%-6d directo=%6d us   secuencial=%8d us%n",
                    id, (t2-t1)/1000, (t4-t3)/1000);
        }
    }
}
```

```bash
java -cp src PruebaIndice > evidencias/indice.txt
cat evidencias/indice.txt
```

Lo que tiene que verse: el tiempo del **directo es igual para el id 1 que para el 19999**, y el del **secuencial crece con el id**. Esa es la diferencia entre tiempo constante y tiempo proporcional, medida en tu propia máquina.

**Lo que entregas de este bloque**

1. `src/GestorArchivos.java` con los dos `TODO` resueltos.
2. `src/PruebaIndice.java`.
3. `evidencias/indice.txt` con los tiempos.
4. `datos/pedidos.log` con una muestra (no subas 20000 líneas: recorta a 200 con `head`).

5. En `BITACORA.md`, bajo `### Antes de la clase`:

   | Id buscado | Directo (us) | Secuencial (us) | Factor |
   |---|---|---|---|
   | 1 | | | |
   | 5000 | | | |
   | 10000 | | | |
   | 19999 | | | |

   Y debajo:
   - **Por qué el directo tarda lo mismo siempre** y el secuencial no.
   - **Cuánto ocupa tu índice en memoria** (20000 entradas de `Integer` a `Long`) y por qué eso es un intercambio: gastas RAM para ahorrar disco. Es la misma decisión de la semana 11 con el catálogo.
   - **Por qué el índice obliga a hacer `flush` en cada línea**, y qué le cuesta eso a tu servidor en llamadas al sistema (recupera tu conteo de la semana 13).

```bash
git add .
git commit -m "s15 bloque 2: log append-only con indice de posiciones"
git push
```

---

### Bloque extra: secuencial contra seek en 100000 líneas {#bloque-extra}

Opcional. Con 20000 líneas la diferencia se ve. Con 100000 se vuelve la diferencia entre un sistema que sirve y uno que no.

```bash
cd ~/so-proyecto
java -cp src GeneradorPedidos 100000 | java -cp src ServidorPedidos RECHAZAR 4 5000
ls -lh datos/pedidos.log
```

Ahora barre las posiciones y mide las dos búsquedas en cada una:

| Posición buscada | Directo (us) | Secuencial (us) | Factor |
|---|---|---|---|
| Primera línea | | | |
| 25% | | | |
| 50% | | | |
| 75% | | | |
| Última línea | | | |
| **Promedio** | | | |

Grafícalo si hiciste el extra de la semana 12: el directo es una línea plana y el secuencial una recta que sube. Ver las dos curvas juntas explica el tema mejor que cualquier párrafo.

Y tres experimentos más que valen la pena:

**1. Con la caché del kernel fría.** Recuerda de la semana 11 que Linux cachea los archivos leídos. Tus mediciones están hechas con el log ya en RAM. Vacía la caché y repite:

```bash
sync; sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
java -cp src PruebaIndice
```

El secuencial se desploma mucho más que el directo, porque tiene que traer del disco todo lo que recorre. **El factor real, con disco frío, es mucho mayor que el que mediste.**

**2. Cuánto cuesta reconstruir el índice.** Mide el arranque de tu servidor con el log de 100000 líneas:

```bash
time java -cp src PruebaIndice
```

Reconstruir el índice es una lectura secuencial completa. Con un log de un año sería inviable, y por eso existe el `guardarIndice()`: se persiste y se carga. Compara los dos arranques.

**3. Qué pasa si el índice no cabe.** 100000 entradas caben en memoria. Mil millones no. Qué haría una base de datos? La respuesta es no tener el índice completo en RAM sino en disco, y en una estructura que permita buscar sin leerla entera: un **árbol B**. Eso ya no es este curso, pero ahora sabes exactamente qué problema resuelve y por qué.

```bash
git add .
git commit -m "s15 extra: secuencial contra directo en 100000 lineas"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu log indexado. Hoy rompemos cosas en el sistema de archivos y vemos por qué se rompen.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. El archivo borrado que no libera espacio

El diagnóstico clásico de un disco lleno, reproducido en clase. Cada quien:

```bash
cd /tmp
# Un proceso que escribe sin parar a un archivo
java -cp ~/so-proyecto/src EscritorInfinito > /tmp/grande.log &
PID=$!
sleep 10
ls -lh /tmp/grande.log
du -sh /tmp/grande.log

# Ahora lo borramos MIENTRAS el proceso lo tiene abierto
rm /tmp/grande.log
ls -lh /tmp/grande.log        # no existe
df -h /tmp                     # el espacio SIGUE ocupado
```

El archivo no está y el espacio no se libera. El diagnóstico:

```bash
lsof +L1 | head
ls -l /proc/$PID/fd | grep deleted
```

Ahí aparece, marcado `(deleted)`. Y se libera al matar el proceso:

```bash
kill $PID
df -h /tmp
```

**Este es el ejercicio más aplicable de la semana.** El día que un servidor de producción tenga el disco lleno y borrar logs no arregle nada, vas a saber por qué en treinta segundos.

#### 2. Quedarse sin inodos

Menos conocido y más desconcertante. Con cuidado, en un directorio propio:

```bash
mkdir -p /tmp/inodos && cd /tmp/inodos
df -i /tmp | head -2
for i in $(seq 1 50000); do touch r$i.txt; done
df -i /tmp | head -2
du -sh /tmp/inodos
```

50000 archivos vacíos: **casi cero bytes de datos, 50000 inodos consumidos**. En un sistema con pocos inodos libres, esto llena el disco sin llenar el disco.

En tu servidor: **un recibo por venta, 500 ventas al día**. En cuántos días llegas a 50000 archivos? Y qué harías al respecto? (Las respuestas reales: agrupar por mes en subdirectorios, comprimir los viejos, o guardar los recibos en un solo archivo con índice, que es justo lo que acabas de construir.)

Limpien con `rm -rf /tmp/inodos`.

#### 3. El índice desalineado

Rompan su índice a propósito para entender por qué funciona. Metan un acento en un nombre de producto del catálogo:

```
9;jarabe para la tós;45.00;10
```

Corran, generen pedidos de ese producto, y busquen un pedido **posterior** a ese en el log. La línea que devuelve el `seek` va a salir cortada o corrida.

Diagnóstico en el pizarrón: **cuántos bytes se desalineó y por qué**. La `ó` ocupa 2 bytes en UTF-8 y el `length()` de Java contó 1. Es un error real, difícil de encontrar, y la moraleja es de las que se quedan: **cuando cuentas posiciones en un archivo, cuentas bytes, nunca caracteres.**

#### 4. El log rotado

Último problema práctico. Un log que crece sin parar acaba llenando el disco, igual que la cola sin límite de la semana 12. La solución estándar es **rotarlo**:

```bash
# lo que hace logrotate, en esencia
mv datos/pedidos.log datos/pedidos.log.1
touch datos/pedidos.log
```

Háganlo **con el servidor corriendo** y observen:

```bash
ls -l /proc/$(pgrep -f ServidorPedidos)/fd
wc -l datos/pedidos.log         # sigue vacio
wc -l datos/pedidos.log.1       # aqui sigue escribiendo
```

El servidor **sigue escribiendo en el archivo viejo**, porque su descriptor apunta al inodo, no al nombre. Es exactamente lo del bloque 1 y ahora se ve por qué importa.

La solución de verdad: mandarle una señal al servidor para que cierre y reabra el log. Y eso es la semana 8. Si les da tiempo, impleméntenlo con un manejador de `SIGHUP`, que es literalmente para lo que se usa `SIGHUP` en los servidores reales.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu `pedidos.log` en modo append**, con el índice funcionando y persistido a disco con `guardarIndice()`, de modo que el servidor no tenga que reconstruirlo leyendo todo en cada arranque.

2. **Agrega la consulta de un pedido por id** a tu servidor: que al recibir una línea como `consulta 4711` responda con los datos de ese pedido, buscándolo con `seek`. Es la primera funcionalidad de tu servidor que **no es escribir**, y es la que justifica todo el índice.

3. **Resuelve el problema de los recibos.** Con lo que viste de inodos, decide qué haces con `datos/recibos/` a largo plazo y aplícalo: subdirectorios por fecha, o un solo archivo indexado. Justifícalo con tus números de la semana.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es un inodo y por qué el nombre no está en él.
   - Por qué borrar un archivo abierto no libera espacio, y cómo se diagnostica.
   - Por qué elegiste append-only para el log y qué te permite hacer.
   - Tu tabla de tiempos de búsqueda directa contra secuencial, con el factor.

   ```bash
   git add .
   git commit -m "s15 proyecto: log indexado y consulta por id"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **El Servidor Central lleva el log consolidado indexado** de las tres sucursales. Decidan cómo evitar que los ids se repitan entre sucursales: prefijo de sucursal, rangos asignados, o un id compuesto. Es un problema real de sistemas distribuidos y la solución que elijan hay que defenderla.

2. **Implementen la consulta cruzada:** un cajero de la sucursal 1 pregunta por un pedido de la sucursal 3, y el central lo encuentra con el índice. Es la primera vez que el sistema integrado hace algo que ninguna sucursal puede hacer sola.

3. **Preparen el terreno para la semana 16.** Hasta hoy las sucursales y el central se comunican por tuberías, lo que los obliga a estar en la misma máquina. La semana que viene eso cambia. Revisen su código y marquen **qué partes suponen que el otro proceso está local**: son las que van a tener que cambiar.
