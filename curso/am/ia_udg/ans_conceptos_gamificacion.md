---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# 1) CSV con puntos para 5 equipos

Archivo [CSV](ans_conceptos_gamificacion_data.csv).

Estructura de columnas:

* `team`: identificador del equipo
* `pt_id`: número del punto (1–15)
* `x`, `y`: coordenadas 2D

---

# 2) Ecuación para calcular centroides (objetivo y variables)

## Nombre de la ecuación

### Centroides de K-Means (media de clúster)

## Objetivo de la ecuación

Calcular la posición del **centroide** (\boldsymbol{\mu}_k) del clúster (k), es decir, el “promedio” de todos los puntos asignados a ese clúster. En K-Means, se **minimiza** la suma de distancias cuadráticas a estos centroides.

$$
\boldsymbol{\mu}*k ;=; \frac{1}{|C_k|},\sum*{x_i \in C_k} , x_i
$$

**Variables:**

* $C_k$: conjunto de puntos asignados al clúster $k$.
* $\lvert C_k \rvert$: número de puntos en el clúster $k$.
* $x_i \in \mathbb{R}^2$: coordenadas del punto $i$ (en nuestro caso, ($x,y$)).
* $\boldsymbol{\mu}_k \in \mathbb{R}^2$: centroide del clúster $k$ (promedio de las $x$ y de las $y$).

> Interpretación práctica: en 2D, $\mu_k = (\bar{x}_k, \bar{y}_k)$

$$
\bar{x}*k = \frac{1}{ \lvert C_k \rvert}\sum*{x_i \in C_k} x_i^{(x)}
$$

$$
\bar{y}*k = \frac{1}{|C_k|}\sum*{x_i \in C_k} x_i^{(y)}
$$

---

# 3) Script que calcula centroides y grafica (5 equipos)

El siguiente script:

* Lee el CSV `cluster_rush_5_teams.csv`.
* Ejecuta **K-Means con (K=3)** por cada equipo.
* **Imprime los centroides** (coordenadas) y **genera una gráfica por equipo** con puntos coloreados por clúster y centroides marcados con “X”.

```python
"""
Cluster Rush - Ground Truth Script
----------------------------------
Lee 'cluster_rush_5_teams.csv', calcula K-Means (K=3) por equipo,
imprime centroides y grafica cada equipo en una figura separada.

Requisitos:
  pip install scikit-learn matplotlib pandas
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

# 1) Cargar datos
df = pd.read_csv("cluster_rush_5_teams.csv")

equipos = sorted(df["team"].unique())
resultados = {}

for team in equipos:
    X = df.loc[df["team"] == team, ["x", "y"]].to_numpy()

    # 2) Ajustar KMeans con K=3
    km = KMeans(n_clusters=3, random_state=0, n_init="auto")
    labels = km.fit_predict(X)
    centroids = km.cluster_centers_

    resultados[team] = centroids

    # 3) Plot
    plt.figure()
    plt.scatter(X[:, 0], X[:, 1], c=labels, alpha=0.8)
    plt.scatter(centroids[:, 0], centroids[:, 1], marker="X", s=200)
    plt.title(f"Cluster Rush - {team}")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.tight_layout()

# 4) Mostrar resultados numéricos
print("\n=== Centroides por equipo (x, y) ===")
for team, C in resultados.items():
    print(f"{team}:")
    for k, (cx, cy) in enumerate(C, start=1):
        print(f"  Cluster {k}: ({cx:.3f}, {cy:.3f})")

plt.show()
```
