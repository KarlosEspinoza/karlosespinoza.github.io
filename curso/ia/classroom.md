# Google Classroom - IE043 Inteligencia Artificial

Textos listos para copiar y pegar al armar el Classroom. Las fechas van como `[fecha]` porque
dependen del calendario del ciclo.

Regla de redacción para todo lo que se publique aquí: **nunca se menciona la modalidad de las
sesiones**. Siempre "durante la sesión", nunca "en linea", "a distancia" ni "virtual".

---

## 1. Configuración de la clase

**Nombre:** Inteligencia Artificial
**Sección:** IE043 - 7mo semestre - Ing. Mecatrónica
**Materia:** Inteligencia Artificial
**Aula:** C5

### Temas (en este orden)

1. Empieza aqui
2. Unidad 1 - Introducción
3. Unidad 2 - Aprendizaje supervisado
4. Unidad 3 - Aprendizaje no supervisado
5. Unidad 4 - Evaluación y despliegue
6. Revisiones de avances
7. Proyecto integrador

### Ajustes recomendados

- **Tablón:** dejar en "Los alumnos pueden comentar" (no "publicar"). El hilo de comentarios de
  la publicación de cada semana es el canal de dudas de la sesión, y de paso te queda registro
  escrito de quién preguntó qué.
- **Trabajo de clase:** organizar por tema, no por fecha.
- **Calificaciones:** solo las tres revisiones de avances llevan calificación. Las tareas
  semanales van "Sin calificación" para que el libro de calificaciones no se llene de ruido.

---

## 2. Anuncio de bienvenida (fijar en el tablón)

> Bienvenidos al curso de Inteligencia Artificial.
>
> Este curso no se estudia, se construye. Durante el semestre cada uno de ustedes va a levantar
> un sistema completo: un clasificador de piezas que lee la señal de un sensor, decide con un
> modelo de aprendizaje de máquina de qué tipo es la pieza y acciona un actuador para separarla.
> Es el mismo tipo de sistema que opera en una línea de producción real.
>
> No hay temas sueltos. Cada semana le agrega una capa al mismo sistema, y al final del semestre
> lo van a poner a correr sobre la maqueta del laboratorio con el PLC.
>
> Todo el material del curso vive aquí:
> https://karlosespinoza.github.io/curso/ia
>
> Antes de cualquier otra cosa, lean la publicación **"Como funciona el curso"**. Ahí está cómo
> se entrega, cómo se evalúa y cómo se trabaja cada semana. Es corta y les va a ahorrar
> problemas todo el semestre.

---

## 3. Material: "Como funciona el curso"

Tema: **Empieza aqui**. Es la publicación más importante del Classroom.

