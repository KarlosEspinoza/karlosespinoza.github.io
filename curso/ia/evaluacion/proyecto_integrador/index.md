---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Proyecto Integrador

**Ingeniería Mecatrónica – Séptimo Semestre**  
**Valor:** 50% de la calificación final

---

## Descripción general

El proyecto integrador consiste en diseñar, implementar y demostrar un **sistema físico inteligente en equipo**. El sistema debe adquirir datos de sensores reales, entrenar un modelo de Aprendizaje de Máquina y ejecutar inferencia en tiempo real para controlar actuadores.

El equipo elige libremente la situación que simula su sistema y la documenta en un reporte técnico en Google Docs.

Este proyecto integra los atributos de egreso **AE2A** y **AE7A**.

---

## Formación de equipos

- Equipos de **2 o 3 integrantes** (no se permiten equipos de 1 ni de 4 o más).
- **Cada integrante debe aportar sensores y actuadores distintos** a los de sus compañeros de equipo. No se puede repetir el mismo tipo de sensor ni el mismo tipo de actuador dentro del equipo.

**Ejemplo para un equipo de 2:**

| Integrante | Sensores | Actuadores |
|---|---|---|
| Integrante A | LM35, LDR, HC-SR04 | Servo, LED RGB, Buzzer |
| Integrante B | A3144, HW-870, GP2Y0A21YK0F | Motor CD, Relé, Válvula |

> Ningún componente se repite entre los dos integrantes. El sistema completo integra todos los sensores y actuadores en un único pipeline de aprendizaje de máquina.

---

## Tipo de modelo

El equipo implementa **uno** de los siguientes:

- **Clasificación** (aprendizaje supervisado)
- **Regresión** (aprendizaje supervisado)
- **Clustering / Agrupamiento** (aprendizaje no supervisado)

---

## Pipeline de desarrollo

El proyecto sigue el mismo pipeline del curso. Los archivos deben entregarse con los nombres exactos indicados:

```
proyecto/
  manual/
    manual.ino        ← Etapa 1: Arduino para adquisición manual
  automatico/
    automatico.ino    ← Etapa 3: Arduino para producción
  guardar.py          ← Etapa 1: Guarda los datos del serial en CSV
  datos.csv           ← Datos adquiridos (generado por guardar.py)
  entrenar.py         ← Etapa 2: Entrena el modelo
  modelo.pkl          ← Modelo entrenado (generado por entrenar.py)
  produccion.py       ← Etapa 3: Inferencia en tiempo real
  integrantes.csv     ← Autoevaluación del equipo
```

### Etapa 1 — Adquisición de datos

`manual/manual.ino` lee todos los sensores del equipo y envía las lecturas por el puerto serial.  
`guardar.py` recibe los datos y los guarda en `datos.csv`.

> En esta etapa el equipo controla manualmente las condiciones del sistema para generar las diferentes clases, rangos o situaciones de la variable objetivo.

### Etapa 2 — Entrenamiento

`entrenar.py` carga `datos.csv`, entrena el modelo y lo guarda en `modelo.pkl` usando `joblib`.

### Etapa 3 — Producción

`automatico/automatico.ino` lee todos los sensores en tiempo real y envía las lecturas a Python.  
`produccion.py` carga `modelo.pkl`, recibe las lecturas, realiza la inferencia y envía el comando de vuelta al Arduino para accionar los actuadores.

---

## Puntos extra *(opcionales)*

### Extra 1 — Evaluación del modelo

Agrega en `entrenar.py` una etapa de evaluación con las métricas correspondientes a tu tipo de modelo (accuracy, F1, MAE, RMSE, R², etc.).

- `entrenar.py` debe guardar en `modelo.pkl` **únicamente el mejor modelo** (el que obtenga la mejor métrica en el conjunto de prueba).
- Justifica en el reporte por qué ese modelo es el mejor.

### Extra 2 — Raspberry Pi

Despliega el sistema de producción en una **Raspberry Pi** en lugar de una laptop.

- `produccion.py` debe correr en la Raspberry Pi.
- La Raspberry Pi se comunica con el Arduino Nano por serial (UART).
- Incluye en el reporte la configuración realizada y una foto del sistema corriendo en la Raspberry Pi.

> Los extras se evalúan de forma independiente. Pueden hacer uno, los dos, o ninguno.

---

## Entregables

### 1. Reporte técnico en Google Docs

El reporte describe el desarrollo completo del proyecto. Debe incluir:

**1.1 Descripción del sistema**
- ¿Qué situación simula el sistema? Descríbela con claridad.
- ¿Qué miden los sensores (X)? ¿Qué predice, clasifica o agrupa el modelo (y)?
- Justificación del tipo de modelo elegido (clasificación, regresión o clustering).

**1.2 Contribución de cada integrante**

Tabla que muestre qué sensores y actuadores aporta cada integrante:

