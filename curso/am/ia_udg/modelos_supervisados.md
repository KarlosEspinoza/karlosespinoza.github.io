---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad: Modelos Supervisados: Regresión y Clasificación

## Objetivo

Que el estudiante **comprenda y aplique** los conceptos de **regresión y clasificación** en proyectos de aprendizaje supervisado, utilizando lecturas de sensores en Arduino Nano y actuadores para generar datos, entrenar modelos simples en Python y evaluar su desempeño.

---

## Aportación a los Atributos de Egreso

Esta actividad contribuye al **diseño e implementación de sistemas de automatización y control (AE2A)**, al requerir que los estudiantes construyan un modelo supervisado con datos obtenidos de sensores reales. También fortalece el **trabajo colaborativo y liderazgo (AE7A)**, ya que los alumnos trabajarán en parejas para integrar hardware y software, organizar el flujo de datos y discutir la validez de sus resultados en condiciones reales e inciertas.

---

## Método de enseñanza

Se utilizará **Aprendizaje Experiencial y Aprendizaje Basado en la Indagación**. Los estudiantes manipularán sensores y actuadores, generarán datos etiquetados y aplicarán modelos supervisados en Python para resolver problemas reales de mecatrónica, respondiendo preguntas clave como: ¿los datos siguen una relación lineal o deben clasificarse en categorías?

---

## Criterios de evaluación

La evidencia se revisará mediante lista de cotejo:

* ¿Incluyó código y ejecución en Arduino y Python?
* ¿Aplicó correctamente un modelo de **regresión** y uno de **clasificación**?
* ¿Se entregaron capturas o fotos como evidencia de funcionamiento?
* ¿El trabajo refleja colaboración en parejas (aportaciones de ambos integrantes)?

---

## Desarrollo del Tema

### 1. Regresión

#### Explicación

La **regresión** busca modelar la relación entre una variable dependiente $y$ y una o más variables independientes $x$.
El modelo más simple es la **regresión lineal**:

$$
y = \beta_0 + \beta_1 x + \varepsilon
$$

donde:

* $y$: variable objetivo (ej. temperatura real)
* $x$: variable predictora (ej. voltaje del LM35)
* $\beta_0, \beta_1$: parámetros del modelo
* $\varepsilon$: error aleatorio

#### Ejemplo

Un **Arduino Nano** mide la temperatura con un **LM35**. El voltaje de salida se convierte a °C con una fórmula lineal. La regresión lineal permite calibrar el sensor comparando sus lecturas con un termómetro de referencia, corrigiendo desviaciones para mejorar la precisión.

#### Ejercicio (Arduino Nano + LM35 + LM35(referencia))

Conecta 2 LM35 a un Arduino.
Guarda los datos de ambos sensores en un CSV en dos columnas: lectura_LM35 y temp_referencia.

<img src="/image/ia/lm35_lm35.png" width="600"/>

**Python (regresión lineal con scikit-learn):**

```python
import csv
import numpy as np
from sklearn.linear_model import LinearRegression

# TODO: Leer datos CSV con dos columnas: lectura_LM35, temp_referencia
# pista: usen csv.reader como antes

X = np.array(lectura_lm35).reshape(-1, 1)
y = np.array(temp_referencia)

modelo = LinearRegression().fit(X, y)
beta_0 = modelo.intercept_
beta_1 = modelo.coef_[0]


print(f"Ecuación: y = {beta_0:.2f} + {beta_1:.2f}x")
```
























### 2. Clasificación

#### Explicación

La **clasificación** asigna una etiqueta discreta a un conjunto de datos. Un modelo simple es el **clasificador k-NN (k-nearest neighbors)**:

$$
\hat{y} = \text{modo}\{ y_i : x_i \in \text{vecinos}_k(x)\}
$$

donde:

* $\hat{y}$: clase predicha
* $x$: vector de entrada
* $\text{vecinos}_k(x)$: los k puntos de entrenamiento más cercanos

#### Ejemplo

Un Arduino Nano usa un **HC-SR04** para medir distancia y controla un **servo** que abre o cierra una compuerta. Se etiqueta cada lectura como “Cerca” (clase 0) o “Lejos” (clase 1). El modelo de clasificación (k-NN) puede aprender a predecir automáticamente la clase de nuevas distancias.

#### Ejercicio (Arduino Nano + HC-SR04 + SG90)

