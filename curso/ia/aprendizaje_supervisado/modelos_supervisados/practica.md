---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

## Práctica

En parejas, recolecten datos con **dos sensores distintos** (ej. LDR + LM35) y activen un actuador (ej. LED RGB o buzzer).

1. Usen **regresión** para calibrar uno de los sensores (ej. LDR vs lux).
2. Usen **clasificación** para predecir el estado del actuador (ej. LED encendido/apagado).
3. Guarden datos en CSV y apliquen ambos modelos en Python.

**Script Python base (semi-completo):**

```python
import csv
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsClassifier

# TODO: Leer datos de sensores desde 'datos.csv'
# Estructura esperada: sensor1, sensor2, actuador

# --- Parte 1: Regresión ---
X_reg = np.array(sensor1).reshape(-1,1)
y_reg = np.array(valor_referencia)
modelo_reg = LinearRegression().fit(X_reg, y_reg)
print("Regresión:", modelo_reg.intercept_, modelo_reg.coef_)

# --- Parte 2: Clasificación ---
X_clf = np.array(sensor2).reshape(-1,1)
y_clf = np.array(actuador)  # etiquetas 0/1
modelo_clf = KNeighborsClassifier(n_neighbors=3).fit(X_clf, y_clf)
print("Clasificación:", modelo_clf.predict([[umbral]]))
```


