# CLAUDE.md — Curso IN235: Fundamentos de Sistemas Operativos

Materiales del curso de Fundamentos de Sistemas Operativos para Ingeniería en Teleinformática,
5to semestre, CUCSur UdeG.

**Instructor:** Karlos Espinoza (karlos.espinoza@academicos.udg.mx)
**Horario:** Lunes y Miércoles 15:00-16:59 hrs
**Tiempo efectivo por sesión:** ~1.5 h (el resto se va en pase de lista, espera y ajustes)
**Horas efectivas estimadas del semestre:** ~43-45 h (vs. 80 h del programa oficial)
**Grupo:** máximo ~15 alumnos, Ingeniería en Teleinformática
**Conocimientos previos del alumno:** Java (POO + estructuras de datos), Redes I-III

---

## REGLA DE MODIFICACIONES DURANTE EL CURSO

El curso arranca el **lunes 17 de agosto de 2026**. A partir de ese momento **los alumnos ya
están trabajando sobre este material y su calificación depende de él**, así que cualquier cambio
puede afectarlos y dar pie a una queja legítima.

### Protocolo

**Karlos indica en qué semana va el curso** al pedir una modificación. Si no lo dice, **hay que
preguntárselo antes de tocar cualquier archivo de `semana-NN/` o de `evaluacion/`**. Sin ese dato
no se puede saber si un cambio es seguro.

Con la semana en curso `N`, el material se clasifica en tres:

| Objetivo del cambio | Se puede | Cómo |
|---|---|---|
| **Semana > N** (futura) | Libre | Material que nadie ha visto. Se edita sin restricción. |
| **Semana = N** (en curso) | Con cuidado | Solo si no agrega ni endurece lo que se pide. |
| **Semana < N** (pasada) | Muy restringido | Solo correcciones que no cambien lo evaluado. |

### Qué se puede cambiar siempre, en cualquier semana

- Erratas, redacción, claridad, ejemplos adicionales.
- Enlaces rotos, anclas, formato.
- Bugs en el código de ejemplo, **siempre que no cambie lo que se le pide al alumno**.
- **Quitar o relajar** un requisito (nadie sale perjudicado).
- Cualquier cosa dentro del repositorio privado `so-profesor` (el alumno no lo ve).

### Qué NO se puede hacer en la semana en curso ni en semanas pasadas

- **Agregar un entregable o un requisito.** El alumno que ya la trabajó bien tiene que seguir
  estando bien. Si hace falta algo nuevo, va en la semana siguiente con la redacción "a partir de
  esta semana...", nunca retroactivo.
- **Renombrar archivos del proyecto** (`ServidorPedidos.java`, `GestorInventario.java`,
  `catalogo.txt`, etc.). Los alumnos ya hicieron commit con esos nombres y la progresión de
  semanas los encadena. Los nombres quedan **congelados** en cuanto pasa la semana que los
  introduce.
- **Cambiar la convención de commits o la estructura de `BITACORA.md`.** Es el formato del
  historial ya escrito.
- **Tocar las listas "Tu servidor debe" de las semanas 9, 14 y 17**, ni los pesos de evaluación,
  una vez iniciada la unidad que evalúan. Son el instrumento de calificación.

### Cómo se hace un cambio necesario pero riesgoso

1. **Moverlo a la semana siguiente** en vez de editar la pasada. Es lo primero que hay que intentar.
2. Si de verdad tiene que ir en la semana ya publicada, **agregar, no reemplazar**: una nota
   fechada y visible ("**Corrección del <fecha>:** ...") para que el alumno vea que cambió y no
   crea que leyó mal.
3. **Avisarle a Karlos explícitamente** que el cambio toca material ya visto, para que él lo
   comunique en Classroom.

### La red de seguridad

El sitio está en git. Si un alumno reclama que "eso no decía eso", `git log` sobre el archivo
muestra exactamente qué decía la página en la fecha en que él la trabajó. Por eso **cada cambio va
en su propio commit con un mensaje claro**, y por eso nunca se reescribe la historia del
repositorio.

