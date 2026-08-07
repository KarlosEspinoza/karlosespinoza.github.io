# CLAUDE.md — Curso IE043: Inteligencia Artificial

Materiales del curso de Inteligencia Artificial para Ingeniería Mecatrónica,
7mo semestre, CUCSUR UdeG.

**Instructor:** Karlos Espinoza (karlos.espinoza@academicos.udg.mx)
**Horario:** Lunes y Miércoles 9:00–11:00 hrs (sesiones 120 min; actividades: 90 min)
**Metodologías:** ABP, Aula Invertida, Gamificación, Aprendizaje Colaborativo, Aprendizaje Experiencial

---

## Hardware disponible en clase

- **Microcontrolador:** Arduino Nano
- **Sensores:** LM35, HC-SR04, LDR, A3144, HW-870, GP2Y0A21YK0F
- **Actuadores:** Servomotor, Motor CD, Buzzer, LED, LED RGB, Válvula, Relé

### Hardware de laboratorio (fase de producción)

- **PLC:** Siemens S7-1214C, dirección IP 192.168.0.1, comunicación vía python-snap7
- **PC de control:** 192.168.0.10, conectada por Ethernet directo al PLC
- **Maquetas:** dos celdas con bandas transportadoras, pistones, sensores capacitivos e inductivos
- **Celda 1:** contador de vueltas de cadena, sensor inductivo, sensor en banda, motor de torre, motor de banda
- **Celda 2:** motor de banda, sensor de pistón, sensor de caja desplazada
- **Piezas:** bloques de madera con tachuelas (detectadas por sensor inductivo) o imanes (detectados por A3144)

---

## Atributos de Egreso trabajados

- **AE2A:** Diseñar e implementar sistemas en automatización, control, robótica y sistemas embebidos mediante proyectos integradores.
- **AE7A:** Favorecer el trabajo colaborativo y el liderazgo en equipos multidisciplinarios.

---

## Evaluación

| Rubro | Peso |
|---|---|
| Proyecto integrador (equipo) | 35% |
| Prácticas | 35% |
| Actividades integradoras | 5% |
| Asistencia | 5% |
| Proyecto final de carrera | 20% |

Las **actividades integradoras** las reporta la coordinación de la carrera (jornadas, eventos académicos y actividades transversales del PE). El **proyecto final de carrera** (20%) lo evalúa el comité valuador; la calificación la entrega dicho comité al asesor al cierre del semestre.

**Instrumentos de revisión de avances (proyecto individual):**

| Instrumento | Peso dentro del proyecto |
|---|---|
| Evidencias (código en GitHub, datasets, modelos, demo del bucle de control) | 50% |
| BITACORA.md con explicación de conceptos de ML aplicados | 30% |
| 2 preguntas (orales o escritas) el día de la revisión | 20% |

En el **proyecto integrador** se agrega autoevaluación entre pares y los pesos quedan: Evidencias 45%, BITACORA.md 25%, Preguntas 20%, Autoevaluación entre pares 10%.

**Sesiones de revisión de avances (miércoles presencial):**
- Revisión 1: semana 9 — cierre U1 y U2
- Revisión 2: semana 14 — cierre U3
- Revisión final: semana 17 — demo del bucle de control en maqueta con PLC

---

## Regla principal: Aprendizaje por proyecto progresivo

> **Cada clase y cada tema debe aportar directamente al proyecto individual y al proyecto integrador del alumno. Los ejemplos de clase son fragmentos funcionales del proyecto, no ejercicios aislados.**

### El caso único del curso: Sistema clasificador de piezas sobre banda transportadora

Existe **un solo sistema que se construye durante todo el semestre**: un clasificador que lee señales de sensores, toma una decisión con un modelo de ML y actúa sobre actuadores para enrutar piezas en una banda transportadora.

Es el mismo tipo de sistema que opera en líneas de manufactura y clasificación industrial. Todos los conceptos del ML encajan de forma natural y obligada — no forzada.

