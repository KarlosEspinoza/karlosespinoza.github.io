---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

## Aprendizaje No Supervisado: Concepto y aplicaciones

### Objetivo

Que el estudiante **comprenda el concepto de aprendizaje no supervisado y sus principales métodos (especialmente K-Means)**, aplicándolos para **agrupar lecturas de sensores** y detectar patrones de comportamiento en sistemas mecatrónicos usando **Arduino Nano** y **Python (scikit-learn)**.

### Aportación a los Atributos de Egreso

Esta actividad fortalece el **Atributo de Egreso 2 Nivel Avanzado (AE2A)** al diseñar un sistema inteligente que recolecta datos sensoriales reales y aplica algoritmos de agrupamiento para interpretar el entorno.
Asimismo, desarrolla el **Atributo de Egreso 7 Nivel Avanzado (AE7A)**, pues los estudiantes trabajarán en **equipos colaborativos**, analizando incertidumbre y divergencia en los datos experimentales, para tomar decisiones en conjunto.

### Método de enseñanza

Se empleará el **Aprendizaje Basado en Proyectos (ABP)** combinado con **Aprendizaje con Soporte Tecnológico**.
Los estudiantes construirán un circuito sensor–actuador, generarán un conjunto de datos reales y aplicarán K-Means para descubrir agrupamientos naturales sin etiquetas previas.

### Criterios de evaluación

| Criterio                             | Descripción                                                 | Ponderación |
| ------------------------------------ | ----------------------------------------------------------- | ----------- |
| Implementación del circuito          | Sensor y actuador conectados correctamente al Arduino Nano  | 25%         |
| Recolección y análisis de datos      | CSV con lecturas limpias, bien estructuradas                | 20%         |
| Aplicación del algoritmo K-Means     | Script funcional en Python con interpretación de resultados | 25%         |
| Trabajo colaborativo y documentación | Evidencia en Google Docs (fotos, código y conclusiones)     | 15%         |
| Participación y gamificación         | Desempeño en la dinámica práctica final                     | 15%         |

### Desarrollo del tema

#### Definición

El **aprendizaje no supervisado** busca **descubrir patrones ocultos** en los datos **sin etiquetas conocidas**.
Su objetivo es **encontrar estructura interna**, como agrupamientos o correlaciones.

$$
X = {x_1, x_2, \ldots, x_n}, \quad \text{donde } x_i \in \mathbb{R}^m
$$

Cada vector $x_i$ representa una observación (por ejemplo, una lectura de sensores).
El algoritmo intenta **agrupar** estos datos según su similitud sin conocer la clase verdadera.

#### Algoritmo K-Means

El algoritmo **K-Means** divide los datos en **K grupos (clusters)** minimizando la distancia entre cada punto y el **centroide** de su grupo:

$$
J = \sum_{k=1}^{K} \sum_{x_i \in C_k} ||x_i - \mu_k||^2
$$

donde:

* $K$: número de grupos,
* $C_k$: conjunto de puntos del cluster (k),
* $\mu_k$: centroide del cluster (k).

El objetivo es **minimizar $J$** (error de agrupamiento).

<img style="display: block;-webkit-user-select: none;margin: auto;background-color: hsl(0, 0%, 90%);" src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/K-means_convergence.gif/500px-K-means_convergence.gif">

[Imagen: Wikipedia](https://en.wikipedia.org/wiki/K-means_clustering)

#### Ejemplo

Un **Arduino Nano** mide **temperatura (LM35)** y **distancia (HC-SR04)**.
El sistema agrupa los datos automáticamente en tres clústeres:

* 🟩 “Frío y cercano”
* 🟦 “Medio”
* 🟥 “Caliente y lejano”

Esto permite, por ejemplo, que un **LED RGB** cambie de color según el grupo detectado, sin reglas programadas explícitamente.

---

#### Ejercicio: Recolección de datos

**Circuito base:**

* $x_1$: LM35: A0
* $x_2$: HC_SR04: Trig D8, Echo D9
* $y$: LED RGB: D3, D5, D6

<img src="/image/ia/lm35_hc-sr04_ledRGB.png" width="600"/>

**Arduino:**

```cpp
// Arduino - Recolección de datos para clustering
// TODO: completar lecturas analógicas y envío por Serial

void setup() {
  Serial.begin(9600);
}

void loop() {
  int temp = analogRead(A0);   // Temperatura (LM35)
  long dist = getDistance();   // TODO: Implementar función ultrasonido
  Serial.print(temp);
  Serial.print(",");
  Serial.println(dist);
  delay(500);
}

// long getDistance() -> usa pulseIn() con el HC-SR04
```

#### Ejercicio: Aplicación de K-Means en Python

```python
# ./train_model.py
import joblib # nos ayudara a guardar o cargar el modelo entrenado
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import csv

# TODO: Leer 'datos.csv' con columnas temp, dist
# X = np.array([...])

# Crear modelo de 3 grupos
modelo = KMeans(n_clusters=3, random_state=0)
modelo.fit(X)

# Guardar el modelo entrenado
joblib.dump(modelo, 'modelo_kmeans.pkl')
print("Modelo guardado exitosamente.")

# Visualizar resultados
plt.scatter(X[:,0], X[:,1], c=modelo.labels_)
plt.xlabel("Temperatura (LM35)")
plt.ylabel("Distancia (HC-SR04)")
plt.title("Agrupamiento de lecturas con K-Means")
plt.show()
```

**Interpretación:**
Cada color representa un patrón distinto de comportamiento sensorial.
El LED RGB puede configurarse para encender un color diferente según el cluster.

#### Ejercicio: Retroalimentación con actuador

```python
# ./deploy_model.py
import joblib

# TODO: Enviar color del cluster por Serial al Arduino

# Cargar el modelo entrenado
modelo = joblib.load('modelo_kmeans.pkl')

nueva_lectura = np.array([[410, 28]])
cluster = modelo.predict(nueva_lectura)[0]
print("Cluster:", cluster)
# Si cluster = 0 LED rojo
# Si cluster = 1 LED verde
# Si cluster = 2 LED azul
```

**Arduino:**
Recibe el número del clúster por Serial y ajusta el color del LED RGB (o enciende el correspondiente).

```cpp
if (Serial.available()) {
  int cluster = Serial.parseInt();
  if (cluster == 0) setColor(255, 0, 0);
  if (cluster == 1) setColor(0, 255, 0);
  if (cluster == 2) setColor(0, 0, 255);
}
```

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

🔧 **Objetivo:** el actuador debe comportarse distinto en cada cluster detectado (ej. tono o ángulo).

---

### 8. Entregables

1. **Google Docs** con:

   * Código Arduino y Python.
   * Capturas del circuito y gráfica de clusters.
   * Breve explicación (3–5 líneas) del patrón que encontraron.

### 9. Actividad de Gamificación: “Cluster Rush”

**Duración:** 8 minutos
**Dinámica:**

* Cada equipo recibe 15 puntos aleatorios (x, y) en un [CSV](ans_conceptos_gamificacion_data.csv).
* Deben **dibujar a mano los 3 posibles clusters** y estimar los centroides.
* Gana el equipo cuyos centroides estén **más cerca** de los del modelo real proyectado en pantalla.

💡 *Propósito:* Reforzar intuitivamente cómo el algoritmo agrupa por cercanía y ajusta los centroides.
