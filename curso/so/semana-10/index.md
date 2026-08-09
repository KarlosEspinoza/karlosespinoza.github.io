---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 10 - Planificación de procesos (U2)

Tu servidor ya atiende varios pedidos a la vez sin romper el inventario. Ahora aparece la pregunta que estaba escondida detrás: cuando hay 50 pedidos esperando y solo puedes atender unos cuantos a la vez, **a cuál atiendes primero?**

Esa decisión la toma el sistema operativo miles de veces por segundo con los procesos de tu máquina, y la vas a tomar tú con los pedidos de tu servidor. Son el mismo problema: recursos limitados, muchos candidatos, y una política que decide el orden. Esta semana vas a implementar dos políticas distintas, medir cuál conviene a tu negocio, y de paso entender por qué el SO usa la que usa.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: cómo reparte el turno el sistema operativo](#bloque-1)
    - [Bloque 2: tu propio planificador de pedidos](#bloque-2)
    - [Bloque extra: prioridades reales con nice](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes quantum, cambio de contexto y las políticas clásicas | Tu tabla comparativa calculada a mano |
| 2 | Implementas dos políticas en tu servidor y las mides | `src/PlanificadorPedidos.java` y `evidencias/planificacion.txt` |
| Extra | Cambias prioridades reales de procesos con `nice` y `renice` | Tu medición del efecto de la prioridad |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: cómo reparte el turno el sistema operativo {#bloque-1}

#### El planificador

En tu máquina hay decenas de procesos listos para ejecutarse y unos pocos núcleos. La parte del kernel que decide **cuál corre ahora y por cuánto tiempo** se llama **planificador** (*scheduler*), y es de las piezas más afinadas del sistema operativo.

Su trabajo es una decisión que se toma constantemente: cada vez que un proceso se bloquea, cada vez que termina, cada vez que llega uno nuevo, y cada vez que se le acaba el turno al que estaba corriendo.

#### El quantum

Ese turno tiene nombre: **quantum**. Es el tiempo máximo que un proceso puede usar el procesador antes de que el SO se lo quite, aunque no haya terminado ni haya pedido nada.

El mecanismo es de hardware: hay un temporizador que interrumpe al procesador cada cierto tiempo, y esa interrupción devuelve el control al kernel. Sin ese temporizador, un proceso con un ciclo infinito **congelaría la máquina completa**, porque nadie podría quitárselo. Tu `EstadoR.java` de la semana 2 giraba al 100% de un núcleo y aun así pudiste teclear en la terminal: eso fue el quantum funcionando.

A eso se le llama planificación **expropiativa** (*preemptive*): el SO puede quitarle el procesador a un proceso sin su permiso. Lo contrario, la **cooperativa**, donde el proceso suelta el procesador cuando le da la gana, es lo que usaban Windows 3.1 y el Mac OS clásico, y es la razón de que un solo programa colgado tumbara todo el sistema.

En Linux el quantum no es fijo. El planificador actual (CFS, *Completely Fair Scheduler*) reparte el tiempo de forma proporcional según la prioridad, y el turno efectivo va de unos pocos milisegundos a unas decenas. Puedes verlo:

```bash
cat /proc/sys/kernel/sched_rr_timeslice_ms
```

#### Lo que cuesta cambiar de proceso

Cada cambio de turno es un **cambio de contexto**, que ya conoces desde la semana 3: guardar los registros del proceso que sale, restaurar los del que entra. Cuesta del orden de **1 a 5 microsegundos**, más un costo indirecto que suele ser mayor: el nuevo proceso llega con las cachés del procesador llenas de los datos del anterior y tiene que volver a llenarlas.

De ahí sale la tensión de diseño de todo planificador:

- **Quantum corto:** el sistema responde rápido, todo el mundo avanza un poquito seguido. Pero se gasta más proporción del tiempo en cambios de contexto.
- **Quantum largo:** menos desperdicio, más trabajo útil por segundo. Pero un proceso interactivo puede quedarse esperando y se siente lento.

Puedes ver cuántos cambios de contexto lleva tu servidor:

```bash
grep ctxt /proc/TU_PID/status
```

```
voluntary_ctxt_switches:        1247
nonvoluntary_ctxt_switches:      38
```

La distinción es útil: los **voluntarios** son las veces que tu proceso soltó el procesador porque se bloqueó (un `sleep`, una lectura). Los **no voluntarios** son las veces que se le acabó el quantum y se lo quitaron. Un servidor sano tiene muchos voluntarios y pocos no voluntarios; al revés significa que está gastando procesador de verdad.

#### Las políticas clásicas

Ahora las políticas, que son lo que vas a implementar. Para compararlas hay tres medidas:

| Medida | Qué es |
|---|---|
| **Tiempo de espera** | Cuánto estuvo formado sin que lo atendieran |
| **Tiempo de retorno** | Desde que llegó hasta que terminó (espera + servicio) |
| **Tiempo de respuesta** | Desde que llegó hasta que **empezaron** a atenderlo |

**FIFO (o FCFS, primero en llegar, primero en ser servido).** El más simple: se atiende en orden de llegada, y cada uno corre hasta terminar.

Su problema tiene nombre propio, **el efecto convoy**: si el primero es larguísimo, todos los cortos que llegaron detrás esperan por él. Es la fila del supermercado cuando la señora de adelante trae el carrito lleno y tú traes un chicle.

**SJF (el trabajo más corto primero).** Se atiende primero al que va a tardar menos. Se puede demostrar matemáticamente que **minimiza el tiempo de espera promedio**: es óptimo en ese sentido, y no hay política que lo mejore.

Tiene dos problemas serios. El primero es que **hay que saber cuánto va a tardar cada trabajo**, y en general no se sabe; se estima a partir del pasado. El segundo es la **inanición**: si no dejan de llegar trabajos cortos, uno largo puede esperar para siempre.

**Round Robin (turno rotatorio).** FIFO con quantum: cada uno corre un turno y, si no terminó, se va al final de la cola. Es justo, nadie se muere de hambre, y el tiempo de respuesta es bueno. A cambio, el tiempo de retorno promedio es peor que el de SJF, y si el quantum es muy chico se gasta mucho en cambios de contexto.

**Por prioridades.** Cada trabajo trae un número y se atiende primero al más prioritario. Sufre de inanición para los de baja prioridad, y se resuelve con **envejecimiento** (*aging*): subirle la prioridad a los que llevan mucho esperando.

#### Compáralas a mano

Este cálculo es el ejercicio clásico y hay que hacerlo con lápiz. Cuatro pedidos que llegan todos en el instante 0:

| Pedido | Duración |
|---|---|
| P1 | 8 |
| P2 | 2 |
| P3 | 4 |
| P4 | 1 |

Con **FIFO** (orden P1, P2, P3, P4):

| Pedido | Empieza | Termina | Espera |
|---|---|---|---|
| P1 | 0 | 8 | 0 |
| P2 | 8 | 10 | 8 |
| P3 | 10 | 14 | 10 |
| P4 | 14 | 15 | 14 |

Espera promedio: (0 + 8 + 10 + 14) / 4 = **8**

Con **SJF** (orden P4, P2, P3, P1):

| Pedido | Empieza | Termina | Espera |
|---|---|---|---|
| P4 | 0 | 1 | 0 |
| P2 | 1 | 3 | 1 |
| P3 | 3 | 7 | 3 |
| P1 | 7 | 15 | 7 |

Espera promedio: (0 + 1 + 3 + 7) / 4 = **2.75**

**El mismo trabajo, en el mismo tiempo total (15), con menos de la mitad de espera promedio.** No se hizo nada más rápido: solo se cambió el orden. Eso es lo que hace una política de planificación.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **La tercera columna de la comparación.** Calcula a mano **Round Robin con quantum 2** para los mismos cuatro pedidos, y llena esta tabla:

   | Política | Espera promedio | Retorno promedio | Quién sale perjudicado |
   |---|---|---|---|
   | FIFO | 8 | | |
   | SJF | 2.75 | | |
   | Round Robin (q=2) | | | |

2. **Cuál le conviene a tu negocio y por qué.** Piensa en tu dominio de verdad: en una farmacia con una receta urgente y diez ventas de dulces, o en un taller con una reparación de tres días y cinco revisiones de diez minutos. Justifica con **una consecuencia concreta para un cliente tuyo**, no en abstracto.

3. **Los cambios de contexto de tu servidor.** Corre tu servidor con carga, saca `grep ctxt /proc/TU_PID/status`, y explica qué te dice la proporción entre voluntarios y no voluntarios sobre lo que está haciendo tu servidor.

```bash
git add .
git commit -m "s10 bloque 1: politicas de planificacion comparadas"
git push
```

---

### Bloque 2: tu propio planificador de pedidos {#bloque-2}

Hasta hoy tu servidor atiende los pedidos en el orden en que llegan, sin decidir nada: eso es FIFO por omisión. Vamos a darle una cola de verdad y dos políticas.

#### El planificador

Crea `src/PlanificadorPedidos.java`:

```java
// PlanificadorPedidos.java - decide el orden en que se atienden los pedidos
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class PlanificadorPedidos {

    public enum Politica { FIFO, SJF }

    private final List<Pedido> cola = new ArrayList<>();
    private final Politica politica;

    // Estadisticas para poder comparar las dos politicas.
    private long esperaTotal = 0;
    private int atendidos = 0;

    public PlanificadorPedidos(Politica politica) {
        this.politica = politica;
    }

    public synchronized void encolar(Pedido p) {
        cola.add(p);
        notifyAll();          // despierta a un hilo que este esperando trabajo
    }

    // Saca el siguiente pedido segun la politica. Se bloquea si no hay.
    public synchronized Pedido siguiente() throws InterruptedException {

        while (cola.isEmpty()) {
            wait();           // espera PASIVA: no gasta CPU
        }

        Pedido elegido;

        if (politica == Politica.FIFO) {
            // TODO: el primero que llego. pista: cola.remove(0)
            elegido = null;
        } else {
            // TODO: el mas corto primero.
            //       "Mas corto" en tu dominio = el de menor cantidad.
            //       pista: cola.stream().min(Comparator.comparingInt(Pedido::getCantidad))
            elegido = null;
        }

        cola.remove(elegido);
        esperaTotal += System.currentTimeMillis() - elegido.getHoraLlegada();
        atendidos++;
        return elegido;
    }

    public synchronized int pendientes() { return cola.size(); }

    public synchronized double esperaPromedio() {
        return atendidos == 0 ? 0 : (double) esperaTotal / atendidos;
    }
}
```

Vas a tener que agregarle a tu clase `Pedido` un campo `horaLlegada` (en milisegundos, con `System.currentTimeMillis()`) si no lo tenías. Ese es el dato que hace posible medir la espera, y es justo el campo `hora` que modelaste en la semana 3 sin saber para qué iba a servir.

#### `wait` y `notifyAll`: esperar sin gastar

Estas dos son nuevas y son importantes. Fíjate en el problema que resuelven: un hilo que quiere trabajo y no hay. Qué hace?

La versión mala, que es lo primero que se le ocurre a todo el mundo:

```java
while (cola.isEmpty()) { }        // espera activa: 100% de CPU para nada
```

Es el `EstadoR.java` de la semana 2, otra vez. La versión buena es `wait()`: el hilo **suelta el candado** y se bloquea hasta que alguien llame a `notifyAll()` sobre ese objeto. No consume procesador mientras espera, y al despertar recupera el candado automáticamente.

Que `wait()` suelte el candado es lo que hace que esto funcione: si no lo soltara, nadie podría entrar a `encolar()` a dejar el pedido que el otro está esperando, y tendrías un interbloqueo de la semana 7.

Y el `while (cola.isEmpty())` tiene que ser `while` y no `if`. Un hilo puede despertar y encontrar que otro ya se llevó el pedido, así que hay que **volver a comprobar** la condición al despertar. Es una regla fija: `wait()` siempre va dentro de un `while`.

#### Conéctalo a tu servidor

Tu `ServidorPedidos` cambia de forma. En vez de crear un hilo por pedido, ahora tiene un **pool fijo de trabajadores** que van sacando de la cola:

```java
PlanificadorPedidos planificador =
        new PlanificadorPedidos(PlanificadorPedidos.Politica.FIFO);

// Arrancamos N trabajadores. Ellos son los "procesadores" de este sistema.
int trabajadores = 2;
for (int i = 0; i < trabajadores; i++) {
    final int id = i + 1;
    new Thread(() -> {
        while (true) {
            try {
                Pedido p = planificador.siguiente();     // se bloquea si no hay
                atender(p, id);
            } catch (InterruptedException e) {
                return;
            }
        }
    }, "trabajador-" + id).start();
}

// El ciclo principal ya solo recibe y encola:
while (entrada.hasNextLine()) {
    // TODO: construye el Pedido desde la linea y encolalo.
    //       planificador.encolar(pedido);
}
```

Con dos trabajadores estás simulando una máquina de dos núcleos, y ahí es donde la política empieza a importar de verdad: **con recursos infinitos ninguna política importa; con recursos escasos, todas**.

#### Mide las dos políticas

Haz que el tiempo de atender dependa de la cantidad del pedido, para que haya pedidos cortos y largos:

```java
Thread.sleep(200L * pedido.getCantidad());
```

Y corre la misma carga con las dos políticas:

```bash
cd ~/so-proyecto/src
javac *.java

cd ~/so-proyecto
{
  echo "===== FIFO ====="
  java -cp src GeneradorPedidos 50 | java -cp src ServidorPedidos FIFO
  echo "===== SJF ====="
  java -cp src GeneradorPedidos 50 | java -cp src ServidorPedidos SJF
} > evidencias/planificacion.txt 2>&1

grep -E "promedio|Politica" evidencias/planificacion.txt
```

(Haz que tu servidor lea la política de `args[0]`, con FIFO por omisión.)

Al terminar, que imprima el resumen: política usada, pedidos atendidos, espera promedio, espera máxima.

**Lo que entregas de este bloque**

1. `src/PlanificadorPedidos.java` con los dos `TODO` resueltos.
2. `src/ServidorPedidos.java` usando el planificador con un pool de trabajadores.
3. `evidencias/planificacion.txt` con las dos corridas.

4. En `BITACORA.md`, bajo `### Antes de la clase`:

   | | FIFO | SJF |
   |---|---|---|
   | Espera promedio | | |
   | Espera máxima | | |
   | Cuál fue el pedido más perjudicado | | |

   Y debajo:
   - **Coincide con lo que calculaste a mano en el bloque 1?** Si no, por qué.
   - **Cuál es el pedido que más esperó con SJF**, y cuánto. Ese es el que sufre la inanición: ponle nombre y cantidad.
   - **Cuál política dejarías en tu negocio** y qué le dirías al cliente que quedó al final.

```bash
git add .
git commit -m "s10 bloque 2: planificador con dos politicas"
git push
```

---

### Bloque extra: prioridades reales con nice {#bloque-extra}

Opcional. Acabas de planificar pedidos dentro de tu programa. Ahora vas a planificar **procesos de verdad**, con la herramienta que usarías en un servidor real.

Linux le da a cada proceso un valor de amabilidad, el **nice**, que va de **-20 (el más prioritario) a 19 (el menos)**. El nombre es literal: un proceso "amable" cede el paso a los demás. Por omisión todos arrancan en 0, y **subir la prioridad (bajar el número) requiere `sudo`**; bajarla la puede hacer cualquiera.

```bash
nice -n 19 java MiPrograma        # lo lanza con la prioridad mas baja
renice -n 5 -p PID                # se la cambia a uno que ya corre
ps -o pid,ni,pri,%cpu,cmd -C java # la columna NI es el nice
```

Para medirlo necesitas saturar la máquina, porque **si sobra procesador la prioridad no se nota**: solo importa cuando hay competencia. Usa tu `EstadoR.java` de la semana 2, que gira sin parar, y lánzalo tantas veces como núcleos tengas por dos:

```bash
nproc                                    # cuantos nucleos tienes

# Saturar: 2 procesos por nucleo
for i in $(seq 1 $(( $(nproc) * 2 ))); do java EstadoR & done

# Ahora lanza tu servidor con distintas prioridades y mide
time (java GeneradorPedidos 100 | java ServidorPedidos > /dev/null)
time (nice -n 19 java GeneradorPedidos 100 | nice -n 19 java ServidorPedidos > /dev/null)
sudo nice -n -10 java ServidorPedidos ...   # si tienes sudo

pkill -f EstadoR                          # limpiar
```

| Prioridad (nice) | Tiempo con la máquina saturada | %CPU obtenido |
|---|---|---|
| -10 (alta) | | |
| 0 (normal) | | |
| 19 (baja) | | |

Y las dos preguntas que valen:

1. **Con la máquina descargada, cambia algo el nice?** Corre lo mismo sin los procesos de saturación y explica el resultado.
2. **A qué proceso de tu proyecto le pondrías un nice alto y a cuál bajo, en un servidor de producción?** Piensa en un respaldo nocturno contra el servidor que atiende cajeros.

```bash
git add .
git commit -m "s10 extra: prioridades con nice y renice"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu planificador funcionando con dos políticas. Hoy lo estresamos y vemos aparecer la inanición.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. La carrera de políticas

Todos con la misma carga, para poder comparar entre máquinas:

```bash
java GeneradorPedidos 100 | java ServidorPedidos FIFO > /tmp/fifo.txt
java GeneradorPedidos 100 | java ServidorPedidos SJF  > /tmp/sjf.txt
```

Al pizarrón, tres columnas: **espera promedio FIFO, espera promedio SJF, espera máxima SJF**.

Lo que va a salir en todas las máquinas: SJF gana en promedio, y **pierde feo en el máximo**. Ese contraste es la lección de la semana, y hay que dejarlo escrito así: *una política puede mejorar el promedio de todos empeorando muchísimo la vida de uno*.

#### 2. Provocar la inanición

Ahora lo hacemos a propósito. Modifica tu generador para que produzca **un pedido enorme al principio** y después una lluvia de pedidos chicos:

```java
// En GeneradorPedidos, antes del ciclo normal:
System.out.println("999;" + productos[0] + ";50");   // el pedido gigante
```

Corre con SJF y sigue al pedido 999 en el log. **No lo van a atender nunca** mientras sigan llegando pedidos chicos.

Cronométrenlo. Cuánto lleva esperando cuando termina la corrida? En tu dominio: cuánto lleva ese cliente esperando su pedido de 50 piezas mientras despachan pedidos de 1?

#### 3. Arreglarlo con envejecimiento

Entre todos, en el pizarrón, la solución. Un pedido que lleva mucho esperando debe subir de prioridad. Implementación mínima en tu `siguiente()`:

```java
// En vez de elegir solo por cantidad, elige por una prioridad
// que empeora con el tamano y mejora con la espera.
long ahora = System.currentTimeMillis();
elegido = cola.stream()
    .min(Comparator.comparingDouble(p ->
         p.getCantidad() - (ahora - p.getHoraLlegada()) / 1000.0))
    .orElse(null);
```

Ese `/1000.0` es la constante de envejecimiento: cada segundo de espera le resta un punto al "tamaño efectivo" del pedido. Prueben con varios valores y vean el efecto:

| Constante de envejecimiento | Espera promedio | Espera máxima |
|---|---|---|
| Sin envejecimiento (SJF puro) | | |
| /1000 (1 punto por segundo) | | |
| /100 (10 puntos por segundo) | | |
| /10 | | |

Con la constante muy agresiva, SJF se convierte en FIFO. Vale la pena verlo: **la política no es una elección entre cajas cerradas, es un continuo**, y ese parámetro es la perilla.

#### 4. El planificador real, en vivo

Para terminar, veamos al planificador de Linux haciendo su trabajo. Saturen la máquina:

```bash
for i in $(seq 1 $(( $(nproc) * 3 ))); do java EstadoR & done
top
```

En `top`, miren la columna `NI` y la `%CPU`. Ahora bajen la prioridad de uno:

```bash
renice -n 19 -p PID_DE_UNO
```

Y véanlo perder terreno en `top` en tiempo real, sin que nadie lo haya detenido. Eso es el CFS repartiendo tiempo de forma proporcional.

Limpien con `pkill -f EstadoR`.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu servidor con el planificador integrado** y la política elegible desde la línea de comandos. Que el resumen final imprima siempre la política usada y las estadísticas de espera.

2. **Implementa el envejecimiento** si elegiste SJF, o documenta por qué no lo necesitas si elegiste FIFO. Una política que produce inanición sin control es un defecto, no una decisión.

3. **Deja escrita tu decisión en el README**, con el argumento del negocio: qué política, con qué parámetros, y qué cliente sale ganando y cuál perdiendo.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es el quantum y por qué existe. Qué pasaría sin él.
   - Las tres políticas comparadas con tus números medidos, no con los del ejemplo.
   - Qué es la inanición, cómo la provocaste y cómo la resolviste.
   - Qué relación hay entre lo que hace tu planificador con los pedidos y lo que hace el kernel con los procesos.

   ```bash
   git add .
   git commit -m "s10 proyecto: planificacion de pedidos con politica elegible"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Decidan la política del Servidor Central**, que es más interesante que la de una sucursal: los pedidos le llegan de tres sucursales distintas. Es justo que la sucursal que más pedidos manda acapare la atención? Discutan si conviene una cola por sucursal atendida por turnos (que es Round Robin entre sucursales) en vez de una sola cola global.

2. **Implementen y midan las dos opciones**, con las tres sucursales mandando carga desigual a propósito: una manda 100 pedidos, otra 20 y otra 5. Guarden la comparación.

3. **Anoten la pregunta y su respuesta:** si una sucursal se satura y llena la cola del central, qué pasa con las otras dos? Esa pregunta se contesta de verdad en la semana 12, cuando el buffer tenga un límite.
