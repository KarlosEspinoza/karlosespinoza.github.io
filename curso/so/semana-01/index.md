---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 1 - Encuadre y configuración del entorno (U1)

Esta primera semana tiene dos metas. La primera es dejar **listo tu entorno de trabajo** y creado el repositorio donde va a vivir tu proyecto durante todo el semestre. La segunda es entender, desde cero, **qué es un sistema operativo y por qué es el punto de partida de todo el software que vas a escribir**.

Todo el curso gira alrededor de un solo sistema que vas a construir tú mismo: un **Servidor de Pedidos**. Imagina el sistema que usa una tienda para vender: hay varias cajas atendiendo clientes al mismo tiempo, y todas comparten un mismo inventario. Ese tipo de sistema, el que opera por ejemplo una empresa como SICAR, es justo el que iremos levantando capa por capa. Cada concepto de sistemas operativos va a aparecer de forma natural cuando tu servidor lo necesite, no porque venga en el temario.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: tu entorno y tu repositorio](#bloque-1)
    - [Bloque 2: qué es un sistema operativo y dónde vive tu servidor](#bloque-2)
    - [Bloque extra: el mapa de tu servidor](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

Esta guía se trabaja **durante la sesión**, no en tu casa la noche anterior ni la madrugada del miércoles. Está partida en **dos bloques obligatorios y uno extra**, y cada bloque termina con algo concreto que subes a tu repositorio. Así tu trabajo queda registrado conforme lo vas haciendo, sin que tengas que entregar nada aparte.

Pregunta en cuanto algo no salga. No te aguantes la duda hasta el final: se resuelve mucho más rápido en el momento en que aparece que media hora después, cuando ya le moviste a cinco cosas y ya no sabes cuál fue.

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Instalas el entorno y creas tu repositorio | El repositorio con su estructura y tu `README.md` |
| 2 | Entiendes qué es el SO y eliges tu dominio | Tu entrada de `BITACORA.md` |
| Extra | Trazas el mapa completo de tu servidor | La tabla de lo que tu servidor le pedirá al SO |

El **bloque extra es opcional**. Es para quien terminó los dos primeros y quiere que su proyecto llegue más lejos. No hace falta para la clase del miércoles, y no pasa nada si no lo haces.

#### Si te atoras, se documenta y se hace commit igual

Esta es la regla más importante de todo el semestre, y aplica a las 17 semanas.

**Nunca te quedes sin entregar por no haberlo logrado.** Un bloque que no salió, pero que está bien documentado, **cuenta como entregado**. Lo que no cuenta es no dejar rastro.

Ahora, "documentado" tiene una forma, y no es escribir "no me salió". Cuando algo se rompa, abre en tu `BITACORA.md` una subsección `#### Atorones` y anota **cuatro cosas**:

```markdown
#### Atorones

**Bloque:** 1

**Comando exacto que ejecuté:** wsl --install

**Error completo, copiado y pegado tal cual:**

    Error: 0x80370102 The virtual machine could not be started because
    a required feature is not installed.

**Qué intenté, en orden:**
1. Reinicié la computadora y lo volví a correr: mismo error.
2. Busqué el codigo 0x80370102 y varias respuestas dicen que hay que
   activar la virtualizacion en el BIOS.
3. Entré al BIOS (tecla F2 al arrancar) y busqué la opcion, pero en mi
   modelo no la encontré con ese nombre.

**Dónde me quedé exactamente:** en el paso 1. No llegué a instalar Ubuntu,
así que tampoco pude hacer nada de lo que venía después.
```

Por qué te pido tanto detalle, y no es por burocracia:

- **Copiar el error completo te obliga a leerlo.** La mitad de los errores de este curso dicen en su propio texto qué hay que hacer, y se resuelven solos en cuanto alguien los lee en vez de asustarse.
- **Escribir "qué intenté" te obliga a intentar.** No se puede llenar esa lista sin haber probado algo. Ese es justo el punto.
- **Me deja llegar el miércoles con la solución lista**, en vez de gastar la sesión averiguando qué te pasó.

Un atorón con las cuatro partes vale como bloque entregado. Un "no me salió" a secas, no.

---

### Bloque 1: tu entorno y tu repositorio {#bloque-1}

Antes de cualquier concepto, necesitas la herramienta. Este bloque es puro trabajo de preparación, pero es el que sostiene todo el semestre.

#### Git y GitHub: la memoria de tu proyecto

**Git** es un programa que guarda "fotos" de tu proyecto a lo largo del tiempo. Cada foto se llama **commit**, y lleva fecha, hora, tu nombre y una descripción de lo que cambiaste. Si algo se rompe, vuelves a una foto anterior. **GitHub** es el sitio en la nube donde publicas ese historial para que quede respaldado y yo pueda revisarlo.

En este curso Git no es un adorno: es **la columna vertebral de cómo entregas y cómo te evalúo**. Tu proyecto crece commit a commit, semana a semana. El historial es la prueba de que trabajaste de forma constante y no todo la última noche. Cuando llegue una revisión de avances, haces `push` antes del día acordado y yo reviso tu código con anticipación.

Y aquí entra un archivo que vas a cuidar toda la vida del proyecto: **`BITACORA.md`**. Es un documento, dentro de tu mismo repositorio, donde cada semana explicas **con tus propias palabras** qué concepto viste y cómo lo aplicaste en tu servidor. No es un trámite: vale el 30% de cada revisión, y es donde demuestras que entendiste lo que programaste.

#### Instala lo que vas a necesitar

Todo el curso se trabaja sobre **Linux dentro de Windows**, con una herramienta que se llama **WSL2** (Windows Subsystem for Linux, versión 2). Te permite correr un Ubuntu real dentro de tu Windows, sin reiniciar la máquina ni partir el disco. Para ti es una terminal más que abres en Windows; por debajo hay un kernel de Linux completo.

En el bloque 2 vas a entender por qué insisto tanto en Linux. Por ahora, los cinco pasos:

1. **Activa WSL2.** Abre **PowerShell como administrador** y ejecuta:

   ```powershell
   wsl --install
   ```

   Reinicia si te lo pide. Al abrir Ubuntu por primera vez, crea tu usuario y contraseña de Linux (apúntala, la vas a usar para `sudo`). Verifica que quedó en versión 2:

   ```powershell
   wsl -l -v
   ```

   > A partir de aquí, **todos los comandos van dentro de la terminal de Ubuntu**, no en PowerShell.

2. **Instala Java, Git y la herramienta de GitHub** dentro de Ubuntu:

   ```bash
   sudo apt update
   sudo apt install openjdk-21-jdk git gh -y
   ```

   Comprueba que respondan los tres:

   ```bash
   java -version
   git --version
   gh --version
   ```

3. **Configura tu identidad de Git.** Esto es lo que va a aparecer en cada commit tuyo:

   ```bash
   git config --global user.name "Tu Nombre Completo"
   git config --global user.email "tu.correo@alumnos.udg.mx"
   ```

4. **Crea tu cuenta de GitHub**, si todavía no tienes una. Abre [github.com](https://github.com) en el navegador de Windows y haz clic en **Sign up**. Tres detalles que importan más de lo que parecen:

   - **Usa un correo al que vayas a tener acceso siempre.** Tu correo institucional o uno personal, pero no uno de una escuela anterior ni uno que ya no revisas: ahí llegan las confirmaciones y las recuperaciones de contraseña.
   - **Elige un nombre de usuario presentable**, con tu nombre real o algo cercano (`ana-perez`, `aperez-dev`). Este repositorio va a ser de las primeras cosas que enseñes cuando busques trabajo, y el usuario aparece en la URL. Un apodo de videojuego no ayuda.
   - **Apunta tu contraseña** y activa la verificación en dos pasos si te la ofrece. GitHub la pide para varias operaciones y recuperar una cuenta bloqueada a media semana de revisión es un problema evitable.

   Si ya tienes cuenta, solo comprueba que puedes entrar.

5. **Conecta tu terminal con tu cuenta de GitHub.** GitHub ya no acepta contraseña para `git`, así que la autenticación va por el navegador:

   ```bash
   gh auth login
   gh auth setup-git
   ```

   En `gh auth login` responde `GitHub.com`, protocolo `HTTPS`, `Yes` a autenticar Git con tus credenciales, y `Login with a web browser`. Copia el código de 8 caracteres, presiona Enter y autoriza en el navegador. Después de esto, tus `git push` ya no te piden usuario ni contraseña.

Si algo de esto se atora, los pasos vienen con más detalle y con las fallas típicas en [Configuración del entorno](/curso/so/entorno). Ahí también está el video.

#### Crea tu repositorio

Crea el repositorio en GitHub con el nombre `so-proyecto` y **visibilidad privada**.

Privado, y no público, por una razón concreta: todos los repositorios del grupo se llaman igual, así que uno público lo encuentra cualquiera buscando el nombre en GitHub. Tu proyecto es tuyo y el de tu compañero es suyo.

```bash
cd ~
git clone https://github.com/TU_USUARIO/so-proyecto.git
cd so-proyecto
```

Como está privado, **tienes que darme acceso o no voy a poder revisarte**. En tu repositorio, ve a **Settings -> Collaborators -> Add people**, escribe mi usuario `KarlosEspinoza` y manda la invitación. Sin esa invitación tu trabajo no existe para mí y cuenta como no entregado, así que hazlo hoy y no la semana de la revisión.

Al terminar el semestre puedes cambiarlo a público si quieres: es un proyecto completo y sirve para enseñarlo cuando busques trabajo.

#### Cómo se organiza tu repositorio

Esta estructura es la misma para todo el grupo y para todo el semestre. No la cambies: es la que me permite revisar tu proyecto rápido y sin andar buscando archivos.

```
so-proyecto/
  README.md      <- quien eres y que dominio es tu servidor
  BITACORA.md    <- una seccion por semana
  src/           <- todo el codigo Java: ServidorPedidos.java, Pedido.java, ...
  datos/         <- catalogo.txt, pedidos.log, recibos/
  evidencias/    <- salidas de terminal: procesos.txt, strace.txt, ...
```

Créala de una vez, aunque las carpetas estén vacías:

```bash
mkdir src
mkdir datos
mkdir evidencias
```

Un detalle de `evidencias/` que vale la pena entender desde hoy. En este curso, buena parte de lo que demuestras **no es código: es la salida de un comando**. Cuando en la semana 2 observes tu servidor con `ps`, lo que prueba que lo hiciste es el texto que escupió tu terminal, con **tu** número de proceso. Eso se guarda ahí, así:

```bash
ps -ef > evidencias/procesos.txt
```

Ojo: Git no sube carpetas vacías. Van a quedar registradas hasta que pongas un archivo dentro, cosa que pasa la semana que viene. No te preocupes si al hacer `git status` no las ves.

#### Cómo se escribe la bitácora

`BITACORA.md` lleva **una sección por semana, y cada semana tiene dos partes fijas**: lo que trabajaste en la guía y lo que le agregaste al proyecto. Siempre igual, todas las semanas:

```markdown
# Bitácora del proyecto

## Semana 1 - Encuadre y configuración del entorno

### Antes de la clase

(aquí van los entregables de los bloques de la guía)

### Avance del proyecto

(aquí va lo que le agregaste a tu sistema)
```

#### Cómo nombrar tus commits

El mensaje del commit me dice qué estabas haciendo sin que yo tenga que abrir nada. Usa siempre este formato:

| Cuándo haces commit | Mensaje |
|---|---|
| Al terminar el bloque 1 | `s01 bloque 1: entorno y repositorio listos` |
| Al terminar el bloque 2 | `s01 bloque 2: eleccion de dominio` |
| Si hiciste el bloque extra | `s01 extra: mapa del servidor` |
| Al terminar el avance de tu proyecto | `s01 proyecto: ...` |

El `s01` es el número de semana, y cambia cada semana (`s02`, `s03`, y así). **Haz un commit al terminar cada bloque, no uno solo al final.** Es menos trabajo de lo que parece y deja ver tu avance a lo largo de la sesión.

#### Escribe tu `README.md`

```markdown
# Servidor de Pedidos - Farmacia

Proyecto del curso Fundamentos de Sistemas Operativos.

- Alumno: Ana Pérez
- Código: 2162628
- Dominio: Farmacia

## Descripción

Servidor que recibe pedidos de varios cajeros y gestiona un inventario
compartido de medicamentos. Crece semana a semana con los temas del
curso: procesos, concurrencia, memoria, archivos y red.
```

El dominio lo terminas de decidir en el bloque 2, así que por ahora déjalo en blanco o pon el que traigas en mente.

**Lo que entregas de este bloque**

- El repositorio `so-proyecto` creado en GitHub, **privado** y con la invitación de colaborador ya enviada.
- Las carpetas `src/`, `datos/` y `evidencias/`.
- `README.md` con tu nombre y tu código.
- `BITACORA.md` con la estructura de la semana 1.

```bash
git add .
git commit -m "s01 bloque 1: entorno y repositorio listos"
git push
```

---

### Bloque 2: qué es un sistema operativo y dónde vive tu servidor {#bloque-2}

Ya tienes dónde guardar. Ahora el concepto que le da nombre al curso.

#### Qué es un sistema operativo

Cuando enciendes una computadora, el hardware por sí solo no sabe hacer nada útil. Un procesador es un circuito que suma y compara números muy rápido; la memoria RAM es un enorme casillero donde se guardan datos temporalmente; el disco es una bodega donde las cosas se quedan aunque apagues el equipo. Pero nada de eso, por sí mismo, sabe abrir una aplicación, atender a dos usuarios a la vez o guardar un archivo.

Hace falta un programa que coordine todo ese hardware y lo ponga a disposición de los demás programas de forma ordenada. Ese programa es el **sistema operativo (SO)**.

Una buena forma de imaginarlo es pensar en el SO como el **administrador de un edificio de oficinas** donde trabajan muchos inquilinos (los programas):

- Decide **qué oficina (qué parte de la memoria) ocupa cada inquilino**, y se asegura de que uno no se meta en la oficina de otro.
- Reparte el **tiempo del elevador (el procesador)** entre todos los que lo piden, para que ninguno se quede esperando para siempre.
- Lleva el control de las **bodegas (los archivos en el disco)**: quién guarda qué y dónde.
- Gestiona la **recepción y la mensajería (la entrada/salida y la red)**: lo que entra del teclado, lo que sale a la pantalla, lo que llega por internet.

La idea más importante que tienes que llevarte es esta: **tus programas nunca hablan directamente con el hardware; le piden todo al sistema operativo**. Tu programa no le dice al disco "muévete a tal sector y graba estos bytes"; le dice al SO "guárdame este archivo", y el SO se encarga del resto.

#### Dónde vive tu servidor

Esto es clave para el curso, porque el sistema que vas a construir **no es más que un programa que vive sobre el SO y le pide servicios constantemente**. Lo podemos dibujar en capas:

```
+--------------------------------+
|   Tu Servidor de Pedidos       |   <- programa de usuario (lo escribes tu)
+--------------------------------+
|   Sistema operativo (kernel)   |   <- procesos, memoria, archivos, red
+--------------------------------+
|   Hardware (CPU, RAM, disco)   |
+--------------------------------+
```

Tu servidor está arriba. Cada vez que quiera hacer algo "real" (correr, recordar el catálogo, guardar un pedido, atender a un cajero por la red) tiene que bajar a pedírselo al SO. Y resulta que **cada unidad del curso es uno de esos servicios**:

| Unidad | Lo que tu servidor le pedirá al SO | Cuándo lo construyes |
|---|---|---|
| U1 Perspectivas | "Déjame existir y correr como proceso." | Semanas 1 a 3 |
| U2 Procesos | "Atiende a varios cajeros a la vez sin que se rompa el inventario." | Semanas 4 a 10 |
| U3 Memoria | "Guárdame el catálogo en RAM para responder rápido." | Semanas 11 y 12 |
| U4 Entrada/Salida | "Lee este archivo y escribe este recibo." | Semana 13 |
| U5 Archivos | "Guarda permanentemente todos los pedidos." | Semana 15 |
| U6 Red | "Recibe a un cajero que se conecta desde otra máquina." | Semana 16 |

Ese es el curso completo, en una tabla. No hay temas sueltos: hay seis cosas que tu servidor necesita y seis unidades que se las dan.

#### El kernel y los dos modos de ejecución

El corazón del sistema operativo se llama **kernel**. Es la parte que tiene **control total sobre el hardware**: puede tocar cualquier zona de memoria, mandar órdenes al disco, configurar la red. Como es una pieza tan poderosa, hay que protegerla para que un programa cualquiera no haga un desastre. Por eso el procesador funciona en **dos modos**:

- **Modo usuario:** es donde corren tus programas normales (tu servidor, el navegador, VS Code). En este modo el procesador tiene los permisos limitados a propósito. Si tu programa intenta tocar directamente el hardware o la memoria de otro programa, el SO lo frena en seco.
- **Modo kernel:** es donde corre el kernel. En este modo se puede hacer todo.

Para qué tanta separación: para que **un programa con un error, o uno malicioso, no pueda tumbar toda la máquina ni espiar a los demás**. Piénsalo en términos de tu proyecto: si tu Servidor de Pedidos tiene un bug y truena, lo que se cae es tu servidor, no Windows ni Linux completos. Esa estabilidad no la programaste tú: te la regala el SO gracias a esta separación de modos.

#### Las llamadas al sistema

Si tu programa corre en modo usuario y no puede tocar el hardware, surge una pregunta lógica: entonces cómo hace para leer un archivo o abrir una conexión de red. La respuesta es la **llamada al sistema** (en inglés *system call* o *syscall*): una petición formal que tu programa le hace al kernel para que haga algo por él.

Funciona como cuando llegas a una ventanilla de gobierno: tú no entras a las oficinas internas a buscar tu documento; llenas una solicitud, la entregas en la ventanilla, y un empleado autorizado entra, hace el trámite y te devuelve el resultado. La ventanilla es la frontera entre tú (modo usuario) y las oficinas (modo kernel). La llamada al sistema es esa solicitud.

Cuando más adelante escribas en Java algo así para cargar tu catálogo:

```java
List<String> lineas = Files.readAllLines(Path.of("datos/catalogo.txt"));
```

por debajo esa instrucción se traduce en varias llamadas al sistema: una para **abrir** el archivo (`openat`), otras para **leer** su contenido (`read`) y una para **cerrarlo** (`close`). Java te lo presenta bonito en una sola línea, pero quien realmente toca el disco es el kernel. En la semana 13 vamos a **verlas ocurrir en vivo** con una herramienta llamada `strace`, y ese día esta idea deja de ser teoría.

#### Por qué tu software vivirá en Linux

Tu laptop probablemente tiene Windows, y está bien. Pero el **destino de casi todo el software que vas a escribir como profesional es Linux**:

- Los **servidores** detrás de las páginas web, las apps, las bases de datos y los puntos de venta corren casi siempre sobre Linux.
- Empresas locales como **SICAR** y prácticamente todo el trabajo de **DevOps y administración de servidores** se hace sobre Linux.
- Los **contenedores** (Docker) y la nube son, por dentro, Linux.

En otras palabras: el Servidor de Pedidos que vas a construir es exactamente el tipo de programa que en la vida real correría en un servidor Linux, no en una PC con Windows. Cuando abres esa terminal de Ubuntu que instalaste en el bloque 1, **ya estás trabajando dentro de un servidor Linux igual al que usarías en producción**. No es un simulador de juguete.

#### Elige tu dominio

El dominio es el tipo de negocio cuyo servidor construyes. Todos comparten la misma estructura (pedidos que llegan, inventario compartido), y lo que cambia es qué se pide y qué se agota.

**Nadie más del grupo puede tener el mismo dominio**, porque cada dominio va a ser una sucursal distinta cuando armemos los equipos del proyecto integrador.

| Dominio | Ejemplo de pedido | Ejemplo de inventario |
|---|---|---|
| Restaurante | Orden de platillos en mesa | Existencia de ingredientes |
| Farmacia | Solicitud de medicamentos | Stock de medicamentos |
| Librería | Pedido de libros | Ejemplares disponibles |
| Taller de servicio | Orden de reparación | Disponibilidad de técnicos |
| Renta de equipo | Reserva de herramientas | Unidades disponibles |
| Estacionamiento | Solicitud de lugar | Cajones libres |
| Veterinaria | Cita o servicio | Consultorios disponibles |

Si se te ocurre uno que no está en la lista, adelante: solo necesita cumplir dos cosas, que haya **algo que se pida** y **algo que se acabe**. Sin recurso limitado no hay condición de carrera, y sin condición de carrera te quedas sin la mitad de la Unidad 2.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`, responde con tus palabras:

1. **Cuál es tu dominio**, qué se pide en él y qué se agota.
2. **Por qué tu servidor no puede tocar el disco directamente.** Explica la ventanilla con tus palabras, no con las de la guía.
3. **Un ejemplo tuyo de cada capa.** Completa esta tabla con **tu** dominio, no con farmacia:

   | Capa | En mi sistema esto es... |
   |---|---|
   | Programa de usuario | |
   | Servicio que le pido al SO | |
   | Hardware que termina moviéndose | |

Actualiza también el dominio en tu `README.md`.

```bash
git add .
git commit -m "s01 bloque 2: eleccion de dominio"
git push
```

---

### Bloque extra: el mapa de tu servidor {#bloque-extra}

Opcional. Si ya terminaste los dos bloques anteriores, este te va a dar la foto completa del semestre y te va a servir de índice para tu bitácora.

Vuelve a la tabla de las seis unidades y **tradúcela a tu dominio**. Para cada unidad, escribe qué va a hacer **tu** servidor en concreto:

| Unidad | Qué hará mi servidor | Qué se rompe si el SO no me lo da |
|---|---|---|
| U1 Perspectivas | | |
| U2 Procesos | | |
| U3 Memoria | | |
| U4 Entrada/Salida | | |
| U5 Archivos | | |
| U6 Red | | |

La segunda columna es la fácil. **La tercera es la que vale**: obliga a pensar qué pasaría si ese servicio no existiera. Por ejemplo, en U2: si el SO no me diera forma de coordinar dos cajeros, el inventario quedaría en un número equivocado y vendería medicamento que ya no tengo.

Guárdala en tu `BITACORA.md`. En la semana 17 vas a volver a leerla, y la gracia es ver cuánto de lo que escribiste hoy resultó cierto.

```bash
git add .
git commit -m "s01 extra: mapa del servidor"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu entorno instalado, tu repositorio creado y tu dominio elegido. **Trae tu laptop**: la mayor parte de la sesión es de encuadre y trabajo en el pizarrón, pero si algo del bloque 1 se te atoró, la abrimos y lo resolvemos ahí mismo.

**1. Rescate de instalaciones.** Lo primero. Quien traiga un atorón documentado, lo vemos. Es más rápido de lo que parece porque casi siempre son los mismos tres o cuatro problemas, y viéndolo una vez se le resuelve a todo el que lo tenga.

**2. El mapa de sucursales.** Cada quien dice su nombre y el dominio que eligió. Lo anotamos en el pizarrón. La regla es que **no se pueden repetir dominios**: si dos coinciden, ahí mismo se resuelve. Al final el pizarrón ya es el mapa de sucursales del grupo, y de ahí salen los equipos del proyecto integrador.

**3. El SO invisible.** En equipos de 3, van a reconstruir todo lo que ocurre "por debajo" desde que un cajero teclea un pedido hasta que se imprime el recibo.

Para que no arranquen de una hoja en blanco, la historia se parte en estos seis momentos. Cada equipo toma la tabla y llena las dos columnas de la derecha:

| Momento | Qué pasa a la vista | Qué tuvo que hacer alguien por debajo | Quién crees que lo hizo |
|---|---|---|---|
| 1 | El cajero abre el programa de la caja | | |
| 2 | Teclea el producto y la cantidad | | |
| 3 | El sistema revisa si hay existencia | | |
| 4 | Otra caja pide el mismo producto en ese instante | | |
| 5 | Se descuenta del inventario | | |
| 6 | Se imprime el recibo | | |

Tres reglas para llenarla:

- En la columna 3 la respuesta nunca es "el programa". Pregúntense **quién le dio** al programa lo que necesitaba: quién trajo el archivo del disco, quién le prestó el procesador, quién le dio memoria.
- En la columna 4, si no saben el nombre técnico, descríbanlo. "Alguien tuvo que decidir cuál de las dos cajas iba primero" es una respuesta perfecta.
- El renglón 4 es el importante y probablemente el que los deje discutiendo. Déjenlo así: es el tema de la Unidad 2 y no se resuelve hoy.

Al final juntamos las tablas de todos los equipos en el pizarrón y les ponemos encima las seis unidades del curso. Van a ver que **cada renglón cae en alguna unidad** y que no sobra ninguna. Ese pizarrón es el temario del curso, escrito por ustedes antes de que yo se los dictara.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

El repositorio ya lo creaste en el bloque 1. Lo que queda es cerrarlo y dejarlo entregado.

1. **Entrega la URL de tu repositorio en Google Classroom.** Esto se hace **una sola vez en todo el semestre**: de ahí en adelante yo reviso directo en GitHub y tú solo haces `push`.

2. **Verifica que me llegó la invitación de colaborador.** En tu repositorio, Settings -> Collaborators, mi usuario `KarlosEspinoza` tiene que aparecer en la lista (aunque diga "pending"). Si no está, tu trabajo es invisible para mí.

3. **Cierra tu entrada de la semana en `BITACORA.md`**, bajo `### Avance del proyecto`:

   ```markdown
   ### Avance del proyecto

   Instalé WSL2 con Ubuntu, Java 21 y Git, y creé este repositorio. Elegí el
   dominio de farmacia porque me interesa cómo se controla el stock cuando
   varios cajeros atienden al mismo tiempo.

   En la dinámica del SO invisible nos dimos cuenta de que casi todo lo que
   creíamos que hacía el programa lo hace en realidad el sistema operativo:
   nosotros solo se lo pedimos.
   ```

4. **Sube tu avance:**

   ```bash
   git add .
   git commit -m "s01 proyecto: repositorio entregado y dominio registrado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Forma tu equipo** de 2 o 3 integrantes.
2. **Verifiquen que cada integrante tenga un dominio diferente**, porque cada dominio será una sucursal del sistema multi-sucursal que construirán juntos. Por ejemplo: uno farmacia, otro restaurante, otro librería.
3. **Registren el equipo** subiendo a Classroom un archivo `equipo.csv` con una línea por integrante. Lo sube cada uno de los integrantes, el mismo archivo:

   ```
   codigo,dominio
   2162628,farmacia
   2162631,restaurante
   2162640,libreria
   ```

   El dominio va en una sola palabra, en minúsculas y sin acentos, porque ese archivo lo proceso con un script.

Todavía no hay código del integrador: por ahora basta con que el equipo quede formado y los dominios reservados, porque a partir de la Unidad 2 cada sucursal empezará a conectarse a un Servidor Central que desarrollarán en conjunto.
