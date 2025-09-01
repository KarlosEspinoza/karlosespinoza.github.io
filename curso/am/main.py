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

# Identificar etiqueta 
y_col = "label" # Las etiqueta esta en la cuarta columna, pero tienes que ponerle cabecera a tus datos para que la identifique
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

# Regresión logística multinomial (softmax)
# C = 1/λ controla la regularización L2
clf = LogisticRegression(solver="lbfgs", C=1.0, max_iter=300)
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

