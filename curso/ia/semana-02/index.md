---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 2 - La primera señal del sensor (U1)

## Antes de la clase (aprendizaje invertido)

Comunicación entre Arduino y Python con pyserial: abrir el puerto, leer líneas y convertirlas a números (guía).

## Durante la clase (aprendizaje activo)

Conectamos el primer sensor al Arduino y leemos su señal desde Python en tiempo real. Graficamos la señal mientras pasamos una pieza frente al sensor y observamos qué forma tiene. Aquí es donde el sistema deja de ser una idea y empieza a existir.

## Tu proyecto esta semana

- Programa `sensor.ino` para que envíe la lectura de tu sensor por el puerto serial.
- Escribe `leer_sensor.py` que reciba la lectura con pyserial y la grafique con matplotlib.
- Pasa una pieza frente al sensor y guarda una captura de cómo se ve la señal.
- Explica en `BITACORA.md` qué mide tu sensor y qué le pasa a la señal cuando la pieza pasa. Haz push.
