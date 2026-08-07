---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 1 - Encuadre y configuración del entorno

Esta primera semana tiene dos metas. La primera es que entiendas **qué es el aprendizaje de máquina y por qué cambia la forma en que se construye un sistema de control**. La segunda es que dejes **listo tu entorno de trabajo** y creado el repositorio donde vivirá tu proyecto durante todo el semestre.

Todo el curso gira alrededor de un solo sistema que vas a construir tú mismo: un **clasificador de piezas sobre banda transportadora**. Imagina una línea de producción donde las piezas van pasando y hay que separarlas: las buenas siguen de largo, las que son de otro material se desvían, las defectuosas se sacan. Ese tipo de sistema es justo el que iremos levantando capa por capa. Y cada concepto de inteligencia artificial va a aparecer de forma natural cuando tu clasificador lo necesite.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Programar reglas contra aprender de los datos](#reglas-contra-datos)
    - [El bucle de control inteligente](#bucle-de-control)
    - [Del prototipo al hardware industrial](#prototipo-y-produccion)
    - [Git y GitHub: la memoria de tu proyecto](#git-y-github)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prepara tu entorno](#prepara-tu-entorno)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

Lee esta sección con calma antes de la sesión. Está escrita para que la entiendas por tu cuenta. En clase la usaremos como punto de partida para darle forma a tu proyecto.

### Programar reglas contra aprender de los datos {#reglas-contra-datos}

Hasta ahora, cuando querías que un Arduino tomara una decisión, escribías la regla tú mismo:

```cpp
if (distancia < 10) {
  activarPiston();
}
```

Ese enfoque funciona muy bien mientras la regla sea sencilla y tú la conozcas de antemano. El problema aparece cuando la decisión depende de **varias señales a la vez** y el patrón no es evidente. Piensa en distinguir una pieza de madera de una de plástico: no hay un solo umbral que las separe. La reflectancia se parece, el tamaño se traslapa, y lo que realmente las diferencia es una **combinación** de varias lecturas que tú no sabrías escribir a mano.

El **aprendizaje de máquina (Machine Learning, ML)** invierte el planteamiento. En lugar de que tú escribas la regla, le das al programa **ejemplos ya resueltos** y él encuentra la regla solo:

```
Programacion tradicional:   datos + reglas    ->  resultados
Aprendizaje de maquina:     datos + resultados ->  reglas
```

En la programación tradicional tú aportas la regla. En ML tú aportas los **ejemplos etiquetados** ("esta lectura corresponde a una pieza de madera", "esta otra a una de metal") y el algoritmo produce un **modelo**: una función que, ante una lectura nueva que nunca vio, predice a qué clase pertenece.

Eso es lo que vas a construir. No vas a escribir el `if` que separa tus piezas: vas a **recolectar ejemplos de cada tipo de pieza y dejar que el modelo encuentre la frontera**.

### El bucle de control inteligente {#bucle-de-control}

Aquí está la idea que sostiene todo el curso. Un modelo que solo imprime predicciones en la pantalla es un ejercicio de laboratorio. Lo que hace a este curso de mecatrónica y no de ciencia de datos es que **el modelo mueve algo**.

La arquitectura completa es esta:

```
   +----------+      +--------+      +----------+
   | SENSOR   | ---> | MODELO | ---> | ACTUADOR |
   +----------+      +--------+      +----------+
     mide una         decide          actua sobre
     señal fisica     que es          el proceso

        ^                                  |
        |                                  v
        +------ el proceso fisico ---------+
                  (la banda)
```

Se llama **bucle** porque se cierra: el actuador modifica el proceso físico, el sensor vuelve a medir ese proceso modificado, y el ciclo se repite indefinidamente. Es el mismo esquema de un control clásico que ya conoces, con una diferencia importante: **el bloque de decisión ya no es una ecuación que tú programaste, sino un modelo entrenado con datos**.

Aplicado a nuestro caso:

1. La pieza avanza sobre la banda y pasa frente a los sensores.
2. Los sensores generan una señal (una serie de valores en el tiempo).
3. Python recibe esa señal, calcula sus características y se la pasa al modelo.
4. El modelo responde: "esto es una pieza tipo A".
5. Python envía la orden al actuador: el pistón empuja, o la banda sigue.

Las cuatro unidades del curso son, literalmente, las cuatro capas de ese bucle. Mira cómo encaja:

| Unidad | Lo que le agregas al sistema | Cuándo lo construyes |
|---|---|---|
| U1 Introducción | El sistema existe: lees un sensor y ves su señal en Python. | Semanas 1 y 2 |
| U2 Supervisado | Etiquetas las piezas, extraes características y entrenas el clasificador. El Arduino actúa según su decisión. | Semanas 3 a 8 |
| U3 No supervisado | Buscas patrones sin etiquetas y detectas piezas anómalas que nadie te enseñó. | Semanas 10 a 13 |
| U4 Evaluación y despliegue | Validas el modelo y lo pones a controlar la maqueta real a través del PLC. | Semanas 15 a 17 |

Al final del semestre tu sistema será un clasificador funcional de extremo a extremo: **sensores -> Python -> modelo -> PLC -> actuadores**.

### Del prototipo al hardware industrial {#prototipo-y-produccion}

Vamos a trabajar en dos escenarios, y conviene que entiendas desde hoy por qué son dos y no uno.

El **prototipo** lo armas con un **Arduino Nano** y sensores de bajo costo sobre protoboard. Es donde vas a equivocarte barato: recolectar datos, probar sensores, entrenar y volver a entrenar. Aquí pasas la mayor parte del semestre.

La **producción** es la maqueta del laboratorio: bandas transportadoras reales, pistones, sensores capacitivos e inductivos, todo gobernado por un **PLC Siemens S7-1214C**. Ahí el modelo ya no le habla al Arduino sino al PLC, y el PLC mueve la banda y el pistón de verdad.

Para tu semestre esto quiere decir algo muy concreto: **la mayor parte del curso vas a trabajar sin banda**. Montas tu sensor en el protoboard y pasas la pieza a mano frente a él, sobre una mesa. Al modelo le da igual qué mueve la pieza; lo que necesita es la señal que se genera cuando pasa.

La banda de la maqueta llega después. Cuando el curso lo exija, en la Unidad 4, vamos al laboratorio, les explico cómo se usa la maqueta y **cada quien va a capturar ahí sus datos buenos**, los definitivos, sobre la banda real. En clase practicamos el concepto; los datos finales de tu sistema salen de la maqueta.

Esta separación no es un capricho didáctico: **es exactamente como se trabaja en la industria**. Nadie entrena un modelo directamente sobre la línea de producción en marcha. Se prototipa aparte, se valida, y solo entonces se despliega. Lo importante es que **el modelo es el mismo**: lo que cambia es a quién le manda la orden al final. Por eso a lo largo del curso vamos a cuidar que tu código separe bien esas dos cosas.

### Git y GitHub: la memoria de tu proyecto {#git-y-github}

Falta una pieza del entorno, y es tan importante como el Arduino: el control de versiones.

**Git** es un programa que guarda "fotos" de tu proyecto a lo largo del tiempo. Cada foto se llama **commit**, y lleva fecha, tu nombre y una descripción de lo que cambiaste. Si algo se rompe, vuelves a una foto anterior. **GitHub** es el sitio en la nube donde publicas ese historial para que quede respaldado y yo pueda revisarlo.

En este curso Git no es un adorno: es **la columna vertebral de cómo entregas y cómo te evalúo**. Tu proyecto crece commit a commit, semana a semana. El historial es la prueba de que trabajaste de forma constante y no todo la última noche. Cuando llegue una revisión de avances, haces `push` antes del día acordado y yo reviso tu código con anticipación.

Y aquí entra un archivo que vas a cuidar toda la vida del proyecto: **`BITACORA.md`**. Es un documento, dentro de tu mismo repositorio, donde cada semana explicas **con tus propias palabras** qué concepto viste y cómo lo aplicaste en tu clasificador. No es un trámite: vale el 30% de cada revisión, y es donde demuestras que entendiste lo que programaste.

Un detalle que importa en ML y que no aplicaba en otros cursos: **tus datos también son parte del proyecto**. El CSV que recolectes en la semana 3 es tan importante como el código, porque sin él tu modelo no se puede volver a entrenar. Va al repositorio igual que todo lo demás.

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

La primera sesión es de encuadre y la hacemos **sin laptop**, para conocernos y construir entre todos el mapa de los sistemas que vamos a desarrollar. Dos dinámicas:

**1. Tu línea de clasificación.** Cada quien dice qué va a clasificar su sistema: piezas por material (madera, metal, plástico), por tamaño (chica, mediana, grande), por color, botellas llenas contra vacías, tornillos por longitud, lo que quieras. Lo anotamos en el pizarrón. La regla es que **no se pueden repetir dominios**, porque cada dominio será un módulo distinto cuando armemos los equipos del proyecto integrador. Al final el pizarrón ya es el mapa de módulos del grupo.

**2. El clasificador humano.** En equipos, les paso tres piezas físicas distintas. Sin usar instrumentos, describan **qué señales medibles** permitirían distinguirlas: ¿pesa más?, ¿refleja más luz?, ¿es magnética?, ¿es más alta? Después viene la pregunta difícil: si solo pudieran usar **un** sensor, ¿cuál elegirían y qué par de piezas seguirían confundiéndose? Esa confusión que descubran hoy a mano es exactamente el problema que en la semana 7 va a resolver el modelo, y la razón por la que necesitamos varias señales y no una.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

Esta semana siembras el proyecto. Lo que crees ahora es el terreno sobre el que vas a construir las siguientes 16 semanas.

### Prepara tu entorno {#prepara-tu-entorno}

Deja instalado y funcionando lo siguiente (en tu computadora, con calma, fuera de clase):

1. **Python y Visual Studio Code.** Si ya los traes de cursos anteriores, solo verifica que respondan:

   ```bash
   python --version
   code --version
   ```

2. **Las bibliotecas del curso.** Desde la terminal:

   ```bash
   pip install numpy pandas matplotlib scikit-learn pyserial joblib
   ```

   Comprueba que la instalación quedó bien:

   ```bash
   python -c "import numpy, pandas, matplotlib, sklearn, serial, joblib; print('entorno listo')"
   ```

3. **Arduino IDE**, y conecta tu Arduino Nano para confirmar que la computadora lo reconoce. Anota el puerto que le asigna (`COM3` en Windows, `/dev/ttyUSB0` en Linux): lo vas a necesitar la próxima semana.

4. **Git**, configurado con tu identidad:

   ```bash
   git config --global user.name "Tu Nombre"
   git config --global user.email "tucorreo@ejemplo.com"
   ```

### Prácticas {#practicas}

1. **Elige tu dominio de clasificación** (recuerda: nadie más del grupo puede tener el mismo) y regístralo conmigo. Necesitas **tres tipos de pieza** que se puedan distinguir con los sensores disponibles:

   | Dominio | Los tres tipos | Señales que podrían distinguirlos |
   |---|---|---|
   | Material | Madera, metal, plástico | Magnetismo (A3144), reflectancia (LDR) |
   | Tamaño | Chica, mediana, grande | Distancia (HC-SR04 o GP2Y0A21YK0F) |
   | Color | Clara, media, oscura | Reflectancia (LDR) |
   | Contenido | Llena, media, vacía | Peso o distancia al nivel |
   | Estado | Buena, marcada, deforme | Combinación de reflectancia y distancia |

   Aún no tienes que estar seguro de qué sensores vas a usar. Eso lo terminas de decidir en la semana 3, cuando diseñemos el experimento de recolección.

2. **Crea tu repositorio** en GitHub (por ejemplo `clasificador-piezas-ia`, público) y clónalo:

   ```bash
   git clone https://github.com/TU_USUARIO/clasificador-piezas-ia.git
   cd clasificador-piezas-ia
   ```

3. **Escribe tu `README.md`** con tus datos y tu dominio:

   ```markdown
   # Clasificador de piezas - Material

   Proyecto del curso Inteligencia Artificial.

   - Alumno: Ana Pérez
   - Código: 2162628
   - Dominio: clasificación por material (madera, metal, plástico)

   ## Descripción

   Sistema que lee señales de sensores mientras una pieza pasa frente a ellos,
   clasifica de qué tipo es con un modelo de aprendizaje de máquina y acciona
   un actuador para enrutarla. Crece semana a semana con los temas del curso:
   adquisición, características, clasificación, anomalías y despliegue en PLC.
   ```

4. **Escribe la primera entrada de tu `BITACORA.md`**, explicando con tus palabras lo que entendiste esta semana:

   ```markdown
   # Bitácora del proyecto

   ## Semana 1 - Encuadre y configuración del entorno

   Preparé mi entorno de Python con las bibliotecas del curso y creé este
   repositorio. Elegí clasificar por material porque quiero ver si el sensor
   de efecto Hall alcanza para separar el metal del resto.

   Entendí que en programación tradicional yo escribo la regla, y que en
   aprendizaje de máquina le doy ejemplos etiquetados al algoritmo para que
   él encuentre la regla. También entendí que mi sistema no termina en la
   predicción: el modelo tiene que cerrar el bucle y mover un actuador.
   ```

5. **Guarda y sube tu avance**, y entrega la URL del repositorio en Google Classroom (esto se hace una sola vez en todo el semestre):

   ```bash
   git add .
   git commit -m "inicio: configuracion del entorno y eleccion de dominio"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Forma tu equipo** de 2 o 3 integrantes.
2. **Verifiquen que cada integrante tenga un dominio diferente**, porque cada dominio será un módulo del clasificador multi-dominio que construirán juntos. Por ejemplo: uno clasifica por material, otro por tamaño, otro detecta piezas anómalas.
3. **Registren el equipo y los dominios** conmigo durante esta semana.

Todavía no hay código del integrador: por ahora basta con que el equipo quede formado y los dominios reservados, porque a partir de la Unidad 2 cada módulo empezará a integrarse en un controlador central que desarrollarán en conjunto.
