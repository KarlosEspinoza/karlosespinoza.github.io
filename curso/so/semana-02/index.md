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

Y lo de siempre: **si te atoras, escríbelo en la bitácora y haz commit igual**. Un "no me salió, `ps` no me muestra mi proceso" es información útil para el miércoles.

---

### Bloque 1: el árbol de procesos de tu máquina {#bloque-1}

#### Programa y proceso no son lo mismo

Esta distinción parece de diccionario y no lo es. Es la base de toda la Unidad 2.

Un **programa** es un archivo muerto en el disco: `ServidorPedidos.class`, unos bytes guardados. Un **proceso** es ese programa **en ejecución**: cargado en memoria, con un número que lo identifica, con instrucciones ejecutándose, con archivos abiertos y con una porción de CPU asignada.

De un mismo programa pueden salir **muchos procesos a la vez**, y cada uno es independiente del otro. Es exactamente lo que va a pasar en tu proyecto integrador: tres sucursales corriendo el mismo tipo de servidor, cada una con su propio inventario, sin enterarse una de la otra.

Cada proceso tiene un número único, el **PID** (Process ID), que el SO le asigna al nacer. Y tiene un **PPID**, el PID de su padre: el proceso que lo lanzó. Porque en Linux los procesos no aparecen de la nada, **alguien los crea**. Tu terminal crea a `java`, y de ahí para arriba hasta el primer proceso del sistema.

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

3. Una pregunta para contestar en dos líneas: **el proceso con PID 1, quién es y quién es su padre?** Búscalo con `ps -ef | head -3` y explica lo que ves.

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

Llegas con tu servidor escrito y corriendo, y con tu `evidencias/procesos.txt` hecho. Hoy toca romperlo, que es la mejor forma de entender qué lo sostiene.

**1. El padre y el huérfano.** Lanzas tu servidor desde una terminal y **cierras la terminal**. Qué le pasa al proceso? Lo buscamos con `ps -ef` y miramos su PPID: cambió. Alguien lo adoptó. De ahí sale la conversación de por qué el SO no deja procesos sin padre, y de por qué un servidor de verdad se lanza de una manera que sobrevive a la terminal.

**2. La fábrica de zombis.** Escribimos juntos un programa de tres líneas que lanza un hijo y no recoge su resultado, y lo vemos aparecer como `Z` en `ps`. Un zombi no consume CPU ni memoria, pero **ocupa un PID**, y los PIDs se acaban. Es el primer caso del curso de un recurso del SO que se puede agotar por un descuido del programador.

**3. Comparación de estados.** Cada quien pone su servidor en un estado distinto y comparamos: uno dormido en `S`, otro pausado con `Ctrl + Z` en `T`, otro con un ciclo sin `sleep` clavado en `R` al 100% de CPU. Ese último es el que hay que ver bien en `top`, porque es el error que vamos a diagnosticar en la semana 6.

**4. El costo de arrancar.** Medimos con `time` cuánto tarda en arrancar la JVM contra lo que tarda un programa en C. La diferencia lleva directo a la pregunta de la semana que viene: qué hace el SO cuando crea un proceso, y por qué eso no es gratis.

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
