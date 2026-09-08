# Pull de repositorios de alumnos (uso del asesor)

Material INTERNO y generico. Clona o actualiza en local los repositorios de
los alumnos (individuales y de equipo) para poder revisarlos con Claude Code
antes de cada sesion de revision de avances.

Los datos reales de alumnos no viven en este repositorio porque es publico:
viven en `~/curso/<curso>/<ciclo>/alumnos.csv`, y esa ruta sale del
`DIR_CICLO` del `curso.conf`.

## Repos individuales

El nombre del repo individual esta fijado por convencion en cada curso
(`REPO_INDIVIDUAL` del conf), asi que la URL se arma sola con el `usuario` de
GitHub que cada alumno dio.

```bash
./pull-individuales.sh ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf
```

Clona o actualiza en `<dir-ciclo>/repos-individual/<codigo>-<usuario>/`. Al
final imprime cuantos se clonaron, cuantos se actualizaron, cuales fallaron
(normalmente porque el alumno no ha agregado al asesor como colaborador, o el
repo no existe con ese nombre) y que alumnos todavia no tienen `usuario` en
el CSV.

## Repos de equipo (proyecto integrador)

Mismo mecanismo con `REPO_EQUIPO`. Lo crea el representante del equipo, que
en `alumnos.csv` es la fila con la columna `representante` llena; el numero
del equipo sale de la columna `equipo`, que la llevan todos los integrantes.
Si el CSV no trae columna `representante` (formato viejo), se asume que el
representante es el unico integrante con `equipo` lleno.

```bash
./pull-equipos.sh ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf
```

Clona en `<dir-ciclo>/repos-equipo/equipo-<N>-<usuario>/`, y al final avisa
que equipos del CSV se quedaron sin representante marcado.

Si el curso todavia no usa repositorio de equipo, `REPO_EQUIPO` va vacio en
el conf y el script lo dice y no hace nada.

## Argumentos

```
./pull-individuales.sh <curso.conf> [dir-ciclo] [alumnos.csv]
./pull-equipos.sh      <curso.conf> [dir-ciclo] [alumnos.csv]
```

Los dos ultimos son opcionales: por default salen del conf
(`DIR_CICLO` y `<dir-ciclo>/alumnos.csv`).

## Notas

- Correr los scripts de nuevo, sin borrar nada, hace `pull --ff-only` en
  lugar de volver a clonar.
- Solo leen: nunca hacen `commit` ni `push` a un repo de alumno.
