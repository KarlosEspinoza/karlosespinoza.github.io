---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 5 - Características en el dominio del tiempo (U2)

## Antes de la clase (aprendizaje invertido)

Ingeniería de características en el dominio del tiempo: media, varianza y amplitud pico a pico calculadas sobre ventanas de la señal (guía).

## Durante la clase (aprendizaje activo)

Convertimos cada señal completa en un puñado de números que la describen. El modelo no recibe la señal cruda: recibe estas características. Calculamos las de cada ventana y comparamos sus valores entre los tres tipos de pieza.

## Avance de tu proyecto esta semana

- Escribe `features.py` que recorra `datos_limpios.csv` por ventanas y calcule media, varianza y amplitud pico a pico.
- Guarda el resultado en `features.csv`: una fila por pieza, una columna por característica, más la etiqueta.
- Grafica una característica contra otra, coloreando por tipo de pieza, y observa si las clases se separan.
- Explica en `BITACORA.md` qué característica separa mejor tus clases y por qué crees que es esa. Haz push.
