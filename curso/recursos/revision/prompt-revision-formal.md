<curso>=so
<ciclo>=202620
<NN>=09
<numero>=1

Vamos a hacer la revisión formal <numero> (semana <NN>) del curso <curso>.
Ciclo: ~/curso/<curso>/<ciclo>. Conf: curso/<curso>/recurso/curso.conf.
Sustituye esas variables en todo lo que sigue.

1. Corre pull-individuales.sh y pull-equipos.sh para traer todos los repos
   al día. Si el curso.conf define REPO_AUTOEVAL, corre también
   pull-autoevals.sh y aggregate.py, y dime quién no tiene su repo de
   autoevaluación accesible: eso es el 10% que pierden en esta revisión.
2. Si existe ~/curso/<curso>/<ciclo>/excepciones.md, léelo antes de evaluar
   nada: son casos particulares ya autorizados por Karlos. No hagas
   observación sobre un punto que esté cubierto ahí para ese alumno o
   equipo.
3. Revisa cada repo individual y de equipo: el código, los datos, las
   figuras o evidencias, y BITACORA.md. Si ya tengo las respuestas a las 2
   preguntas de esa revisión, inclúyelas; si no, dejamos esa parte para el
   día de la revisión.
4. Para cada alumno y equipo, asigna nivel (Excelente/Bueno/Suficiente/
   Insuficiente) por instrumento según la rúbrica de evaluación del curso,
   con sus pesos.
5. Redacta el concentrado.md en
   ~/curso/<curso>/<ciclo>/revision/<numero>/concentrado.md, un bloque por
   alumno y por equipo:

   <!-- BLOQUE: ALUMNO <codigo>-<usuario> -->
   ## Revision <numero> (semana <NN>)

   | Instrumento | Peso | Nivel |
   |---|---|---|
   | Evidencias | 50% | |
   | BITACORA.md | 30% | |
   | Preguntas | 20% | |

   ### Evidencias
   ...
   ### BITACORA.md
   ...
   ### Preguntas
   ...
   ### Para la siguiente revision
   ...
   <!-- FIN BLOQUE -->

   (para equipo usa <!-- BLOQUE: EQUIPO <numero>-<usuario> --> y los pesos
   45/25/20/10 con la fila de Autoevaluacion entre pares, según
   plantilla-equipo.md del curso).
6. No toques ningún repo de alumno: nada de add/commit/push. Solo escribe el
   concentrado.md. Yo lo reviso y te autorizo aplicar.
