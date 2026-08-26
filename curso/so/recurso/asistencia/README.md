# Asistencia del lunes a partir de los commits (uso del asesor)

Material INTERNO. Primer paso del flujo semanal informal (ver
`recurso/revision/README.md`, seccion "Flujo semanal informal"). Genera
`~/curso/so/<ciclo>/asistencia/asistencia-s<numero>.md` con quien **no
entrego nada** esa semana en su `so-proyecto`, para pasar la inasistencia.

Es de **solo lectura**: lee `git log` de los repos ya clonados, nunca hace
`commit` ni `push`. Por eso no necesita autorizacion, a diferencia del paso
siguiente del flujo (la nota breve que se agrega a `REVISION.md`, que si la
necesita).

## Por que existe

El bloque 1 y el bloque 2 del lunes cierran cada uno con un commit
`sNN bloque 1: ...` / `sNN bloque 2: ...` en `so-proyecto` (convencion fija
de `CLAUDE.md`). Un atoron documentado usa el mismo formato de mensaje y
cuenta igual que el bloque entregado. Basta con que el mensaje exista para
saber que el alumno trabajo la sesion.

## Requisito: repos al dia

```bash
../pull-repos/pull-individuales.sh ~/curso/so/202620/alumnos.csv \
  ~/curso/so/202620/repos-individual
```

## Uso

```bash
./asistencia.sh alumnos.csv semana dir-ciclo [repos]
```

Ejemplo, semana 5:

```bash
./asistencia.sh ~/curso/so/202620/alumnos.csv 5 ~/curso/so/202620
```

Escribe `~/curso/so/202620/asistencia/asistencia-s05.md`.

## Que reporta

- **No entregaron nada**: ni `sNN bloque 1` ni `sNN bloque 2`. Es el
  contenido principal del `.md` - la lista para pasar inasistencia.
- Aparte, sin contar como inasistencia: **sin usuario de GitHub en el CSV**
  y **repo no clonado en local** (problemas de datos, no de asistencia).

## Notas

- No hace `git add`/`commit`/`push` a ningun repo, ni siquiera al local.
- CSV, repos clonados y los `.md` generados no se versionan (ver
  `.gitignore`).
