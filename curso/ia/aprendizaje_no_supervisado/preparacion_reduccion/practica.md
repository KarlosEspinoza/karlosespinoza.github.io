---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

## Práctica

En parejas, recolecten 50 lecturas simultáneas de **temperatura (LM35)**, **luz (LDR)** y **sonido (KY-037)**, envíenlas por serial y guárdenlas en un CSV. Luego:

1. Estandaricen los datos.
2. Apliquen PCA con 2 componentes.
3. Grafiquen el resultado.
4. Coloquen una breve reflexión: ¿qué patrón observan entre las condiciones ambientales?

Script guía:

```python
"""
Práctica PCA: Lecturas desde Arduino
"""
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

# 1. Leer CSV generado por Arduino
# df = pd.read_csv("lecturas_ambiente.csv")

# 2. Estandarizar
# scaler = StandardScaler()
# X_scaled = scaler.fit_transform(df[["temp", "luz", "sonido"]])

# 3. PCA
# pca = PCA(n_components=2)
# X_pca = pca.fit_transform(X_scaled)

# 4. Graficar componentes
# plt.scatter(...)
# plt.title("Proyección PCA de ambiente")
# plt.show()

# TODO: Escriban una reflexión breve sobre qué representa cada eje PCA
```


