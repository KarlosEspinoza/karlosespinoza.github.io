---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 13 - La anomalía como señal de control (U3)

## Antes de la clase (aprendizaje invertido)

Diseño de la respuesta del sistema ante una anomalía: detener, desviar o alertar. Qué criterio usar para decidir cuál corresponde (guía).

## Durante la clase (aprendizaje activo)

Integramos el detector de anomalías al bucle de control. Ahora el sistema no solo clasifica: también reconoce cuando la pieza no se parece a nada que haya visto antes, y actúa distinto en ese caso.

## Avance de tu proyecto esta semana

- Integra el autoencoder a `control.py`: primero se revisa si la pieza es anómala, y solo si no lo es se clasifica.
- Define y programa la respuesta ante anomalía (detener la banda, desviar la pieza o encender una alerta).
- Graba un video del sistema reaccionando a una pieza anómala.
- Explica en `BITACORA.md` por qué conviene revisar la anomalía antes de clasificar y no después. Haz push.

> La próxima semana es la Revisión de avances 2. Deja la detección de anomalías integrada al bucle.
