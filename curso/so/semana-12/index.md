---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 12 - Diagnóstico de memoria (U3)

La semana pasada tu servidor murió con `-Xmx64m` y quedó una pregunta en el aire: ese mensaje lo escribió Java o lo escribió el kernel? Esta semana aprendes a distinguirlos, a provocar cada uno a propósito, y a diagnosticar el problema que está detrás de la mayoría de los servidores que "hay que reiniciar cada semana": la **fuga de memoria**.

Y arreglas el defecto más serio que le queda a tu servidor. Ahora mismo, si los cajeros mandan pedidos más rápido de lo que puedes atenderlos, tu cola crece sin límite hasta que la máquina se acaba. Un sistema que no puede decir "ya no puedo con más" no es un sistema robusto: es uno que todavía no se ha caído.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: fugas, OOM y quién mató a tu proceso](#bloque-1)
    - [Bloque 2: un buffer que no se desborda](#bloque-2)
    - [Bloque extra: provoca la fuga y grafícala](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes qué es una fuga, quién es el OOM killer y cómo distinguirlo de la JVM | Tu tabla de las dos muertes y tu análisis de riesgo |
| 2 | Le pones un límite a la cola de pedidos de tu servidor | `src/BufferPedidos.java` y `evidencias/buffer.txt` |
| Extra | Provocas una fuga y la grafícas | Tu gráfica de `VmRSS` contra tiempo |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: fugas, OOM y quién mató a tu proceso {#bloque-1}

#### Qué es una fuga de memoria

Una **fuga de memoria** (*memory leak*) es memoria que el programa reservó y que ya no va a usar, pero que no se libera. Va acumulándose hasta que se acaba.

En lenguajes como C la fuga es literal: pides memoria con `malloc` y se te olvida el `free`. En Java existe el recolector de basura, y por eso mucha gente cree que las fugas no pueden ocurrir. **Sí ocurren**, solo que de otra forma.

El recolector de basura libera lo que **nadie referencia**. Una fuga en Java es memoria que **sigue siendo referenciada por alguien** aunque el programa nunca la vaya a volver a usar. El recolector la ve viva y no la toca. Los casos típicos:

| Patrón | Por qué fuga |
|---|---|
| Una colección que solo crece | Un `ArrayList` de todos los pedidos históricos, un `HashMap` de caché sin política de expiración |
| Escuchadores que se registran y no se dan de baja | El objeto sigue referenciado por la lista de escuchadores |
| Hilos que no terminan | Cada hilo mantiene viva su pila y todo lo que referencia |
| Recursos no cerrados | Cada archivo abierto tiene estructuras asociadas |

El primero es el que tienes tú. Si tu servidor guarda cada pedido atendido en una lista para el resumen final, y corre durante meses, esa lista es una fuga perfecta: crece sin parar y nunca se limpia.

Lo característico de una fuga, y lo que la hace difícil, es que **no falla de inmediato**. El servidor funciona perfecto el lunes, va un poco más lento el jueves, y el domingo a las 3 de la mañana se muere. Por eso tantos sistemas tienen un reinicio programado semanal: alguien decidió que era más barato reiniciar que buscar la fuga.

#### Las dos muertes

Cuando un programa Java se queda sin memoria, puede morir de dos formas distintas, y **confundirlas te manda a buscar el problema al lugar equivocado**. Ya las viste las dos en la semana 3 con Docker; ahora hay que saber distinguirlas siempre.

| | `OutOfMemoryError` | OOM killer |
|---|---|---|
| **Quién lo hace** | La JVM | El kernel de Linux |
| **Qué se agotó** | El heap de Java, el límite de `-Xmx` | La RAM física de la máquina (o del cgroup) |
| **Qué ves** | Una excepción con stack trace | La palabra `Killed`, y nada más |
| **Código de salida** | 1 | **137** |
| **Se puede atrapar?** | Técnicamente sí, no deberías | No. Es `SIGKILL` |
| **Corre el shutdown hook?** | Sí | **No** |
| **Dónde queda registrado** | En tu log | En `dmesg`, no en tu log |
| **Qué hay que revisar** | Tu código y tu `-Xmx` | La memoria de la máquina entera |

La fila del shutdown hook enlaza con la semana 8 y es la que más duele en la práctica: con el OOM killer **no se ejecuta tu apagado ordenado**, así que no hay resumen, no se cierran archivos y se pierde lo que estuviera en buffers.

#### El OOM killer

Cuando a Linux se le acaba la memoria física y ya no puede ni hacer swap, tiene que elegir: o mata a alguien, o se cae la máquina entera. Elige matar, y la parte que lo hace se llama **OOM killer** (*out of memory killer*).

No mata al azar. Le asigna a cada proceso un puntaje (`oom_score`) que considera cuánta memoria ocupa, cuánto lleva vivo y su prioridad configurada, y **mata al de mayor puntaje**. Puedes ver el de tu servidor:

```bash
cat /proc/TU_PID/oom_score
cat /proc/TU_PID/oom_score_adj
```

El segundo va de -1000 a 1000 y es un ajuste manual. En un servidor real, se le baja al proceso crítico para que el OOM killer prefiera a otro:

```bash
echo -500 | sudo tee /proc/TU_PID/oom_score_adj
```

Y aquí está la ironía cruel del OOM killer, que hay que conocer: **suele matar justo al proceso importante**. Tu servidor de pedidos es probablemente el que más memoria usa de la máquina, así que es el que más puntaje tiene. El kernel mata al servidor de producción y deja vivo al editor de texto.

Cuando pasa, el rastro está aquí:

```bash
dmesg | grep -i -E "killed process|out of memory"
```

```
[12453.887] Out of memory: Killed process 4187 (java) total-vm:3521000kB,
            anon-rss:1985112kB, file-rss:0kB, shmem-rss:0kB, oom_score_adj:0
```

Esa línea es la prueba. Si tu servidor "desapareció sin dejar nada en el log", esto es lo primero que hay que mirar, y es de las cosas que más rápido te distinguen en un trabajo de operaciones.

#### El problema del productor y el consumidor

Ahora el problema concreto de tu servidor, que tiene nombre clásico.

Tienes un **productor** (los cajeros que mandan pedidos) y unos **consumidores** (tus trabajadores que los atienden), comunicados por una **cola**. Si el productor va más rápido que los consumidores, la cola crece. Si no tiene límite, crece hasta acabarse la memoria.

Y ojo, porque esto **no es una fuga**: no hay ningún error en tu código, no se te olvidó liberar nada. Es un problema de diseño distinto y se llama **falta de contrapresión** (*backpressure*). El sistema no tiene forma de decirle al productor "más despacio".

Las tres respuestas posibles cuando la cola se llena, y las tres son legítimas según el negocio:

| Estrategia | Qué hace | Cuándo conviene |
|---|---|---|
| **Bloquear** | El productor espera a que haya espacio | Cuando no se puede perder ningún pedido |
| **Rechazar** | Se descarta el pedido nuevo y se avisa | Cuando es mejor decir "no puedo" que colapsar |
| **Descartar el más viejo** | Entra el nuevo, sale el más antiguo | Cuando lo reciente vale más (telemetría, sensores) |

Java te da la primera envuelta en `ArrayBlockingQueue`, que es una cola con capacidad fija donde `put()` se bloquea si está llena y `take()` se bloquea si está vacía. Es exactamente el mecanismo que implementaste a mano con `wait`/`notifyAll` en la semana 10, ahora con límite por los dos lados.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **La tabla de las dos muertes**, resumida con tus palabras, y **cómo distinguirlas en la práctica**: qué comando corres para saber cuál de las dos fue.

2. **El análisis de riesgo de tu servidor.** Busca en tu propio código:

   | Estructura | Crece sin límite? | Qué pasaría en 6 meses corriendo |
   |---|---|---|
   | La cola de pedidos del planificador | | |
   | El catálogo en memoria | | |
   | (cualquier lista o mapa que tengas) | | |

   Sé honesto: si encuentras una que crece sin límite, esa es una fuga y la vas a arreglar en el bloque 2.

3. **Tu estrategia elegida** de las tres de la tabla, para cuando la cola se llene, **con el argumento del negocio**. En una farmacia perder una receta no es lo mismo que en un sensor de temperatura perder una lectura. Justifícalo con tu dominio.

```bash
git add .
git commit -m "s12 bloque 1: fugas, OOM killer y contrapresion"
git push
```

---

### Bloque 2: un buffer que no se desborda {#bloque-2}

#### El buffer acotado

Crea `src/BufferPedidos.java`. Es la cola de tu servidor, con límite y con política de desbordamiento:

```java
// BufferPedidos.java - la cola de pedidos, ACOTADA
import java.util.ArrayDeque;
import java.util.Deque;

public class BufferPedidos {

    public enum Politica { BLOQUEAR, RECHAZAR, DESCARTAR_VIEJO }

    private final Deque<Pedido> cola = new ArrayDeque<>();
    private final int capacidad;
    private final Politica politica;

    // Contadores: sin esto no se puede diagnosticar nada.
    private int aceptados = 0;
    private int rechazados = 0;
    private int descartados = 0;
    private int maximoAlcanzado = 0;

    public BufferPedidos(int capacidad, Politica politica) {
        this.capacidad = capacidad;
        this.politica = politica;
    }

    // Devuelve true si el pedido entro, false si se rechazo.
    public synchronized boolean ofrecer(Pedido p) throws InterruptedException {

        while (cola.size() >= capacidad) {

            if (politica == Politica.RECHAZAR) {
                rechazados++;
                return false;
            }

            if (politica == Politica.DESCARTAR_VIEJO) {
                cola.removeFirst();      // sale el mas antiguo
                descartados++;
                break;
            }

            // BLOQUEAR: el productor espera a que haya lugar.
            wait();
        }

        cola.addLast(p);
        aceptados++;
        maximoAlcanzado = Math.max(maximoAlcanzado, cola.size());
        notifyAll();
        return true;
    }

    public synchronized Pedido tomar() throws InterruptedException {
        while (cola.isEmpty()) {
            wait();
        }
        Pedido p = cola.removeFirst();
        notifyAll();            // avisa al productor que ya hay lugar
        return p;
    }

    public synchronized int tamano() { return cola.size(); }

    public synchronized String resumen() {
        return "capacidad=" + capacidad
             + " politica=" + politica
             + " aceptados=" + aceptados
             + " rechazados=" + rechazados
             + " descartados=" + descartados
             + " ocupacion_maxima=" + maximoAlcanzado
             + " (" + (maximoAlcanzado * 100 / capacidad) + "%)";
    }
}
```

Fíjate en los dos `notifyAll()`. Uno despierta a los consumidores cuando entra un pedido; el otro despierta al productor cuando se libera un lugar. **Sin el segundo, un productor bloqueado por cola llena no despertaría nunca** y tendrías un servidor colgado, que ya sabes diagnosticar desde la semana 7.

Y el `maximoAlcanzado` no es adorno: es la métrica que te dice si dimensionaste bien. Si termina la jornada al 12% de ocupación, tu buffer es más grande de lo necesario; si toca el 100%, se te quedó chico.

#### Conéctalo a tu servidor

Sustituye la lista sin límite de tu `PlanificadorPedidos` por este buffer. El ciclo principal ahora tiene que hacer algo cuando un pedido no entra:

```java
BufferPedidos buffer = new BufferPedidos(50, BufferPedidos.Politica.RECHAZAR);

// En el ciclo que recibe:
Pedido p = /* ... construir desde la linea ... */;

if (!buffer.ofrecer(p)) {
    // TODO: registra el rechazo con el formato de tu dominio y
    //       marca el pedido con estado "rechazado".
    //       Aqui por fin sirve de verdad el campo estado de la semana 3.
    registrar("RECHAZADO por saturacion: " + p);
}
```

Y en el apagado ordenado de la semana 8, agrega el resumen del buffer:

```java
registrar("Buffer: " + buffer.resumen());
```

#### Provoca la saturación

Necesitas que los pedidos entren más rápido de lo que salen. Dos formas: subir la velocidad del generador o bajar el número de trabajadores. Haz las dos:

```bash
cd ~/so-proyecto/src
javac *.java

cd ~/so-proyecto
{
  for politica in BLOQUEAR RECHAZAR DESCARTAR_VIEJO; do
    echo "===== $politica ====="
    java -cp src -Xmx128m GeneradorPedidos 2000 \
      | java -cp src -Xmx128m ServidorPedidos $politica 2 \
      | tail -6
  done
} > evidencias/buffer.txt 2>&1

cat evidencias/buffer.txt
```

(Haz que tu servidor acepte la política y el número de trabajadores como argumentos.)

Y para comparar, la versión **sin límite**: pon la capacidad en `Integer.MAX_VALUE`, corre con `-Xmx64m` y 2000 pedidos, y mira qué pasa. Debería morir, y ahí tienes tu `OutOfMemoryError` provocado a propósito.

**Lo que entregas de este bloque**

1. `src/BufferPedidos.java` completo.
2. `src/ServidorPedidos.java` usando el buffer acotado, con el `TODO` del rechazo resuelto.
3. `evidencias/buffer.txt` con las tres políticas y la corrida sin límite.

4. En `BITACORA.md`, bajo `### Antes de la clase`:

   | Política | Aceptados | Rechazados | Descartados | Ocupación máxima | Tiempo total |
   |---|---|---|---|---|---|
   | BLOQUEAR | | | | | |
   | RECHAZAR | | | | | |
   | DESCARTAR_VIEJO | | | | | |
   | Sin límite | | | | | |

   Y debajo:
   - **Por qué BLOQUEAR tarda más** que las otras dos, y a quién le pasa el problema (pista: quién se queda esperando).
   - **Qué le dirías al cliente** cuyo pedido fue rechazado, en tu dominio. Y qué pasa con el cliente cuyo pedido fue descartado por viejo, que ni siquiera se entera.
   - **Qué capacidad le pondrías a tu buffer en producción** y con qué argumento. Usa tu ocupación máxima medida.

```bash
git add .
git commit -m "s12 bloque 2: buffer acotado con politica de desbordamiento"
git push
```

---

### Bloque extra: provoca la fuga y grafícala {#bloque-extra}

Opcional. Una fuga se diagnostica **mirando la memoria a lo largo del tiempo**, no en un instante. Vamos a producir esa gráfica.

Primero, la fuga. Es de las más realistas que hay: un historial de pedidos que nadie limpia.

```java
// En ServidorPedidos, una lista "para el reporte" que nunca se vacia.
static final List<Pedido> historial = new ArrayList<>();

// Dentro de atender(), al terminar:
synchronized (historial) {
    historial.add(pedido);          // aqui esta la fuga
}
```

Se ve perfectamente razonable. Nadie lo señalaría en una revisión de código. Y en seis meses de operación es lo que mata al servidor.

Ahora el muestreo. Un script que anota el `VmRSS` cada segundo:

```bash
#!/bin/bash
# medir_memoria.sh - muestrea VmRSS de un proceso cada segundo
PID=$1
SALIDA=${2:-memoria.csv}

echo "segundo,vmrss_kb,heap_pct" > "$SALIDA"
s=0
while [ -d "/proc/$PID" ]; do
  rss=$(grep VmRSS /proc/$PID/status | awk '{print $2}')
  echo "$s,$rss," >> "$SALIDA"
  s=$((s+1))
  sleep 1
done
echo "El proceso $PID termino en el segundo $s"
```

```bash
chmod +x medir_memoria.sh

# Lanza el servidor con carga continua y mide
java -Xmx256m -cp src ServidorPedidos RECHAZAR 2 < /dev/null &
PID=$!
./medir_memoria.sh $PID evidencias/memoria_fuga.csv &
java -cp src GeneradorPedidos 100000 | ...
```

Con el CSV ya puedes graficar. Lo más rápido, sin instalar nada:

```bash
gnuplot -e "set terminal dumb 100 30; set title 'VmRSS'; \
  set datafile separator ','; plot 'evidencias/memoria_fuga.csv' \
  using 1:2 with lines title 'KB'"
```

Si no tienes `gnuplot`: `sudo apt install gnuplot -y`. También puedes abrir el CSV en Excel o en LibreOffice y hacer la gráfica ahí; lo que importa es la forma de la curva, no la herramienta.

Corre dos veces y compara las dos formas:

| | Con la fuga (`historial` sin limpiar) | Sin la fuga |
|---|---|---|
| Forma de la curva | | |
| `VmRSS` a los 30 s | | |
| `VmRSS` a los 120 s | | |
| Se estabiliza? | | |

**La forma de la curva es el diagnóstico.** Una memoria sana sube al principio, hace dientes de sierra (el recolector trabajando) y **se estabiliza en una banda**. Una fuga tiene dientes de sierra cuyo **piso va subiendo**: cada recolección libera menos que la anterior. En cuanto sabes reconocer esa forma, diagnosticar una fuga es cuestión de minutos.

Y para el remate, mira el trabajo del recolector:

```bash
java -Xmx256m -Xlog:gc -cp src ServidorPedidos ...
```

Cada línea es una recolección. Con fuga, la memoria que queda después de cada una va subiendo, y las recolecciones se vuelven más frecuentes y más largas. Ese es el "se arrastra antes de caerse" que viste la semana pasada.

```bash
git add .
git commit -m "s12 extra: fuga provocada y curva de VmRSS"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu buffer acotado. Hoy matamos procesos de las dos maneras y aprendemos a saber cuál fue.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. Las dos muertes, lado a lado

Cada quien provoca las dos y las compara. Primero la de la JVM:

```bash
cd ~/so-proyecto/src
java -Xmx64m Tragon            # el de la semana 3
echo "codigo de salida: $?"
```

Después la del kernel. Necesitas un cgroup, y la forma más simple es Docker, igual que en la semana 3:

```bash
docker run --rm -v ~/so-proyecto/src:/app -w /app --memory=64m \
  eclipse-temurin:21-jdk java Tragon
echo "codigo de salida: $?"
dmesg | tail -5
```

Al pizarrón, la tabla comparativa llena con lo que vieron:

| | Mensaje exacto | Código de salida | Hubo stack trace? | Aparece en `dmesg`? |
|---|---|---|---|---|
| `OutOfMemoryError` | | | | |
| OOM killer | | | | |

Y ahora la parte que hay que hacer bien: **el diagnóstico a ciegas**. Por parejas, uno mata el proceso del otro de una de las dos formas sin decirle cuál, y el otro tiene que determinarlo con comandos. Es exactamente el trabajo de un lunes por la mañana cuando el servidor amaneció caído.

#### 2. El shutdown hook que no corre

Comprobación directa de por qué esto importa. Con tu servidor, que ya tiene apagado ordenado desde la semana 8:

```bash
java -Xmx64m -cp src ServidorPedidos ... &   # provocalo hasta el OOM
```

Miren si salió el resumen final. Con `OutOfMemoryError` **a veces sí** alcanza a correr; con el OOM killer del kernel, **nunca**.

En tu dominio: cuántas ventas quedaron sin registrar? Los pedidos que estaban en el buffer cuando murió, se perdieron todos. Ponle el número.

#### 3. Dimensionar el buffer, en serio

Actividad de ingeniería, con datos. Cada quien corre su servidor con varias capacidades y la misma carga:

```bash
for cap in 10 50 200 1000 5000; do
  echo -n "cap=$cap  "
  java -cp src -Xmx128m GeneradorPedidos 5000 \
    | java -cp src -Xmx128m ServidorPedidos RECHAZAR 2 $cap \
    | grep "Buffer:"
done
```

| Capacidad | Rechazados | Ocupación máxima | `VmRSS` pico | Tiempo total |
|---|---|---|---|---|
| 10 | | | | |
| 50 | | | | |
| 200 | | | | |
| 1000 | | | | |
| 5000 | | | | |

Al pizarrón la conclusión de cada quien. Lo que va a salir: **subir la capacidad reduce rechazos hasta cierto punto y después ya no**, porque el cuello de botella deja de ser el buffer y pasa a ser el número de trabajadores. Un buffer más grande no atiende más rápido: solo hace la fila más larga.

Esa frase es la que hay que llevarse, y es la que se usa de verdad al dimensionar sistemas: **la cola absorbe picos, no capacidad insuficiente**. Si tu carga promedio supera tu capacidad de servicio, ninguna cola te salva; solo retrasa el colapso y lo hace peor.

#### 4. El OOM killer eligiendo víctima

Demostración final, en una sola máquina y con cuidado. Lancen tres procesos con distinta memoria y distinto `oom_score_adj`:

```bash
java -Xmx1g Tragon &            # el goloso
PID1=$!
java -Xmx64m Tragon &           # el modesto
PID2=$!

cat /proc/$PID1/oom_score
cat /proc/$PID2/oom_score
```

Vean los puntajes y **predigan a quién mataría el kernel** antes de comprobarlo. Después bajen el puntaje del goloso y vean cómo cambia la predicción:

```bash
echo -500 | sudo tee /proc/$PID1/oom_score_adj
cat /proc/$PID1/oom_score
```

En un servidor de producción esto es lo que se hace con la base de datos: se le baja el puntaje para que el OOM killer prefiera matar cualquier otra cosa antes que a ella.

Limpien con `pkill -f Tragon`.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu servidor con el buffer acotado** y la política que elegiste, con la capacidad justificada por tu medición. El resumen del apagado tiene que incluir la línea del buffer con la ocupación máxima.

2. **Elimina las estructuras que crecen sin límite.** Si tienes un historial, o le pones un tope (los últimos N), o lo escribes a disco y lo sueltas de memoria. Lo segundo es lo correcto y es justo lo que vas a hacer en la semana 15.

3. **Deja el rechazo visible para el cliente.** Un pedido rechazado tiene que quedar registrado con su estado y con el motivo. Un sistema que descarta en silencio es peor que uno que se cae.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es una fuga de memoria y por qué puede ocurrir en Java aunque haya recolector de basura.
   - Las dos muertes por falta de memoria, cómo se distinguen y qué comando usas para cada una.
   - Qué política de desbordamiento elegiste y por qué, con el argumento de tu negocio.
   - Tu tabla de dimensionamiento del buffer y la capacidad que dejaste.

   ```bash
   git add .
   git commit -m "s12 proyecto: buffer acotado y control de memoria"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Falta poco para la revisión de la semana 14. Este es el avance que la cierra por el lado de memoria.

1. **El Servidor Central necesita contrapresión hacia las sucursales.** Si el central se satura, qué le dice a la sucursal que le está mandando pedidos? Impleméntenlo y prueben el caso: una sucursal mandando mucho más rápido que las otras dos.

2. **Midan el sistema completo bajo saturación** y guarden la evidencia: memoria de los cuatro procesos, ocupación de las colas, pedidos rechazados por cada uno.

3. **Comprueben que ninguna sucursal puede tumbar a las demás.** Es la propiedad que se le pide a un sistema distribuido y es la pregunta que se hace en la revisión: si la sucursal 1 se vuelve loca y manda 100000 pedidos, siguen operando la 2 y la 3? Si la respuesta es no, ahí tienen el trabajo de esta semana.
