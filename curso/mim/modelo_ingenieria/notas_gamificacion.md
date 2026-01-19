---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)


# Guía para el profesor

## Actividad de gamificación: **“El modelo correcto”**

### Propósito pedagógico (explícito)

Que el estudiante **entienda que proponer un modelo es una decisión**, no un cálculo; y que dicha decisión depende de **supuestos, calidad de datos y objetivo del análisis**, no de la complejidad matemática.

---

## ⏱️ Duración total

**5–10 minutos**

* Presentación del reto: 1 min
* Discusión en equipos: 3–4 min
* Defensa rápida: 1 min por equipo
* Cierre del profesor: 1–2 min

---

## 🧠 Contexto que das en voz alta (30–45 s)

> “Tenemos datos experimentales ruidosos del crecimiento de una grieta en función del tiempo y la temperatura. Dos ingenieros proponen modelos distintos.
> Su tarea no es resolver nada numéricamente, sino **decidir cuál modelo usarían y por qué**.”

---

## 📊 Fenómeno común (para ambos equipos)

* Crecimiento de longitud de grieta (a(t))
* Dependencia con temperatura (T)
* Datos experimentales con **alto ruido**
* Objetivo: **describir la tendencia global**, no el mecanismo microestructural completo

---

## 📐 Modelos propuestos (se proyectan)

### 🔵 **Modelo A (fenomenológico mínimo)**

[
\frac{da}{dt} = k,T^n
\quad \Rightarrow \quad
a(t)=a_0+kT^n t
]

---

### 🔴 **Modelo B (más complejo, aparentemente “mejor”)**

[
\frac{da}{dt} = k,T^n,a
\quad \Rightarrow \quad
a(t)=a_0,\exp(kT^n t)
]

---

## 👥 Organización

* **Equipo 1**: defiende el **Modelo A**
* **Equipo 2**: defiende el **Modelo B**

Cada equipo debe responder **los mismos reactivos**.

---

## 📝 Reactivos (lo que deben discutir)

### Reactivo 1

**¿Cuáles son los supuestos explícitos del modelo que te tocó?**

---

### Reactivo 2

**¿Qué fenómeno físico sí captura bien y qué NO captura?**

---

### Reactivo 3

**Dado que los datos experimentales tienen mucho ruido,
¿qué modelo es más defendible usar en esta etapa y por qué?**

---

### Reactivo 4

**¿En qué situación real tu modelo dejaría de ser válido?**

---

## ✅ Respuestas esperadas (guía para el profesor)

### 🔵 Modelo A — respuestas esperadas

**Supuestos**

* La tasa de crecimiento es constante en el tiempo
* No depende del tamaño de la grieta
* No hay retroalimentación
* Modelo válido solo como primera aproximación

**Qué captura bien**

* Tendencia promedio
* Dependencia con temperatura
* Escala temporal global

**Qué NO captura**

* Aceleración del daño
* Inestabilidad
* Efectos geométricos o microestructurales

**Por qué es defendible con datos ruidosos**

* Menos parámetros implícitos
* Menor riesgo de sobreinterpretar ruido
* Más robusto ante dispersión experimental

**Cuándo falla**

* Cuando la grieta crece rápido
* Cuando hay inestabilidad o daño acelerado

---

### 🔴 Modelo B — respuestas esperadas

**Supuestos**

* La tasa de crecimiento depende del tamaño de la grieta
* Existe retroalimentación
* Crecimiento potencialmente inestable

**Qué captura bien**

* Aceleración del daño
* Fenómenos tipo runaway
* Etapas avanzadas de fractura

**Qué NO captura**

* Etapas iniciales con daño lento
* Datos muy ruidosos sin resolución temporal fina

**Problema con datos ruidosos**

* Amplifica el ruido
* Puede “ver” crecimiento exponencial donde no lo hay
* Riesgo de sobreajuste conceptual

**Cuándo es válido**

* Experimentos controlados
* Datos de alta calidad
* Etapas cercanas a falla

---

## 🏆 ¿Quién gana?

### Regla clara para decidir

Gana el equipo que **mejor justifique su modelo en función del objetivo y los datos**, no el que tenga la ecuación “más bonita”.

👉 **Respuesta pedagógicamente correcta en ESTE contexto**
🏆 **Modelo A**

**Por qué (frase clave para cerrar):**

> “Con datos ruidosos y objetivo exploratorio, el modelo más simple es el más honesto.”

---

## 🎯 Cierre del profesor (1–2 minutos)

Puedes cerrar con este guion literal:

> “Hoy ganó el modelo más simple, pero no porque sea ‘mejor’ en general, sino porque es el adecuado para esta etapa.
> Un modelo no se evalúa en el vacío, sino frente a los datos, el objetivo y los supuestos.
> Proponer un modelo es una decisión de ingeniería, no de ego matemático.”

---

## 💡 Variantes rápidas (si quieres repetirla otro día)

* Cambia el contexto a **fluencia**, **difusión**, **degradación térmica**
* Cambia el objetivo: *predicción a largo plazo* → puede ganar el modelo B
* Cambia la calidad de datos → vuelve a discutir

