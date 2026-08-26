# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Materiales del curso **IM156 - Matemáticas Aplicadas al Modelado de Materiales**, del
**Doctorado en Ciencia e Ingeniería de Materiales**, CUCSUR UdeG.

**Profesor:** Karlos Espinoza (karlos.espinoza@academicos.udg.mx)
**Nivel:** posgrado (doctorado)
**Grupo:** 3 alumnos en el ciclo actual
**Software del alumno:** Matlab (licencia UdeG) + LaTeX (MikTeX) + VS Code + git, sobre Windows

Datos oficiales completos (créditos, horas, bibliografía, pesos de evaluación) en `programa.md`.
Ese archivo es la fuente de verdad institucional; si un material contradice al programa, gana el
programa.

---

## Comandos

Jekyll se sirve **desde la raíz del repositorio**, no desde este directorio:

```bash
cd /home/karlos/gh/karlosespinoza.github.io
make run     # jekyll serve + abre Chrome en http://127.0.0.1:4000/
make local   # jekyll serve --host 0.0.0.0 --livereload (sin abrir Chrome)
```

El curso queda en <http://127.0.0.1:4000/curso/mim/>.

Los scripts `.m` se ejecutan en Matlab, no hay build ni tests automatizados. Un `gen_*.m` o
`datos_*.m` se corre **antes** que su script de ajuste, porque el CSV que consume lo produce él.

---

## El modelo del curso: clínica de modelado, no cátedra

**No hay un tema por semana.** Cada alumno modela un fenómeno de su propia tesis y lo avanza durante
el semestre. Las sesiones son clínicas: en cada turno un alumno pasa al banquillo con su avance y
los otros dos son el panel que lo revisa, con dos papeles nombrados (abogado de los supuestos,
abogado de los datos). Con 3 alumnos, cada quien pasa 5 veces al banquillo y 10 al panel.

Consecuencias para cualquier material que se genere aquí:

- **No crear `semana-NN/` ni `sesion-NN/`.** Este curso no se organiza por semana, a diferencia de
  `curso/ia/` y `curso/so/`. Un intento de reestructurarlo así ya se descartó.
- **El profesor no da clase magistral.** Al cierre de cada turno dicta un *encargo* (concepto,
  fuente exacta con capítulo y sección, pregunta que debe poder responder, evidencia esperada) y el
  alumno lo estudia solo. En su siguiente turno **el alumno explica el concepto**, no el profesor.
- **El contenido llega bajo demanda**, cuando el proyecto de alguien lo pide.

### Nunca describir la modalidad ni la cadencia de las sesiones

En ningún archivo visible al alumno se escribe si las sesiones son presenciales o virtuales, cuántas
hay por semana, ni qué día son. Se escribe siempre **"la sesión"** o **"el turno"**. Hay un acuerdo
interno sobre la cadencia que no se documenta en el repositorio, que es público. `programa.md`
declara la modalidad institucional y con eso basta.

---

## Estructura

```
curso/mim/
  index.md                 <- indice: programa, como funciona, requisitos, biblioteca de fichas
  programa.md              <- programa institucional completo (fuente de verdad)
  tutoria/index.md         <- la clinica: papeles, encargo, tiempos de push, reglas duras, evaluacion
  ruta/index.md            <- los 5 hitos por los que pasa todo proyecto
  encuadre/index.md        <- sesion de arranque: ficha de admision, reencuadre de temas, alta en git
  plantillas/
    index.md               <- explica cada plantilla
    ficha.md               <- ficha de admision del caso (4 casillas)
    avance.tex             <- plantilla LaTeX del avance (7 secciones fijas)
    revision.md            <- plantilla de la revision del panel (4 secciones)
    encargos.md            <- registro de encargos + matriz de cobertura del programa (profesor)
    alumnos_ejemplo.csv    <- solo el encabezado; los datos reales NO van aqui
    README_repositorio.md  <- README semilla del repositorio privado del curso
  matlab.md                <- requisito: instalacion y uso de Matlab
  latex/index.md           <- requisito: instalacion y uso de LaTeX
  latex/ejemplo_latex/     <- plantilla minima main.tex/main.pdf
  modelo_teorico/          <- biblioteca de fichas de la Unidad 1
    <tema>/index.md
  prompt_tema.md           <- prompt generador de una ficha completa
  prompt_gamificacion.md   <- prompt de seguimiento (heredado del modelo anterior)
  prompt_tarea.md          <- prompt de seguimiento (heredado del modelo anterior)
  temp.md                  <- borrador crudo (ver "Trampas conocidas")
```

