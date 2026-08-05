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

## Contenido temático y estado de archivos

```
curso/ia/
  index.md                               <- Índice del curso
  programa/index.md                      <- Programa institucional completo
  template.md                            <- Plantilla base para nuevas páginas
  todo.md                                <- Notas de desarrollo del curso
  proyecto/index.md                      <- Proyecto final (rúbrica completa)

  U1 - Introducción (semanas 1-2):
  conceptos_flujo_ml/index.md            <- U1.1: Flujo del ML ⚠️ revisar (agregar bucle de control y caso)
  bucle_control_inteligente/             <- U1.2: Sensor -> modelo -> actuador ❌ pendiente
  interfaces_io/                         <- U1.3-1.4: Arduino y PLC como interfaces ❌ pendiente

  U2 - Aprendizaje Supervisado (semanas 3-8):
  aprendizaje_supervisado/
    conceptos/index.md                   <- U2.1: Concepto y aplicaciones ✅
    adquisicion_datos/                   <- U2.2: Adquisición y limpieza de datos de sensores ❌ pendiente
    preparacion_limpieza_datos/          <- (base anterior de U2.2) ⚠️ reemplazar con contexto de sensores
    ingenieria_caracteristicas/          <- U2.3a: Features dominio del tiempo ⚠️ revisar (agregar FFT)
    features_frecuencia/                 <- U2.3b: FFT y densidad espectral de potencia ❌ pendiente
    modelos_supervisados/                <- U2.4: Clasificador + primer bucle de control con Arduino ⚠️ revisar
    redes_neuronales/                    <- U2.5: Redes neuronales para señales ✅

  U3 - Aprendizaje No Supervisado (semanas 10-13):
  aprendizaje_no_supervisado/
    conceptos/index.md                   <- U3.1: Concepto y aplicaciones ✅
    preparacion_reduccion/index.md       <- U3.2: Preparación y PCA ✅
    tecnicas_principales/index.md        <- U3.3: K-Means, DBSCAN, PCA ✅
    autoencoders/                        <- U3.4: Autoencoders para anomalías ❌ pendiente
    anomalias_control/                   <- U3.5: Anomalías como señal de control ❌ pendiente

  U4 - Evaluación y Despliegue en PLC (semanas 15-17):
  evaluacion_modelo/
    metricas/index.md                    <- U4.1: Métricas ✅
    validacion_cruzada/index.md          <- U4.2: Validación cruzada ✅
    hiperparametros/                     <- U4.3: Selección de hiperparámetros ❌ pendiente
    sobreajuste_subajuste/               <- U4.4: Sobreajuste y subajuste ❌ pendiente
    despliegue_plc/                      <- U4.5-4.6: Despliegue en PLC S7-1214C ❌ pendiente
    panorama_frontera/                   <- U4.7: Physical AI, RL en robótica ❌ pendiente
```

---

## Estructura de cada tema (patrón establecido)

Cada subdirectorio de tema contiene:
- `index.md` — actividad de clase (90 min): objetivo, atributos egreso, método, criterios, desarrollo con código Python anclado al caso del semestre
- `practica.md` — práctica de laboratorio
- `*_gam.md` + `*_datos.csv` — actividad de gamificación (5–10 min)
- `*_extra.md` — actividad extra para casa (40 min, vale 0.1 pts sobre calificación final)

Los temas de U2 incluyen además código de adquisición de datos desde el Arduino (pyserial).  
Los temas de U4 (despliegue) incluyen código de comunicación con el PLC (python-snap7).

---

## Prompts de generación de materiales

| Archivo | Uso |
|---|---|
| `prompt_tema.md` | Generar actividad de clase (90 min) con código Python anclado al caso del semestre |
| `prompt_gam.md` | Generar actividad de gamificación (5–10 min) |
| `prompt_extra.md` | Generar actividad extra para casa (40 min) |
| `prompt_circ.md` | Generar conexiones de circuitos en KiCad |

---

## Convenciones de contenido

- Los ejemplos siempre usan el **caso del semestre** (clasificador de piezas sobre banda transportadora); no se inventan contextos nuevos por tema
- Los datos de los ejemplos son **señales de sensores físicos** (series de tiempo), no tablas genéricas
- Los ejercicios de código son **incompletos a propósito**: el pseudocódigo de lo ya visto (leer CSV, graficar, etc.) lo completan los alumnos; solo el fragmento nuevo del tema del día está listo
- Las ecuaciones se documentan con sus variables debajo de la fórmula
- El **frontmatter** de cada página incluye `layout: default` y `title`
- Cada subpágina lleva `[Inicio](/curso/ia)` al principio
- En los archivos visibles al alumno **no usar caracteres especiales** que no se puedan escribir con teclado normal: prohibidos `—`, `←`, `→`, `⬛` y similares; usar `->`, `<-`, `:` o reformular
