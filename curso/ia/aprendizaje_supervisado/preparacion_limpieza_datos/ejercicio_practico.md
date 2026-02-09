---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Ejercicio práctico

## Preparación y limpieza de datos con sensores reales

**Modalidad:** Trabajo en equipos (2–3 integrantes)
**Duración estimada:** 90 minutos

---

## Objetivo del ejercicio

Aplicar técnicas básicas de **preparación y limpieza de datos** (normalización y detección de outliers) a datos reales obtenidos desde un **sensor físico conectado a Arduino**, integrando Arduino y Python en un flujo sencillo de análisis.

Este ejercicio refuerza el contenido visto en clase sobre **Preparación y Limpieza de Datos en Aprendizaje Supervisado** .

---

## Contexto

En sistemas mecatrónicos reales, los datos de sensores **no llegan listos para usarse**. Presentan ruido, escalas distintas y valores atípicos. Antes de entrenar cualquier modelo o tomar decisiones automáticas, es indispensable **limpiar y preparar los datos**.

En este ejercicio reproducirán ese escenario usando hardware real.

---

## Material requerido (por equipo)

* Arduino (Nano, Uno o similar)
* **Un sensor analógico** (LM35 *o* LDR *o* GP2Y0A21)
* Resistencias necesarias (ej. 10kΩ para LDR)
* Cables y protoboard
* Computadora con Python
* Cable USB

---

## Actividad 1 – Adquisición de datos crudos

### Instrucciones

1. Conecta **un solo sensor analógico** al Arduino (A0).
2. Programa el Arduino para:

   * Leer el valor del sensor.
   * Enviar el valor por **Serial** cada 500 ms.
3. Recolecta **al menos 30 lecturas**.

### Evidencia esperada en el Google Docs

* Foto del montaje.
* Código de Arduino.
* Captura del monitor serial.

---

## Actividad 2 – Normalización de datos 

### Instrucciones

1. Usa Python para leer los datos desde el puerto serial.
2. Guarda los valores en una lista.
3. Aplica **normalización Min–Max** a los datos:

$$
x' = \frac{x - x_{min}}{x_{max} - x_{min}}
$$

4. Imprime los valores originales y normalizados.

### Evidencia esperada en el Google Docs

* Código Python.
* Captura de salida en consola.

### Código base sugerido (Python)

```python
import serial, time
import numpy as np

arduino = serial.Serial('/dev/ttyUSB0', 9600)
time.sleep(2)

valores = []
for i in range(30):
    try:
        valores.append(int(arduino.readline().decode().strip()))
    except:
        pass

arr = np.array(valores)
norm = (arr - arr.min()) / (arr.max() - arr.min())

print("Original:", arr)
print("Normalizado:", norm)
```

---

## Actividad 3 – Detección de outliers 

### Instrucciones

1. Usando los mismos datos, calcula:

   * Media (μ)
   * Desviación estándar (σ)
2. Detecta valores atípicos usando la regla de **3σ**:

$$
|x_i - \mu| > 3\sigma
$$

3. Reporta:

   * Lista de outliers detectados.
   * Qué harías con ellos (eliminar o ignorar).

### Evidencia esperada en el Google Docs

* Código Python.
* Breve explicación (3–4 líneas).

### Código base sugerido

```python
mu = np.mean(arr)
sigma = np.std(arr)

outliers = [x for x in arr if abs(x - mu) > 3*sigma]

print("Media:", mu)
print("Sigma:", sigma)
print("Outliers:", outliers)
```
## Entregable único (para asistencia)

**Un solo Google Docs por equipo** que incluya:

1. Lista de integrantes.
2. Foto del montaje.
3. Código Arduino.
4. Código Python (normalización y outliers).
5. Capturas de ejecución.
6. Breve explicación (máx. 10 líneas):

   * Qué sensor usaron.
   * Qué problema de datos detectaron.
   * Qué técnica aplicaron y por qué.

**Este documento será la evidencia para pasar asistencia.**
No se evaluará estilo ni formato, solo evidencia de trabajo real.


