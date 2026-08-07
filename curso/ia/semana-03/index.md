---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 3 - Recolección de datos etiquetados (U2)

La semana pasada lograste ver la señal de tu sensor. Viste la forma del evento y comparaste tus tres tipos de pieza. Esta semana conviertes esa señal en algo que un modelo pueda usar: un **dataset etiquetado**.

Aquí empieza la Unidad 2, y es la semana más importante del semestre. No exagero. En aprendizaje de máquina el modelo no puede ser mejor que los datos con los que lo entrenas, y esos datos los vas a recolectar tú, a mano, esta semana. Si el dataset sale mal, todo lo que hagamos de la semana 4 a la 17 va a estar construido sobre arena. Y lo peor es que un dataset malo no da error: da un modelo que parece funcionar y falla en cuanto lo pones en la banda.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: qué es un dataset etiquetado](#bloque-1)
    - [Bloque 2: el protocolo de recolección](#bloque-2)
    - [Bloque extra: detectar el evento solo](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes qué forma tiene un dataset y diseñas el tuyo | El diseño de tu tabla y tus tres etiquetas |
| 2 | Escribes tu protocolo de recolección y `adquirir.py` | `codigo/adquirir.py` y tu protocolo |
| Extra | Detectas el evento automáticamente con un umbral | `adquirir.py` con detección automática |

Todo se hace **sin el Arduino conectado**. El miércoles recolectas el dataset de verdad, y llegas con el código y el protocolo ya listos. Si te atoras, escríbelo en la bitácora y haz commit igual.

---

### Bloque 1: qué es un dataset etiquetado {#bloque-1}

#### Tres palabras que vas a usar todo el semestre

**Muestra.** Una lectura individual del sensor. Un número. Es lo que imprimía tu script la semana pasada.

**Ventana.** El tramo de señal que contiene un evento completo: desde antes de que la pieza aparezca hasta después de que se fue. Una ventana son muchas muestras seguidas. Ya la conociste la semana pasada, cuando graficaste la forma del evento.

**Etiqueta.** El nombre de la clase a la que pertenece esa ventana: `madera`, `metal`, `plastico`. La etiqueta la pones tú, a mano, sabiendo qué pieza pasaste. Por eso se llama **aprendizaje supervisado**: hay alguien (tú) que supervisa y le dice al algoritmo la respuesta correcta.

La unidad de tu dataset **no es la muestra, es la ventana**. Una muestra suelta no significa nada; lo que se clasifica es el evento completo. Si tu dataset tiene 30 ventanas por clase y cada ventana tiene 200 muestras, tienes 90 ventanas y 18000 muestras. El modelo verá 90 ejemplos, no 18000.

#### Qué forma tiene el archivo

Necesitamos guardar muchas ventanas en un solo archivo, y poder distinguir dónde termina una y empieza otra. La forma más simple es agregar dos columnas de control:

```
ventana,t,valor,etiqueta
0,0,512,madera
0,1,510,madera
0,2,498,madera
...
0,199,511,madera
1,0,513,metal
1,1,509,metal
...
```

- `ventana` es el número de la pasada. Todas las filas con el mismo número pertenecen al mismo evento.
- `t` es el número de muestra dentro de la ventana, de 0 en adelante. Es el tiempo, en unidades de muestra.
- `valor` es la lectura del sensor.
- `etiqueta` es la clase de esa pieza.

Este formato se llama **formato largo**, y tiene una ventaja que vas a agradecer: **las ventanas no tienen que medir todas lo mismo**. Si una pasada te dio 180 muestras y otra 220, las dos caben sin problema. Si guardaras una ventana por fila con 200 columnas, tendrías que forzar a que todas midieran igual.

Con `pandas` recuperar una ventana es directo:

```python
import pandas as pd
datos = pd.read_csv('datos/datos.csv')
v0 = datos[datos['ventana'] == 0]     # todas las muestras de la ventana 0
print(v0['etiqueta'].iloc[0])         # su etiqueta
```

Si en la semana 2 hiciste el bloque extra y mandas dos sensores, tu tabla lleva una columna por sensor: `ventana,t,valor1,valor2,etiqueta`. Todo lo demás es igual.

#### Dónde vive cada cosa

De aquí en adelante los scripts se corren **desde la raíz de tu repositorio**, no desde dentro de `codigo/`:

```bash
python codigo/adquirir.py
```

Así las rutas dentro del código son simples y siempre iguales: `datos/datos.csv`, `figuras/senal.png`. Si lo corres desde otra carpeta, no va a encontrar los archivos.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Las columnas exactas de tu `datos.csv`, con el nombre de cada una y qué guarda.
2. Tus tres etiquetas, escritas tal como van a aparecer en el archivo (una palabra, minúsculas, sin acentos).
3. Cinco filas de ejemplo de tu tabla, con valores plausibles para tu sensor.

```bash
git add .
git commit -m "s03 bloque 1: diseño del dataset"
git push
```

---

### Bloque 2: el protocolo de recolección {#bloque-2}

Ya sabes qué forma tiene el archivo. Falta lo más delicado: **cómo vas a generar esos datos sin arruinarlos**.

Un protocolo de recolección es la lista de decisiones que tomas antes de empezar a capturar, y que respetas sin cambiarlas a media captura. Son cuatro.

#### Cuántas ventanas por clase

El mínimo para este curso son **30 ventanas por clase**, o sea 90 pasadas en total si tienes tres tipos. Con menos, cualquier resultado que obtengas es ruido: bastan dos o tres pasadas raras para cambiar por completo lo que aprende el modelo.

Treinta por clase es poco para un sistema real, pero es lo que alcanzas a capturar en una sesión. Si puedes hacer 50, mejor.

#### Balance de clases

**El mismo número de ventanas para cada clase.** Si capturas 50 de madera, 30 de metal y 12 de plástico, el modelo aprende que lo más probable es que sea madera, y acierta bastante seguido sin haber aprendido nada. Ese modelo va a tener buena exactitud y va a ser inútil.

Un dataset desbalanceado se puede arreglar después, con técnicas que veremos en la semana 15, pero es mucho más barato no desbalancearlo desde el principio.

#### El orden de las pasadas

**No captures las 30 de madera seguidas, luego las 30 de metal.** Altérnalas: madera, metal, plástico, madera, metal, plástico, y así.

La razón no es obvia y es importante. Mientras capturas, el mundo cambia: la luz de la ventana se mueve, el sensor se calienta, la pila baja, tú te cansas. Si capturaste toda la madera al principio y todo el plástico al final, esas condiciones cambiantes quedaron **pegadas a la etiqueta**. El modelo podría estar aprendiendo a distinguir "principio de la sesión" de "final de la sesión" en vez de madera y plástico, y tú nunca te enterarías.

Alternando, ese cambio lento se reparte parejo entre las tres clases y deja de ser una pista falsa.

#### La velocidad de tu mano

Este es el punto que más proyectos arruina en este curso, así que léelo dos veces.

Como todavía no usamos la banda, tú mueves la pieza a mano. Y tu mano no es constante: **si sin darte cuenta pasas el metal más rápido que la madera, la duración del evento se vuelve una pista perfecta para distinguirlos**. Tu modelo va a llegar al 98% de exactitud, tú vas a estar feliz, y lo que aprendió fue tu mano, no la pieza.

Eso se llama **fuga de información**: una pista que está en tus datos, que separa perfectamente las clases, y que no tiene nada que ver con lo que quieres medir. Es de los errores más caros porque **no se ve en los resultados**, se ve solo si lo piensas antes.

Cómo se controla:

- **Marca en la mesa** el punto de inicio y el de fin del recorrido, con cinta. Siempre el mismo tramo.
- **Cuenta el tiempo.** Un recorrido por segundo, marcando el ritmo con el metrónomo del celular si hace falta.
- **Fija la distancia** entre la pieza y el sensor. Una guía de cartón pegada a la mesa resuelve esto.
- **Alterna las clases**, como ya dijimos: si el ritmo se te va acelerando, se acelera parejo para las tres.

Y algo que vale más que todo lo anterior: **anótalo en tu bitácora**. Escribir "pasé cada pieza en aproximadamente un segundo sobre un tramo marcado de 20 cm, a 5 cm del sensor" te obliga a haberlo hecho.

#### `adquirir.py`

Te dejo lista la parte nueva, que es la captura de varias ventanas y el guardado en CSV. Lo que ya sabes hacer, lo completas tú.

```python
# adquirir.py - captura ventanas etiquetadas y las guarda en datos/datos.csv
import serial
import time
import csv

PUERTO = '/dev/ttyUSB0'   # Windows: 'COM3'
BAUDIOS = 115200
N_MUESTRAS = 200          # largo de cada ventana
ARCHIVO = 'datos/datos.csv'

etiqueta = input("Etiqueta de esta pieza: ")
n_ventanas = int(input("Cuantas ventanas vas a capturar: "))

ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
time.sleep(2)             # el Arduino se reinicia al abrir el puerto

# 'a' = append: no borra lo que ya habias capturado antes
archivo = open(ARCHIVO, 'a', newline='')
escritor = csv.writer(archivo)

# TODO: si el archivo esta vacio, escribe primero la fila de encabezados
#       ventana,t,valor,etiqueta

# TODO: averigua en que numero de ventana te quedaste la vez pasada
#       pista: lee el CSV con pandas y toma el maximo de la columna 'ventana'
ventana = 0

for i in range(n_ventanas):
    input(f"\nVentana {ventana} ({etiqueta}). Enter y pasa la pieza...")
    ser.reset_input_buffer()          # tira lo que se acumulo mientras esperabas

    t = 0
    while t < N_MUESTRAS:
        linea = ser.readline().decode('utf-8').strip()
        try:
            valor = float(linea)
        except ValueError:
            continue
        escritor.writerow([ventana, t, valor, etiqueta])
        t += 1

    print(f"  {N_MUESTRAS} muestras guardadas")
    ventana += 1

archivo.close()
ser.close()
print(f"\nListo. Datos en {ARCHIVO}")
```

Dos detalles del código que conviene que entiendas, porque los vas a necesitar:

**`ser.reset_input_buffer()`** tira lo que llegó mientras estabas esperando a que presionaras Enter. Sin eso, tu ventana empezaría con muestras viejas de hace diez segundos y el evento saldría corrido.

**El modo `'a'`** (append) hace que cada ejecución agregue al final en vez de borrar. Así puedes capturar una clase, cerrar el programa, y volver a correrlo para la siguiente sin perder lo anterior. Por eso también necesitas saber en qué número de ventana te quedaste: ese es el `TODO`.

**Lo que entregas de este bloque**

- `codigo/adquirir.py` con los dos `TODO` resueltos.
- En `BITACORA.md`, tu protocolo de recolección escrito:
  1. Cuántas ventanas por clase vas a capturar.
  2. En qué orden.
  3. Cómo vas a mantener pareja la velocidad de la mano, en concreto: qué vas a marcar, medir o fijar.
  4. A qué distancia del sensor va a pasar la pieza.

```bash
git add .
git commit -m "s03 bloque 2: protocolo de recoleccion y adquirir.py"
git push
```

---

### Bloque extra: detectar el evento solo {#bloque-extra}

Opcional. El `adquirir.py` de arriba captura 200 muestras a partir de que presionas Enter, así que tú tienes que sincronizarte con el programa. Funciona, pero es incómodo y mete variabilidad.

Lo que hacen los sistemas reales es al revés: el programa **espera y se da cuenta solo** de cuándo pasó algo. La idea es simple: si la lectura se aleja del valor de reposo más de cierto umbral, empezó el evento.

```python
UMBRAL = 30      # cuanto tiene que alejarse del reposo para contar como evento

reposo = 512     # TODO: mide tu valor de reposo promediando 100 muestras sin pieza

# esperar a que empiece el evento
while True:
    valor = leer_valor(ser)
    if abs(valor - reposo) > UMBRAL:
        break

# a partir de aqui, capturar la ventana completa
```

Dos cosas que se ponen interesantes cuando lo intentas:

**El evento empieza antes de que lo detectes.** Cuando el umbral se cruza, la pieza ya lleva un rato entrando. Si guardas solo a partir de ahí, pierdes el arranque de la forma. La solución que se usa en la industria es un **buffer circular**: vas guardando siempre las últimas 20 muestras, y cuando se dispara el umbral las incluyes al principio de la ventana. En Python eso es `collections.deque(maxlen=20)`.

**Elegir el umbral es una decisión, no un número mágico.** Muy bajo, y el ruido te dispara eventos falsos. Muy alto, y las piezas que apenas se notan no se detectan nunca.

```bash
git add .
git commit -m "s03 extra: deteccion automatica del evento"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con `adquirir.py` escrito y tu protocolo decidido. Traes tu Arduino, tu sensor, tus tres tipos de pieza y con qué marcar la mesa. Hoy sales con tu dataset.

**1. Montaje fijo.** Antes de capturar nada, dejas el sensor y la guía de la pieza montados de forma que no se muevan en toda la sesión. Si a media captura mueves el sensor dos centímetros, los datos de antes y los de después son de dos sistemas distintos. Cinta, plastilina, lo que sea, pero que no se mueva.

**2. Captura de prueba.** Capturas tres ventanas de una sola clase y las graficas de inmediato. Antes de invertir una hora en capturar 90 pasadas, hay que verificar que el evento cae completo dentro de la ventana y que no se sale de rango. Es mucho más barato descubrir aquí que tu `N_MUESTRAS` es corto.

**3. La captura en serio.** Las 90 pasadas, alternando clases, con el ritmo marcado. Es repetitivo y es la parte del semestre que más se parece al trabajo real: recolectar datos limpios es lento y nadie lo puede hacer por ti.

**4. Revisión rápida.** Al final, cuentas cuántas ventanas quedaron por clase y graficas una de cada una. Si algo se ve raro, se recaptura hoy, no la semana que viene.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Captura tu dataset** siguiendo tu protocolo y guárdalo en `datos/datos.csv`. Mínimo 30 ventanas por clase, balanceado.

2. **Verifica el dataset** antes de darlo por bueno. Escribe unas líneas sueltas de Python (o hazlo en la terminal) que respondan:

   ```python
   import pandas as pd
   datos = pd.read_csv('datos/datos.csv')

   # cuantas ventanas hay de cada clase
   print(datos.groupby('etiqueta')['ventana'].nunique())

   # TODO: verifica que ninguna ventana tenga menos muestras de las esperadas
   # TODO: verifica que no haya valores imposibles (fuera del rango de tu sensor)
   ```

   Si alguna clase quedó corta, se captura lo que falta. Un dataset desbalanceado no se arregla solo.

3. **Grafica una ventana de cada clase** en una sola figura y guárdala en `figuras/dataset.png`.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Cuántas ventanas capturaste por clase.
   - Qué hiciste en concreto para que la velocidad de tu mano no se convirtiera en una pista, y qué tan bien crees que te salió.
   - Qué te sorprendió al ver los datos juntos.
   - Si algo salió mal durante la captura y cómo lo resolviste. Esto vale, no lo escondas: en la semana 16 vamos a volver sobre los problemas de este dataset.

   ```bash
   git add .
   git commit -m "s03 proyecto: dataset etiquetado de los tres tipos de pieza"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Cada integrante captura el dataset de su propio dominio, pero **con el mismo formato de columnas**. Acuerden hoy:

1. **Los nombres de las columnas de control**, que deben ser idénticos en los tres: `ventana`, `t`, `etiqueta`. Si uno le pone `id` y otro `ventana`, el controlador central de la semana 8 va a necesitar código distinto para cada módulo.
2. **El mismo `N_MUESTRAS`**, si sus sensores lo permiten. Ventanas del mismo largo simplifican mucho la integración.
3. **Que las etiquetas de los tres no se repitan entre sí.** Si dos módulos tienen una clase llamada `grande`, el sistema integrado no va a poder decir de cuál módulo vino. Pónganle prefijo si hace falta: `tam_grande`, `mat_metal`.
