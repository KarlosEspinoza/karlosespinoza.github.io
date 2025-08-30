---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Introducción al preprocesamiento e ingeniería de datos

## 1. Teoría 

### a) ¿Qué es el preprocesamiento?

Es la fase en la que tomamos datos “crudos” (directos de sensores) y los **preparamos** para poder analizarlos o entrenar un modelo.
Sin este paso, los algoritmos se confunden por **escalas distintas, ruido, o variables redundantes**.

**Ejemplo**: con un Arduino Nano y un sensor de luz LDR, las lecturas crudas varían de 0 a 1023 según la intensidad luminosa. 
Estos valores no son comparables directamente con los de otro sensor, como temperatura o sonido. 
Con preprocesamiento podemos normalizar los datos de la LDR a un rango 0–1 y eliminar picos de ruido, facilitando que un modelo aprenda patrones reales sin confundirse.

### b) Ejemplo del robot seguidor de paredes

* Dataset: [Wall-following Robot](https://www.kaggle.com/datasets/uciml/wall-following-robot?resource=download)

En el experimento, un robot móvil recorre una habitación siguiendo la pared mientras registra lecturas de 24 sensores ultrasónicos distribuidos en su cuerpo. 
Estos sensores miden distancias al entorno y generan gran cantidad de datos crudos. 
Para facilitar el análisis, los investigadores redujeron esas 24 lecturas a solo 4 direcciones clave (frente, izquierda, derecha y atrás) y, en una versión más compacta, a solo 2 (frente e izquierda). 
Este proceso de simplificación es un ejemplo claro de preprocesamiento, donde se transforman datos complejos en variables más útiles y manejables para el control o el aprendizaje automático.

* Tres versiones:

  * sensor_readings_24.csv: 24 sensores ultrasónicos.
  * sensor_readings_4.csv: 4 distancias simplificadas (frente, izquierda, derecha, atrás).
  * sensor_readings_2.csv: solo frente e izquierda.

### c) Ecuaciones relevantes en el preprocesamiento

**(1) Normalización Min–Max**

**Objetivo:** que todos los sensores tengan la **misma escala** para compararlos.

$$
x_i' = \frac{x_i - x_{\min}}{x_{\max} - x_{\min}}
$$

* $x_i$: valor crudo de un sensor.
* $x_{\min}, x_{\max}$: valores mínimo y máximo en ese sensor.
* $x_i'$: valor escalado entre 0 y 1.

**(2) Reducción a “distancias simplificadas”**

**Objetivo:** quedarnos con lo más representativo → la **distancia mínima** en cada dirección.

$$
d_{\text{frente}} = \min_{s\in \mathcal{F}} x_s
$$

Donde $\mathcal{F}$ es el grupo de sensores que apuntan hacia el frente. Lo mismo para izquierda, derecha y atrás.


**(3) Codificación de etiquetas**

**Objetivo:** traducir palabras a números que entienda un algoritmo.

| Clase textual     | Código |
| ----------------- | ------ |
| Move-Forward      | 0      |
| Slight-Right-Turn | 1      |
| Sharp-Right-Turn  | 2      |
| Slight-Left-Turn  | 3      |


## 2. Práctica 

### Objetivo de la práctica

Pasar de un dataset con 24 sensores (`sensor_readings_24.csv`) a uno con **2 distancias simplificadas** (frente e izquierda) y con **etiquetas numéricas**, aplicando además **normalización Min–Max**.


### Explicación del problema

El robot SCITOS G5 tiene 24 sensores ultrasónicos alrededor de su cintura. Esos datos son útiles, pero complicados para un modelo simple. Para una primera versión de control, basta con **dos entradas**:

* Distancia frente (mínimo de los sensores frontales).
* Distancia izquierda (mínimo de los sensores laterales izquierdos).

Con esas dos variables y la etiqueta numérica, podemos alimentar un clasificador sencillo o simular decisiones.

### Instrucciones

1. Cargar `sensor_readings_24.csv`.
2. Seleccionar subconjuntos de sensores:

   * Frente (sensores 0–5).
   * Izquierda (sensores 6–11).
3. Calcular la distancia mínima en cada grupo.
4. Normalizar esos valores con **Min–Max**.
5. Traducir la columna de clase a valores numéricos (0–3).
6. Guardar un nuevo archivo `robot_2sensores.csv`.


### Script

**./main.py**

```python
# -*- coding: utf-8 -*-
# Práctica: reducción de 24 sensores a 2 y preprocesamiento básico
# Dataset: sensor_readings_24.csv

import pandas as pd
import numpy as np

# 1. Cargar el CSV (ajusta la ruta si es necesario)
df = pd.read_csv("datos/sensor_readings_24.csv", header=None)

# Separar características (X) y etiquetas (y)
X = df.iloc[:, :-1]   # todas las columnas excepto la última
y = df.iloc[:, -1]    # última columna = clase textual

# 2. Seleccionar subconjuntos de sensores
# Asumimos que sensores 0-5 son frente, 6-11 izquierda
front_sensors = X.iloc[:, 0:6]
left_sensors  = X.iloc[:, 6:12]

# 3. Calcular distancias mínimas
d_front = front_sensors.min(axis=1)
d_left  = left_sensors.min(axis=1)

# 4. Normalización Min–Max
# Ecuación: x' = (x - min) / (max - min)
d_front_norm = (d_front - d_front.min()) / (d_front.max() - d_front.min())
d_left_norm  = (d_left - d_left.min()) / (d_left.max() - d_left.min())

# 5. Codificación de etiquetas
label_map = {
    "Move-Forward": 0,
    "Slight-Right-Turn": 1,
    "Sharp-Right-Turn": 2,
    "Slight-Left-Turn": 3
}
y_num = y.map(label_map)

# 6. Crear nuevo DataFrame con 2 sensores + etiqueta numérica
df_2 = pd.DataFrame({
    "D_front_norm": d_front_norm,
    "D_left_norm": d_left_norm,
    "Class": y_num
})

# 7. Guardar a CSV
df_2.to_csv("datos/robot_2sensores.csv", index=False)

print("Archivo guardado: datos/robot_2sensores.csv")
print(df_2.head())
```

