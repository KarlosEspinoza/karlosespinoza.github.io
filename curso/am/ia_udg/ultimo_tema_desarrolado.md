---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)


# Actividad: Preparación y Limpieza de Datos en Aprendizaje Supervisado

## Objetivo

Que el estudiante comprenda y aplique los procesos de preparación y limpieza de datos para proyectos de **aprendizaje supervisado**, utilizando sensores y actuadores en Arduino como fuente de datos.

## Aportación a los Atributos de Egreso

Esta actividad fortalece la capacidad de **diseñar e implementar sistemas** (AE2A) al integrar datos de sensores físicos en un flujo de *machine learning*. También fomenta el **trabajo colaborativo y liderazgo** (AE7A), pues los estudiantes trabajarán en parejas para resolver ejercicios y compartir hallazgos.

## Método de enseñanza

Se empleará **Aprendizaje Experiencial y Colaborativo**. Los estudiantes manipulan datos reales obtenidos de sensores, discuten en parejas y aplican lo aprendido en ejercicios guiados.

## Criterios de evaluación

La evidencia se revisará con lista de cotejo:

* ¿Incluyó código y ejecución en Arduino/Python?
* ¿Se aplicaron correctamente las técnicas de limpieza de datos?
* ¿Se entregaron capturas/fotos como evidencia?
* ¿El trabajo refleja aportaciones de ambos integrantes?

---

## Desarrollo del Tema (60 minutos)
















### 1. Normalización de Datos

#### Explicación

La normalización escala los datos a un rango común (ej. \[0,1]) para evitar que sensores con diferentes unidades dominen el modelo.
  Fórmula de Min-Max:

  $$
  x' = \frac{x - x_{\min}}{x_{\max} - x_{\min}}
  $$

  donde $x$ = valor original, $x'$ = valor normalizado, $x_{\min}$, $x_{\max}$ = valores mínimo y máximo.

#### Ejemplo

 Un Arduino Nano conectado a un **HC-SR04** mide distancias en cm, y un **LDR** mide luz en valores de 0–1023. Si queremos que un modelo prediga si un servomotor debe abrir o cerrar una compuerta, ambos datos deben estar en la misma escala. Normalizamos distancia y luz para que el algoritmo no dé más peso a los valores del LDR.

#### Ejercicio

<img src="/image/ia/ldr.png" width="400"/>

Normalizamos la lectura de un **LDR** en Arduino.

```cpp
int sensorPin = A0;  // LDR
int val;
void setup() {
  Serial.begin(9600);
}
void loop() {
  val = analogRead(sensorPin); // valor entre 0-1023
  float norm = (val - 0.0) / (1023.0 - 0.0); // Normalización Min-Max
  Serial.println(norm); 
  delay(500);
}
```

### 2. Detección y Manejo de Valores Atípicos (*Outliers*)

#### Explicación

Los outliers son datos fuera del rango esperado. Se identifican con el criterio de 3σ (desviación estándar).
  Fórmula:

  $$
  |x_i - \mu| > 3\sigma
  $$

  donde $\mu$ es la media y $\sigma$ la desviación estándar.

#### Ejemplo

Usando el **LM35**, un valor de 150 °C sería un outlier si la media en el salón es de 25 °C con σ = 2 °C. Estos valores erróneos afectan al entrenamiento del modelo.

#### Ejercicio

<img src="/image/ia/lm35.png" width="400"/>

**Script de Arduino (LM35 → °C por Serial)**
```cpp
const int lm35Pin = A0;
int lectura;
float temperatura;

void setup() {
  Serial.begin(9600);
}

void loop() {
  lectura = analogRead(lm35Pin);
  temperatura = (lectura * 5.0 * 100.0) / 1023.0; // °C
  Serial.println(temperatura);
  delay(500);
}

```

***Script de Python (lee Serial, detecta outliers y limpia)*

```python
import serial, time
import numpy as np

arduino = serial.Serial('/dev/ttyUSB0', 9600)
time.sleep(2)

valores = []

# Leer 20 datos del Arduino
for i in range(20):
    try:
        data = arduino.readline().decode().strip()
        temp = float(data)
        valores.append(temp)
    except:
        pass

arr = np.array(valores)
mu, sigma = np.mean(arr), np.std(arr)

# Detectar outliers con 3σ
outliers = [x for x in arr if abs(x - mu) > 3*sigma]

print("Temperaturas:", arr)
print("Outliers detectados:", outliers)

```

































### 3. Imputación de Valores Faltantes

#### Explicación

Cuando un sensor falla, genera datos vacíos. Se pueden reemplazar por la **media, mediana o interpolación**.
  Ejemplo de imputación por media:

  $$
  x_i = \frac{\sum x}{n}
  $$

#### Ejemplo

El sensor **YF-S201** de flujo de agua a veces manda 0 cuando no recibe pulsos. Si ese valor es por falla, podemos imputar la media de los últimos valores.

#### Ejercicio

```python
import numpy as np

# Flujo de agua medido (L/min), con un 0 erróneo
flujo = [2.5, 2.6, 0, 2.4, 2.5]

# Imputación simple con la media
media = np.mean([x for x in flujo if x > 0])
flujo_imputado = [x if x > 0 else media for x in flujo]

print("Original:", flujo)
print("Imputado:", flujo_imputado)
```

---

## Práctica (para casa, 30 min)

En parejas, recolecten datos de **cualquier sensor disponible** (ej. LDR o HC-SR04) y activen un **actuador** (ej. LED o servomotor) dependiendo de la condición del dato ya **limpio** (ej. normalizado o con imputación).
El objetivo es aplicar al menos **una técnica de limpieza de datos**.

**Script Python (con pistas):**

```python
import serial
import numpy as np

# Abrir puerto serial
arduino = serial.Serial('/dev/ttyUSB0', 9600)

valores = []
for i in range(20):
    data = arduino.readline().decode().strip()
    try:
        valor = float(data)
        valores.append(valor)
    except:
        pass

# TODO: Normalizar los valores
# norm_valores = ...

# TODO: Imputar si hay valores nulos o atípicos
# imputados = ...

print("Valores procesados:", imputados)
# TODO: Decidir si se activa un actuador (ej. LED)
```

---

## Entregables

* Código Arduino y Python usado en ejercicios y práctica.
* Capturas de pantalla de la ejecución o fotos del montaje.
* Breve descripción (3–5 líneas) de qué técnica de limpieza aplicaron.
  👉 Evidencia entregada en un **Google Docs con capturas y código**.

---

## Actividad de Gamificación (5–10 minutos)

**“Data Sprint”**

* Cada equipo recibe un conjunto de **10 valores con ruido y outliers** en papel o proyector.
* Gana el equipo que **corrija los datos primero** aplicando alguna técnica vista (normalización, imputación o eliminación de outliers).
* Se premia con recompensa sorpresa  al equipo ganador.

## Actividad Extra

Si quieres aprender más sobre este tema, te invito a revisar [este material](preparacion_limpieza_datos_extra).
