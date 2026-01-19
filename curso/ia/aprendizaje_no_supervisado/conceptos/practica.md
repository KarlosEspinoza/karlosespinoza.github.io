---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

### Práctica

**Actividad:**
En parejas, recolecten lecturas de **dos sensores diferentes** (por ejemplo, **LDR y A3144**) y hagan que un **Buzzer o Servomotor** reaccione según el grupo detectado por K-Means.

**Python base (semi-completo):**

```python
import numpy as np
from sklearn.cluster import KMeans
import serial

# TODO: leer datos del archivo 'lecturas.csv'
# columnas: sensor1, sensor2
# X = np.array([...])

modelo = KMeans(n_clusters=3)
modelo.fit(X)

# TODO: tomar una nueva medición en tiempo real del Arduino
# valor1, valor2 = ...

cluster = modelo.predict([[valor1, valor2]])[0]
print("Cluster actual:", cluster)

# TODO: enviar el número del cluster al Arduino por Serial
```

**Objetivo:** el actuador debe comportarse distinto en cada cluster detectado (ej. tono o ángulo).


