---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 1 - Encuadre y configuración del entorno

Esta primera semana tiene dos metas. La primera es que entiendas, con calma y desde cero, **qué es un sistema operativo y por qué es el punto de partida de todo el software que vas a escribir**. La segunda es que dejes **listo tu entorno de trabajo** y creado el repositorio donde vivirá tu proyecto durante todo el semestre.

Todo el curso gira alrededor de un solo sistema que vas a construir tú mismo: un **Servidor de Pedidos**. Imagina el sistema que usa una tienda para vender: hay varias cajas (cajeros) atendiendo clientes al mismo tiempo, y todas comparten un mismo inventario. Ese tipo de sistema, el que opera por ejemplo una empresa como SICAR, es justo el que iremos levantando capa por capa. Y cada concepto de sistemas operativos va a aparecer de forma natural cuando tu servidor lo necesite.

---

## Antes de la clase (aprendizaje invertido)

Lee esta sección con calma antes de la sesión. Está escrita para que la entiendas por tu cuenta, sin necesidad de que yo te la explique en vivo. En clase la usaremos como punto de partida para discutir y para empezar a darle forma a tu proyecto.

### Qué es un sistema operativo

Cuando enciendes una computadora, el hardware por sí solo no sabe hacer nada útil. Un procesador es un circuito que suma y compara números muy rápido; la memoria RAM es un enorme casillero donde se guardan datos temporalmente; el disco es una bodega donde las cosas se quedan aunque apagues el equipo. Pero nada de eso, por sí mismo, sabe abrir una aplicación, atender a dos usuarios a la vez o guardar un archivo. Hace falta un programa que coordine todo ese hardware y lo ponga a disposición de los demás programas de forma ordenada. Ese programa es el **sistema operativo (SO)**.

Una buena forma de imaginarlo es pensar en el SO como el **administrador de un edificio de oficinas** donde trabajan muchos inquilinos (los programas):

- Decide **qué oficina (qué parte de la memoria) ocupa cada inquilino**, y se asegura de que uno no se meta en la oficina de otro.
- Reparte el **tiempo del elevador (el procesador)** entre todos los que lo piden, para que ninguno se quede esperando para siempre.
- Lleva el control de las **bodegas (los archivos en el disco)**: quién guarda qué y dónde.
- Gestiona la **recepción y la mensajería (la entrada/salida y la red)**: lo que entra del teclado, lo que sale a la pantalla, lo que llega por internet.

La idea más importante que tienes que llevarte es esta: **tus programas nunca hablan directamente con el hardware; le piden todo al sistema operativo**. Tu programa no le dice al disco "muévete a tal sector y graba estos bytes"; le dice al SO "guárdame este archivo", y el SO se encarga del resto.

Esto es clave para nuestro curso, porque el sistema que vas a construir, el Servidor de Pedidos, **no es más que un programa que vive sobre el SO y le pide servicios constantemente**. Lo podemos dibujar en capas:

```
+--------------------------------+
|   Tu Servidor de Pedidos       |   <- programa de usuario (lo escribes tú)
+--------------------------------+
|   Sistema operativo (kernel)   |   <- procesos, memoria, archivos, red
+--------------------------------+
|   Hardware (CPU, RAM, disco)   |
+--------------------------------+
```

Tu servidor está arriba. Cada vez que quiera hacer algo "real" (correr, recordar el catálogo, guardar un pedido, atender a un cajero por la red) tendrá que bajar a pedírselo al SO. Y resulta que **cada unidad del curso es uno de esos servicios**. Mira cómo encaja:

| Unidad | Lo que tu servidor le pedirá al SO | Cuándo lo construyes |
|---|---|---|
| U1 Perspectivas | "Déjame existir y correr como proceso." | Semanas 1 a 3 |
| U2 Procesos | "Atiende a varios cajeros a la vez sin que se rompa el inventario." | Semanas 4 a 10 |
| U3 Memoria | "Guárdame el catálogo en RAM para responder rápido." | Semanas 11 y 12 |
| U4 Entrada/Salida | "Lee este archivo y escribe este recibo." | Semana 13 |
| U5 Archivos | "Guarda permanentemente todos los pedidos." | Semana 15 |
| U6 Red | "Recibe a un cajero que se conecta desde otra máquina." | Semana 16 |

