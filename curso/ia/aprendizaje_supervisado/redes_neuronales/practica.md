---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

## Práctica para casa

**Actividad:**
En parejas, utilicen **dos sensores diferentes** (por ejemplo, **LDR y HC-SR04**) y un **actuador** (por ejemplo, **LED RGB** o **Buzzer**) para que una red neuronal decida el color del LED o el tono del buzzer.

**Objetivo:**
Entrenar un modelo MLPClassifier que prediga una **categoría (color o tono)** a partir de las lecturas de los sensores.

**Python base (semi-completo):**

```python
import csv
import numpy as np
from sklearn.neural_network import MLPClassifier

# TODO: Leer datos de 'sensores.csv'
# columnas esperadas: sensor1, sensor2, color (0=azul,1=rojo,2=verde)

# Entrenamiento
modelo = MLPClassifier(hidden_layer_sizes=(6,), activation='relu', max_iter=1500)
modelo.fit(X, y)

# TODO: probar con nuevos valores
nueva_medicion = np.array([[val1, val2]])
pred = modelo.predict(nueva_medicion)
print("Color predicho:", pred)
```


