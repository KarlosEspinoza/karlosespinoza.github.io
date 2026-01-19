---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)


# Gamificación: “Feature Battle – Relámpago”

## Propósito 

* Activar a la clase y reforzar:

  1. **Extracción** (media de ventana),
  2. **Combinación** (p. ej., variable compuesta),
  3. **Transformación** (log/escala cuando aplique),
  4. **Selección** vía **correlación con la variable objetivo** (LED\_ON).
* Favorecer AE7A (colaboración rápida con roles definidos) y, por el contenido técnico, AE2A (criterio para diseñar qué “feature” es útil).

## Duración total

**7–9 minutos.**

* 1 min: contexto y reglas
* 3–5 min: trabajo en equipos
* 1–3 min: presentaciones y desempate

## Materiales

* Proyector con un **dataset corto** (te dejo uno abajo).
* Un pizarrón o slide para **marcar puntajes**.
* Reloj/cronómetro.

## Formación de equipos

* 2 a 4 equipos (3–5 estudiantes c/u).
* Asigna **roles en 15 s**:

  * *Analista*: propone la característica.
  * *Matemático/a*: escribe la fórmula y justifica.
  * *Expositor/a*: defiende la elección en 20–30 s.
  * (Opcional) *Crítico/a*: verifica supuestos/umbral.

---

## Reglas del juego (cuéntalas tal cual)

1. Proyectaré un **mini-dataset** con columnas: `timestamp, ldr_raw, temp_C, LED_ON`.
2. En **3 minutos**, su equipo debe proponer **UNA** “mejor característica” para predecir `LED_ON`. Puede ser:

   * **Extracción** (p. ej., media de 5 lecturas del LDR: $\bar{x}_5$).
   * **Combinación** (p. ej., $x_{\text{comp}}$ = función de LDR y otra señal si aporta).
   * **Transformación** (p. ej., $\log$ si fuera útil; hoy puede no serlo, decídanlo).
3. Deben **justificar** su elección con **criterio cuantitativo**: cómo **aumentaría** la correlación (o la separabilidad) con `LED_ON`.
4. Preparan un **argumento de 20–30 s**: fórmula clara, qué aporta y por qué es mejor que usar el valor crudo.
5. **Puntuación**:

   * Claridad y pertinencia (0–2)
   * Rigor de la motivación (0–2)
   * Conexión con `LED_ON` (0–2)
   * Factibilidad en Arduino/Python (0–2)
   * Bonus (0–2) si consideran **ruido de etiqueta** (el 5% que vimos) o justifican por qué la temperatura **no** ayuda hoy.
     **Máximo: 10 pts**.

> **Tip a los equipos (dilo en voz alta):**
> El LED se enciende con **poca luz** → LDR bajo. Por eso, $\bar{x}_5$ del LDR o el **rango**/ **varianza** en ventanas cortas pueden estabilizar la señal para una mejor regla de decisión. La temperatura no debería correlacionar con `LED_ON`.

---

## Mini-dataset para proyectar (copia/pega en un slide)

(10 filas son suficientes. No tienen que calcular nada; solo pensar la **feature**.)

```
timestamp,ldr_raw,temp_C,LED_ON
0.0,850,30.2,0
0.2,790,29.9,0
0.4,620,31.0,0
0.6,280,30.5,1
0.8,260,30.3,1
1.0,310,29.8,0
1.2,290,30.6,1
1.4,270,30.1,1
1.6,510,30.4,0
1.8,180,29.7,1
```

---

## Ejemplos de respuestas válidas (para evaluar rápido)

* **Media móvil (extracción):**

  $$
  \bar{x}_5(t) = \frac{1}{5}\sum_{i=0}^{4} \text{LDR}(t-i)
  $$

  *Objetivo:* suavizar rachas de sombra/luz y **estabilizar** la decisión `LED_ON`.
  *Variables:* LDR crudo; ventana de 5 muestras.
  *Esperado:* **mejor correlación negativa** con `LED_ON` que un solo valor instantáneo.

* **Rango/local range (robustez a picos):**

  $$
  r_5(t) = \max(\text{LDR}_{t-4:t}) - \min(\text{LDR}_{t-4:t})
  $$

  *Objetivo:* detectar inestabilidad luminosa que podría afectar la regla.
  *Uso:* como **feature auxiliar** (si r\_5 alto, evita falsas alarmas).

* **Combinación (descartar distractor):**

  $$
  z(t) = \alpha\cdot \bar{x}_5(t) + \beta\cdot \text{Temp}(t) \quad \text{con } \beta\approx 0
  $$

  *Objetivo:* mostrar que **Temp** no aporta (correlación ≈ 0) y que el peso razonable es casi nulo → **selección** implícita.

> **Ecuación explicada (ejemplo media móvil):**
> Nombre: *Media móvil de orden 5*.
> **Objetivo:** reducir ruido/variabilidad en LDR para que la decisión sobre `LED_ON` sea más confiable.
> Variables: $\text{LDR}(t)$ valor actual, $t$ tiempo/discreto, ventana de 5 muestras.

---

## Instrucciones minuto a minuto

1. **(0:00–0:45)** Presenta el reto y muestra el dataset.
2. **(0:45–1:00)** Asignan roles por equipo.
3. **(1:00–4:00)** Trabajo en equipo: diseñan **UNA** feature y su justificación (pueden escribir la fórmula en una tarjetita).
4. **(4:00–6:30)** *Pitch* por equipos (20–30 s cada uno).
5. **(6:30–8:30)** Tu evaluación rápida con la rúbrica y declara ganador.
6. **(8:30–9:00)** Cierre: resalta por qué **LDR en ventana** > LDR crudo, y por qué **Temp** no correlaciona hoy.

---

## Rúbrica de puntuación (para ti)

| Criterio                  | 0            | 1         | 2                                                       |   |   |
| ------------------------- | ------------ | --------- | ------------------------------------------------------- | - | - |
| Claridad/pertinencia      | Confuso      | Aceptable | Muy claro y directo                                     |   |   |
| Rigor (fórmula/razón)     | Débil        | Parcial   | Bien fundamentado                                       |   |   |
| Conexión con LED\_ON      | No evidencia | Implícita | Explícita (espera ↑                                     | r | ) |
| Factibilidad              | Irreal       | Parcial   | Implementable ya en Arduino/Python                      |   |   |
| Bonus (ruido/temperatura) | –            | –         | Considera 5% ruido o descarta Temp por baja correlación |   |   |

**Desempate rápido:** el equipo cuya feature **(a)** no requiera re-cablear y **(b)** se compute con 1–2 líneas en Python/Arduino gana.


