# Matematicas Aplicadas al Modelado de Materiales

Repositorio del curso IM156, Doctorado en Ciencia e Ingenieria de Materiales, CUCSUR UdeG.
Privado. Los tres alumnos y el profesor son colaboradores.

Aqui se entrega todo. No hay entregas por correo.

Las reglas completas estan en <https://karlosespinoza.github.io/curso/mim/tutoria/>.

## Como funciona

En cada turno un alumno pasa al banquillo con su avance y los otros dos son el panel que lo revisa.

| Quien | Que sube | Cuando |
|---|---|---|
| El del turno | Su avance: documento, scripts, datos y figuras | 48 horas antes |
| El panel | Su revision | 24 horas antes |

Sin push 48 horas antes no hay turno, y el turno no se repone.

## Estructura

```
README.md                  <- este archivo
encargos.md                <- que se le encargo a quien, en que turno
alumnos.csv                <- codigo, nombre y correo
plantillas/                <- ficha.md, avance.tex, revision.md
alumnos/
  <codigo>/
    ficha.md               <- su caso
    bitacora.md            <- una entrada por turno
    manuscrito/            <- el articulo que crece todo el semestre
    avances/
      tNN/
        avance.tex  avance.pdf
        codigo/  datos/  figuras/
revisiones/
  tNN/
    revision-<codigo>.md
```

## Regla de propiedad

Usted escribe **solo** dentro de `alumnos/<su codigo>/` y en sus propios archivos de `revisiones/`.
Los archivos de la raiz los mantiene el profesor.

Haga `git pull` antes de cada `git push`.

## Mensajes de commit

| Momento | Mensaje |
|---|---|
| Entrega del avance | `tNN avance: ...` |
| Entrega de la revision | `tNN revision: ...` |
| Entrada de bitacora | `tNN bitacora: ...` |
| Trabajo sobre el manuscrito | `tNN manuscrito: ...` |

## Calendario de turnos

Se sortea en la sesion de arranque. Cada quien pasa cinco veces al banquillo y diez al panel.

| Turno | Banquillo | Abogado de los supuestos | Abogado de los datos |
|---|---|---|---|
| t01 | | | |
| t02 | | | |
| t03 | | | |
| t04 | | | |
| t05 | | | |
| t06 | | | |
| t07 | | | |
| t08 | | | |
| t09 | | | |
| t10 | | | |
| t11 | | | |
| t12 | | | |
| t13 | | | |
| t14 | | | |
| t15 | | | |

Los papeles del panel se alternan: quien fue abogado de los supuestos en un turno es abogado de los
datos en el siguiente.

## Evaluacion

| Rubro | Peso |
|---|---|
| Tarea (los 5 avances) | 50% |
| Proyecto integrador (manuscrito 30% y defensa 10%) | 40% |
| Participacion y discusion (las 10 revisiones) | 10% |