| Unidad | Lo que se agrega al sistema | Por qué ese tema aparece naturalmente |
|---|---|---|
| **U1** – Introducción | El sistema existe. Leemos sensores con Arduino y visualizamos la señal en Python. | Antes de entrenar un modelo hay que entender de dónde vienen los datos |
| **U2** – Supervisado | Etiquetamos las piezas. Extraemos features (tiempo y frecuencia). Entrenamos el clasificador. El Arduino actúa según la decisión del modelo. | El bloque debe ser clasificado para ser enrutado correctamente en la banda |
| **U3** – No supervisado | Sin etiquetas, buscamos patrones. Detectamos piezas anómalas con autoencoder. La anomalía dispara una acción de control. | La línea puede recibir piezas desconocidas o defectuosas que no estaban en el entrenamiento |
| **U4** – Evaluación y despliegue | Validamos el modelo. Lo desplegamos en la maqueta real vía PLC S7-1214C. El modelo controla la banda y el pistón. | El mismo clasificador, ahora corriendo en producción sobre hardware industrial |

**Progresión visible semana a semana:**

```
Semana 1-2  → Arduino conectado a Python; primera señal de sensor visualizada en tiempo real
Semana 3-4  → Dataset etiquetado de los tres tipos de pieza guardado en CSV
Semana 5-6  → Features de tiempo y frecuencia (FFT) extraídas sobre las señales
Semana 7-8  → Clasificador entrenado; primer bucle de control completo con Arduino
Semana 9    → Revisión 1
Semana 10-11 → Clustering sin etiquetas; PCA del dataset del clasificador
Semana 12-13 → Autoencoder entrenado; anomalías integradas al bucle de control
Semana 14   → Revisión 2
Semana 15-16 → Modelo validado y exportado; prueba de conexión con PLC S7-1214C
Semana 17   → Revisión final: demo del bucle completo sobre la maqueta con PLC
```

Al final del semestre el sistema es un clasificador funcional end-to-end:
sensores → Python → modelo → PLC → actuadores.

**El proyecto individual** es ese mismo sistema, cada alumno con su propio dominio de clasificación (materiales, tamaños, estados de una máquina, etc.).  
**El proyecto integrador** es una versión más completa desarrollada en equipo, desplegada sobre las maquetas del laboratorio con PLC.

### La banda de la maqueta: acceso diferido y dos etapas de datos

La banda transportadora de la maqueta del laboratorio **no se ha usado todavía** y no está
disponible como herramienta de práctica semanal: es una sola y no es realista que todo el grupo
trabaje sobre ella cada semana. Esto **no cambia el caso central** (el sistema sigue siendo el
clasificador de piezas sobre banda transportadora), solo cambia con qué se practica.

**Etapa 1 (semanas 2 a ~14): sin banda.** El alumno monta su sensor en protoboard y **simula el
paso moviendo la pieza a mano** sobre una superficie frente al sensor. Para el ML basta con que
la pieza genere una ventana de señal al pasar; qué la mueve es irrelevante para el modelo. Toda
la práctica de clase se hace así.

**Etapa 2 (cuando el curso lo exija, U4): con banda.** Cada alumno va **por su cuenta a la
maqueta del laboratorio a capturar sus datos buenos** sobre la banda real. En clase se practica
el concepto; los datos definitivos salen de la maqueta. Karlos los lleva primero en una sesión
para explicar cómo se usa (sugerido: semana 15, con una visita corta previa en la 9 o la 14) y
después cada quien agenda su captura.

Consecuencias que hay que escribir en los materiales, no ocultar:

- **Semana 3 (recolección):** mover la pieza a mano hace que la velocidad varíe entre pasadas, y
  eso es **fuga de información** si el alumno mueve un tipo de pieza más rápido que otro: el
  modelo aprende su mano, no la pieza. Regla de protocolo explícita: velocidad pareja, orden
  alternado entre tipos, y nota en `BITACORA.md` de cómo lo controlaron.
- **Semanas 4 y 5:** la variabilidad de duración y amplitud entre pasadas es justo lo que
  resuelven la normalización y las features. Llega sola, aprovecharla.
