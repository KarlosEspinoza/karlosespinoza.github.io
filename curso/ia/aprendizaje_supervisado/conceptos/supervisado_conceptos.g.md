---
layout: default
title: Aprendizaje de máquina
---
[Curso: Aprendizaje de Máquina](index)

# Guion

**Teoría (20 min)**

1. Definición de supervisado y ejemplo Arduino (5 min)
2. ERM, pérdidas (CE, MSE) y regularización (7 min)
3. Algoritmos (LR, k-NN, SVM, RF) + métricas clave (8 min)

**Práctica (40 min)**

1. Carga y partición del CSV (10 min)
2. Entrenamiento con GridSearch (15 min)
3. Métricas, matriz de confusión y discusión de riesgos (10 min)
4. Cierre con “¿cómo lo llevaría a Arduino?” (5 min)

---

## 6) Más conceptos con mini-ejemplos (para reforzar en tu web)

**(a) Escalado de características**
**Ejemplo (\~400 caracteres):**
El **HC-SR04** produce distancias en cm, la **LDR** una resistencia relativa y el **DHT22** en °C y %HR. Para **k-NN** o **SVM**, sin escalado la distancia Euclídea estará dominada por la **escala** mayor (cm). Con **StandardScaler**, cada sensor aporta de modo comparable, logrando que el **servo** gire cuando el **patrón** conjunto lo exija.

**(b) Desbalance de clases**
**Ejemplo (\~400 caracteres):**
Si casi siempre el robot va “**recto**” y pocas veces “**gira**”, la **accuracy** alta puede engañar. Usar **class\_weight** o optimizar **F1** macro hace que el modelo **atienda** las clases raras pero críticas. Así, no **ignora** paredes cercanas; el **motor** frena a tiempo aunque eso reduzca un poco la exactitud global.

**(c) Selección de características**
**Ejemplo (\~400 caracteres):**
Con 24 sensores ultrasónicos, quizá varios son **redundantes** (p. ej., dos muy correlacionados). Probar **Random Forest** para ver **importancias**, o **PCA** para reducir dimensión, puede simplificar la lógica final. En un microcontrolador, menos **features** implica decisiones más **rápidas** y menos consumo.

**(d) Validación cruzada**
**Ejemplo (\~400 caracteres):**
Antes de “congelar” hiperparámetros (p. ej. $k=5$ en k-NN), validas con **k-fold** (k=5). Así evalúas robustez con distintas particiones. En la práctica, tu robot mantendrá un **desempeño** más estable ante cambios modestos de iluminación (LDR) o variación de temperatura (DHT22) en el taller.

---

## 7) Cierre: de los datos al actuador

**Mensaje final para el estudiantado:** el aprendizaje supervisado **conecta** señales reales de sensores (ruidosas, con drift y correlaciones) con **acciones de control**. La teoría (pérdida, regularización, métricas) no es adorno: se traduce en **decisiones más seguras** en el **servo** y el **motor**. La práctica propuesta es un **espejo** del ciclo real: datos → modelo → validación → prueba → **acción embebida**.

---

### Archivos de referencia

* **BASE\_DE\_DATOS:** Kaggle *Wall-Following Robot*
* **ARCHIVOS\_CSV:** `sensor_readings_24.csv`, `sensor_readings_4.csv`, `sensor_readings_2.csv`

