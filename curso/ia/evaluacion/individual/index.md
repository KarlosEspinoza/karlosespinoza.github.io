---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Evaluación Individual

**Ingeniería Mecatrónica – Séptimo Semestre**  
**Valor:** 15% de la calificación final

---

## Descripción general

Implementarás de manera **individual** un sistema físico inteligente usando Arduino Nano, sensores reales y un modelo de Aprendizaje de Máquina entrenado con datos que tú mismo adquieras.

El sistema debe simular una situación real que tú elijas y describas. Por ejemplo: una máquina que cierra la ventana de un invernadero, apaga el riego y envía una notificación en base a tres sensores que clasifican el tipo de día. Tú decides qué situación simula tu sistema.

---

## Requisitos del sistema

| Elemento | Cantidad mínima |
|---|---|
| Sensores | 3 |
| Actuadores | 3 |
| Tarjeta de desarrollo | Arduino Nano |
| Montaje | Protoboard |

### Tipo de modelo permitido

Debes implementar **uno** de los siguientes:

- **Clasificación** (aprendizaje supervisado)
- **Regresión** (aprendizaje supervisado)
- **Clustering / Agrupamiento** (aprendizaje no supervisado)

---

## Pipeline de desarrollo

El sistema sigue tres etapas. Cada etapa tiene archivos con nombres exactos que debes respetar.

```
proyecto/
  manual/
    manual.ino        ← Etapa 1: Arduino para adquisición manual
  automatico/
    automatico.ino    ← Etapa 3: Arduino para producción
  guardar.py          ← Etapa 1: Guarda datos del serial en CSV
  datos.csv           ← Datos adquiridos (generado por guardar.py)
  entrenar.py         ← Etapa 2: Entrena el modelo
  modelo.pkl          ← Modelo entrenado (generado por entrenar.py)
  produccion.py       ← Etapa 3: Inferencia en tiempo real
```

### Etapa 1 — Adquisición de datos

`manual/manual.ino` lee los sensores y envía las lecturas por el puerto serial.  
`guardar.py` recibe los datos del serial y los guarda en `datos.csv`.

> En esta etapa tú controlas manualmente las condiciones del sistema para generar las diferentes clases o rangos de tu variable objetivo.

### Etapa 2 — Entrenamiento

`entrenar.py` carga `datos.csv`, entrena el modelo y lo guarda en `modelo.pkl` usando `joblib`.

### Etapa 3 — Producción

`automatico/automatico.ino` lee los sensores en tiempo real y envía las lecturas a Python.  
`produccion.py` carga `modelo.pkl`, recibe las lecturas, realiza la inferencia y envía el comando de vuelta al Arduino para accionar los actuadores.

---

## Puntaje extra: Evaluación del modelo *(opcional)*

Quien incluya una **etapa de evaluación** en `entrenar.py` obtendrá puntos extra.

La evaluación no es obligatoria, pero si la haces:

- Agrega en `entrenar.py` el cálculo de las métricas correspondientes a tu tipo de modelo (accuracy, F1, MAE, RMSE, R², etc.).
- `entrenar.py` debe guardar en `modelo.pkl` **únicamente el mejor modelo** (por ejemplo, el que obtenga mayor accuracy o menor error en el conjunto de prueba).

---

## Entregables

Entregarás **dos cosas**:

### 1. Documento en Google Docs

Un documento sencillo que describa:

1. **Situación simulada** — ¿Qué hace tu sistema? ¿Qué situación del mundo real representa?
2. **Variables X e y** — ¿Qué miden tus sensores (X)? ¿Qué predice o agrupa el modelo (y)?
3. **Tipo de modelo** — ¿Clasificación, regresión o clustering? ¿Por qué elegiste ese tipo?
4. **Diagrama de conexiones** — Esquema o foto clara del circuito en protoboard.
5. **Tabla de condiciones de operación** — Muestra las situaciones que puede enfrentar tu sistema.

**Ejemplo de tabla:**

| LM35 [°C] | HC-SR04 [cm] | LDR | Clase / Valor (y) |
|---|---|---|---|
| 35–50 | 5–15 | < 300 | Día caluroso y soleado |
| 20–35 | cualquier | 300–700 | Día templado nublado |
| < 20 | cualquier | > 700 | Noche o día muy frío |

6. **Descripción del pipeline** — Explica brevemente cómo funciona cada etapa (adquisición, entrenamiento, producción).

> El documento no necesita ser extenso. Lo importante es que demuestre que entiendes el concepto y el flujo de desarrollo.

---

### 2. Archivo ZIP

El ZIP debe llamarse con tu **código de estudiante** (ejemplo: `219894185.zip`) y contener exactamente la siguiente estructura:

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
```

> Entrega ambos archivos (Google Docs + ZIP) en el espacio indicado en Google Classroom antes de la fecha límite.

---

## Evaluación oral

Después de entregar, presentarás una **evaluación oral individual** de pocos minutos.

Te haré **2 preguntas** sobre tu sistema y sobre los conceptos del curso.

| Respuestas correctas | Calificación oral |
|---|---|
| 2 de 2 | 100% |
| 1 de 2 | 80% |
| 0 de 2 | 0% |

---

## Calificación final de la evaluación individual

| Componente | Peso |
|---|---|
| Entregables (Google Docs + ZIP) | 50% |
| Evaluación oral | 50% |

Esta evaluación equivale al **15% de tu calificación final** del curso.

---

## Atributos de Egreso

- **AE2A:** Diseñar e implementar sistemas en automatización, control, robótica y sistemas embebidos mediante proyectos integradores.
