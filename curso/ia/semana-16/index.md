---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 16 - Sobreajuste y preparación para producción (U4)

## Antes de la clase (aprendizaje invertido)

Sobreajuste y subajuste: cómo se diagnostican y cómo se corrigen. Comunicación con el PLC S7-1214C desde Python con python-snap7 (guía).

## Durante la clase (aprendizaje activo)

Diagnosticamos si el modelo memorizó en lugar de aprender, y lo corregimos. Después hacemos la primera prueba de conexión con el PLC del laboratorio: leer una entrada y escribir una salida desde Python. Es el puente entre tu prototipo y el hardware industrial.

## Avance de tu proyecto esta semana

- Compara el desempeño en entrenamiento contra el de prueba y diagnostica si hay sobreajuste.
- Corrige lo que encuentres (más datos, menos características o un modelo más simple) y deja tu modelo final exportado.
- Escribe `prueba_plc.py` que se conecte al PLC con python-snap7, lea una entrada y active una salida.
- Explica en `BITACORA.md` cómo detectaste el sobreajuste y qué cambió al corregirlo. Haz push.

> La próxima semana es la Revisión final. Deja tu modelo listo y la conexión con el PLC probada.
