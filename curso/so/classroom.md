# Google Classroom - IN235 Fundamentos de Sistemas Operativos

Textos listos para copiar y pegar al armar el Classroom.

**Sin fechas, para poder reusar el curso.** Ningún texto publicable menciona una fecha: dicen
"al término de la semana 1", "el miércoles", "antes de la fecha de entrega". Lo único que se ata
al calendario es **el campo de fecha de entrega de Classroom**, que va aparte de la descripción.
Al reusar el curso el siguiente semestre, con "Reutilizar publicación" copias el texto intacto y
lo único que vuelves a poner son esas fechas, mapeando semana a día.

Por eso en las notas de cada publicación la fecha aparece como semana ("miércoles de la semana
9"), que es lo que se traduce a día concreto cada ciclo.

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

**Nombre:** Fundamentos de Sistemas Operativos
**Sección:** IN235 - 5to semestre - Ing. en Teleinformática
**Materia:** Fundamentos de Sistemas Operativos
**Aula:** C5

### Temas (en este orden)

1. Empieza aqui
2. Unidad 1 - Perspectivas iniciales
3. Unidad 2 - Procesos y concurrencia
4. Unidad 3 - Administracion de memoria
5. Unidad 4 - Entrada y salida
6. Unidad 5 - Sistemas de archivos
7. Unidad 6 - Red
8. Revisiones de avances
9. Proyecto integrador

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
Bienvenidos al curso de Fundamentos de Sistemas Operativos.

Este curso no se estudia, se construye. Durante el semestre cada uno de ustedes va a levantar un sistema completo: un Servidor de Pedidos que recibe pedidos desde varias terminales de cajero, los atiende al mismo tiempo y gestiona un inventario compartido. Es el mismo tipo de sistema que opera una empresa de punto de venta como SICAR.

No hay temas sueltos. Cada semana le agrega una capa al mismo servidor: primero existe como proceso, luego atiende a varios cajeros a la vez, luego administra su memoria, luego escribe en archivos, y al final recibe conexiones por red desde otra máquina.

Todo el material del curso vive aquí:
https://karlosespinoza.github.io/curso/so

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

Todo el curso gira alrededor de un solo sistema: un Servidor de Pedidos. Cada quien elige el dominio de su negocio (farmacia, restaurante, librería, taller, estacionamiento, renta de equipo, veterinaria, lo que quieras) y ningún dominio se puede repetir en el grupo, porque después cada dominio va a ser una sucursal distinta del proyecto integrador.

Tu dominio necesita cumplir dos cosas: que haya algo que se pida y algo que se acabe. Sin un recurso limitado no hay dos cajeros peleando por lo mismo, y ahí se cae la mitad del curso.

COMO ENTREGAS

No se entrega nada por Classroom, salvo una cosa: la URL de tu repositorio de GitHub, una sola vez en todo el semestre. De ahí en adelante tu entrega es hacer push.

Tu repositorio es privado, y me agregas a mí como colaborador para que pueda revisarlo (Settings, Collaborators, Add people, usuario KarlosEspinoza). Si no me mandas esa invitación, no puedo ver tu trabajo y cuenta como no entregado. Al terminar el semestre puedes cambiarlo a público si quieres enseñarlo cuando busques trabajo.

Tu repositorio tiene esta estructura, y es la misma para todo el grupo:

so-proyecto/
   README.md      quien eres y que dominio es tu servidor
   BITACORA.md    una seccion por semana
   src/           ServidorPedidos.java, Pedido.java, GestorInventario.java, ...
   datos/         catalogo.txt, pedidos.log, recibos/
   evidencias/    salidas de terminal: procesos.txt, strace.txt, deadlock.txt, ...

La carpeta evidencias/ es particular de este curso. En Sistemas Operativos buena parte de lo que demuestras no es código: es la salida de un comando, con tus propios números de proceso y tus propios tiempos medidos. Eso va ahí, y sin un lugar fijo se pierde.

BITACORA.md

Es el archivo donde explicas con tus palabras qué entendiste y cómo lo aplicaste en tu servidor. No es un trámite: vale el 30% de cada revisión de avances.

Lleva una sección por semana, y cada semana tiene siempre las mismas dos partes:

## Semana 2 - Linux y el primer proceso
### Antes de la clase
(lo que trabajaste en la guia de la sesion)
### Avance del proyecto
(lo que le agregaste a tu servidor)

LOS COMMITS

El mensaje del commit me dice qué estabas haciendo sin que yo tenga que abrir nada. Usa siempre este formato, donde sNN es el número de semana:

s02 bloque 1: arbol de procesos observado
s02 bloque 2: servidor corriendo como proceso
s02 extra: ficha de proceso en /proc
s02 proyecto: servidor observable como proceso

Haz un commit al terminar cada bloque, no uno solo al final.

COMO SE TRABAJA CADA SEMANA

Cada semana tiene una guía "Antes de la clase" partida en dos bloques obligatorios y uno extra. Cada bloque termina con algo concreto que subes a tu repositorio. La guía se trabaja durante la sesión, no la noche anterior.

En la sesión del lunes se lee, se decide y se escribe código. En la del miércoles se ejecuta, se rompe y se depura en conjunto: la clase arranca donde terminó tu guía, así que si no la trabajaste, no vas a tener con qué trabajar.

El bloque extra es opcional. Es para quien terminó los dos primeros y quiere que su proyecto llegue más lejos. No hace falta para la clase del miércoles.

SI TE ATORAS

Esta es la regla más importante del semestre. Nunca te quedes sin entregar por no haberlo logrado: un bloque que no salió, pero que está bien documentado, cuenta como entregado.

Documentado quiere decir cuatro cosas, no "no me salió":

1. El comando exacto que ejecutaste.
2. El mensaje de error completo, copiado y pegado tal cual, no descrito de memoria.
3. Qué intentaste, en orden, mínimo dos cosas.
4. Dónde te quedaste exactamente.

Eso va en tu BITACORA.md, en una subsección que se llama Atorones. El formato completo está en la guía de la semana 1.

Te pido ese detalle por tres razones: copiar el error completo te obliga a leerlo, y buena parte de los errores de este curso dicen en su propio texto qué hay que hacer; escribir "qué intenté" te obliga a intentar; y me deja llegar el miércoles con la solución lista en vez de gastar la sesión averiguando qué te pasó.

Un atorón con las cuatro partes vale como bloque entregado. Un "no me salió" a secas, no.

SOBRE COPIAR

Cada quien tiene un dominio distinto, su propio catálogo y sus propios productos. Pero además, en este curso las evidencias son salidas de tu propia máquina: tus números de proceso, tus tiempos medidos, el rastro de llamadas al sistema de tu proceso. El código de otro no produce tus números, y eso se nota de inmediato.

Además, el 20% de cada revisión son preguntas sobre tu propio código, en el momento. Ahí es donde se cae el trabajo que no hiciste tú. Si vas a apoyarte en alguien, que sea para entender, no para copiar: lo segundo se ve.

LA ASISTENCIA

La asistencia de la sesión del lunes se registra con el commit de la actividad de la sesión. Cuenta que el trabajo exista, no que esté bien. Consulta tus faltas acumuladas en la tarea "Faltas".

COMO SE EVALUA

- Proyecto integrador (en equipo): 50%
- Prácticas (tu proyecto individual): 35%
- Actividades integradoras (las coordina la carrera): 5%
- Asistencia: 10%

Las prácticas y el proyecto integrador se califican en tres revisiones de avances, en las semanas 9, 14 y 17. En cada revisión de las prácticas:

- Evidencias (código en GitHub, commits, demo): 50%
- BITACORA.md: 30%
- Dos preguntas el día de la revisión: 20%

En el proyecto integrador se agrega autoevaluación entre pares, y los pesos quedan: evidencias 45%, BITACORA.md 25%, preguntas 20%, autoevaluación entre pares 10%.

Para cada revisión tienes que haber hecho push antes de la fecha de entrega, que es antes del día de la revisión. Yo reviso tu código y tu bitácora con anticipación, y el día de la revisión la sesión se dedica solo a las preguntas. Si no hay push a tiempo, la revisión cuenta como no entregada.
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

- Nombre so-proyecto y visibilidad privada.
- Mi usuario KarlosEspinoza agregado como colaborador (Settings, Collaborators, Add people). Sin esa invitación no puedo revisarte y tu trabajo cuenta como no entregado.
- README.md con tu nombre, tu código y el dominio de tu servidor.
- BITACORA.md con la sección de la semana 1.
- Las carpetas src/, datos/ y evidencias/.

Ojo con las carpetas: git no sube carpetas vacías, así que esta semana todavía no las vas a ver en GitHub. No es un error. Aparecen la semana que viene, en cuanto pongas un archivo dentro.

Responde con la URL completa, así:
https://github.com/tu-usuario/so-proyecto

Y en tu computadora deben quedar instalados, dentro de la terminal de Ubuntu (WSL2), no en Windows: Java JDK 21, Git y GitHub CLI (gh). Más Visual Studio Code en Windows con la extensión WSL.

Los pasos están en la guía de la semana 1:
https://karlosespinoza.github.io/curso/so/semana-01

Y la versión larga, con las fallas más comunes de cada paso, aquí:
https://karlosespinoza.github.io/curso/so/entorno
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
El proyecto integrador se hace en equipos de 2 o 3. Cada integrante trabaja un dominio distinto, porque cada dominio va a ser una sucursal del sistema multi-sucursal que van a integrar juntos.

Pónganse de acuerdo y suban un archivo llamado equipo.csv con una línea por integrante:

codigo,dominio
2162628,farmacia
2162631,restaurante
2162640,libreria

Reglas del archivo, porque lo voy a procesar con un script y si viene mal no lo lee:

- La primera línea es exactamente: codigo,dominio
- Una línea por integrante del equipo.
- El código va sin espacios y sin guiones.
- El dominio en una sola palabra, en minúsculas y sin acentos: farmacia, restaurante, libreria, taller, estacionamiento, veterinaria, renta. Si el tuyo no está en esa lista, invéntale una palabra corta y consúltalo conmigo.
- Nada de comas de más, ni líneas en blanco al final.

Lo suben los integrantes, el mismo archivo cada quien. Si dos traen el mismo dominio, resuélvanlo antes de entregar: no puede repetirse ni dentro del equipo ni en todo el grupo.
```

> **Nota para ti, no para publicar:** al juntar todos los `equipo.csv` puedes verificar de un
> jalón que ningún dominio se repita en el grupo entero, y cruzar la columna `codigo` contra la
> lista de inscritos para ver quién se quedó sin equipo. Ese es el punto de pedirlo en CSV y no
> en texto libre.

---

## 6. Material: autoevaluación entre pares

Tipo: **Material**. Tema: **Proyecto integrador**. Sin calificación y sin entrega por Classroom:
lo que se entrega es un push a un repositorio propio.

Va como Material y no como Tarea a propósito: si fuera Tarea, Classroom mostraría quién entregó
y quién no, y el alumno podría inferir cosas. Aquí solo tú sabes quién hizo push.

**Título:**

```
Autoevaluacion entre pares del proyecto integrador
```

**Descripción:**

```
El 10% de cada revisión del proyecto integrador sale de cómo evalúan tus compañeros de equipo tu participación. Es anónima entre ustedes: nadie del equipo ve lo que pusieron los demás, solo yo.

Se entrega así, y solo se configura una vez en todo el semestre:

1. Crea un repositorio privado con el nombre que quieras, distinto de so-proyecto. Puede ser autoeval-so.
2. Agrégame como colaborador (Settings, Collaborators, Add people, usuario KarlosEspinoza).
3. Dentro, crea un archivo de texto llamado con tu propio código de alumno y terminación .csv. Si tu código es 2162628, el archivo se llama 2162628.csv. El nombre del archivo dice quién está evaluando, así que no lo cambies.
4. El contenido es una línea por cada compañero de tu equipo, con su código y la calificación que le pones de 0 a 100:

codigo,calificacion
2162631,95
2162640,70

La primera línea es exactamente codigo,calificacion. No te incluyas a ti mismo.

Antes de cada una de las tres revisiones actualizas ese archivo y haces push. Son tres entregas, no una: la participación de un compañero puede cambiar entre unidades y esto lo tiene que reflejar.

Qué estás calificando: si cumplió lo que le tocaba, si lo entregó a tiempo para que los demás pudieran seguir, y si se puede contar con él cuando algo se rompe. No es simpatía.

Si no haces push antes de una revisión, pierdes ese 10% en esa revisión. No afecta a tus compañeros: su promedio se calcula solo con las autoevaluaciones que sí se entregaron.
```

---

## 7. Tarea semanal

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
Guía de la semana: https://karlosespinoza.github.io/curso/so/semana-NN

Ahí está lo que trabajas durante la sesión (los dos bloques y el extra) y lo que le agregas a tu proyecto.

Haz commit al terminar cada bloque. Marca esta tarea como completada cuando hayas hecho push de tu avance de la semana.

Si te atoraste, documéntalo en tu BITACORA.md con las cuatro partes y haz commit igual: cuenta como entregado.

Si tienes dudas, déjalas como comentario aquí.
```

### Las tareas semanales

Créalas todas de una vez al inicio del ciclo y ponles fecha. Así el semestre completo queda a la
vista del alumno desde el primer día y tú no vuelves a tocar el Classroom más que para las
calificaciones de las revisiones.

El título en Classroom es solo `Semana N`. Las columnas de tema y unidad son **para ti**, para
saber cuál es cuál al ponerles fecha y en qué tema del Classroom va cada una.

| Título en Classroom | URL de la guía | Tema del Classroom | Tema (solo tu referencia) |
|---|---|---|---|
| `Semana 1` | `.../semana-01` | Unidad 1 | Encuadre y configuración del entorno |
| `Semana 2` | `.../semana-02` | Unidad 1 | Linux y el primer proceso |
| `Semana 3` | `.../semana-03` | Unidad 1 | Contenedores y concepto de proceso |
| `Semana 4` | `.../semana-04` | Unidad 2 | Hilos: pedidos concurrentes |
| `Semana 5` | `.../semana-05` | Unidad 2 | Condición de carrera |
| `Semana 6` | `.../semana-06` | Unidad 2 | Exclusión mutua y semáforos |
| `Semana 7` | `.../semana-07` | Unidad 2 | Bloqueos y sincronización |
| `Semana 8` | `.../semana-08` | Unidad 2 | Comunicación entre procesos |
| (semana 9) | | Revisiones | -> sección 8, con calificación |
| `Semana 10` | `.../semana-10` | Unidad 2 | Planificación de procesos |
| `Semana 11` | `.../semana-11` | Unidad 3 | Administración de memoria |
| `Semana 12` | `.../semana-12` | Unidad 3 | Diagnóstico de memoria |
| `Semana 13` | `.../semana-13` | Unidad 4 | Llamadas al sistema y E/S |
| (semana 14) | | Revisiones | -> sección 8, con calificación |
| `Semana 15` | `.../semana-15` | Unidad 5 | Sistemas de archivos |
| `Semana 16` | `.../semana-16` | Unidad 6 | Sockets y red |
| (semana 17) | | Revisiones | -> sección 8, con calificación |

Base de las URL: `https://karlosespinoza.github.io/curso/so/`

Las semanas 9, 14 y 17 no llevan tarea semanal: en su lugar van las tres revisiones de avances de
la sección 8, que sí llevan calificación.

---

## 8. Las tres revisiones de avances

Tipo: **Tarea**, sin archivo, marcar como completada. Tema: **Revisiones de avances**.
Estas sí llevan calificación (100 puntos) y son las que alimentan el libro de calificaciones.

### Revisión 1 - semana 9

Fecha de entrega: **martes de la semana 9, 23:59** (el push va antes de la sesión).
Título: `Revisión de avances 1 - cierre de las Unidades 1 y 2`

```
Cierre de las Unidades 1 y 2. Revisamos tu servidor el miércoles en clase.

Tu servidor debe:

- Correr como proceso y poder observarse desde fuera: PID, padre, estado, consumo.
- Atender varios pedidos a la vez, un hilo por pedido.
- Tener un inventario compartido que se descuenta al atender un pedido.
- Demostrar la condición de carrera y demostrar que quedó resuelta con el mecanismo de exclusión mutua.
- Tener las evidencias de terminal en evidencias/, con tus propios números.
- BITACORA.md al día, con la entrada de cada semana.

Haz push antes de la fecha de entrega. Reviso tu código y tu bitácora con anticipación, y el día de la revisión la sesión se dedica solo a las preguntas. Si no hay push a tiempo, la revisión cuenta como no entregada.

Se evalúa: evidencias 50%, BITACORA.md 30%, dos preguntas el día de la revisión 20%.

Del proyecto integrador se evalúa lo mismo más la autoevaluación entre pares, con estos pesos: evidencias 45%, BITACORA.md 25%, preguntas 20%, autoevaluación 10%. No olvides actualizar tu archivo de autoevaluación y hacer push antes de esta fecha.

Detalle: https://karlosespinoza.github.io/curso/so/semana-09
```

### Revisión 2 - semana 14

Fecha de entrega: **martes de la semana 14, 23:59**.
Título: `Revisión de avances 2 - cierre de las Unidades 3 y 4`

```
Cierre de las Unidades 3 y 4. Mismo formato que la revisión 1: haz push antes de la fecha de entrega y revisamos tu servidor el miércoles en clase.

Acuérdate de actualizar tu archivo de autoevaluación entre pares y hacer push antes de esta fecha.

Detalle: https://karlosespinoza.github.io/curso/so/semana-14
```

### Revisión final - semana 17

Fecha de entrega: **martes de la semana 17, 23:59**.
Título: `Revisión final - demo del servidor completo`

```
Entrega final: demo del servidor completo, con cajeros conectándose por socket, inventario protegido, log de pedidos persistente y recibos escritos en disco.

Acuérdate de actualizar tu archivo de autoevaluación entre pares y hacer push antes de esta fecha.

Detalle: https://karlosespinoza.github.io/curso/so/semana-17
```

---

## 9. Registro de faltas

Una **Tarea** llamada `Faltas`, en el tema *Empieza aqui*, donde el número que aparece en la
calificación **no es una calificación: es el número de faltas acumuladas**. Cada alumno ve solo
la suya, sin hoja aparte y sin problema de privacidad.

**Configuración**

- Tipo: **Tarea**, sin archivo adjunto y sin nada que entregar.
- Puntos: pon el **total de sesiones del semestre** (34 en 2026B). Así el número siempre cabe
  y se lee como "3 de 34".
- Categoría de calificación: una con **peso 0%**, o desactiva "Mostrar calificación general a los
  alumnos". Si no lo haces, Classroom mete estos puntos en el promedio y le baja la calificación
  general a todo el grupo.
- Sin fecha de entrega. Se queda publicada todo el semestre y tú vas actualizando el número.

**Cómo la mantienes**

- Después de la sesión del lunes: de los commits de los bloques de la sesión.
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

La asistencia de la sesión del lunes se registra con el commit de la actividad de la sesión. Cuenta que el trabajo exista, no que esté bien: si te atoraste y lo documentaste en tu bitácora, cuenta como asistencia.

CUANTAS FALTAS PUEDES TENER

El Reglamento General de Evaluación y Promoción de Alumnos de la UdeG pide un mínimo de asistencia para tener derecho a que se te registre calificación:

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
> - **Los máximos de 6 y 11 son válidos con las dos bases posibles del ciclo 2026B**, así que no
>   hay que elegir: 34 sesiones brutas (lunes y miércoles del 17 de agosto al 11 de diciembre) o
>   32 sesiones reales descontando los dos festivos que caen en día de clase (miércoles 16 de
>   septiembre y lunes 16 de noviembre). El redondeo hacia abajo absorbe la diferencia:
>
>   | Base | 80% ordinario | 65% extraordinario |
>   |---|---|---|
>   | 34 sesiones | máx. 6 faltas | máx. 11 faltas |
>   | 32 sesiones | máx. 6 faltas | máx. 11 faltas |
>
>   Si cambia el ciclo, recalcula esto contra <https://escolar.udg.mx/calendarios> antes de
>   publicar los números.
> - Mandar las justificaciones a la Coordinación no es rigidez, es el reglamento. Si no lo dejas
>   escrito, te van a llegar recetas médicas todo el semestre y cada una es una decisión tuya que
>   después tienes que defender.
> - El plazo para reclamar es lo que te protege. Sin él, al cierre te llegan reclamaciones de
>   sesiones de hace dos meses que ya no puedes verificar.

---

## 10. Orden en que conviene armarlo

1. Crear la clase y los 9 temas.
2. Publicar "Como funciona el curso" (Material, tema *Empieza aqui*).
3. Publicar el anuncio de bienvenida y fijarlo.
4. Crear la pregunta de la URL del repositorio.
5. Crear la tarea de registro de equipo.
6. Crear el material de autoevaluación entre pares.
7. Crear la tarea "Faltas" y dejarla publicada todo el semestre.
8. Crear las 14 tareas semanales y las 3 revisiones, con sus fechas.
