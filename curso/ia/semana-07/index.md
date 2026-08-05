---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 7 - Entrenamiento del clasificador (U2)

## Antes de la clase (aprendizaje invertido)

Modelos supervisados de clasificación: árbol de decisión, máquina de vectores de soporte (SVM) y Random Forest. Qué es la matriz de confusión (guía).

## Durante la clase (aprendizaje activo)

Entrenamos el clasificador con las características extraídas. Separamos entrenamiento y prueba, comparamos varios modelos y leemos la matriz de confusión para descubrir qué piezas se confunden entre sí. Esa confusión suele ser la misma que detectamos a mano en la semana 1.

## Avance de tu proyecto esta semana

- Escribe `entrenar.py` que cargue `features.csv`, separe entrenamiento y prueba, entrene al menos dos modelos distintos y los compare.
- Guarda el mejor modelo en `modelo.pkl` con joblib.
- Incluye la matriz de confusión de tu mejor modelo.
- Explica en `BITACORA.md` qué modelo elegiste, con qué exactitud, y qué par de piezas se confunde más. Haz push.
