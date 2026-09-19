# Estrategia del taller

Documento interno. Aqui vive el *por que* de cada decision del taller. Si algo se va a
cambiar, se cambia aqui primero y despues en el material.

---

## 1. Identidad

* **Nombre:** De la senal a la decision
* **Subtitulo:** Taller practico de adquisicion de senales y aprendizaje automatico en sistemas embebidos
* **Dirigido a:** 6to semestre de Ingenieria Mecatronica, CUCSUR UdeG
* **Cupo:** 15 alumnos
* **Fechas:** lunes 28 de septiembre de 2026 (3 h) y martes 29 de septiembre de 2026 (4 h)
* **Duracion total:** 7 horas
* **Instructor:** Karlos Espinoza (karlos.espinoza@academicos.udg.mx)
* **Origen:** peticion del coordinador de carrera, para preparar al grupo que llevara
  IE043 Inteligencia Artificial en el siguiente ciclo

El nombre corto es el que se usa en el cartel y en el sitio. El nombre con subtitulo es
el que va en el oficio, en el programa y en la constancia.

---

## 2. Por que existe el taller

El grupo que entra a IE043 llega cada ciclo con los mismos tres problemas, y los tres se
pagan en las primeras semanas del curso, no en el taller:

1. **El entorno no esta instalado.** Python sin PATH, el driver CH340 ausente, pip sin
   bibliotecas. El internet de la universidad es malo, asi que resolverlo en clase
   consume sesiones completas.
2. **El hardware llega tarde.** En IE043 el alumno elige su dominio el lunes de la
   semana 1 y necesita su sensor el miercoles de la semana 2. Ese margen es apretado y
   cada ciclo alguien se queda fuera.
3. **El vocabulario es nuevo.** "Dataset", "feature", "entrenar" y "modelo" aparecen las
   cuatro juntas en la semana 3 y nadie las ha usado nunca con las manos.

El taller ataca los tres. No es un curso de introduccion a la inteligencia artificial: es
la puesta a punto del grupo antes de que empiece el curso de verdad.

---

## 3. Objetivo real

El objetivo declarado (el del programa) es que el participante recorra el flujo completo
de un sistema de clasificacion basado en aprendizaje automatico.

El objetivo real, el que manda cuando hay que recortar algo, es que el martes 29 de
septiembre de 2026 a las 13:00 los 15 participantes tengan:

1. El entorno instalado y **probado** en su propia maquina.
2. Su kit de hardware comprado y funcionando.
3. Una cuenta de GitHub viva, con un repositorio suyo y al menos un push hecho.
4. El flujo completo recorrido una vez, de punta a punta, con sus manos.

**No es que aprendan aprendizaje automatico.** Siete horas no alcanzan para eso y
pretenderlo es lo que romperia el taller. Es que en febrero las palabras ya no sean
nuevas y el primer dia de clase no se vaya en instalar.

---

## 4. Restricciones duras

| Restriccion | Consecuencia de diseno |
|---|---|
| **7 horas, repartidas 3 + 4** | El dia corto es el dia del hardware, que es el mas fragil. Todo lo que se pueda mover al dia 2, se mueve |
| **15 alumnos, un instructor** | Es manejable. Permite verificacion individual previa y rescate uno a uno |
| **Internet malo o nulo** | Nada del taller puede depender de descargar algo. Todo va en USB |
| **Nivel del grupo** | Calibracion heredada de IE043: 30 min de contenido toman cerca de una hora real |
| **El laboratorio no presta material** | El kit es requisito de inscripcion, y tiene que estar por escrito en el programa |
| **10 dias de preparacion** (desde el 2026-09-18) | La guia previa es la ruta critica. Sale antes que cualquier otra cosa |

---

## 5. Las cinco reglas de diseno

Estas cinco reglas son lo que hace que el flujo completo quepa en 7 horas. Si se rompe
una, el taller no cierra.

1. **Ninguna instalacion dentro del taller.** Se instala antes, con la guia previa, y se
   verifica con evidencia antes del viernes 25 de septiembre de 2026. Los primeros 20
   minutos del lunes son verificacion express, no rescate masivo.
2. **Todo el codigo va escrito y entregado.** El participante ejecuta, observa y modifica
   un parametro. No escribe desde cero. Este es el cambio de modo que distingue al taller
   de IE043, donde el alumno si escribe y se equivoca (por eso el curso dura 17 semanas).
3. **Un solo camino.** Mismo sensor, mismas tres piezas, mismo codigo para los 15. En
   IE043 la diversidad de dominios es lo que hace rico al curso; aqui seria lo que lo
   mata.
4. **Cero teoria.** Los conceptos se nombran al pasar, en una frase, en el momento en que
   ocurren en la pantalla. No hay diapositivas de teoria.