---

## Modalidad: qué se escribe y qué no (IMPORTANTE)

**En ningún material se describe la modalidad de las sesiones.** La modalidad publicada es
**Presencial**, aula **C5**, para las dos sesiones de la semana. Al escribir, siempre "durante la
sesión", nunca una caracterización de cómo ocurre.

Nomenclatura interna para poder hablar de las dos sesiones sin nombrar modalidad:

| Sesión | Nombre interno | Qué se presenta al alumno |
|---|---|---|
| Lunes | **sesión de guía** | "Actividades realizadas antes de la clase (aprendizaje invertido)" |
| Miércoles | **sesión de aula** | "Actividades de aprendizaje activo a realizar durante la clase" |

### La restricción de diseño que sí hay que respetar

Lo importante para generar materiales no es la modalidad, es esto:

- **En la sesión de guía el alumno trabaja por su cuenta**, con el asesor disponible para
  resolver dudas. No se puede asumir trabajo en equipo cara a cara, ni material del aula, ni
  que alguien mire su pantalla. Todo bloque del lunes tiene que poder resolverse solo, con la
  guía escrita y una laptop.
- **En la sesión de aula se trabaja en conjunto**: comparar resultados entre compañeros,
  discutir, romper cosas y depurarlas juntos.

De ahí sale la regla operativa del curso: **el lunes se lee, se decide y se escribe código; el
miércoles se ejecuta, se rompe y se depura en conjunto.**

El programa debe cumplir la rúbrica de syllabus innovador (`recurso/lineamiento-syllabus.md`):
aprendizaje invertido, aprendizaje activo, evaluación y retroalimentación formativas, y criterios
de evaluación sumativa con rúbricas. Objetivo: la mayoría de categorías en nivel 3 o 4, ninguna
en 1 o 2.

### Qué es público y qué no

**El repositorio del sitio es público** (`github.com/KarlosEspinoza/karlosespinoza.github.io`).
El `exclude:` de `_config.yml` impide que Jekyll publique un archivo en el sitio, pero **no
impide que se lea en GitHub**. Consecuencia práctica:

- Este archivo, `recurso/` y `classroom.md` **no se sirven en el sitio**, pero **sí son legibles
  en GitHub**. Por eso están redactados de forma que su filtración no cause problema.
- Lo que de verdad no debe salir del control del asesor va en el repositorio **privado**
  `KarlosEspinoza/so-profesor`, nunca aquí.

---

## Material de profesor (repositorio privado)

Los ejercicios resueltos, los procedimientos completos y las salidas esperadas de cada semana
viven en el repositorio privado **`KarlosEspinoza/so-profesor`**, clonado en `~/gh/so-profesor/`
como `semana-01.md` ... `semana-17.md`.

En el repositorio del sitio, `curso/so/semana-NN/profesor.md` es un **enlace simbólico** a ese
archivo, y `**/profesor.md` está en `.gitignore`. Resultado:

- Con `make local`, Karlos lo consulta en `http://127.0.0.1:4000/curso/so/semana-NN/profesor.html`
  con el estilo del curso.
- Desde el celular o en otra máquina: `github.com/KarlosEspinoza/so-profesor/blob/main/semana-NN.md`.
- **Nunca entra al repositorio público ni lo construye GitHub Pages.**

Al generar o editar una semana, **el `index.md` y el `profesor.md` se escriben juntos**: el
segundo trae las respuestas del primero. Las semanas 09, 14 y 17 son revisiones y no llevan
material de profesor.

Secciones fijas de cada `semana-NN.md` del repo privado:

| Sección | Qué trae |
|---|---|
| Antes de la sesión | Qué hay que tener listo y cuánto tarda de verdad cada bloque |
| Bloque 1 resuelto | Respuestas esperadas y variantes aceptables por dominio |
| Bloque 2 resuelto | El código completo con los `TODO` resueltos y la salida esperada |
| Bloque extra resuelto | Lo mismo, para los dos o tres que lleguen ahí |
| Durante la sesión de aula | Guion de la actividad, con tiempos |
| Dónde se atoran | Los errores concretos que salen cada semestre y cómo se destraban |
| Preguntas de revisión | Banco de preguntas del tema, para los instrumentos de revisión |