Cuando trabajes el **proyecto integrador** con tu equipo, esta idea se multiplica: tendrás **varios servidores corriendo a la vez** (uno por cada sucursal) más un Servidor Central que los coordina. Todos compitiendo por el mismo procesador y la misma memoria de la máquina. Ahí el papel del SO como "administrador del edificio" se vuelve todavía más evidente, porque hay muchos más inquilinos pidiendo recursos al mismo tiempo.

### El kernel y los dos modos de ejecución

El corazón del sistema operativo se llama **kernel**. Es la parte que tiene **control total sobre el hardware**: puede tocar cualquier zona de memoria, mandar órdenes al disco, configurar la red. Como es una pieza tan poderosa, hay que protegerla para que un programa cualquiera no haga un desastre. Por eso el procesador funciona en **dos modos**:

- **Modo usuario:** es donde corren tus programas normales (tu servidor, el navegador, VS Code). En este modo el procesador tiene los permisos limitados a propósito. Si tu programa intenta tocar directamente el hardware o la memoria de otro programa, el SO lo frena en seco.
- **Modo kernel:** es donde corre el kernel. En este modo se puede hacer todo.

¿Por qué tanta separación? Para que **un programa con un error, o uno malicioso, no pueda tumbar toda la máquina ni espiar a los demás**. Piénsalo en términos de tu proyecto: si tu Servidor de Pedidos tiene un bug y truena, lo que se cae es tu servidor, no Windows ni Linux completos. Esa estabilidad no la programaste tú: te la regala el SO gracias a esta separación de modos.

En el proyecto integrador esto importa todavía más. Cada sucursal corre como un proceso independiente y aislado. Si la sucursal "farmacia" se cae por un error, las sucursales "restaurante" y "librería" siguen funcionando, porque el SO mantiene a cada proceso en su propia burbuja de memoria. Ese aislamiento entre procesos es una de las cosas que estaremos comprobando en clase.

### Las llamadas al sistema (system calls)

Si tu programa corre en modo usuario y no puede tocar el hardware, surge una pregunta lógica: ¿entonces cómo hace para leer un archivo o abrir una conexión de red? La respuesta es la **llamada al sistema** (en inglés *system call* o *syscall*): una petición formal que tu programa le hace al kernel para que haga algo por él.

Funciona como cuando llegas a una ventanilla de gobierno: tú no entras a las oficinas internas a buscar tu documento; llenas una solicitud, la entregas en la ventanilla, y un empleado autorizado entra, hace el trámite y te devuelve el resultado. La ventanilla es la frontera entre tú (modo usuario) y las oficinas (modo kernel). La llamada al sistema es esa solicitud.

Cuando más adelante escribas en Java algo como esto para cargar tu catálogo:

```java
List<String> lineas = Files.readAllLines(Path.of("catalogo.txt"));
```

por debajo, esa instrucción se traduce en varias llamadas al sistema: una para **abrir** el archivo (`open`), otras para **leer** su contenido (`read`) y una para **cerrarlo** (`close`). Java te lo presenta bonito en una sola línea, pero quien realmente toca el disco es el kernel, a través de esas syscalls. Lo mismo pasará cuando tu servidor escriba un recibo o cuando acepte la conexión de un cajero por la red: siempre hay una llamada al sistema de por medio.

Por ahora quédate con la idea: **la llamada al sistema es la puerta por la que tu servidor le pide servicios al SO**. En la Unidad 4 las veremos a detalle, pero te las menciono desde hoy porque van a estar presentes en cada cosa "real" que haga tu proyecto.

### Por qué tu software vivirá en Linux

Tu laptop probablemente tiene Windows, y está bien. Pero el **destino de casi todo el software que vas a escribir como profesional es Linux**. Vale la pena que entiendas por qué, porque define cómo trabajaremos:

- Los **servidores** que están detrás de las páginas web, las apps, las bases de datos y los puntos de venta corren casi siempre sobre Linux.
- Empresas locales como **SICAR** (puntos de venta) y prácticamente todo el trabajo de **DevOps y administración de servidores** se hace sobre Linux.
- Los **contenedores** (Docker) y la nube son, por dentro, Linux.