| Integrante | Código | Sensores | Actuadores |
|---|---|---|---|
| Nombre A | 21XXXXXXX | Sensor 1, Sensor 2, Sensor 3 | Actuador 1, Actuador 2, Actuador 3 |
| Nombre B | 21XXXXXXX | Sensor 4, Sensor 5, Sensor 6 | Actuador 4, Actuador 5, Actuador 6 |

**1.3 Sistema eléctrico**
- Diagrama de conexiones completo (todos los sensores y actuadores del equipo).
- Foto del montaje en protoboard.

**1.4 Adquisición de datos**
- Tabla de condiciones de operación del sistema.

Ejemplo:

| Sensor 1 | Sensor 2 | Sensor 3 | … | Clase / Valor (y) | Descripción |
|---|---|---|---|---|---|
| valor | valor | valor | … | clase | Situación que representa |

- Frecuencia de muestreo y cantidad de datos recopilados.
- Código de `manual/manual.ino` comentado.
- Código de `guardar.py` comentado.

**1.5 Entrenamiento**
- Descripción del modelo elegido y por qué.
- Código de `entrenar.py` comentado.
- *(Si hicieron el Extra 1)* Métricas obtenidas y justificación del modelo final.

**1.6 Producción**
- Descripción del flujo completo: sensor → Arduino → Python → modelo → actuador.
- Código de `automatico/automatico.ino` comentado.
- Código de `produccion.py` comentado.
- Enlace a video demostrativo en **YouTube (No listado)** o **Google Drive (acceso libre)**.

El video debe mostrar: el sistema físico, lecturas en tiempo real, inferencia del modelo y actuadores respondiendo.

---

### 2. Archivo ZIP

El ZIP se nombra con los **códigos de todos los integrantes separados por guiones**  
(ejemplo: `219894185-218010062-214393994.zip`) y contiene exactamente:

```
proyecto/
  manual/
    manual.ino
  automatico/
    automatico.ino
  guardar.py
  datos.csv
  entrenar.py
  modelo.pkl
  produccion.py
  integrantes.csv
```

**`integrantes.csv`** — cada integrante asigna la calificación que considera que merece cada miembro del equipo por su participación real en el proyecto. La suma de calificaciones determina el 50% del puntaje de proyecto.

```csv
codigo,calificacion
219894185,100
218010062,80
214393994,100
```

---

> ⚠️ **Cada integrante del equipo debe entregar por separado el Google Docs y el ZIP en Google Classroom.**
>
> La entrega es individual aunque el proyecto sea en equipo. No es suficiente que un compañero entregue por ti.
>
> **El integrante que no entregue en la fecha límite recibe calificación 0 en el proyecto integrador**, independientemente de su participación en el desarrollo.

---

## Rúbrica de evaluación (50%)

| # | Criterio | Descripción | Puntaje |
|---|---|---|---|
| 1 | **Definición del problema** | Describe X, y y tipo de modelo con claridad y justificación | 0 / 5 |
| 2 | **Contribución individual** | Cada integrante aporta sensores y actuadores distintos, documentado en tabla | 0 / 5 |
| 3 | **Sistema eléctrico** | Diagrama completo, conexiones correctas, foto del montaje | 0 / 5 |
| 4 | **Adquisición de datos** | Tabla de condiciones, datos suficientes, scripts funcionales y comentados | 0 / 15 |
| 5 | **Scripts Arduino** | `manual.ino` y `automatico.ino` funcionales, comentados y claros | 0 / 10 |
| 6 | **Scripts Python** | `guardar.py`, `entrenar.py` y `produccion.py` reproducibles y bien estructurados | 0 / 15 |
| 7 | **Producción en tiempo real** | El sistema completo funciona: sensores → modelo → actuadores | 0 / 10 |
| 8 | **Calidad del reporte** | Organización, ortografía, claridad, rigor técnico | 0 / 5 |
| 9 | **Entrega completa** | ZIP con estructura exacta, video, `integrantes.csv` | 0 / 5 |
| | **Subtotal** | | **0 / 75** |
| E1 | **Extra: Evaluación del modelo** | Métricas en `entrenar.py`, solo se guarda el mejor modelo, justificación | + 0 / 10 |
| E2 | **Extra: Raspberry Pi** | Producción corriendo en Raspberry Pi, foto y configuración en reporte | + 0 / 10 |
| | **Total con extras** | | **0 / 95** |

> Los 75 puntos base equivalen al **50% de la calificación final**.  
> Los puntos extra se suman directamente sobre ese 50%.

---

## Atributos de Egreso

- **AE2A:** Diseñar e implementar sistemas en automatización, control, robótica y sistemas embebidos mediante proyectos integradores.
- **AE7A:** Favorecer el trabajo colaborativo y el liderazgo en equipos multidisciplinarios.
