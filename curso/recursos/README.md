# Scripts de revision de avances (uso del asesor)

Material INTERNO, comun a todos los cursos. Aqui viven los scripts que traen
los repositorios de los alumnos a la maquina local y sacan el reporte de
asistencia de la semana, para poder revisarlos con Claude Code.

**Nada en esta carpeta es especifico de un curso.** Todo lo que cambia entre
cursos (nombre de los repositorios, carpeta de datos del ciclo, plantillas de
retroalimentacion) vive en un archivo `curso.conf` dentro de cada curso:

```
curso/ia/recurso/curso.conf
curso/so/recurso/curso.conf
```

Ese conf es el primer argumento de todos los scripts. `curso.conf.ejemplo`
es la plantilla para dar de alta un curso nuevo.

**Los datos de alumnos no viven aqui.** El sitio es publico. `alumnos.csv`,
los repos clonados y los reportes generados viven fuera, en
`~/curso/<curso>/<ciclo>/`.

---

## Que hay

| Carpeta | Que hace | Toca repos de alumnos |
|---|---|---|
| `pull-repos/` | Clona o actualiza los repos individuales y los de equipo | Solo lectura (`clone`/`pull`) |
| `asistencia/` | Reporte semanal: quien no entrego nada esa semana | Solo lectura (`git log`) |
| `autoeval/` | Junta y promedia la autoevaluacion entre pares | Solo lectura |
| `revision/` | El flujo de retroalimentacion y los prompts | No, solo documenta |

El unico paso que **escribe** en los repositorios de los alumnos es
`aplicar-concentrado.py`, y no esta aqui: vive en `~/curso/scripts/`, fuera
del sitio publico. Ver `revision/README.md`.

---

## El `curso.conf`

```bash
CURSO=ia
REPO_INDIVIDUAL=clasificador-piezas-ia
REPO_EQUIPO=integrador-ia          # vacio si el curso aun no usa repo de equipo
REPO_AUTOEVAL=autoeval-ia          # vacio si no hay autoevaluacion entre pares
COLABORADOR=KarlosEspinoza
DIR_CICLO="$HOME/curso/ia/202620"  # se actualiza una vez por ciclo
PLANTILLA_INDIVIDUAL="$RECURSO_CURSO/revision/plantilla-individual.md"
PLANTILLA_EQUIPO="$RECURSO_CURSO/revision/plantilla-equipo.md"
```

`RECURSO_CURSO` ya viene definida cuando se lee el conf: es la carpeta donde
esta el propio conf.

Las URL de los repositorios **se arman solas** a partir del usuario de GitHub
de cada alumno y del nombre fijo del repo. Por eso no hace falta juntar URLs
de Classroom: el alumno entrega la suya una vez, tu la anotas en el CSV como
usuario, y de ahi en adelante todo sale de `alumnos.csv`.

---

## La carpeta del ciclo

Fuera del sitio publico, una por ciclo:

```
~/curso/ia/202620/
  alumnos.csv          <- codigo,nombre,email,usuario,equipo,representante
  repos-individual/    <- <codigo>-<usuario>/
  repos-equipo/        <- equipo-<numero>-<usuario>/
  repos-autoeval/      <- <codigo>-<usuario>/
  asistencia/          <- asistencia-sNN.md, concentrado-sNN.md
  revision/            <- 1/concentrado.md, 2/, 3/
```

`alumnos.csv` lleva encabezado con estas columnas:

```csv
codigo,nombre,email,usuario,equipo,representante
220647795,CAMBEROS LLAMAS VICTOR GABRIEL,victor@alumnos.udg.mx,victorcamberos4779,1,1
220618353,CASILLAS GONZALEZ JUAN PABLO,juan@alumnos.udg.mx,juancasillas1835,1,
```

Las columnas **se reconocen por nombre, no por posicion**: da igual el orden y
que un curso traiga columnas de mas. Obligatorias solo `codigo` y `usuario`.

- `usuario`: cuenta de GitHub. Vacio mientras el alumno no la haya entregado;
  los scripts lo reportan aparte, sin tratarlo como falla.
- `equipo`: numero de equipo, **lo llevan todos los integrantes**.
- `representante`: se llena solo en el integrante que crea el repositorio del
  proyecto integrador. Es de quien se clona ese repo. Si un curso no trae esta
  columna, se asume el formato viejo: representante es el unico integrante con
  `equipo` lleno.

`pull-equipos.sh` avisa si un equipo del CSV se quedo sin representante
marcado, o si alguien quedo marcado dos veces.

---

## Uso tipico

```bash
R=~/gh/karlosespinoza.github.io/curso/recursos
C=~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf

$R/pull-repos/pull-individuales.sh $C
$R/pull-repos/pull-equipos.sh      $C
$R/asistencia/asistencia.sh        $C 3
```

Cualquier script acepta la carpeta del ciclo como argumento extra, para
correr sobre un ciclo pasado sin editar el conf:

```bash
$R/asistencia/asistencia.sh $C 3 ~/curso/ia/202520
```

## Requisitos

- `gh` autenticado (`gh auth status`); git usa su credential helper sobre
  https, asi que `git clone`/`git pull` de un repo privado ya funciona sin
  pedir contrasena.
- Haber sido agregado como colaborador en cada repo. Un fallo de clonado casi
  siempre es eso, no un problema del script.
