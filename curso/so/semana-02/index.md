---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 2 - Linux y el primer proceso (U1)

La semana pasada dijimos que tu servidor es un programa que vive sobre el sistema operativo. Esta semana **lo vas a ver con tus propios ojos**: vas a escribir la primera versión de tu Servidor de Pedidos, ponerla a correr sobre Linux y observarla desde afuera como lo que es, un proceso más entre los cientos que tiene tu máquina.

Este es el salto de "el SO administra programas" a "el SO está administrando **el mío**, y aquí está la prueba". A partir de hoy, cada vez que hablemos de estados, memoria o señales, vas a poder ir a tu terminal y mirar qué está pasando con tu propio proceso.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: el árbol de procesos de tu máquina](#bloque-1)
    - [Bloque 2: tu servidor como proceso vivo](#bloque-2)
    - [Bloque extra: la ficha completa de tu proceso](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Aprendes a mirar los procesos de tu máquina | `evidencias/procesos.txt` y tu lectura de 3 procesos |
| 2 | Escribes y corres tu servidor, y lo observas | `src/ServidorPedidos.java` y `evidencias/servidor.txt` |
| Extra | Lees la ficha completa que el kernel lleva de tu proceso | La tabla de campos de `/proc` |

Todo dentro de la terminal de Ubuntu (WSL2). Un commit al terminar cada bloque.

Y lo de siempre: **si te atoras, lo documentas y haces commit igual**. Con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja) de la semana pasada: comando exacto, error completo copiado y pegado, qué intentaste en orden, y dónde te quedaste. Así vale como bloque entregado.

---

### Bloque 1: el árbol de procesos de tu máquina {#bloque-1}

#### Programa y proceso no son lo mismo

Esta distinción parece de diccionario y no lo es. Es la base de toda la Unidad 2.

Un **programa** es un archivo muerto en el disco: `ServidorPedidos.class`, unos bytes guardados. Un **proceso** es ese programa **en ejecución**: cargado en memoria, con un número que lo identifica, con instrucciones ejecutándose, con archivos abiertos y con una porción de CPU asignada.

De un mismo programa pueden salir **muchos procesos a la vez**, y cada uno es independiente del otro. Es exactamente lo que va a pasar en tu proyecto integrador: tres sucursales corriendo el mismo tipo de servidor, cada una con su propio inventario, sin enterarse una de la otra.

Cada proceso tiene un número único, el **PID** (Process ID), que el SO le asigna al nacer. Y tiene un **PPID**, el PID de su padre: el proceso que lo lanzó. Porque en Linux los procesos no aparecen de la nada, **alguien los crea**. Tu terminal crea a `java`, y de ahí para arriba hasta el primer proceso del sistema.

#### De dónde sale el primer proceso

Si todo proceso lo crea otro proceso, la pregunta obvia es quién creó al primero. Y para contestarla hay que retroceder hasta el momento en que aprietas el botón de encendido.

Cuando la máquina arranca, la RAM está vacía: no hay sistema operativo, porque el SO también es un programa y también está guardado en el disco. Alguien tiene que ir por él. Ese alguien es una cadena de cuatro pasos, cada uno cargando al siguiente:

```
1. Firmware (BIOS o UEFI)   <- vive en un chip de la tarjeta madre, no en el disco
        |
        v
2. Cargador de arranque     <- un programa chiquito en el disco (GRUB)
        |
        v
3. Kernel del SO            <- se copia a la RAM y toma el control
        |
        v
4. Primer proceso, PID 1    <- el kernel lo crea a mano
```

**1. El firmware.** Es el único programa que no está en el disco: viene grabado en un chip de la tarjeta madre, así que existe desde antes que cualquier sistema operativo. En las máquinas viejas se llamaba **BIOS**; en las de hoy es **UEFI** (también escrito EFI), que hace lo mismo pero moderno. Su trabajo es corto: revisa que el hardware básico responda, decide de cuál disco se va a arrancar y le pasa el control a lo que encuentre ahí.

**2. El cargador de arranque.** En Linux normalmente es **GRUB**, y es ese menú negro donde a veces alcanzas a ver dos versiones del sistema. Es un programa muy pequeño cuyo único propósito es encontrar el archivo del kernel en el disco, copiarlo a la memoria y saltar a él.

**3. El kernel toma el control.** Ya en RAM, inicializa el hardware de verdad, monta el sistema de archivos raíz y se convierte en lo que va a ser el resto del tiempo: el administrador del que hablamos la semana pasada.

**4. El kernel crea el PID 1 a mano.** Y aquí está la respuesta. El primer proceso **no lo crea otro proceso: lo crea el kernel directamente**, por eso es el único cuyo padre no existe. En un Linux normal ese primer proceso es `systemd`; en WSL2 es `/init`. A partir de ahí ya todo sigue la regla: el PID 1 arranca los servicios, alguno de ellos arranca tu terminal, tu terminal arranca a `java`. **El árbol de procesos que vas a mirar en un momento tiene raíz, y esa raíz es el final del arranque.**

Un aviso para que no lo busques y no lo encuentres: en tu laptop **no vas a ver GRUB**. Quien arrancó con UEFI fue Windows; WSL2 lanza después una máquina virtual ligera que salta directo al paso 3, sin firmware ni cargador propios. La cadena completa la verías en una computadora con Linux instalado directamente, y es exactamente la que sigue cualquier servidor de los que vas a administrar.

#### Qué hace el PID 1 el resto del tiempo

Vale la pena detenerse un momento en ese primer proceso, porque es el que vas a usar todos los días si acabas administrando servidores.

En un Linux de servidor el PID 1 es **`systemd`**, y su trabajo no termina al arrancar. Es quien mantiene vivos los **servicios**: la base de datos, el servidor web, y algún día tu Servidor de Pedidos. Un servicio es simplemente un proceso que `systemd` arranca al encender la máquina, vigila mientras corre, y reinicia si se cae. Dos comandos concentran casi todo el trato con él:

```bash
systemctl status nombre-del-servicio    # esta vivo? desde cuando? se cayo?
journalctl -u nombre-del-servicio -f    # sus ultimas lineas de log, en vivo
```

Cuando en un trabajo te digan "revisa por qué se cayó el servicio", eso es lo que vas a teclear.

**En tu WSL2 no van a funcionar todavía**, y ya sabes por qué: tu PID 1 no es `systemd`, es `/init`. Compruébalo:

```bash
ps -p 1 -o pid,comm
systemctl status          # probablemente falle, y esta bien
```

No es un problema que haya que resolver hoy. Lo que importa es que ubiques la pieza: **el PID 1 es el que sostiene todo lo que corre en un servidor**, y en la semana 8, cuando tu servidor aprenda a apagarse de forma ordenada, vas a ver que la secuencia que usa `systemd` para detener un servicio es exactamente la que vas a programar. Ahí puedes convertir tu servidor en un servicio de verdad, si quieres.

#### Mirar los procesos: `ps`

`ps` lista procesos. La forma que vas a usar todo el semestre:

```bash
ps -ef
```

`-e` es "todos los procesos" y `-f` es "formato completo". Las columnas que importan:

```
UID    PID   PPID  C STIME TTY   TIME     CMD
karlos 812   811   0 14:02 pts/0 00:00:00 -bash
karlos 940   812   0 14:05 pts/0 00:00:01 java ServidorPedidos
```

Lee la segunda línea así: el proceso **940** es `java ServidorPedidos`, y su padre es el **812**, que es el `bash` de tu terminal. Si cierras esa terminal, ya te puedes imaginar qué le va a pasar al 940. Lo comprobamos el miércoles.

Cuando ya sepas el PID, pide justo lo que te interesa:

```bash
ps -o pid,ppid,stat,%cpu,%mem,etime,cmd -p 940
```

#### La columna que hay que aprenderse: STAT

`stat` es el **estado** del proceso, y es la columna más informativa de todas. Estas son las letras que vas a ver:

| Letra | Significa | Cuándo aparece |
|---|---|---|
| `R` | En ejecución o listo para ejecutarse | El proceso está usando CPU o esperando turno |
| `S` | Dormido, interrumpible | Está esperando algo (un teclazo, red, un temporizador). **Es el estado normal de un servidor** |
| `D` | Dormido, no interrumpible | Esperando al disco. Si ves muchos, tu disco es el cuello de botella |
| `T` | Detenido | Alguien lo pausó (por ejemplo con `Ctrl + Z`) |
| `Z` | Zombi | Ya terminó, pero su padre no ha recogido su resultado |

Además puede traer un sufijo: `+` significa que está en primer plano en la terminal, y `l` que tiene varios hilos (eso te va a importar mucho en la semana 4).

Fíjate en algo que sorprende a todos: **un servidor sano pasa casi todo el tiempo en `S`, no en `R`**. Estar dormido esperando trabajo no es estar fallando, es estar bien hecho. Un servidor que siempre está en `R` normalmente está desperdiciando CPU en un ciclo que no espera nada, y ese es un error que vamos a cometer a propósito en la semana 6 para ver cuánto cuesta.

#### Verlos moverse: `top`

`ps` es una foto. `top` es video:

```bash
top
```

Se actualiza solo. Teclas útiles mientras corre: `M` ordena por memoria, `P` por CPU, `H` muestra hilos en vez de procesos (semana 4), y `q` sale.

#### De dónde saca `ps` la información

Aquí viene lo bonito, y es muy propio de Linux: `ps` no tiene ningún poder especial. Solo **lee archivos**. El kernel expone el estado de cada proceso como si fuera un sistema de archivos, en `/proc`:

```bash
ls /proc
```

Vas a ver un montón de carpetas numeradas. **Cada número es el PID de un proceso vivo.** Dentro de cada una está su ficha:

```bash
cat /proc/940/status
```

Esos archivos no existen en el disco: los inventa el kernel en el momento en que los lees. Es la manera que tiene el SO de contestar preguntas sobre sí mismo usando la herramienta que ya tienes: leer un archivo. Volveremos a `/proc` en la Unidad 3 para medir la memoria de tu servidor.

**Lo que entregas de este bloque**

1. La foto de los procesos de tu máquina:

   ```bash
   cd ~/so-proyecto
   ps -ef > evidencias/procesos.txt
   ```

2. En `BITACORA.md`, bajo `### Antes de la clase`, **elige 3 procesos de tu propia lista** (no de la de la guía) y llena esta tabla:

   | PID | PPID | STAT | Qué creo que es y por qué está en ese estado |
   |---|---|---|---|

   Elige uno que esté en `S` y explica qué crees que está esperando. Esa columna es la que vale.

3. Dos preguntas cortas sobre la raíz del árbol:

   - **El proceso con PID 1, quién es y qué PPID tiene?** Búscalo con `ps -ef | head -3` y explica qué significa el número que aparece en su columna PPID.
   - **Por qué ese proceso es el único que no pudo ser creado por otro proceso?** Contéstala con la cadena de arranque, en tres o cuatro líneas.

```bash
git add .
git commit -m "s02 bloque 1: arbol de procesos observado"
git push
```

---

### Bloque 2: tu servidor como proceso vivo {#bloque-2}

#### Por qué un servidor no termina

Un programa normal hace su trabajo y se acaba. Un servidor no: **se queda esperando**. Esa es la diferencia de fondo entre el `main` que has escrito en otras materias y el que vas a escribir hoy.

Si tu servidor imprimiera "Servidor listo" y terminara, sería inútil: nadie podría mandarle un pedido, porque para cuando el primer cajero escribiera algo, el proceso ya no existiría. Un servidor tiene que **seguir vivo indefinidamente**, ocupando un lugar en la tabla de procesos del SO, hasta que alguien lo apague.

Por eso la primera versión de tu servidor es un ciclo que no termina.

#### El código

Crea `src/ServidorPedidos.java`:

```java
// ServidorPedidos.java - el servidor existe como proceso en el SO
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class ServidorPedidos {

    // TODO: cambia esto por el nombre de tu negocio
    static final String NEGOCIO = "Farmacia SaludYa";

    public static void main(String[] args) throws InterruptedException {

        // Le preguntamos al SO cual es nuestro propio numero de proceso.
        long pid = ProcessHandle.current().pid();

        registrar("Servidor de " + NEGOCIO + " listo. PID " + pid);

        // TODO: registra tambien en que directorio arranco el servidor.
        //       pista: System.getProperty("user.dir")

        // Un servidor no termina: se queda vivo esperando trabajo.
        // Por ahora "esperar" es solo dormir y dar senales de vida.
        while (true) {
            Thread.sleep(5000);
            registrar("En espera de pedidos");
        }
    }

    static void registrar(String mensaje) {
        String hora = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"));
        System.out.println("[" + hora + "] " + mensaje);
    }
}
```

Tres cosas que vale la pena que notes:

**`ProcessHandle.current().pid()`** es una llamada al sistema disfrazada. Java le está preguntando al kernel "cuál es mi PID", porque el proceso no lo sabe por sí mismo: es el SO quien se lo asignó. Es la primera vez en el curso que tu código le pide algo al SO de forma explícita.

**El `Thread.sleep(5000)`** no es un relleno. Es lo que mantiene al proceso en estado `S` en vez de `R`. Dormir es la manera correcta de esperar: el proceso le dice al SO "despiértame en 5 segundos" y mientras tanto **no consume CPU**. En la semana 6 vas a ver la alternativa mala, que es quedarse dando vueltas en un ciclo vacío, y vas a medir cuánto cuesta.

**El `while (true)`** es el esqueleto de todo servidor. En la semana 4 lo que hay dentro deja de ser un `sleep` y pasa a ser "leer un pedido y atenderlo". En la 16 pasa a ser "aceptar una conexión". La forma no cambia; cambia el trabajo.

#### Ponlo a correr

```bash
cd ~/so-proyecto/src
javac ServidorPedidos.java
java ServidorPedidos
```

Deberías ver la línea de arranque con tu PID, y cada 5 segundos una línea nueva. **Déjalo corriendo** y abre una **segunda terminal de Ubuntu** para observarlo desde fuera:

```bash
ps -ef | grep ServidorPedidos
```

Ahí está tu proceso, con su PID y su PPID. Ahora mira su estado, sustituyendo por tu número:

```bash
ps -o pid,ppid,stat,%cpu,%mem,etime,cmd -p TU_PID
```

Casi siempre lo vas a atrapar en `S`, durmiendo, con `%cpu` en 0.0. Eso es exactamente lo que debe pasar.

Para detenerlo, en la primera terminal: `Ctrl + C`.

#### Correrlo en segundo plano y guardar su salida

Un servidor de verdad no ocupa tu terminal ni escribe en tu pantalla: corre en segundo plano y **escribe a un archivo de registro**. Se hace así:

```bash
cd ~/so-proyecto/src
java ServidorPedidos > ../datos/servidor.log 2>&1 &
```

Tres piezas que conviene entender por separado, porque son de las cosas que más se usan en el trabajo real:

- `> ../datos/servidor.log` manda la **salida normal** al archivo en vez de a la pantalla.
- `2>&1` manda también la **salida de errores** al mismo lugar. Sin esto, los errores se te van a la pantalla y no quedan registrados. En la Unidad 4 vas a entender por qué se escribe con esos números raros: son los descriptores de archivo 1 y 2.
- `&` lo lanza en **segundo plano**, y te devuelve la terminal de inmediato.

Comprueba que está vivo y que está escribiendo:

```bash
jobs
tail -f ../datos/servidor.log
```

`tail -f` te muestra el archivo conforme crece. Sales con `Ctrl + C`, y eso **no mata al servidor**: solo deja de mirar el archivo. Para apagarlo de verdad:

```bash
kill TU_PID
```

**Lo que entregas de este bloque**

1. `src/ServidorPedidos.java` con los dos `TODO` resueltos y el nombre de tu negocio.

2. La evidencia de que corrió y de que lo observaste:

   ```bash
   cd ~/so-proyecto
   ps -o pid,ppid,stat,%cpu,%mem,etime,cmd -p TU_PID > evidencias/servidor.txt
   ```

3. `datos/servidor.log` con al menos tres líneas.

4. En `BITACORA.md`, bajo `### Antes de la clase`:
   - Tu PID y tu PPID, y **quién es el padre de tu servidor**.
   - En qué estado lo encontraste y por qué en ese y no en otro.
   - Qué `%cpu` tenía, y por qué ese número es el correcto para un servidor que "no está haciendo nada".

```bash
git add .
git commit -m "s02 bloque 2: servidor corriendo como proceso"
git push
```

---

### Bloque extra: la ficha completa de tu proceso {#bloque-extra}

Opcional. Con tu servidor corriendo, mira la ficha que el kernel lleva de él:

```bash
cat /proc/TU_PID/status
```

Son unas 50 líneas. Localiza estas y anota su valor en tu bitácora:

| Campo | Qué es |
|---|---|
| `Name` | El nombre del ejecutable. Ojo: no dice `ServidorPedidos` |
| `State` | El mismo estado que viste en `ps`, pero con su nombre completo |
| `Pid` / `PPid` | Los que ya conoces |
| `Threads` | Cuántos hilos tiene. Te va a sorprender el número |
| `VmSize` | Memoria virtual que pidió |
| `VmRSS` | Memoria física que de verdad está ocupando |

Dos cosas para pensar y escribir, que son adelantos de unidades que vienen:

1. **`Threads` no dice 1**, aunque tu programa solo tenga un `main`. Investiga por qué y anótalo. (Pista: la JVM tiene trabajo propio que hacer mientras tu código corre.) Esto es la semana 4.
2. **`VmSize` es muchísimo más grande que `VmRSS`.** Anota los dos números y la diferencia. Esa diferencia es el tema completo de la semana 11.

```bash
git add .
git commit -m "s02 extra: ficha de proceso en /proc"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu servidor escrito y corriendo, y con tu `evidencias/procesos.txt` hecho. Hoy toca romperlo, que es la mejor forma de entender qué lo sostiene. Trae tu laptop y ten tu proyecto compilado.

Cada actividad trae los comandos y el esqueleto de código listos. **Lo que no viene es la explicación**: eso es lo que vas a escribir tú, y lo que discutimos entre todos.

#### 1. El padre y el huérfano

Lanza tu servidor en segundo plano y anota los dos números que salen:

```bash
cd ~/so-proyecto/src
java ServidorPedidos > ../datos/servidor.log 2>&1 &
ps -o pid,ppid,stat,cmd -p $!
```

`$!` es el PID del último proceso que lanzaste en segundo plano, así no tienes que buscarlo.

Ahora **cierra esa terminal completa** (la X de la ventana, no `Ctrl + C`). Abre una terminal nueva y búscalo otra vez:

```bash
ps -o pid,ppid,stat,cmd -C java
```

Compara las dos salidas y contesta: **sigue vivo? qué cambió?** La columna que hay que mirar es PPID. Después de eso, la pregunta buena: **por qué el SO se toma la molestia de buscarle un padre nuevo en vez de dejarlo huérfano?**

#### 2. La fábrica de zombis

Crea `Zombi.java` en tu `src/`. Está casi completo: lo único que le falta es lo que **no** hay que hacer.

```java
// Zombi.java - un padre descuidado
public class Zombi {
    public static void main(String[] args) throws Exception {

        ProcessBuilder pb = new ProcessBuilder("sleep", "1");
        Process hijo = pb.start();

        System.out.println("Hijo lanzado con PID " + hijo.pid());

        // TODO: aqui DEBERIA ir hijo.waitFor(), pero lo omitimos a proposito.
        //       El padre se queda vivo un minuto sin recoger al hijo.
        Thread.sleep(60000);
    }
}
```

```bash
javac Zombi.java
java Zombi
```

Anota el PID que imprime. En **otra terminal**, espera 2 segundos y busca al hijo:

```bash
ps -ef | grep defunct
```

`defunct` es como `ps` escribe "zombi". Míralo también en la columna STAT:

```bash
ps -o pid,ppid,stat,cmd -C sleep
```

Tres cosas que vas a comprobar y anotar:

1. Cuánta CPU y memoria consume el zombi. (Míralo con `ps -o pid,stat,%cpu,%mem,cmd`.)
2. Qué le pasa al zombi cuando **matas al padre**: `kill PID_DEL_PADRE`, y vuelve a buscarlo.
3. Cuántos PIDs tiene tu sistema en total: `cat /proc/sys/kernel/pid_max`.

Con esos tres datos, la pregunta que cierra la actividad: **si un zombi no gasta CPU ni memoria, por qué es un problema?** Y la versión de tu proyecto: si tu servidor creara un proceso por pedido y se le olvidara el `waitFor()`, cuánto aguantaría atendiendo 50 pedidos por minuto?

#### 3. Comparación de estados

Aquí ponemos el mismo tipo de programa en tres estados distintos y los miramos lado a lado. Crea `EstadoR.java`, que es el servidor mal hecho:

```java
// EstadoR.java - la version mala de esperar
public class EstadoR {
    public static void main(String[] args) {

        System.out.println("PID " + ProcessHandle.current().pid());

        long inicio = System.currentTimeMillis();

        // Espera exactamente lo mismo que el servidor: 60 segundos.
        // Pero en vez de dormir, se queda preguntando la hora sin parar.
        while (System.currentTimeMillis() - inicio < 60000) {
            // a proposito vacio
        }

        System.out.println("Termine");
    }
}
```

Lee las dos versiones juntas antes de correr nada: `ServidorPedidos` espera con `Thread.sleep`, `EstadoR` espera con un ciclo vacío. **Las dos esperan lo mismo, 60 segundos.**

Ahora los tres estados. Necesitas tres terminales:

```bash
# Terminal 1: estado S
java ServidorPedidos

# Terminal 2: estado R
java EstadoR

# Terminal 3: observar
top
```

En `top`, teclea `P` para ordenar por CPU. Los dos `java` van a estar en la lista con números muy distintos.

Para el tercer estado, vuelve a la terminal 1 y presiona **`Ctrl + Z`**. Eso pausa el proceso. Míralo:

```bash
ps -o pid,stat,%cpu,cmd -C java
```

Llena esta tabla con **tus** números:

| Programa | STAT | %CPU | Qué está esperando | Cuánto trabajo útil hace |
|---|---|---|---|---|
| `ServidorPedidos` | | | | |
| `EstadoR` | | | | |
| `ServidorPedidos` pausado con `Ctrl + Z` | | | | |

Para reanudar el pausado: `fg`. Para matar el de `R`: `Ctrl + C`.

La pregunta que dejamos abierta y **no vamos a responder hoy**: los dos esperan 60 segundos y los dos acaban al mismo tiempo. Por qué uno gasta el 100% de un núcleo y el otro casi 0? Eso se llama espera activa y es la semana 6.

#### 4. El costo de arrancar

Un programa que no hace nada, en dos lenguajes. Primero el de C, que lo escribes con un solo comando:

```bash
printf '#include <stdio.h>\nint main(){printf("listo\\n");return 0;}\n' > /tmp/listo.c
gcc /tmp/listo.c -o /tmp/listo
```

Y el equivalente en Java, `Vacio.java`:

```java
public class Vacio {
    public static void main(String[] args) {
        System.out.println("listo");
    }
}
```

Mídelos:

```bash
time /tmp/listo
time java Vacio
```

De las tres líneas que imprime `time`, la que nos interesa es `real`. Anota los dos números y **el factor entre ellos**.

La conversación que abre esto: los dos programas imprimen una palabra. Entonces **en qué se le fue al segundo todo ese tiempo?** No se le fue a tu código: se le fue al SO creando el proceso y a la JVM montándose. La semana que viene vemos exactamente qué hace el SO en ese rato, y en la semana 4 vas a ver por qué eso nos obliga a atender los pedidos con hilos y no con procesos.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu servidor arrancando de forma limpia** desde la raíz del proyecto, sin rutas raras. Comprueba que el log se escribe en `datos/servidor.log`.

2. **Agrega el manejo del caso "ya está corriendo".** Si lanzas dos veces tu servidor, ahora tienes dos procesos escribiendo al mismo log y pisándose. Todavía no sabemos resolverlo bien (eso es la Unidad 2), pero **documenta el problema**: lánzalo dos veces, mira los dos PIDs con `ps`, y anota qué pasó con el log.

3. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es un proceso, con tus palabras, y en qué se diferencia del programa que escribiste.
   - Cómo vive tu servidor en el SO: su PID, su padre, su estado y su consumo.
   - Qué pasó cuando lo lanzaste dos veces, y qué crees que habría que hacer al respecto.

   ```bash
   git add .
   git commit -m "s02 proyecto: servidor observable como proceso"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Cada integrante ya tiene su servidor corriendo. Junten las tres sucursales **en una sola máquina, al mismo tiempo**:

1. Cada quien lanza su servidor en segundo plano en la misma máquina de un integrante.
2. Sáquenle una foto conjunta con `ps -ef | grep java` donde se vean **los tres procesos con PIDs distintos**.
3. Guárdenla en el repositorio del equipo y anoten en el README del equipo qué PID corresponde a qué sucursal.

Es una demostración chiquita pero importante: tres programas iguales, tres procesos independientes, y el SO llevando la cuenta de cada uno. Es la base de todo lo que van a integrar el resto del semestre.
