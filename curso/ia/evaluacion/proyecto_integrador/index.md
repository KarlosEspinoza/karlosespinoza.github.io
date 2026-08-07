---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Proyecto Integrador

**Ingeniería Mecatrónica -- Séptimo Semestre**  
**Valor:** 35% de la calificación final

---

- [Descripción general](#descripcion-general)
- [Formación de equipos](#formacion-de-equipos)
- [Lo que construyen, capa por capa](#capa-por-capa)
- [Arquitectura del sistema](#arquitectura)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Revisiones de avances](#revisiones)
    - [Revisión 1: semana 9](#revision-1)
    - [Revisión 2: semana 14](#revision-2)
    - [Revisión final: semana 17](#revision-final)
- [Autoevaluación del equipo](#autoevaluacion)
- [Calificación](#calificacion)
- [Atributos de egreso](#atributos)

---

## Descripción general {#descripcion-general}

El proyecto integrador es un **Sistema Clasificador Multi-Dominio** desarrollado en equipo. Cada integrante aporta su propio clasificador (de su proyecto individual) como un módulo del sistema. Un **Controlador Central** en Python los integra, toma la decisión de ruteo combinada y la ejecuta sobre la maqueta del laboratorio a través del PLC S7-1214C.

El resultado es un sistema de control inteligente real: múltiples modelos de ML corriendo en Python, comunicándose con hardware industrial vía python-snap7, con detección de anomalías integrada y actuadores físicos que responden a la decisión del modelo. Es el mismo tipo de arquitectura que opera en líneas de manufactura y clasificación industrial.

---

## Formación de equipos {#formacion-de-equipos}

- Equipos de **2 o 3 integrantes** (no se permiten equipos de 1 ni de 4 o más).
- **Cada integrante debe tener un dominio diferente** al de sus compañeros, ya que cada uno aporta su módulo clasificador.
- Registra tu equipo y dominios con el asesor durante la primera semana del curso.

**Ejemplo para un equipo de 3:**

| Integrante | Dominio (módulo) | Proyecto individual |
|---|---|---|
| Alumno A | Clasificación por material (madera/metal/plástico) | Clasificador con sensor inductivo + LDR |
| Alumno B | Clasificación por tamaño (chico/mediano/grande) | Clasificador con sensor ultrasónico HC-SR04 |
| Alumno C | Detección de anomalías (pieza dañada/desconocida) | Autoencoder sobre señales de vibrador + A3144 |

> El Controlador Central y el despliegue en PLC no pertenecen a ninguno en particular: son responsabilidad compartida del equipo.

---

## Lo que construyen, capa por capa {#capa-por-capa}

Al igual que el proyecto individual, el integrador crece con cada unidad del curso. Cada tema visto en clase se aplica al sistema del equipo:

| Unidad | Lo que agrega el equipo al sistema |
|---|---|
| **U1** Introducción | Cada integrante aporta su configuración de sensor. El equipo visualiza las señales de todos los sensores en una sola gráfica en Python. Definen juntos la arquitectura de sensores sobre la banda transportadora. |
| **U2** Aprendizaje Supervisado | Cada integrante aporta su clasificador entrenado. El equipo integra los modelos en un pipeline unificado: las features de todos los sensores entran, el pipeline decide el tipo de pieza y el Arduino actúa sobre los actuadores. |
| **U3** Aprendizaje No Supervisado | El equipo entrena un autoencoder compartido sobre las señales combinadas de todos los dominios. Las anomalías detectadas por cualquier módulo activan una respuesta de control coordinada (paro de banda o desvío de pieza). |
| **U4** Evaluación y Despliegue | El pipeline validado se despliega sobre la maqueta del laboratorio vía PLC S7-1214C. El equipo demuestra el bucle completo: sensores de la maqueta -> Python -> modelos -> PLC -> banda y pistón. |

---

## Arquitectura del sistema {#arquitectura}

```
           Pipeline de Control Central (Python)
     (integra todos los clasificadores + anomalias)
              |            |           |
        Modulo A       Modulo B    Modulo C
       (material)      (tamano)   (anomalia)
              \            |           /
               \           |          /
            PLC S7-1214C (python-snap7)
                  |               |
           Banda transportadora  Piston desviador
```

El **Pipeline Central** recorre la secuencia de decisión en cada ciclo:

```
1. Leer señales de sensores (Arduino en prototipo, PLC en producción)
2. Extraer features por dominio (cada módulo aporta sus propias features)
3. Clasificar con cada modelo (decisión por dominio)
4. Fusionar decisiones (votación o jerarquía definida por el equipo)
5. Detectar anomalías (autoencoder compartido)
6. Enviar comando al PLC -> banda o pistón reacciona
```

---

## Estructura del repositorio {#estructura-del-repositorio}

```
proyecto-integrador/
  README.md                   <- Integrantes, dominios y descripción del sistema
  BITACORA.md                 <- Conceptos de ML aplicados por el equipo
  pipeline/
    controlador.py            <- Script central: lee, decide y actúa
    plc_client.py             <- Comunicación con PLC vía python-snap7
    fusion.py                 <- Lógica de fusión de decisiones entre módulos
    anomalias.py              <- Autoencoder compartido del equipo

  dominio_a/                  <- Proyecto individual del integrante A (adaptado)
    modelo_a.joblib           <- Clasificador entrenado del dominio A
    features_a.py             <- Extracción de features del dominio A
    datos/
      dataset_a.csv

  dominio_b/                  <- Proyecto individual del integrante B (adaptado)
    modelo_b.joblib
    features_b.py
    datos/
      dataset_b.csv

  dominio_c/                  <- Proyecto individual del integrante C (si aplica)
    modelo_c.joblib
    features_c.py
    datos/
      dataset_c.csv
```

> Cada integrante adapta su script de adquisición y su modelo para que el Controlador Central pueda invocarlos como módulo del pipeline.

---

## Revisiones de avances {#revisiones}

El proyecto se revisa en las **mismas 3 semanas** que el proyecto individual. El equipo debe hacer **push a GitHub de sus avances antes del día de la revisión** (a más tardar en la sesión previa de esa semana), para que el asesor revise el código y la BITACORA.md con anticipación. El día de la revisión la sesión se dedica únicamente a las **preguntas (orales o escritas, en papel o en archivo de texto)**. Si el equipo no hizo el push a tiempo, no hay nada que revisar y la revisión cuenta como no entregada. Además, cada integrante actualiza y hace push de su autoevaluación privada antes de cada revisión (ver la sección "Autoevaluación del equipo"). En cada revisión cuentan:

| Instrumento | Peso dentro de la revisión |
|---|---|
| Evidencias: código, commits y funcionamiento del sistema completo entregados en GitHub antes de la revisión | 45% |
| BITACORA.md del equipo: explicación de los conceptos de ML aplicados | 25% |
| 2 preguntas (orales o escritas), una por integrante seleccionada al azar | 20% |
| Autoevaluación entre pares: contribución de cada integrante al equipo | 10% |

---

### Revisión 1 -- Semana 9 {#revision-1}

**Introducción y Aprendizaje Supervisado**

**El sistema debe:**
- Leer señales de **todos los sensores del equipo** en Python desde Arduino (pyserial)
- El pipeline integra los **clasificadores entrenados** de cada dominio
- La decisión combinada acciona actuadores físicos conectados al Arduino (LED, servo o motor como prototipo)
- El repositorio contiene los datasets de cada dominio y los modelos exportados con joblib

**La BITACORA.md del equipo debe explicar:**
- Cómo se integraron los módulos de cada integrante en el pipeline
- Qué estrategia de fusión de decisiones usa el equipo y por qué
- Cómo funciona el bucle de control en prototipo (diagrama del flujo completo)

---

### Revisión 2 -- Semana 14 {#revision-2}

**Aprendizaje No Supervisado y detección de anomalías**

**El sistema debe:**
- El pipeline incluye un **autoencoder compartido** entrenado con datos de todos los dominios
- El umbral de error de reconstrucción está definido y documentado en la BITACORA.md
- Una anomalía detectada dispara una **acción de control diferenciada** (paro o desvío de pieza)
- La lógica de anomalía está integrada al script `controlador.py` del pipeline

**La BITACORA.md debe explicar:**
- Cómo se diseñó el autoencoder: arquitectura, datos de entrenamiento, umbral
- Cómo se integra la detección de anomalías al bucle de control
- Qué pasa en el sistema cuando se detecta una anomalía (diagrama de flujo actualizado)

---

### Revisión Final -- Semana 17 {#revision-final}

**Despliegue en PLC y demo del sistema completo**

**El sistema debe:**
- El pipeline completo corre sobre la **maqueta del laboratorio** vía PLC S7-1214C (python-snap7)
- Los sensores de la maqueta alimentan el pipeline; los actuadores de la maqueta (banda y pistón) responden a la decisión del modelo
- El sistema maneja al menos **2 tipos de pieza correctamente clasificados** y detecta al menos **1 tipo de anomalía**
- Demo en vivo durante la sesión de revisión

**La BITACORA.md debe incluir:**
- Una sección por cada unidad del curso explicando cómo aparece ese concepto en el sistema integrador
- Tabla de contribución de cada integrante al código del integrador
- Resultados de evaluación del modelo en producción (matriz de confusión, precisión, recall)

---

## Autoevaluación del equipo {#autoevaluacion}

Cada integrante evalúa de forma **anónima** la contribución real de sus compañeros al proyecto integrador. La evaluación es privada: tus compañeros nunca ven la calificación que les pusiste; solo la ve el asesor. La autoevaluación vale el **10% de cada revisión de avances**.

Para que sea anónima, la autoevaluación **no se entrega en el repositorio del equipo** (ahí todos se verían). Se entrega por un canal privado y separado:

**Cómo se entrega:**
1. Cada integrante crea un **repositorio privado** de GitHub solo para su autoevaluación (por ejemplo `autoeval-ia`) y **agrega al asesor como colaborador**. Al ser privado y sin tus compañeros, nadie más puede verlo.
2. Dentro del repositorio coloca un archivo CSV cuyo nombre sea **tu propio código de alumno**, por ejemplo `2162628.csv`.
3. El archivo tiene dos columnas, `codigo` y `calificacion`: una fila por cada compañero al que calificas (no te incluyas a ti mismo). La calificación va de 0 a 100.
4. Entrega la URL de tu repositorio privado en Google Classroom **una sola vez**. Después, **antes de cada una de las 3 revisiones**, actualiza tu archivo `<tu_codigo>.csv` con tu evaluación de esa etapa y haz push.

**Ejemplo:** el alumno `2162628`, en un equipo con `2152525` y `2178899`, sube el archivo `2162628.csv`:

```csv
codigo,calificacion
2152525,90
2178899,100
```

**Reglas:**
- La calificación que recibe cada integrante es el **promedio de las calificaciones que le asignaron sus compañeros**, ponderado con la evaluación del asesor.
- **Si no haces push de tu autoevaluación antes de una revisión, pierdes el 10% de la autoevaluación en esa revisión** (cuenta como no entregada). Esto **no afecta a tus compañeros**: el promedio que ellos reciben se calcula solo con las autoevaluaciones que sí se entregaron.

---

## Calificación {#calificacion}

| Revisión | Semana | Peso |
|---|---|---|
| Revisión 1 | Semana 9 | 33% |
| Revisión 2 | Semana 14 | 34% |
| Revisión final | Semana 17 | 33% |

> El proyecto integrador equivale al **35% de la calificación final del curso**.

---

## Atributos de Egreso {#atributos}

- **AE2A Nivel Avanzado:** Diseñar e implementar un sistema de control inteligente end-to-end (sensores -> modelo -> PLC -> actuadores) desplegado sobre hardware industrial real.
- **AE7A Nivel Avanzado:** Favorecer el trabajo colaborativo y el liderazgo en la integración de módulos de distintos dominios, cumplir fechas de revisión y analizar riesgos del sistema en producción.
