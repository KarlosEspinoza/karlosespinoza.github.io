---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 6 - Características en el dominio de la frecuencia (U2)

## Antes de la clase (aprendizaje invertido)

La señal vista en frecuencia: transformada rápida de Fourier (FFT) y densidad espectral de potencia (guía).

## Durante la clase (aprendizaje activo)

Calculamos la FFT de las señales del sensor y vemos qué información aparece en frecuencia que no se alcanzaba a ver en el tiempo. Agregamos características espectrales al dataset y comparamos el espectro de los tres tipos de pieza.

## Avance de tu proyecto esta semana

- Amplía `features.py` para calcular la FFT de cada ventana y extraer al menos dos características espectrales (por ejemplo frecuencia dominante y energía en una banda).
- Agrégalas a `features.csv`.
- Compara en una sola gráfica el espectro de tus tres tipos de pieza.
- Explica en `BITACORA.md` qué te dice la frecuencia que no te decía el tiempo. Si en tu caso la frecuencia no aporta nada útil, documenta esa conclusión con la evidencia: también es un resultado válido. Haz push.
