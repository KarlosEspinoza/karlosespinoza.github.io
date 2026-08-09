---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)


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
* **Asignatura:** Fundamentos de Sistemas Operativos
* **Denominación:** Fundamentos de Sistemas Operativos
* **Clave de la asignatura:** IN235
* **División:** División de Desarrollo Regional
* **Departamento:** Departamento de Ingenierías
* **Academia:** Computación
* **Programa Educativo al que está adscrita:** Ingeniería en Teleinformática
* **Tipo:** Curso-Taller (CT)
* **Nivel:** Pregrado
* **Área de formación:** Optativa Abierta
* **Modalidad:** Presencial
* **Prerrequisitos:** IN227 Fundamentos de Computación
* **Horas teoría:** 40
* **Hora práctica:** 40
* **Horas totales:** 80
* **Créditos:** 8
* **Aula:** C5
* **Horario de clase:** Lunes y Miércoles 15:00 hrs a 16:59 hrs
* **Asesor:** Karlos Emmanuel Espinoza Ramos
* **Correo electrónico del asesor:** [karlos.espinoza@academicos.udg.mx](mailto:karlos.espinoza@academicos.udg.mx)  
* **Horario de asesoría:** Agendar por [correo electrónico](mailto:karlos.espinoza@academicos.udg.mx) o en [Google Calendar](https://calendar.app.google/ZZw7VbjTCUFAmac29)  
* **Jefe de departamento:** Domingo Velázquez Pérez 
* **Correo electrónico del jefe de departamento:** [domingov@cucsur.udg.mx](domingov@cucsur.udg.mx)
* **Presidente de la académia:** Gerardo Joel Medina Reyes
* **Secretario de la académia:** Alfonso Ramos Michel
* **Programa actualizado por:** Karlos Emmanuel Espinoza Ramos
* **Fecha de actualización del programa:** Julio de 2026

## Alineación con el programa educativo {#alineacion-con-el-programa-educativo}

* **Relación con el perfil de egreso:**
  * **Atributo de Egreso 2 Nivel Introductorio:** Identifica, analiza y resuelve problemas complejos de las áreas de sistemas de información y comunicación digital, aplicando conocimientos de ingeniería, matemática y ciencias básicas, además formula conclusiones fundamentadas en investigaciones y bibliografía especializada, considerando los principios integrales que promuevan el desarrollo sostenible.
  * **Atributo de Egreso 4 Nivel Medio:** Reproduce ambientes simulados que facilitan la investigación de problemas complejos en las áreas de sistemas de información y comunicación digital utilizando métodos de investigación, diseño de experimentos y análisis e interpretación de datos, integrando conocimiento especializado para sintetizar información y obtener conclusiones fundamentadas y válidas.
  * **Atributo de Egreso 6 Nivel Medio:** Desarrolla ambientes simulados que permiten analizar e interpretar datos en sistemas de información y comunicación digital, evaluando los impactos sociales, económicos, legales, ambientales y de sostenibilidad, para proponer soluciones integrales a problemas complejos en el área de la Ingeniería Teleinformática.
* **Relación con el plan de estudios:** La comprensión del sistema operativo es la base sobre la que se construye el desarrollo de software, la administración de servidores y la operación de sistemas distribuidos; áreas centrales de la Ingeniería en Teleinformática y punto de partida para las materias Sistemas Operativos Abiertos, Fundamentos de Programación de Sistemas y Tecnología Cliente Servidor del siguiente ciclo.

* **Perfil del profesor**
* ***Descripción*****:** Ingeniero con experiencia en sistemas operativos, redes de cómputo y desarrollo de software. Cuenta con publicaciones científicas en el área de computación y sistemas de información.
* ***Referencias*****:**
  * ORCID: [0000-0002-2759-2961](https://orcid.org/0000-0002-2759-2961)
  * Google Académico: [https://scholar.google.es/citations?user=oSspIj4AAAAJ\&hl=es\&oi=sra](https://scholar.google.es/citations?user=oSspIj4AAAAJ&hl=es&oi=sra)

# Descripción {#descripcion}

## Objetivos {#objetivos}

* **Objetivo general:** El alumno entenderá el concepto de sistemas operativos e identificará las partes que lo integran a través del uso del mismo.
* **Objetivos específicos:**
  * Desarrollar habilidades en el uso de los sistemas operativos para los diferentes equipos de cómputo.
  * Desarrollar la capacidad de crear simuladores de control de procesos, administración de archivos y de administración de memoria para reforzar los conocimientos del curso.
* **Elementos del desarrollo de la unidad de aprendizaje:**
  * Conocimientos: Comprensión de la estructura y funcionamiento interno del sistema operativo. Administración de procesos, memoria, entrada/salida, sistemas de archivos y comunicación en red a nivel de sistema operativo.
  * Habilidades y Destrezas: Operación de sistemas Linux desde la línea de comandos. Programación concurrente en Java. Análisis y diagnóstico del comportamiento del sistema (procesos, memoria, servicios). Comprensión de los contenedores como aplicación del sistema operativo. Implementación de los subsistemas del SO en un servidor funcional.
  * Valores y Actitudes: Responsabilidad, trabajo en equipo, pensamiento crítico y ética profesional en el uso de los sistemas de cómputo.

## Contenido {#contenido}

### Enfoque del curso: orientado a la demanda laboral

El contenido se reorganiza para responder a lo que el campo laboral pide hoy en los roles de software, infraestructura y sistemas. La evidencia de fuentes primarias (Stack Overflow Developer Survey 2025, CNCF Annual Survey 2025, W3Techs, TOP500) muestra dos hechos claros: el destino del software es Linux y los contenedores son el sustrato estándar de producción. El mercado no pide menos teoría de sistemas operativos: pide poder aplicarla para operar, diagnosticar y automatizar los sistemas que corren sobre el SO.

Por eso cada unidad se trabaja desde su aplicación real. Las herramientas que paga el mercado descansan en los conceptos clásicos del temario:

| Lo que pide el campo laboral | Concepto del temario que lo sostiene |
|---|---|
| Operar Linux en producción (procesos, logs, servicios, permisos) | Perspectivas, procesos, llamadas al sistema |
| Docker y contenedores | Procesos, aislamiento (namespaces, cgroups), archivos |
| Diagnóstico de servicios (concurrencia, OOM, fugas de memoria) | Hilos, condición de carrera, exclusión mutua, memoria |
| Sockets y microservicios | Comunicación entre procesos, red |
| Observabilidad y automatización | Llamadas al sistema, scripting, archivos de log |

Todo se construye sobre un único caso a lo largo del semestre: un **servidor de pedidos** que recibe órdenes desde varias terminales de cajero, las procesa y gestiona un inventario compartido (el mismo tipo de sistema que opera un punto de venta como SICAR). Cada unidad agrega una capa funcional al sistema.

* **Contenido temático:**
1. Perspectivas iniciales: el SO y Linux en producción
2. Procesos y concurrencia
3. Administración de memoria y diagnóstico
4. Administración de Entrada/Salida y llamadas al sistema
5. Sistemas de archivos y persistencia
6. Interfaz del SO a la red: sockets

* **Estructura conceptual del curso:**

1. Perspectivas iniciales: el SO y Linux en producción
    1. Concepto de Sistema Operativo y el Kernel
    1. Clasificación y estructura (niveles o estratos de diseño)
    1. Interfaz del SO con los programas: llamadas al sistema (concepto articulador del curso)
        1. Espacio de usuario y espacio del kernel
        1. Como la JVM usa syscalls (crear hilos, abrir archivos, leer, escribir, crear sockets)
        1. Por que el SO arbitra el acceso al hardware
    1. Modelo de proteccion: por que el SO controla el acceso a los recursos
        1. Anillos de privilegio (espacio de usuario y espacio del kernel)
        1. Por que un proceso no puede leer la memoria de otro directamente
        1. Permisos de proceso en Linux (panorama)
    1. Por qué el destino del software es Linux (panorama del mercado)
    1. Arranque del sistema: firmware (BIOS/UEFI), cargador de arranque, kernel y el primer proceso (PID 1)
    1. Operar Linux: procesos (ps, top), estados de proceso, el sistema de archivos /proc
    1. Servicios y registros del sistema: el PID 1 como administrador de servicios (systemctl, journalctl); se retoma en la Unidad 2 al programar el apagado ordenado
    1. Qué es un contenedor: aislamiento con namespaces y cgroups (Docker como SO aplicado, nivel conceptual)
    1. El servidor de pedidos como proceso observable del sistema operativo
1. Procesos y concurrencia
    1. Concepto, modelo, estados y transiciones de los procesos
    1. Procesos ligeros: hilos o hebras
    1. Concurrencia (el núcleo del curso)
        1. Condición de carrera (como bug real de producción)
        1. Sección crítica y exclusión mutua
        1. Sincronización y semáforos
        1. Bloqueos (deadlocks)
        1. Paso de mensajes
        1. Transacciones atómicas
    1. Interrupciones
    1. Comunicación entre procesos
        1. Señales
        1. Alarmas
        1. Tuberías (pipes) y tuberías con nombre (FIFO)
        1. Apagado ordenado de un servicio: la secuencia SIGTERM, espera y SIGKILL que aplica systemd
    1. Planificación de procesos
        1. Por lotes y multiprogramación
        1. Primero en llegar primero en ser atendido (FIFO)
        1. Panorama comparativo: Tiempo Real, Distribuido y Embebido
1. Administración de memoria y diagnóstico
    1. Conceptos básicos, organización y administración
    1. Memoria virtual, memoria real e intercambio (SWAP)
    1. El catálogo de productos en memoria (caché)
    1. Diagnóstico: consumo, fugas de memoria y el OOM killer
1. Administración de Entrada/Salida y llamadas al sistema
    1. Controladores y mecanismos de los periféricos
    1. Estructura de datos para manejo de E/S
    1. Operaciones de E/S
    1. Llamadas al sistema (lectura del catálogo, escritura de recibos)
1. Sistemas de archivos y persistencia
    1. Concepto, objetivos y componentes de un sistema de archivos
    1. Organización física y mecanismos de acceso (secuencial y directo)
    1. Manejo del espacio en memoria secundaria
    1. El sistema de archivos de Linux (vía WSL2)
    1. Log persistente de pedidos (pedidos.txt) y búsqueda por ID
1. Interfaz del SO a la red: sockets
    1. Por que los sockets son una abstraccion del SO (no solo de la red)
    1. Sockets: servidor y cliente
    1. Flujos de entrada y de salida
    1. El cajero como cliente que se conecta por socket al servidor


# Metodología y evaluación {#metodologia-y-evaluacion}

## Métodos, instrumentos y reglas {#metodos-instrumentos-y-reglas}

* **Métodos e instrumentos:**
  * **Aprendizaje Basado en Proyectos (ABP)** como eje central: las prácticas individuales y un proyecto integrador en equipo sostienen el aprendizaje a lo largo del semestre. Todo gira en torno a un único caso, el servidor de pedidos, que crece semana a semana.
  * **Aprendizaje invertido (actividades previas a la clase):** antes de cada sesión el alumno realiza una actividad autoaplicable (lectura, video del asesor, cuestionario o laboratorio guiado paso a paso) que prepara el concepto del tema y avanza directamente su proyecto. Así el alumno llega a clase con el contexto ya construido.
  * **Aprendizaje activo durante la clase:** el tiempo de clase se dedica a aplicar lo preparado sobre el caso central: resolver problemas, construir y depurar código en vivo, comparar soluciones entre pares y demostrar el avance. El asesor guía, retroalimenta y resuelve dudas en el momento.
  * **Aprendizaje Colaborativo:** el proyecto integrador se desarrolla en equipo, con resolución conjunta de problemas de concurrencia, administración de memoria y sistemas de archivos.
  * **Aprendizaje con Soporte Tecnológico:** terminal Linux (WSL2), Java para programación concurrente, Git y GitHub.
  * **Evaluación y retroalimentación formativas:** en cada revisión de avances el asesor retroalimenta el código y la BITACORA.md entregados; las preguntas (orales o escritas) y la revisión de evidencias permiten detectar y corregir brechas antes de la evaluación sumativa.
* **Instrumentos de evaluación:**
  * Evidencias en el repositorio GitHub (código, commits, demo)
  * BITACORA.md donde el alumno explica con sus palabras los conceptos del SO aplicados en su proyecto
  * Preguntas (orales o escritas), 2 por revisión de avances
* **Reglas:**
  * **Reglamento General de Evaluación y Promoción de Alumnos:** [https://secgral.udg.mx/sites/default/files/Normatividad\_general/rgepa-oct-2017.pdf](https://secgral.udg.mx/sites/default/files/Normatividad_general/rgepa-oct-2017.pdf)
  * **Asistencia:** El alumno deberá cumplir con el 80% de asistencias para tener derecho a examen ordinario, y con el 65% para examen extraordinario. Cada semana se asigna una actividad de aprendizaje invertido previa a la clase, cuyo producto se aplica y revisa durante la sesión; su entrega forma parte del seguimiento de la participación y el avance.
  * **Reglas del aula:**
    * Respetar el espacio de trabajo propio y de los compañeros, manteniéndolo ordenado y limpio.
    * Usar los equipos y herramientas únicamente con fines académicos.
  * **Reglas de la sesión:**
    * Mantener el respeto con los estudiantes y el asesor.
    * Respetar la participación de los estudiantes y el asesor.

## Evaluación y rúbricas {#evaluacion-y-rubricas}

* **Evaluación:**
  * **Proyecto integrador (equipo):** 50%
  * **Prácticas:** 35%
  * **Actividades integradoras:** 5%
  * **Asistencia:** 10%

Las **actividades integradoras** son las que la coordinación de la carrera organiza a nivel de programa educativo (jornadas, eventos academicos y actividades transversales). La coordinación informa al asesor el porcentaje alcanzado por cada alumno dentro de ese 5%, que se suma a la calificacion final.

* **Instrumentos de revisión de avances (prácticas):**

| Instrumento | Descripción | Peso dentro del proyecto |
|---|---|---|
| Evidencias | Código en GitHub, commits y demo que demuestren el avance, entregados antes del día de la revisión | 50% |
| BITACORA.md | Documento en el repositorio donde el alumno explica con sus palabras los conceptos del SO aplicados en su proyecto | 30% |
| Preguntas (orales o escritas) | 2 preguntas sobre el trabajo realizado y los conceptos involucrados, aplicadas el día de la revisión | 20% |

En el **proyecto integrador** se agrega un cuarto instrumento, la autoevaluación entre pares, y los pesos quedan: Evidencias 45%, BITACORA.md 25%, Preguntas (orales o escritas) 20% y Autoevaluación entre pares 10%. Cada integrante entrega su autoevaluación de forma privada y anónima antes de cada revisión; el detalle está en la página del proyecto integrador.

# Planeación {#planeacion}

El ciclo 2026B comprende del 17 de agosto al 11 de diciembre de 2026. El curso sigue un modelo de aprendizaje invertido: antes de cada sesión el alumno realiza una actividad que prepara el concepto y avanza su proyecto, y el tiempo de clase se dedica a actividades de aprendizaje activo sobre el caso central (servidor de pedidos). Como reforzamiento posterior, cada semana el alumno integra lo aplicado en su proyecto y registra una entrada en BITACORA.md, versionada en GitHub. La retroalimentación formativa se da en las revisiones de avances (comentarios del asesor sobre el código y la BITACORA.md entregados). Se contemplan tres sesiones de revisión de avances. El alumno hace push a GitHub de sus evidencias y de su BITACORA.md antes del día de la revisión (a más tardar en la sesión previa de esa semana), de modo que el asesor revise el código y la bitácora con anticipación; la sesión de revisión se dedica entonces a dos preguntas (orales o escritas): una sobre su propio trabajo y otra sobre los temas vistos en clase. En cada una se revisan las prácticas y el proyecto integrador.

| Semana | Fechas | Actividades realizadas antes de la clase (aprendizaje invertido) | Actividades de aprendizaje activo a realizar durante la clase |
|---|---|---|---|
| 1 | 17 y 19 ago | Encuadre del curso y Tarea 0: configuración del entorno (WSL2, Git, GitHub, repo) | U1: discusión guiada sobre qué es un SO, el kernel, las llamadas al sistema y el modelo de proteccion (usuario/kernel); por qué el destino del software es Linux |
| 2 | 24 y 26 ago | Operar Linux: cadena de arranque (firmware, cargador, kernel, PID 1) y el árbol de procesos con ps, top, estados y /proc | U1: primer proceso Java vivo y observable; procesos huérfanos y zombis; comparación de estados; costo de crear un proceso |
| 3 | 31 ago y 2 sep | Qué es un contenedor: namespaces y cgroups (lectura/video) | U1 a U2: demo de Docker como SO aplicado; modelado del concepto de proceso sobre el caso |
| 4 | 7 y 9 sep | Estados y transiciones de procesos. Hilos (guía) | U2: construir hilos en Java; el servidor acepta pedidos en texto plano |
| 5 | 14 y 16 sep (1) | Concurrencia: condición de carrera (guía con ejemplo reproducible) | Sin sesión (1) |
| 6 | 21 y 23 sep | Sección crítica, exclusión mutua y semáforos (guía) | U2: resolver en equipo el caso de dos cajeros simultáneos sin romper el inventario (semáforo) |
| 7 | 28 y 30 sep | Bloqueos (deadlocks) y sincronización (guía) | U2: depurar y diagnosticar problemas de concurrencia sobre el caso |
| 8 | 5 y 7 oct | Comunicación entre procesos: señales, apagado ordenado y pipes (guía) | U2: implementar IPC y el apagado ordenado del servidor; medir lo que se pierde según la señal recibida; opcionalmente publicarlo como servicio del sistema (systemd) |
| 9 | 12 y 14 oct | Push a GitHub de evidencias y BITACORA.md (entrega previa a la revisión) | **Revisión de avances 1**: preguntas orales o escritas, U1 y U2 (prácticas e integrador) |
| 10 | 19 y 21 oct | Planificación de procesos: lotes, FIFO y panorama (RT, distribuido, embebido) (guía) | U2: comparar políticas de planificación aplicadas al caso |
| 11 | 26 y 28 oct | Administración de memoria: virtual, real e intercambio (guía) | U3: implementar el catálogo de productos en memoria (caché) |
| 12 | 2 y 4 nov (2) | Diagnóstico de memoria: consumo, fugas y OOM killer (guía) | U3: construir el buffer de pedidos pendientes y diagnosticar su consumo |
| 13 | 9 y 11 nov | Llamadas al sistema y operaciones de E/S (guía) | U4: implementar lectura del catálogo y escritura de recibos con syscalls |
| 14 | 16 y 18 nov (3) | Push a GitHub de evidencias y BITACORA.md (entrega previa a la revisión) | **Revisión de avances 2**: preguntas orales o escritas, U3 y U4 (prácticas e integrador) |
| 15 | 23 y 25 nov | Sistemas de archivos: acceso y el FS de Linux (guía) | U5: construir el log persistente de pedidos (pedidos.log) y búsqueda por ID |
| 16 | 30 nov y 2 dic | El socket como abstraccion del SO. Sockets servidor y cliente. Flujos de E/S (guía) | U6: implementar el cajero como cliente que se conecta por socket |
| 17 | 7 y 9 dic | Integración final y push a GitHub de la entrega (evidencias y BITACORA.md) | **Revisión final**: preguntas orales o escritas y cierre (prácticas e integrador) |

(1) Miércoles 16 de septiembre: Día de la Independencia, sin sesión esa semana.  
(2) Lunes 2 de noviembre: Día de Muertos, posible suspensión de actividades.  
(3) Lunes 16 de noviembre: Día de la Revolución (observado), sin sesión esa fecha.

# Recursos

## Bibliográficos {#bibliograficos}

* **Bibliografía básica:**
  * Arpaci-Dusseau, Remzi H.; Arpaci-Dusseau, Andrea C. *Operating Systems: Three Easy Pieces* (OSTEP). Arpaci-Dusseau Books, edición en línea actualizada (v1.10). Disponible sin costo: [https://www.ostep.org](https://www.ostep.org)
  * Tanenbaum, Andrew S.; Bos, Herbert. *Modern Operating Systems*, 5.ª edición. Pearson, 2022.
  * Silberschatz, Abraham; Galvin, Peter B.; Gagne, Greg. *Operating System Concepts*, 10.ª edición. Wiley, 2018.
  * Sol Llaven, Daniel. *Sistemas operativos: panorama para ingeniería en computación e informática*. Patria, 2016.
* **Bibliografía complementaria:**
  * Feria Martínez, José F. *Administración de sistemas operativos*. Síntesis, 2021.
  * Goetz, Brian; et al. *Java Concurrency in Practice*. Addison-Wesley, 2006.
  * Kerrisk, Michael. *The Linux Programming Interface*. No Starch Press, 2010.
  * Shotts, William. *The Linux Command Line*, 5.ª edición en línea. No Starch Press, 2024. Disponible sin costo: [https://linuxcommand.org/tlcl.php](https://linuxcommand.org/tlcl.php)
  * Poulton, Nigel. *Docker Deep Dive*, edición 2024. Independiente, 2024.
  * Gregg, Brendan. *Systems Performance: Enterprise and the Cloud*, 2.ª edición. Pearson, 2020.

## Instalaciones, equipos y software {#instalaciones-equipos-y-software}

* Computadora con Windows 10/11
* WSL2 (Windows Subsystem for Linux)
* Java JDK 21 o superior
* Visual Studio Code
* Terminal (bash)
* Buscador web
* Google Classroom