---

## Evaluación

| Rubro | Peso |
|---|---|
| Proyecto integrador (equipo) | 50% |
| Prácticas (el proyecto individual, renombrado por la academia) | 35% |
| Actividades integradoras (las coordina la carrera; informa el % por alumno) | 5% |
| Asistencia | 10% |

**Instrumentos de revisión de avances (prácticas):**

| Instrumento | Peso dentro del proyecto |
|---|---|
| Evidencias (código en GitHub, commits, demo) | 50% |
| BITACORA.md con explicación de conceptos | 30% |
| 2 preguntas (orales o escritas) | 20% |

En el **proyecto integrador** se agrega un cuarto instrumento (autoevaluación entre pares) y los
pesos quedan: Evidencias 45%, BITACORA.md 25%, Preguntas 20%, **Autoevaluación entre pares 10%**.

**Flujo de entrega y revisión:** el alumno hace `push` a GitHub de sus evidencias y BITACORA.md
**antes del dia de la revision** (a mas tardar la sesion previa de esa semana). El asesor revisa
codigo + bitacora con anticipacion. El dia de la revision la sesion se dedica solo a las
preguntas (orales, o escritas en papel o archivo de texto). Si no hubo push a tiempo, la
revision cuenta como no entregada.

**Sesiones de revisión de avances:**

- Revisión 1: **miércoles de la semana 9** - cierre Unidades 1 y 2
- Revisión 2: **miércoles de la semana 14** - cierre Unidades 3 y 4
- Revisión 3: **miércoles de la semana 17** - cierre y entrega final

**Las fechas no se escriben en ningún material.** Se expresan siempre como semana, y lo único
atado al calendario es el campo de fecha de entrega de Google Classroom. Así el curso se reusa
cada ciclo sin volver a tocar los textos.

### Asistencia y calendario oficial

Reglamento General de Evaluación y Promoción de Alumnos de la UdeG (2017):

| Periodo | Asistencia mínima | Artículo |
|---|---|---|
| Ordinario | 80% | 20, fracc. II |
| Extraordinario | 65% | 27, fracc. III |

Justificación de faltas (arts. 53 a 55): se tramita ante la **Coordinación de Carrera, no con el
profesor**, dentro de los cinco días hábiles siguientes al regreso a clases. Tope justificable:
20% del total de horas de la materia (35% excepcional por la Coordinación). Si una falta
justificada cae el día de una revisión de avances, profesor y alumno acuerdan otra fecha (art. 55).

**Calendario oficial: <https://escolar.udg.mx/calendarios>.** De ahí salen las fechas de inicio y
fin del ciclo y el número real de sesiones. Se recalcula cada ciclo; no se consulta a la Academia.
Ver también `recurso/calendario-clases.md`.

### Ciclo 2026B (verificado contra el calendario oficial)

| | |
|---|---|
| Inicio de clases | lunes 17 de agosto de 2026 |
| Fin de clases | viernes 11 de diciembre de 2026 |
| Sesiones brutas (lun + mié) | 34 |
| Festivos en día de clase | miércoles 16 sep, lunes 16 nov |
| Sesiones reales | 32 |
| Máximo de faltas | **6** ordinario, **11** extraordinario |

Los máximos dan 6 y 11 tanto sobre 34 como sobre 32, porque el redondeo hacia abajo absorbe la
diferencia.

**Dos efectos del calendario en el diseño de las semanas:**

- **La semana 5 pierde la sesión de aula** (16 de septiembre). Por eso la semana 5 está diseñada
  para sostenerse sola con los dos bloques del lunes: la condición de carrera se reproduce en
  solitario y no necesita al grupo. La sesión de aula solo agrega comparación entre compañeros.
  **Esto no se escribe en el material visible.**
