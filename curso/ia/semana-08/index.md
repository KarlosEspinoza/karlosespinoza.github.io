---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 8 - Redes neuronales y primer bucle de control (U2)

## Antes de la clase (aprendizaje invertido)

Redes neuronales para clasificación de señales: capas, funciones de activación y entrenamiento (guía).

## Durante la clase (aprendizaje activo)

Entrenamos una red densa sobre las mismas características y la comparamos con el modelo de la semana pasada. Después cerramos por primera vez el bucle completo: el modelo decide y el Arduino acciona el actuador. Es el momento en que tu proyecto deja de ser un script y se vuelve un sistema.

## Tu proyecto esta semana

- Entrena una red neuronal sobre `features.csv` y compárala con tu modelo anterior.
- Escribe `control.py`: lee la señal en vivo, extrae las características, predice con `modelo.pkl` y envía la orden al Arduino.
- Programa `control.ino` para que reciba esa orden y accione el actuador según la clase predicha.
- Graba un video corto del bucle funcionando: pasas una pieza y el actuador responde.
- Explica en `BITACORA.md` cómo quedó cerrado tu bucle sensor -> modelo -> actuador. Haz push.

> La próxima semana es la Revisión de avances 1. Deja tu bucle funcionando y tu BITACORA.md al día.
