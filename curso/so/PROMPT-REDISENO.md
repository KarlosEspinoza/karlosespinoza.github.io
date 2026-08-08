# Prompt para rediseñar el curso de Sistemas Operativos

Documento interno. Copia el bloque de abajo y pégalo como primer mensaje de una sesión de Claude
Code abierta en `/home/karlos/gh/karlosespinoza.github.io`.

El curso de IA (`curso/ia/`) ya quedó terminado con esta metodología el 2026-08-07. Sirve como
implementación de referencia: no hay que inventar el patrón, hay que copiarlo y adaptarlo a los
temas de SO.

---

## El prompt

```
Quiero rediseñar el curso de Sistemas Operativos (curso/so/) con la misma metodología con la
que quedó el curso de Inteligencia Artificial (curso/ia/).

ANTES DE ESCRIBIR NADA, lee y usa como referencia:

- curso/ia/CLAUDE.md          la metodología completa y todas las reglas
- curso/ia/semana-01/index.md y curso/ia/semana-05/index.md   dos semanas ya desarrolladas
- curso/ia/classroom.md       los textos de Google Classroom
- curso/ia/evaluacion/individual/index.md   la página de prácticas
- curso/so/CLAUDE.md          el contexto del curso de SO, que ya existe

Lo que YA está bien en curso/so/CLAUDE.md y no hay que reinventar: el caso único del semestre
(Servidor de Pedidos), la progresión por unidades, los pesos de evaluación, los tres
instrumentos de revisión, la confidencialidad de la modalidad de los lunes, y el contexto
laboral de los egresados. Respétalo todo.

Lo que hay que TRAER de curso/ia, porque es lo que se desarrolló después:

1. LA ESTRUCTURA DE BLOQUES DE LA SESIÓN DEL LUNES.
   "## Antes de la clase" deja de ser una lectura y se vuelve una guía de trabajo partida en:
   - ### Cómo se trabaja esta guía   (tabla de bloques + la nota de "si te atoras, escríbelo
     y haz commit igual")
   - ### Bloque 1: <nombre>          obligatorio, ~30 min de contenido
   - ### Bloque 2: <nombre>          obligatorio, ~30 min de contenido
   - ### Bloque extra: <nombre>      opcional
   Cada bloque cierra con "**Lo que entregas de este bloque**" y su bloque bash con
   git add / commit / push. Un commit por bloque, nunca uno solo al final.
   El bloque extra NUNCA es requisito de nada: el miércoles debe poder arrancar solo con los
   bloques 1 y 2.
   Calibración: el grupo tiene ~15 alumnos de 5to semestre que ya saben Java. Ajusta la
   dificultad a eso, no al grupo de IA (que es más flojo). Pero mantén el criterio de que
   30 min de contenido toman cerca de una hora real.

2. LA CONVENCIÓN DEL REPOSITORIO DEL ALUMNO.
   Repositorio privado con el asesor como colaborador (usuario KarlosEspinoza). Estructura fija
   todo el semestre. BITACORA.md con una sección por semana y DOS subsecciones fijas:
   "### Antes de la clase" y "### Avance del proyecto". Mensajes de commit con prefijo:
   sNN bloque 1: / sNN bloque 2: / sNN extra: / sNN proyecto:
   Adapta la estructura de carpetas a un proyecto Java, no a uno de Python.

3. EL MECANISMO DE CUMPLIMIENTO.
   El miércoles arranca donde terminó el lunes ("llegas con X ya escrito del lunes"). La
   asistencia del lunes se registra con los commits de los bloques, y eso se comunica con
   redacción neutra que NO revele la modalidad.

4. EL FORMATO DE PÁGINA.
   Cada semana desarrollada lleva: frontmatter, [Inicio](/curso/so) al principio, dos párrafos
   de introducción que conectan con el proyecto, y un índice entre dos --- con anclas
   explícitas {#id} en cada encabezado (kramdown se come los acentos al generarlas solo).
   Renombra "## Tu proyecto esta semana" a "## Avance de tu proyecto esta semana" en las 17.

5. LA REGLA DE MODIFICACIONES DURANTE EL CURSO.
   Cópiala de curso/ia/CLAUDE.md al inicio de curso/so/CLAUDE.md. Es la que dice que Karlos
   indica en qué semana va el curso antes de pedir un cambio, y que nunca se agrega un
   requisito de forma retroactiva.

6. UN classroom.md PARA SO.
   Mismo patrón que curso/ia/classroom.md: textos en TEXTO PLANO (Classroom no renderiza
   markdown ni admite tablas), cada párrafo en una sola línea, sin fechas, con los títulos de
   las tareas semanales como "Semana N" a secas para no tener que tocarlas si cambia el tema.

7. REVISAR LAS FECHAS DEL CICLO. Hazlo al principio, porque de ahí sale todo lo demás.
   curso/so/CLAUDE.md trae hoy las revisiones de avances en el 14 de octubre, el 18 de
   noviembre y el 9 de diciembre. Esas fechas vienen de un ciclo anterior y hay que
   verificarlas antes de usarlas.

   La fuente oficial es https://escolar.udg.mx/calendarios y de ahí salen tres cosas:
   - Las fechas de inicio y fin del ciclo.
   - El número REAL de sesiones (lunes y miércoles entre esas dos fechas, descontando
     festivos). Ese total define los máximos de faltas: 20% del total para ordinario y 35%
     para extraordinario, redondeando hacia abajo (reglamento UdeG, arts. 20 y 27).
   - En qué semana del calendario caen las revisiones 1, 2 y 3.

   Compara también con curso/so/recurso/calendario-clases.md, que ya calcula sesiones por
   ciclo, y dime si no coinciden.

   Pregúntame por el calendario del ciclo vigente antes de escribir cualquier fecha. Si
   todavía no lo tengo, deja las fechas fuera del material visible y expresadas como semana
   ("miércoles de la semana 9"), igual que se hizo en curso/ia: así el curso se reusa cada
   semestre sin volver a tocar los textos.

REGLAS DE ESCRITURA QUE NO SE NEGOCIAN:

- En archivos visibles al alumno, NADA de caracteres que no se escriban con un teclado normal:
  nada de guiones largos, flechas unicode ni comillas curvas. Usa -> y -- y comillas rectas.
- NUNCA escribas que la sesión del lunes es en línea, a distancia o virtual. Siempre "durante
  la sesión". La modalidad publicada es presencial, aula C5.
- El código de ejemplo es incompleto A PROPÓSITO en lo que el alumno ya sabe (Java básico,
  estructuras de datos); solo el fragmento nuevo del tema del día va listo. Marca lo demás
  como TODO con una pista.
- Los alumnos usan Windows con WSL2. Los comandos y rutas se escriben para eso.
- Un solo caso central: todo ejemplo pertenece al Servidor de Pedidos. No se inventa un
  contexto nuevo por tema.

CÓMO QUIERO QUE TRABAJEMOS:

Empieza por leer todo lo anterior y dime qué diferencias encuentras entre la metodología de
IA y el estado actual de SO, y qué propones para cada semana (nombre de los dos bloques
obligatorios y del extra, y qué archivo del proyecto agrega). Enséñame ese plan ANTES de
escribir las semanas. Cuando lo apruebe, desarrollamos.

Después de cada archivo que escribas, verifica: sin caracteres prohibidos, frontmatter
completo, [Inicio] presente, y que todas las anclas del índice resuelvan a un encabezado.
Un commit por cambio, con mensaje claro y sin caracteres especiales.
```

