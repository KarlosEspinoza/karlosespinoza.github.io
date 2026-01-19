---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)


# Notas del ejercicio

```matlab
sigma_mm = 2;
```

---

## 1️⃣ Primero: qué hiciste realmente (lectura correcta del experimento)

Tú hiciste lo siguiente (aunque no lo dijiste explícitamente, esto es clave que el alumno lo entienda):

* Generaste **datos experimentales con muchísimo ruido**
* Usaste un **modelo correcto** (el mismo que generó los datos)
* **NO ajustaste parámetros**
* Solo comparaste **modelo propuesto vs datos medidos**

👉 Esto simula perfectamente una situación real de laboratorio:

> *“Tengo un modelo físicamente razonable, pero mis mediciones son muy ruidosas.”*

---

## 2️⃣ Interpretación métrica por métrica (esto es lo que “quieren decir”)

### 🔹 MAE = **1.43 mm**

**Qué es**
Error absoluto medio: en promedio, el modelo se equivoca **1.43 mm** respecto a la medición.

**Cómo explicarlo en clase**

> “Si tomo una medición al azar, el valor predicho por el modelo suele diferir de lo que medí en alrededor de 1.4 mm.”

📌 Clave:
Tu señal “real” está alrededor de décimas de mm → el error es **mucho mayor que la señal**.

👉 Esto NO significa que el modelo esté mal.
Significa que **la medición es muy ruidosa**.

---

### 🔹 RMSE = **1.77 mm**

**Qué es**
Error cuadrático medio: penaliza errores grandes.

**Lectura importante**
RMSE > MAE ⇒ hay errores grandes ocasionales (outliers debidos al ruido).

Esto es exactamente lo que hace un ruido gaussiano con σ = 2 mm.

---

### 🔹 MAPE = **8.85 %**

**Este número engaña si no se explica bien.**

MAPE mide error relativo, pero:

* cuando `a_mm` cruza por valores pequeños o cambia de signo (por el ruido),
* el porcentaje se “normaliza” artificialmente.

👉 Es un excelente punto para decirles:

> *“Las métricas no son verdades absolutas; hay que saber cuándo usar cada una.”*

---

### 🔹 R² = **0.9981** ← 🔥 EL PUNTO MÁS IMPORTANTE

Este valor parece decir:

> “El modelo es casi perfecto”

PERO al mismo tiempo:

* MAE ≈ 1.4 mm
* RMSE ≈ 1.8 mm

🧠 **Esto parece una contradicción… y no lo es.**

---

## 3️⃣ La paradoja clave (aquí está la lección central)

### ❓ ¿Cómo puede R² ser casi 1 si el error es enorme?

Porque:

* **R² mide tendencia global**, no error puntual
* Tu modelo:

  * captura **perfectamente la dependencia con T y con t**
  * explica **casi toda la varianza estructural**
* El ruido:

  * es grande
  * pero **no destruye la tendencia**

👉 Traducción ingenieril:

> *“El modelo explica muy bien el fenómeno, pero el experimento mide muy mal.”*

Esto es exactamente lo que pasa en muchos experimentos reales.

---

## 4️⃣ Interpretación por temperatura (tabla final)

Los errores:

| T (°C) | RMSE (mm) |
| ------ | --------- |
| 650    | 1.80      |
| 800    | 1.94      |
| 900    | 1.78      |

No hay una tendencia clara con T.

📌 Esto indica:

* El error **no depende del modelo**
* El error viene del **ruido impuesto artificialmente**

Si el modelo estuviera mal:

* verías RMSE crecer sistemáticamente con T o con t

---

## 5️⃣ Qué enseña esto sobre *proponer un modelo* (mensaje clave)

Aquí está la frase que vale la clase completa:

> **Un mal ajuste numérico no implica un mal modelo.
> Puede implicar un experimento ruidoso.**

Y la inversa también es cierta:

> **Un buen R² no garantiza precisión experimental.**

---

## 6️⃣ Cómo cerrar esto en clase (guion sugerido)

Puedes decir algo así:

> “Nosotros propusimos el modelo correcto, pero los datos tienen tanto ruido que el error absoluto es grande.
> Aun así, el modelo explica casi toda la tendencia.
> Esto nos enseña que modelar no es solo ajustar ecuaciones: es entender datos, ruido, supuestos y métricas.”

Luego pregúntales:

* ¿Mejorarían el modelo o el experimento?
* ¿Qué cambiarían primero en un laboratorio real?
* ¿Cuándo NO tendría sentido proponer un modelo?

---

## 7️⃣ Si quieres reforzar aún más (opcional, 2 minutos)

Diles que cambien SOLO una línea:

```matlab
sigma_mm = 0.01;
```

y vuelvan a correr todo.

👉 Van a ver:

* MAE ↓↓↓
* RMSE ↓↓↓
* R² ≈ igual

Y ahí se cierra el círculo mental:

> **El modelo nunca cambió. Cambió la calidad del experimento.**


