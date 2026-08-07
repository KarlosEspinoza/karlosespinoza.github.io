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
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: tu entorno y tu repositorio](#bloque-1)
    - [Bloque 2: de programar reglas a aprender de los datos](#bloque-2)
    - [Bloque extra: la hoja de datos de tu sensor](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

Esta guía se trabaja **durante la sesión del lunes**, no en tu casa la noche anterior ni la madrugada del miércoles. Está partida en **dos bloques obligatorios y uno extra**, y cada bloque termina con algo concreto que subes a tu repositorio. Así tu trabajo queda registrado conforme lo vas haciendo, sin que tengas que entregar nada aparte.

Voy a estar disponible durante toda la sesión para resolver dudas. Aprovéchala: es el único rato de la semana en que puedes preguntar **mientras** lo estás haciendo, en vez de quedarte atorado.

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Instalas el entorno y creas tu repositorio | El repositorio con su estructura y tu `README.md` |
| 2 | Entiendes qué es aprender de los datos y eliges tu dominio | Tu entrada de `BITACORA.md` |
| Extra | Revisas la hoja de datos de tu sensor candidato | Una tabla con sus características |

El **bloque extra es opcional**. Es para quien terminó los dos primeros y quiere que su proyecto llegue más lejos. No hace falta para la clase del miércoles, y no pasa nada si no lo haces.

Una última cosa, y es la más importante de la semana: **si te atoras, escríbelo**. Un commit que dice "no me salió, me quedé atorado al configurar Git" es trabajo hecho y me sirve muchísimo para saber dónde apoyarte el miércoles. Lo que no sirve es no dejar rastro.

---

### Bloque 1: tu entorno y tu repositorio {#bloque-1}

Antes de cualquier concepto, necesitas la herramienta. Este bloque es puro trabajo de preparación, pero es el que sostiene todo el semestre.

#### Git y GitHub: la memoria de tu proyecto

Falta una pieza del entorno, y es tan importante como el Arduino: el control de versiones.

**Git** es un programa que guarda "fotos" de tu proyecto a lo largo del tiempo. Cada foto se llama **commit**, y lleva fecha, hora, tu nombre y una descripción de lo que cambiaste. Si algo se rompe, vuelves a una foto anterior. **GitHub** es el sitio en la nube donde publicas ese historial para que quede respaldado y yo pueda revisarlo.

En este curso Git no es un adorno: es **la columna vertebral de cómo entregas y cómo te evalúo**. Tu proyecto crece commit a commit, semana a semana. El historial es la prueba de que trabajaste de forma constante y no todo la última noche. Cuando llegue una revisión de avances, haces `push` antes del día acordado y yo reviso tu código con anticipación.

Y aquí entra un archivo que vas a cuidar toda la vida del proyecto: **`BITACORA.md`**. Es un documento, dentro de tu mismo repositorio, donde cada semana explicas **con tus propias palabras** qué concepto viste y cómo lo aplicaste en tu clasificador. No es un trámite: vale el 30% de cada revisión, y es donde demuestras que entendiste lo que programaste.

Un detalle que importa en aprendizaje de máquina y que no aplicaba en otros cursos: **tus datos también son parte del proyecto**. El CSV que recolectes en la semana 3 es tan importante como el código, porque sin él tu modelo no se puede volver a entrenar. Va al repositorio igual que todo lo demás.

#### Instala lo que vas a necesitar

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

3. **Arduino IDE.** Si tienes tu Arduino Nano a la mano, conéctalo y confirma que la computadora lo reconoce, y anota el puerto que le asigna (`COM3` en Windows, `/dev/ttyUSB0` en Linux). Si no lo tienes contigo, deja el IDE instalado y el puerto lo anotas el miércoles.

4. **Git**, configurado con tu identidad:

   ```bash
   git config --global user.name "Tu Nombre"
   git config --global user.email "tucorreo@ejemplo.com"
   ```

#### Crea tu repositorio

Crea el repositorio en GitHub con el nombre `clasificador-piezas-ia` y **visibilidad privada**. Privado quiere decir que solo lo ves tú y quien tú autorices: tu proyecto es tuyo y el de tu compañero es suyo.

```bash
git clone https://github.com/TU_USUARIO/clasificador-piezas-ia.git
cd clasificador-piezas-ia
```

Como está privado, tienes que darme acceso o no voy a poder revisarte. En tu repositorio, ve a **Settings -> Collaborators -> Add people**, escribe mi usuario `[USUARIO_GITHUB_DEL_PROFESOR]` y manda la invitación. **Sin esa invitación tu trabajo no existe para mí**, así que hazlo hoy y no la semana de la revisión.

Al terminar el semestre puedes cambiarlo a público si quieres: es un proyecto completo y sirve para enseñarlo cuando busques trabajo.

#### Cómo se organiza tu repositorio

Esta estructura es la misma para todo el grupo y para todo el semestre. No la cambies: es la que me permite revisar tu proyecto rápido y sin andar buscando archivos.

```
clasificador-piezas-ia/
  README.md      <- quien eres y que clasifica tu sistema
  BITACORA.md    <- una seccion por semana, crece cada lunes y cada miercoles
  codigo/        <- todo el codigo: sensor.ino, leer_sensor.py, adquirir.py, ...
  datos/         <- los CSV que recolectes: datos.csv, features.csv, ...
  figuras/       <- las graficas que generes: senal.png, ...
```

Créala de una vez, aunque las carpetas estén vacías:

```bash
mkdir codigo datos figuras
```

`BITACORA.md` lleva **una sección por semana, y cada semana tiene dos partes fijas**: lo que trabajaste el lunes en la guía y lo que le agregaste al proyecto. Siempre igual, todas las semanas:

```markdown
# Bitácora del proyecto

## Semana 1 - Encuadre y configuración del entorno

### Antes de la clase

(aquí van los entregables de los bloques del lunes)

### Avance del proyecto

(aquí va lo que le agregaste a tu sistema)
```

#### Cómo nombrar tus commits

El mensaje del commit me dice qué estabas haciendo sin que yo tenga que abrir nada. Usa siempre este formato:

| Cuándo haces commit | Mensaje |
|---|---|
| Al terminar el bloque 1 del lunes | `s01 bloque 1: entorno y repositorio listos` |
| Al terminar el bloque 2 del lunes | `s01 bloque 2: eleccion de dominio` |
| Si hiciste el bloque extra | `s01 extra: hoja de datos del sensor` |
| Al terminar el avance de tu proyecto | `s01 proyecto: ...` |

El `s01` es el número de semana, y cambia cada semana (`s02`, `s03`, y así). **Haz un commit al terminar cada bloque, no uno solo al final.** Es menos trabajo de lo que parece, y deja ver tu avance a lo largo de la sesión.

#### Escribe tu `README.md`

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

El dominio lo terminas de decidir en el bloque 2, así que por ahora déjalo en blanco o pon el que traigas en mente.

**Lo que entregas de este bloque**

- El repositorio creado en GitHub, privado y con la invitación de colaborador ya enviada.
- Las carpetas `codigo/`, `datos/` y `figuras/`.
- `README.md` con tu nombre y tu código.
- `BITACORA.md` con la estructura de la semana 1.

```bash
git add .
git commit -m "s01 bloque 1: entorno y repositorio listos"
git push
```

---

### Bloque 2: de programar reglas a aprender de los datos {#bloque-2}

Ya tienes dónde guardar. Ahora el concepto que le da nombre al curso.

#### Programar reglas contra aprender de los datos

Hasta ahora, cuando querías que un Arduino tomara una decisión, escribías la regla tú mismo:

```cpp
if (distancia < 10) {
  activarPiston();
}
```

Ese enfoque funciona muy bien mientras la regla sea sencilla y tú la conozcas de antemano. El problema aparece cuando la decisión depende de **varias señales a la vez** y el patrón no es evidente. Piensa en distinguir una pieza de madera de una de plástico: no hay un solo umbral que las separe. La reflectancia se parece, el tamaño se traslapa, y lo que realmente las diferencia es una **combinación** de varias lecturas que tú no sabrías escribir a mano.

El **aprendizaje de máquina (Machine Learning, ML)** invierte el planteamiento. En lugar de que tú escribas la regla, le das al programa **ejemplos ya resueltos** y él encuentra la regla solo:

```
Programacion tradicional:   datos + reglas     ->  resultados
Aprendizaje de maquina:     datos + resultados ->  reglas
```

En la programación tradicional tú aportas la regla. En ML tú aportas los **ejemplos etiquetados** ("esta lectura corresponde a una pieza de madera", "esta otra a una de metal") y el algoritmo produce un **modelo**: una función que, ante una lectura nueva que nunca vio, predice a qué clase pertenece.

Eso es lo que vas a construir. No vas a escribir el `if` que separa tus piezas: vas a **recolectar ejemplos de cada tipo de pieza y dejar que el modelo encuentre la frontera**.

#### El bucle de control inteligente

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

#### Del prototipo al hardware industrial

Vamos a trabajar en dos escenarios, y conviene que entiendas desde hoy por qué son dos y no uno.

El **prototipo** lo armas con un **Arduino Nano** y sensores de bajo costo sobre protoboard. Es donde vas a equivocarte barato: recolectar datos, probar sensores, entrenar y volver a entrenar. Aquí pasas la mayor parte del semestre.

La **producción** es la maqueta del laboratorio: bandas transportadoras reales, pistones, sensores capacitivos e inductivos, todo gobernado por un **PLC Siemens S7-1214C**. Ahí el modelo ya no le habla al Arduino sino al PLC, y el PLC mueve la banda y el pistón de verdad.

Para tu semestre esto quiere decir algo muy concreto: **la mayor parte del curso vas a trabajar sin banda**. Montas tu sensor en el protoboard y pasas la pieza a mano frente a él, sobre una mesa. Al modelo le da igual qué mueve la pieza; lo que necesita es la señal que se genera cuando pasa.

La banda de la maqueta llega después. Cuando el curso lo exija, en la Unidad 4, vamos al laboratorio, les explico cómo se usa la maqueta y **cada quien va a capturar ahí sus datos buenos**, los definitivos, sobre la banda real. En clase practicamos el concepto; los datos finales de tu sistema salen de la maqueta.

Esta separación no es un capricho didáctico: **es exactamente como se trabaja en la industria**. Nadie entrena un modelo directamente sobre la línea de producción en marcha. Se prototipa aparte, se valida, y solo entonces se despliega. Lo importante es que **el modelo es el mismo**: lo que cambia es a quién le manda la orden al final.

#### Elige tu dominio de clasificación

Nadie más del grupo puede tener el mismo dominio, porque cada dominio va a ser un módulo distinto cuando armemos los equipos del proyecto integrador. Necesitas **tres tipos de pieza** que se puedan distinguir con los sensores disponibles:

| Dominio | Los tres tipos | Señales que podrían distinguirlos |
|---|---|---|
| Material | Madera, metal, plástico | Magnetismo (A3144), reflectancia (LDR) |
| Tamaño | Chica, mediana, grande | Distancia (HC-SR04 o GP2Y0A21YK0F) |
| Color | Clara, media, oscura | Reflectancia (LDR) |
| Contenido | Llena, media, vacía | Peso o distancia al nivel |
| Estado | Buena, marcada, deforme | Combinación de reflectancia y distancia |

Aún no tienes que estar seguro de qué sensores vas a usar. Eso lo terminas de decidir en la semana 3, cuando diseñemos el experimento de recolección.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`, responde con tus palabras:

1. ¿Cuál es la diferencia entre programar la regla y aprender la regla? Un ejemplo tuyo, no el de la guía.
2. ¿Cuál es tu dominio y cuáles son tus tres tipos de pieza?
3. Describe el bucle de control de **tu** sistema: qué mide tu sensor, qué tiene que decidir el modelo y qué haría el actuador con cada uno de tus tres tipos.

Actualiza también el dominio en tu `README.md`.

```bash
git add .
git commit -m "s01 bloque 2: eleccion de dominio"
git push
```

---

### Bloque extra: la hoja de datos de tu sensor {#bloque-extra}

Opcional. Si ya terminaste los dos bloques anteriores, este te va a ahorrar tiempo la semana que viene.

Busca la hoja de datos (*datasheet*) del sensor que crees que vas a usar y llena esta tabla en tu bitácora:

| Dato | Tu sensor |
|---|---|
| Tipo de salida (analógica, digital, por pulso) | |
| Rango de medición | |
| Tiempo de respuesta | |
| Voltaje de alimentación | |

El **tiempo de respuesta** es el que más nos va a importar: en la semana 2 vamos a decidir cada cuánto tomar una lectura, y ningún sensor puede darte lecturas nuevas más rápido de lo que tarda en responder.

```bash
git add .
git commit -m "s01 extra: hoja de datos del sensor"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu dominio ya elegido y tu repositorio creado. La sesión es de encuadre y la hacemos **sin laptop**, para conocernos y construir entre todos el mapa de los sistemas que vamos a desarrollar. Dos dinámicas:

**1. Tu línea de clasificación.** Cada quien dice qué va a clasificar su sistema, el dominio que eligió el lunes. Lo anotamos en el pizarrón. La regla es que **no se pueden repetir dominios**: si dos coinciden, ahí mismo se resuelve. Al final el pizarrón ya es el mapa de módulos del grupo.

**2. El clasificador humano.** En equipos, les paso tres piezas físicas distintas. Sin usar instrumentos, describan **qué señales medibles** permitirían distinguirlas: ¿pesa más?, ¿refleja más luz?, ¿es magnética?, ¿es más alta? Después viene la pregunta difícil: si solo pudieran usar **un** sensor, ¿cuál elegirían y qué par de piezas seguirían confundiéndose? Esa confusión que descubran hoy a mano es exactamente el problema que en la semana 7 va a resolver el modelo, y la razón por la que necesitamos varias señales y no una.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

El repositorio ya lo creaste el lunes. Lo que queda es cerrarlo y dejarlo entregado.

1. **Entrega la URL de tu repositorio en Google Classroom.** Esto se hace **una sola vez en todo el semestre**: de ahí en adelante yo reviso directo en GitHub y tú solo haces `push`.

2. **Cierra tu entrada de la semana en `BITACORA.md`**, bajo `### Avance del proyecto`:

   ```markdown
   ### Avance del proyecto

   Preparé mi entorno de Python con las bibliotecas del curso y creé este
   repositorio. Elegí clasificar por material porque quiero ver si el sensor
   de efecto Hall alcanza para separar el metal del resto.

   En la dinámica del clasificador humano nos dimos cuenta de que la madera y
   el plástico se parecen mucho a simple vista, así que probablemente voy a
   necesitar más de un sensor.
   ```

3. **Sube tu avance:**

   ```bash
   git add .
   git commit -m "s01 proyecto: repositorio entregado y dominio registrado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

1. **Forma tu equipo** de 2 o 3 integrantes.
2. **Verifiquen que cada integrante tenga un dominio diferente**, porque cada dominio será un módulo del clasificador multi-dominio que construirán juntos. Por ejemplo: uno clasifica por material, otro por tamaño, otro detecta piezas anómalas.
3. **Registren el equipo y los dominios** conmigo durante esta semana.

Todavía no hay código del integrador: por ahora basta con que el equipo quede formado y los dominios reservados, porque a partir de la Unidad 2 cada módulo empezará a integrarse en un controlador central que desarrollarán en conjunto.
