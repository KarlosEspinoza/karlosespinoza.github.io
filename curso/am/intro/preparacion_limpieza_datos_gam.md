---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad de Gamificación: *“Data Sprint”* 🏃‍♂️🏃‍♀️

## Duración

5–10 minutos (ideal para romper la monotonía y reactivar la energía del grupo).

---

## Objetivo

* Reforzar de manera lúdica las técnicas de **preparación y limpieza de datos** (normalización, imputación y detección/eliminación de outliers).
* Promover la **competencia sana y colaboración** entre equipos.

---

## Materiales

* Proyector o pizarrón.
* Alternativa: entregar una hoja impresa a cada equipo con un conjunto de datos pequeños (10 valores).

---

## Desarrollo (paso a paso)

1. **Divide el grupo en equipos** (mínimo 2 personas, máximo 4).

2. **Presenta o entrega un conjunto de datos con ruido**. Ejemplo:

   ```
   25, 26, 150, 27, 0, 26, 25, 24, 28, 300
   ```

   *Aquí hay outliers (150 y 300) y un valor faltante simulado (0).*

3. **Indicación a los estudiantes:**

   * Identificar los valores incorrectos o extraños.
   * Aplicar una de las técnicas vistas (normalización, imputación o detección de outliers).
   * Mostrar el conjunto de datos corregido.

4. **Tiempo límite:** 5 minutos.
   Gana el equipo que entregue primero un resultado correcto.

---

## Criterios de Éxito

* Detectaron correctamente los outliers.
* Aplicaron la técnica de limpieza adecuada (ej. imputación con media, normalización, o simplemente eliminar los valores fuera de rango).
* El resultado final es coherente y justificado en 1–2 frases.

---

## Ejemplo de Solución Esperada

* Datos originales:

  ```
  25, 26, 150, 27, 0, 26, 25, 24, 28, 300
  ```
* Paso 1: Detectar outliers (150, 300) y el dato faltante (0).
* Paso 2: Imputar 0 con la media ≈ 26.
* Paso 3: Eliminar 150 y 300 (o imputarlos con la media).
* Resultado final (ejemplo):

  ```
  25, 26, 26, 27, 26, 26, 25, 24, 28
  ```

---

## Recompensa

* Un punto extra simbólico en la participación.
* Alternativa: entregar un “sticker de data master” o un reconocimiento rápido al equipo ganador.