En otras palabras: el Servidor de Pedidos que vas a construir es exactamente el tipo de programa que en la vida real correría en un servidor Linux, no en una PC con Windows. Por eso desarrollaremos sobre Linux desde el primer día. Y para no tener que borrar tu Windows ni instalar una máquina virtual pesada, usamos una herramienta que mete Linux dentro de Windows: **WSL2**.

### WSL2: Linux dentro de Windows

**WSL2** (Windows Subsystem for Linux, versión 2) te permite correr un Linux real (usaremos Ubuntu) **dentro de tu Windows**, sin reiniciar la máquina ni partir el disco. Para ti, en el día a día, es simplemente una terminal más que abres en Windows; pero por debajo hay un kernel de Linux completo y funcional.

Ahí, dentro de esa terminal, instalaremos Java, Git y todo lo del curso. La ventaja es enorme: cuando abras esa terminal de Ubuntu, **ya estás trabajando "dentro" de un servidor Linux igual al que usarías en producción**. Lo que construyas ahí es directamente transportable a un servidor real. No estás practicando en un simulador de juguete: estás en Linux de verdad.

### Git y GitHub: la memoria de tu proyecto

Falta una pieza más del entorno, y es tan importante como Linux: el control de versiones.

**Git** es un programa que guarda "fotos" de tu proyecto a lo largo del tiempo. Cada foto se llama **commit**, y lleva una fecha, tu nombre y una descripción de lo que cambiaste. Si algo se rompe, puedes volver a una foto anterior. **GitHub** es el sitio en la nube donde publicas ese historial para que quede respaldado y otros (en tu caso, yo y tu equipo) puedan verlo.

En este curso Git y GitHub no son un adorno: son **la columna vertebral de cómo entregas y cómo te evalúo**. Tu proyecto va a crecer commit a commit, semana a semana. El historial de commits es la prueba de que fuiste trabajando de forma constante y no todo a última hora. Cuando llegue una revisión de avances, lo que harás es un `push` a GitHub antes del día acordado, y yo reviso tu código y tu bitácora con anticipación.

Y aquí entra un archivo que vas a cuidar toda la vida del proyecto: **`BITACORA.md`**. Es un documento, dentro de tu mismo repositorio, donde cada semana explicas **con tus propias palabras** qué concepto viste y cómo lo aplicaste en tu servidor. No es un trámite: es donde demuestras que entendiste, y es una parte importante de cada revisión. La gran ventaja de tenerlo versionado en Git es que se nota cómo fuiste razonando a lo largo del semestre.

En el proyecto integrador, Git además les sirve para **trabajar en equipo sobre el mismo código** sin pisarse: cada integrante aporta su parte (su sucursal) y todo se integra en un repositorio común del equipo.

---

## Durante la clase (aprendizaje activo)

La primera sesión es de encuadre y la hacemos **sin laptop**, para conocernos y construir entre todos el mapa del sistema que vamos a desarrollar. Dos dinámicas:

**1. Nombre de tu sistema.** Cada quien dice un apodo y el dominio de negocio que está pensando para su servidor: restaurante "El Fogón", farmacia "SaludYa", librería "Página 7", lo que quieras. Lo anotamos en el pizarrón. La regla es que **no se pueden repetir dominios**, porque cada dominio será una sucursal distinta cuando armemos los equipos del proyecto integrador. Al final de la dinámica, el pizarrón ya es el mapa de sucursales del grupo.

**2. El SO invisible.** En equipos pequeños, durante unos minutos, hagan una lista de todo lo que ocurre "por debajo" desde que un cajero teclea un pedido hasta que se imprime el recibo. ¿Quién decide cuál caja usa el procesador en ese instante? ¿Dónde está guardado el inventario mientras tanto? ¿Qué pasaría si dos cajas piden el último producto exactamente al mismo tiempo? No hay que resolverlo todavía: la meta es solo **descubrir en qué momentos aparece el sistema operativo**. Vas a ver que aparece en todos. Cada uno de esos momentos es, de hecho, un tema que veremos a lo largo del curso.

---

## Tu proyecto esta semana

