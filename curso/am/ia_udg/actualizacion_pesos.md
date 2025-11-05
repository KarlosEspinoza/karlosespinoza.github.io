---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actualización de pesos

## Ecuación general de actualización de pesos

$$
w_{ij}^{(t+1)} = w_{ij}^{(t)} - \eta \frac{\partial E}{\partial w_{ij}}
$$

### donde:

* $w_{ij}^{(t)}$: Peso actual que conecta la neurona ( i ) con la neurona ( j )
* $w_{ij}^{(t+1)}$: Peso actualizado después de un paso de aprendizaje
* $\eta$: Tasa de aprendizaje (*learning rate*), controla el tamaño del ajuste
* $E$: Función de error o **función de costo**, normalmente el **Error Cuadrático Medio (ECM)** o la **Entropía Cruzada**
* $\frac{\partial E}{\partial w_{ij}}$: Derivada parcial del error respecto al peso, obtenida mediante **retropropagación**

### Interpretación intuitiva

El algoritmo mide **cuánto cambia el error** si un peso cambia ligeramente.
Luego ajusta el peso en **la dirección opuesta al gradiente** (de ahí “descenso de gradiente”) para **reducir el error**.

## Ejemplo en una red simple

Supón una sola neurona con función de activación sigmoide:

$$
y = f(z) = \frac{1}{1 + e^{-z}}, \quad z = \sum_i w_i x_i + b
$$

El error (para un solo ejemplo) es:

$$
E = \frac{1}{2}(y_{real} - y_{pred})^2
$$

Entonces, el gradiente del error respecto a un peso ( w_i ) es:

$$
\frac{\partial E}{\partial w_i} = -(y_{real} - y_{pred}) \cdot f'(z) \cdot x_i
$$

Sustituyendo esto en la ecuación de actualización:

$$
w_i^{(t+1)} = w_i^{(t)} + \eta (y_{real} - y_{pred}) f'(z) x_i
$$

### donde:

* $f'(z)$: derivada de la función de activación (por ejemplo, en la sigmoide ( f'(z) = f(z)(1 - f(z)) ))
* $y_{real} - y_{pred}$: error entre la salida deseada y la predicha
* $x_i$: entrada correspondiente
* $t$: epoca
