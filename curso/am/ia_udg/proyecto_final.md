---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Proyecto Final
**Ingeniería Mecatrónica – Séptimo Semestre**

## Descripción general

El proyecto final consiste en el diseño, implementación y validación de un **sistema físico inteligente** utilizando sensores reales, un microcontrolador (Arduino/ESP32), adquisición de datos, algoritmos en Python y un modelo de Aprendizaje de Máquina entrenado con datos recolectados por el propio equipo.

El sistema debe funcionar en condiciones reales y documentarse adecuadamente.

Este proyecto integra competencias del curso y los atributos de egreso AE2A y AE7A.

---

# Entregables

## 1. Reporte técnico (PDF)

El reporte debe contener las siguientes secciones:

---

## 1.1. Descripción de la aplicación

### Descripción de su variable X y y
Explicar con claridad:
- Qué sensores o fuentes producen las **variables X** (entradas).
- Qué representa **y**, la salida o variable objetivo.

Ejemplo:  
X = lectura LM35 y distancia HC-SR04 → y = clasificación “objeto presente/ausente”.

### Descripción y justificación del tipo de Aprendizaje de Máquina
Indicar si emplean:
- Clasificación  
- Regresión  
- Clustering  
y justificar por qué es adecuado para la aplicación elegida.

---

## 1.2. Desarrollo del sistema

### Sistema Mecánico
- Descripción del diseño mecánico.  
- Soportes, bases, mecanismos, estructura.  
- Incluir imágenes, fotos, planos o CAD.

### Sistema Eléctrico
- Diagrama de conexiones completo.  
- Conexión de sensores, actuadores, microcontrolador y alimentación.

### c) Adquisición de datos
Describir:
- Cómo se recolectaron los datos.  
- Condiciones de prueba. Incluye en este apartado una tabla con todas las condiciones o situaciones que pueden suceder en tu sistema.

**Tabla ejemplo**

| LM35 [°C] | HC-SR04 [cm] | Caso (y)                        | Explicación breve |
|-----------|--------------|----------------------------------|-------------------|
| 45–80     | 3–12         | Presente (Vela muy cercana)      | Alta temperatura detectada → la llama está a pocos centímetros. Reflejo ultrasónico fuerte y estable. |
| 30–45     | 5–20         | Presente (Vela cercana)          | La temperatura aumenta moderadamente; la vela está relativamente cerca pero no pegada al sensor. |
| 25–30     | 10–35        | Indeterminado / Zona gris        | El aumento de temperatura es leve y puede deberse a ambiente cálido. Requiere más datos o calibración. |
| 18–25     | 20–150       | Ausente (No hay vela cercana)    | Temperatura ambiente normal y distancia mayor a 20 cm. No hay fuente de calor relevante. |
| <18       | >100         | Ausente (Ambiente frío)          | No existe incremento térmico ni presencia física significativa. |


- Frecuencia de muestreo.  
- Cantidad de datos recopilados.

Debe incluir:

#### • Algoritmo Arduino – Etapa de Adquisición de datos
- Código .ino completo y comentado.

#### • Algoritmo Python – Etapa de Adquisición de datos
- Script para recibir datos, almacenarlos en CSV y preprocesarlos.

---

## 1.3. Entrenamiento y evaluación del modelo

Debe incluir:

- División de set de datos en entrenamiento/prueba.  
- Selección del modelo.  
- Métricas de evaluación (Accuracy, MSE, R², F1-score, etc.). Este apartado es opcional, se evaluara como puntos extras en el proyecto.  
- Justificación de elección del modelo final.

Incluye:

### • Algoritmo Python – Entrenamiento
- Preprocesamiento.
- Entrenamiento.
- Evaluación.
- Exportación del modelo (joblib).

### • Algoritmo Arduino/Python – Producción
- Uso del modelo para predicción en tiempo real.  
- Accionamiento de actuadores.

---

## 1.4. Producción / Sistema Final

Explicar como todo el flujo de como opera el sistema desde que lee los sensores hasta la accion del actuador.

Debe incluir:

### • Script Arduino – Producción
Código final del sistema ya funcionando en tiempo real.

### • Script Python – Producción
Script utilizado para cargar el modelo entrenado y ejecutar inferencia.

### • Video demostrativo
Comartir el enlace de un video a YouTube como **No listado** o Google Drive con acceso libre en donde se muestre el sistema funcionando.  

Debe mostrar:
- El sistema físico.  
- Lecturas en tiempo real.  
- Inferencia del modelo.  
- Actuadores funcionando.

---

# Entregables:

Cada integrante del equipo debe de entrega lo siguiente. No entregar se considerará que no trabajó.

1. Reporte (PDF)
2. CSV con los datos de entrenamiento. Archivo limpio y procesado para reproducir el entrenamiento.
3. Script Arduino – Etapa de Adquisición
4. Script Python – Etapa de Adquisición
5. Script Python – Etapa de Entrenamiento
6. Script Arduino – Etapa de Producción
7. Script Python – Etapa de Producción
8. CSV de Autoevaluación (50% de la calificación). El CSV lo debes de nombrar como integrantes.csv y dentro vendrá el código de cada uno de los integrantes del equipo y su calificación.

**Ejemplo:** integrantes.csv

```csv
codigo,calificacion
219894185,100
218010062,80
214393994,100
217688871,0
```

# Rúbrica de Evaluación del Proyecto Final (50%)

| Criterio | Descripción | Evidencia esperada | Puntaje |
|---------|-------------|--------------------|---------|
| **1. Definición del Problema** | Describe correctamente X y y; justifica el tipo de modelo | Claridad en variables, justificación consistente | 0 / 5 |
| **2. Sistema Mecánico** | Diseño físico coherente, estable y documentado | Fotos, diagramas, CAD, descripciones | 0 / 5 |
| **3. Sistema Eléctrico** | Conexiones correctas, diagrama completo y legible | Esquema eléctrico, montaje | 0 / 5 |
| **4. Adquisición de Datos** | Explicación del proceso y tabla de condiciones de operación | Datos suficientes, tabla de condiciones, scripts funcionales | 0 / 10 |
| **5. Scripts Arduino (Adquisición y Producción)** | Código funcional, comentado y claro | .ino incluidos, funcionamiento verificado | 0 / 10 |
| **6. Scripts Python (Adquisición, Entrenamiento, Producción)** | Código reproducible y bien estructurado | scripts .py, manejo de datos, carga del modelo | 0 / 10 |
| **7. Entrenamiento del Modelo** | División de datos, métricas, análisis crítico | Gráficas, tablas, justificación del modelo final | 0 / 10 |
| **8. Producción del Sistema** | Inferencia en tiempo real funciona; integración correcta | Video, explicación del flujo final | 0 / 10 |
| **9. Calidad del Reporte** | Organización, ortografía, claridad, rigor técnico | Reporte PDF completo | 0 / 5 |
| **10. Entrega Completa de Archivos** | Scripts, CSVs, video y reporte entregados | Revisión de anexos | 0 / 5 |

### **Total: 0 / 75 puntos (equivalente al 50% de la calificación final)**