<img src="/image/ia/lm35_hc-sr04_sg90.png" width="600"/>

```cpp
// Arduino: HC-SR04 (trig=9, echo=10), SG90 en D3
#include <Servo.h>
Servo servo;

const int trigPin = 9, echoPin = 10;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  servo.attach(3);
}

void loop() {
  // TODO: medir distancia con HC-SR04 (ya lo saben hacer)
  // guardar distancia en cm
  // etiquetar como 0 (cerca) si <20 cm, 1 (lejos) si >=20 cm
  // imprimir: distancia, etiqueta
}
```

**Python (clasificación k-NN):**

```python
import csv
import numpy as np
from sklearn.neighbors import KNeighborsClassifier

# TODO: Leer CSV con columnas: distancia, etiqueta

X = np.array(distancias).reshape(-1, 1)
y = np.array(etiquetas)

modelo = KNeighborsClassifier(n_neighbors=3).fit(X, y)

nueva = [[15.0]]  # distancia de prueba
print("Clase predicha:", modelo.predict(nueva))
```

---

### 3. Comparación Regresión vs Clasificación

| Aspecto             | Regresión                    | Clasificación                   |
| ------------------- | ---------------------------- | ------------------------------- |
| Variable objetivo   | Continua (°C, voltaje, etc.) | Discreta (0/1, Cerca/Lejos)     |
| Ejemplo Mecatrónica | Calibrar sensor LM35         | Detectar proximidad con HC-SR04 |
| Modelo usado        | Lineal, polinomial           | k-NN, Árbol de decisión         |

---

## Práctica (para casa, \~20 min)

En parejas, recolecten datos con **dos sensores distintos** (ej. LDR + LM35) y activen un actuador (ej. LED RGB o buzzer).

1. Usen **regresión** para calibrar uno de los sensores (ej. LDR vs lux).
2. Usen **clasificación** para predecir el estado del actuador (ej. LED encendido/apagado).
3. Guarden datos en CSV y apliquen ambos modelos en Python.

**Script Python base (semi-completo):**

```python
import csv
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsClassifier

# TODO: Leer datos de sensores desde 'datos.csv'
# Estructura esperada: sensor1, sensor2, actuador

# --- Parte 1: Regresión ---
X_reg = np.array(sensor1).reshape(-1,1)
y_reg = np.array(valor_referencia)
modelo_reg = LinearRegression().fit(X_reg, y_reg)
print("Regresión:", modelo_reg.intercept_, modelo_reg.coef_)

# --- Parte 2: Clasificación ---
X_clf = np.array(sensor2).reshape(-1,1)
y_clf = np.array(actuador)  # etiquetas 0/1
modelo_clf = KNeighborsClassifier(n_neighbors=3).fit(X_clf, y_clf)
print("Clasificación:", modelo_clf.predict([[umbral]]))
```

---

## Entregables

* Código Arduino y Python de los ejercicios y práctica.
* Capturas/fotos de ejecución y montaje del circuito.
* Breve descripción (3–5 líneas) de cómo aplicaron regresión y clasificación.
* Evidencia entregada en **Google Docs** con código, capturas y texto breve.

---

## Actividad de Gamificación (5–10 min)

Haremos un juego llamado **“¿Regresión o Clasificación?”**.
En equipos, recibirán ejemplos de sistemas con sensores y actuadores. Su tarea será decidir rápidamente si el problema es de **regresión** (cuando la salida es un valor numérico continuo, como °C o cm) o de **clasificación** (cuando la salida es una categoría, como ON/OFF, Cerca/Lejos).

Cada respuesta correcta suma puntos, y si además proponen qué modelo usarían (ej. regresión lineal, k-NN), obtendrán puntos extra.
El equipo que acumule más puntos al final será el ganador.



**“Clasificador Relámpago”**

* La clase se divide en **2 equipos**.
* El profesor proyecta 10 valores de un sensor (ej. distancia de HC-SR04).
* Cada equipo debe decidir rápidamente si cada valor corresponde a la clase **“Cerca”** o **“Lejos”** según un umbral.
* Se otorgan puntos por rapidez y precisión.
* Equipo con más aciertos gana **puntos extra o premio sorpresa**.

## Actividad Extra

Si quieres aprender más sobre este tema, te invito a revisar [este material](modelos_supervisados_extra).

