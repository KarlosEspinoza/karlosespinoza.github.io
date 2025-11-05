---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Redes Neuronales

## Objetivo

Que el estudiante **comprenda, configure y entrene una red neuronal artificial (ANN)** para modelar relaciones no lineales en sistemas mecatrónicos, utilizando sensores y actuadores conectados a un **Arduino Nano** y **Python (scikit-learn)**.

## Aportación a los Atributos de Egreso

Esta actividad contribuye al **Atributo de Egreso 2 Nivel Avanzado (AE2A)** al requerir el **diseño e implementación de un sistema inteligente** que integre sensores, actuadores y una red neuronal básica para predicción o control.
Asimismo, fomenta el **Atributo de Egreso 7 Nivel Avanzado (AE7A)** al trabajar en equipos pequeños, planificar tareas y analizar incertidumbre en los datos experimentales y el entrenamiento del modelo.

## Método de enseñanza

Se empleará el método de **Aprendizaje Experiencial** y **Aprendizaje con Soporte Tecnológico**.
Los estudiantes manipularán sensores y actuadores reales, generarán datos, los procesarán con Python y explorarán cómo una red neuronal aprende patrones complejos mediante la retropropagación.

## Criterios de evaluación

| Criterio                                   | Descripción                                                | Ponderación |
| ------------------------------------------ | ---------------------------------------------------------- | ----------- |
| Implementación del circuito                | Sensor y actuador conectados correctamente al Arduino Nano | 25%         |
| Recolección de datos                       | CSV con lecturas de entrada y salida                       | 20%         |
| Entrenamiento de la red neuronal           | Script en Python funcional, con resultados interpretables  | 25%         |
| Trabajo colaborativo y documentación breve | Evidencia en Google Docs con fotos y conclusiones          | 15%         |
| Participación y actividad de gamificación  | Desempeño en dinámicas prácticas                           | 15%         |


## Desarrollo del tema

### Neurona artificial

Una **neurona artificial** simula el comportamiento de una biológica: recibe varias entradas ponderadas, las suma y aplica una función de activación para producir una salida:

$$
z = \sum_{i=1}^{n} w_i x_i + b
$$

$$
y = f\left(z\right)
$$

Donde:

* $x_i$: entradas (lecturas de sensores)
* $w_i$: pesos sinápticos (ajustables en el entrenamiento)
* $b$: sesgo (bias)
* $z$: señal de entrada a la neurona
* $f$: [función de activación](https://codificandobits.com/blog/funcion-de-activacion/) (ej. sigmoide, ReLU)
* $y$: salida (por ejemplo, posición de un servomotor)

#### Ejemplo

Un **Arduino Nano** lee un **LDR** y un **LM35**, y la red neuronal decide qué tanto abrir un **servomotor** para controlar la entrada de luz según la temperatura y luminosidad.

#### Ejercicio: Entradas y Salidas 

Conecta **LDR (A0)** y **LM35 (A1)** y un **Servo (D3)**.
El circuito inicial se usará durante toda la clase.

```cpp
// Arduino - Lectura de LDR y LM35
// TODO: completen la lectura analógica y el envío por Serial

void setup() {
  Serial.begin(9600);
}

void loop() {
  int luz = analogRead(A0);  // entrada 1
  int temp = analogRead(A1); // entrada 2
  int salida = ???;          // placeholder para salida deseada (servo)
  Serial.print(luz);
  Serial.print(",");
  Serial.println(temp);
  delay(500);
}
```

### Red Neuronal de una capa oculta

Una red neuronal multicapa (MLP) con una capa oculta se representa como:

$$
\mathbf{y} = f\left(\mathbf{W_2} \cdot g(\mathbf{W_1} \mathbf{x} + \mathbf{b_1}) + \mathbf{b_2}\right)
$$

donde:

* $\mathbf{x}$: vector de entradas (sensores)
* $\mathbf{W_1}$, $\mathbf{W_2}$: matrices de pesos
* $g$, $f$: funciones de activación
* $\mathbf{y}$: salida (posición o estado del actuador)

#### Ejemplo

Una red neuronal aprende la relación entre la **temperatura y la luz** para ajustar automáticamente el **ángulo del servo**.

#### Ejercicio 2: Entrenamiento en Python

```python
import csv
import numpy as np
from sklearn.neural_network import MLPRegressor

# TODO: Leer datos CSV (luz,temp,salida)
X = np.array([...])   # entradas: luz y temp
y = np.array([...])   # salida: posición del servo (0–180)

# Crear y entrenar la red neuronal
modelo = MLPRegressor(hidden_layer_sizes=(5,), activation='relu', max_iter=1000)
modelo.fit(X, y)

# Probar con un nuevo dato
nuevo = np.array([[300, 512]])  # luz media, temperatura media
print("Servo predicho:", modelo.predict(nuevo))
```

### Entrenamiento y generalización

Durante el entrenamiento, la red ajusta los pesos minimizando el **error cuadrático medio (ECM)**:

$$
ECM = \frac{1}{n}\sum_{i=1}^{n}(y_i - \hat{y_i})^2
$$

Esto mejora la **capacidad de generalización**, es decir, predecir correctamente datos que no ha visto antes.
Para más detalles sobre la actualización de pesos consulta [[actualización de pesos](actualizacion_pesos)].

#### Ejemplo

Si el sistema aprende a mover el servo correctamente con ciertas temperaturas y niveles de luz, debe comportarse coherentemente en condiciones intermedias sin necesidad de reprogramar.

#### Ejercicio: Validación del modelo

Usen datos nuevos para probar la red entrenada. Observen si el servo se mueve adecuadamente según la predicción.

---

## Práctica para casa

**Actividad:**
En parejas, utilicen **dos sensores diferentes** (por ejemplo, **LDR y HC-SR04**) y un **actuador** (por ejemplo, **LED RGB** o **Buzzer**) para que una red neuronal decida el color del LED o el tono del buzzer.

**Objetivo:**
Entrenar un modelo MLPClassifier que prediga una **categoría (color o tono)** a partir de las lecturas de los sensores.

**Python base (semi-completo):**

```python
import csv
import numpy as np
from sklearn.neural_network import MLPClassifier

# TODO: Leer datos de 'sensores.csv'
# columnas esperadas: sensor1, sensor2, color (0=azul,1=rojo,2=verde)

# Entrenamiento
modelo = MLPClassifier(hidden_layer_sizes=(6,), activation='relu', max_iter=1500)
modelo.fit(X, y)

# TODO: probar con nuevos valores
nueva_medicion = np.array([[val1, val2]])
pred = modelo.predict(nueva_medicion)
print("Color predicho:", pred)
```

---

## Entregables

1. **Código Arduino y Python** (subido en un Google Docs).
2. **Fotos o capturas** del montaje y resultados.
3. Breve texto (3–5 líneas) explicando qué aprendieron del comportamiento de la red neuronal.
4. Evidencia compartida en **parejas**.

---

## Actividad de Gamificación

### Neurona Relámpago

Cada equipo recibe una hoja con **10 combinaciones de entradas (x1, x2)**.
Deben calcular a mano (o mentalmente) la salida de una neurona:

$$
y = f\left(0.5x_1 + 0.3x_2 - 0.2\right)
$$

Donde $f$ es la función **sigmoide** ( $f(x) = 1/(1+e^{-x})$ ).

* Gana el equipo que acierte **más salidas correctas** en 5 minutos.
* Bonus si explican qué haría el servo según esa salida (por ejemplo, abrir o cerrar una compuerta).
* El equipo ganador obtiene **puntos extra o reconocimiento grupal**.
