---
layout: default
title: Teoria
---

# Regresión Logística

La **Regresión Logística** es un algoritmo de **aprendizaje supervisado** utilizado para resolver problemas de **clasificación binaria** o **multiclase**. A pesar de su nombre, **no se utiliza para regresión**, sino para **clasificar datos en categorías discretas**.

## Funcionamiento

### 1. Combinación Lineal

Primero, se calcula una combinación lineal de las variables de entrada:

```math
z = w_0 + w_1 x_1 + w_2 x_2 + \cdots + w_n x_n
```

donde:

- $x_i$: características de entrada
- $w_i$: pesos del modelo (parámetros a aprender)

### 2. Función Sigmoide

La salida de la combinación lineal **z** se pasa a través de la función **sigmoide**, que convierte cualquier número real en un valor entre 0 y 1 (una probabilidad):

$$
\sigma(z) = \frac{1}{1 + e^{-z}}
$$

Este valor representa la **probabilidad de que la muestra pertenezca a la clase positiva (1)**.

### 3. Umbral de Clasificación

Se define un **umbral** (por defecto, 0.5). Si:

- $\sigma(z) \geq 0.5$: se clasifica como clase 1
- $\sigma(z) < 0.5$: se clasifica como clase 0



## Visualización de la Función Sigmoide

Su forma en S permite transformar cualquier entrada en una **probabilidad interpretable**.



## Regresión Logística Multiclase

Cuando hay más de dos clases, se utiliza una extensión llamada **Softmax**, que genera una probabilidad para cada clase:

$$
P(y = k \mid x) = \frac{e^{z_k}}{\sum_{j=1}^{K} e^{z_j}}
$$

Donde $z_k$ es la salida de la clase $k$.

---

## Entrenamiento del Modelo

La regresión logística aprende los pesos $w_i$ **maximizando la verosimilitud** (log-likelihood) de los datos observados. Esto se hace mediante un **algoritmo iterativo** como el **Gradiente Descendente**.

---

## Parámetro `max_iter`

En `scikit-learn`, el parámetro `max_iter` define el **número máximo de iteraciones** del optimizador:

- Si es **muy bajo**, el modelo puede **no converger**.
- Si es **muy alto**, el entrenamiento puede tardar más, pero **no mejora** si ya se alcanzó la solución óptima.

Siempre es buena práctica **verificar si el modelo ha convergido** (Scikit-learn emite un warning si no lo hace).

---

## Ventajas

- Simplicidad y fácil interpretación.
- Requiere poca potencia computacional.
- Produce probabilidades como salida.

## Desventajas

- Solo puede modelar relaciones **lineales** entre variables y la probabilidad.
- Sensible a variables correlacionadas o escalas diferentes.

---

## Casos de Uso Típicos

- Clasificación binaria: correo spam vs. no spam, defecto vs. no defecto.
- Problemas multiclase con softmax: diagnóstico médico, tipo de objeto en sensores, 