---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Técnicas principales de Aprendizaje No Supervisado: K-Means, DBSCAN y PCA

## Objetivo

Que los estudiantes comprendan y apliquen las **técnicas principales de aprendizaje no supervisado** —**K-Means**, **DBSCAN** y **PCA**— utilizando datos reales provenientes de sensores conectados a un **Arduino Nano**, como parte del flujo completo de análisis: recolección → preprocesamiento → reducción de dimensionalidad → clustering.

## Aportación a los Atributos de Egreso

Esta actividad fortalece los **Atributos de Egreso 2 y 7, nivel avanzado (AE2A y AE7A)**.
El **AE2A** se desarrolla al implementar un sistema embebido capaz de recolectar, procesar y analizar datos mediante algoritmos de agrupamiento. El **AE7A** se evidencia durante la colaboración para construir el circuito, compartir datasets y discutir la interpretación de los resultados de clustering y sus implicaciones en el diseño de sistemas inteligentes embebidos.

## Método de enseñanza

Se empleará **Aprendizaje Basado en Proyectos (ABP)** combinado con **Aprendizaje Experiencial**, conforme a las metodologías del documento institucional.

Los estudiantes realizan un proyecto de clustering completo aplicado sobre sensores reales, construyendo incrementalmente el circuito, el dataset y los modelos no supervisados.

## Criterios de evaluación

| Criterio                        | Descripción                                                                            | Puntaje |
| ------------------------------- | -------------------------------------------------------------------------------------- | ------- |
| Circuito y recolección de datos | El circuito LM35 + HC-SR04 + LDR + A3144 + LED RGB funciona y entrega datos coherentes | 25%     |
| Implementación del clustering   | K-Means y DBSCAN correctamente ejecutados y comentados                                 | 40%     |
| Interpretación de resultados    | Identifica patrones, clusters y ruido con base en características físicas              | 20%     |
| Evidencias (Google Docs)        | Código + fotos + reflexiones breves                                                    | 15%     |

---

# Desarrollo del tema

## K-Means: agrupamiento basado en distancia

K-Means divide los datos en *K* grupos minimizando la distancia entre los puntos y el centroide del cluster.

La función objetivo es minimizar:

$$
J = \sum_{k=1}^{K} \sum_{x_i \in C_k} | x_i - \mu_k |^2
$$

* $C_k$ = conjunto de puntos en el cluster *k*
* $\mu_k$ = centroide del cluster

K-Means asume clusters “esféricos”, basados en distancia Euclidiana.

### Ejercicio 

#### Circuito

El Arduino Nano recolecta datos de:

* **Temperatura** (LM35 – A0)
* **Distancia** (HC-SR04 – D2/D3)
* **Luz** (LDR – A1)
* **Hall** (A3144 - D4)

Activa 3 actuadores representados en un:

* **LED RGB** D5 (R), D6 (G), D9 (B)

#### Caso

Un robot detecta **patrones de falla** sin supervisión:

* ruido eléctrico
* cambios anómalos de distancia
* oscilaciones de luz por falso contacto
* detección intermitente del Hall

| Cluster | Temp      | Luz       | Dist           | Hall | Interpretación (falla/no falla)          |
| ------- | --------- | --------- | -------------- | ---- | ---------------------------------------- |
| 0       | Normal    | Normal    | Estable        | 0    | Operación normal                         |
| 1       | Normal    | Oscila    | Estable        | 0    | “Falla probable en LDR o cableado”       |
| 2       | Inestable | Inestable | Saltos bruscos | 1    | “Perturbación magnética o interferencia” |

Después de obtener lecturas, se envían por Serial y en Python ejecutamos K-Means.
El LED RGB mostrará el cluster asignado:

* Cluster 0 → Rojo
* Cluster 1 → Verde
* Cluster 2 → Azul

#### Circuito 

* LM35 → A0
* LDR → A1
* HC-SR04 → D2 Trig, D3 Echo
* A3144 → D4
* LED RGB → D5 (R), D6 (G), D9 (B)

#### Script Arduino

