---
layout: default
title: Inteligencia Artificial
---
# Inteligencia Artificial

## Programa

- [Programa del curso](programa)

## Requisitos

- [Instalación y uso de Python con Visual Studio Code](/curso/python/instalacion_y_uso)
- [Requisitos](requisitos/)

## El caso del semestre

Durante todo el curso construimos un solo sistema: un **clasificador de piezas sobre banda transportadora**. Cada unidad le agrega una capa de funcionalidad, hasta llegar a un bucle de control completo sensores -> Python -> modelo -> PLC -> actuadores.

| Unidad | Lo que se agrega al sistema |
|---|---|
| 1. Introducción | Leemos sensores con Arduino y visualizamos la señal en Python |
| 2. Aprendizaje Supervisado | Etiquetamos las piezas, extraemos características y entrenamos el clasificador |
| 3. Aprendizaje No Supervisado | Buscamos patrones sin etiquetas y detectamos piezas anómalas |
| 4. Evaluación y Despliegue | Validamos el modelo y lo desplegamos en la maqueta con PLC S7-1214C |

## Actividades de clase

1. Introducción
    1. [Conceptos y flujo del Aprendizaje de Máquina](conceptos_flujo_ml)
    1. El bucle de control inteligente: sensor -> modelo -> actuador
    1. El caso del semestre: sistema clasificador de piezas sobre banda transportadora
    1. Interfaces de I/O: Arduino (prototipo) y PLC S7-1214C (producción)
1. Aprendizaje Supervisado
    1. [Concepto y aplicaciones en sistemas de control industrial](aprendizaje_supervisado/conceptos)
    1. [Adquisición y limpieza de datos de sensores](aprendizaje_supervisado/preparacion_limpieza_datos)
    1. Ingeniería de características para señales de sensores
        1. [Dominio del tiempo: media, varianza, amplitud pico a pico](aprendizaje_supervisado/ingenieria_caracteristicas)
        1. Dominio de la frecuencia: FFT y densidad espectral de potencia
    1. [Modelos supervisados: clasificación de piezas y regresión](aprendizaje_supervisado/modelos_supervisados)
    1. Primer bucle de control: el modelo decide, el Arduino actúa
    1. [Redes neuronales para clasificación de señales de sensores](aprendizaje_supervisado/redes_neuronales)
1. Aprendizaje No Supervisado
    1. [Concepto y aplicaciones: descubrir clases sin etiquetas previas](aprendizaje_no_supervisado/conceptos)
    1. [Preparación de datos para clustering y reducción de dimensionalidad](aprendizaje_no_supervisado/preparacion_reduccion)
    1. [Técnicas principales: K-Means, DBSCAN, PCA sobre datos del sistema](aprendizaje_no_supervisado/tecnicas_principales)
    1. Autoencoders para detección de anomalías en la línea
    1. Anomalías como señal de control: paro, reclasificación o alerta
1. Evaluación de Modelos y Despliegue en PLC
    1. [Métricas de evaluación para clasificación y regresión](evaluacion_modelo/metricas)
    1. [Validación cruzada](evaluacion_modelo/validacion_cruzada)
    1. Selección y ajuste de hiperparámetros
    1. Sobreajuste y subajuste
    1. Despliegue en producción: el modelo controla la maqueta vía PLC S7-1214C
    1. El bucle de control industrial: PC -> python-snap7 -> PLC -> banda y pistón
    1. Panorama de frontera: Physical AI, modelos fundacionales y RL en robótica

> Los temas sin enlace todavía no tienen material publicado. Se irán liberando conforme avance el semestre.

## Evaluación

| Rubro | Peso |
|---|---|
| Proyecto integrador (equipo) | 35% |
| Prácticas | 35% |
| Actividades integradoras | 5% |
| Asistencia | 5% |
| Proyecto final de carrera | 20% |

Los avances se revisan en tres sesiones presenciales: **semana 9** (cierre de U1 y U2), **semana 14** (cierre de U3) y **semana 17** (demo del bucle de control sobre la maqueta con PLC).

- [Evaluación individual](evaluacion/individual)
- [Proyecto integrador](evaluacion/proyecto_integrador)

### Recursos para el proyecto

1. [Proyecto final: rúbrica completa](proyecto/)
1. [Configurar el Raspberry Pi](/curso/linux/configurar_raspberry)
1. [Raspberry Pi y Arduino](proyecto/raspberry_arduino)
