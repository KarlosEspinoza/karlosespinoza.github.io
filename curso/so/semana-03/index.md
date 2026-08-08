---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 3 - Contenedores y concepto de proceso (U1-U2)

La semana pasada viste tu servidor desde fuera: su PID, su padre, su estado. Esta semana vas a ver **qué guarda el sistema operativo sobre él por dentro**, y vas a hacer que tu servidor **cree otro proceso**. Ese gesto, un proceso que crea a otro, es el que sostiene todo Linux y el que hace posible que un servidor atienda a varios clientes.

Y con eso ya tienes lo necesario para entender los **contenedores**, que es la palabra que más vas a oír cuando entres a trabajar. Un contenedor no es una máquina virtual ni una tecnología nueva: es un proceso normal al que el SO le está ocultando el resto del sistema. Vas a terminar la semana sabiendo exactamente qué le esconde y cómo.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: lo que el SO guarda de tu proceso](#bloque-1)
    - [Bloque 2: tu servidor crea otro proceso](#bloque-2)
    - [Bloque extra: tu servidor dentro de un contenedor](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes el descriptor de proceso y qué son namespaces y cgroups | Tu explicación de qué vería tu servidor dentro de un contenedor |
| 2 | Haces que tu servidor lance un proceso hijo | `src/GeneradorPedidos.java` y `evidencias/hijo.txt` |
| Extra | Corres tu servidor dentro de Docker | La comparación de `ps` dentro y fuera |

El bloque extra necesita instalar Docker Desktop, que tarda. **No es requisito de nada**: la clase del miércoles arranca solo con los bloques 1 y 2, y la demostración de Docker la hacemos ahí en conjunto.

---

### Bloque 1: lo que el SO guarda de tu proceso {#bloque-1}

#### El descriptor de proceso

Cuando el SO crea tu servidor, no solo lo carga en memoria: **abre un expediente sobre él**. Ese expediente se llama **descriptor de proceso** o **PCB** (Process Control Block), vive dentro del kernel, y es lo que hace posible que existan los procesos.

Contiene, entre otras cosas:

| Qué guarda | Para qué le sirve al SO |
|---|---|
| PID y PPID | Identificarlo y saber de quién es hijo |
| Estado (`R`, `S`, `D`, `T`, `Z`) | Decidir si es candidato a usar el procesador |
| Contenido de los registros del CPU | **Poder reanudarlo exactamente donde iba** |
| Mapa de su memoria | Saber qué zonas de RAM le pertenecen y cuáles no |
| Tabla de archivos abiertos | Traducir "mi archivo 3" al archivo real del disco |
| Usuario dueño y permisos | Decidir qué se le permite hacer |
| Tiempo de CPU consumido | Repartir con justicia y llevar la cuenta |

La tercera fila es la más importante de todas y merece que te detengas. Tu servidor **no corre solo**: comparte el procesador con todos los demás. Cada pocos milisegundos el SO lo detiene a media instrucción, le da el CPU a otro, y más tarde lo reanuda. Para que eso funcione, al detenerlo tiene que **guardar todo el estado del procesador** en el descriptor, y al reanudarlo, restaurarlo tal cual.

Eso se llama **cambio de contexto**, y es lo que hace que tu servidor tenga la ilusión de estar corriendo sin interrupciones cuando en realidad lo detienen y lo reanudan miles de veces por segundo. No es gratis: cuesta tiempo, y en la semana 10 vamos a medir cuánto.

Cuando en la semana 2 leíste `/proc/TU_PID/status`, lo que estabas leyendo era una versión legible de ese expediente.

#### El espacio de direcciones

Otra cosa que el descriptor guarda es **el mapa de memoria del proceso**. Y aquí hay una idea que va a reaparecer en la Unidad 3: cada proceso cree que la memoria es suya y empieza en cero.

Un proceso ve su memoria organizada así:

```
+---------------------------+  direcciones altas
|   Pila (stack)            |  variables locales, llamadas a metodos
|          |                |     crece hacia abajo
|          v                |
|                           |
|          ^                |
|          |                |     crece hacia arriba
|   Monton (heap)           |  todo lo que creas con "new"
+---------------------------+
|   Datos                   |  variables estaticas y constantes
+---------------------------+
|   Codigo (texto)          |  las instrucciones del programa
+---------------------------+  direcciones bajas
```

Si ya programaste en Java te suena, porque es justo la distinción entre **stack** y **heap** que usas sin pensarla: un `int` local vive en la pila, y un objeto creado con `new` vive en el montón. Lo nuevo aquí es de quién es esa organización: **no es de Java, es del proceso**, y el SO se la da a todos por igual.

Lo decisivo: **dos procesos no comparten espacio de direcciones**. Si tu servidor de farmacia y el de tu compañero corren en la misma máquina, la dirección de memoria número 5000 de uno **no tiene nada que ver** con la del otro. Son mapas separados y el SO garantiza que ninguno pueda leer el del otro.

Guarda esa frase, porque es la que va a explicar dos cosas más adelante:

- Por qué en la semana 4 usamos **hilos** para atender pedidos: los hilos del mismo proceso **sí** comparten el montón, y por eso pueden compartir el inventario.
- Por qué en la semana 8, para que dos **procesos** se pasen un pedido, hay que pedirle ayuda al SO: no pueden pasarse un objeto, porque el objeto vive en un mapa que el otro no puede ver.

#### Namespaces: el SO le miente al proceso

Ya tienes todo para entender qué es un contenedor.

Vimos que el SO le da a cada proceso su propia vista de la memoria. Un **namespace** extiende esa idea a **todo lo demás**: la lista de procesos, el sistema de archivos, la red, los usuarios. El kernel le puede dar a un proceso una vista recortada del sistema, y ese proceso no tiene forma de notarlo.

Linux tiene varios tipos de namespace. Los que importan:

| Namespace | Qué le oculta al proceso |
|---|---|
| PID | Solo ve los procesos de su grupo. **Él se cree el PID 1** |
| Mount | Solo ve el sistema de archivos que le montaron |
| Network | Tiene sus propias interfaces de red y sus propios puertos |
| User | Puede ser `root` adentro sin serlo afuera |

Entonces, un proceso dentro de un namespace de PID corre `ps -ef`, ve tres procesos y concluye que la máquina está casi vacía. Está equivocado, pero no tiene manera de saberlo: el kernel le contesta con la vista recortada.

**Eso es un contenedor.** No es una máquina virtual: no hay un segundo sistema operativo ni hardware emulado. Es **un proceso normal de tu Linux, corriendo con el kernel de siempre**, al que el SO le recortó la vista. Por eso arranca en un segundo y una máquina virtual tarda un minuto.

Y ya lo viste sin saberlo: en la semana 2, cuando el PID 1 de tu WSL2 resultó ser `/init` y no lo que esperabas, estabas mirando este mecanismo funcionando.

#### Cgroups: además de la vista, los recursos

Los namespaces controlan **lo que el proceso ve**. Los **cgroups** (control groups) controlan **lo que el proceso puede consumir**: cuánta CPU, cuánta memoria, cuánto disco.

Un cgroup es una etiqueta con un límite. "Este grupo de procesos no puede pasar de 512 MB de RAM ni de medio núcleo". Si el proceso intenta pasarse de memoria, el kernel lo mata, y vamos a ver exactamente ese mecanismo en la semana 12.

Los dos juntos son la definición completa:

> **Contenedor = un proceso + namespaces (lo que ve) + cgroups (lo que consume).**

Por qué te importa esto para tu carrera: cuando entres a una empresa, tu Servidor de Pedidos no se va a instalar en un servidor a mano. Se va a empaquetar en una imagen y va a correr en un contenedor, probablemente varios a la vez. Y ahora ya sabes que eso **no es magia de Docker**: es el kernel de Linux haciendo lo mismo que ya hacía con la memoria, aplicado a todo lo demás.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **Qué es el cambio de contexto** y por qué el descriptor de proceso tiene que guardar los registros del CPU. Con tus palabras.

2. **La tabla de tu servidor dentro de un contenedor.** Imagina que metes tu servidor en un contenedor con un namespace de PID y de red, y un cgroup de 256 MB:

   | Pregunta | Qué respondería mi servidor |
   |---|---|
   | Qué PID crees que tienes? | |
   | Cuántos procesos hay en la máquina? | |
   | Qué pasa si pides 400 MB de memoria? | |

3. **Una diferencia entre contenedor y máquina virtual**, explicada a partir de lo que leíste, no de lo que hayas oído antes.

```bash
git add .
git commit -m "s03 bloque 1: descriptor de proceso, namespaces y cgroups"
git push
```

---

### Bloque 2: tu servidor crea otro proceso {#bloque-2}

#### De dónde salen los procesos

Un proceso no aparece de la nada: **otro proceso lo crea**. Tu `bash` creó a `java`, y `java` puede crear a otro. Esa relación padre-hijo es la que viste en la columna PPID.

En Linux, por debajo, esto ocurre con dos llamadas al sistema: `fork()`, que crea una copia del proceso actual, y `exec()`, que reemplaza el contenido de esa copia por otro programa. Java te lo envuelve en una clase mucho más cómoda: **`ProcessBuilder`**.

Vas a usarlo para algo que tu proyecto necesita de verdad. Hasta hoy tu servidor está solo: no hay quien le mande pedidos. Vas a crear el programa que se los va a mandar.

#### El generador de pedidos

Crea `src/GeneradorPedidos.java`. Es un programa aparte, muy corto, que imprime unos cuantos pedidos de tu dominio y termina:

```java
// GeneradorPedidos.java - simula a un cajero que manda pedidos
public class GeneradorPedidos {

    public static void main(String[] args) {

        long pid = ProcessHandle.current().pid();
        System.out.println("Generador arrancado. PID " + pid);

        int cuantos = Integer.parseInt(args[0]);

        for (int i = 1; i <= cuantos; i++) {
            // TODO: imprime un pedido de TU dominio, con este formato:
            //       ID;PRODUCTO;CANTIDAD
            //       ejemplo de farmacia:  1;paracetamol;2
            //       Usa un arreglo de 4 o 5 productos tuyos y elige uno al azar.
            //       pista: java.util.Random y nextInt(productos.length)
        }

        System.out.println("Generador termina. PID " + pid);
    }
}
```

Nada de esto es nuevo para ti: es un arreglo, un ciclo y un `Random`. Lo dejo incompleto a propósito, porque lo que importa esta semana no es el generador, es **quién lo lanza**.

Pruébalo solo, para asegurarte de que funciona:

```bash
cd ~/so-proyecto/src
javac GeneradorPedidos.java
java GeneradorPedidos 5
```

#### Que tu servidor lo lance

Ahora la parte nueva. Agrega esto a `ServidorPedidos.java`, dentro del `main`, **antes** del ciclo `while`:

```java
// El servidor crea un proceso hijo y lo observa.
ProcessBuilder pb = new ProcessBuilder("java", "GeneradorPedidos", "5");
pb.inheritIO();                       // el hijo escribe en la misma terminal

Process hijo = pb.start();            // aqui nace el proceso hijo

registrar("Lance un hijo con PID " + hijo.pid());
registrar("Yo soy el PID " + pid + ", asi que soy su padre");

int salida = hijo.waitFor();          // el padre espera a que el hijo termine
registrar("El hijo termino con codigo " + salida);
```

Córrelo:

```bash
javac ServidorPedidos.java
java ServidorPedidos
```

Vas a ver los mensajes del padre y los del hijo mezclados en la misma terminal, con dos PIDs distintos.

#### Tres cosas que están pasando ahí

**`pb.start()` es donde nace el proceso.** En ese instante el kernel crea un descriptor nuevo, con su propio PID, su propio espacio de direcciones y su propia entrada en la tabla de procesos. El hijo **no comparte memoria** con tu servidor: si el generador cambiara una variable, tu servidor no se enteraría. Es exactamente lo que decía el bloque 1.

**`inheritIO()` le presta al hijo las salidas del padre**, y por eso ves sus mensajes en tu terminal. Sin esa línea, lo que el hijo imprime se va a un tubo hacia el padre y no lo ves. Ese tubo tiene nombre, se llama *pipe*, y es el tema de la semana 8.

**`waitFor()` es lo que evita el zombi.** El padre se queda bloqueado (en estado `S`) hasta que el hijo termina, y al terminar **recoge su código de salida**. Si no lo hicieras, el hijo quedaría en `Z`, como el que fabricamos en clase la semana pasada. Ese código de salida (0 si todo bien) es la única información que un hijo le devuelve a su padre por este camino.

#### Míralo con dos procesos vivos

Para alcanzar a ver a los dos al mismo tiempo, sube el número de pedidos a algo grande:

```java
new ProcessBuilder("java", "GeneradorPedidos", "2000000")
```

Córrelo y, desde una segunda terminal:

```bash
ps -ef | grep java
```

Ahí tienes las dos líneas: `ServidorPedidos` y `GeneradorPedidos`, con el PPID del segundo igual al PID del primero.

**Lo que entregas de este bloque**

1. `src/GeneradorPedidos.java` con el `TODO` resuelto y productos de **tu** dominio.
2. `src/ServidorPedidos.java` lanzando al hijo y esperándolo.
3. La evidencia de los dos procesos vivos:

   ```bash
   cd ~/so-proyecto
   ps -ef | grep java > evidencias/hijo.txt
   ```

4. En `BITACORA.md`, bajo `### Antes de la clase`:
   - El PID del padre y el del hijo, y cómo se ve la relación entre los dos en tu evidencia.
   - Qué pasaría si quitaras el `waitFor()`. (Puedes probarlo.)
   - Por qué el hijo **no puede** modificar una variable de tu servidor, con lo que aprendiste en el bloque 1.

```bash
git add .
git commit -m "s03 bloque 2: proceso hijo con ProcessBuilder"
git push
```

---

### Bloque extra: tu servidor dentro de un contenedor {#bloque-extra}

Opcional, y el que más tarda por la instalación. Si lo haces, vas a comprobar tú mismo lo del bloque 1.

Instala **Docker Desktop** en Windows y activa su integración con WSL2 (en Settings, Resources, WSL Integration). Comprueba desde Ubuntu:

```bash
docker --version
```

En la raíz de tu proyecto, crea un archivo llamado `Dockerfile` (sin extensión):

```dockerfile
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY src/ /app/
RUN javac ServidorPedidos.java GeneradorPedidos.java
CMD ["java", "ServidorPedidos"]
```

Constrúyelo y córrelo:

```bash
cd ~/so-proyecto
docker build -t mi-servidor .
docker run --rm -it mi-servidor
```

Ahora la comparación que vale. Entra al contenedor y mira los procesos desde dentro:

```bash
docker run --rm -it mi-servidor bash
ps -ef
```

Compara esa lista con la que sacaste en la semana 2 desde tu Ubuntu. Anota en la bitácora:

| Pregunta | Fuera (WSL2) | Dentro del contenedor |
|---|---|---|
| Cuántos procesos ve `ps -ef`? | | |
| Qué PID tiene tu servidor? | | |
| Qué usuario eres (`whoami`)? | | |

Y prueba el cgroup, que es la otra mitad:

```bash
docker run --rm -it --memory=256m mi-servidor
```

```bash
git add .
git commit -m "s03 extra: servidor en contenedor"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu servidor lanzando un hijo y con tu tabla de namespaces escrita. Hoy comprobamos lo que predijiste y le damos forma al dato central del proyecto.

**1. La demostración de los namespaces.** Corremos un contenedor en pantalla grande y hacemos `ps -ef` dentro y fuera al mismo tiempo. Vamos cotejando contra la tabla que cada quien escribió el lunes: quién acertó en que se vería como PID 1, quién esperaba ver la máquina completa. Después, desde fuera, buscamos **ese mismo proceso** en la lista de la máquina anfitriona y comprobamos que ahí tiene otro PID. El mismo proceso, dos números, según quién pregunte.

**2. El cgroup mata.** Corremos un servidor con `--memory=64m` y lo forzamos a pedir más. Miramos cómo el kernel lo mata y dónde queda registrado. Es la primera aparición del OOM killer, que es tema completo de la semana 12.

**3. Modelamos el pedido, entre todos.** Aquí bajamos del SO al diseño. Un pedido de tu dominio, qué datos tiene exactamente? Lo discutimos en el pizarrón hasta sacar una lista mínima común (identificador, producto, cantidad, hora, estado) y cada quien la adapta a lo suyo. De ahí sale `Pedido.java`, que es lo que te llevas de tarea.

**4. La pregunta que abre la Unidad 2.** Tu servidor lanza un hijo y lo espera con `waitFor()`. Mientras espera, está bloqueado. Ahora imagina 5 cajeros mandando pedidos a la vez: si tu servidor atiende a uno y se bloquea, qué pasa con los otros cuatro? Esa pregunta es la Unidad 2 completa, y la respuesta empieza la semana que viene.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Crea `src/Pedido.java`** con los datos del pedido de tu dominio, según lo que acordamos en clase. Es Java que ya sabes: atributos, constructor, getters y un `toString()`. Lo único que pido es que el `toString()` produzca **la misma línea con el formato `ID;PRODUCTO;CANTIDAD`** que imprime tu generador, porque en la semana 4 el servidor va a tener que leer esas líneas y convertirlas de vuelta en objetos.

2. **Crea `datos/catalogo.txt`** con el catálogo de tu dominio: al menos **8 productos**, uno por línea, con este formato:

   ```
   ID;NOMBRE;PRECIO;EXISTENCIA
   1;paracetamol;35.50;12
   2;ibuprofeno;42.00;8
   3;amoxicilina;120.00;3
   ```

   Pon existencias **bajas** a propósito, entre 1 y 15. En la semana 5 vas a necesitar que el inventario se agote rápido para poder romperlo.

3. **Haz que tu `GeneradorPedidos` use productos que existan en tu catálogo.** Por ahora escríbelos a mano en el arreglo; en la semana 13 el servidor va a leer el archivo de verdad.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es un contenedor, con tus palabras, y por qué no es una máquina virtual.
   - Qué guarda el SO en el descriptor de tu proceso y por qué le hace falta.
   - Qué datos tiene un pedido en tu dominio y por qué elegiste esos.

   ```bash
   git add .
   git commit -m "s03 proyecto: modelo de pedido y catalogo"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Las tres sucursales van a tener que entenderse entre ellas a partir de la Unidad 2, y eso empieza por hablar el mismo idioma.

1. **Acuerden el formato de línea de un pedido** y déjenlo escrito en el README del equipo. Nuestra recomendación es `ID;PRODUCTO;CANTIDAD`, pero si su sistema necesita un campo más (la sucursal, por ejemplo), decídanlo ahora y anótenlo. Cambiarlo en la semana 16, con todo conectado, es carísimo.

2. **Cada quien conserva su propio catálogo**, con sus productos y sus precios. Lo que se comparte es el formato del archivo, no el contenido.

3. **Discutan una pregunta y anoten su respuesta:** cuando tengan el Servidor Central, cada sucursal va a ser un proceso independiente. Qué ventaja tiene eso frente a hacer un solo programa gigante que atienda las tres? Con lo del bloque 1 ya tienen con qué contestarla, y es justo lo que voy a preguntar en la revisión de la semana 9.
