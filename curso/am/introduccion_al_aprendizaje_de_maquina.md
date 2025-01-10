---
layout: default
title: Introducción al aprendizaje de máquina
---

# Introducción al aprendizaje de máquina

## ¿Qué es el aprendizaje de máquina?

El aprendizaje de máquina (Machine Learning) es una rama de la inteligencia artificial que permite a los sistemas aprender y mejorar automáticamente a partir de la experiencia sin ser programados explícitamente. Esto se logra mediante el uso de algoritmos que analizan datos, reconocen patrones y hacen predicciones o decisiones basadas en ellos.

### Ejemplo introductorio: Reconocimiento de letras escritas a mano
Imagina que deseas crear un sistema que pueda identificar letras escritas a mano. En lugar de programar explícitamente las reglas para cada letra (lo cual sería complicado debido a la variabilidad en la escritura), el aprendizaje de máquina permite entrenar un modelo proporcionándole ejemplos de letras y sus correspondientes etiquetas.
![Mnist dataset [(Baldominos 2019)](https://www.mdpi.com/2076-3417/9/15/3169).](https://www.mdpi.com/applsci/applsci-09-03169/article_deploy/html/images/applsci-09-03169-g002.png)


#### Proceso de entrenamiento:
1. **Datos de entrada**: Se recopilan miles de imágenes de letras escritas a mano.
1. **Modelo de aprendizaje**: Se elige un algoritmo (como una red neuronal) que pueda aprender de los datos.
1. **Entrenamiento**: El modelo ajusta sus parámetros internos para minimizar errores al predecir las letras correctas.
1. **Evaluación**: Se prueba el modelo con datos nuevos para verificar su precisión.
1. **Uso**: Una vez se satisface la precisión deseada el algoritmos puede ser usado.
```mermaid
graph LR
    A[Datos de entrada]
    style A fill:red

    B(Modelo de aprendizaje)
    style B fill:yellow
    C(Entrenamiento)
    style C fill:yellow
    D(Evaluación)
    style D fill:yellow

    E[Uso]
    style E fill:green

    A --> B
    B --> C
    C --> D
    D --> E
```

---

### Definición y conceptos básicos

El aprendizaje de máquina se basa en tres conceptos clave:

1. **Datos**: El material crudo con el que el modelo aprenderá. En el caso del reconocimiento de letras, son las imágenes de las letras.
2. **Modelos**: Las representaciones matemáticas utilizadas para encontrar patrones en los datos.
3. **Algoritmos**: Los procedimientos que el modelo sigue para optimizar su desempeño.

#### Tipos de aprendizaje de máquina
- **Supervisado**: Se entrena con datos etiquetados (por ejemplo, imágenes con la letra identificada).
- **No supervisado**: Encuentra patrones en datos no etiquetados (por ejemplo, agrupar imágenes similares sin saber qué letra representan).
- **Por refuerzo**: Aprende a tomar decisiones a través de ensayo y error (como enseñar a un robot a caminar).

| Tipo              | Datos etiquetados | Ejemplo                       |
|-------------------|-------------------|-------------------------------|
| Supervisado       | Sí                | Clasificar correos como spam  |
| No supervisado    | No                | Segmentar clientes            |
| Por refuerzo      | No                | Aprender a jugar ajedrez      |

---

### Diferencias entre IA, aprendizaje de máquina y aprendizaje profundo

1. **Inteligencia Artificial (Artificial Intelligence)**:
   - Campo amplio que incluye cualquier sistema capaz de realizar tareas que normalmente requieren inteligencia humana.
   - Ejemplo: Asistentes virtuales como Alexa o Siri.

2. **Aprendizaje de Máquina (Machine Leraning)**:
   - Subconjunto de la IA centrado en sistemas que aprenden de datos.
   - Ejemplo: Sistemas de recomendación en Netflix.

3. **Aprendizaje Profundo (Deep Learning)**:
   - Subconjunto del aprendizaje de máquina que utiliza redes neuronales profundas para analizar grandes cantidades de datos.
   - Ejemplo: Reconocimiento facial en cámaras de seguridad.

![Relación entre IA, ML y Deep Learning](https://www.researchgate.net/publication/353939315/figure/fig1/AS:1057659167989760@1629177004291/enn-Diagram-for-AI-ML-NLP-DL.ppm)

---

