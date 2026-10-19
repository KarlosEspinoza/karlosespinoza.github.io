# Retroalimentacion a los alumnos (uso del asesor)

Material INTERNO y generico. Dos flujos: la revision semanal informal, que es
la de todas las semanas, y la revision formal de las semanas 9, 14 y 17. Los
dos terminan igual:

> **prompt -> revisar manualmente el `concentrado.md` -> autorizar y aplicar**

Nunca se hace `commit`/`push` a un repositorio de alumno sin ese tercer paso
explicito. La regla dura completa esta en el `CLAUDE.md` de cada curso,
seccion "Revision de avances: REVISION.md y el flujo de autorizacion".

Los prompts viven en archivos aparte, para copiarlos completos de un jalon:

| Flujo | Archivo |
|---|---|
| Revision semanal informal | `prompt-revision-semanal.md` |
| Revision formal (semanas 9, 14 y 17) | `prompt-revision-formal.md` |

Son la **version generica**. No hay que buscar y reemplazar cada `<curso>` o
`<ciclo>` del texto: **las primeras lineas del prompt declaran las
variables**, se cambian ahi los valores del dia y el resto se pega tal cual.

```
<curso>=ia
<ciclo>=202620
<NN>=03
```

Cada curso tiene ademas su propia copia con las rutas ya puestas, que es la
que conviene usar en el dia a dia:

- IA: `curso/ia/recurso/revision/README.md`

Los pull y el reporte de asistencia **van dentro del prompt**: no hay que
correr nada a mano antes de pegarlo. Los comandos sueltos, por si se quieren
correr sin Claude Code, estan al final.

---

## Donde llega la retroalimentacion: `REVISION.md`

En la raiz del repositorio del alumno y del equipo. El alumno la ve con su
propio `git pull`, no por Classroom ni por correo. Es de una sola via (la
escribe el asesor) y **crece con cada revision**: se agrega una seccion
nueva, nunca se borra una anterior.

La primera vez que se aplica algo, el archivo se crea con el encabezado de la
plantilla del curso (`plantilla-individual.md` / `plantilla-equipo.md`, en
`curso/<curso>/recurso/revision/`), que le explica al alumno que es ese
archivo. Por eso no hace falta anunciarlo en el material del curso.

---

## Revision semanal informal (asistencia + nota breve)

Cualquier semana con bloques, es decir las que no son de revision formal. Se
corre **al cerrar la sesion**, no durante: a media sesion aparecen como "no
entregaron nada" los que todavia estan trabajando.

1. **Prompt:** copiar completo `prompt-revision-semanal.md`, cambiar las
   variables de las primeras lineas y pegarlo al abrir sesion con Claude
   Code. Trae dentro el pull y el reporte de asistencia, no hay que correr
   nada antes.

   La seccion de incidencias queda solo en tu copia local: es para ti, no
   para ellos. El reporte de asistencia queda en
   `~/curso/<curso>/<ciclo>/asistencia/asistencia-s<NN>.md`: esa es la lista
   para pasar la inasistencia.

2. **Revisar manualmente el `concentrado.md`.** Mismo criterio: para excluir
   a alguien, borrar su bloque. La seccion de incidencias del final no
   necesita autorizacion (no se aplica a nada), pero es lo primero que
   conviene leer: es la radiografia de la semana antes de la siguiente
   sesion.

3. **Autorizar y aplicar.** Basta con decirselo a Claude Code ("autorizado,
   aplicalo"), o correrlo a mano:

   ```bash
   python3 ~/curso/scripts/aplicar-concentrado.py \
     ~/gh/karlosespinoza.github.io/curso/<curso>/recurso/curso.conf \
     ~/curso/<curso>/<ciclo>/asistencia/concentrado-s<NN>.md

   python3 ~/curso/scripts/aplicar-concentrado.py \
     ~/gh/karlosespinoza.github.io/curso/<curso>/recurso/curso.conf \
     ~/curso/<curso>/<ciclo>/asistencia/concentrado-s<NN>.md \
     --confirmar
   ```

   El commit queda como el encabezado de la nota (`Nota rapida (<fecha>)`), no
   como `Revision N`, asi que en el historial de `REVISION.md` se distingue de
   una revision formal.

4. Listo: el alumno lo ve con su siguiente `git pull`.

---

## Revision formal (semanas 9, 14 y 17)

1. **Prompt:** copiar completo `prompt-revision-formal.md`, cambiar las
   variables de las primeras lineas y pegarlo al abrir sesion con Claude
   Code. Trae dentro el pull de los repos y la autoevaluacion, no hay que
   correr nada antes.

   El ID de cada bloque es el mismo que usan `pull-individuales.sh` y
   `pull-equipos.sh` para nombrar la carpeta. En este paso no se toca ningun
   repo.

2. **Revisar manualmente el `concentrado.md` completo.** Para excluir a
   alguien del lote, borrar su bloque del archivo: no hay autorizacion
   parcial por comando, lo que quede en el archivo es lo que se aplica.

3. **Autorizar y aplicar.** Basta con decirselo a Claude Code ("autorizado,
   aplicalo"), o correrlo a mano:

   ```bash
   # primero sin --confirmar para ver el dry-run
   python3 ~/curso/scripts/aplicar-concentrado.py \
     ~/gh/karlosespinoza.github.io/curso/<curso>/recurso/curso.conf \
     ~/curso/<curso>/<ciclo>/revision/<numero>/concentrado.md

   # ya revisado y autorizado, aplicar de verdad
   python3 ~/curso/scripts/aplicar-concentrado.py \
     ~/gh/karlosespinoza.github.io/curso/<curso>/recurso/curso.conf \
     ~/curso/<curso>/<ciclo>/revision/<numero>/concentrado.md \
     --confirmar
   ```

   El script valida todos los repos antes de tocar cualquiera (que esten
   clonados y limpios); si algo no cuadra aborta el lote completo. Commit por
   repo, con el encabezado del bloque como mensaje.

4. Listo: el alumno o el equipo lo ve con su siguiente `git pull`.

---

## Comandos sueltos

Todo esto lo corre Claude Code desde el prompt. Estan aqui por si hace falta
correr uno solo, sin sesion.

```bash
R=~/gh/karlosespinoza.github.io/curso/recursos
C=~/gh/karlosespinoza.github.io/curso/<curso>/recurso/curso.conf

$R/pull-repos/pull-individuales.sh $C            # repos individuales al dia
$R/pull-repos/pull-equipos.sh      $C            # repos de equipo al dia
$R/asistencia/asistencia.sh        $C <NN>       # quien no entrego nada
$R/autoeval/pull-autoevals.sh      $C            # autoevaluacion entre pares
python3 $R/autoeval/aggregate.py ~/curso/<curso>/<ciclo>/repos-autoeval
```

---

## Referencia

- Las plantillas de `REVISION.md` son **por curso**, en
  `curso/<curso>/recurso/revision/`. Aqui quedan
  `plantilla-individual.md.ejemplo` y `plantilla-equipo.md.ejemplo` como punto
  de partida para dar de alta un curso nuevo.
- El encabezado de la plantilla (todo lo que va antes del primer `---`) es lo
  que `aplicar-concentrado.py` usa al crear un `REVISION.md` nuevo. Por eso el
  separador `---` tiene que estar.
- La autoevaluacion entre pares es otra cosa (anonima, repo aparte de cada
  alumno, ver `../autoeval/`): no se copia al `REVISION.md`.
- Por que Markdown y no CSV: la retroalimentacion es prosa con contexto, no
  datos tabulares; en Markdown se lee igual que `BITACORA.md`.