- **La semana 14 pierde la sesión de guía** (16 de noviembre). Es semana de revisión y no lleva
  guía de lunes, así que no afecta.

Si cambia el ciclo, hay que rehacer esta verificación antes de tocar nada más: las revisiones
amarran la mitad de las decisiones del semestre.

---

## Regla principal: Aprendizaje por proyecto progresivo

> **Cada clase y cada tema debe aportar directamente a las prácticas (proyecto individual) y al proyecto integrador del alumno. Los ejemplos de clase son fragmentos funcionales del proyecto, no ejercicios aislados.**

### Principio

"Lo que se ve en clase hoy, el alumno lo adapta en su proyecto mañana."

### El caso único del curso: Servidor de Pedidos

Existe **un solo sistema que se usa durante todo el semestre**: un servidor que recibe pedidos desde múltiples terminales de cajero, los procesa y gestiona inventario compartido.

Es el mismo tipo de sistema que opera en empresas como SICAR (puntos de venta). Todos los conceptos del SO encajan de forma natural y obligada, no forzada.

| Unidad | Lo que se agrega al sistema | Por qué ese tema aparece naturalmente |
|---|---|---|
| **U1** - Perspectivas | El servidor existe como proceso en el SO. Lo observamos: `ps`, `top`, estados | El SO es lo que hace que el servidor exista y corra |
| **U2** - Procesos | Cada pedido se maneja en un hilo separado. Dos cajeros piden el último producto al mismo tiempo -> condición de carrera, resuelta con semáforo | La concurrencia aparece sola cuando hay múltiples cajeros simultáneos |
| **U3** - Memoria | El catálogo de productos se mantiene en memoria (caché). Cola de pedidos pendientes -> administración del buffer | Sin gestión de memoria el servidor se cae bajo carga |
| **U4** - E/S | El servidor lee el catálogo desde un archivo al arrancar y escribe un recibo por cada pedido | El sistema necesita leer y escribir: ahí entran las llamadas al sistema |
| **U5** - Archivos | Los pedidos se persisten en un log (`pedidos.log`). Búsqueda directa por ID en el catálogo | Los archivos son la memoria permanente del servidor |
| **U6** - Red | El cajero es un cliente que se conecta por socket al servidor. Múltiples cajeros simultáneos | El sistema completo: cliente -> socket -> servidor -> archivo |

Al final del semestre el sistema es un servidor funcional end-to-end.

**Las prácticas** (nombre institucional del proyecto individual) son ese mismo servidor, cada alumno con su propio dominio (restaurante, farmacia, renta de equipos, librería, etc.).
**El proyecto integrador** es una versión más completa desarrollada en equipo, que integra todos los subsistemas.

### Cómo aplicarlo al generar materiales

- **Un solo caso central**: todos los ejemplos de código de todas las clases pertenecen al mismo sistema. No se inventa un nuevo contexto por tema.
- El alumno no parte de cero en su proyecto: **adapta y extiende lo que ya construimos juntos en clase**.
- Los temas se presentan en el **orden en que se necesitan en el proyecto**, no solo en el orden del temario oficial.
- Cada unidad **agrega una capa de funcionalidad** al caso central (procesos -> concurrencia -> memoria -> archivos -> red).

### Implicaciones para el diseño de cada clase

1. **Conectar con el proyecto desde el inicio de la sesión**: "Hoy vamos a agregar X a nuestro proyecto."
2. **El código de ejemplo es incompleto a propósito** en las partes que el alumno ya sabe (Java básico, estructuras de datos); solo se deja listo el fragmento nuevo del tema del día. Lo demás va como `TODO` con una pista.
3. **El cierre de cada sesión** indica explícitamente qué debe cambiar/agregar el alumno en su proyecto antes de la siguiente clase.
4. **BITACORA.md del alumno** debe crecer con cada tema.

---

## Estructura de cada semana (patrón establecido)

`semana-NN/index.md` tiene siempre las mismas tres secciones:

