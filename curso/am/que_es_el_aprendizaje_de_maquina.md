---
layout: default
title: Ejercicio Ingenieria de datos
---
# ¿Qué es el aprendizaje de máquina?

## 1.1.1 Definición y conceptos básicos

### ¿Qué es el Aprendizaje de Máquina?

El **Aprendizaje de Máquina (Machine Learning)** es una rama de la inteligencia artificial que se enfoca en construir programas capaces de **aprender de los datos** sin estar explícitamente programados.

Según Arthur Samuel (1959):

> *"Machine learning is the field of study that gives computers the ability to learn without being explicitly programmed."*

---

### Elementos básicos de un sistema de aprendizaje

- **Datos de entrada**: un conjunto de ejemplos representados como vectores.
- **Modelo**: función matemática que relaciona entradas con salidas.
- **Algoritmo de aprendizaje**: ajusta el modelo a partir de los datos.
- **Función objetivo**: criterio que el algoritmo intenta optimizar (por ejemplo, minimizar el error).
- **Salida**: una predicción o decisión generada por el modelo.

---

### Representación matemática del aprendizaje

Un algoritmo de aprendizaje busca una función:

$$
f : X \rightarrow Y
$$

donde:
- $ X $ es el espacio de entrada (conjunto de características o atributos),
- $ Y $ es el espacio de salida (clases o valores continuos),
- $ f $ es una función que aproxima la relación entre entrada y salida.

---

### Conjunto de entrenamiento

Se parte de un conjunto de datos $ D $ con $ m $ ejemplos:

$$
D = \{ (x^{(1)}, y^{(1)}), (x^{(2)}, y^{(2)}), \ldots, (x^{(m)}, y^{(m)}) \}
$$

donde cada:
- $x^{(i)} \in \mathbb{R}^n$ es un vector de entrada con $ n $ atributos (características),
- $ y^{(i)} $ es la salida esperada (etiqueta o valor real).

---

### Objetivo del aprendizaje

El modelo genera una **hipótesis** $ h(x) $ que intenta aproximar la salida deseada $ y $:

$$
h(x) \approx y
$$

El **error de hipótesis** se mide con una función de costo (por ejemplo, error cuadrático medio para regresión o entropía cruzada para clasificación).

---

### Tipos de Aprendizaje de Máquina

- **Supervisado**: se aprende a partir de datos etiquetados $ (x, y) $.
- **No supervisado**: el modelo explora la estructura de los datos sin etiquetas.
- **Por refuerzo**: un agente aprende por ensayo y error mediante recompensas.

---

### Ejemplo

En estos [datos](/datos/area_dataset.csv) cada fila representa un ejemplo del conjunto de entrenamiento para el modelo de área, con las siguientes columnas:

- **Ancho**: característica de entrada
- **Alto**: característica de entrada
- **Area**: salida (etiqueta)

Aqui:

$$
X = [Ancho, Alto]
$$

$$
Y = Área
$$

$$
f(X) = Ancho * Alto
$$

Conjunto de entrenamiento 

$$
D = \{(x^{i}, y^{i}), \ldots ,(x^{i}, y^{m})\}
$$

En los datos, cuanto vale $m$?

Ahora veremos como trabajarlos con python.
```python
{% include 0_introduccion/leer_area_simple.py %}
```

Podemos utilizar el módulo CSV.
```python
{% include 0_introduccion/leer_area_csv.py %}
```

