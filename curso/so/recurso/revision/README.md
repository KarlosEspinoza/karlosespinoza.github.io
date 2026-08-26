# Retroalimentacion a los alumnos (uso del asesor)

Material INTERNO. Dos flujos: la revision formal (semanas 9, 14, 17) y la
revision semanal informal (cualquier otra semana con bloques). Los dos
terminan igual: **prompt -> revisar manualmente el `concentrado.md` ->
autorizar y aplicar**. Nunca se hace commit/push a un repo de alumno sin ese
tercer paso explicito (regla dura completa en `CLAUDE.md` del curso, seccion
"Revision de avances: REVISION.md y el flujo de autorizacion").

## Revision formal (semanas 9/14/17)

1. **Pull fresco de todos los repos:**

   ```bash
   ~/gh/karlosespinoza.github.io/curso/so/recurso/pull-repos/pull-individuales.sh \
     ~/curso/so/202620/alumnos.csv ~/curso/so/202620/repos-individual
   ~/gh/karlosespinoza.github.io/curso/so/recurso/pull-repos/pull-equipos.sh \
     ~/curso/so/202620/alumnos.csv ~/curso/so/202620/repos-equipo
   ```

2. **Prompt** (copiar/pegar al abrir sesion con Claude Code):

   ```
   Vamos a hacer la revisión formal <numero> (semana <NN>) del ciclo
   ~/curso/so/202620.

   1. Corre pull-individuales.sh y pull-equipos.sh para traer todos los repos
      al día.
   2. Revisa cada repo individual (so-proyecto) y de equipo (integrador-so):
      evidencias/, BITACORA.md, y el código de src/. Si ya tienes las
      respuestas a las 2 preguntas de esa revisión, inclúyelas; si no, dejamos
      esa parte para el día de la revisión.
   3. Para cada alumno y equipo, asigna nivel (Excelente/Bueno/Suficiente/
      Insuficiente) por instrumento según la rúbrica de evaluacion/practicas
      (individual) o evaluacion/proyecto_integrador (equipo), con sus pesos.
   4. Redacta el concentrado.md en
      ~/curso/so/202620/revision/<numero>/concentrado.md, un bloque por
      alumno/equipo:

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
      plantilla-equipo.md).
   5. No toques ningún repo de alumno: nada de add/commit/push. Solo escribe el
      concentrado.md. Yo lo reviso y te autorizo aplicar.
   ```

   El ID de cada bloque es el mismo que usan `pull-individuales.sh` /
   `pull-equipos.sh` para nombrar la carpeta. En este paso no se toca ningun
   repo.

3. **Revisar manualmente el `concentrado.md` completo.** Para excluir a
   alguien del lote, borrar su bloque del archivo (no hay autorizacion
   parcial por comando: lo que quede en el archivo es lo que se aplica).

4. **Autorizar y aplicar:**

   ```bash
   # primero sin --confirmar para ver el dry-run
   python3 ~/curso/so/scripts/aplicar-concentrado.py \
     ~/curso/so/202620/revision/<numero>/concentrado.md \
     ~/curso/so/202620

   # ya revisado y autorizado, aplicar de verdad
   python3 ~/curso/so/scripts/aplicar-concentrado.py \
     ~/curso/so/202620/revision/<numero>/concentrado.md \
     ~/curso/so/202620 \
     --confirmar
   ```

   El script valida todos los repos antes de tocar cualquiera (clonados,
   limpios); si algo no cuadra aborta el lote completo. Commit por repo:
   el encabezado del bloque (`Revision <numero> (semana <NN>)`).

5. Listo: el alumno/equipo lo ve con su siguiente `git pull`.

## Revision semanal informal (asistencia + nota breve)

Cualquier semana con bloques (no en las semanas de revision 9/14/17).

1. **Pull fresco de todos los repos:**

   ```bash
   ~/gh/karlosespinoza.github.io/curso/so/recurso/pull-repos/pull-individuales.sh \
     ~/curso/so/202620/alumnos.csv ~/curso/so/202620/repos-individual
   ~/gh/karlosespinoza.github.io/curso/so/recurso/pull-repos/pull-equipos.sh \
     ~/curso/so/202620/alumnos.csv ~/curso/so/202620/repos-equipo
   ```


2. **Reporte de asistencia** (solo lectura, no toca ningun repo, sin
   autorizacion):

   ```bash
   ~/gh/karlosespinoza.github.io/curso/so/recurso/asistencia/asistencia.sh \
     ~/curso/so/202620/alumnos.csv <NN> ~/curso/so/202620
   ```

   Escribe `~/curso/so/202620/asistencia/asistencia-s<NN>.md`: quien no
   entrego nada esa semana, para pasar la inasistencia. Detalle en
   `recurso/asistencia/README.md`.

