# Google Classroom - IE043 Inteligencia Artificial

Textos listos para copiar y pegar al armar el Classroom.

**Sin fechas, para poder reusar el curso.** Ningún texto publicable menciona una fecha: dicen
"al término de la semana 1", "el miércoles", "antes de la fecha de entrega". Lo único que se ata
al calendario es **el campo de fecha de entrega de Classroom**, que va aparte de la descripción.
Al reusar el curso el siguiente semestre, con "Reutilizar publicación" copias el texto intacto y
lo único que vuelves a poner son esas fechas, mapeando semana a día.

Por eso en las notas de cada publicación la fecha aparece como semana ("miércoles de la semana
2"), que es lo que se traduce a día concreto cada ciclo.

**Cómo está escrito este archivo.** Todo lo que va dentro de un bloque de código se copia y se
pega tal cual en Classroom. Está en **texto plano a propósito**: Classroom no renderiza markdown
ni admite tablas, así que no lleva asteriscos, ni almohadillas, ni backticks, ni tablas. Cada
párrafo va en una sola línea, para que al pegarlo no queden cortes raros. Si quieres resaltar
algo, hazlo con la barra de formato de Classroom después de pegar.

Lo que está fuera de los bloques de código son notas para ti y no se publica.

Regla de redacción para todo lo que se publique: **nunca se menciona la modalidad de las
sesiones**. Siempre "durante la sesión". La modalidad publicada es presencial, aula C5.

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
  la tarea de cada semana es el canal de dudas de la sesión, y de paso te queda registro escrito
  de quién preguntó qué.
- **Trabajo de clase:** organizar por tema, no por fecha.
- **Calificaciones:** solo las tres revisiones de avances llevan calificación. Las tareas
  semanales van "Sin calificación" para que el libro de calificaciones no se llene de ruido.

---

## 2. Anuncio de bienvenida

Publicar en el tablón y fijarlo.

```
Bienvenidos al curso de Inteligencia Artificial.

Este curso no se estudia, se construye. Durante el semestre cada uno de ustedes va a levantar un sistema completo: un clasificador de piezas que lee la señal de un sensor, decide con un modelo de aprendizaje de máquina de qué tipo es la pieza y acciona un actuador para separarla. Es el mismo tipo de sistema que opera en una línea de producción real.

No hay temas sueltos. Cada semana le agrega una capa al mismo sistema, y al final del semestre lo van a poner a correr sobre la maqueta del laboratorio con el PLC.

Todo el material del curso vive aquí:
https://karlosespinoza.github.io/curso/ia

Antes de cualquier otra cosa, lean la publicación "Como funciona el curso". Ahí está cómo se entrega, cómo se evalúa y cómo se trabaja cada semana. Es corta y les va a ahorrar problemas todo el semestre.
```

---

## 3. Material: "Como funciona el curso"

Tema: **Empieza aqui**. Es la publicación más importante del Classroom.

**Título:**

```
Como funciona el curso
```

**Descripción:**

```
EL CASO DEL SEMESTRE

Todo el curso gira alrededor de un solo sistema: un clasificador de piezas sobre banda transportadora. Cada quien elige su propio dominio de clasificación, que son dos cosas juntas: la categoría por la que clasificas (material, tamaño, color, lo que quieras) y los tres tipos de pieza concretos con los que lo haces.

No puede haber dos sistemas iguales en el grupo. La categoría se puede repetir entre compañeros, pero tus tres tipos de pieza tienen que ser tuyos. Dentro de tu equipo del proyecto integrador la regla es más estricta: los tres integrantes necesitan categorías distintas, porque cada categoría va a ser un módulo del sistema que van a integrar.

COMO ENTREGAS

No se entrega nada por Classroom, salvo una cosa: la URL de tu repositorio de GitHub, una sola vez en todo el semestre. De ahí en adelante tu entrega es hacer push.

Tu repositorio es privado, y me agregas a mí como colaborador para que pueda revisarlo (Settings, Collaborators, Add people, usuario KarlosEspinoza). Si no me mandas esa invitación, no puedo ver tu trabajo y cuenta como no entregado. Al terminar el semestre puedes cambiarlo a público si quieres enseñarlo cuando busques trabajo.

Tu repositorio tiene esta estructura, y es la misma para todo el grupo:

clasificador-piezas-ia/
   README.md      quien eres y que clasifica tu sistema
   BITACORA.md    una seccion por semana
   codigo/        sensor.ino, leer_sensor.py, ...
   datos/         los CSV que recolectes
   figuras/       las graficas que generes

BITACORA.md

Es el archivo donde explicas con tus palabras qué entendiste y cómo lo aplicaste en tu sistema. No es un trámite: vale el 30% de cada revisión de avances.

Lleva una sección por semana, y cada semana tiene siempre las mismas dos partes:

## Semana 2 - La primera señal del sensor
### Antes de la clase
(lo que trabajaste en la guía de la sesión del lunes)
### Avance del proyecto
(lo que le agregaste a tu sistema)

LOS COMMITS

El mensaje del commit me dice qué estabas haciendo sin que yo tenga que abrir nada. Usa siempre este formato, donde sNN es el número de semana:

s02 bloque 1: sensor.ino y formato de linea
s02 bloque 2: leer_sensor.py y frecuencia de muestreo
s02 extra: dos valores por linea
s02 proyecto: señales capturadas de los tres tipos

Haz un commit al terminar cada bloque, no uno solo al final.

COMO SE TRABAJA CADA SEMANA

Lunes. Trabajas la guía "Antes de la clase" de la semana. Está partida en dos bloques obligatorios y uno extra, y cada bloque termina con algo concreto que subes a tu repositorio. La guía se trabaja durante la sesión, no la noche anterior. Voy a estar disponible toda la sesión para resolver dudas: déjalas como comentario en la tarea de la semana.

Miércoles. Aplicamos sobre el hardware lo que preparaste el lunes. La clase arranca donde terminó tu guía: si no la trabajaste, no vas a tener con qué trabajar.

El bloque extra es opcional. Es para quien terminó los dos primeros y quiere que su proyecto llegue más lejos. No hace falta para la clase del miércoles.

Y lo más importante: si te atoras, escríbelo y haz commit igual. Un commit que dice "no me salió, me quedé atorado aquí" es trabajo hecho y me sirve para saber dónde apoyarte el miércoles. Lo que no cuenta es no dejar rastro.

SOBRE COPIAR

Cada quien tiene un dominio distinto, sus propias piezas y sus propios datos, así que el código de otro no le sirve a tu sistema: te va a dar resultados que no corresponden a tus gráficas ni a tu CSV, y se nota de inmediato.

Además, el 20% de cada revisión son preguntas sobre tu propio código, en el momento. Ahí es donde se cae el trabajo que no hiciste tú. Si vas a apoyarte en alguien, que sea para entender, no para copiar: lo segundo se ve.

LA ASISTENCIA

La asistencia de la sesión del lunes se registra con los commits de la actividad de la sesión. Cuenta que el trabajo exista, no que esté bien. Consulta tus faltas acumuladas en la tarea "Faltas".

COMO SE EVALUA

- Prácticas (tu proyecto individual): 35%
- Proyecto integrador (en equipo): 35%
- Proyecto final de carrera: 20%
- Actividades integradoras: 5%
- Asistencia: 5%

Las prácticas y el proyecto integrador se califican en tres revisiones de avances, en las semanas 9, 14 y 17. En cada revisión:

- Evidencias (código, datos, modelos, demo): 50%
- BITACORA.md: 30%
- Dos preguntas el día de la revisión: 20%

En el proyecto integrador se agrega autoevaluación entre pares, y los pesos quedan: evidencias 45%, BITACORA.md 25%, preguntas 20%, autoevaluación entre pares 10%.

Para cada revisión tienes que haber hecho push antes del día acordado. Si no hay push a tiempo, la revisión cuenta como no entregada.
```

---

## 4. Tarea única: entrega de la URL de tu repositorio

Tipo: **Pregunta -> Respuesta corta** (así ves todas las URL en una sola lista).
Tema: **Empieza aqui**. Sin calificación. Fecha de entrega: al término de la semana 1.
Deja activada la opción de que puedan editar su respuesta: varios van a pegar mal la URL.

**Título:**

```
Entrega la URL de tu repositorio de GitHub
```

**Instrucciones:**

```
Esta es la única entrega que haces por Classroom en todo el semestre. De aquí en adelante tu entrega es hacer push a este mismo repositorio.

Antes de responder, tu repositorio debe tener:

- Nombre clasificador-piezas-ia y visibilidad privada.
- Mi usuario KarlosEspinoza agregado como colaborador (Settings, Collaborators, Add people). Sin esa invitación no puedo revisarte y tu trabajo cuenta como no entregado.
- README.md con tu nombre, tu código y tu dominio de clasificación.
- BITACORA.md con la sección de la semana 1.
- Las carpetas codigo/, datos/ y figuras/.

Responde con la URL completa, así:
https://github.com/tu-usuario/clasificador-piezas-ia

Y en tu computadora deben quedar instalados: Python (marcando la casilla "Add Python to PATH"), Visual Studio Code, Git, el Arduino IDE y el driver CH340. Ese último es importante: sin él Windows no reconoce el Arduino Nano y la tarjeta no aparece por ningún lado. Anota también el puerto COM que le toca a tu tarjeta.

Un aviso para ahorrarte un rato de confusión: el instalador de Git deja un programa llamado Git Bash, y en este curso no se usa. Todos los comandos, los de Python y los de Git, se escriben en la terminal integrada de Visual Studio Code, la que abres con Ctrl + ñ. Es la única terminal que vamos a usar en todo el semestre.

Los pasos están en la guía de la semana 1:
https://karlosespinoza.github.io/curso/ia/semana-01
```

---

## 5. Tarea: registro de equipo del proyecto integrador

Tipo: **Tarea** con archivo adjunto. Tema: **Proyecto integrador**. Sin calificación.
Fecha: al término de la semana 1.

**Entregan todos los integrantes el mismo archivo**, no uno solo por el equipo. Así Classroom te
marca de inmediato a quien no entregó, que casi siempre es el que se quedó sin equipo, y de paso
que los tres suban el mismo `equipo.csv` confirma que están de acuerdo en quién es quién.

**Título:**

```
Registro de equipo y dominios
```

**Instrucciones:**

```
El proyecto integrador se hace en equipos de 2 o 3. Cada integrante trabaja una categoría distinta, porque cada categoría va a ser un módulo del clasificador multi-dominio que van a integrar juntos.

Pónganse de acuerdo y suban un archivo llamado equipo.csv con una línea por integrante:

codigo,dominio
2162628,material
2162631,tamano
2162640,anomalias

Reglas del archivo, porque lo voy a procesar con un script y si viene mal no lo lee:

- La primera línea es exactamente: codigo,dominio
- Una línea por integrante del equipo.
- El código va sin espacios y sin guiones.
- La columna dominio lleva tu categoría en una sola palabra, en minúsculas y sin acentos: material, tamano, color, contenido, estado, anomalias. Si la tuya no está en esa lista, invéntale una palabra corta y consúltalo conmigo. Tus tres tipos de pieza no van aquí, van en tu README.md.
- Nada de comas de más, ni líneas en blanco al final.

Lo suben los tres integrantes, el mismo archivo cada quien. Si dos traen la misma categoría, resuélvanlo antes de entregar: dentro del equipo las tres categorías tienen que ser distintas.
```

> **Nota para ti, no para publicar:** al juntar todos los `equipo.csv` puedes verificar de un
> jalón que dentro de cada equipo no se repita la categoría, y cruzar la columna `codigo` contra
> la lista de inscritos para ver quién se quedó sin equipo. Ese es el punto de pedirlo en CSV y
> no en texto libre. Que los tres tipos de pieza no se repitan en el grupo lo controlas en el
> pizarrón de la semana 1, no aquí.

---

## 6. Tarea semanal

Una sola publicación por semana, tipo **Tarea**, sin archivo adjunto, que el alumno marca como
completada. Sin calificación. Fecha de entrega: **miércoles 9:00** de esa semana.

No lleva Material aparte: **el detalle vive en la página del curso**. La tarea es solo el
recordatorio y el enlace, así hay un solo lugar que mantener y nunca se desincroniza con el
sitio. Las dudas de la sesión se dejan como comentario en esta misma tarea.

**Título:** `Semana NN` y nada más.

Sin el tema en el título, a propósito: **si más adelante cambias de qué trata una semana, lo cambias
en la página del curso y el Classroom no se toca**. El título del tema vive en un solo lugar.

**Instrucciones** (idénticas todas las semanas, solo cambia el número en la URL):

```
Guía de la semana: https://karlosespinoza.github.io/curso/ia/semana-NN

Ahí está lo que trabajas durante la sesión del lunes (los dos bloques y el extra) y lo que le agregas a tu proyecto.

Haz commit al terminar cada bloque. Marca esta tarea como completada cuando hayas hecho push de tu avance de la semana.

Si tienes dudas, déjalas como comentario aquí.
```

### Las tareas semanales

Créalas todas de una vez al inicio del ciclo y ponles fecha. Así el semestre completo queda a la
vista del alumno desde el primer día y tú no vuelves a tocar el Classroom más que para las
calificaciones de las revisiones.

El título en Classroom es solo `Semana N`. La columna del tema es **para ti**, para saber cuál es
cuál al ponerles fecha; no se escribe en Classroom.

| Título en Classroom | URL de la guía | Tema (solo tu referencia) |
|---|---|---|
| `Semana 1` | `.../semana-01` | Encuadre y configuración del entorno (U1) |
| `Semana 2` | `.../semana-02` | La primera señal del sensor (U1) |
| `Semana 3` | `.../semana-03` | Recolección de datos etiquetados (U2) |
| `Semana 4` | `.../semana-04` | Limpieza y normalización de señales (U2) |
| `Semana 5` | `.../semana-05` | Características en el dominio del tiempo (U2) |
| `Semana 6` | `.../semana-06` | Características en el dominio de la frecuencia (U2) |
| `Semana 7` | `.../semana-07` | Entrenamiento del clasificador (U2) |
| `Semana 8` | `.../semana-08` | Redes neuronales y primer bucle de control (U2) |
| (semana 9) | | -> sección 7, con calificación |
| `Semana 10` | `.../semana-10` | Aprendizaje no supervisado y PCA (U3) |
| `Semana 11` | `.../semana-11` | Agrupamiento: K-Means y DBSCAN (U3) |
| `Semana 12` | `.../semana-12` | Autoencoders para detección de anomalías (U3) |
| `Semana 13` | `.../semana-13` | La anomalía como señal de control (U3) |
| (semana 14) | | -> sección 7, con calificación |
| `Semana 15` | `.../semana-15` | Evaluación del modelo (U4) |
| `Semana 16` | `.../semana-16` | Sobreajuste y preparación para producción (U4) |
| (semana 17) | | -> sección 7, con calificación |

Base de las URL: `https://karlosespinoza.github.io/curso/ia/`

Las semanas 9, 14 y 17 no llevan tarea semanal: en su lugar van las tres revisiones de avances de
la sección 7, que sí llevan calificación.

---

## 7. Las tres revisiones de avances

Tipo: **Tarea**, sin archivo, marcar como completada. Tema: **Revisiones de avances**.
Estas sí llevan calificación (100 puntos) y son las que alimentan el libro de calificaciones.

### Revisión 1 - semana 9

Fecha de entrega: martes de la semana 9, 23:59 (el push va **antes** de la sesión).
Título: `Revisión de avances 1 - cierre de las Unidades 1 y 2`

```
Cierre de las Unidades 1 y 2. Revisamos tu sistema el miércoles en clase.

Tu sistema debe:

- Leer la señal de tu sensor desde Python y guardar un dataset etiquetado de tus tres tipos de pieza.
- Extraer características en el dominio del tiempo y de la frecuencia.
- Clasificar con un modelo entrenado por ti.
- Cerrar el bucle: el Arduino actúa según la decisión del modelo.
- BITACORA.md al día, con la entrada de cada semana.

Haz push antes de la fecha de entrega. Si no hay push a tiempo, la revisión cuenta como no entregada.

Se evalúa: evidencias 50%, BITACORA.md 30%, dos preguntas el día de la revisión 20%.

Detalle: https://karlosespinoza.github.io/curso/ia/semana-09
```

### Revisión 2 - semana 14

Fecha de entrega: martes de la semana 14, 23:59.
Título: `Revisión de avances 2 - cierre de la Unidad 3`

```
Cierre de la Unidad 3. Mismo formato que la revisión 1: haz push antes de la fecha de entrega y revisamos tu sistema el miércoles en clase.

Detalle: https://karlosespinoza.github.io/curso/ia/semana-14
```

### Revisión final - semana 17

Fecha de entrega: martes de la semana 17, 23:59.
Título: `Revisión final - demo del bucle de control`

```
Entrega final: demo del bucle de control completo sobre la maqueta con PLC.

Detalle: https://karlosespinoza.github.io/curso/ia/semana-17
```

---

## 8. Registro de faltas

Una **Tarea** llamada `Faltas`, en el tema *Empieza aqui*, donde el número que aparece en la
calificación **no es una calificación: es el número de faltas acumuladas**. Cada alumno ve solo
la suya, sin hoja aparte y sin problema de privacidad.

**Configuración**

- Tipo: **Tarea**, sin archivo adjunto y sin nada que entregar.
- Puntos: pon el **total de sesiones del semestre** (por ejemplo 34). Así el número siempre cabe
  y se lee como "3 de 34".
- Categoría de calificación: una con **peso 0%**, o desactiva "Mostrar calificación general a los
  alumnos". Si no lo haces, Classroom mete estos puntos en el promedio y le baja la calificación
  general a todo el grupo.
- Sin fecha de entrega. Se queda publicada todo el semestre y tú vas actualizando el número.

**Cómo la mantienes**

- Lunes después de las 11:00: de los commits de los bloques de la sesión.
- Miércoles: del pase de lista en clase.

Actualízala el mismo día. Una lista que actualizas cada tres semanas no sirve, porque el alumno
ya no se acuerda de qué día faltó y la reclamación se te vuelve discusión.

**Título:**

```
Faltas
```

**Instrucciones:**

```
Aquí llevo el registro de tus faltas. El número que ves no es una calificación: es cuántas faltas llevas acumuladas. Lo actualizo después de cada sesión.

No tienes que entregar nada en esta tarea. Solo consultarla.

La asistencia de la sesión del lunes se registra con los commits de la actividad de la sesión. Cuenta que el trabajo exista, no que esté bien: si te atoraste y lo escribiste en tu bitácora, cuenta como asistencia.

CUANTAS FALTAS PUEDES TENER

El Reglamento General de Evaluación y Promoción de Alumnos de la UdeG pide un mínimo de asistencia para tener derecho a que se te registre calificación. El curso tiene 34 sesiones, así que:

- Evaluación ordinaria: 80% de asistencia, es decir 6 faltas como máximo (artículo 20).
- Evaluación extraordinaria: 65% de asistencia, es decir 11 faltas como máximo (artículo 27).

Con 7 faltas pierdes el ordinario aunque tengas 100 de calificación, y no es algo que yo pueda dispensar.

FALTAS JUSTIFICADAS

Las faltas se justifican ante la Coordinación de Carrera, no conmigo (artículo 54). Llevas el documento que la respalda dentro de los cinco días hábiles siguientes a la fecha en que pudiste regresar a clases. Si la Coordinación las considera justificadas, me avisa y yo hago la anotación.

El reglamento reconoce como causas la enfermedad, una comisión conferida por autoridad universitaria y la fuerza mayor a juicio de la Coordinación (artículo 53). Y hay un tope: no se puede justificar más del 20% del total de horas de la materia.

Si una falta justificada te cae el día de una revisión de avances, acordamos otra fecha para hacerla (artículo 55). Avísame en cuanto sepas.

SI ALGO ESTA MAL

Dímelo por comentario privado en esta tarea durante la misma semana en que ocurrió. Después ya no hay forma de verificarlo y la falta se queda como está.
```

> **Notas para ti, no para publicar:**
>
> - Los porcentajes están verificados contra el reglamento vigente (2017): art. 20 fracc. II
>   (80% ordinario), art. 27 fracc. III (65% extraordinario), arts. 53 a 55 (justificación).
> - **El número de faltas depende de cómo cuentes el total, y ahí hay una inconsistencia que
>   tienes que resolver.** El calendario real son 17 semanas x 2 sesiones = **34 sesiones**, pero
>   `programa/index.md` declara **80 horas totales**, que a 4 horas por semana son 20 semanas o
>   40 sesiones. Los números publicados arriba salen de 34 sesiones:
>
>   | Base | 80% ordinario | 65% extraordinario |
>   |---|---|---|
>   | 34 sesiones (calendario real) | máx. 6 faltas | máx. 11 faltas |
>   | 40 sesiones (80 hrs del programa) | máx. 8 faltas | máx. 14 faltas |
>
>   El art. 19 deja los porcentajes de evaluación a lo aprobado por la Academia, así que confirma
>   ahí cuál es la base antes de publicarlo. Si eliges la otra, cambia los dos números.
> - Mandar las justificaciones a la Coordinación no es rigidez, es el reglamento. Si no lo dejas
>   escrito, te van a llegar recetas médicas todo el semestre y cada una es una decisión tuya que
>   después tienes que defender.
> - El plazo para reclamar es lo que te protege. Sin él, al cierre te llegan reclamaciones de
>   sesiones de hace dos meses que ya no puedes verificar.

---

## 9. Orden en que conviene armarlo

1. Crear la clase y los 7 temas.
2. Publicar "Como funciona el curso" (Material, tema *Empieza aqui*).
3. Publicar el anuncio de bienvenida y fijarlo.
4. Crear la pregunta de la URL del repositorio.
5. Crear la tarea de registro de equipo.
6. Crear la tarea "Faltas" y dejarla publicada todo el semestre.
7. Crear **las 14 tareas semanales y las 3 revisiones de avances**, todas de un jalón, con sus
   fechas tomadas del calendario oficial. Es lo más tardado del armado y solo se hace una vez:
   despues de esto el Classroom ya no se toca en todo el semestre, salvo para poner faltas y las
   calificaciones de las revisiones.

---

## Reusar el curso el siguiente semestre

Los textos no llevan fechas ni nombres de ciclo, así que se reusan tal cual. Al abrir el
Classroom nuevo:

1. **Reutilizar publicación** para traer las publicaciones del ciclo anterior. Trae el texto, no
   las fechas ni las entregas de los alumnos.
2. Poner **la fecha de entrega** de cada tarea, traduciendo la semana a día concreto según el
   calendario oficial del ciclo: <https://escolar.udg.mx/calendarios>. El número de semana va en
   el título de cada tarea, así que la traducción es directa.
3. Contar en ese mismo calendario las sesiones reales del ciclo (lunes y miércoles entre el
   inicio y el fin) y **recalcular los máximos de faltas** de la tarea "Faltas". Como el
   reglamento pide 80% de asistencia para ordinario y 65% para extraordinario, los máximos son
   el complemento: 20% y 35% del total de sesiones, redondeando hacia abajo. Con 34 sesiones son
   6 y 11. Hay que actualizar los dos números y también la línea "El curso tiene 34 sesiones"
   del texto publicado.

Lo que cambia cada semestre son las fechas, el total de sesiones y los dominios que registran los
alumnos. Todo lo demás se queda igual.