- **Semanas 15 y 16 (U4):** en la banda la velocidad es constante y distinta a la de la mano. Ese
  desajuste entre datos de entrenamiento y datos de producción es **el ejemplo central de la
  Unidad 4**: "tu modelo funciona en tu escritorio, por qué falla en la maqueta".

En el texto visible al alumno, hasta la U4 la pieza **"pasa frente al sensor"**, no "avanza sobre
la banda". La banda física se nombra al hablar del sistema final y de la fase de producción.

### Cómo aplicarlo al generar materiales

- **Un solo caso central**: todos los ejemplos de código de todas las clases pertenecen al mismo sistema. No se inventa un nuevo contexto por tema.
- El alumno no parte de cero en su proyecto: **adapta y extiende lo que ya construimos juntos en clase**.
- Los temas se presentan en el **orden en que se necesitan en el proyecto**, no solo en el orden del temario oficial.
- Cada unidad **agrega una capa de funcionalidad** al caso central.
- Las actividades del lunes preparan el concepto; las del miércoles lo aplican sobre el caso central.

### Implicaciones para el diseño de cada clase

1. **Conectar con el proyecto desde el inicio**: "Hoy vamos a agregar X a nuestro clasificador."
2. **El código de ejemplo es incompleto a propósito** en las partes que el alumno ya sabe (leer CSV, graficar, etc.); solo se deja listo el fragmento nuevo del tema del día.
3. **El cierre de cada sesión** indica explícitamente qué debe cambiar/agregar el alumno en su proyecto antes de la siguiente clase.
4. **BITACORA.md del alumno** debe crecer con cada tema: el alumno explica con sus palabras cómo aplicó el concepto en su proyecto y hace `git push` de esa entrada junto con el código.

---

## Stack tecnológico del curso

- **Prototipo:** Arduino Nano + sensores low-cost + pyserial
- **Producción:** Siemens S7-1214C + python-snap7 (PUT/GET habilitado en el PLC)
- **Lenguaje:** Python (ya conocido de cursos previos)
- **Editor:** Visual Studio Code
- **Control de versiones:** Git + GitHub (un repositorio por alumno, crece semana a semana)
- **Documentación del proyecto:** BITACORA.md en el mismo repositorio — no se usa Google Docs
- **Plataforma:** Google Classroom (el alumno entrega solo la URL de su repo, una sola vez)

---

## Organización del curso: por semana, no por tema

El curso está organizado **por semana**, igual que `curso/so/`. La semana es la unidad de
navegación, de seguimiento y de entrega. No hay directorios por tema.

Esto sustituye a la organización anterior por tema. **El material viejo (`conceptos_flujo_ml/`,
`aprendizaje_supervisado/`, `aprendizaje_no_supervisado/`, `evaluacion_modelo/`) ya no se usa
y no se enlaza desde el índice.** Se conserva en el repositorio solo como referencia: al
desarrollar una semana se puede rescatar de ahí lo que sirva (ecuaciones, ejemplos, código,
gamificaciones), reescribiéndolo para el caso del semestre y el proyecto progresivo.

```
curso/ia/
  index.md                        <- Índice del curso: lista de 17 semanas
  programa/index.md               <- Programa institucional completo
  programa/bibliografia.csv       <- Bibliografía en CSV
  requisitos/index.md             <- Configuración del entorno
  CLAUDE.md                       <- Este archivo
  evaluacion/
    individual/index.md           <- Prácticas (proyecto individual) ⚠️ pendiente rediseñar al esquema nuevo
    proyecto_integrador/index.md  <- Proyecto integrador (clasificador multi-dominio)

  semana-01/index.md ... semana-17/index.md

  (material viejo, solo referencia, sin enlazar)
  conceptos_flujo_ml/  aprendizaje_supervisado/  aprendizaje_no_supervisado/
  evaluacion_modelo/  proyecto/  todo.md  template.md
  prompt_tema.md  prompt_gam.md  prompt_extra.md  prompt_circ.md
```

### Estado de las semanas

