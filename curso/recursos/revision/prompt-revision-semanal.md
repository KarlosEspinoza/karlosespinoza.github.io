<curso>=so
<ciclo>=202620
<NN>=05

Vamos a hacer la revisión semanal informal de la semana <NN> del curso
<curso>. Ciclo: ~/curso/<curso>/<ciclo>. Conf:
curso/<curso>/recurso/curso.conf. Sustituye esas variables en todo lo que
sigue.

1. Corre pull-individuales.sh para traer los repos al día.
2. Corre asistencia.sh con la semana <NN> para saber quién no entregó nada
   (genera asistencia-s<NN>.md).
3. Si existe ~/curso/<curso>/<ciclo>/excepciones.md, léelo antes de anotar
   nada: son casos particulares ya autorizados por Karlos. No hagas
   observación sobre un punto que esté cubierto ahí para ese alumno o
   equipo.
4. De los que sí entregaron algo, revisa brevemente los commits/diff de esta
   semana y BITACORA.md. No es evaluación formal: solo anota algo si de
   verdad destaca (un error importante, algo muy bien resuelto, algo que
   conviene corregir antes de la revisión formal). Si no hay nada que valga
   la pena decir, no le hagas bloque.
5. Redacta el concentrado.md en
   ~/curso/<curso>/<ciclo>/asistencia/concentrado-s<NN>.md, un bloque por
   alumno:

   <!-- BLOQUE: ALUMNO <codigo>-<usuario> -->
   ### Nota rápida (<fecha de hoy>)
   <texto corto>
   <!-- FIN BLOQUE -->

   Para los que no entregaron nada, un aviso corto y neutral (sin regañar),
   p. ej. "No veo commits de la semana <NN> (`s<NN> bloque 1`/`s<NN> bloque
   2`). Si tuviste un problema, cuéntamelo para que quede en la bitácora."
6. Al final del archivo, FUERA de cualquier bloque (aplicar-concentrado.py
   solo lee lo que está dentro de <!-- BLOQUE --> ... <!-- FIN BLOQUE -->,
   así que esto nunca se aplica a ningún repo), agrega:

   ## Incidencias comunes de la semana <NN>

   Agrupa los problemas que se repitieron entre varios alumnos (mismo
   error, mismo malentendido, mismo bloqueo de entorno): de qué se trata,
   a quiénes les pasó (código o usuario) y cuántos. Es para usarla como
   agenda del rescate de atorones de la siguiente sesión y para anotar si
   algo apunta a que el material de esa semana necesita ajuste para el
   siguiente ciclo.
7. No toques ningún repo de alumno: nada de add/commit/push. Solo escribe el
   concentrado.md. Yo lo reviso y te autorizo aplicar.