> ## Como funciona el curso
>
> ### El caso del semestre
>
> Todo el curso gira alrededor de un solo sistema: un **clasificador de piezas sobre banda
> transportadora**. Cada quien elige su propio dominio de clasificación (por material, por
> tamaño, por color, lo que quieras) y **ningún dominio se puede repetir en el grupo**, porque
> después cada dominio va a ser un módulo distinto del proyecto integrador.
>
> ### Como entregas
>
> No se entrega nada por Classroom, salvo una cosa: **la URL de tu repositorio de GitHub, una
> sola vez en todo el semestre**. De ahí en adelante tu entrega es hacer `push`.
>
> Tu repositorio es **privado**, y me agregas a mí como colaborador para que pueda revisarlo
> (Settings -> Collaborators -> Add people, usuario `[USUARIO_GITHUB_DEL_PROFESOR]`). **Si no me
> mandas esa invitación, no puedo ver tu trabajo y cuenta como no entregado.** Al terminar el
> semestre puedes cambiarlo a público si quieres enseñarlo cuando busques trabajo.
>
> Tu repositorio tiene esta estructura, y es la misma para todo el grupo:
>
> ```
> clasificador-piezas-ia/
>   README.md      <- quien eres y que clasifica tu sistema
>   BITACORA.md    <- una seccion por semana
>   codigo/        <- sensor.ino, leer_sensor.py, ...
>   datos/         <- los CSV que recolectes
>   figuras/       <- las graficas que generes
> ```
>
> ### BITACORA.md
>
> Es el archivo donde explicas **con tus palabras** qué entendiste y cómo lo aplicaste en tu
> sistema. No es un trámite: vale el 30% de cada revisión de avances.
>
> Lleva una sección por semana, y cada semana tiene siempre las mismas dos partes:
>
> ```markdown
> ## Semana 2 - La primera señal del sensor
>
> ### Antes de la clase
>
> (lo que trabajaste en la guía de la sesión del lunes)
>
> ### Avance del proyecto
>
> (lo que le agregaste a tu sistema)
> ```
>
> ### Los commits
>
> El mensaje del commit me dice qué estabas haciendo sin que yo tenga que abrir nada. Usa
> siempre este formato, donde `sNN` es el número de semana:
>
> ```
> s02 bloque 1: sensor.ino y formato de linea
> s02 bloque 2: leer_sensor.py y frecuencia de muestreo
> s02 extra: dos valores por linea
> s02 proyecto: señales capturadas de los tres tipos
> ```
>
> **Haz un commit al terminar cada bloque, no uno solo al final.**
>
> ### Como se trabaja cada semana
>
> **Lunes.** Trabajas la guía "Antes de la clase" de la semana. Está partida en **dos bloques
> obligatorios y uno extra**, y cada bloque termina con algo concreto que subes a tu
> repositorio. La guía se trabaja durante la sesión, no la noche anterior. Voy a estar
> disponible toda la sesión para resolver dudas: déjalas como comentario en la publicación de
> la semana.
>
> **Miércoles.** Aplicamos sobre el hardware lo que preparaste el lunes. La clase **arranca
> donde terminó tu guía**: si no la trabajaste, no vas a tener con qué trabajar.
>
> **El bloque extra es opcional.** Es para quien terminó los dos primeros y quiere que su
> proyecto llegue más lejos. No hace falta para la clase del miércoles.
>
> Y lo más importante: **si te atoras, escríbelo y haz commit igual**. Un commit que dice "no me
> salió, me quedé atorado aquí" es trabajo hecho y me sirve para saber dónde apoyarte el
> miércoles. Lo que no cuenta es no dejar rastro.
>
> ### Sobre copiar
>
> Cada quien tiene un dominio distinto, sus propias piezas y sus propios datos, así que el
> código de otro no le sirve a tu sistema: te va a dar resultados que no corresponden a tus
> gráficas ni a tu CSV, y se nota de inmediato.
>
> Además, el 20% de cada revisión son **preguntas sobre tu propio código**, en el momento. Ahí
> es donde se cae el trabajo que no hiciste tú. Si vas a apoyarte en alguien, que sea para
> entender, no para copiar: lo segundo se ve.
>
> ### La asistencia
>
> La asistencia de la sesión del lunes se registra con **los commits de la actividad de la
> sesión**. Cuenta que el trabajo exista, no que esté bien.
>
> ### Como se evalúa
>
> | Rubro | Peso |
> |---|---|
> | Prácticas (tu proyecto individual) | 35% |
> | Proyecto integrador (en equipo) | 35% |
> | Proyecto final de carrera | 20% |
> | Actividades integradoras | 5% |
> | Asistencia | 5% |
>
> Las prácticas y el proyecto integrador se califican en **tres revisiones de avances**, en las
> semanas 9, 14 y 17. En cada revisión:
>
> | Instrumento | Peso |
> |---|---|
> | Evidencias (código, datos, modelos, demo) | 50% |
> | BITACORA.md | 30% |
> | 2 preguntas el día de la revisión | 20% |
>
> En el proyecto integrador se agrega autoevaluación entre pares: Evidencias 45%, BITACORA 25%,
> Preguntas 20%, Autoevaluación 10%.
>
> Para cada revisión tienes que haber hecho `push` **antes** del día acordado. Si no hay push a
> tiempo, la revisión cuenta como no entregada.

