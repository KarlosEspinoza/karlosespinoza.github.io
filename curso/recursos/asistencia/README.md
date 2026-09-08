# Asistencia de la sesion de guia a partir de los commits (uso del asesor)

Material INTERNO y generico. Primer paso del flujo semanal informal (ver
`../revision/README.md`). Genera
`<dir-ciclo>/asistencia/asistencia-sNN.md` con quien **no entrego nada** esa
semana en su repositorio individual, para pasar la inasistencia.

Es de **solo lectura**: lee `git log` de los repos ya clonados, nunca hace
`commit` ni `push`. Por eso no necesita autorizacion, a diferencia del paso
siguiente del flujo (la nota breve que se agrega a `REVISION.md`, que si la
necesita).

## Por que existe

En todos los cursos el bloque 1 y el bloque 2 de la sesion de guia cierran
cada uno con un commit `sNN bloque 1: ...` / `sNN bloque 2: ...`. Un atoron
documentado usa el mismo formato de mensaje y cuenta igual que el bloque
entregado. Basta con que el mensaje exista para saber que el alumno trabajo
la sesion.

## Requisito: repos al dia

```bash
../pull-repos/pull-individuales.sh ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf
```

## Uso

```bash
./asistencia.sh <curso.conf> <semana> [dir-ciclo] [alumnos.csv]
```

Ejemplo, semana 3 de IA:

```bash
./asistencia.sh ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf 3
```

Escribe `~/curso/ia/202620/asistencia/asistencia-s03.md`.

## Que reporta

- **No entregaron nada**: ni `sNN bloque 1` ni `sNN bloque 2`. Es el contenido
  principal del `.md`, la lista para pasar inasistencia.
- Aparte, sin contar como inasistencia: **sin usuario de GitHub en el CSV** y
  **repo no clonado en local** (problemas de datos, no de asistencia).

## Si un curso usa otra convencion de commits

Se cambia en su `curso.conf`, sin tocar el script:

```bash
PATRON_ASISTENCIA="^s{NN} (bloque [12]|actividad)"
```

`{NN}` se sustituye por el numero de semana con dos digitos.