| Semana | Tema | Estado |
|---|---|---|
| 01 | Encuadre y configuración del entorno | ✅ desarrollada |
| 02 | La primera señal del sensor (U1) | ✅ desarrollada |
| 03 | Recolección de datos etiquetados (U2) | ⬜ esqueleto |
| 04 | Limpieza y normalización de señales (U2) | ⬜ esqueleto |
| 05 | Características en el dominio del tiempo (U2) | ⬜ esqueleto |
| 06 | Características en el dominio de la frecuencia (U2) | ⬜ esqueleto |
| 07 | Entrenamiento del clasificador (U2) | ⬜ esqueleto |
| 08 | Redes neuronales y primer bucle de control (U2) | ⬜ esqueleto |
| 09 | Revisión de avances 1 | ✅ completa |
| 10 | Aprendizaje no supervisado y PCA (U3) | ⬜ esqueleto |
| 11 | Agrupamiento: K-Means y DBSCAN (U3) | ⬜ esqueleto |
| 12 | Autoencoders para detección de anomalías (U3) | ⬜ esqueleto |
| 13 | La anomalía como señal de control (U3) | ⬜ esqueleto |
| 14 | Revisión de avances 2 | ✅ completa |
| 15 | Evaluación del modelo (U4) | ⬜ esqueleto |
| 16 | Sobreajuste y preparación para producción (U4) | ⬜ esqueleto |
| 17 | Revisión final | ✅ completa |

---

## Estructura de cada semana (patrón establecido)

`semana-NN/index.md` tiene siempre las mismas tres secciones:

- `## Antes de la clase (aprendizaje invertido)` — la guía que el alumno trabaja antes de la sesión
- `## Durante la clase (aprendizaje activo)` — lo que se hace en clase sobre el caso central
- `## Avance de tu proyecto esta semana` — lo que el alumno agrega a su proyecto, con nombres de archivo concretos, y siempre cierra con la entrada de `BITACORA.md` y el push

Las semanas de revisión (09, 14, 17) usan una variante:

- `## Antes de la clase (entrega previa)` — con la lista de "Tu sistema debe:"
- `## Durante la clase (revisión)`
- `## Lo que se evalúa`

Cuando la semana se desarrolla a fondo (como la 01), se antepone una introducción que conecta
con el proyecto, y las secciones se expanden con teoría explicada desde cero, código y tablas.
Además, toda semana desarrollada lleva un **índice** después de la introducción, con el formato de
`programa/index.md` (lista de enlaces entre dos `---`) y **anclas explícitas `{#id}`** en cada
encabezado, porque kramdown se come los acentos al generar los ids solos.

### La sesión del lunes: estructura de bloques

`## Antes de la clase` es una **guía de trabajo, no una lectura**. Se trabaja durante la sesión del
lunes (2 horas) y se parte siempre así:

- `### Cómo se trabaja esta guía` — tabla de bloques y la nota de "si te atoras, escríbelo y haz
  commit igual"
- `### Bloque 1: <nombre>` — obligatorio
- `### Bloque 2: <nombre>` — obligatorio
- `### Bloque extra: <nombre>` — opcional

Reglas de diseño de los bloques:

- **Dos bloques obligatorios de ~30 min de contenido cada uno.** El grupo es flojo y de nivel bajo:
  30 min de contenido les toma cerca de una hora real. Ese es el criterio de calibración, no
  "cuánto cabe en dos horas".
- **Cada bloque cierra con un entregable concreto** bajo `**Lo que entregas de este bloque**`, más
  su bloque `bash` con `git add / commit / push`. Un commit por bloque, nunca uno solo al final:
  las horas de los commits son lo que deja ver si trabajaron la sesión completa.
- **El entregable no se puede improvisar ni copiar**: se apoya en que cada alumno tiene un dominio
  distinto (justificaciones, números medidos de su propio caso, tres líneas de ejemplo de su
  sensor). Vale como entregado aunque esté mal; lo que no vale es no dejar rastro.
- **El bloque extra nunca es requisito de nada**: el miércoles debe poder arrancar solo con los
  bloques 1 y 2. Es para los 2 o 3 alumnos fuertes, y se paga solo en las evidencias de su
  revisión (50%), sin puntos aparte.