---

## 4. Tarea única: entrega de la URL de tu repositorio

Tipo: **Pregunta -> Respuesta corta** (así ves todas las URL en una sola lista).
Tema: **Empieza aqui**. Sin calificación. Fecha de entrega: `[fin de la semana 1]`.

**Título:** Entrega la URL de tu repositorio de GitHub

**Instrucciones:**

> Esta es la única entrega que haces por Classroom en todo el semestre. De aquí en adelante tu
> entrega es hacer `push` a este mismo repositorio.
>
> Antes de responder, tu repositorio debe tener:
>
> - Nombre `clasificador-piezas-ia` y visibilidad **privada**.
> - Mi usuario `[USUARIO_GITHUB_DEL_PROFESOR]` agregado como colaborador
>   (Settings -> Collaborators -> Add people). **Sin esa invitación no puedo revisarte y tu
>   trabajo cuenta como no entregado.**
> - `README.md` con tu nombre, tu código y tu dominio de clasificación.
> - `BITACORA.md` con la sección de la semana 1.
> - Las carpetas `codigo/`, `datos/` y `figuras/`.
>
> Responde con la URL completa, así:
> `https://github.com/tu-usuario/clasificador-piezas-ia`
>
> Los pasos están en la guía de la semana 1:
> https://karlosespinoza.github.io/curso/ia/semana-01

**Desactiva** la opción de que los alumnos puedan editar su respuesta despues de entregar? No:
déjala activada, porque algunos van a pegar mal la URL.

---

## 5. Tarea: registro de equipo del proyecto integrador

Tipo: **Tarea** con archivo adjunto. Tema: **Proyecto integrador**. Sin calificación.
Fecha: `[fin de la semana 1]`.

**Entregan todos los integrantes el mismo archivo**, no uno solo por el equipo. Así Classroom te
marca de inmediato a quien no entregó, que casi siempre es el que se quedó sin equipo, y de paso
que los tres suban el mismo `equipo.csv` confirma que están de acuerdo en quién es quién.

**Título:** Registro de equipo y dominios

**Instrucciones:**

> El proyecto integrador se hace en equipos de 2 o 3. Cada integrante trabaja **un dominio
> distinto**, porque cada dominio va a ser un módulo del clasificador multi-dominio que van a
> integrar juntos.
>
> Pónganse de acuerdo y suban un archivo llamado **`equipo.csv`** con una línea por integrante:
>
> ```
> codigo,dominio
> 2162628,material
> 2162631,tamano
> 2162640,anomalias
> ```
>
> Reglas del archivo, porque lo voy a procesar con un script y si viene mal no lo lee:
>
> - La primera línea es exactamente `codigo,dominio`.
> - Una línea por integrante del equipo.
> - El código va sin espacios y sin guiones.
> - El dominio en **una sola palabra, en minúsculas y sin acentos**: `material`, `tamano`,
>   `color`, `contenido`, `estado`, `anomalias`. Si el tuyo no está en esa lista, invéntale una
>   palabra corta y consúltalo conmigo.
> - Nada de comas de más, ni líneas en blanco al final.
>
> **Lo suben los tres integrantes**, el mismo archivo cada quien. Si dos traen el mismo dominio,
> resuélvanlo antes de entregar: no puede repetirse ni dentro del equipo ni en todo el grupo.

> **Nota para ti, no para publicar:** al juntar todos los `equipo.csv` puedes verificar de un
> jalón que ningún dominio se repita en el grupo entero, y cruzar la columna `codigo` contra la
> lista de inscritos para ver quién se quedó sin equipo. Ese es el punto de pedirlo en CSV y no
> en texto libre.

---

## 6. Publicación semanal (plantilla)

