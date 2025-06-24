# TEMA 1.1.2 - Diferencias entre IA, Aprendizaje de Máquina y Aprendizaje Profundo

## Duración estimada: 0.5 horas (30 minutos)

---

## 1. Explicación Teórica

### ¿Qué es la Inteligencia Artificial (IA)?

La Inteligencia Artificial es un campo de la informática que estudia y desarrolla sistemas capaces de simular la inteligencia humana. Esto incluye razonar, aprender, planificar, percibir e incluso manipular objetos.

> **IA = Sistema que emula comportamientos inteligentes.**

### ¿Qué es el Aprendizaje de Máquina (Machine Learning)?

Es una subárea de la IA enfocada en crear algoritmos que **aprenden a partir de datos** para realizar tareas específicas sin estar programados de forma explícita.

> **ML = Sistemas que aprenden patrones a partir de datos.**

### ¿Qué es el Aprendizaje Profundo (Deep Learning)?

Es una subárea del Aprendizaje de Máquina basada en redes neuronales artificiales con muchas capas ("profundas"). Son especialmente útiles para tareas complejas como visión por computadora, reconocimiento de voz y procesamiento de lenguaje natural.

> **DL = ML + Redes Neuronales Profundas.**

### Relación entre ellos:

```plaintext
Inteligencia Artificial
 ├─ Aprendizaje de Máquina (ML)
     └─ Aprendizaje Profundo (DL)
```

---

## 2. Tabla Comparativa

| Característica    | IA                    | ML                               | DL                               |
| ----------------- | --------------------- | -------------------------------- | -------------------------------- |
| Definición        | Sistemas inteligentes | Algoritmos que aprenden de datos | Redes neuronales profundas       |
| Inspiración       | Comportamiento humano | Estadística, optimización        | Neurociencia, córtex visual      |
| Datos necesarios  | Variable              | Moderados                        | Grandes cantidades               |
| Computo requerido | Variable              | Medio                            | Alto                             |
| Ejemplos          | Chatbots, robots      | Clasificadores, predictores      | Reconocimiento facial, GPT, etc. |

---

## 3. Ecuaciones Relevantes

### Hipótesis del Aprendizaje de Máquina:

$$
\hat{y} = f(x) \Rightarrow \text{Aprendizaje} = \text{ajuste de } f \text{ para aproximar } y
$$

### Red Neuronal (simplificada):

$$
\hat{y} = \sigma(Wx + b)
$$

Donde:

* $W$: pesos
* $x$: entrada
* $b$: sesgo (bias)
* $\sigma$: función de activación

---

## 4. Práctica

### Objetivo

Que el estudiante entienda de forma aplicada las diferencias entre un modelo tradicional (IA), uno basado en aprendizaje de máquina (ML) y uno basado en redes neuronales (DL) mediante la predicción de "riesgo de sobrecalentamiento" en motores.

### Problema

Simular tres enfoques para predecir si un motor está en riesgo de sobrecalentamiento:

1. **IA**: reglas fijas basadas en umbrales.
2. **ML**: modelo entrenado con regresión logística.
3. **DL**: red neuronal simple.

### Instrucciones

1. Ejecutar el script generador de datos.
2. Analizar los datos generados.
3. Entrenar y comparar los modelos IA (reglas), ML (LogisticRegression), y DL (MLPClassifier).

### Script: Generador de datos

```python
import pandas as pd
import numpy as np

np.random.seed(0)
n = 200
temp = np.random.normal(70, 10, n)  # temperatura
vel = np.random.normal(1500, 300, n)  # velocidad RPM
vib = np.random.normal(0.5, 0.1, n)  # vibración (g)

# Riesgo de sobrecalentamiento (etiqueta): 1 si temp > 85 o vib > 0.65
riesgo = ((temp > 85) | (vib > 0.65)).astype(int)

# Crear DataFrame
df = pd.DataFrame({"Temperatura": temp, "Velocidad": vel, "Vibracion": vib, "Riesgo": riesgo})
df.to_csv("datos_motor.csv", index=False)
print("Archivo 'datos_motor.csv' generado.")
```

### Script: Comparación de modelos IA, ML y DL

```python
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import classification_report

# Cargar datos
df = pd.read_csv("datos_motor.csv")
X = df[["Temperatura", "Velocidad", "Vibracion"]]
y = df["Riesgo"]

# --- Modelo IA (reglas fijas) ---
def reglas_ia(row):
    return int(row["Temperatura"] > 85 or row["Vibracion"] > 0.65)

df["IA"] = df.apply(reglas_ia, axis=1)

# --- Modelo ML (regresión logística) ---
ml_model = LogisticRegression()
ml_model.fit(X, y)
df["ML"] = ml_model.predict(X)

# --- Modelo DL (Red Neuronal Multicapa) ---
dl_model = MLPClassifier(hidden_layer_sizes=(5,), max_iter=1000)
dl_model.fit(X, y)
df["DL"] = dl_model.predict(X)

# --- Evaluación ---
print("Evaluación ML:")
print(classification_report(y, df["ML"]))

print("Evaluación DL:")
print(classification_report(y, df["DL"]))

print("Evaluación IA:")
print(classification_report(y, df["IA"]))
```

> **Comentario en el código**:
>
> * La función `reglas_ia` representa un sistema experto basado en umbrales, característico de sistemas de IA clásicos.
> * `LogisticRegression` es un modelo de ML supervisado que ajusta una función $\hat{y} = \sigma(Wx + b)$.
> * `MLPClassifier` usa una red neuronal simple para ajustar múltiples capas, ilustrando el concepto de aprendizaje profundo.

---

Con esta actividad, el estudiante no solo **aprende las diferencias teóricas**, sino que **experimenta cómo se comportan en la práctica** los distintos enfoques de IA, ML y DL en un contexto de ingeniería mecatrónica.

