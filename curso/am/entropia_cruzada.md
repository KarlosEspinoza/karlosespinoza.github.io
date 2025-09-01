---
layout: default
title: Entropía cruzada
---

# Entropía cruzada

# ¿Cuál es la ecuación?

## Multiclase (una muestra)

$$
\mathcal{L}_{\text{CE}}(\mathbf{x},y;\theta)
= -\sum_{c=1}^{C}\mathbf{1}[y=c]\;\log\;p_{\theta}(y=c\mid \mathbf{x})
$$

## Multiclase (promedio en un conjunto de $n$ muestras)

$$
\boxed{\;
\displaystyle
\mathcal{L}_{\text{CE}}(\theta)
= -\frac{1}{n}\sum_{i=1}^{n}\ \sum_{c=1}^{C}\ \mathbf{1}[y_i=c]\;\log\;p_{\theta}(y=c\mid \mathbf{x}_i)
\;}
$$

## Binaria (caso particular, $C=2$)

$$
\boxed{\;
\displaystyle
\mathcal{L}_{\text{bin}}(p,y)
= -\big[\,y\,\log p + (1-y)\,\log(1-p)\,\big]
\;}
$$

---

# ¿Qué significa cada símbolo?

| Símbolo                          | Significado                                                                     | Nota/Intuición                                                |
| -------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| $\mathbf{x}$                     | Vector de características (sensores, etc.)                                      | En nuestro robot: distancias ultrasónicas, luz (LDR), etc.    |
| $y$                              | Etiqueta verdadera de la clase para $\mathbf{x}$                                | Por ejemplo: {recto, girar\_izq, girar\_der}.                 |
| $C$                              | Número de clases                                                                | Multiclase si $C>2$; binaria si $C=2$.                        |
| $\theta$                         | Parámetros del modelo                                                           | Pesos de una regresión logística, de una red, etc.            |
| $\mathbf{1}[y=c]$                | Indicador que vale 1 si $y=c$, 0 si no                                          | Selecciona el término de la clase correcta.                   |
| $p_{\theta}(y=c\mid \mathbf{x})$ | Probabilidad **predicha** por el modelo de que $\mathbf{x}$ sea de la clase $c$ | Sale de softmax (multiclase) o sigmoide (binaria).            |
| $\log(\cdot)$                    | Logaritmo natural (por defecto)                                                 | Si usas $\log_2$, la unidad pasa a “bits”; con $\ln$, “nats”. |
| $\mathcal{L}_{\text{CE}}$        | **Pérdida** de entropía cruzada                                                 | Lo que minimizas en entrenamiento (ERM).                      |
| $n$                              | Número de muestras en tu lote/conjunto                                          | Se promedia para tener una escala estable.                    |

**Objetivo de la ecuación:** minimizar $\mathcal{L}_{\text{CE}}$ para que el modelo asigne **alta probabilidad** a la clase correcta. Equivalentemente, **maximiza la verosimilitud** (MLE) de los datos etiquetados.

---

# ¿De dónde salen esas probabilidades $p_\theta$?

En **multiclase**, casi siempre de **softmax** sobre los “logits” $z_c(\mathbf{x};\theta)$:

$$
p_{\theta}(y=c\mid \mathbf{x})
=
\frac{e^{z_c(\mathbf{x};\theta)}}{\sum_{j=1}^{C} e^{z_j(\mathbf{x};\theta)}}
\quad\text{con}\quad
\sum_{c=1}^{C} p_{\theta}(y=c\mid \mathbf{x})=1.
$$

En **binaria**, usamos una **sigmoide** sobre el logit $z$:

$$
p = \sigma(z)=\frac{1}{1+e^{-z}}.
$$

---

# ¿Por qué el logaritmo y el signo “–”?

* El **log** transforma productos en sumas (trabajamos con verosimilitud logarítmica) y **penaliza con fuerza la sobreconfianza equivocada**.
* El “–” convierte “maximizar log-probabilidad” en “minimizar pérdida” (conveniente para optimización).

**Propiedad clave:** si el modelo pone probabilidad **cercana a 1** en la clase verdadera, $-\log p$ es **cercano a 0**. Si se **equivoca con mucha confianza** (p.ej. $p=0.001$ para la clase verdadera), $-\log p$ se **dispara** (gran castigo).

---

# Ejemplo 

**Contexto:** Robot seguidor de pared con 3 clases $ \{ \text{recto}, \text{girar\_izq}, \text{girar\_der} \}$.
$\mathbf{x}$ concatena:

* $d_F$: distancia frontal (HC-SR04)
* $d_L$: distancia izquierda (HC-SR04)
* $d_R$: distancia derecha (HC-SR04)
* $L$: nivel de luz (LDR)
* $T, H$: temperatura y humedad (DHT22)
  El **actuador** es un **servo** de dirección y un **driver** de motor DC.

Para una muestra $\mathbf{x}$ con etiqueta real $y=\text{girar\_izq}$, el modelo predice:

$$
p(\text{recto}\mid \mathbf{x})=0.10,\quad
p(\text{girar\_izq}\mid \mathbf{x})=0.85,\quad
p(\text{girar\_der}\mid \mathbf{x})=0.05.
$$

La pérdida de esa muestra:

$$
\mathcal{L}_{\text{CE}}(\mathbf{x},y)
= -\log 0.85 \approx 0.163.
$$

**Baja** (bien): el sistema mandará **señal al servo** para girar a la izquierda.

Si el modelo se equivoca **con confianza**:

$$
p(\text{recto})=0.90,\ p(\text{girar\_izq})=0.05,\ p(\text{girar\_der})=0.05
\Rightarrow
\mathcal{L} = -\log 0.05 \approx 2.996,
$$

gran castigo: el entrenamiento empuja los parámetros para **aumentar** el logit de la clase correcta y **bajar** los demás.

---

# Tabla rápida: pérdida por una sola muestra (multiclase)

| Predicción correcta para $y$ | $p_{\text{true}}$ | $-\log p_{\text{true}}$ | Interpretación                 |
| ---------------------------: | ----------------: | ----------------------: | ------------------------------ |
|                   Muy segura |              0.99 |                   0.010 | Excelente                      |
|                    Aceptable |              0.85 |                   0.163 | Bien                           |
|                      Ambigua |              0.50 |                   0.693 | Meh                            |
|                         Mala |              0.10 |                   2.303 | Mal                            |
|                     Muy mala |              0.01 |                   4.605 | Fatal (sobreconfianza errónea) |

*(logaritmo natural; unidades en “nats”)*

---

# Conexión con ERM y regularización

* **ERM:** minimizas el **promedio** de la pérdida en tus datos.
* **Regularización (p. ej. L2):**

  $$
  \min_{\theta}\ \frac{1}{n}\sum_{i}\mathcal{L}_{\text{CE}}(\mathbf{x}_i,y_i;\theta)\;+\;\lambda\lVert\theta\rVert_2^2
  $$

  Evita que el modelo “memorice” ruido de sensores (picos eléctricos al activar un relevador, variación luminosa brusca en la LDR) y **mejora la generalización** del comportamiento del servo/motor.

---

# Detalles prácticos importantes

1. **Unidades**: con $\ln$ la pérdida está en **nats**; con $\log_2$, en **bits**.
2. **Etiquetas one-hot**: la forma $\sum_c \mathbf{1}[y=c]\log p_c$ equivale a $-\log p_{\text{clase\_verdadera}}$.
3. **Desbalance de clases**: puedes **ponderar** la pérdida por clase (class weights) si “girar” es raro pero crítico.
4. **Estabilidad numérica**: implementa softmax con el truco **log-sum-exp** (restar el máximo logit) para evitar desbordamientos.
5. **Calibración**: si necesitas probabilidades **bien calibradas** (p. ej., activar un **freno** a cierto umbral), considera Platt scaling o isotonic calibration.
6. **Label smoothing** (multiclase): reemplaza la one-hot por una distribución suavizada (p. ej., $0.9$ para la verdadera, $0.1/(C-1)$ para el resto) para **reducir sobreconfianza**.

---

# Intuición geométrica (multiclase con softmax)

* El modelo produce **logits** $z_c$. El gradiente de la entropía cruzada empuja a **subir** $z_{y}$ (clase verdadera) y a **bajar** $z_{c\neq y}$.
* En términos de decisión, la frontera se ajusta para **ganar margen probabilístico** en torno a los patrones de sensores que distinguen “recto” vs “girar”.

---

# Mini-ejemplo numérico (binario)

**Tarea:** “obstáculo cercano” (1) vs “libre” (0) a partir de $d_F$ (ultrasonido).

* Muestra 1: $y=1$, el modelo predice $p=0.9$ → $\mathcal{L}=-\log 0.9=0.105$ (bien)
* Muestra 2: $y=1$, el modelo predice $p=0.1$ → $\mathcal{L}=-\log 0.1=2.303$ (mal)
  Promedias ambas: la segunda **domina** el gradiente, corrigiendo fuerte al modelo.

---

