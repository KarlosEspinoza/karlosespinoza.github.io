---
layout: default
title: De la señal a la decisión
---
[Inicio](/curso/senal)

---

- [Información del taller](#informacion-del-taller)
    - [Características](#caracteristicas)
    - [Alineación con el programa educativo](#alineacion-con-el-programa-educativo)
- [Descripción](#descripcion)
    - [Justificación](#justificacion)
    - [Objetivos](#objetivos)
    - [Requisitos previos del participante](#requisitos-previos)
    - [Contenido](#contenido)
- [Metodología y acreditación](#metodologia-y-acreditacion)
    - [Metodología](#metodologia)
    - [Acreditación](#acreditacion)
- [Planeación](#planeacion)
- [Recursos](#recursos)
    - [Material y equipo](#material-y-equipo)
    - [Bibliográficos](#bibliograficos)

---

# Información del taller {#informacion-del-taller}

## Características {#caracteristicas}

* **Universidad:** Universidad de Guadalajara
* **Centro Universitario:** Centro Universitario de la Costa Sur
* **Denominación:** De la señal a la decisión. Taller práctico de adquisición de señales y aprendizaje automático en sistemas embebidos
* **Tipo:** Taller práctico
* **División:** División de Desarrollo Regional
* **Departamento:** Departamento de Ingenierías
* **Academia:** Computación
* **Programa Educativo al que se dirige:** Ingeniería Mecatrónica
* **Dirigido a:** Estudiantes de sexto semestre, que cursarán Inteligencia Artificial (IE043) en el ciclo siguiente
* **Nivel:** Pregrado
* **Modalidad:** Presencial
* **Cupo:** 15 participantes
* **Duración total:** 7 horas
* **Horas teoría:** 0
* **Horas práctica:** 7
* **Fechas:** Lunes 28 de septiembre de 2026 (3 horas) y martes 29 de septiembre de 2026 (4 horas)
* **Aula:** Por confirmar con la coordinación de la carrera
* **Instructor:** Karlos Emmanuel Espinoza Ramos
* **Correo electrónico del instructor:** [karlos.espinoza@academicos.udg.mx](mailto:karlos.espinoza@academicos.udg.mx)
* **Origen:** Solicitud de la coordinación de la carrera de Ingeniería Mecatrónica
* **Material del participante:** Kit de hardware propio, **requisito de inscripción** (ver [Material y equipo](#material-y-equipo))
* **Programa elaborado por:** Karlos Emmanuel Espinoza Ramos
* **Fecha de elaboración:** Septiembre de 2026

## Perfil del instructor

* ***Descripción*****:** Ingeniero con conocimientos en el desarrollo de algoritmos inteligentes y sistemas de control. Ha realizado publicaciones científicas sobre desarrollo de software y algoritmos.
* ***Referencias*****:**
  * ORCID: [0000-0002-2759-2961](https://orcid.org/0000-0002-2759-2961)
  * Google Académico: [https://scholar.google.es/citations?user=oSspIj4AAAAJ\&hl=es\&oi=sra](https://scholar.google.es/citations?user=oSspIj4AAAAJ&hl=es&oi=sra)

# Descripción {#descripcion}

## Justificación {#justificacion}

Cada ciclo, el grupo que ingresa a Inteligencia Artificial (IE043) pierde las primeras semanas del curso en tres obstáculos que no son de contenido:

1. **El entorno de desarrollo no está instalado.** Python sin la variable PATH configurada, el controlador CH340 ausente, bibliotecas sin instalar. Resolverlo en el aula consume sesiones completas, agravado por la calidad de la conexión a internet.
2. **El hardware llega tarde.** La asignatura requiere que el estudiante trabaje con su sensor desde la segunda semana. El margen entre la elección del dominio y la primera práctica es corto, y cada ciclo hay estudiantes que quedan fuera de las primeras actividades por no contar con el material.
3. **El vocabulario técnico es completamente nuevo.** Conjunto de datos, característica, entrenamiento y modelo son términos que aparecen juntos en la tercera semana, sin que el estudiante los haya utilizado antes en la práctica.

Este taller atiende los tres antes de que inicie el curso. No es una introducción a la inteligencia artificial: es la puesta a punto del grupo. Al término, cada participante cuenta con su entorno instalado y verificado, su kit de hardware adquirido y funcionando, un repositorio propio en GitHub y el flujo completo de un sistema de clasificación recorrido una vez con sus propias manos.

**El material lo aporta cada participante.** El Centro Universitario no proporciona kit ni equipo en préstamo para esta actividad. Contar con el kit completo y con el software instalado es **requisito de inscripción**, y ambos se detallan en la guía previa que se distribuye con la convocatoria.

## Objetivos {#objetivos}

* **Objetivo general:** Recorrer de principio a fin el flujo de un sistema de clasificación basado en aprendizaje automático, desde la adquisición de la señal de un sensor hasta la actuación sobre un dispositivo físico, sobre una plataforma embebida.
* **Objetivos específicos:**
  * Montar un circuito de adquisición con dos sensores ópticos sobre una plataforma Arduino y verificar su lectura por el puerto serie.
  * Adquirir la señal desde Python mediante `pyserial` y visualizarla en tiempo real.
  * Construir un conjunto de datos etiquetado a partir de mediciones propias.
  * Extraer características en el dominio del tiempo que representen cada medición.
  * Entrenar un clasificador y leer las reglas de decisión que el modelo obtiene de los datos.
  * Cerrar el bucle de control sensor -> características -> modelo -> actuador.
  * Publicar el proyecto en un repositorio de GitHub.
* **Elementos del desarrollo del taller:**
  * Conocimientos: Adquisición de señales con Arduino. Comunicación serie entre microcontrolador y computadora. Conjunto de datos etiquetado. Ingeniería de características en el dominio del tiempo. Clasificación supervisada con árboles de decisión. Bucle de control sensor -> modelo -> actuador. Control de versiones con Git.
  * Habilidades y destrezas: Montaje de circuitos en protoboard. Ejecución y lectura de código en Python. Interpretación de gráficas de señales. Diagnóstico de fallas de conexión y de entorno.
  * Desarrollo del aprendizaje progresivo: Responsabilidad sobre el material propio, orden en el trabajo experimental y perseverancia ante la falla técnica.

## Requisitos previos del participante {#requisitos-previos}

Son condición de inscripción y se verifican **antes** del taller, con evidencia enviada por correo electrónico a más tardar el viernes 25 de septiembre de 2026:

1. **Computadora portátil propia** con Windows y su cargador.
2. **Kit de hardware completo**, adquirido por el participante.
3. **Software instalado y verificado:** Python 3, Visual Studio Code, Git, Arduino IDE y el controlador CH340, los tres primeros accesibles desde la línea de comandos.
4. **Bibliotecas de Python instaladas:** `pyserial`, `numpy`, `pandas`, `matplotlib`, `scikit-learn` y `joblib`.
5. **Cuenta de GitHub** creada.

La guía previa con la lista de compras, el procedimiento de instalación y las cuatro comprobaciones con evidencia está publicada en [karlosespinoza.github.io/curso/senal/requisitos](/curso/senal/requisitos/) y se distribuye junto con la convocatoria.

No se requiere experiencia previa en aprendizaje automático ni en electrónica. Se requiere haber programado antes en algún lenguaje.

## Contenido {#contenido}

Todo el taller se construye sobre un único caso práctico: un **clasificador de tres piezas**. Un sensor óptico mide la luz que refleja cada pieza, Python resume la medición en cuatro características, un árbol de decisión determina de qué material se trata y un LED RGB señala la decisión con un color.

Las tres piezas son las mismas para todos los participantes (cartulina blanca, cartulina negra y papel aluminio), de modo que el grupo trabaja con un solo montaje, un solo conjunto de programas y un solo procedimiento.

* **Contenido temático:**
1. Adquisición de la señal
2. Construcción del conjunto de datos
3. Extracción de características
4. Entrenamiento del clasificador
5. Cierre del bucle de control

* **Estructura conceptual del taller:**

1. Adquisición de la señal
    1. El reparto de tareas entre el microcontrolador y la computadora
    1. Montaje del circuito: sensor de reflexión TCRT5000 y fotorresistencia
    1. Lectura analógica y transmisión por el puerto serie
    1. Dependencia de las condiciones de iluminación: comparación entre los dos sensores
    1. Adquisición desde Python con `pyserial` y visualización en tiempo real
1. Construcción del conjunto de datos
    1. Concepto de ventana de muestreo
    1. Etiquetado de las mediciones
    1. Registro en archivo CSV y verificación del conjunto obtenido
1. Extracción de características
    1. Por qué no se entrena con la señal cruda
    1. Características en el dominio del tiempo: media, desviación, mínimo y máximo
    1. Visualización de la separación entre clases
    1. Selección de la variable de entrada y criterio de descarte
1. Entrenamiento del clasificador
    1. Separación entre datos de entrenamiento y datos de prueba
    1. Árbol de decisión: entrenamiento y exactitud
    1. Lectura de las reglas obtenidas por el modelo
    1. Matriz de confusión y efecto de la profundidad del árbol
    1. Persistencia del modelo entrenado
1. Cierre del bucle de control
    1. Correspondencia obligatoria entre entrenamiento y operación
    1. Predicción sobre una medición nueva
    1. Actuación sobre el LED RGB según la decisión del modelo
    1. Publicación del proyecto en GitHub
    1. Comportamiento del sistema ante una pieza de una clase no vista

# Metodología y acreditación {#metodologia-y-acreditacion}

## Metodología {#metodologia}

* **Aprendizaje experiencial** como eje: las 7 horas se dedican a construir un sistema funcional. No hay exposición teórica ni presentaciones; los conceptos se nombran en el momento en que aparecen en la pantalla del participante.
* **Código proporcionado y ejecutado, no escrito desde cero.** El participante recibe los siete programas completos, los ejecuta, observa el resultado y modifica parámetros para comprobar su efecto. Esta es la diferencia deliberada con la asignatura IE043, donde el estudiante escribe el código y dispone de un semestre para equivocarse.
* **Un solo camino para todo el grupo:** mismo sensor, mismas piezas, mismos programas. Con un instructor y 15 participantes, la uniformidad del montaje es lo que permite atender una falla individual sin detener al grupo.
* **Instalación previa verificada:** ninguna instalación ocurre durante el taller. El entorno se instala antes con la guía previa y se comprueba con evidencia, lo que permite que la primera sesión inicie con trabajo productivo.
* **Puntos de recuperación:** el instructor proporciona los archivos intermedios del proceso (conjunto de datos, características y modelo entrenado) en memoria USB. Un participante que no logre completar una etapa toma el archivo correspondiente y continúa con las siguientes, sin quedar excluido del resto del taller.
* **Trabajo en pareja como contingencia:** el participante que llegue sin equipo o sin kit se integra con un compañero. El taller no se detiene.
* **Soporte tecnológico:** Arduino IDE, Python, Visual Studio Code, Git y GitHub. Todo el trabajo se realiza desde la línea de comandos de Windows.

## Acreditación {#acreditacion}

La constancia se otorga al participante que cumpla las dos condiciones:

| Requisito | Evidencia |
|---|---|
| **Asistencia a las 7 horas** | Lista de asistencia de las dos sesiones |
| **Sistema funcionando** | Repositorio público en GitHub con los programas, el conjunto de datos, el modelo entrenado y el bucle de control operando |

No hay examen. La evidencia es el sistema construido y su publicación, que además queda como referencia del participante para el curso siguiente.

# Planeación {#planeacion}

## Sesión 1. Del sensor a los datos (lunes 28 de septiembre, 3 horas)

| Duración | Contenido |
|---|---|
| 20 min | Encuadre del taller y verificación del entorno de cada participante |
| 50 min | Montaje del circuito con TCRT5000 y fotorresistencia. Programa de lectura en el Arduino. Observación de la señal en el monitor serie y comparación del comportamiento de los dos sensores ante un cambio de iluminación |
| 10 min | Receso |
| 50 min | Adquisición de la señal desde Python con `pyserial`. Visualización en tiempo real de las lecturas de los dos sensores |
| 50 min | Captura de ventanas etiquetadas de las tres piezas. Construcción y verificación del archivo `datos.csv` |

**Resultado de la sesión:** conjunto de datos etiquetado con 30 ventanas de medición, propiedad de cada participante.

## Sesión 2. De los datos a la decisión (martes 29 de septiembre, 4 horas)

| Duración | Contenido |
|---|---|
| 15 min | Recuperación de participantes sin conjunto de datos, a partir del archivo de respaldo |
| 45 min | Extracción de características en el dominio del tiempo. Visualización de la separación entre las tres clases y criterio para descartar el segundo sensor |
| 45 min | Entrenamiento del árbol de decisión. Exactitud, matriz de confusión y lectura de las reglas obtenidas por el modelo. Efecto de la profundidad del árbol |
| 15 min | Receso |
| 60 min | Cierre del bucle de control: predicción sobre una medición nueva y actuación sobre el LED RGB. Correspondencia entre el procedimiento de entrenamiento y el de operación |
| 30 min | Publicación del proyecto en GitHub |
| 30 min | Comportamiento del sistema ante una pieza de una clase no vista. Cierre y vínculo con la asignatura IE043 |

**Resultado de la sesión:** sistema de clasificación completo, operando y publicado.

# Recursos {#recursos}

## Material y equipo {#material-y-equipo}

### Que aporta el participante

**El kit es requisito de inscripción.** El Centro Universitario no presta material para esta actividad.

| Componente | Cantidad |
|---|---|
| Computadora portátil con Windows y cargador | 1 |
| Arduino Nano (o compatible) con cable USB de datos | 1 |
| Protoboard | 1 |
| Jumpers Dupont macho-macho y macho-hembra | 20 a 40 |
| Módulo sensor de reflexión TCRT5000 | 1 |
| Fotorresistencia (LDR) | 1 |
| LED RGB de cátodo común, 5 mm | 1 |
| Resistencias de 220 ohm | 3 |
| Resistencia de 10k ohm | 1 |
| Piezas de cartulina blanca, cartulina negra y papel aluminio, de 5 x 5 cm | 3 de cada una |

Costo aproximado del kit completo: de 350 a 550 pesos. El material es el mismo que el participante utilizará durante la asignatura IE043 en el ciclo siguiente, por lo que no constituye un gasto exclusivo de esta actividad.

### Que aporta el instructor

* Los siete programas del taller, completos y probados.
* Memorias USB con los instaladores del software, las bibliotecas de Python para instalación sin conexión y los archivos de respaldo de cada etapa.
* Material de referencia publicado y de acceso abierto en [karlosespinoza.github.io/curso/senal](/curso/senal/).

### Requerimientos del aula

* **Contactos eléctricos suficientes para 15 computadoras portátiles**, distribuidos de modo que no dependan de una sola extensión.
* **Mesas de trabajo** que permitan montar un protoboard al lado de la computadora.
* **Proyector o televisor** con conexión HDMI.
* Capacidad para 15 participantes más el instructor.

No se requiere conexión a internet en el aula. El taller está diseñado para operar sin ella.

## Bibliográficos {#bibliograficos}

* **Bibliografía básica:**
  * Géron, Aurélien. Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow (3a ed.). O'Reilly, 2022. ISBN: 978-1-0981-2597-4.
  * VanderPlas, Jake. Python Data Science Handbook (2a ed.). O'Reilly, 2022. ISBN: 978-1-0981-2122-8.
  * scikit-learn developers. scikit-learn User Guide: Decision Trees. [https://scikit-learn.org/stable/modules/tree.html](https://scikit-learn.org/stable/modules/tree.html)
* **Bibliografía complementaria:**
  * Arduino. Language Reference. [https://www.arduino.cc/reference/en/](https://www.arduino.cc/reference/en/)
  * Liechti, Chris. pySerial Documentation. [https://pyserial.readthedocs.io/](https://pyserial.readthedocs.io/)
  * Sossa Azuela, Juan Humberto; Reyes Cortés, Fernando. Inteligencia Artificial Aplicada a Robótica y Automatización. Marcombo, 2021. ISBN: 978-84-267-3316-0.