### El repositorio privado del curso (no es este)

El trabajo de los alumnos vive en repositorios de git **privados y aparte**, con los alumnos y
Karlos como colaboradores. Su estructura y sus reglas están en `tutoria/index.md` y en
`plantillas/README_repositorio.md`. Lo que hay aquí son las **semillas** que se copian allá.

| Repositorio | Qué es |
|---|---|
| `KarlosEspinoza/mim-actividades` | Privado y marcado como **template repository**. Es la plantilla base: README, `encargos.md`, `alumnos.csv` vacío y `plantillas/`. No lleva trabajo de alumnos. |
| `KarlosEspinoza/mim-actividades-202620` | El repositorio del ciclo 202620, creado desde la plantilla. Aquí trabajan los 3 alumnos. |

Cada ciclo nuevo se crea **desde la plantilla**, no como fork:

```bash
gh repo create KarlosEspinoza/mim-actividades-<ciclo> --private \
  --template KarlosEspinoza/mim-actividades
```

Se usa template y no fork a propósito: un fork arrastra el historial del repositorio padre, así que
el ciclo nuevo cargaría con el trabajo del grupo anterior. Con template cada ciclo arranca limpio y
los grupos quedan aislados entre sí. Las mejoras a la plantilla se hacen en `mim-actividades` y se
aplican al siguiente ciclo.

Clones locales: `/home/karlos/gh/mim-actividades` y `/home/karlos/gh/mim-actividades-202620`.

**Las carpetas de alumno se nombran con el código de alumno, no con el apellido.** El único archivo
que liga código con nombre y correo es `alumnos.csv`, y ese archivo **solo existe en el repositorio
privado**. Aquí vive únicamente `plantillas/alumnos_ejemplo.csv`, con el encabezado y nada más.

El `.gitignore` de la raíz bloquea `**/alumnos.csv` sin excepciones: en este repositorio, que es
público, un archivo con ese nombre no se puede commitear ni por accidente. Por eso la plantilla se
llama distinto. No agregar una negación al `.gitignore` para "arreglarlo".

---

## La biblioteca de fichas

`modelo_teorico/<tema>/index.md` **ya no es un temario**: es una biblioteca de referencia que se
consulta cuando un encargo la pide. `index.md` lista los 14 temas del programa y solo los que tienen
ficha escrita llevan enlace.

Con autoaprendizaje, **no hay que escribir una ficha por concepto**. Se escribe ficha solo cuando la
fuente bibliográfica es mala o cuando el mismo concepto le toca a un segundo alumno. La biblioteca
crece semestre a semestre.

### Anatomía de una ficha

Las tres fichas existentes siguen la estructura que pide `prompt_tema.md`. Al escribir una nueva,
tomar la más reciente como plantilla:

1. `# <Título>`
2. `## Objetivo` -- en términos de lo que el estudiante hará
3. `## Método de enseñanza`
4. `## Criterios de evaluación` -- tabla Criterio / Descripción / Peso, suma 100%
5. `# Desarrollo del tema`: `## Caso ejemplo` (prosa de ~700 caracteres, siempre sobre ingeniería de
   materiales), `## Conceptos/Modelos` (explicación + ecuación + prosa de cómo se relaciona con el
   caso), `## Ejercicio en clase` con los scripts Matlab completos
6. `# Tarea`
7. `# Actividad de gamificación`

Las secciones 6 y 7 son herencia del modelo anterior de cátedra y **no aplican al modelo de
clínica**: la tarea real del alumno es su avance, y la gamificación quedó sustituida por los papeles
del panel. Al escribir una ficha nueva se pueden omitir; al tocar una vieja, no hace falta quitarlas.

### Archivos que acompañan a una ficha

| Archivo | Qué es |
|---|---|
| `index.md` | La ficha |
| `gen_*.m` / `datos_*.m` | Genera el CSV del experimento sintético |
| `ajuste_*.m` / `simulacion_*.m` | Ajuste, métricas y gráficas sobre ese CSV |
| `*.csv` | Salida ya generada |
| `notas_ejercicio.md` | Análisis para el profesor |
| `notas_gamificacion.md` | Guía del profesor (heredado del modelo anterior) |