3. **Prompt** (copiar/pegar al abrir sesion con Claude Code):

   ```
   Vamos a hacer la revisión semanal informal de la semana <NN>. Ciclo: ~/curso/so/202620.

   1. Corre pull-individuales.sh para traer los repos so-proyecto al día.
   2. Corre recurso/asistencia/asistencia.sh con la semana <NN> para saber quién
      no entregó nada (genera asistencia-s<NN>.md).
   3. De los que sí entregaron algo, revisa brevemente los commits/diff de esta
      semana y BITACORA.md. No es evaluación formal: solo anota algo si de
      verdad destaca (un error importante, algo muy bien resuelto, algo que
      conviene corregir antes de la revisión formal). Si no hay nada que valga
      la pena decir, no le hagas bloque.
   4. Redacta el concentrado.md en
      ~/curso/so/202620/asistencia/concentrado-s<NN>.md, un bloque por alumno:

      <!-- BLOQUE: ALUMNO <codigo>-<usuario> -->
      ### Nota rápida (<fecha de hoy>)
      <texto corto>
      <!-- FIN BLOQUE -->

      Para los que no entregaron nada, un aviso corto y neutral (sin regañar),
      p. ej. "No veo commits de la semana <NN> (`s<NN> bloque 1`/`s<NN> bloque
      2`). Si tuviste un problema, cuéntamelo para que quede en la bitácora."
   5. Al final del archivo, FUERA de cualquier bloque (aplicar-concentrado.py
      solo lee lo que esta dentro de <!-- BLOQUE --> ... <!-- FIN BLOQUE -->,
      asi que esto nunca se aplica a ningun repo), agrega:

      ## Incidencias comunes de la semana <NN>

      Agrupa los problemas que se repitieron entre varios alumnos (mismo
      error, mismo malentendido, mismo bloqueo de entorno): de que se trata,
      a quienes les paso (codigo o usuario) y cuantos. Es para que Karlos
      la use como agenda del rescate de atorones del miercoles y para anotar
      si algo apunta a que el material de esa semana necesita ajuste para el
      siguiente ciclo.
   6. No toques ningún repo de alumno: nada de add/commit/push. Solo escribe el
      concentrado.md. Yo lo reviso y te autorizo aplicar.
   ```

   La seccion de incidencias queda en tu copia local de `concentrado.md`
   (`~/curso/so/202620/asistencia/concentrado-s<NN>.md`), no en ningun repo
   de alumno: es para ti, no para ellos.

4. **Revisar manualmente el `concentrado.md` completo.** Mismo criterio que
   la revision formal: para excluir a alguien, borrar su bloque (no hay
   autorizacion parcial por comando). La seccion de incidencias del final no
   necesita autorizacion (no se aplica a nada), pero de todas formas es lo
   primero que conviene leer: es la radiografia de la semana antes del
   miercoles.

5. **Autorizar y aplicar:**

   ```bash
   # primero sin --confirmar para ver el dry-run
   python3 ~/curso/so/scripts/aplicar-concentrado.py \
     ~/curso/so/202620/asistencia/concentrado-s<NN>.md \
     ~/curso/so/202620

   # ya revisado y autorizado, aplicar de verdad
   python3 ~/curso/so/scripts/aplicar-concentrado.py \
     ~/curso/so/202620/asistencia/concentrado-s<NN>.md \
     ~/curso/so/202620 \
     --confirmar
   ```

   El commit queda como el encabezado de la nota (`Nota rapida (<fecha>)`),
   no como `Revision N`, asi que en el historial de `REVISION.md` se
   distingue de una revision formal.

6. Listo: el alumno lo ve con su siguiente `git pull`.

## Referencia (no hace falta releer cada revision)

- Plantillas: `plantilla-individual.md`, `plantilla-equipo.md`. Cada seccion
  trae tabla de instrumento/peso/nivel (niveles y pesos de
  `evaluacion/practicas` o `evaluacion/proyecto_integrador`), un parrafo por
  instrumento, y "Para la siguiente revision".
- `REVISION.md` crece con cada revision (`## Revision N`), nunca se borra una
  anterior; es de una sola via (la escribe el asesor).
- Distinto de la autoevaluacion entre pares (anonima, repo aparte de cada
  alumno, ver `recurso/autoeval/`): eso no se copia aqui.
- Por que Markdown y no CSV: la retroalimentacion es prosa con contexto, no
  datos tabulares; en Markdown se lee igual que `BITACORA.md`.
