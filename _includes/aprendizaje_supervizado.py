import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, accuracy_score, confusion_matrix
from sklearn.linear_model import LogisticRegression, Perceptron
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier

# Importar
df = pd.read_csv("sensor_readings_2.csv")
df = df.dropna()
if df['class'].dtype == 'object':
    le = LabelEncoder()
    df['class'] = le.fit_transform(df['class'])
    clases = le.classes_
else:
    clases = sorted(df['class'].unique())
X = df.drop('class', axis=1)
y = df['class']
scaler = StandardScaler()
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.25, random_state=42, stratify=y
)

# 8. Definir modelos a comparar
modelos = {
    "Logistic Regression": LogisticRegression(max_iter=1000),
    "Perceptron": Perceptron(),
    "SVM": SVC(),
    "KNN (k=5)": KNeighborsClassifier(n_neighbors=5),
    "Decision Tree": DecisionTreeClassifier()
}

# Entrenamiento y evaluación
for nombre, modelo in modelos.items():
    print(f"======")
    print(f"Modelo: {nombre}")
    modelo.fit(X_train, y_train)
    y_pred = modelo.predict(X_test)

    acc = accuracy_score(y_test, y_pred)
    print(f"Accuracy: {acc:.4f}")
    print("Reporte de Clasificación:")
    print(classification_report(y_test, y_pred, target_names=clases.astype(str)))
    
    cm = confusion_matrix(y_test, y_pred)
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=clases, yticklabels=clases)
    plt.title(f'Matriz de Confusión - {nombre}')
    plt.xlabel('Predicción')
    plt.ylabel('Verdadero')
    plt.show()