**Los `.m` están duplicados dentro de `index.md`** en bloques ` ```matlab `, y las páginas no
enlazan a los archivos. Al corregir un script hay que tocar **los dos lados** o se desincronizan
(ya pasó: `simulacion_ejercicio.m` conserva en su cabecera el nombre viejo
`ejercicio_evaluar_modelo.m`).

### Patrón de los ejercicios: experimento sintético

Nunca se usan datos genéricos. Es también la salida para el alumno que aún no tiene datos de
laboratorio:

1. Un script genera un CSV que **simula un experimento real**: ground truth de un modelo conocido
   + ruido gaussiano + deriva, con `rng(<semilla>)` para que sea reproducible.
2. Otro script propone o ajusta el modelo sobre ese CSV y **cuantifica el error** (MAE, RMSE,
   MAPE, R²), grafica datos vs modelo y guarda un CSV de resumen.
3. La discusión apunta a la trampa del ejercicio (ej. en `modelo_matematico`: cómo R² puede ser casi
   1 con un error enorme).

Al ajustar por mínimos cuadrados no lineales se usa `lsqnonlin` (Optimization Toolbox); **dar
siempre la alternativa con `fminsearch`**, porque no todos los alumnos tienen la toolbox.

---

## Evaluación

Los pesos son los del programa y no se cambian. El mapeo al modelo de clínica es:

| Rubro del programa | Peso | Qué lo instrumenta |
|---|---|---|
| Tarea | 50% | Los 5 avances de cada alumno, 10% cada uno |
| Proyecto integrador | 40% | Manuscrito final (30%) y defensa (10%) |
| Participación y discusión | 10% | Las 10 revisiones de panel, 1% cada una |

El manuscrito es un artículo corto de 6 a 8 páginas en LaTeX que crece turno a turno y que debe
poder convertirse en una sección de la tesis del alumno. Esa es la palanca de motivación real en
doctorado, no la calificación.

---

## Convenciones de contenido

- **Frontmatter en toda página**, con el mismo `title` en todas (es el nombre del curso):
  ```yaml
  ---
  layout: default
  title: Matemáticas para Ingeniería de Materiales
  ---
  ```
- **Enlace de regreso relativo** justo después del frontmatter, según la profundidad del archivo:
  `[Inicio](index)` en `matlab.md`, `[Inicio](../index)` en `tutoria/index.md` y en las `notas_*.md`,
  `[Inicio](../../index)` en el `index.md` de una ficha. (En `curso/ia/` el enlace es absoluto; aquí
  no.)
- **Las plantillas no llevan frontmatter** a propósito: Jekyll las copia tal cual y quedan
  descargables desde `plantillas/index.md`.
- **Ecuaciones con MathJax:** `$` inline, `$$` en bloque. Cada ecuación lleva **debajo la lista de
  sus variables con unidades**.
- **Sin caracteres especiales** que no se escriban con teclado normal en archivos que ve el alumno:
  nada de `—`, `←`, `→`, `–`, ni emoji. Usar `->`, `<-`, `--`, `:` o reformular. Las páginas viejas
  (`notas_*.md`, algunos temas) todavía los tienen; no se propagan a material nuevo.
- Diagramas con Mermaid (plugin `jekyll-mermaid`) cuando ayuden a explicar un concepto.

---

## Trampas conocidas

- **`programa.md` quedó desalineado.** Su sección "Planeación" todavía habla de 10 sesiones
  repartidas en tres unidades (1-3, 4-7, 8-10), que era el diseño de cátedra. El curso ya no
  funciona así. Es un documento institucional ya elaborado, así que **no se toca sin que Karlos lo
  decida**: hay que preguntarle antes de editarlo.
- **`temp.md` es un volcado crudo de chat**, sin frontmatter y con LaTeX roto (`[ ... ]` en vez de
  `$$`). Al no tener frontmatter, Jekyll **lo copia tal cual y queda publicado** en
  `/curso/mim/temp.md`. No es material del curso; es el borrador del que salió la ficha
  `modelo_matematico`. Si se limpia el directorio, empezar por ahí.
- **`_config.yml` de la raíz excluye** `CLAUDE.md` y `**/prompt_*.md` del sitio publicado, pero el
  repositorio es público: lo excluido no se sirve, se sigue leyendo en GitHub. **Nada de datos
  personales de alumnos aquí**, ni siquiera en archivos excluidos.
- **`prompt_tema.md` trae valores de otro curso**: su `ULTIMO_TEMA` apunta a
  `ans_preparacion_reduccion.md`, que no existe en `mim`. Al usarlo, sustituir `TEMA` y
  `ULTIMO_TEMA` por el tema real y por el `index.md` de la ficha más reciente.
- `latex/index.md` cierra su enlace de descarga de VS Code con `[aquí]()` vacío.
- `latex/index.md` y `matlab.md` usan `[Inicio](index)`; en `latex/index.md` eso apunta a sí mismo,
  debería ser `[Inicio](../index)`.
