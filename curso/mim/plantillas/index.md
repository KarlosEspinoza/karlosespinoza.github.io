---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)

# Plantillas de entrega

Todo lo que se entrega en este curso tiene una estructura fija. No es burocracia: es lo que permite
que el panel revise en media hora y que su avance sirva de material para el manuscrito sin
reescribirlo.

Las plantillas también están en el repositorio del curso, en `plantillas/`. Cópielas de ahí.

| Plantilla | Quién la usa | Cuándo se entrega |
|---|---|---|
| [`ficha.md`](ficha.md) | Todos, una sola vez | En la sesión de arranque |
| [`avance.tex`](avance.tex) | El del turno | 48 horas antes de su turno |
| [`revision.md`](revision.md) | El panel | 24 horas antes del turno |

---

## La ficha del caso

Se llena una vez, en la [sesión de arranque](../encuadre/), y se corrige solo si el proyecto cambia
de rumbo. Es la definición de su caso: fenómeno, pregunta de ingeniería, variable de diseño y los dos
objetivos en conflicto.

Archivo: [`ficha.md`](ficha.md), va en `alumnos/<su codigo>/ficha.md`.

---

## El avance

Es el documento que usted defiende en su turno. **No hay diapositivas**: se expone sobre este PDF.

De 3 a 6 páginas, en LaTeX, con siete secciones fijas:

| # | Sección | Qué va ahí |
|---|---|---|
| 1 | Encargo recibido | Copiado literal del turno anterior |
| 2 | Qué estudié | La fuente, y el concepto con sus palabras, con ecuaciones y unidades |
| 3 | Cómo lo apliqué a mi caso | La técnica sobre su fenómeno, nunca en abstracto |
| 4 | Evidencia | Figuras numeradas con pie, tabla de resultados, error cuantificado |
| 5 | Cómo reproducirlo | Qué script se corre, en qué orden, qué archivo produce cada uno |
| 6 | Qué no me salió | Lo que falló y lo que quedó abierto |
| 7 | Referencias | La fuente del encargo y lo demás que haya consultado |

El criterio de si está bien escrito es este: **quien no estuvo en la sesión tiene que poder entenderlo
solo**. Si el documento solo se entiende con usted explicándolo al lado, está incompleto.

La sección 5 es la que hace verificable su trabajo: el panel la sigue al pie de la letra y o corre o
no corre. La sección 6 no baja la calificación; omitirla sí.

Archivo: [`avance.tex`](avance.tex), va en `alumnos/<su codigo>/avances/tNN/` junto con
`codigo/`, `datos/` y `figuras/`. Se sube el `.tex` y el `.pdf` compilado.

---

## La revisión del panel

Es lo que entrega cuando no es su turno. Cuatro secciones:

| # | Sección | Qué va ahí |
|---|---|---|
| 1 | ¿Corre? | Qué comandos corrió, qué salió, qué falló, con el mensaje de error pegado |
| 2 | Su papel | Supuestos o datos, según le haya tocado esta vez |
| 3 | Su objeción más fuerte | La que va a defender en la sesión |
| 4 | Qué se robaría | Una cosa del trabajo ajeno que le sirve a su propio proyecto |

La sección 4 no es cortesía. Es la razón por la que revisar el trabajo de otro le conviene a usted:
en un semestre va a ver tres problemas de modelado en lugar de uno.

Una revisión cuenta cuando trae una objeción sustantiva, algo que el autor tenga que responder.
Corregir la redacción no es una objeción.

Archivo: [`revision.md`](revision.md), va en `revisiones/tNN/revision-<su codigo>.md`.

---

## Archivos del profesor

Estos dos los mantiene el profesor en la raíz del repositorio. No los edite.

- [`encargos.md`](encargos.md): el registro de qué se le encargó a quién, en qué turno y con qué
  fuente. Ahí consulta usted su encargo vigente.
- [`alumnos_ejemplo.csv`](alumnos_ejemplo.csv): el formato del padrón del grupo. El archivo con los
  datos reales existe solo en el repositorio privado del curso.
- [`README_repositorio.md`](README_repositorio.md): el `README.md` del repositorio del curso, con el
  calendario de turnos.
