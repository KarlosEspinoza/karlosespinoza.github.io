---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 15 - Evaluación del modelo (U4)

## Antes de la clase (aprendizaje invertido)

Métricas de clasificación (exactitud, precisión, exhaustividad y F1), validación cruzada y búsqueda de hiperparámetros (guía).

## Durante la clase (aprendizaje activo)

Evaluamos el modelo como se hace en serio: con validación cruzada en lugar de una sola partición, y comparando configuraciones de hiperparámetros para elegir la versión que se va a producción. Hasta ahora confiabas en un solo número; esta semana aprendes por qué ese número puede engañarte.

## Tu proyecto esta semana

- Escribe `evaluar.py` que evalúe tu clasificador con validación cruzada y reporte exactitud, precisión, exhaustividad y F1 por clase.
- Busca los mejores hiperparámetros de tu modelo y documenta la comparación.
- Vuelve a entrenar con la mejor configuración y actualiza `modelo.pkl`.
- Explica en `BITACORA.md` por qué una sola partición puede engañarte y qué métrica importa más en tu caso. Haz push.
