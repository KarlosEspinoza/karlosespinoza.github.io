---
layout: default
title: Introducción al aprendizaje de máquina
---

# Introducción al aprendizaje de máquina

## ¿Qué es el aprendizaje de máquina?

El aprendizaje de máquina (Machine Learning) es una rama de la inteligencia artificial que permite a los sistemas aprender y mejorar automáticamente a partir de la experiencia sin ser programados explícitamente.
Esto se logra mediante el uso de algoritmos que analizan datos, reconocen patrones y hacen predicciones o decisiones basadas en ellos.

Imagina que deseas crear un sistema que pueda **identificar letras escritas a mano**. 
En lugar de programar explícitamente las reglas para cada letra (lo cual sería complicado debido a la variabilidad en la escritura), el aprendizaje de máquina permite entrenar un modelo proporcionándole ejemplos de letras y sus correspondientes etiquetas.
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

- **Datos**: El material crudo con el que el modelo aprenderá. En el caso del reconocimiento de letras, son las imágenes de las letras.
- **Modelos**: Las representaciones matemáticas utilizadas para encontrar patrones en los datos.
- **Algoritmos**: Los procedimientos que el modelo sigue para optimizar su desempeño.

#### Datos

Los datos pueden venir de diferentes medios.
Por ejemplo, en una máquina un sensor de temperatura proporciona la temperatura en el tiempo.

| Tiempo              | Temperatura |
| 2025-enero-05 10:33:20 | 20.1        |
| 2025-enero-05 10:33:21 | 20.5        |
| 2025-enero-05 10:33:22 | 40.9        |
| 2025-enero-05 10:33:23 | 21.3        |
| ...                    | ...         |
| 2025-enero-05 22:45:11 | 25.7        |

No obstante los datos puede que el sensor los otorge en formatos que debas de acondicionar o mejorar la representación de estos datos.

| Tiempo              | Temperatura |
| 2025-<code style="color : red">enero</code>-05 10:33:20 | 20.1        |
| 2025-enero-05 10:33:21 | 20.5        |
| 2025-enero-05 10:33:22 | <code style="color : red">40.9</code>        |
| 2025-enero-05 10:33:23 | 21.3        |
| ...                 | ...         |
| 2025-enero-05 22:45:11 | 25.7        |

Por ejemplo, en nuestro sensor de temperatura quizá el tiempo contiene letras o palabras con las que no puedas realizar operaciones (<code style="color : red">enero</code> en nuestro ejemplo).
En estos casos probablemente necesites **codificar** esos datos.
En este ejmplo, podría asignarle a enero el numero 1, ya que enero es el primer mes del año.

Los datos también pueden contener **errores** o **anomalias**.
Los errores corresponden a un mal funcionamiento del sensor u **origen de los datos**.
Mientras que la anomalia se refiere a algo muy atipico y dependiendiendo de tu aplicación tendras que considerar que hacer con esos datos.
En nuestro ejemplo <code style="color : red">40.9</code> no corresponde a un ambiente en el que se observa una tendencide la temperatura a subir paulatinamente.

También puede ser que nuestra aplicación este orientada a detectar un comportamiento de un sistema. 
Por ejemplo, si buscamos identificar si la temperatura esta subiendo, puede ser que sea irrelevante el día, o incluso la hora.
Puede que sea más relevante el lapso que ha pasado entre cada dato y no la hora en si, es decir el **delta** del tiempo.

#### Modelos

Es bien sabido que un **modelo** es cualquier cosa que represente a algo real.
En aprendizaje de máquina, los modelos son representaciones matemáticas que se aproximan al **sistema real** que pretendemos identificar. 
Por ejemplo, una persona en una habitación es capaz de identificar si la temperatura esta subiendo.
En este caso, nuestro sistema esta compuesto por diversos **elementos** que tienen **interacción** entre si.
En este sistema podrias listar diferentes elementos: el grosor de las paredes, la temperatura exterior, la temperatura interior, el color de las paredes, la presencia de una ventana, la posición de la persona, la ropa de la persona, su piel, su sistema nervioso, su cerebro, ojos, etc.
Algunos tienen interaciones entre si, y otros no tienen interaciones entre si.
Estas interaciones pueden ser relevantes o incluso no tener ninguna relevancia.
Por ejemplo, la temperatura exterior interaciona con las paredes de la habitación.
De igual forma, puede ser que el color de als paredes tenga muy poca influencia en la temparatura de la habitación, pero quiza podría influir en la percepción de la persona.
![System](https://www.researchgate.net/publication/368382603/figure/fig1/AS:11431281118970163@1675950076727/Network-graph-showing-commenting-and-replying-interactions-between-participants-in-the.jpg)


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