Para cada semana se publican **dos cosas**: un Material con el contenido y una Tarea con la
fecha, para que les aparezca en "Pendientes".

### 6.1 Material de la semana

Tipo: **Material**. Tema: la unidad que corresponda.

**Título:** `Semana NN - <titulo de la semana>`

**Descripción:**

> **Guía de la sesión:** <URL de la semana>
>
> **Lunes.** Trabajas la guía "Antes de la clase". Bloques de esta semana:
>
> 1. <nombre del bloque 1>
> 2. <nombre del bloque 2>
> - Extra (opcional): <nombre del bloque extra>
>
> Haz commit al terminar cada bloque.
>
> **Miércoles.** <una linea de lo que se hace en clase, y con que hay que llegar>
>
> Deja tus dudas de la sesión como comentario en esta publicación.

### 6.2 Tarea de la semana

Tipo: **Tarea**, sin archivo adjunto, el alumno la marca como completada.
**Sin calificación.** Fecha de entrega: **miércoles 9:00**.

**Título:** `Semana NN - avance en tu repositorio`

**Instrucciones:**

> Al terminar la semana, tu repositorio debe tener:
>
> - <archivo o archivos nuevos>
> - La entrada de la semana en `BITACORA.md`, con sus dos partes
>   (`### Antes de la clase` y `### Avance del proyecto`).
>
> Marca esta tarea como completada cuando hayas hecho `push`.
>
> Guía completa: <URL de la semana>

> **Nota para ti, no para publicar:** la palomita de "completada" no prueba nada, la puede
> marcar cualquiera. Sirve como recordatorio y para que les aparezca en su calendario. El
> registro real es el `git log`.

---

## 7. Semana 1 (ya redactada)

### Material

**Título:** Semana 1 - Encuadre y configuración del entorno
Tema: **Unidad 1 - Introducción**

> **Guía de la sesión:** https://karlosespinoza.github.io/curso/ia/semana-01
>
> Esta semana dejas listo tu entorno de trabajo y creado el repositorio donde va a vivir tu
> proyecto todo el semestre. Y entiendes de qué se trata realmente el aprendizaje de máquina.
>
> **Lunes.** Trabajas la guía "Antes de la clase". Bloques de esta semana:
>
> 1. Tu entorno y tu repositorio: instalas todo y creas tu repo en GitHub.
> 2. De programar reglas a aprender de los datos: el concepto, y eliges tu dominio.
> - Extra (opcional): la hoja de datos de tu sensor.
>
> Haz commit al terminar cada bloque.
>
> **Miércoles.** Sesión de encuadre, **sin laptop**. Registramos los dominios de todo el grupo
> en el pizarrón y hacemos la dinámica del clasificador humano. Llegas con tu dominio ya
> elegido.
>
> Deja tus dudas de la sesión como comentario en esta publicación.

### Tarea

**Título:** Semana 1 - avance en tu repositorio
Fecha: `[miercoles de la semana 1]`, 9:00. Sin calificación.

> Al terminar la semana, tu repositorio debe tener:
>
> - `README.md` con tu nombre, tu código y tu dominio.
> - `BITACORA.md` con la sección de la semana 1 y sus dos partes.
> - Las carpetas `codigo/`, `datos/` y `figuras/`.
>
> Marca esta tarea como completada cuando hayas hecho `push`.
>
> Guía completa: https://karlosespinoza.github.io/curso/ia/semana-01

---

## 8. Semana 2 (ya redactada)

### Material

**Título:** Semana 2 - La primera señal del sensor
Tema: **Unidad 1 - Introducción**

