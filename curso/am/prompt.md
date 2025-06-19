TEMA = 1.1.2 Diferencias entre IA, aprendizaje de máquina y aprendizaje profundo
DURACION = 0.5

# Explicación teórica
Considera las siguientes especificaciones para la explicación teórica:
- Desrrollar el tema {TEMA}.
- Ajusta la explicación del tema para que me tome {DURACION} horas explicarlo a mis alumnos.
- Conceptos
- Ecuaciones matemáticas
- Si consideras conveniente incluye: diagramas, imagenes, tablas
- Una práctica.

## MarkDown
Necesito que me des el código MarkDown de la explicación para copiarlo, tengo mi paguina github.io con jekyll.
Considera en el Markdown las siguientes especificaciones:
- Si incluyes imagenes incluyelas con el link a la imagen ![Nombre de la imagen](link-de-la-imagen).
- Si vas a hacer algun diagrama hazlo utilizando diagramas mermaid.
- Si incluyes ecuaciones mateáticas considera usar $ECUACION$ para ecuaciones en linea y para las que no son en linea utiliza:
$$
ECUACION
$$
- Incluye al inicio del archivo lo siguiente:

---
layout: default
title: {TEMA}
---

# {TEMA}

EXPLICAION TEORICA

# Práctica

EXPLICACION DE LA PRACTICA



Quiero que incluyas en la Práctica:
- El objetivo de la práctica
- La explicación del problema de la práctica
- Las instrucciones de la práctica
- Un script python que genere los datos CSV para la práctica
- Un script de python que importe los datos del CSV generado para la práctica, que incluya también codigo relacionado a los conceptos y ecuaciones de la explicación teórica, y que en los comentarios del script aborde los conceptos y ecuaciones explicados en la etapa de la explicación teorica.

Eres profesor de Ingeniería Mectrónica de septimo semestre.