- `## Antes de la clase (aprendizaje invertido)` - la guía en bloques
- `## Durante la clase (aprendizaje activo)` - lo que se hace en aula sobre el caso central
- `## Avance de tu proyecto esta semana` - lo que el alumno agrega, con nombres de archivo
  concretos, y siempre cierra con la entrada de `BITACORA.md` y el push

Las semanas de revisión (09, 14, 17) usan una variante:

- `## Antes de la clase (entrega previa)` - con la lista de "Tu servidor debe:"
- `## Durante la clase (revisión)`
- `## Lo que se evalúa`

Toda semana lleva: frontmatter (`layout: default`, `title`), `[Inicio](/curso/so)` al principio,
dos párrafos de introducción que conectan con el proyecto, y un **índice** entre dos `---` con
**anclas explícitas `{#id}`** en cada encabezado, porque kramdown se come los acentos al
generarlas solo.

### La sesión de guía: estructura de bloques

`## Antes de la clase` es una **guía de trabajo, no una lectura**. Se parte siempre así:

- `### Cómo se trabaja esta guía` - tabla de bloques y la nota de "si te atoras, escríbelo y haz
  commit igual"
- `### Bloque 1: <nombre>` - obligatorio
- `### Bloque 2: <nombre>` - obligatorio
- `### Bloque extra: <nombre>` - opcional

Reglas de diseño de los bloques:

- **Dos bloques obligatorios de ~30 min de contenido cada uno.** Este grupo ya programa en Java y
  es de 5to semestre, así que el bloque 2 siempre es **código real que compila y corre**, no
  relleno. Aun así, 30 min de contenido les toma cerca de 45 min reales, y la sesión efectiva es
  de ~90 min: ese es el criterio de calibración. **No se copia la calibración de `curso/ia`**,
  que está bajada a propósito para un grupo más flojo y tiene sesiones de 120 min.
- **Cada bloque cierra con un entregable concreto** bajo `**Lo que entregas de este bloque**`, más
  su bloque `bash` con `git add / commit / push`. Un commit por bloque, nunca uno solo al final:
  las horas de los commits son lo que deja ver si trabajaron la sesión completa.
- **El entregable no se puede improvisar ni copiar**: se apoya en que cada alumno tiene un dominio
  distinto y en que las evidencias son salidas de **su** máquina (PIDs, tiempos medidos, `strace`
  de su proceso). Vale como entregado aunque esté mal; lo que no vale es no dejar rastro.
- **El bloque extra nunca es requisito de nada**: la sesión de aula debe poder arrancar solo con
  los bloques 1 y 2. Es para los 2 o 3 alumnos fuertes y se paga solo en las evidencias de su
  revisión (50%), sin puntos aparte.
- **Nada del lunes depende de que algo corra bien.** Se lee, se decide y se escribe código. Medir,
  romper y comparar es del miércoles.
- **El miércoles arranca donde terminó el lunes** ("llegas con X ya escrito"). Ese es el mecanismo
  real de cumplimiento: no hacerlo tiene costo visible el mismo miércoles.

