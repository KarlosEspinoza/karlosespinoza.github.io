---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 12 - Autoencoders para detección de anomalías (U3)

## Antes de la clase (aprendizaje invertido)

El autoencoder: comprimir y reconstruir una señal. El error de reconstrucción como medida de qué tan rara es una pieza (guía).

## Durante la clase (aprendizaje activo)

Entrenamos un autoencoder solo con piezas normales y medimos el error de reconstrucción. Definimos el umbral a partir del cual una pieza se considera anómala. Esto le da a tu sistema algo que el clasificador no tiene: la capacidad de decir "esto no se parece a nada que yo conozca".

## Tu proyecto esta semana

- Escribe `autoencoder.py` que entrene solo con tus piezas normales y guarde el modelo.
- Mide el error de reconstrucción y fija un umbral justificado con tus propios datos.
- Prueba con una pieza que el modelo nunca vio (rota, de otro material, colocada al revés) y comprueba que el error sube.
- Explica en `BITACORA.md` cómo elegiste el umbral y qué pasa si lo pones muy alto o muy bajo. Haz push.