5. **Checkpoints de respaldo.** El USB lleva `datos.csv`, `features.csv` y `modelo.pkl`
   ya hechos. Quien se atore en una etapa toma el respaldo y sigue. Sin esto, un
   participante atorado a las 10:00 del lunes ya no hace nada en todo el taller.

### Corolario: una sola terminal, el CMD

La regla 3 (un solo camino) aplicada al entorno. Son 15 maquinas Windows y un instructor:
cada variante de terminal multiplica las formas en que una misma instruccion puede fallar.

* **El CMD y nada mas.** No la terminal integrada de Visual Studio Code, no PowerShell, no
  Git Bash. El CMD esta en las 15 maquinas, se ve igual en todas y no depende de que VS Code
  haya arrancado bien.
* **Visual Studio Code es solo el editor.** Se abre con `code <archivo>` y se ejecuta con
  `python <archivo>` desde el CMD, con las dos ventanas a la vez. Nadie instala la extension
  de Python: es una descarga mas que puede fallar y no aporta nada al flujo del taller.
* **El CMD se abre desde la barra de direcciones del explorador** (escribir `cmd` y Enter),
  asi arranca parado en la carpeta de trabajo y se evita ensenar `cd`.

De aqui sale la forma de la guia previa: lo que de verdad se esta asegurando no es "instalar
Python", es que **`python`, `code` y `git` respondan desde el CMD**, y eso son tres casillas
de PATH en tres instaladores. Por eso la guia lleva figuras de esas tres pantallas y por eso
la comprobacion 1 pide tambien `code --version`.

---

## 6. El caso central

Un **clasificador de tres piezas**: el sensor lee, Python extrae caracteristicas, un
modelo decide de que tipo es y el LED RGB muestra la decision con un color.

Es la version minima del caso de IE043 (clasificador de piezas sobre banda
transportadora), a proposito, para que en febrero reconozcan el sistema.

### Sensores: LDR + TCRT5000

| Decision | Por que |
|---|---|
| **TCRT5000 como sensor principal** | Trae su propio emisor infrarrojo, asi que no le afecta la luz del aula. Es el sensor recomendado por defecto de IE043, asi que lo compran una sola vez y les sirve todo el semestre siguiente |
| **LDR como segundo sensor** | Barato y facil de entender. Comparar los dos sobre las mismas piezas ensena sola la leccion de la dependencia de la luz ambiente |
| **Se descarto el LM35** | Es termico, tarda segundos en responder y no sirve para "una pieza pasa frente al sensor". Era carga muerta para este objetivo |

### Piezas: cartulina blanca, cartulina negra, papel aluminio

Fijas e iguales para los 15. Cuestan casi nada, todos las consiguen y el aluminio tiene
un comportamiento reflectante raro que hace interesante la grafica. Mismo dataset
conceptual para todo el grupo, asi que el codigo es uno solo.

### Actuador: LED RGB

| Decision | Por que |
|---|---|
| **LED RGB** | Tres colores para tres clases. Cuesta poco, es inmediato, visual y no falla |
| **Se descarto el servo** | Con el Nano alimentado por USB da reinicios y jitter, y puede costar 20 minutos de depuracion en el peor momento del dia 2. Queda como extra si sobra tiempo |

### Modelo: arbol de decision

No es por ser el mejor clasificador: es por `export_text`. El arbol **imprime las reglas
que aprendio**, y eso permite decir en voz alta:

> Esto es exactamente el `if` que ustedes habrian escrito a mano, pero lo encontro solo a
> partir de los datos.