```cpp
void setup() {
  Serial.begin(9600);
  pinMode(5, OUTPUT); // R
  pinMode(6, OUTPUT); // G
  pinMode(9, OUTPUT); // B
  pinMode(4, INPUT);  // A3144 Hall digital
}

void loop() {
  int temp = analogRead(A0);     // Convertir con fórmula ya vista
  int luz  = analogRead(A1);
  long dist = medirDistancia();  // pseudocódigo: usa HC-SR04

  int hall = digitalRead(4);

  // Enviar CSV
  Serial.print(temp); Serial.print(",");
  Serial.print(luz);  Serial.print(",");
  Serial.print(dist); Serial.print(",");
  Serial.println(hall);

  delay(200);
}
```

#### Script Python 

```python
from sklearn.cluster import KMeans
import pandas as pd

# df = pd.read_csv("lecturas_clase.csv")

X = df[["temp","luz","dist","hall"]]

# K=3 clusters
kmeans = KMeans(n_clusters=3)
labels = kmeans.fit_predict(X)

df["cluster"] = labels

# Después enviarán el cluster al Arduino 
print(df.head())
```

## DBSCAN: densidad y detección de ruido

DBSCAN (Density-Based Spatial Clustering of Applications with Noise) crea clusters donde los puntos están densamente conectados. Identifica puntos “ruido” (outliers).

Los dos parámetros clave son:

* $\epsilon$: radio de vecindad
* minPts: número mínimo de vecinos

Los puntos se clasifican en DBSCAN como:

* **Core point** si tiene ≥ minPts dentro de $\epsilon$
* **Border point** si está cerca de un core pero no cumple minPts
* **Noise** si no pertenece a ningún cluster

### Ejercicio

#### Caso

El sensor **A3144** detecta campos magnéticos (0 o 1).
Si acercan un imán, las lecturas cambian.
DBSCAN puede detectar “eventos de magnetización” como clusters densos.
Lecturas esporádicas o ruido del sensor se marcan como **-1**.
En este sistema podriamos implementar 3 acuadores con un LED RGB donde:

* Cluster 0: Verde
* Cluster 1: Azul
* **Ruido (-1)**: Rojo fijo

```python
from sklearn.cluster import DBSCAN

# df = pd.read_csv("lecturas_clase.csv")
X = df[["temp","luz","dist","hall"]]

db = DBSCAN(eps=0.5, min_samples=5)
labels = db.fit_predict(X)

df["cluster_dbscan"] = labels

print(df["cluster_dbscan"].value_counts())
```

## 3. PCA — Recordatorio breve

Recordemos que PCA transforma:

$$
Z = XW
$$

donde los autovectores $W$ maximizan la varianza.

Usaremos PCA solo para visualizar los clusters obtenidos con K-Means y DBSCAN.

---

### Ejercicio 3 — Visualización de clusters

```python
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

X = df[["temp","luz","dist","hall"]]
pca = PCA(n_components=2)
Z = pca.fit_transform(X)

plt.scatter(Z[:,0], Z[:,1], c=df["cluster"])
plt.title("K-Means en espacio PCA")
plt.show()
```

---

# Práctica (20 minutos)

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

---

# Entregables

Un **Google Docs** con:

1. Foto del circuito completo.
2. Capturas del serial y el CSV.
3. Código Arduino y Python.
4. Gráficas de K-Means y DBSCAN.
5. Reflexión de la práctica.

---

# Actividad de gamificación

## “Cluster Battle Royale”

1. En grupos de 3–4 estudiantes.
2. Cada equipo recibe **10 tarjetas** con observaciones reales generadas por el profesor (temp, luz, dist, hall).
3. En 90 segundos, deben agrupar las tarjetas **usando reglas de clustering verbal**:

   * “Estos puntos están cerca en luz y distancia.”
   * “Este parece ruido, está lejos de todos.”
4. Cada equipo explica su clusterización.
5. El profesor revela los clusters reales (generados con Python).
6. Se otorgan puntos por:

   * Cluster correcto
   * Detectar ruido
   * Justificación clara

