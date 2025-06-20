---

layout: default
title: Supervisado, no supervisado, semi-supervisado y reforzado
---

# 1.2.1 Supervisado, no supervisado, semi-supervisado y reforzado

## Explicación teórica

### Introducción

El aprendizaje automático puede clasificarse en varias categorías según la manera en que el modelo aprende a partir de los datos.
Los cuatro tipos principales son:

- Aprendizaje supervisado
- Aprendizaje no supervisado
- Aprendizaje semi-supervisado
- Aprendizaje por refuerzo

A continuación, se describen detalladamente estos enfoques.

### Aprendizaje Supervisado

En este tipo de aprendizaje, el modelo se entrena con un conjunto de datos etiquetado, es decir, cada entrada tiene una salida conocida. 
El objetivo es que el modelo aprenda una función que relacione entradas con salidas.
Por ejemplo, la clasificación de correos como "spam" o "no spam".

**Ecuación básica:**

$$
y = f(\mathbf{x})
$$

donde:

* \$\mathbf{x}\$ representa las características de entrada
* \$y\$ es la salida etiquetada

El objetivo es encontrar \$\hat{f}\$ tal que \$\hat{f}(\mathbf{x}) \approx y\$ para nuevos ejemplos.

### Aprendizaje No Supervisado

Aquí, el modelo trabaja con datos sin etiquetar. 
El objetivo es identificar patrones o estructuras ocultas en los datos.
Por ejemplo, agrupamiento de clientes según sus hábitos de consumo.

**Algoritmos comunes:** K-means, PCA, DBSCAN.

### Aprendizaje Semi-Supervisado

Este enfoque combina una pequeña cantidad de datos etiquetados con una gran cantidad de datos no etiquetados para entrenar el modelo.
Suele ser útil cuando etiquetar los datos es costoso o difícil.
Por ejemplo, la clasificación de imágenes donde solo algunas están etiquetadas.

### Aprendizaje por Refuerzo

El agente aprende a tomar decisiones mediante prueba y error. 
Se recibe una recompensa por cada acción tomada y el objetivo es maximizar la recompensa acumulada a lo largo del tiempo.
Por ejemplo, un robot que aprende a caminar.

**Ecuación del valor esperado de recompensa:**

$$
V(S) = \mathbb{E}\left[\sum_{t=0}^{\infty} \gamma^t r_t \right]
$$

donde:

* \$V(S)\$ es el valor del estado \$S\$
* \$\gamma\$ es el factor de descuento
* \$r\_t\$ es la recompensa en el tiempo \$t\$

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Reinforcement_learning_diagram.svg/250px-Reinforcement_learning_diagram.svg.png" alt="Aprendizaje reforzado" style="background-color:white;">

### Comparación

| Tipo de aprendizaje | Datos etiquetados | Objetivo principal       | Ejemplo práctico              |
| ------------------- | ----------------- | ------------------------ | ----------------------------- |
| Supervisado         | Sí                | Predicción               | Clasificación de correos      |
| No supervisado      | No                | Descubrir patrones       | Agrupamiento de clientes      |
| Semi-supervisado    | Parcialmente      | Combinar ventajas        | Clasificación con pocos datos |
| Por refuerzo        | No (recompensas)  | Aprender política óptima | Agentes de videojuegos        |

## Práctica

### Objetivo de la práctica

Explorar y comparar los enfoques supervisado, no supervisado y semi-supervisado utilizando datos simulados, con el fin de observar cómo se comportan ante el mismo problema.

### Explicación del problema

Se generará un conjunto de datos que representa dos grupos de observaciones (dos clases) en un espacio bidimensional. Se aplicarán:

* Clasificación supervisada usando regresión logística.
* Agrupamiento no supervisado usando K-means.
* Clasificación semi-supervisada usando etiquetas parciales.

### Instrucciones

1. Ejecuta el script `generar_datos.py` para crear el archivo `datos_clasificacion.csv`.
2. Ejecuta el script `modelo_aprendizaje.py` para comparar los enfoques supervisado, no supervisado y semi-supervisado.

### Script: generar\_datos.py

```python
import numpy as np
import pandas as pd
from sklearn.datasets import make_classification

# Generar datos
X, y = make_classification(n_samples=500, n_features=2, n_classes=2,
                           n_informative=2, n_redundant=0, random_state=42)

# Guardar en CSV
df = pd.DataFrame(X, columns=['feature1', 'feature2'])
df['label'] = y
df.to_csv('datos_clasificacion.csv', index=False)
print("Archivo generado: datos_clasificacion.csv")
```

### Script: modelo\_aprendizaje.py

```python
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.cluster import KMeans
from sklearn.semi_supervised import SelfTrainingClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import numpy as np

# Cargar datos
df = pd.read_csv('datos_clasificacion.csv')
X = df[['feature1', 'feature2']].values
y = df['label'].values

# Aprendizaje supervisado
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
clf_sup = LogisticRegression()
clf_sup.fit(X_train, y_train)
y_pred_sup = clf_sup.predict(X_test)
print("Exactitud (supervisado):", accuracy_score(y_test, y_pred_sup))

# Aprendizaje no supervisado
kmeans = KMeans(n_clusters=2, random_state=42)
kmeans.fit(X)
y_pred_unsup = kmeans.labels_
print("Etiquetas (no supervisado):", np.unique(y_pred_unsup))

# Aprendizaje semi-supervisado
# Solo se etiquetan las primeras 50 muestras
y_partial = np.copy(y)
y_partial[50:] = -1

base_clf = LogisticRegression()
clf_semi = SelfTrainingClassifier(base_clf)
clf_semi.fit(X, y_partial)
y_pred_semi = clf_semi.predict(X)
print("Exactitud (semi-supervisado):", accuracy_score(y, y_pred_semi))

#print(len(y_pred_sup))
# Visualización de resultados
plt.figure(figsize=(12, 4))

plt.subplot(1, 3, 1)
plt.title("Supervisado")
plt.scatter(X_test[:, 0], X_test[:, 1], c=y_pred_sup, cmap='coolwarm')

plt.subplot(1, 3, 2)
plt.title("No Supervisado")
plt.scatter(X[:, 0], X[:, 1], c=y_pred_unsup, cmap='coolwarm')

plt.subplot(1, 3, 3)
plt.title("Semi-supervisado")
plt.scatter(X[:, 0], X[:, 1], c=y_pred_semi, cmap='coolwarm')

plt.tight_layout()
plt.show()
-----------------------

```

