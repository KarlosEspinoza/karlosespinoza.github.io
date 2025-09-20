---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad Extra: Otros modelos supervisados

## Objetivo

Aplicar **tres modelos supervisados adicionales**—Regresión Logística (clasificación), Árbol de Decisión (regresión) y SVM (clasificación)—para problemas breves con datos reales de Arduino, reforzando el pipeline: adquisición → CSV → entrenamiento → evaluación/predicción.

---

## 1) Regresión Logística (Clasificación binaria)

### Explicación (teoría breve)

La **regresión logística** modela la probabilidad de pertenencia a una clase (p. ej., LED encendido $y=1$) dada una variable $x$ (p. ej., luz del LDR).
**Ecuación (objetivo: estimar probabilidad y tomar una decisión):**

$$
\hat{p}(y=1\mid x)=\sigma(z)=\frac{1}{1+e^{-z}},\quad z=\beta_0+\beta_1 x
$$

* $\sigma(\cdot)$: sigmoide
* $\beta_0, \beta_1$: parámetros a estimar
* Decisión típica: **clase 1 si** $\hat{p}\ge 0.5$

### Ejemplo (mecatrónica \~400 caracteres)

Con un **LDR** en un pasillo, queremos aprender la regla “**poca luz → encender LED**” sin fijar manualmente el umbral. Tomamos pares $(\text{LDR}, \text{LED\_ON})$ durante 1 minuto, donde LED\_ON lo define el Arduino con una regla inicial sencilla. La regresión logística aprende a predecir LED\_ON a partir de la luz y generaliza mejor ante variaciones de iluminación.

### Ejercicio (Arduino + Python)

**Circuito:** LDR como divisor a **A0** y **LED** en **D3** (con resistencia).
**Arduino (pseudo-código, imprime `ldr_raw,led_on`)**:

```cpp
// LDR en A0, LED en D3. NO repetir lo ya visto (lectura ADC, etc.):
const int PIN_LDR = A0;
const int PIN_LED = 3;
const int UMBRAL = 300; // umbral operativo inicial (solo para generar etiquetas)

void setup(){ Serial.begin(9600); pinMode(PIN_LED, OUTPUT); }
void loop(){
  int ldr = analogRead(PIN_LDR);
  int led_on = (ldr < UMBRAL) ? 1 : 0;
  digitalWrite(PIN_LED, led_on ? HIGH : LOW);
  // CSV: ldr_raw,led_on
  Serial.print(ldr); Serial.print(","); Serial.println(led_on);
  delay(200);
}
```

**Python (entrenar logística con scikit-learn):**

```python
# logistic_ldr.py
import csv
import numpy as np
from sklearn.linear_model import LogisticRegression

ldr_vals, y = [], []
# TODO: leer 'ldr_led.csv' con columnas: ldr_raw, led_on
# pista: usar csv.reader, convertir a float/int y append

X = np.array(ldr_vals).reshape(-1,1)
y = np.array(y)

model = LogisticRegression().fit(X, y)
# Imprime coeficientes de la sigmoide: z = b0 + b1*x
print("b0, b1:", model.intercept_[0], model.coef_[0,0])

# Predicción de ejemplo:
for test in [150, 300, 600]:
    p = model.predict_proba([[test]])[0,1]
    print(f"LDR={test} -> P(LED=1)={p:.2f}, clase={int(p>=0.5)}")
```

---

## 2) Árbol de Decisión (Regresión)

### Explicación (teoría breve)

Un **árbol de regresión** divide el espacio de $x$ en regiones y ajusta una **constante por hoja** minimizando el **error cuadrático**.
**Impureza (objetivo: minimizar error dentro de nodos):**

$$
\text{MSE}=\frac{1}{n}\sum_{i=1}^{n}(y_i-\hat{y})^2
$$

* $y$: variable continua (p. ej., distancia real, °C)
* El árbol busca particiones que reduzcan el MSE total.

### Ejemplo (mecatrónica \~400 caracteres)

El **HC-SR04** es no lineal ante superficies blandas. Un **árbol de regresión** puede aproximar estas no linealidades para convertir tiempos/lecturas en una mejor estimación de **distancia**. Tomamos lecturas con el sensor apuntando a diferentes objetivos y el árbol aprende umbrales internos que mejoran la predicción sin que definamos una fórmula explícita.

### Ejercicio (Arduino + Python)

**Circuito (opcional si lo tienen a mano, si no, simulan CSV):** HC-SR04 (**Trig D9**, **Echo D10**).
**Arduino (pseudo-código, imprime `dist_cm`)**:

```cpp
// HC-SR04. NO repetir lo ya visto para medir distancia.
const int TRIG=9, ECHO=10;
void setup(){ Serial.begin(9600); pinMode(TRIG,OUTPUT); pinMode(ECHO,INPUT); }
void loop(){
  // TODO: disparo de trig, medir pulso echo → dist_cm
  // CSV: dist_cm
  Serial.println(dist_cm);
  delay(200);
}
```

