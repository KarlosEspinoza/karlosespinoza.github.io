# Pull de repositorios de alumnos (uso del asesor)

Material INTERNO. Clona o actualiza en local los repositorios `so-proyecto`
(individuales) y los repositorios del proyecto integrador (por equipo), para
poder revisarlos con Claude Code antes de cada sesion de revision de avances.

Los datos reales de alumnos (CSV con nombre/correo/usuario) **no viven en
este repositorio** porque es publico. Viven aparte, por ejemplo en
`~/curso/so/<ciclo>/alumnos.csv`, y se pasan como argumento a los scripts.
Ambos scripts leen el mismo `alumnos.csv`.

## Repos individuales (`so-proyecto`)

El nombre del repo individual esta fijado por convencion (`so-proyecto`), asi
que la URL se arma sola a partir del `usuario` de GitHub que cada alumno dio
en el `alumnos.csv` (columnas: `codigo,nombre,email,usuario,equipo`).

```bash
./pull-individuales.sh ~/curso/so/202620/alumnos.csv
```

Clona/actualiza en `repos-individual/<codigo>-<usuario>/`. Al final imprime:

- cuantos se clonaron nuevos, cuantos se actualizaron, cuantos fallaron
  (normalmente porque el alumno no ha agregado a `KarlosEspinoza` como
  colaborador, o el repo no existe con ese nombre),
- que alumnos todavia no tienen `usuario` en el CSV (no han avisado su
  cuenta de GitHub).

## Repos de equipo (proyecto integrador)

El nombre del repo de equipo tambien esta fijado por convencion
(`integrador-so`, ver `semana-01` y `classroom.md`), igual que `so-proyecto`
para el individual. Lo crea el representante del equipo, que es la unica fila
de cada equipo con la columna `equipo` llena en `alumnos.csv`. La URL se arma
sola: no hace falta ningun CSV aparte con URLs de Classroom.

```bash
./pull-equipos.sh ~/curso/so/202620/alumnos.csv
```

Clona/actualiza en `repos-equipo/equipo-<N>-<usuario-representante>/`. Dentro
de cada uno vive el `equipo.csv` que trae el equipo (integrantes y dominios)
y el `README.md` con los acuerdos.

## Requisitos

- `gh` autenticado (`gh auth status`); git usa su credential helper sobre
  https, asi que un `git clone`/`git pull` normal ya funciona sin pedir
  contraseña.
- Haber sido agregado como colaborador en cada repo (individual y de equipo).
  Un fallo de clonado casi siempre es que falta esa invitacion, no un
  problema del script.

## Notas

- Correr los scripts de nuevo (sin borrar `repos-individual/` ni
  `repos-equipo/`) hace `pull --ff-only` en lugar de volver a clonar.
- `alumnos.csv`, `repos-individual/` y `repos-equipo/` estan en
  `.gitignore`: no se versionan en el sitio publico.