Esa frase es el bloque 2 de la semana 01 de IE043 ("de programar reglas a aprender de los
datos") demostrado en vivo. Es el mejor gancho posible hacia el curso y la unica idea
conceptual que el taller si se compromete a dejar instalada.

---

## 7. Reparto de las 7 horas

### Lunes 28 de septiembre de 2026, 3 h: del sensor a los datos

| Hora | Bloque | Termina con |
|---|---|---|
| 0:00 | Encuadre y verificacion express | Todos con el entorno respondiendo |
| 0:20 | Circuito LDR + TCRT5000, sketch, Monitor Serie | El numero moviendose con la mano |
| 1:10 | *descanso* | |
| 1:20 | `leer_sensor.py`: pyserial y grafica en vivo | La senal en pantalla desde Python |
| 2:10 | `adquirir.py` con las tres piezas | `datos.csv` en el disco |
| 3:00 | cierre | |

Git sale completo del dia 1. El lunes termina con el dataset y nada mas.

### Martes 29 de septiembre de 2026, 4 h: de los datos a la decision

| Hora | Bloque | Termina con |
|---|---|---|
| 0:00 | Arranque y recuperacion de quien no logro su `datos.csv` | Todos con dataset, propio o de respaldo |
| 0:15 | `features.py`: de 200 numeros a 4 | `features.csv` y la grafica donde se ven separadas |
| 1:00 | `entrenar.py`: arbol, accuracy, reglas impresas | `modelo.pkl` |
| 1:45 | *descanso* | |
| 2:00 | `control.py` + `control.ino`: bucle cerrado | La pieza prende su color |
| 3:00 | Git y push a GitHub | El repositorio publicado |
| 3:30 | La cuarta pieza que nunca vio, y cierre | El gancho hacia la Unidad 3 de IE043 |

El bloque de las 2:00 es el momento importante del taller y tiene que alcanzar si o si.
Lo sacrificable es el de las 3:30, y despues el de las 3:00 (git se va de tarea con la
guia escrita).

---

## 8. Las redes de seguridad

| Red | Que protege |
|---|---|
| **Guia previa con 4 comprobaciones y evidencia**, limite viernes 25 de septiembre de 2026 | Que el dia 1 no se vaya en instalar. Convierte "les mande la guia" en "se quien esta listo" |
| **El Blink en la verificacion previa** | Es la comprobacion de mayor valor de toda la guia: si llegan con un LED parpadeando, el driver CH340 ya esta resuelto |
| **USB con instaladores y bibliotecas** (`pip download`) | El internet malo. Con 15 maquinas, un `pip install` en vivo es una hora perdida |
| **Checkpoints `datos.csv`, `features.csv`, `modelo.pkl` en el USB** | Que un atorado en la etapa 2 no quede fuera de las etapas 3, 4 y 5 |
| **Git fuera del dia 1** | Que un problema de red no consuma el dia corto |
| **Ensayo completo con hardware real** el 26 o 27 de septiembre de 2026 | Todo lo demas |

---

## 9. Lo que queda fuera, y por que

| Tema | Por que no |
|---|---|
| FFT y dominio de la frecuencia | Semanas 6 de IE043. No cabe y no hace falta para cerrar el bucle |
| Normalizacion y limpieza | Semana 4 de IE043. Se evita eligiendo piezas que se separan sin ella |
| Redes neuronales | Semana 8 de IE043. El arbol ensena mas en menos tiempo |
| Aprendizaje no supervisado, PCA, autoencoders | Unidad 3 completa. Solo se deja plantado el gancho con la cuarta pieza |
| PLC y despliegue | Unidad 4. Requiere la maqueta del laboratorio |
| Metricas mas alla de accuracy | Unidad 4. Accuracy basta para que vean que el numero existe |
| Train/test explicado | Se hace en el codigo, se menciona en una frase, no se desarrolla |
| Dominio propio por participante | Choca con la regla 3 (un solo camino) |

---

## 10. Conexion con IE043

| Bloque del taller | Equivale a |
|---|---|
| Verificacion previa y encuadre | Semana 01, bloque 1 |
| Sketch y Monitor Serie | Semana 02, bloque 1 |
| `leer_sensor.py` | Semana 02, bloque 2 |
| `adquirir.py` y `datos.csv` | Semana 03 |
| `features.py` | Semana 05 |
| `entrenar.py` y el arbol | Semana 07 |
| `control.py` y el bucle cerrado | Semana 08, bloque 2 |
| La cuarta pieza | Gancho hacia la Unidad 3 (semanas 10 a 13) |

### El hueco de cuatro meses

El taller es en septiembre de 2026 y el curso empieza en enero o febrero de 2027. Lo que
sobrevive a ese hueco es lo duradero: **el kit comprado y el entorno instalado**. El
codigo en los dedos se olvida.

Dos consecuencias para el material:

1. El sitio se queda publicado, para que puedan rehacerlo solos en vacaciones.
2. El cierre del martes les dice explicitamente que semanas del curso acaban de recorrer
   y donde vive la pagina.

---

## 11. Acreditacion

Atada a algo verificable, no a un examen:

* Asistencia a las 7 horas.
* Repositorio en GitHub con el bucle cerrado funcionando.

Eso ademas deja al instructor una lista de quien llego preparado a febrero.

---

## 12. Riesgos y mitigacion

| Riesgo | Probabilidad | Mitigacion |
|---|---|---|
| Llegan sin instalar | Alta si la guia sale tarde | Guia el 2026-09-21, evidencia el 2026-09-25, rescate individual por correo |
| Llegan sin kit | Media | Kit como requisito de inscripcion, por escrito en el programa, respaldado por el coordinador |
| Driver CH340 sin instalar | Alta | El Blink es parte de la verificacion previa obligatoria |
| Puerto COM ocupado por el Monitor Serie | Muy alta | Documentado en la guia y anunciado en voz alta antes de correr `leer_sensor.py` |
| Se atoran y pierden una etapa | Media | Checkpoints de respaldo en el USB |
| El internet no sirve el martes | Media | Git queda de tarea con la guia escrita; el bucle cerrado ya ocurrio |
| El aula no tiene corriente suficiente | Media | Requerimientos del aula por escrito en el programa: 15 laptops mas 15 Arduinos |
| Un participante llega sin computadora | Baja | Trabaja en pareja. No se detiene el grupo |