Esta semana siembras el proyecto. Lo que crees ahora es el terreno sobre el que vas a construir las siguientes 16 semanas.

### Prepara tu entorno

Deja instalado y funcionando lo siguiente (lo haces en tu computadora, con calma, fuera de clase):

1. **Activa WSL2.** En PowerShell como administrador:

   ```powershell
   wsl --install
   ```

   Reinicia si te lo pide. Al abrir Ubuntu por primera vez, crea tu usuario y contraseña de Linux. Verifica que quedó en versión 2:

   ```powershell
   wsl -l -v
   ```

2. **Instala Git y Java** dentro de la terminal de Ubuntu, y configura tu identidad de Git:

   ```bash
   sudo apt update
   sudo apt install git openjdk-21-jdk -y
   git config --global user.name "Tu Nombre"
   git config --global user.email "tucorreo@ejemplo.com"
   ```

   Comprueba que respondan: `git --version` y `java -version`.

3. **Instala Visual Studio Code** en Windows y su extensión **WSL**, que te deja abrir carpetas de Linux directamente. Desde una carpeta en la terminal de Ubuntu puedes abrirlo con `code .`.

### Prácticas

1. **Elige tu dominio** de esta lista (recuerda: nadie más del grupo puede tener el mismo) y regístralo conmigo:

   | Dominio | Ejemplo de pedido | Ejemplo de inventario |
   |---|---|---|
   | Restaurante | Orden de platillos | Ingredientes |
   | Farmacia | Solicitud de medicamentos | Stock de medicamentos |
   | Librería | Pedido de libros | Ejemplares |
   | Taller de servicio | Orden de reparación | Técnicos disponibles |
   | Renta de equipo | Reserva de herramienta | Unidades disponibles |
   | Estacionamiento | Solicitud de lugar | Cajones libres |
   | Veterinaria | Cita o servicio | Consultorios |

2. **Crea tu repositorio** en GitHub (por ejemplo `servidor-pedidos-so`, público) y clónalo dentro de tu Ubuntu:

   ```bash
   git clone https://github.com/TU_USUARIO/servidor-pedidos-so.git
   cd servidor-pedidos-so
   ```

3. **Escribe tu `README.md`** con tus datos y tu dominio:

   ```markdown
   # Servidor de Pedidos - Farmacia

   Proyecto del curso Fundamentos de Sistemas Operativos.

   - Alumno: Ana Pérez
   - Código: 2162628
   - Dominio: Farmacia

   ## Descripción

   Servidor que recibe pedidos de varios cajeros y gestiona un inventario
   compartido de medicamentos. Crecerá semana a semana con los temas del
   curso: procesos, concurrencia, memoria, archivos y red.
   ```

4. **Escribe la primera entrada de tu `BITACORA.md`**, explicando con tus palabras lo que entendiste esta semana:

   ```markdown
   # Bitácora del proyecto

   ## Semana 1 - Configuración del entorno

   Configuré WSL2 para tener Linux dentro de Windows, instalé Git y Java, y
   creé mi repositorio. Elegí el dominio de farmacia porque me interesa cómo
   se controla el stock cuando varios cajeros atienden al mismo tiempo.

   Entendí que el sistema operativo administra el hardware y se lo ofrece a
   mis programas, y que mi servidor no tocará el hardware directamente: todo
   se lo pedirá al SO mediante llamadas al sistema.
   ```

5. **Guarda y sube tu avance**, y entrega la URL del repositorio en Google Classroom (esto se hace una sola vez en todo el semestre):

   ```bash
   git add .
   git commit -m "inicio: configuracion del entorno y eleccion de dominio"
   git push
   ```

### Proyecto integrador

1. **Forma tu equipo** de 2 o 3 integrantes.
2. **Verifiquen que cada integrante tenga un dominio diferente**, porque cada dominio será una sucursal del sistema multi-sucursal que construirán juntos. Por ejemplo: uno farmacia, otro restaurante, otro librería.
3. **Registren el equipo y los dominios** conmigo durante esta semana.

Todavía no hay código del integrador: por ahora basta con que el equipo quede formado y los dominios reservados, porque a partir de la Unidad 2 cada sucursal empezará a conectarse a un Servidor Central que desarrollarán en conjunto.
