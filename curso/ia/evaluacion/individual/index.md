---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Prácticas: tu proyecto individual

**Ingeniería Mecatrónica, séptimo semestre**
**Valor: 35% de la calificación final**

Las prácticas de este curso no son ejercicios sueltos. Son **un solo sistema que construyes durante todo el semestre**, una capa por semana, y que se evalúa en tres revisiones de avances.

---

- [Qué construyes](#que-construyes)
- [Tu dominio](#tu-dominio)
- [Cómo se entrega](#como-se-entrega)
    - [El repositorio](#el-repositorio)
    - [BITACORA.md](#bitacora)
    - [Los commits](#los-commits)
- [Lo que agregas cada semana](#cada-semana)
- [Las tres revisiones de avances](#revisiones)
    - [Revisión 1: semana 9](#revision-1)
    - [Revisión 2: semana 14](#revision-2)
    - [Revisión final: semana 17](#revision-final)
- [Calificación](#calificacion)
- [Atributos de egreso](#atributos)

---

## Qué construyes {#que-construyes}

Un **clasificador de piezas sobre banda transportadora**: un sistema que lee la señal de un sensor mientras una pieza pasa, decide con un modelo de aprendizaje de máquina de qué tipo es, y acciona un actuador para enrutarla.

Es el mismo sistema de principio a fin. Cada unidad del curso le agrega una capa:

| Unidad | Lo que le agregas | Semanas |
|---|---|---|
| U1 Introducción | El sistema existe: lees tu sensor desde Python y ves la señal. | 1 y 2 |
| U2 Supervisado | Etiquetas las piezas, extraes características, entrenas el clasificador y cierras el bucle de control con el Arduino. | 3 a 8 |
| U3 No supervisado | Buscas patrones sin etiquetas y detectas piezas anómalas que nadie te enseñó. La anomalía dispara una acción. | 10 a 13 |
| U4 Evaluación y despliegue | Validas el modelo con métricas honestas y lo despliegas sobre la maqueta del laboratorio a través del PLC. | 15 y 16 |

Al final del semestre tu sistema es un clasificador funcional de extremo a extremo: **sensores -> Python -> modelo -> PLC -> actuadores**.

---

## Tu dominio {#tu-dominio}

Cada quien elige **qué clasifica su sistema**, y **ningún dominio se puede repetir en el grupo**, porque después cada dominio será un módulo distinto del [proyecto integrador](../proyecto_integrador).

Necesitas **tres tipos de pieza** que se puedan distinguir con los sensores disponibles en clase:

| Dominio | Los tres tipos | Señales que podrían distinguirlos |
|---|---|---|
| Material | Madera, metal, plástico | Magnetismo (A3144), reflectancia (LDR) |
| Tamaño | Chica, mediana, grande | Distancia (HC-SR04 o GP2Y0A21YK0F) |
| Color | Clara, media, oscura | Reflectancia (LDR) |
| Contenido | Llena, media, vacía | Peso o distancia al nivel |
| Estado | Buena, marcada, deforme | Combinación de reflectancia y distancia |

El dominio se elige y se registra en la **semana 1**. A partir de ahí, todos los ejemplos de clase los adaptas a tu caso.

---

## Cómo se entrega {#como-se-entrega}

**No se entrega nada por Classroom**, salvo una cosa: la URL de tu repositorio de GitHub, una sola vez en todo el semestre. De ahí en adelante **tu entrega es hacer `push`**.

No hay documentos de Google, no hay archivos ZIP y no hay entregas por correo. El repositorio es la entrega.

### El repositorio {#el-repositorio}

Se llama `clasificador-piezas-ia`, es **privado**, y me agregas como colaborador (`Settings -> Collaborators -> Add people`, usuario `KarlosEspinoza`). **Sin esa invitación no puedo revisarte y tu trabajo cuenta como no entregado.**

La estructura es la misma para todo el grupo y para todo el semestre:

```
clasificador-piezas-ia/
  README.md      <- quien eres y que clasifica tu sistema
  BITACORA.md    <- una seccion por semana
  codigo/        <- sensor.ino, leer_sensor.py, adquirir.py, ...
  datos/         <- datos.csv, features.csv, ...
  figuras/       <- senal.png, confusion.png, ...
```

El `README.md` es la ficha técnica de tu sistema y se mantiene al día: tu dominio, tu sensor, tus características, tu modelo y su desempeño actual.

### BITACORA.md {#bitacora}

Es donde explicas **con tus propias palabras** qué concepto viste y cómo lo aplicaste en tu sistema. **Vale el 30% de cada revisión**, así que no es un trámite: es donde demuestras que entendiste lo que programaste.

Lleva una sección por semana, y cada semana tiene siempre las mismas dos partes:

```markdown
## Semana 5 - Características en el dominio del tiempo

### Antes de la clase

(lo que trabajaste en la guía de la sesión del lunes)

### Avance del proyecto

(lo que le agregaste a tu sistema)
```

Lo que busco al leerla no es que todo te haya salido bien. Es que se entienda **qué decidiste y por qué**. Una bitácora que dice "elegí un filtro de tamaño 5 porque mi evento dura 40 muestras y con 25 se me aplanaba el valle" vale muchísimo más que una que dice "apliqué un filtro de media móvil".

Y si algo no te salió, escríbelo. Un problema bien descrito cuenta como avance; un archivo vacío no.

### Los commits {#los-commits}

El mensaje del commit me dice qué estabas haciendo sin que yo tenga que abrir nada. Se usa siempre este formato, donde `sNN` es el número de semana:

| Momento | Mensaje |
|---|---|
| Al terminar el bloque 1 de la guía | `s05 bloque 1: ...` |
| Al terminar el bloque 2 de la guía | `s05 bloque 2: ...` |
| Si hiciste el bloque extra | `s05 extra: ...` |
| Al terminar el avance del proyecto | `s05 proyecto: ...` |

**Un commit al terminar cada bloque, no uno solo al final de la semana.** El historial es la evidencia de que trabajaste de forma constante, y eso es parte de lo que se evalúa.

---

## Lo que agregas cada semana {#cada-semana}

Los nombres de archivo son fijos, para que el proyecto crezca de forma acumulable y yo pueda revisarlo rápido:

| Semana | Tema | Archivos que agregas o modificas |
|---|---|---|
| 02 | La primera señal del sensor | `codigo/sensor.ino`, `codigo/leer_sensor.py` |
| 03 | Recolección de datos etiquetados | `codigo/adquirir.py` -> `datos/datos.csv` |
| 04 | Limpieza y normalización | `codigo/limpiar.py` -> `datos/datos_limpios.csv` |
| 05 | Características en el tiempo | `codigo/features.py` -> `datos/features.csv` |
| 06 | Características en frecuencia | `codigo/features.py` (agrega FFT) |
| 07 | Entrenamiento del clasificador | `codigo/entrenar.py` -> `modelo.pkl` |
| 08 | Primer bucle de control | `codigo/control.py`, `codigo/control.ino` |
| 10 | PCA y piezas anómalas | `codigo/pca.py`, `datos/anomalias.csv` |
| 11 | Agrupamiento | `codigo/clustering.py` |
| 12 | Autoencoder | `codigo/autoencoder.py` -> `detector.pkl` |
| 13 | La anomalía como señal de control | `codigo/control.py` (integra anomalías) |
| 15 | Evaluación del modelo | `codigo/evaluar.py`, `datos/datos_banda.csv` |
| 16 | Preparación para producción | `codigo/prueba_plc.py` -> `modelo_produccion.pkl` |

El detalle de cada semana está en su propia guía, enlazada desde el [índice del curso](/curso/ia).

---

## Las tres revisiones de avances {#revisiones}

Aquí es donde se califica. Son tres, presenciales, y cada una cierra un bloque del curso.

**Haz `push` antes del día acordado.** Yo reviso tu repositorio con anticipación y llego a la sesión con tus evidencias ya leídas. **Si no hay push a tiempo, la revisión cuenta como no entregada.**

En cada revisión se evalúa igual:

| Instrumento | Peso |
|---|---|
| Evidencias: código, datos, modelos y demostración del sistema funcionando | 50% |
| `BITACORA.md`: explicación de los conceptos de ML aplicados a tu sistema | 30% |
| 2 preguntas (orales o escritas) el día de la revisión | 20% |

Sobre las **2 preguntas**: una es sobre tu propio trabajo y la otra sobre los temas vistos en clase. La primera es la que importa. Si el código lo escribió alguien más, ahí se nota, porque las preguntas son sobre decisiones concretas de tu sistema: por qué elegiste ese filtro, qué pasa si subes el umbral, qué característica te sirvió más.

### Revisión 1: semana 9 {#revision-1}

Cierre de las Unidades 1 y 2. Tu sistema debe:

- Leer la señal de tu sensor desde Python y guardar un dataset etiquetado de tus tres tipos de pieza, balanceado y con al menos 30 ventanas por clase.
- Limpiar y normalizar las señales, con la corrección de línea base.
- Extraer características en el dominio del tiempo y de la frecuencia.
- Clasificar con un modelo entrenado por ti, con su matriz de confusión.
- **Cerrar el bucle**: el Arduino actúa según la decisión del modelo.
- `BITACORA.md` al día, de la semana 1 a la 8.

La evidencia principal es el **video del bucle funcionando**, con al menos dos pasadas de cada clase.

### Revisión 2: semana 14 {#revision-2}

Cierre de la Unidad 3. Tu sistema debe, además de lo anterior:

- Reducir dimensiones con PCA y mostrar cómo se estructuran tus datos.
- Agrupar sin etiquetas con K-Means y DBSCAN, y comparar los grupos con tus clases reales.
- Detectar piezas anómalas con un autoencoder, con su umbral justificado.
- **Reaccionar ante la anomalía**: el sistema rechaza o marca lo que no reconoce.
- `BITACORA.md` al día, hasta la semana 13.

La evidencia principal es el **video del sistema rechazando una anomalía**, más tu tabla de tasa de detección y falsas alarmas.

### Revisión final: semana 17 {#revision-final}

Cierre de la Unidad 4 y entrega final. Tu sistema debe, además de lo anterior:

- Estar evaluado con **validación cruzada**, reportando exactitud con su desviación estándar, y precisión y exhaustividad por clase.
- Tener datos capturados sobre la **banda real de la maqueta**, y el modelo reentrenado con ellos.
- Documentar el desajuste entre los datos de escritorio y los de la banda, con evidencia.
- Correr el bucle completo sobre la maqueta: **sensores -> Python -> modelo -> PLC -> banda y pistón**.
- `BITACORA.md` completa, con una entrada por cada semana del curso.

La evidencia principal es la **demostración en vivo sobre la maqueta**.

---

## Calificación {#calificacion}

Las tres revisiones se promedian:

| Revisión | Semana | Peso |
|---|---|---|
| Revisión 1 | Semana 9 | 33% |
| Revisión 2 | Semana 14 | 34% |
| Revisión final | Semana 17 | 33% |

Y ese promedio es el **35% de tu calificación final** del curso.

Dos cosas que conviene tener claras desde ahora:

**No se puede recuperar al final.** El sistema se construye por capas y cada revisión evalúa las capas de ese momento. No hay manera de hacer en la semana 16 el trabajo de la semana 3, porque la semana 3 es donde se recolectan los datos sobre los que se apoya todo lo demás.

**Un resultado malo bien explicado vale más que un resultado bueno sin explicar.** Si tu clasificador acierta el 70% y tú sabes exactamente por qué y qué harías para mejorarlo, eso es ingeniería. Si acierta el 99% y no sabes de dónde salió ese número, es sospechoso, y las preguntas del día de la revisión están diseñadas justo para distinguir los dos casos.

---

## Atributos de egreso {#atributos}

- **AE2A:** Diseñar e implementar sistemas en automatización, control, robótica y sistemas embebidos mediante proyectos integradores.