---

## Notas para Karlos, no van en el prompt

**Lo que ya tiene SO y no hay que rehacer.** `curso/so/CLAUDE.md` ya trae el caso único del
semestre (Servidor de Pedidos), la tabla de qué agrega cada unidad, la progresión semana a semana,
los pesos, los tres instrumentos y la mecánica de la autoevaluación entre pares con `<codigo>.csv`.
Eso está más maduro que como estaba IA al empezar.

**Lo que falta.** Las semanas 2 a 17 son esqueletos de 20 a 31 líneas con la estructura vieja de
tres secciones. La 01 ya está desarrollada (226 líneas) pero sin bloques. Es exactamente el punto
donde estaba IA al inicio de la sesión del 2026-08-07.

**Dos diferencias de contexto que conviene tener presentes:**

| | IA | SO |
|---|---|---|
| Grupo | Flojo, nivel bajo | ~15 alumnos, ya dominan Java |
| Sesión | 120 min | ~90 min efectivos |
| Revisiones | Semanas 9, 14, 17 | Semanas 9, 14, 17 (fechas fijas en CLAUDE.md) |
| Integrador | 35% | **50%** |
| Asistencia | 5% | **10%** |
| Hardware | Sí, y condiciona el lunes | No, todo es software |

La calibración de los bloques **no** se copia tal cual: en IA se bajó el nivel porque el grupo lo
pedía. En SO el grupo es más fuerte y las sesiones más cortas.

**Una decisión que en IA salió sola y en SO hay que forzar.** En IA los bloques del lunes quedaron
sin hardware porque el Arduino está en el aula. En SO no hay esa restricción física, así que hay
que decidir a propósito qué se hace el lunes y qué el miércoles. La regla que funcionó: **el lunes
se lee, se decide y se escribe código; el miércoles se ejecuta, se rompe y se depura en conjunto.**

**Lo del calendario.** Es el punto 7 del prompt y conviene resolverlo antes que nada, porque las
fechas de las revisiones amarran la mitad de las decisiones del semestre. Las que están hoy en
`CLAUDE.md` (14 oct, 18 nov, 9 dic) son de un ciclo anterior.

En IA la solución que funcionó fue **no meter fechas en el material visible**: todo se expresa como
semana ("miércoles de la semana 9") y lo único atado al calendario es el campo de fecha de entrega
de Google Classroom. Eso permite reusar el curso cada semestre sin reescribir nada. Vale la pena
hacer lo mismo aquí, y de paso quitar de `CLAUDE.md` las tres fechas fijas.
