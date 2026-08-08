---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)


---

- [Información del curso](#informacion-del-curso)
    - [Caracteristicas](#caracteristicas)
    - [Alineación con el programa educativo](#alineacion-con-el-programa-educativo)
- [Descripción](#descripcion)
    - [Objetivos](#objetivos)
    - [Contenido](#contenido)
- [Metodología y evaluación](#metodologia-y-evaluacion)
    - [Métodos, instrumentos y reglas](#metodos-instrumentos-y-reglas)
    - [Evaluación y rúbricas](#evaluacion-y-rubricas)
- [Planeación](#planeacion)
- [Recursos](#recursos)
    - [Bibliográficos](#bibliograficos)
    - [Instalaciones, equipos y software](#instalaciones-equipos-y-software)

---



# Información del curso {#informacion-del-curso}

## Caracteristicas {#caracteristicas}

* **Universidad:** Universidad de Guadalajara  
* **Centro Universitario:** Centro Universitario de la Costa Sur
* **Asignatura:** Inteligencia Artificial
* **Denominación:** Inteligencia Artificial  
* **Clave de la asignatura:** IE043  
* **División:** División de Desarrollo Regional  
* **Departamento:** Departamento de Ingenierías  
* **Academia:** Computación
* **Programa Educativo al que está adscrita:** Ingeniería Mecatrónica  
* **Tipo:** Curso-Laboratorio   
* **Nivel:** Pregrado  
* **Área de formación:** Básica Particular Obligatoria  
* **Modalidad:** Presencial  
* **Prerrequisitos:** Análisis de sistemas y señales  
* **Horas teoría:** 40  
* **Hora práctica:** 40  
* **Horas totales:** 80  
* **Créditos:** 8  
* **CNR:** 182168  
* **Aula:** T7, C7  
* **Horario de clase síncrona:** Lunes y Miércoles 09:00 hrs a 11:00 hrs  
* **Asesor:** Karlos Emmanuel Espinoza Ramos  
* **Correo electrónico del asesor:** [karlos.espinoza@academicos.udg.mx](mailto:karlos.espinoza@academicos.udg.mx)  
* **Horario de asesoría:** Agendar por [correo electrónico](mailto:karlos.espinoza@academicos.udg.mx) o en [Google Calendar](https://calendar.app.google/ZZw7VbjTCUFAmac29)  
* **Jefe de departamento:** Domingo Velázquez Pérez 
* **Correo electrónico del jefe de departamento:** [domingov@cucsur.udg.mx](mailto:domingov@cucsur.udg.mx)
* **Presidente de la académia:** Gerardo Joel Medina Reyes
* **Secretario de la académia:** Alfonso Ramos Michel
* **Programa actualizado por:** Karlos Emmanuel Espinoza Ramos
* **Fecha de actualización del programa:** Julio de 2026

## Alineación con el programa educativo {#alineacion-con-el-programa-educativo}

* **Relación con el perfil de egreso:**   
  * **Atributo de Egreso 2 Nivel Avanzado**: Diseñar e implementar sistemas en el área de automatización, control, robótica y sistemas embebidos, a través de proyectos integradores.  
  * **Atributo de Egreso 7 Nivel Avanzado**: Favorecer el trabajo colaborativo y el liderazgo, conforma y se integra en equipos multidisciplinarios de trabajo que establecen metas, planean tareas, cumplen fechas límite y analizan riesgos e incertidumbre.  
* **Relación con el plan de estudios:** Los algoritmos inteligentes son parte fundamental dentro de los procesos de la mecatrónica conformándose como un importante punto para la formación profesional de los estudiantes.

* **Perfil del profesor**  
* ***Descripción*****:** Ingeniero con conocimientos en el desarrollo de algoritmos inteligentes y sistemas de control. Ha realizado publicaciones científicas sobre desarrollo de software y algoritmos.  
* ***Referencias*****:**  
  * ORCID: [0000-0002-2759-2961](https://orcid.org/0000-0002-2759-2961)  
  * Google Académico: [https://scholar.google.es/citations?user=oSspIj4AAAAJ\&hl=es\&oi=sra](https://scholar.google.es/citations?user=oSspIj4AAAAJ&hl=es&oi=sra)

# Descripción {#descripcion}

## Objetivos {#objetivos}

* **Objetivo general:** Diseñar e implementar un sistema de control inteligente que integre el ciclo completo del aprendizaje de máquina, desde la adquisición de señales de sensores hasta el despliegue del modelo como controlador en un sistema industrial real.
* **Objetivos específicos:**   
  * Implementar el bucle de control inteligente (sensor -> modelo -> actuador), primero en prototipo con Arduino y después en producción con PLC.
  * Aplicar técnicas de ingeniería de características para señales de sensores en los dominios del tiempo y de la frecuencia.
  * Entrenar y evaluar modelos de clasificación y detección de anomalías sobre datos reales de sensores físicos.
  * Desplegar un modelo de aprendizaje de máquina como controlador en una maqueta industrial con banda transportadora y pistón, usando comunicación con PLC vía python-snap7.
* **Elementos del desarrollo de la unidad de aprendizaje:**  
  * Conocimientos: Flujo del aprendizaje de máquina. Adquisición y procesamiento de señales de sensores. Ingeniería de características en tiempo y frecuencia (FFT). Aprendizaje supervisado y no supervisado. Evaluación de modelos. Comunicación con PLC vía python-snap7. Bucle de control sensor -> modelo -> actuador.
  * Habilidades y Destrezas: Pensamiento lógico matemático. Programación en Python. Recolección y etiquetado de datos de sensores físicos. Integración hardware-software en sistemas de control industrial. Comunicación efectiva. Solución de problemas.
  * Desarrollo del Aprendizaje progresivo: Valores y Actitudes de trabajo en equipo, responsabilidad, ética y perseverancia.

## Contenido {#contenido}

### Enfoque del curso: orientado a la demanda laboral

El contenido se reorganiza para responder a lo que el campo laboral pide a un ingeniero mecatrónico con formación en inteligencia artificial. La evidencia de reportes de demanda (2025-2026) muestra que el perfil diferenciador no es el conocimiento de algoritmos de ML en abstracto: es la capacidad de aplicarlos sobre señales físicas reales y de cerrar el bucle de control sobre hardware industrial. El mercado no pide menos teoría de ML; pide poder aplicarla para adquirir datos de sensores, entrenar modelos y actuar sobre sistemas reales con restricciones físicas.

Por eso cada unidad se trabaja desde su aplicación real. Los conceptos del temario son el medio para construir un sistema funcional:

| Lo que pide el campo laboral | Concepto del temario que lo sostiene |
|---|---|
| Bucles de control con IA en sistemas industriales | Sensor -> modelo -> actuador como arquitectura central del curso |
| Series de tiempo y señales de sensores (FFT, características) | Ingeniería de características para señales en tiempo y frecuencia |
| Mantenimiento predictivo y detección de anomalías | Aprendizaje no supervisado y autoencoders aplicados al sistema |
| Despliegue en hardware real con restricciones físicas | Comunicación con PLC S7-1214C vía python-snap7 |
| Integración hardware-software: el modelo actúa | El clasificador decide, el actuador mueve la pieza |
| Fundamentos de ML para sistemas ciber-físicos | Supervisado, no supervisado y evaluación como medios, no fines |

Todo se construye sobre un único caso a lo largo del semestre: un **sistema clasificador de piezas sobre banda transportadora**, del mismo tipo que opera en líneas de manufactura y clasificación industrial. Cada unidad agrega una capa funcional al sistema.

| Unidad | Lo que se agrega al sistema | Por qué ese tema aparece naturalmente |
|---|---|---|
| U1: Introducción | El sistema existe. Leemos sensores con Arduino y visualizamos la señal en Python. | Antes de entrenar un modelo hay que entender de dónde vienen los datos |
| U2: Aprendizaje Supervisado | Etiquetamos las piezas. Extraemos características. Entrenamos el clasificador. El Arduino actúa según la decisión del modelo. | El bloque debe ser clasificado para ser enrutado correctamente en la banda |
| U3: Aprendizaje No Supervisado | Sin etiquetas, buscamos patrones. Detectamos piezas anómalas con autoencoder. La anomalía dispara una acción de control. | La línea puede recibir piezas desconocidas o defectuosas que no estaban en el entrenamiento |
| U4: Evaluación y Despliegue | Validamos el modelo. Lo desplegamos en la maqueta real vía PLC S7-1214C. El modelo controla la banda y el pistón. | El mismo clasificador de U2 y U3, ahora corriendo en producción sobre hardware industrial |

Al final del semestre el sistema es un clasificador funcional end-to-end: sensores -> Python -> modelo -> PLC -> actuadores.

**El proyecto individual** es ese mismo sistema, cada alumno con su propio conjunto de sensores y dominio de clasificación (materiales, tamaños, estados de una máquina, etc.).  
**El proyecto integrador** es una versión más completa desarrollada en equipo, que integra todos los subsistemas y se despliega sobre las maquetas del laboratorio con PLC.

* **Contenido temático:**  
1. Introducción  
2. Aprendizaje Supervisado  
3. Aprendizaje No Supervisado  
4. Evaluación de Modelos y Despliegue en PLC

* **Estructura conceptual del curso:**  

1. Introducción
    1. Conceptos y flujo del Aprendizaje de Máquina
    1. El bucle de control inteligente: sensor -> modelo -> actuador
    1. El caso del semestre: sistema clasificador de piezas sobre banda transportadora
    1. Interfaces de I/O: Arduino (prototipo) y PLC S7-1214C (producción)
1. Aprendizaje Supervisado
    1. Concepto y aplicaciones en sistemas de control industrial
    1. Adquisición y limpieza de datos de sensores
    1. Ingeniería de características para señales de sensores
        1. Dominio del tiempo: media, varianza, amplitud pico a pico
        1. Dominio de la frecuencia: FFT y densidad espectral de potencia
    1. Modelos supervisados: clasificación de piezas y regresión
    1. Primer bucle de control: el modelo decide, el Arduino actúa sobre actuadores
    1. Redes neuronales para clasificación de señales de sensores
1. Aprendizaje No Supervisado
    1. Concepto y aplicaciones: descubrir clases sin etiquetas previas
    1. Preparación de datos para clustering y reducción de dimensionalidad
    1. Técnicas principales: K-Means, DBSCAN, PCA sobre datos del sistema
    1. Autoencoders para detección de anomalías en la línea
    1. Anomalías como señal de control: paro, reclasificación o alerta
1. Evaluación de Modelos y Despliegue en PLC
    1. Métricas de evaluación para clasificación y regresión
    1. Validación cruzada
    1. Selección y ajuste de hiperparámetros
    1. Sobreajuste y subajuste
    1. Despliegue en producción: el modelo controla la maqueta vía PLC S7-1214C
    1. El bucle de control industrial: PC -> python-snap7 -> PLC -> banda y pistón
    1. Panorama de frontera: Physical AI, modelos fundacionales y RL en robótica


# Metodología y evaluación {#metodologia-y-evaluacion}

## Métodos, instrumentos y reglas {#metodos-instrumentos-y-reglas}

* **Métodos e instrumentos:**  
  * **Aprendizaje Basado en Proyectos (ABP)** como eje central: un proyecto individual y un proyecto integrador en equipo sostienen el aprendizaje a lo largo del semestre. Todo gira en torno a un único caso, el clasificador de piezas sobre banda transportadora, que crece semana a semana hasta convertirse en un controlador industrial funcional.
  * **Aprendizaje Invertido (Flipped Classroom):** antes de cada sesión el alumno realiza una actividad (guía de código, lectura, video) que prepara el concepto del tema y avanza directamente su proyecto. El alumno llega a clase con el contexto ya construido.
  * **Aprendizaje activo durante la clase:** el tiempo de clase se dedica a aplicar lo preparado sobre el caso central: recolectar datos reales de sensores, entrenar modelos, construir y depurar el bucle de control, comparar soluciones entre pares y demostrar el avance. El asesor guía, retroalimenta y resuelve dudas en el momento.
  * **Aprendizaje Colaborativo:** el proyecto integrador se desarrolla en equipo, con resolución conjunta de problemas de recolección de datos, diseño del clasificador y despliegue sobre la maqueta con PLC.
  * **Aprendizaje con Soporte Tecnológico:** Python, Arduino IDE, python-snap7, Git y GitHub como herramientas centrales. Los datos recolectados en clase son los que alimentan los modelos del proyecto.
  * **Gamificación:** cuestionarios rápidos, listas de cotejo con puntos, retos cortos.
  * **Aprendizaje Autorregulado:** el alumno registra su avance semanal en BITACORA.md, versionada en GitHub. El asesor cruza lo que el alumno dice que hizo (BITACORA.md) con lo que realmente implementó (código) y retroalimenta en cada revisión.
* **Instrumentos de evaluación:**  
  * Evidencias en el repositorio GitHub (código, datasets, modelos entrenados, demo del bucle de control)
  * BITACORA.md donde el alumno explica con sus palabras los conceptos de ML aplicados en su proyecto
  * Preguntas (orales o escritas), 2 por revisión de avances
  * Lista de cotejo  
  * Formato de autoevaluación y coevaluación  
  * Participación  
* **Reglas:**  
  * **Reglamento General de Evaluación y Promoción de Alumnos:** [https://secgral.udg.mx/sites/default/files/Normatividad\_general/rgepa-oct-2017.pdf](https://secgral.udg.mx/sites/default/files/Normatividad_general/rgepa-oct-2017.pdf)  
  * **Reglas del aula:**   
    * Respetar el espacio de trabajo propio y de los compañeros, manteniéndolo ordenado y limpio.  
    * Usar los equipos únicamente como indica el manual de uso.  
  * **Reglas de la sesión:**  
    * Mantener el respeto con los estudiantes y el asesor.  
    * Respetar la participación de los estudiantes y el asesor.

## Evaluación y rúbricas {#evaluacion-y-rubricas}

* **Evaluación:**
  * **Proyecto integrador (equipo):** 35%
  * **Prácticas:** 35%
  * **Actividades integradoras:** 5%
  * **Asistencia:** 5%
  * **Proyecto final de carrera:** 20%

Las **actividades integradoras** son las que la coordinacion de la carrera organiza a nivel de programa educativo (jornadas, eventos academicos y actividades transversales). La coordinacion informa al asesor el porcentaje alcanzado por cada alumno dentro de ese 5%, que se suma a la calificacion final.

El rubro **Proyecto final de carrera** (20%) es evaluado por el comite valuador de Proyectos finales de carrera; la calificacion la reporta dicho comite al asesor al cierre del semestre.

**Instrumentos de revision de avances (proyecto individual):**

| Instrumento | Descripcion | Peso dentro del proyecto |
|---|---|---|
| Evidencias | Codigo en GitHub (datasets, modelos, codigo del bucle de control), commits y demo funcionando, entregados antes del dia de la revision | 50% |
| BITACORA.md | Documento en el repositorio donde el alumno explica los conceptos de ML aplicados en su proyecto | 30% |
| Preguntas (orales o escritas) | 2 preguntas sobre el trabajo realizado y los conceptos involucrados, aplicadas el dia de la revision | 20% |

En el **proyecto integrador** se agrega un cuarto instrumento, la autoevaluacion entre pares, y los pesos quedan: Evidencias 45%, BITACORA.md 25%, Preguntas 20% y Autoevaluacion entre pares 10%. El alumno entrega la URL de su repositorio en Google Classroom una sola vez al inicio del semestre; todas las revisiones siguientes se hacen sobre el mismo repositorio actualizado.

# Planeación {#planeacion}

El curso sigue un modelo de aprendizaje invertido: antes de cada sesión el alumno realiza una actividad que prepara el concepto del tema y avanza su proyecto, y el tiempo de clase se dedica a actividades de aprendizaje activo sobre el caso central (clasificador de piezas). Como reforzamiento, cada semana el alumno integra lo aplicado en su proyecto y registra una entrada en BITACORA.md, versionada en GitHub. Se contemplan tres sesiones de revisión de avances. El alumno hace push a GitHub de sus evidencias y BITACORA.md antes del día de la revisión; la sesión de revisión se dedica a dos preguntas (orales o escritas): una sobre su propio trabajo y otra sobre los temas vistos en clase.

| Semana | Actividades realizadas antes de la clase (aprendizaje invertido) | Actividades de aprendizaje activo a realizar durante la clase |
|---|---|---|
| 1 | Encuadre del curso; Tarea 0: configurar entorno (Python, VS Code, Git, Arduino IDE, pyserial) | U1: qué es ML; el bucle sensor -> modelo -> actuador; el caso del semestre: clasificador de piezas sobre banda transportadora |
| 2 | Leer señales con Arduino en Python vía pyserial: guía paso a paso | U1: primera lectura de sensor en tiempo real; graficar la señal en Python; el Arduino como interfaz de datos |
| 3 | Diseño del experimento de recolección de datos: tipos de pieza, sensores y etiquetas (guía) | U2: recolectar datos de los tres tipos de pieza con etiquetas; guardar en CSV; visualizar distribuciones por clase |
| 4 | Limpieza y normalización de señales de sensores (guía) | U2: limpiar el dataset; tratar valores atípicos; normalizar; explorar distribuciones |
| 5 | Ingeniería de características: dominio del tiempo (guía) | U2: calcular media, varianza y amplitud pico a pico sobre ventanas de la señal; agregar features al dataset |
| 6 | FFT y densidad espectral de potencia aplicada a señales de sensores (guía) | U2: calcular FFT de las señales del sensor; agregar features espectrales; comparar tipos de pieza en frecuencia |
| 7 | Modelos supervisados: SVM, árbol de decisión y Random Forest (guía) | U2: entrenar el clasificador de piezas; evaluar con matriz de confusión; seleccionar el mejor modelo |
| 8 | Redes neuronales para clasificación de señales: arquitectura y entrenamiento (guía) | U2: red densa sobre features de sensores; primer bucle de control completo: el modelo decide, el Arduino actúa |
| 9 | Push a GitHub de evidencias y BITACORA.md (entrega previa a la revisión) | **Revisión de avances 1:** preguntas orales o escritas, U1 y U2 (proyecto individual y proyecto integrador) |
| 10 | Aprendizaje no supervisado: concepto y aplicaciones sin etiqueta (guía) | U3: PCA sobre el dataset del clasificador; visualizar clusters en 2D; interpretar componentes principales |
| 11 | K-Means y DBSCAN: parámetros y casos de uso (guía) | U3: aplicar clustering sobre datos del sistema; comparar con las etiquetas reales |
| 12 | Autoencoders para detección de anomalías (guía) | U3: entrenar autoencoder con datos normales; medir error de reconstrucción; definir umbral para detectar piezas anómalas |
| 13 | Anomalías como señal de control: diseño de la respuesta del sistema (guía) | U3: integrar la detección de anomalías al bucle de control; la anomalía detiene la banda o desvía la pieza |
| 14 | Push a GitHub de evidencias y BITACORA.md (entrega previa a la revisión) | **Revisión de avances 2:** preguntas orales o escritas, U3 (proyecto individual y proyecto integrador) |
| 15 | Métricas de evaluación, validación cruzada y selección de hiperparámetros (guía) | U4: evaluar el modelo con datos del sistema; comparar configuraciones; seleccionar la versión lista para producción |
| 16 | Sobreajuste, subajuste y preparación del modelo para producción (guía) | U4: diagnosticar y corregir problemas del modelo; exportar con joblib; prueba de conexión con PLC S7-1214C |
| 17 | Integración final y push a GitHub (evidencias y BITACORA.md) | **Revisión final:** demostración del bucle de control sobre la maqueta vía PLC; panorama de frontera: Physical AI, modelos fundacionales y RL en robótica |

# Recursos {#recursos}

## Bibliográficos {#bibliograficos}

* **Bibliografía básica:**  
  * Russell, Stuart J.; Norvig, Peter. Inteligencia artificial: un enfoque moderno (4a ed.). Pearson, 2022. ISBN: 978-84-1322-952-5.  
  * Géron, Aurélien. Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow (3a ed.). O'Reilly, 2022. ISBN: 978-1-0981-2597-4.  
  * Raschka, Sebastian; Liu, Yuxi; Mirjalili, Vahid. Machine Learning with PyTorch and Scikit-Learn. Packt, 2022. ISBN: 978-1-8018-1931-2.  
  * VanderPlas, Jake. Python Data Science Handbook (2a ed.). O'Reilly, 2022. ISBN: 978-1-0981-2122-8.  
* **Bibliografía complementaria:**  
  * Chollet, François. Deep Learning with Python (2a ed.). Manning, 2021. ISBN: 978-1-6172-9686-4.  
  * Sossa Azuela, Juan Humberto; Reyes Cortés, Fernando. Inteligencia Artificial Aplicada a Robótica y Automatización. Marcombo, 2021. ISBN: 978-84-267-3316-0.  
  * Reis, M. J. C. S. et al. Lightweight Signal Processing and Edge AI for Real-Time Anomaly Detection in IoT Sensor Networks. MDPI Sensors, 2025. [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12610206/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12610206/)
  * David J. Malan. CS50's Introduction to Programming with Python. Harvard University. [https://cs50.harvard.edu/python/2022/](https://cs50.harvard.edu/python/2022/)  
  * Brian Yu, David J. Malan. CS50's Introduction to Artificial Intelligence with Python. Harvard University. [https://cs50.harvard.edu/ai/2024/](https://cs50.harvard.edu/ai/2024/)

## Instalaciones, equipos y software  {#instalaciones-equipos-y-software}

* Computadora  
* Buscador web  
* Google Classroom  
* Procesador de texto  
* Terminal  
* Visual Studio Code  
* Arduino IDE  
* Arduino Nano  
* Sensores: LM35, HC-SR04, LDR, A3144, HW-870, GP2Y0A21YK0F, TCRT5000, TCS3200, LJ12A3-4-Z/BX  
* Actuadores: Servomotor, Motor CD, Buzzer, LED, LED RGB  
* Siemens S7-1214C PLC (disponible en laboratorio)  
* Maquetas de laboratorio: bandas transportadoras, pistones, sensores capacitivos e inductivos  
* Python  
  * `numpy`
  * `pandas`
  * `matplotlib`
  * `scikit-learn`
  * `tensorflow`
  * `pyserial`
  * `joblib`
  * `snap7`
