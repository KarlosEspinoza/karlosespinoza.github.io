---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Práctica

En parejas:

1. Recolecten 60 lecturas usando los **4 sensores**:
   LM35, HC-SR04, LDR, A3144.
2. Generen un CSV.
3. Apliquen **K-Means** con K=3.
4. Apliquen **DBSCAN** con parámetros moderados.
5. Visualicen ambos modelos en PCA.
6. Escriban una reflexión (5–7 líneas):

   * ¿Qué sensores fueron más importantes para separar clusters?
   * ¿Qué puntos fueron marcados como ruido por DBSCAN?

### Script guía para la práctica (semi-completo)

```python
"""
Práctica: Clustering con sensores
"""
import pandas as pd
from sklearn.cluster import KMeans, DBSCAN
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

# 1. Leer CSV
# df = pd.read_csv("datos_practica.csv")

# 2. Escalamiento
# scaler = StandardScaler()
# X_scaled = scaler.fit_transform(df[["temp","luz","dist","hall"]])

# 3. K-Means
# kmeans = KMeans(n_clusters=3)
# labels_k = kmeans.fit_predict(X_scaled)

# 4. DBSCAN
# db = DBSCAN(eps=0.5, min_samples=5)
# labels_d = db.fit_predict(X_scaled)

# 5. PCA
# pca = PCA(n_components=2)
# Z = pca.fit_transform(X_scaled)

# 6. Gráficas
# plt.scatter(Z[:,0], Z[:,1], c=labels_k)
# plt.title("Clusters K-Means")
# plt.show()

# plt.scatter(Z[:,0], Z[:,1], c=labels_d)
# plt.title("Clusters DBSCAN")
# plt.show()
```