> **Guía de la sesión:** https://karlosespinoza.github.io/curso/ia/semana-02
>
> Esta semana construyes la primera flecha del bucle: la que va del sensor a Python. Todavía no
> hay modelo ni actuador; la meta es que una señal del mundo físico llegue viva hasta tu
> computadora y la puedas ver.
>
> **Lunes.** Trabajas la guía "Antes de la clase". Todo se hace **sin el Arduino conectado**:
> hoy escribes el código y tomas las decisiones.
>
> 1. Cómo se hablan el Arduino y Python: escribes `sensor.ino`.
> 2. Leerlo desde Python, y a qué velocidad: escribes `leer_sensor.py` y decides tu frecuencia
>    de muestreo.
> - Extra (opcional): mandar dos sensores en la misma línea.
>
> Haz commit al terminar cada bloque.
>
> **Miércoles.** Conectamos. Llegas con `sensor.ino` y `leer_sensor.py` ya escritos del lunes y
> con tu `delay()` decidido, y comprobamos si aguantan la realidad. Trae tu Arduino, tu sensor y
> tus tres tipos de pieza.
>
> Deja tus dudas de la sesión como comentario en esta publicación.

### Tarea

**Título:** Semana 2 - avance en tu repositorio
Fecha: `[miercoles de la semana 2]`, 9:00. Sin calificación.

> Al terminar la semana, tu repositorio debe tener:
>
> - `codigo/sensor.ino` y `codigo/leer_sensor.py`.
> - En `figuras/`, la gráfica de la señal de cada uno de tus tres tipos de pieza, y una gráfica
>   con las tres juntas.
> - La entrada de la semana 2 en `BITACORA.md`, con sus dos partes.
>
> Marca esta tarea como completada cuando hayas hecho `push`.
>
> Guía completa: https://karlosespinoza.github.io/curso/ia/semana-02

---

## 9. Las tres revisiones de avances

Tipo: **Tarea**, sin archivo, marcar como completada. Tema: **Revisiones de avances**.
Estas sí llevan calificación (100 puntos) y son las que alimentan el libro de calificaciones.

### Revisión 1 - semana 9

Fecha de entrega: `[martes de la semana 9]`, 23:59 (el push va **antes** de la sesión).

> Cierre de las Unidades 1 y 2. Revisamos tu sistema el miércoles en clase.
>
> Tu sistema debe:
>
> - Leer la señal de tu sensor desde Python y guardar un dataset etiquetado de tus tres tipos de
>   pieza.
> - Extraer características en el dominio del tiempo y de la frecuencia.
> - Clasificar con un modelo entrenado por ti.
> - Cerrar el bucle: el Arduino actúa según la decisión del modelo.
> - `BITACORA.md` al día, con la entrada de cada semana.
>
> **Haz push antes de la fecha de entrega. Si no hay push a tiempo, la revisión cuenta como no
> entregada.**
>
> Se evalúa: evidencias 50%, BITACORA.md 30%, 2 preguntas el día de la revisión 20%.
>
> Detalle: https://karlosespinoza.github.io/curso/ia/semana-09

### Revisión 2 - semana 14

Fecha de entrega: `[martes de la semana 14]`, 23:59.

> Cierre de la Unidad 3. Mismo formato que la revisión 1.
>
> Detalle: https://karlosespinoza.github.io/curso/ia/semana-14

### Revisión final - semana 17

Fecha de entrega: `[martes de la semana 17]`, 23:59.

> Entrega final: demo del bucle de control completo sobre la maqueta con PLC.
>
> Detalle: https://karlosespinoza.github.io/curso/ia/semana-17

---

## 10. Orden en que conviene armarlo

1. Crear la clase y los 7 temas.
2. Publicar "Como funciona el curso" (Material, tema *Empieza aqui*).
3. Publicar el anuncio de bienvenida y fijarlo.
4. Crear la pregunta de la URL del repositorio.
5. Crear la tarea de registro de equipo.
6. Crear las tres revisiones de avances, con sus fechas. Así el calendario del semestre queda
   armado desde el primer día y los alumnos ven a qué le están apuntando.
7. Publicar semana 1 y semana 2.
8. Las semanas 3 a 17 se van publicando conforme se desarrollen, con la plantilla del punto 6.