La asistencia del lunes se registra con los commits de los bloques. **Eso no se escribe en el
programa**; se comunica en el encuadre y en Classroom con redacción neutra ("la asistencia se
registra con el commit de la actividad de la sesión").

---

## Organización del repositorio del alumno

El repositorio es **privado**, con Karlos agregado como colaborador (usuario `KarlosEspinoza`).
Público no: todos los repos se llaman igual y se encuentran buscando el nombre en GitHub, lo que
invita a copiar. La invitación se manda en el bloque 1 de la semana 1 y hay que verificarla esa
misma semana: un repo sin invitación es invisible y no se puede evaluar.

Estructura, definida en `semana-01` y fija para todo el semestre:

```
so-proyecto/
  README.md      <- quien eres y que dominio es tu servidor
  BITACORA.md    <- una seccion por semana
  src/           <- ServidorPedidos.java, Pedido.java, GestorInventario.java, ...
  datos/         <- catalogo.txt, pedidos.log, recibos/
  evidencias/    <- salidas de terminal: procesos.txt, strace.txt, deadlock.txt, ...
```

`evidencias/` es el equivalente de `figuras/` en `curso/ia`. En SO la evidencia casi siempre es
salida de terminal (`ps`, `jstack`, `strace`, `/proc`, `ss`), y sin un lugar fijo se pierde.

`BITACORA.md` lleva una sección por semana con **dos subsecciones fijas**: `### Antes de la clase`
(entregables de los bloques del lunes) y `### Avance del proyecto` (lo del miércoles en adelante).
Eso permite distinguir de un vistazo el trabajo de la guía del trabajo del proyecto.

Convención de mensajes de commit (`sNN` = número de semana):

| Momento | Mensaje |
|---|---|
| Fin del bloque 1 | `sNN bloque 1: ...` |
| Fin del bloque 2 | `sNN bloque 2: ...` |
| Bloque extra | `sNN extra: ...` |
| Avance del proyecto | `sNN proyecto: ...` |

---

## Las 17 semanas

| Sem | Tema | Bloque 1 | Bloque 2 | Bloque extra | Estado |
|---|---|---|---|---|---|
| 01 | Encuadre y configuración del entorno (U1) | El SO, kernel, modos y syscalls | Entorno WSL2 + repositorio | Mapa de syscalls por unidad | |
| 02 | Linux y el primer proceso (U1) | Árbol de procesos: `ps`, `top`, STAT, `/proc` | `ServidorPedidos.java` vivo y con log | `/proc/<pid>/status` campo por campo | |
| 03 | Contenedores y concepto de proceso (U1-U2) | Proceso vs programa: PCB, namespaces, cgroups | Proceso hijo con `ProcessBuilder` | El servidor dentro de Docker | |
| 04 | Hilos: pedidos concurrentes (U2) | Estados del proceso y qué comparte un hilo | Un hilo por pedido; `nlwp`, `top -H` | Pool con `ExecutorService` | |
| 05 | Condición de carrera (U2) | Sección crítica: el intercalado a mano | `PruebaCarrera.java`, 5 corridas distintas | Cuántos hilos para que falle siempre | |
| 06 | Exclusión mutua y semáforos (U2) | Espera activa, `synchronized`, `Semaphore` | Inventario protegido, mismas 5 corridas | Medir el costo del candado | |
| 07 | Bloqueos y sincronización (U2) | Las 4 condiciones de Coffman en tu dominio | Provocar el deadlock y leerlo con `jstack` | `tryLock` con timeout | |
| 08 | Comunicación entre procesos (U2) | Espacios separados; señales; SIGKILL no se atrapa | Shutdown hook + pipe entre dos procesos | Pipe con nombre (`mkfifo`) | |
| 09 | **Revisión de avances 1** | | | | |
| 10 | Planificación de procesos (U2) | Quantum, cambio de contexto, FIFO/SJF/RR, `nice` | `PlanificadorPedidos.java`, dos políticas | `nice`/`renice` bajo carga | |
| 11 | Administración de memoria (U3) | Virtual, real y swap; páginas; stack vs heap | Catálogo a `HashMap`; `VmSize` vs `VmRSS` | Archivo vs caché, 10000 consultas | |
| 12 | Diagnóstico de memoria (U3) | Fuga y OOM killer; JVM vs kernel | `BufferPedidos.java` acotado | Provocar la fuga y graficar `VmRSS` | |
| 13 | Llamadas al sistema y E/S (U4) | Trap, descriptores 0/1/2, buffering y `flush` | `GestorArchivos.java` visto con `strace` | `strace -c`: con y sin `BufferedWriter` | |
| 14 | **Revisión de avances 2** | | | | |
| 15 | Sistemas de archivos (U5) | Inodo, nombre vs contenido, `stat`, `df`, `du` | `pedidos.log` en append + índice con `seek` | Secuencial vs `seek` en 100000 líneas | |
| 16 | Sockets y red (U6) | El socket como descriptor; `accept()`, `ss` | `ClienteCajero.java` + un hilo por conexión | Cliente desde otra máquina | |
| 17 | **Revisión final** | | | | |

### Archivos del proyecto del alumno (progresión)

Los nombres se mantienen consistentes entre semanas para que el proyecto crezca de forma
acumulable. **Una vez publicada la semana que introduce un nombre, ese nombre queda congelado.**

| Semana | Archivos que agrega o modifica |
|---|---|
| 01 | `README.md`, `BITACORA.md`, estructura del repositorio |
| 02 | `src/ServidorPedidos.java`, `evidencias/procesos.txt` |
| 03 | `src/Pedido.java`, `datos/catalogo.txt` |
| 04 | `src/ServidorPedidos.java` (un hilo por pedido) |
| 05 | `src/GestorInventario.java`, `src/PruebaCarrera.java` |
| 06 | `src/GestorInventario.java` (semáforo) |
| 07 | `src/PruebaBloqueo.java` |
| 08 | `src/ServidorPedidos.java` (shutdown hook, pipe) |
| 10 | `src/PlanificadorPedidos.java` |
| 11 | `src/GestorInventario.java` (caché del catálogo) |
| 12 | `src/BufferPedidos.java` |
| 13 | `src/GestorArchivos.java`, `datos/recibos/` |
| 15 | `src/GestorArchivos.java` (log + índice), `datos/pedidos.log` |
| 16 | `src/ClienteCajero.java` |

---

## Contexto de los proyectos

### Prácticas (proyecto individual)

- La academia pidió que el proyecto individual se considere y se nombre **Prácticas** (misma
  dinámica). En todo material visible al alumno usar **Prácticas**, no "proyecto individual".
- Cada alumno desarrolla su propia aplicación que simula o usa conceptos del SO.
- Los detalles y rúbrica están en `evaluacion/practicas/index.md`.

### Proyecto integrador (equipo)

- Equipos de ~3 alumnos desarrollan un sistema más completo que integra múltiples subsistemas del
  SO (procesos, memoria, archivos, red).
- Los detalles y rúbrica están en `evaluacion/proyecto_integrador/index.md`.
- **Autoevaluación anónima entre pares:** NO va en el repo del equipo (ahí todos se verían).
  Cada alumno entrega un repo privado propio con un archivo CSV nombrado con su propio codigo de
  alumno (p. ej. `2162628.csv`, columnas `codigo,calificacion`; el nombre del archivo identifica
  al evaluador) y agrega al asesor como colaborador. Así los compañeros no se ven entre sí; solo
  el asesor lee todo. Automatización en `recurso/autoeval/`: `pull-autoevals.sh` y `aggregate.py`.
  Vale **10% de cada revisión**. El alumno actualiza su archivo `<codigo>.csv` con push **antes de
  cada una de las 3 revisiones**. Si no hace push, pierde ese 10% en esa revisión; no afecta a los
  compañeros (el promedio se calcula solo con las autoevaluaciones entregadas).

---

## Contexto laboral de los egresados

Los alumnos de Teleinformática suelen insertarse en:

- **Desarrollo backend** (empresa local SICAR: puntos de venta, Java/.NET)
- **DevOps / administración de servidores** (Linux, Docker, bash)
- **Soporte IT** (diagnóstico de sistemas, redes)
- **Desarrollo embebido** (IoT, sistemas embebidos)
- **Trabajo remoto** (startups, freelance)

Los ejemplos y proyectos deben reflejar estos contextos reales.

---

## Stack tecnológico del curso

- **Laptop del alumno:** Windows 10/11 (la gran mayoría)
- **Linux:** WSL2 (sin necesidad de VM ni dual boot)
- **Lenguaje principal:** Java (ya lo dominan desde semestres previos)
- **Editor:** Visual Studio Code con la extensión WSL
- **Control de versiones:** Git + GitHub (un repositorio privado por alumno)
- **Documentación:** Markdown en el propio repo (`BITACORA.md`)
- **Plataforma:** Google Classroom (el alumno entrega solo la URL de su repo, una sola vez)

Reglas al escribir materiales: todos los comandos van **dentro de la terminal de Ubuntu (WSL2)**,
salvo la activación inicial de WSL2, que es PowerShell. Las rutas se escriben estilo Linux.

---

## Ajuste de profundidad por tema

Dado el tiempo efectivo real (~45 h), se aplica la siguiente priorización:

| Unidad | Tratamiento |
|---|---|
| U1 - Perspectivas iniciales | Conceptual, ágil. Semanas 1 a 3. |
| U2 - Procesos | Núcleo del curso. Máxima profundidad. Concurrencia completa en Java. Planificación: lotes y FIFO en práctica; Tiempo Real/Distribuido/Embebido como panorama comparativo en una sola sesión. |
| U3 - Memoria | Conceptual + medición real sobre el proceso de la JVM (`/proc`, `free`, `-Xmx`). |
| U4 - E/S | Conceptual con llamadas al sistema básicas, observadas con `strace`. IN264 profundiza. |
| U5 - Sistemas de archivos | Práctico: operaciones de archivo en Java + estructura del FS de Linux vía WSL2. |
| U6 - Red | Práctico: sockets en Java (ya conocen redes teóricamente de Redes I-III). |

---

## Estructura de archivos del curso

```
curso/so/
  index.md                        <- Indice del curso: lista de 17 semanas
  programa/index.md               <- Programa institucional completo
  programa/bibliografia.csv       <- Bibliografia en CSV
  entorno/index.md                <- Referencia detallada de configuracion del entorno + video
  classroom.md                    <- Textos para copiar y pegar en Google Classroom
  CLAUDE.md                       <- Este archivo
  evaluacion/
    practicas/index.md            <- Instrucciones y rubrica de las practicas
    proyecto_integrador/index.md  <- Instrucciones y rubrica del integrador
  semana-01/index.md ... semana-17/index.md
  semana-NN/profesor.md           <- enlace simbolico al repo privado, en .gitignore
  recurso/                        <- Material de trabajo INTERNO (no se sirve en el sitio)
    reporte-laboral.md
    resumen-ejecutivo-laboral.md
    calendario-clases.md
    lineamiento-syllabus.md
    mejoras.md
    autoeval/
```

---

## Convenciones para generar materiales

- **Frontmatter obligatorio** en cada página: `layout: default` y `title`
- **Enlace de regreso** al inicio de cada subpágina: `[Inicio](/curso/so)`
- **Contexto de los ejemplos:** backend, servidores o sistemas reconocibles en empresas como SICAR
- **Código siempre en Java** salvo que el tema lo requiera diferente (bash para shell)
- **Los ejercicios son incompletos a propósito**: el pseudocódigo de lo ya visto (Java básico,
  colecciones) lo completan los alumnos; solo el fragmento nuevo del tema del día está listo
- **Cada sesión termina con una tarea de proyecto**

### Regla de caracteres especiales

En los archivos de contenido que ven los alumnos (`index.md` y cualquier página publicada del
curso) **no usar caracteres especiales** que no se puedan escribir con un teclado normal.

Caracteres prohibidos: `—` (em dash), `–` (en dash), `←`, `→`, `⬛`, comillas curvas y similares.

Sustituciones:

- `—` entre dos clausulas -> `:` o `,`
- `—` como parentesis -> `( )`
- `—` como separador de titulo o rango -> `-`
- flecha direccional -> `->` o `<-`

Los archivos internos (`CLAUDE.md`, `recurso/`, el repo `so-profesor`) no tienen esta restricción.

### Verificación después de escribir cada archivo visible

1. Sin caracteres prohibidos.
2. Frontmatter completo (`layout: default`, `title`).
3. `[Inicio](/curso/so)` presente.
4. Todas las anclas del índice resuelven a un encabezado con su `{#id}`.
5. Sin fechas: todo expresado como semana.
6. Sin descripción de modalidad.
