---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 11 - Administración de memoria (U3)

Empieza la Unidad 3, y con ella el segundo gran servicio que tu servidor le pide al sistema operativo. Hasta hoy le pediste **existir y correr**; ahora le vas a pedir **memoria**, y vas a descubrir que casi nada de lo que creías sobre ella es cierto.

Tu servidor dice que reservó tres gigabytes y en realidad ocupa cuarenta megas. Cree que la memoria empieza en la dirección cero y no es así. Y cada vez que un cajero consulta un precio, tu servidor abre un archivo, lo lee entero y lo cierra, cosa que a diez consultas por segundo va a matarlo. Esta semana entiendes lo primero y arreglas lo último.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: memoria virtual, real y páginas](#bloque-1)
    - [Bloque 2: el catálogo en memoria](#bloque-2)
    - [Bloque extra: cuánto se gana con la caché](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes memoria virtual, páginas y por qué `VmSize` miente | Tu tabla de memoria de tu propio proceso |
| 2 | Metes el catálogo en memoria y mides el efecto | `src/GestorInventario.java` y `evidencias/memoria.txt` |
| Extra | Mides 10000 consultas contra archivo y contra caché | Tu tabla de rendimiento |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: memoria virtual, real y páginas {#bloque-1}

#### El problema que resuelve la memoria virtual

Vuelve a la semana 3, cuando dijimos que cada proceso cree que la memoria es suya y empieza en cero. Ahora toca ver cómo se logra eso, porque es una de las ideas más elegantes del sistema operativo.

Sin memoria virtual, cada programa tendría que saber en qué parte física de la RAM lo van a cargar, y dos programas no podrían usar las mismas direcciones. Peor: cualquier programa podría leer o escribir la memoria de otro, porque nada se lo impediría.

La solución es una **indirección**. Al proceso se le da un espacio de direcciones **virtual**, propio, que empieza en 0 y es enorme. Cuando el proceso accede a la dirección virtual 5000, el hardware la traduce a una dirección física real, que puede ser cualquier otra. La traducción la hace una pieza del procesador llamada **MMU** (unidad de gestión de memoria), consultando unas tablas que el SO mantiene para cada proceso.

```
   Proceso A                                    RAM fisica
   dir. virtual 5000  --+                    +-----------------+
                        |    tabla de        |  ...            |
                        +--> paginas de A -->|  marco 812      |
                                             |  ...            |
   Proceso B                                 |  marco 340      |
   dir. virtual 5000  --+    tabla de        |  ...            |
                        +--> paginas de B ---+
```

Dos procesos usando la misma dirección virtual, apuntando a lugares físicos distintos. Y **si una dirección virtual no está en la tabla, el acceso se rechaza**: ahí está el aislamiento de la semana 3, implementado en hardware.

#### Páginas y marcos

La traducción no se hace dirección por dirección, sería carísimo. Se hace por bloques de tamaño fijo:

- Una **página** es un bloque del espacio virtual. En Linux mide **4096 bytes** (4 KB).
- Un **marco** (*frame*) es un bloque del mismo tamaño en la RAM física.
- La **tabla de páginas** dice qué página va en qué marco.

Compruébalo en tu máquina:

```bash
getconf PAGESIZE
```

Y aquí viene lo importante: **una página puede no estar en RAM**. Puede estar en el disco, en el área de intercambio (*swap*), o simplemente no haber sido cargada todavía.

Cuando el proceso toca una dirección cuya página no está en RAM, el hardware genera un **fallo de página** (*page fault*), el SO interrumpe al proceso, trae la página del disco a un marco libre, actualiza la tabla y **reanuda el proceso justo donde iba**. El programa no se entera de nada, solo de que esa instrucción tardó muchísimo más.

Puedes ver los fallos de página de tu servidor:

```bash
ps -o pid,min_flt,maj_flt,cmd -C java
```

| Columna | Qué cuenta |
|---|---|
| `min_flt` | Fallos **menores**: la página estaba en RAM, solo faltaba mapearla. Rápido |
| `maj_flt` | Fallos **mayores**: hubo que ir al **disco**. Miles de veces más lento |

Los mayores son los que duelen. Si tu servidor tiene muchos, está pagando disco por cada acceso a memoria.

#### Reservado contra usado: por qué `VmSize` miente

Ahora sí, la explicación de aquel número que te sorprendió en el bloque extra de la semana 2, cuando `VmSize` decía 3.5 GB y `VmRSS` decía 48 MB.

| Campo | Qué mide | Por qué es tan grande o tan chico |
|---|---|---|
| `VmSize` | Todo el espacio de direcciones **reservado** | La JVM reserva de entrada un espacio enorme para el heap, aunque no lo use |
| `VmRSS` | Lo que de verdad ocupa en **RAM física** | Solo las páginas que se tocaron y están residentes |

**Reservar no es ocupar.** Reservar es apuntar en la tabla "esta zona es mía y nadie más la use". Ocupar es tener páginas de verdad en marcos de RAM. La JVM reserva gigabytes por si acaso, y va tocando lo que necesita.

Esto tiene una consecuencia que te importa como administrador de servidores: **si sumas el `VmSize` de todos los procesos te va a dar mucho más que la RAM de la máquina, y no pasa nada**. Es normal. El número que importa para saber si la máquina está apretada es `VmRSS`, y a nivel de sistema, `free`.

```bash
free -h
```

```
               total        used        free      shared  buff/cache   available
Mem:            7.7Gi       2.1Gi       3.2Gi       0.1Gi       2.4Gi       5.3Gi
Swap:           2.0Gi          0B       2.0Gi
```

La columna que hay que mirar es la última, **`available`**: cuánta memoria puede usar un proceso nuevo sin que la máquina empiece a sufrir. La de `free` a secas engaña, porque el SO usa toda la RAM que sobra como caché de disco (`buff/cache`) y la suelta en cuanto alguien la necesita. **RAM libre no es RAM bien usada; RAM libre es RAM desperdiciada**, y por eso Linux la llena de caché a propósito.

#### El swap

La fila `Swap` es un área del disco que el SO usa como extensión de la RAM. Cuando la memoria física se agota, el SO elige páginas que llevan tiempo sin usarse y **las escribe al disco** para liberar marcos.

Funciona, y salva a la máquina de morirse. Pero el disco es entre mil y cien mil veces más lento que la RAM, así que un sistema que empieza a usar swap intensamente entra en lo que se llama **hiperpaginación** (*thrashing*): pasa más tiempo moviendo páginas entre disco y RAM que ejecutando programas. Desde fuera se ve como una máquina que "se congeló" pero con el disco trabajando sin parar.

En un servidor de producción, **swap alto es una alarma**, no un alivio.

#### Dónde vive cada cosa de tu servidor

Para cerrar, el mapa de la semana 3 con los nombres de hoy:

| Zona | Qué guarda | Cuándo se libera |
|---|---|---|
| **Código** | Las instrucciones. Solo lectura | Al terminar el proceso |
| **Datos** | Variables estáticas y constantes | Al terminar el proceso |
| **Montón (heap)** | Todo lo que creas con `new`. **Tu `HashMap` del catálogo va aquí** | Cuando el recolector de basura ve que nadie lo referencia |
| **Pila (stack)** | Variables locales y llamadas a métodos. **Una por hilo** | Al salir del método, automáticamente |

Esa última fila explica algo de la semana 4: si cada hilo tiene su propia pila y una pila reserva del orden de un mega, **10000 hilos son 10 GB de pilas reservadas**. Ahí está la razón de fondo por la que un pool acotado no es un lujo.

**Lo que entregas de este bloque**

Corre tu servidor con carga y, mientras corre, saca estos datos:

```bash
grep -E "VmSize|VmRSS|VmData|VmStk|Threads" /proc/TU_PID/status
ps -o pid,min_flt,maj_flt,%mem -p TU_PID
free -h
```

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **La tabla de memoria de tu servidor**, con tus números:

   | Medida | Valor | Qué significa en mi servidor |
   |---|---|---|
   | `VmSize` | | |
   | `VmRSS` | | |
   | Proporción entre los dos | | |
   | Fallos menores | | |
   | Fallos mayores | | |

2. **Por qué `VmSize` es tanto mayor que `VmRSS`**, con tus palabras, y por qué eso no es un problema ni un desperdicio.

3. **Dónde vive cada cosa de tu sistema.** Con tu dominio:

   | Cosa | Zona | Por qué ahí |
   |---|---|---|
   | El `HashMap` con mi catálogo | | |
   | La variable local `cantidad` dentro de `vender` | | |
   | La constante con el nombre de mi negocio | | |
   | La pila del hilo que atiende el pedido 7 | | |

```bash
git add .
git commit -m "s11 bloque 1: memoria virtual, paginas y VmRSS"
git push
```

---

### Bloque 2: el catálogo en memoria {#bloque-2}

Ahora la aplicación directa. Tu servidor tiene un defecto de diseño que hasta hoy no importaba y a partir de hoy sí.

#### El problema

Si tu `GestorInventario` lee `datos/catalogo.txt` cada vez que necesita consultar un precio o una existencia, cada consulta cuesta: una llamada al sistema para abrir, varias para leer, una para cerrar, más el recorrido del archivo completo para encontrar una línea. Con un cajero no se nota. Con 50 cajeros y 20 consultas por segundo cada uno, tu servidor pasa el día leyendo el mismo archivo mil veces.

La solución es la **caché**: leer el archivo **una vez al arrancar**, tenerlo en memoria en una estructura de acceso rápido, y responder desde ahí.

#### El catálogo en un `HashMap`

Necesitas guardar más que la existencia: también el nombre y el precio. Crea una clase pequeña para eso, `src/Producto.java`:

```java
// Producto.java - una linea del catalogo, en memoria
public class Producto {

    private final int id;
    private final String nombre;
    private final double precio;
    private int existencia;

    // TODO: constructor, getters, y un setExistencia.
    //       Es Java que ya sabes: no lo pongo para que lo escribas tu.

    @Override
    public String toString() {
        return id + ";" + nombre + ";" + precio + ";" + existencia;
    }
}
```

Y cambia el mapa de tu `GestorInventario`:

```java
// Antes:  Map<String, Integer> existencias
// Ahora:  el catalogo completo en memoria, indexado por nombre
private final Map<String, Producto> catalogo = new HashMap<>();

// La carga ocurre UNA SOLA VEZ, al arrancar.
public synchronized void cargarDesde(String ruta) throws IOException {

    long inicio = System.currentTimeMillis();

    for (String linea : Files.readAllLines(Path.of(ruta))) {

        if (linea.isBlank() || linea.startsWith("#")) continue;

        // TODO: parte la linea en ID;NOMBRE;PRECIO;EXISTENCIA,
        //       construye el Producto y metelo al mapa con
        //       catalogo.put(nombre, producto)
    }

    long ms = System.currentTimeMillis() - inicio;
    System.out.println("Catalogo cargado: " + catalogo.size()
            + " productos en " + ms + " ms");
}

public synchronized boolean vender(String nombre, int cantidad) {

    Producto p = catalogo.get(nombre);        // O(1), sin tocar el disco
    if (p == null) { ventasRechazadas++; return false; }

    if (p.getExistencia() >= cantidad) {
        p.setExistencia(p.getExistencia() - cantidad);
        ventasConfirmadas++;
        return true;
    }
    ventasRechazadas++;
    return false;
}
```

Por qué un `HashMap` y no una lista: la búsqueda por clave es de tiempo **constante**, no depende de cuántos productos tengas. Con una `ArrayList` tendrías que recorrerla entera en cada consulta, y con 10000 productos eso sí se nota. Es estructuras de datos de segundo semestre, aplicado donde de verdad importa.

#### Mide el efecto en la memoria

Aquí está lo interesante de la semana: **la caché no es gratis, la pagas en RAM**. Vamos a ver cuánto.

Primero necesitas un catálogo grande de verdad. Genera uno de 50000 productos:

```bash
cd ~/so-proyecto/datos
cp catalogo.txt catalogo_original.txt
for i in $(seq 1 50000); do
  echo "$i;producto$i;$((RANDOM % 500 + 10)).50;$((RANDOM % 100))"
done > catalogo_grande.txt
wc -l catalogo_grande.txt
ls -lh catalogo_grande.txt
```

Ahora mide el `VmRSS` de tu servidor **antes y después** de cargar el catálogo. La forma más limpia es imprimirlo desde el propio programa:

```java
// Un metodo de utilidad, lo vas a usar el resto del semestre.
static void memoria(String etiqueta) {
    Runtime rt = Runtime.getRuntime();
    long usadaMB = (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024);
    System.out.println("[MEM] " + etiqueta + ": " + usadaMB + " MB en el heap");
}
```

Y desde fuera, con el proceso vivo:

```bash
grep VmRSS /proc/TU_PID/status
```

Llena la tabla con los dos catálogos:

| | Productos | `VmRSS` antes de cargar | `VmRSS` después | Diferencia | Tiempo de carga |
|---|---|---|---|---|---|
| `catalogo.txt` | ~8 | | | | |
| `catalogo_grande.txt` | 50000 | | | | |

**Lo que entregas de este bloque**

1. `src/Producto.java` completo.
2. `src/GestorInventario.java` con el catálogo en memoria y `cargarDesde` resuelto.
3. `datos/catalogo_grande.txt` **no** lo subas al repositorio: es grande y se regenera con el comando. En vez de eso, deja el comando en tu bitácora.
4. `evidencias/memoria.txt` con las salidas de `/proc/TU_PID/status`, `ps` y `free -h` con el catálogo grande cargado.

5. En `BITACORA.md`, bajo `### Antes de la clase`:
   - La tabla de arriba, con tus números.
   - **Cuánta RAM cuesta cada producto en memoria**, dividiendo la diferencia entre 50000. Compáralo con lo que ocupa esa misma línea en el archivo (`ls -l`). El número de memoria es mucho mayor: explica por qué (piensa en el objeto, las referencias, el `String`, la entrada del `HashMap`).
   - **Hasta cuántos productos podrías cachear** en una máquina con 2 GB disponibles para tu servidor, según tu medición.

```bash
git add .
git commit -m "s11 bloque 2: catalogo en memoria"
git push
```

---

### Bloque extra: cuánto se gana con la caché {#bloque-extra}

Opcional. Ya sabes lo que **cuesta** la caché en memoria. Ahora mide lo que **gana** en tiempo, que es la otra mitad de la decisión.

Escribe las dos versiones de la consulta. La mala, que lee el archivo cada vez:

```java
// ConsultaLenta.java - lee el archivo en CADA consulta
static double precioDesdeArchivo(String ruta, String nombre) throws IOException {
    for (String linea : Files.readAllLines(Path.of(ruta))) {
        String[] campos = linea.split(";");
        if (campos.length >= 3 && campos[1].equals(nombre)) {
            return Double.parseDouble(campos[2]);
        }
    }
    return -1;
}
```

Y la buena, que es el `catalogo.get(nombre)` de tu gestor.

Compara 10000 consultas de cada una:

```java
public static void main(String[] args) throws Exception {

    int consultas = 10000;
    String ruta = "../datos/catalogo_grande.txt";

    GestorInventario inv = new GestorInventario();
    inv.cargarDesde(ruta);

    // Consultas aleatorias, para no medir siempre la misma linea
    Random r = new Random(42);
    String[] nombres = new String[consultas];
    for (int i = 0; i < consultas; i++) {
        nombres[i] = "producto" + (r.nextInt(50000) + 1);
    }

    long t1 = System.nanoTime();
    for (String n : nombres) precioDesdeArchivo(ruta, n);
    long t2 = System.nanoTime();

    long t3 = System.nanoTime();
    for (String n : nombres) inv.precio(n);
    long t4 = System.nanoTime();

    System.out.println("Desde archivo: " + (t2 - t1) / 1_000_000 + " ms");
    System.out.println("Desde cache:   " + (t4 - t3) / 1_000_000 + " ms");
    System.out.println("Factor:        " + ((t2 - t1) / Math.max(t4 - t3, 1)));
}
```

Cuidado con una cosa al interpretar el resultado: **la versión "desde archivo" no está leyendo el disco 10000 veces**. Después de la primera lectura, el archivo se queda en la caché de disco del kernel (aquel `buff/cache` del `free -h`), así que estás midiendo memoria contra memoria. Aun así la diferencia es enorme, porque igual hay llamadas al sistema, copia de datos y recorrido completo del archivo cada vez.

Para ver el caso real, con disco frío, hay que vaciar esa caché del kernel entre corridas:

```bash
sync; sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
```

| | Tiempo total | Por consulta | Consultas por segundo |
|---|---|---|---|
| Desde archivo (caché del kernel caliente) | | | |
| Desde archivo (caché del kernel vacía) | | | |
| Desde el `HashMap` | | | |

Y la pregunta de diseño, que es la que de verdad se hace en el trabajo: **tu catálogo cambia mientras el servidor corre?** Si alguien edita `catalogo.txt`, tu caché queda desactualizada y vas a vender a precios viejos. Qué harías? Anota tu propuesta: recargar cada N minutos, recargar cuando cambie la fecha del archivo, o no permitir cambios en caliente. Las tres son respuestas defendibles y las tres tienen un costo distinto.

```bash
git add .
git commit -m "s11 extra: archivo contra cache, 10000 consultas"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu catálogo en memoria y tus mediciones. Hoy le apretamos la memoria a la JVM hasta que truene.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. El experimento del `-Xmx`

`-Xmx` le dice a la JVM cuánto puede crecer su heap como máximo. Vamos a ver qué pasa cuando el catálogo no cabe.

```bash
cd ~/so-proyecto/src
for mx in 512m 256m 128m 64m 32m; do
  echo "===== -Xmx$mx ====="
  timeout 60 java -Xmx$mx CargaCatalogo ../datos/catalogo_grande.txt
done
```

(Haz un `CargaCatalogo.java` de tres líneas que solo cargue y reporte.)

Llena la tabla y busca el punto de quiebre:

| `-Xmx` | Carga bien? | Tiempo de carga | Qué error salió |
|---|---|---|---|
| 512m | | | |
| 256m | | | |
| 128m | | | |
| 64m | | | |
| 32m | | | |

Lo que hay que observar, y es lo interesante: justo **antes** de fallar, el tiempo de carga se dispara. No falla de golpe: primero se pone lentísimo. Eso es el recolector de basura corriendo sin parar, tratando de hacer espacio en un heap que ya no da más. **Ese es el síntoma real de un servidor que se está quedando sin memoria en producción: no se cae, se arrastra.**

#### 2. `VmSize` contra `VmRSS`, en vivo

Con el servidor corriendo y el catálogo grande cargado, todos a la vez:

```bash
watch -n 1 'grep -E "VmSize|VmRSS" /proc/$(pgrep -f ServidorPedidos)/status; free -h | head -2'
```

Ahora manden carga y miren cuál de los dos números se mueve y cuál no. Al pizarrón: `VmSize` y `VmRSS` de cada quien, con el mismo catálogo y el mismo `-Xmx`.

Van a salir números distintos entre máquinas, y esa es la conversación: **de qué depende el `VmRSS`?** De la RAM de la máquina, de la presión de memoria, de si el SO decidió que podía darse el lujo. Del `-Xmx` depende el techo, no el uso.

#### 3. Tocar la memoria de verdad

Demostración de que reservar no es ocupar. Dos programas:

```java
// SoloReserva.java - pide 500 MB y no los toca
byte[] grande = new byte[500 * 1024 * 1024];
System.out.println("Reservados. PID " + ProcessHandle.current().pid());
Thread.sleep(60000);
```

```java
// ReservaYToca.java - pide 500 MB y escribe en cada pagina
byte[] grande = new byte[500 * 1024 * 1024];
for (int i = 0; i < grande.length; i += 4096) {   // una escritura por pagina
    grande[i] = 1;
}
System.out.println("Reservados y tocados. PID " + ProcessHandle.current().pid());
Thread.sleep(60000);
```

Corran los dos con `-Xmx1g` y comparen:

| | `VmSize` | `VmRSS` | `min_flt` |
|---|---|---|---|
| `SoloReserva` | | | |
| `ReservaYToca` | | | |

El segundo tiene un `VmRSS` mucho mayor **y muchísimos más fallos de página menores**. Cada uno de esos fallos es el momento exacto en que el SO le dio un marco de RAM de verdad. Ese `i += 4096` del ciclo no es casualidad: es el tamaño de página que consultaste con `getconf PAGESIZE`.

**Ese es el concepto de la semana hecho visible**: la memoria se te entrega cuando la tocas, no cuando la pides.

#### 4. La pregunta que abre la semana 12

Con tu servidor corriendo con `-Xmx64m` y el catálogo grande, manden carga continua y déjenlo. Va a morir. Miren el mensaje.

Y ahora la pregunta: **ese mensaje lo escribió Java o lo escribió el kernel?** Ya vieron los dos en la semana 3 con Docker. La semana que viene es distinguirlos bien, provocarlos a propósito, y aprender a diagnosticar una fuga de memoria.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu catálogo cargándose una sola vez al arrancar**, en un `HashMap`, y todas las consultas resolviéndose desde memoria. Que el servidor imprima al arrancar cuántos productos cargó y en cuánto tiempo.

2. **Vuelve a tu catálogo normal** (`catalogo.txt`, tus 8 productos) para el funcionamiento diario. El grande es solo para medir.

3. **Instrumenta tu servidor con el reporte de memoria.** Que imprima el heap usado al arrancar, después de cargar el catálogo, y en el resumen del apagado ordenado. Con eso ya tienes un servidor observable, que es a lo que hemos ido llegando desde la semana 2.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es la memoria virtual y qué problema resuelve.
   - Qué es una página, qué es un fallo de página y la diferencia entre menor y mayor.
   - Por qué `VmSize` y `VmRSS` son tan distintos en tu servidor, con tus números.
   - Cuánto le costó a tu servidor tener el catálogo en memoria y cuánto ganó, con las dos mediciones.

   ```bash
   git add .
   git commit -m "s11 proyecto: catalogo en memoria y servidor instrumentado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Midan la memoria de las tres sucursales corriendo a la vez** en una sola máquina, con `free -h` antes y después. Sumen los tres `VmRSS` y compárenlo con lo que reporta `free`. No va a cuadrar exactamente, y la explicación (páginas compartidas de las bibliotecas y de la JVM) vale una pregunta de revisión.

2. **Decidan dónde vive el catálogo en el sistema integrado.** Cada sucursal tiene el suyo en memoria, o el Servidor Central tiene uno solo y las sucursales le preguntan? Es una decisión real de arquitectura: la primera es rápida y se desincroniza, la segunda es consistente y mete latencia. Escriban cuál eligieron y por qué.

3. **Calculen el techo del sistema.** Con lo que mide cada producto en memoria, cuántos productos por sucursal aguanta una máquina de 8 GB con tres sucursales? Es el tipo de cálculo que se hace de verdad antes de comprar un servidor.
