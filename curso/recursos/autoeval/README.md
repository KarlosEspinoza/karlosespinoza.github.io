# Autoevaluacion anonima del proyecto integrador (uso del asesor)

Material INTERNO y generico. Junta y promedia la autoevaluacion entre
companeros del proyecto integrador, manteniendola anonima entre alumnos.

## Como funciona la anonimidad

El problema: en el repo compartido del equipo todos verian las calificaciones.
La solucion: cada alumno entrega su autoevaluacion en un **repositorio privado
propio** y agrega al asesor como colaborador. Asi:

- Los companeros NO tienen acceso (repo privado, sin ellos) -> anonimo entre pares.
- El asesor si lee todo y puede promediar -> anonimo no significa secreto para el.

El repo se llama igual para todo el grupo (`REPO_AUTOEVAL` del conf, por
ejemplo `autoeval-ia`), asi que la URL se arma sola con el usuario de GitHub
del `alumnos.csv`, igual que el repo individual.

Dentro, cada alumno sube un CSV cuyo nombre es su propio codigo, por ejemplo
`2162628.csv`:

```csv
codigo,calificacion
2152525,90
2178899,100
```

El nombre del archivo identifica al evaluador; las filas, a quienes evalua.

## Flujo antes de cada revision

```bash
C=~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf

./pull-autoevals.sh $C
python3 aggregate.py ~/curso/ia/202620/repos-autoeval
# opcional, ademas exporta un csv:
python3 aggregate.py ~/curso/ia/202620/repos-autoeval --csv resultado.csv
```

`aggregate.py` imprime, por cada alumno evaluado, su promedio, cuantos lo
evaluaron y el detalle evaluador:calificacion (solo para ti).

Los que aparecen como fallidos en el pull son los que **no han creado su
repo o no invitaron al asesor**: eso es justo lo que hay que saber antes de
la revision, porque significa perder ese 10%.

## Notas

- Si un alumno se califica a si mismo, `aggregate.py` lo ignora y lo avisa.
- Si falta un CSV o tiene columnas mal, lo reporta al final sin detener el
  conteo.
- Los repos clonados y el `resultado.csv` viven en la carpeta del ciclo,
  fuera del sitio publico: contienen calificaciones.
