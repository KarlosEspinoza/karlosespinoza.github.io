---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)

# Dinámica del curso: la clínica de modelado

Este curso no funciona como una cátedra. No hay un tema por semana que todos vean al mismo tiempo,
porque cada uno de ustedes trabaja sobre un fenómeno distinto: el de su propia tesis.

Funciona como una **clínica**. En cada turno un alumno pasa al banquillo con su avance y los otros
dos son el panel que lo revisa. Los papeles rotan. A lo largo del semestre cada quien pasa cinco
veces al banquillo y diez veces al panel.

Lo que se evalúa no es lo que usted sabe, sino dos cosas: cuánto avanzó su proyecto y cuánto aportó
al proyecto de los demás.

---

## Índice

- [Los tres papeles](#los-tres-papeles)
- [El encargo: usted estudia por su cuenta](#el-encargo)
- [Antes de la sesión](#antes-de-la-sesion)
- [Durante la sesión](#durante-la-sesion)
- [Reglas duras](#reglas-duras)
- [El repositorio](#el-repositorio)
- [La bitácora](#la-bitacora)
- [Evaluación](#evaluacion)

---

## Los tres papeles {#los-tres-papeles}

### El del turno

Es quien expone. Llega con su avance ya escrito y publicado en el repositorio del curso, y lo
defiende. **No trae diapositivas: trae un documento.**

### El panel

Son los otros dos. Cada uno llega con un papel asignado:

| Papel | Qué ataca |
|---|---|
| Abogado de los supuestos | La validez del modelo: por qué homogéneo, por qué isotérmico, dónde deja de valer |
| Abogado de los datos | La evidencia: de dónde salió cada parámetro, si el error está cuantificado, si el código corre |

Los papeles se alternan. Si en un turno le tocó supuestos, en el siguiente le toca datos.

El abogado de los datos tiene una obligación concreta: **clonar el repositorio y correr los scripts
del avance antes de la sesión**. Si no corren, eso es un hallazgo y se reporta tal cual, con el
mensaje de error pegado.

### El profesor

No expone. Pregunta, corrige y, al cierre, dicta el siguiente encargo.

---

## El encargo: usted estudia por su cuenta {#el-encargo}

Al final de cada turno usted sale con un **encargo**: el concepto, modelo o técnica que su proyecto
necesita para dar el siguiente paso. Nunca es un tema suelto. Siempre trae cuatro cosas:

| Parte | Para qué sirve |
|---|---|
| Concepto o técnica | Lo que va a aprender |
| Fuente exacta | Capítulo y sección de dónde estudiarlo |
| Pregunta que debe poder responder | El criterio de que lo entendió |
| Evidencia esperada | Lo que tiene que aparecer en su próximo avance |

Usted lo estudia solo. En su siguiente turno **nadie se lo va a explicar: usted lo explica**. Ese es
el bloque en el que el del turno le enseña al grupo lo que estudió, aplicado a su propio caso. Si lo
entendió, se nota ahí; si no, también.

Todos los encargos quedan registrados en `encargos.md`, en el repositorio, con la fecha y a quién le
tocaron.

---

## Antes de la sesión {#antes-de-la-sesion}

| Quién | Qué sube | Cuándo |
|---|---|---|
| El del turno | Su avance completo: documento, scripts, datos y figuras | 48 horas antes |
| El panel (los dos) | Su revisión | 24 horas antes |

El del turno llega habiendo leído las dos revisiones. No se leen en voz alta durante la sesión: ya
todos las leyeron.

Las plantillas de ambos documentos están en [Plantillas de entrega](../plantillas/).

---

## Durante la sesión {#durante-la-sesion}

| Minutos | Qué pasa | Quién trabaja |
|---|---|---|
| 0 a 15 | El del turno expone su avance sobre el documento que subió | El del turno |
| 15 a 30 | El del turno explica el concepto que estudió, aplicado a su caso | El del turno |
| 30 a 55 | El panel interroga con sus dos papeles; el profesor corrige y profundiza | Panel y profesor |
| 55 a 80 | Se resuelve en Matlab la objeción más fuerte que quedó abierta | Los tres |
| 80 a 90 | Se dicta el siguiente encargo y queda escrito en `encargos.md` | Profesor |

En el bloque de 55 a 80 el panel no mira: aplica la misma técnica a su propio caso, aunque sea a
medias. De ahí sale buena parte de lo que después usa en su turno.

---

## Reglas duras {#reglas-duras}

**Para ocupar el banquillo hay que haber hecho push 48 horas antes.** Si no hay push, se pierde el
turno y no se repone: el siguiente llega hasta dentro de tres semanas. Los otros dos conservan su
papel de panel y la sesión se aprovecha con quien sí llegó preparado.

**Un avance sin la sección "Qué no me salió" está incompleto.** Reportar lo que falló no baja la
calificación. Esconderlo sí, porque convierte la sesión en una demostración de que todo va bien, que
es justo lo contrario de para lo que sirve una clínica.

**El panel que no hizo push de su revisión no participa en la discusión** y pierde ese punto. Opinar
sin haber leído y corrido el trabajo ajeno no cuenta como participación.

---

## El repositorio {#el-repositorio}

Todo el curso vive en un repositorio de git **privado** en el que los tres alumnos y el profesor son
colaboradores. Ahí se entrega todo: no hay entregas por correo ni por mensaje.

```
mim-actividades-<ciclo>/
  README.md                  <- reglas y calendario de turnos
  encargos.md                <- que se le encargo a quien, en que turno y con que fuente
  alumnos.csv                <- codigo, nombre y correo
  alumnos/
    <codigo>/
      ficha.md               <- su caso: fenomeno, pregunta, variable de diseno, objetivos
      bitacora.md            <- una entrada por turno
      manuscrito/            <- el articulo que crece todo el semestre
        main.tex
        referencias.bib
      avances/
        t04/
          avance.tex
          avance.pdf
          codigo/            <- los .m
          datos/             <- los .csv
          figuras/           <- las imagenes del avance
  revisiones/
    t04/
      revision-<codigo>.md
```

Su carpeta se llama con su **código de alumno**, no con su nombre.

**Regla de propiedad:** usted escribe solo dentro de `alumnos/<su codigo>/` y en sus propios archivos
de `revisiones/`. Los archivos de la raíz los mantiene el profesor. Haga `git pull` antes de cada
`git push` y no habrá conflictos, porque nadie más toca sus archivos.

Convención de mensajes de commit (`tNN` es el número de turno):

| Momento | Mensaje |
|---|---|
| Entrega del avance | `tNN avance: ...` |
| Entrega de la revisión | `tNN revision: ...` |
| Entrada de bitácora | `tNN bitacora: ...` |
| Trabajo sobre el manuscrito | `tNN manuscrito: ...` |

Las fechas de los commits son parte de la evidencia: muestran cuándo se trabajó, no solo qué se
entregó.

---

## La bitácora {#la-bitacora}

`bitacora.md` lleva una entrada por turno, con tres puntos mínimos:

- **Encargo recibido:** el concepto y la fuente
- **Decisiones:** qué eligió y por qué
- **Descartado:** qué probó que no funcionó, y por qué no funcionó

El tercero es el que después no se va a acordar cuando esté escribiendo su tesis, y es el que evita
repetir dos veces el mismo callejón sin salida.

---

## Evaluación {#evaluacion}

| Rubro del programa | Peso | Cómo se calcula |
|---|---|---|
| Tarea | 50% | Los 5 avances, 10% cada uno |
| Proyecto integrador | 40% | Manuscrito final (30%) y defensa (10%) |
| Participación y discusión | 10% | Las 10 revisiones de panel, 1% cada una |

### Cómo se califica un avance

| Criterio | Peso |
|---|---|
| Aplicación al caso propio, no en abstracto | 30% |
| Comprensión correcta del concepto encargado | 25% |
| Evidencia con el error cuantificado | 25% |
| Reproducibilidad: los scripts corren siguiendo lo que usted escribió | 10% |
| Redacción y honestidad del reporte | 10% |

### Cómo se califica una revisión de panel

Una revisión cuenta cuando trae las cuatro secciones de la plantilla y al menos una **objeción
sustantiva**: algo que el autor tenga que responder, no una corrección de redacción. Reportar que el
código no corre, con el error pegado, siempre cuenta.

### El manuscrito y la defensa

El proyecto integrador es un manuscrito corto tipo artículo, de 6 a 8 páginas en LaTeX, que crece
turno a turno y que al terminar el semestre debe poder convertirse en una sección de su tesis. La
defensa es una presentación de 15 minutos ante el grupo, con preguntas de los otros dos y del
profesor.

Los hitos por los que pasa el manuscrito están en [la ruta del proyecto](../ruta/).
