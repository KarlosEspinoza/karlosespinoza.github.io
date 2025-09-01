---
layout: default
title: Aprendizaje de máquina
---
[Curso: Aprendizaje de Máquina](index)

# 1) La ecuación general

Cuando entrenamos un modelo, no solo queremos minimizar el **error en los datos de entrenamiento** (riesgo empírico), sino también evitar que el modelo se **vuelva demasiado complejo**. Ahí entra la regularización:

$$
J(\theta) = \frac{1}{n}\sum_{i=1}^{n}\mathcal{L}\big(f_\theta(\mathbf{x}_i), y_i\big) \;+\; \lambda \lVert \theta \rVert_2^2
$$

---

# 2) Significado de cada término

* $\theta$: vector de parámetros del modelo (los pesos en regresión logística, en SVM, en una red neuronal, etc.).
* $n$: número de muestras de entrenamiento.
* $\mathcal{L}$: función de pérdida base (ejemplo: error cuadrático medio MSE, o entropía cruzada CE).
* $f_\theta(\mathbf{x}_i)$: predicción del modelo para la muestra $\mathbf{x}_i$.
* $y_i$: etiqueta real.
* $\lVert \theta \rVert_2^2 = \sum_j \theta_j^2$: la **norma L2** al cuadrado, suma de los pesos al cuadrado.
* $\lambda$: hiperparámetro de regularización que controla **cuánto penalizamos** los parámetros grandes.

---

# 3) Intuición

* El primer término: asegura que el modelo **aprenda de los datos**.
* El segundo término: asegura que el modelo **no memorice ruido** ni use pesos enormes.
* Con $\lambda = 0$: no hay regularización (riesgo de sobreajuste).
* Con $\lambda$ muy grande: los pesos se vuelven cercanos a 0 (subajuste).

Es como añadir un resorte que **jala los parámetros hacia 0**, evitando que crezcan demasiado.

---

# 4) Ejemplo mecatrónico

Imagina un robot con Arduino Nano y **24 sensores ultrasónicos** (HC-SR04) alrededor de su chasis.

* Si no regularizas, el modelo puede asignar un **peso enorme** a un sensor lateral que justo en tus datos de entrenamiento tenía valores raros. Eso hará que el robot **gire bruscamente** cada vez que ese sensor detecte un eco espurio.
* Con **L2**, los pesos se suavizan y las decisiones se basan en **el patrón conjunto** de sensores. El robot sigue la pared con más estabilidad y menos “temblores” en el servo.

---

# 5) Visualización 

* **Sin L2:** superficie de error con muchos mínimos, el modelo cae en un valle muy estrecho (memoriza).
* **Con L2:** la penalización hace que el mínimo se encuentre en una región más amplia, donde los pesos son pequeños → mejor **generalización**.

---

# 6) Tabla de comparación rápida

| Parámetro $\lambda$  | Efecto en pesos                    | Riesgo                              |
| -------------------- | ---------------------------------- | ----------------------------------- |
| $\lambda = 0$        | Pesos grandes posibles             | Sobreajuste                         |
| $\lambda$ moderado   | Pesos más pequeños, modelo estable | Generalización adecuada             |
| $\lambda$ muy grande | Pesos casi en 0                    | Subajuste (modelo demasiado simple) |

---

# 7) Fórmula en regresión lineal regularizada (ejemplo sencillo)

Si el modelo es:

$$
\hat{y} = \theta_0 + \theta_1 x_1 + \theta_2 x_2 + \cdots + \theta_m x_m
$$

La pérdida con L2 sería:

$$
J(\theta) = \frac{1}{n}\sum_{i=1}^{n}\big(y_i - \hat{y}_i\big)^2 + \lambda \sum_{j=1}^m \theta_j^2
$$

> Nota: normalmente no se penaliza el sesgo $\theta_0$, solo los demás pesos.