**Python (árbol de regresión con scikit-learn):**

```python
# tree_reg_hcsr04.py
import csv
import numpy as np
from sklearn.tree import DecisionTreeRegressor

X, y = [], []
# Caso 1 (recomendado): si tienes referencia de distancia (y),
#   X = [duracion_echo o lectura derivada], y = distancia_real
# Caso 2: si NO tienes referencia, simula datos coherentes:
#   TODO: generar pares (x,y) sintéticos con ruido

# TODO: cargar o simular X,y (float). X debe ser 2D: [[x1],[x2],...]
X = np.array(X).reshape(-1,1)
y = np.array(y)

tree = DecisionTreeRegressor(max_depth=3).fit(X, y)
print("Árbol entrenado. Ejemplo de predicción:", tree.predict([[250.0]]))
```

> Alternativa rápida si no hay HC-SR04: usar **LM35** y estimar °C con árbol (sustituye `dist_cm` por `temp_C`). Aunque la relación es casi lineal, el árbol se entrena igual y ven el proceso.

---

## 3) SVM – Support Vector Machine (Clasificación)

### Explicación (teoría breve)

Una **SVM lineal** busca el **hiperplano** que **maximiza el margen** entre clases.
**Decisión (objetivo: separar con el mayor margen):**

$$
f(x)=\mathbf{w}^\top \mathbf{x}+b,\;\; \hat{y}=\text{sign}(f(x))
$$

* $\mathbf{w}$, $b$: parámetros que definen el hiperplano
* Con **kernel** se pueden separar datos no lineales (opcional: `kernel='rbf'`).

### Ejemplo (mecatrónica \~400 caracteres)

Montamos **LDR** (iluminancia) y **A3144** (detección de imán) y deseamos clasificar el estado “**alarma**” (buzzer) cuando hay **poca luz** y **magnetismo presente**. Recolectamos $(\text{LDR}, \text{HALL})$ con etiqueta de alarma (0/1). Una SVM lineal encuentra una frontera robusta entre “tranquilo” y “alarma” con mínima sensibilidad a ruido leve.

### Ejercicio (Arduino + Python)

**Circuito:** Reutiliza **LDR (A0)** y añade **A3144** a un pin digital (ej. **D4**). Opcional: buzzer en **D5**.
**Arduino (pseudo-código, imprime `ldr_raw,hall,alarma`)**:

```cpp
// LDR A0, A3144 D4 (digital), buzzer D5 opcional
const int PIN_LDR=A0, PIN_HALL=4, PIN_BUZZ=5;
void setup(){ Serial.begin(9600); pinMode(PIN_HALL,INPUT_PULLUP); pinMode(PIN_BUZZ,OUTPUT); }
void loop(){
  int ldr = analogRead(PIN_LDR);
  int hall = digitalRead(PIN_HALL)==LOW ? 1:0; // imán cerca → 1
  int alarma = (ldr<320 && hall==1)?1:0;      // regla simple p/etiquetar
  // TODO: opcional, activar buzzer si alarma==1
  // CSV: ldr_raw,hall,alarma
  Serial.print(ldr); Serial.print(","); Serial.print(hall); Serial.print(",");
  Serial.println(alarma);
  delay(150);
}
```

**Python (SVM lineal):**

```python
# svm_ldr_hall.py
import csv
import numpy as np
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score

X, y = [], []
# TODO: leer 'ldr_hall_alarm.csv' con columnas: ldr_raw,hall,alarma
# pista: X.append([ldr_val, hall_val]); y.append(alarma)

X = np.array(X)
y = np.array(y)

clf = SVC(kernel='linear').fit(X, y)
yhat = clf.predict(X)
print("Acc (train):", accuracy_score(y, yhat))

# Prueba manual:
print("Pred (LDR=280,HALL=1):", clf.predict([[280,1]])[0])
print("Pred (LDR=600,HALL=0):", clf.predict([[600,0]])[0])
```

---

## Flujo recomendado (para no rearmar)

```mermaid
flowchart LR
  A[LDR + LED] --> B[+ A3144 (opcional)]
  B --> C[+ HC-SR04 (opcional)]
  A -->|Reg. Logística| P1(Predicción LED)
  B -->|SVM| P2(Alarma)
  C -->|Árbol Regresión| P3(Distancia/Temperatura)
```

---

## Entrega (ligera, sin distraer)

Sube a **Google Docs**:

* Fragmentos de **código** (Arduino y Python) con tus **TODO resueltos**,
* **1–2 capturas/fotos** (montaje y consola),
* **3–5 líneas** de conclusión por modelo (qué predice y cómo te fue).

> Con esto basta para otorgar los **0.1 puntos extra**. No necesitas diagramas complejos.


