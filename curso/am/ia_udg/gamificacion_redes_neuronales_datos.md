---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad de Gamificación: Redes Neuronales: Datos

Estas combinaciones representan lecturas simuladas de **dos sensores**, por ejemplo:

* (x_1): nivel de luz (LDR, 0–1 escala normalizada)
* (x_2): temperatura (LM35, 0–1 escala normalizada)

## Ecuación de referencia del juego

[
y = f(0.5x_1 + 0.3x_2 - 0.2)
]
[
f(x) = \frac{1}{1 + e^{-x}}
]

## Combinaciones por equipo

[CSV](gamificacion_redes_neuronales_datos.csv)

| Equipo |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |  x₁  |  x₂ |
| :----: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: | :--: | :-: |
|  **1** |  0.1 | 0.2 |  0.3 | 0.1 |  0.5 | 0.4 |  0.6 | 0.5 |  0.8 | 0.3 |  0.2 | 0.7 |  0.4 | 0.9 |  0.9 | 0.2 |  0.7 | 0.6 |  1.0 | 0.8 |
|  **2** |  0.2 | 0.1 |  0.4 | 0.3 |  0.6 | 0.2 |  0.3 | 0.6 |  0.5 | 0.8 |  0.8 | 0.1 |  0.9 | 0.4 |  0.1 | 0.9 |  0.7 | 0.7 |  1.0 | 0.5 |
|  **3** | 0.05 | 0.8 | 0.15 | 0.4 | 0.25 | 0.3 | 0.35 | 0.5 | 0.45 | 0.7 | 0.55 | 0.2 | 0.65 | 0.9 | 0.75 | 0.1 | 0.85 | 0.6 | 0.95 | 0.4 |
|  **4** |  0.1 | 0.5 |  0.2 | 0.8 |  0.4 | 0.9 |  0.6 | 0.7 |  0.3 | 0.4 |  0.8 | 0.6 |  0.5 | 0.3 |  0.7 | 0.2 |  0.9 | 0.1 |  1.0 | 0.5 |
|  **5** | 0.05 | 0.3 | 0.15 | 0.9 | 0.25 | 0.6 | 0.35 | 0.8 | 0.45 | 0.4 | 0.55 | 0.7 | 0.65 | 0.2 | 0.75 | 0.5 | 0.85 | 0.3 | 0.95 | 0.9 |

### Cómo usar estas combinaciones

1. Entrega a cada equipo su conjunto (puedes imprimirlos o proyectarlos).
2. Cada equipo calcula las **10 salidas** con la ecuación dada.
3. Deben determinar:

   * El valor de ( y ) (entre 0 y 1)
   * Si el valor es **mayor o menor a 0.5**, para decidir si el **servo se abre (ON)** o **cierra (OFF)**
4. Cada acierto vale 1 punto; gana el equipo con **más valores correctos**.
