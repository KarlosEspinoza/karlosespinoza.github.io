---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 12 - Autoencoders para detección de anomalías (U3)

La semana pasada detectaste piezas raras con DBSCAN, y funcionó hasta cierto punto: DBSCAN marca como ruido lo que cae en zonas vacías, pero necesita ver todo el conjunto de datos junto para decidir, y eso no sirve en producción, donde las piezas llegan de una en una.

Esta semana construyes un detector de verdad: uno que **aprende cómo se ve una pieza normal**, y después puede juzgar una pieza nueva, ella sola, en tiempo real. Y lo hace con una idea preciosa: aprender a copiar.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: aprender a copiar para detectar lo raro](#bloque-1)
    - [Bloque 2: autoencoder.py y el umbral](#bloque-2)
    - [Bloque extra: el tamaño del cuello de botella](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes la idea del autoencoder y del error de reconstrucción | Tu explicación con tus palabras |
| 2 | Entrenas el autoencoder y eliges tu umbral | `codigo/autoencoder.py` y `detector.pkl` |
| Extra | Pruebas distintos tamaños del cuello de botella | La tabla comparativa |

Sobre `features.csv` y `anomalias.csv`. Sin hardware.

---

### Bloque 1: aprender a copiar para detectar lo raro {#bloque-1}

#### El truco

Un **autoencoder** es una red neuronal a la que se le pide algo que parece absurdo: **que su salida sea igual a su entrada**. Le das un vector de ocho números y tiene que devolver esos mismos ocho números.

Dicho así no sirve de nada: bastaría con copiar. La gracia está en que **en medio se le pone un cuello de botella**.

```
  entrada          cuello          salida
  8 features      2 neuronas      8 features

     o                               o
     o                               o
     o               o               o
     o                               o
     o               o               o
     o                               o
     o                               o
     o                               o

     \______ codificador ___/\__ decodificador __/
```

Para reconstruir ocho números pasando por solo dos, la red **no puede memorizar: tiene que comprimir**. Está obligada a descubrir cuáles son las dos direcciones que resumen mejor tus datos, y a reconstruir el resto a partir de ellas.

La primera mitad se llama **codificador** (comprime) y la segunda **decodificador** (reconstruye).

#### El error de reconstrucción

Y aquí viene la idea que hace todo esto útil.

Entrenas el autoencoder **solo con piezas normales**. Nunca ve una anómala. Aprende a comprimir y reconstruir bien las tres clases que conoce.

Ahora le llega una pieza rara. Como sus características no se parecen a nada de lo que aprendió, **la reconstruye mal**. Y qué tan mal la reconstruyó se puede medir:

$$e = \frac{1}{m}\sum_{i=1}^{m}(x_i - \hat{x}_i)^2$$

donde:

- $x_i$ es la característica $i$ de la entrada
- $\hat{x}_i$ es lo que la red devolvió para esa característica
- $m$ es el número de características
- $e$ es el **error de reconstrucción**

Ese número es tu medida de rareza:

```
error de reconstruccion
   ^
   |                              o   <- pieza anomala
   |                                      (error alto)
   |          UMBRAL
   |  - - - - - - - - - - - - - - - - -
   |   . .  . .. .  . . ..  .         <- piezas normales
   |  . . .. .  . .. .  . .              (error bajo)
   +-------------------------------> ejemplos
```

Por encima del umbral: anomalía. Por debajo: normal. Un solo número, calculable para una pieza aislada, en un milisegundo. Eso es lo que le faltaba a DBSCAN.

#### Por qué esto es mejor que un clasificador de anomalías

Podrías pensar: ¿por qué no entreno un clasificador supervisado con una cuarta clase llamada `anomalia`?

Porque **no sabes cómo van a ser las anomalías**. Tú capturaste diez piezas raras que se te ocurrieron. En la línea real va a aparecer algo que no imaginaste, y un clasificador entrenado con tus diez la va a meter en la clase que más se le parezca.

El autoencoder no aprende cómo son las anomalías. Aprende **cómo es lo normal**, y marca todo lo que se salga de eso. Por eso detecta cosas que nunca vio, que es justamente lo que necesitas.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Explica con tus palabras por qué obligar a la red a pasar por un cuello de botella es lo que hace que el truco funcione.
2. Por qué el autoencoder se entrena **solo** con piezas normales. ¿Qué pasaría si le metieras también las anómalas?
3. Da un ejemplo concreto, de tu propio dominio, de una anomalía que tu clasificador de la semana 7 no podría manejar.

```bash
git add .
git commit -m "s12 bloque 1: idea del autoencoder"
git push
```

---

### Bloque 2: autoencoder.py y el umbral {#bloque-2}

#### Con las herramientas que ya tienes

No necesitas instalar nada nuevo. Un autoencoder se arma con el `MLPRegressor` de scikit-learn: es la misma red de la semana 8, pero de regresión en vez de clasificación, y entrenada con `X` tanto de entrada como de salida.

```python
# autoencoder.py - detector de anomalias por error de reconstruccion
import numpy as np
import pandas as pd
import joblib
from sklearn.preprocessing import StandardScaler
from sklearn.neural_network import MLPRegressor
from sklearn.model_selection import train_test_split

features = pd.read_csv('datos/features.csv')
X = features.drop(columns=['ventana', 'etiqueta'])

# solo piezas normales, y se aparta una porcion para calcular el umbral
X_train, X_val = train_test_split(X, test_size=0.3, random_state=42)

escalador = StandardScaler()
X_train_esc = escalador.fit_transform(X_train)
X_val_esc   = escalador.transform(X_val)

autoencoder = MLPRegressor(
    hidden_layer_sizes=(4, 2, 4),   # el 2 del medio es el cuello de botella
    activation='relu',
    max_iter=5000,
    random_state=42,
)
autoencoder.fit(X_train_esc, X_train_esc)     # entrada y salida son lo mismo

def error_reconstruccion(X_esc):
    reconstruido = autoencoder.predict(X_esc)
    return np.mean((X_esc - reconstruido)**2, axis=1)

errores_normales = error_reconstruccion(X_val_esc)

UMBRAL = np.percentile(errores_normales, 95)
print(f"Umbral (percentil 95 de las normales): {UMBRAL:.4f}")

joblib.dump({'autoencoder': autoencoder, 'escalador': escalador,
             'umbral': UMBRAL, 'columnas': list(X.columns)},
            'detector.pkl')

# TODO: carga anomalias.csv, calcula sus caracteristicas con el mismo features.py,
#       escalalas con este mismo escalador y calcula sus errores

# TODO: cuenta cuantas anomalias quedaron por encima del umbral (detectadas)
#       y cuantas normales quedaron por encima (falsas alarmas)

# TODO: grafica los dos histogramas de error, normales y anomalas,
#       con una linea vertical en el umbral. Guarda en figuras/anomalias.png
```

Tres cosas del código que importan:

**`fit(X, X)`.** Ahí está todo el truco: la entrada y la salida son el mismo dato.

**La arquitectura `(4, 2, 4)`.** Tres capas ocultas: comprime a 4, luego a 2, y descomprime a 4. El número del medio es el cuello de botella y es el parámetro que decide qué tanto obligas a comprimir.

**Se aparta un conjunto de validación.** El umbral **no** se calcula sobre los datos de entrenamiento, porque ahí el autoencoder reconstruye demasiado bien y el umbral saldría mucho más bajo de lo real, con lo que todo dispararía alarma. Se calcula sobre datos normales que la red no vio.

#### Elegir el umbral

Poner el percentil 95 significa: **acepto que el 5% de mis piezas normales disparen una falsa alarma**. Ese 5% es una decisión de ingeniería, no un número sagrado, y la decisión depende de qué error te duele más:

| Umbral | Falsas alarmas | Anomalías que se escapan |
|---|---|---|
| Percentil 90 | Muchas | Pocas |
| Percentil 95 | Algunas | Algunas |
| Percentil 99 | Pocas | Muchas |

Y cuál conviene depende de tu proceso. Si detener la banda por una falsa alarma cuesta caro, subes el umbral. Si dejar pasar una pieza defectuosa es un problema de seguridad, lo bajas y aguantas las falsas alarmas.

**Escribe tu decisión y su justificación en la bitácora.** No es un detalle: es la parte de ingeniería de este tema, y es lo que voy a preguntar en la revisión.

#### La gráfica de los dos histogramas

Es la evidencia principal de la semana. Dos histogramas encimados, el de errores de las piezas normales y el de las anómalas, con una línea vertical en el umbral.

```
  frecuencia
    ^
    |  ####
    |  ######            UMBRAL
    |  ########            |
    |  ##########          |    ***
    |  ############        |  *******
    +-----------------------------------> error
       normales            |   anomalas
```

Lo que se lee de golpe: **qué tanto se separan las dos poblaciones**. Si están bien separadas, tu detector funciona y casi cualquier umbral entre ellas sirve. Si se traslapan, ningún umbral te va a dar un resultado limpio, y ahí tienes que decidir qué error prefieres cometer.

**Lo que entregas de este bloque**

- `codigo/autoencoder.py` con los tres `TODO` resueltos.
- `detector.pkl` en la raíz.
- `figuras/anomalias.png` con los dos histogramas y el umbral.
- En `BITACORA.md`:
  1. Tu umbral y por qué elegiste ese percentil, en función de tu proceso.
  2. Cuántas de tus piezas raras detectó, comparado con las que detectaba DBSCAN la semana pasada.
  3. Cuántas falsas alarmas produce sobre piezas normales.

```bash
git add .
git commit -m "s12 bloque 2: autoencoder entrenado y umbral elegido"
git push
```

---

### Bloque extra: el tamaño del cuello de botella {#bloque-extra}

Opcional. El `2` del medio lo puse yo. Encuéntralo tú con datos.

```python
for cuello in [1, 2, 3, 4, 6]:
    ae = MLPRegressor(hidden_layer_sizes=(6, cuello, 6),
                      max_iter=5000, random_state=42)
    ae.fit(X_train_esc, X_train_esc)
    # TODO: calcula el error medio en normales y en anomalas
    # TODO: calcula cuantas anomalias detecta con el umbral del percentil 95
```

Lo que vas a ver es un compromiso muy claro:

**Cuello muy chico (1).** La red comprime demasiado y reconstruye mal hasta lo normal. Los errores de todo son altos, las dos poblaciones se juntan y el detector deja de distinguir.

**Cuello muy grande (6 de 8).** Casi no hay compresión, la red aprende prácticamente a copiar, y reconstruye bien **cualquier cosa**, incluidas las anomalías. Otra vez dejas de distinguir, por el motivo opuesto.

**En medio está el punto bueno**, y el criterio para elegirlo no es el error más bajo: es **la mayor separación entre las dos poblaciones**. Puedes medirlo con la diferencia entre el error promedio de las anómalas y el de las normales.

Es la misma lección que la del filtro en la semana 4 y la de `max_depth` en la semana 7: los parámetros que controlan cuánta capacidad tiene un modelo casi siempre tienen un óptimo en medio, no en los extremos.

```bash
git add .
git commit -m "s12 extra: tamaño del cuello de botella"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu detector entrenado y tu figura de histogramas. La sesión es de análisis y de una prueba en vivo.

**1. El marcador contra DBSCAN.** Actualizamos el tablero de la semana pasada, ahora con dos columnas: cuántas anomalías detectaba DBSCAN y cuántas detecta el autoencoder. Discutimos los casos donde el autoencoder ganó por mucho y los pocos donde no ganó.

**2. La galería de histogramas.** Todas las figuras juntas. Se ve inmediatamente quién tiene poblaciones bien separadas y quién las tiene encimadas, y por qué: casi siempre depende de qué tan raras eran las piezas que cada quien eligió como anomalías. Quien usó una de sus propias piezas al revés tiene un caso mucho más difícil que quien usó un tornillo.

**3. La anomalía sorpresa.** Le paso a cada quien un objeto que nunca ha visto y que yo elijo. Lo pasa por su sensor, calcula su error de reconstrucción y vemos si su detector lo marca. Es la prueba honesta: una anomalía que el alumno no eligió ni anticipó.

**4. Prepararse para la semana 13.** Cada quien decide qué va a hacer su sistema cuando detecte una anomalía. No se implementa hoy, se decide: ¿detiene la banda? ¿la desvía a un tercer carril? ¿enciende una alarma y la deja pasar? Esa decisión es el punto de partida de la semana que viene.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu `detector.pkl` entrenado y guardado**, con su autoencoder, su escalador, su umbral y sus columnas.

2. **Amplía `datos/anomalias.csv`** a por lo menos 15 ventanas, incluyendo tipos distintos de anomalía: objetos ajenos, piezas de las tuyas dañadas, piezas de las tuyas en posición incorrecta. Cuanta más variedad, más honesta es tu evaluación.

3. **Arma tu tabla de resultados**:

   | | Detectadas | Total | Tasa |
   |---|---|---|---|
   | Anomalías | | | |
   | Falsas alarmas sobre normales | | | |

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Tu tabla de resultados.
   - Qué tipo de anomalía detecta bien tu sistema y cuál se le escapa. Esto es lo más valioso que puedes escribir esta semana: casi siempre se escapan las anomalías "sutiles", como tu propia pieza con un defecto pequeño, y entender por qué es entender el método.
   - Qué acción vas a disparar cuando se detecte una anomalía, que es lo que implementas la semana que viene.

   ```bash
   git add .
   git commit -m "s12 proyecto: detector de anomalias funcionando"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Implementen la arquitectura de detección que decidieron en la semana 10, la de un detector por módulo o uno solo para todo el sistema.

Y hagan una prueba que da mucha información: **pasen por el sistema una pieza que es normal para un módulo y anómala para otro**. Por ejemplo, una pieza de metal pequeña en un equipo donde uno clasifica por material y otro por tamaño.

Lo que hay que definir es la política del sistema completo: **¿basta con que un módulo grite anomalía para que el sistema reaccione, o tienen que coincidir varios?** Las dos son defendibles y dependen de qué te cueste más. Anoten la decisión, la razón y el resultado de la prueba en el README del equipo.
