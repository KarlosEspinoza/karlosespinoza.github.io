---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad Extra: Técnicas Avanzadas de Ingeniería de Características

### 1. Codificación de Variables Categóricas (One-Hot Encoding)

#### Explicación

La **codificación de variables categóricas** transforma datos no numéricos (ej. colores o estados) en variables numéricas que el modelo pueda procesar. La técnica más común es el **One-Hot Encoding**, donde cada categoría se representa como una columna binaria (0/1).

#### Ejemplo

Un **Arduino Nano** enciende un **LED RGB** con tres colores (`Rojo`, `Verde`, `Azul`) dependiendo de la distancia medida con un **HC-SR04**. Para usar estos datos en un modelo, la variable `color_LED` se codifica en tres columnas: `Rojo`, `Verde`, `Azul`.

#### Ejercicio

Arduino emite la distancia y el color del LED, y Python genera el CSV con codificación One-Hot.

```cpp
// Arduino: HC-SR04 + LED RGB
// Emite: distancia,color
```

```python
# Python: leer Serial y guardar distancia con One-Hot Encoding
# CSV: distancia,Rojo,Verde,Azul
```

---

### 2. Generación de Variables Polinómicas

#### Explicación

La **generación de variables polinómicas** permite crear nuevas características a partir de potencias o multiplicaciones de las variables existentes, ayudando a capturar relaciones no lineales.

#### Ejemplo

Un **LDR** conectado a un **Arduino Nano** mide la luz. Elevar la lectura del LDR a la potencia 2 o 3 puede mejorar la representación de la relación entre la luz ambiente y el encendido de un **LED**.

#### Ejercicio

Arduino emite la lectura cruda del LDR y Python genera un CSV con `LDR`, `LDR²` y `LDR³`.

```cpp
// Arduino: LDR en A0
// Emite: valor crudo del LDR
```

```python
# Python: leer Serial y guardar CSV con columnas [ldr, ldr^2, ldr^3]
```

---

### 3. Reducción de Dimensionalidad (PCA básico)

#### Explicación

Cuando usamos múltiples sensores, puede haber redundancia. El **Análisis de Componentes Principales (PCA)** reduce las dimensiones encontrando combinaciones lineales que conservan la mayor parte de la información.

#### Ejemplo

Un sistema con un **HC-SR04** y un **LDR** genera dos columnas de datos. El PCA permite combinarlas en una sola variable (`PC1`) que captura la mayor varianza.

#### Ejercicio

Arduino emite dos lecturas (LDR y distancia), y Python aplica PCA con `numpy` para obtener la primera componente principal.

```cpp
// Arduino: LDR + HC-SR04
// Emite: ldr,distancia
```

```python
# Python: leer CSV y aplicar PCA
# Imprimir varianza explicada y guardar PC1 en un nuevo CSV
```

---

## Entregables

* Código de Arduino y Python implementado en los tres ejercicios.
* Archivos CSV generados (ejemplo: `distancia_led.csv`, `ldr_polinomico.csv`, `pca.csv`).
* Capturas de pantalla de la ejecución o fotos del montaje de sensores/actuadores.
* Breve descripción (3–5 líneas) explicando qué técnica de ingeniería de características aplicaron en cada caso y para qué serviría en un modelo supervisado.

👉 Evidencia entregada en un **Google Docs con capturas, código y breve descripción**.

