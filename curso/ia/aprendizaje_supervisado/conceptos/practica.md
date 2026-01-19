---
layout: default
title: Aprendizaje de máquina
---
[Inicio](/curso/ia)

# Concepto y aplicaciones

## Práctica

## Objetivo

Entrenar un **modelo de regresión logística** para clasificar las acciones de un robot seguidor de pared (recto, girar izquierda, girar derecha) usando el dataset *Wall-Following Robot* (`sensor_readings_4.csv`, para no abrumar con 24 sensores).

* Dataset: [Wall-following Robot](https://www.kaggle.com/datasets/uciml/wall-following-robot?resource=download)


## Problema

El robot cuenta con 4 sensores ultrasónicos que miden distancias alrededor del chasis.
A partir de estas lecturas debe decidir si **avanza recto**, **gira a la izquierda** o **gira a la derecha**.

Con un modelo de **regresión logística multiclase (softmax)** entrenaremos un clasificador para tomar esta decisión.


## Instrucciones

1. Usa el archivo `sensor_readings_4.csv`.
2. Identifica la columna de etiquetas (clase).
3. Divide datos en entrenamiento (70%) y prueba (30%).
4. Entrena un modelo de regresión logística con regularización L2.
5. Evalúa con **accuracy** y **matriz de confusión**.
6. Reflexiona: ¿qué tipo de errores serían más graves para el robot?


## Script

```python
# -*- coding: utf-8 -*-
"""
Práctica: Regresión Logística Multiclase con sensor_readings_4.csv
Curso: Ingeniería Mecatrónica 7° semestre

Conceptos clave:
- Aprendizaje supervisado: usamos pares (X, y) para entrenar.
- Regresión logística (multiclase con softmax).
- Entropía cruzada: pérdida que penaliza predicciones incorrectas.
- Regularización L2: evita que los pesos crezcan demasiado.
"""

import pandas as pd
from pathlib import Path
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report

# -----------------------------
# 1) Cargar dataset
# -----------------------------
CSV_FILE = "sensor_readings_4.csv"
assert Path(CSV_FILE).exists(), f"Coloca {CSV_FILE} en el directorio de trabajo"
df = pd.read_csv(CSV_FILE)

# Identificar etiqueta (puede llamarse 'Class' o similar)
y_col = [c for c in df.columns if c.lower() in ["class","label","target"]][0]
X = df.drop(columns=[y_col]).values
y = df[y_col].values

print("Clases disponibles:", set(y))

# -----------------------------
# 2) Dividir datos
# -----------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, stratify=y, random_state=42
)

# -----------------------------
# 3) Escalar y entrenar modelo
# -----------------------------
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.transform(X_test)

# -----------------------------
# 4) Entrenar modelo
# -----------------------------
# Regresión logística multinomial (softmax)
# C = 1/λ controla la regularización L2
clf = LogisticRegression(multi_class="multinomial", solver="lbfgs", C=1.0, max_iter=300)
clf.fit(X_train, y_train)

# -----------------------------
# 4) Evaluar modelo
# -----------------------------
y_pred = clf.predict(X_test)

print("Accuracy en test:", accuracy_score(y_test, y_pred))
print("\nReporte de clasificación:\n", classification_report(y_test, y_pred))
print("\nMatriz de confusión:\n", confusion_matrix(y_test, y_pred))

# -----------------------------
# 5) Reflexión
# -----------------------------
# - ¿Qué clases confunde más el modelo?
# - Si confunde "seguir recto" con "girar", ¿qué implica físicamente?
# - ¿Aumentarías λ (es decir, reducir C) para estabilizar los pesos?
```

