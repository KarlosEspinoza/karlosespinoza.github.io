---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)



# Actividad Extra (opcional)

## 1. Escalado Estándar (Z-score Standardization)

### Explicación

La estandarización transforma los datos para que tengan **media cero y desviación estándar uno**. Esto es útil cuando diferentes sensores tienen magnitudes muy distintas.

$$
z_i = \frac{x_i - \mu}{\sigma}
$$

donde $x_i$ = dato original, $\mu$ = media, $\sigma$ = desviación estándar.


### Ejemplo

El **LM35** mide temperatura en °C, pero si lo usamos junto a un sensor de flujo YF-S201 (L/min), el modelo podría verse sesgado por las escalas diferentes. Con la estandarización, tanto °C como L/min quedan en la misma escala relativa: distancia a la media en desviaciones estándar.


### Ejercicio

#### **Arduino (LM35 → °C)**

```cpp
const int lm35Pin = A0;
void setup() { Serial.begin(9600); }
void loop() {
  int lectura = analogRead(lm35Pin);
  float temp = (lectura * 5.0 * 100.0) / 1023.0;
  Serial.println(temp);  // °C
  delay(500);
}
```

#### **Python (estandarización)**

```python
import serial, time
import numpy as np

arduino = serial.Serial('/dev/ttyUSB0', 9600)
time.sleep(2)

valores = []
for i in range(20):
    try:
        data = arduino.readline().decode().strip()
        valores.append(float(data))
    except:
        pass

arr = np.array(valores)
mu, sigma = np.mean(arr), np.std(arr)

z_scores = (arr - mu) / sigma
print("Original:", arr)
print("Estandarizados:", z_scores)
```

## 2. Suavizado de Datos (Promedio Móvil)

### Explicación

El promedio móvil reduce el **ruido** en los datos de un sensor, generando una señal más estable.

$$
\bar{x}_t = \frac{1}{k} \sum_{i=0}^{k-1} x_{t-i}
$$

donde $k$ es la ventana de suavizado.


### Ejemplo

El **LM35** puede tener pequeñas variaciones rápidas por interferencias eléctricas. Si en 5 lecturas sucesivas tenemos: `25, 26, 30, 27, 26`, aplicando un promedio móvil de ventana 3 obtenemos valores más estables: `27.0, 27.7, 27.6`. Esto facilita que un modelo prediga sin confundirse con ruido.


### Ejercicio

#### **Arduino (LM35 → °C, mismo script anterior)**

*(se reutiliza el script de Arduino que envía temperatura por serial)*

#### **Python (promedio móvil)**

```python
import serial, time
import numpy as np

arduino = serial.Serial('/dev/ttyUSB0', 9600)
time.sleep(2)

valores = []
for i in range(30):
    try:
        data = arduino.readline().decode().strip()
        valores.append(float(data))
    except:
        pass

arr = np.array(valores)

# Suavizado con promedio móvil ventana k=3
k = 3
suavizados = np.convolve(arr, np.ones(k)/k, mode='valid')

print("Original:", arr)
print("Suavizados:", suavizados)
```

## Entregables de la Actividad Extra

* Código Arduino y Python (Z-score y Promedio Móvil).
* Capturas de los resultados (datos originales vs transformados).
* Breve reflexión: ¿Qué técnica fue más útil para limpiar la señal de temperatura del LM35?