- **Sin hardware.** El Arduino y los sensores están en el aula, así que los bloques del lunes se
  resuelven leyendo, escribiendo código y decidiendo. El hardware se conecta el miércoles.
- **El miércoles arranca donde terminó el lunes** ("llegas con X ya escrito del lunes"). Ese es el
  mecanismo real de cumplimiento: no hacerlo tiene costo visible el mismo miércoles.

La asistencia del lunes se registra con los commits de los bloques. **Eso no se escribe en el
programa**; se comunica en el encuadre y en Classroom con redacción neutra ("la asistencia del
lunes se registra con el commit de la actividad de la sesión"). En ningún material visible se dice
que la sesión del lunes es a distancia; se escribe siempre como "durante la sesión".

### Organización del repositorio del alumno

Definida en `semana-01` y fija para todo el semestre:

```
clasificador-piezas-ia/
  README.md      <- quien es y que clasifica su sistema
  BITACORA.md    <- una seccion por semana
  codigo/        <- sensor.ino, leer_sensor.py, adquirir.py, ...
  datos/         <- datos.csv, features.csv, ...
  figuras/       <- senal.png, ...
```

`BITACORA.md` lleva una sección por semana con **dos subsecciones fijas**: `### Antes de la clase`
(entregables de los bloques del lunes) y `### Avance del proyecto` (lo del miércoles en adelante).
Eso es lo que permite distinguir de un vistazo el trabajo de la guía del trabajo del proyecto.

Convención de mensajes de commit (`sNN` = número de semana):

| Momento | Mensaje |
|---|---|
| Fin del bloque 1 | `sNN bloque 1: ...` |
| Fin del bloque 2 | `sNN bloque 2: ...` |
| Bloque extra | `sNN extra: ...` |
| Avance del proyecto | `sNN proyecto: ...` |

### Archivos del proyecto del alumno (progresión)

Los nombres de archivo se mantienen consistentes entre semanas para que el proyecto crezca de
forma acumulable:

| Semana | Archivos que agrega o modifica |
|---|---|
| 02 | `codigo/sensor.ino`, `codigo/leer_sensor.py` |
| 03 | `adquirir.py` -> `datos.csv` |
| 04 | `limpiar.py` -> `datos_limpios.csv` |
| 05 | `features.py` -> `features.csv` |
| 06 | `features.py` (agrega FFT) |
| 07 | `entrenar.py` -> `modelo.pkl` |
| 08 | `control.py`, `control.ino` |
| 10 | `pca.py` |
| 11 | `clustering.py` |
| 12 | `autoencoder.py` |
| 13 | `control.py` (integra anomalías) |
| 15 | `evaluar.py` |
| 16 | `prueba_plc.py` |

---

## Prompts de generación de materiales

Los prompts `prompt_tema.md`, `prompt_gam.md`, `prompt_extra.md` y `prompt_circ.md` fueron
escritos para la organización por tema y **ya no aplican tal cual**. Sirven como referencia
(`prompt_circ.md` sigue siendo útil para circuitos en KiCad).

---

## Convenciones de contenido

- Los ejemplos siempre usan el **caso del semestre** (clasificador de piezas sobre banda transportadora); no se inventan contextos nuevos por tema
- Los datos de los ejemplos son **señales de sensores físicos** (series de tiempo), no tablas genéricas
- Los ejercicios de código son **incompletos a propósito**: el pseudocódigo de lo ya visto (leer CSV, graficar, etc.) lo completan los alumnos; solo el fragmento nuevo del tema del día está listo
- Las ecuaciones se documentan con sus variables debajo de la fórmula
- El **frontmatter** de cada página incluye `layout: default` y `title`
- Cada subpágina lleva `[Inicio](/curso/ia)` al principio
- En los archivos visibles al alumno **no usar caracteres especiales** que no se puedan escribir con teclado normal: prohibidos `—`, `←`, `→`, `⬛` y similares; usar `->`, `<-`, `:` o reformular
