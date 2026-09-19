---
layout: default
title: De la señal a la decisión
---
[Inicio](/curso/senal)

# Sesión 2 - De los datos a la decisión

Ayer terminaste con 6000 números en un archivo. Hoy esos números se convierten en un sistema que **decide solo**: le pones una pieza enfrente y prende el color que le corresponde, sin que nadie le haya escrito las reglas.

Esa última parte es la importante. Nadie va a programar "si la lectura es mayor que tanto, entonces es aluminio". Las reglas las va a encontrar un programa a partir de tus datos, y al final te las va a imprimir para que las leas.

---

- [Antes de empezar](#antes-de-empezar)
- [Bloque 1: features.py, de 200 números a 4](#features)
- [Bloque 2: entrenar.py, el árbol y sus reglas](#entrenar)
- [Bloque 3: control.py, cerrar el bucle](#control)
- [Bloque 4: publica tu proyecto](#github)
- [La cuarta pieza](#cuarta-pieza)
- [Con lo que te vas](#cierre)

---

## Antes de empezar {#antes-de-empezar}

Abre el CMD en tu carpeta `taller`, la misma de ayer, con el truco de la barra de direcciones. Comprueba que ahí está tu `datos.csv`:

```
dir
```

**Si no lo tienes**, o si quedó mal, cópialo de la memoria USB y sigue adelante sin problema. Hay un `datos.csv` de respaldo ahí, capturado igual que el tuyo. Perder una etapa no significa perder el día: lo mismo vale para los archivos de más adelante, `features.csv` y `modelo.pkl`.

| | Bloque | Terminas con |
|---|---|---|
| 1 | `features.py` | `features.csv` y la gráfica donde se ven separadas |
| 2 | `entrenar.py` | `modelo.pkl` y las reglas impresas |
| 3 | `control.py` y `control.ino` | La pieza prendiendo su color |
| 4 | Git y GitHub | Tu proyecto publicado |

---

## Bloque 1: features.py, de 200 números a 4 {#features}

Tienes 30 ventanas de 200 muestras cada una. El problema es que **200 números no describen una pieza**: describen 2 segundos de una pieza. Si comparas ventana contra ventana muestra por muestra, dos capturas de la misma cartulina nunca van a ser iguales.

Lo que se hace es resumir cada ventana en unos pocos números que sí digan algo del material. A esos números se les llama **características**, y aquí vamos a sacar cuatro:

| Característica | Qué dice |
|---|---|
| `media` | Cuánta luz rebota en promedio. Es la que más separa a las tres piezas |
| `desv` | Qué tanto tiembla la lectura. El aluminio reflejando es mucho más inquieto que una cartulina mate |
| `minimo` | La lectura más baja de la ventana |
| `maximo` | La lectura más alta de la ventana |

```python
# features.py - convierte cada ventana de 200 muestras en una fila de 4 numeros
import pandas as pd
import matplotlib.pyplot as plt

datos = pd.read_csv('datos.csv')

filas = []
for ventana, g in datos.groupby('ventana'):
    x = g['tcrt'].values           # las 200 muestras del TCRT de esta ventana

    filas.append({
        'ventana':  ventana,
        'media':    x.mean(),
        'desv':     x.std(),
        'minimo':   x.min(),
        'maximo':   x.max(),
        'etiqueta': g['etiqueta'].iloc[0],
    })

features = pd.DataFrame(filas)
features.to_csv('features.csv', index=False)

print(features)
print()
print("Ventanas por pieza:")
print(features.groupby('etiqueta').size())

# cada pieza, un color, para ver si se separan
for etiqueta, g in features.groupby('etiqueta'):
    plt.scatter(g['media'], g['desv'], label=etiqueta)

plt.xlabel('media')
plt.ylabel('desviacion')
plt.legend()
plt.savefig('features.png')
plt.show()
```

Córrelo:

```
python features.py
```

Fíjate en el tamaño de lo que acaba de pasar: entraron **6000 filas** y salieron **30**, una por ventana. De 200 números por ventana quedaron 4. Así es como se le da de comer a un modelo.

### La gráfica es la pregunta del día

En la ventana que se abrió, cada punto es una de tus 30 ventanas, y cada color una pieza. **Si los tres colores forman tres grupos separados, tu dataset sirve.** Si están revueltos, ningún modelo del mundo los va a distinguir después, porque la información no está ahí.

Casi siempre se ven así: las cartulinas caen en dos grupos apretados, y el aluminio más disperso. Esa dispersión es su reflejo especular, que cambia con el ángulo.

Si tus grupos se enciman, lo que está mal son los datos, no el programa. Toma el `datos.csv` de respaldo del USB y sigue con él.

### Por qué no está el LDR

Los datos del LDR siguen ahí, en `datos.csv`, columna `ldr`. Pero `features.py` solo mira la columna `tcrt`.

Es a propósito, y ayer lo viste con la mano: el LDR mide la luz que hay en el aula. Un modelo entrenado con eso funciona a las 11 de la mañana y falla a las 6 de la tarde. El TCRT trae su propia luz, así que su lectura depende de la pieza y no de la hora.

Elegir qué entra y qué no es parte del trabajo, y casi siempre importa más que elegir el modelo.

---

## Bloque 2: entrenar.py, el árbol y sus reglas {#entrenar}

```python
# entrenar.py - entrena el arbol de decision y lo guarda en modelo.pkl
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, export_text
from sklearn.metrics import accuracy_score, confusion_matrix

features = pd.read_csv('features.csv')

X = features.drop(columns=['ventana', 'etiqueta'])   # las 4 caracteristicas
y = features['etiqueta']                             # la respuesta correcta

X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.25,
    stratify=y,        # misma proporcion de piezas en las dos partes
    random_state=42,   # para que el resultado se pueda repetir
)

modelo = DecisionTreeClassifier(max_depth=3, random_state=42)
modelo.fit(X_train, y_train)

y_pred = modelo.predict(X_test)

print("Exactitud:", accuracy_score(y_test, y_pred))
print()
print("Matriz de confusion:")
print(confusion_matrix(y_test, y_pred, labels=sorted(y.unique())))
print("Clases en ese orden:", sorted(y.unique()))
print()
print("Las reglas que aprendio el arbol:")
print(export_text(modelo, feature_names=list(X.columns)))

joblib.dump({'modelo': modelo, 'columnas': list(X.columns)}, 'modelo.pkl')
print("Guardado en modelo.pkl")
```

```
python entrenar.py
```

### Lo que acaba de pasar, en tres partes

**1. Se apartaron datos para el examen.** `train_test_split` guarda una cuarta parte de tus ventanas y no se las enseña al modelo. Se entrena con las otras tres cuartas partes y después se le pregunta por las que nunca vio. Si lo calificáramos con las mismas ventanas con las que aprendió, estaríamos midiendo su memoria, no si aprendió algo.

**2. La exactitud.** Es la fracción de ventanas del examen que acertó. Con estas tres piezas normalmente sale 1.0, porque son muy distintas entre sí. Un 1.0 aquí no significa que el sistema sea perfecto: significa que el problema era fácil.

**3. Las reglas.** Esto es lo que viniste a ver:

```
|--- media <= 412.50
|   |--- class: negra
|--- media >  412.50
|   |--- desv <= 18.30
|   |   |--- class: blanca
|   |--- desv >  18.30
|   |   |--- class: aluminio
```

Tus números van a ser otros, y puede que las preguntas también: a lo mejor a tu árbol le basta la `media` para separar las tres piezas, y a lo mejor necesita la `desv` para distinguir la blanca del aluminio. Lo que no cambia es la forma, una cadena de preguntas con un sí y un no.

Léelo en voz alta, el tuyo. El de arriba diría: si la media es menor que 412.50 es negra; si no, y además tiembla poco, es blanca; y si tiembla mucho, es aluminio.

**Eso es exactamente el `if` que habrías escrito tú a mano.** La diferencia es que nadie se lo dictó. Salió de tus 30 ventanas, y si mañana cambias de material o de sensor, vuelves a correr `entrenar.py` y salen otras reglas solas.

Ahí está la idea completa del aprendizaje de máquina. El resto son variaciones: modelos que no se pueden leer así de fácil, problemas donde las reglas son miles, datos que no se separan tan bonito.

### Prueba esto

Cambia `max_depth=3` por `max_depth=1` y vuelve a correrlo. El árbol ahora solo puede hacer **una** pregunta, así que a la fuerza confunde dos piezas. Míralo en la matriz de confusión y regrésalo a 3.

---

## Bloque 3: control.py, cerrar el bucle {#control}

Hasta aquí el sistema solo piensa. Falta que **haga** algo, que es lo que lo vuelve mecatrónico y no una hoja de cálculo.

### Agrega el LED RGB

Tiene cuatro patas. La más larga es el **cátodo común** y va a tierra; las otras tres son los tres colores, y cada una lleva su resistencia de 220 ohm.

| Pata del LED | Va a |
|---|---|
| La más larga (cátodo) | `GND` |
| Rojo | resistencia de 220 ohm, y de ahí al pin `9` |
| Verde | resistencia de 220 ohm, y de ahí al pin `10` |
| Azul | resistencia de 220 ohm, y de ahí al pin `11` |

Los sensores se quedan donde están. Si al probar el LED no enciende ningún color, lo más probable es que el tuyo sea de ánodo común: avísame y lo resolvemos en un minuto.

### El nuevo programa del Arduino

`control.ino` hace lo mismo que `sensor.ino` y además **escucha**: si le llega una letra desde Python, prende el color que le toca.

```cpp
// control.ino - manda la lectura de los sensores y obedece las ordenes de Python
// R = rojo (blanca), V = verde (negra), A = azul (aluminio), 0 = apagado

const int PIN_TCRT = A0;
const int PIN_LDR  = A1;

const int PIN_ROJO  = 9;
const int PIN_VERDE = 10;
const int PIN_AZUL  = 11;

void color(int r, int v, int a) {
  digitalWrite(PIN_ROJO,  r);
  digitalWrite(PIN_VERDE, v);
  digitalWrite(PIN_AZUL,  a);
}

void setup() {
  Serial.begin(115200);
  pinMode(PIN_ROJO,  OUTPUT);
  pinMode(PIN_VERDE, OUTPUT);
  pinMode(PIN_AZUL,  OUTPUT);
  color(LOW, LOW, LOW);
}

void loop() {
  Serial.print(analogRead(PIN_TCRT));
  Serial.print(',');
  Serial.println(analogRead(PIN_LDR));

  if (Serial.available() > 0) {
    char orden = Serial.read();

    switch (orden) {
      case 'R': color(HIGH, LOW,  LOW);  break;
      case 'V': color(LOW,  HIGH, LOW);  break;
      case 'A': color(LOW,  LOW,  HIGH); break;
      case '0': color(LOW,  LOW,  LOW);  break;
    }
  }

  delay(10);
}
```

Súbelo con el Arduino IDE, y **cierra el Monitor Serie** antes de seguir.

### El bucle completo

```python
# control.py - el bucle completo: capturar, decidir y prender el color
import serial
import time
import numpy as np
import pandas as pd
import joblib

PUERTO = 'COM3'           # cambia este por el tuyo
BAUDIOS = 115200
N_MUESTRAS = 200          # el mismo largo de ventana que en adquirir.py

paquete  = joblib.load('modelo.pkl')
modelo   = paquete['modelo']
columnas = paquete['columnas']

COLORES = {'blanca': b'R', 'negra': b'V', 'aluminio': b'A'}

ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
time.sleep(2)

print("Sistema en marcha. Ctrl+C para detener.")

try:
    while True:
        input("\nPon una pieza y presiona Enter...")
        ser.reset_input_buffer()

        # 1. CAPTURAR una ventana, igual que en adquirir.py
        muestras = []
        while len(muestras) < N_MUESTRAS:
            linea = ser.readline().decode('utf-8').strip()
            partes = linea.split(',')
            if len(partes) != 2:
                continue
            try:
                muestras.append(int(partes[0]))      # solo el TCRT
            except ValueError:
                continue

        # 2. EXTRAER las caracteristicas, igual que en features.py
        x = np.array(muestras)
        fila = pd.DataFrame([{
            'media':  x.mean(),
            'desv':   x.std(),
            'minimo': x.min(),
            'maximo': x.max(),
        }])[columnas]                                # en el mismo orden del entrenamiento

        # 3. DECIDIR
        etiqueta = modelo.predict(fila)[0]
        print(f"-> {etiqueta}")

        # 4. ACTUAR
        ser.write(COLORES[etiqueta])

except KeyboardInterrupt:
    pass

ser.write(b'0')
ser.close()
print("\nListo")
```

```
python control.py
```

Pon la cartulina blanca: **rojo**. La negra: **verde**. El aluminio: **azul**. Prueba las tres varias veces, con trozos distintos.

### Lo que hay que ver aquí

Los pasos 1 y 2 de `control.py` son **copias exactas** de lo que hacen `adquirir.py` y `features.py`. No es pereza: es obligatorio. El modelo aprendió con ventanas de 200 muestras resumidas en esas cuatro características, en ese orden. Si aquí capturaras 100 muestras, o calcularas la desviación de otra forma, el modelo recibiría algo distinto a lo que aprendió y se equivocaría sin avisar.

Por eso `modelo.pkl` no guarda solo el modelo: guarda también la lista de columnas. Es la manera de que el sistema en marcha no se desincronice del entrenamiento.

Y eso es el bucle cerrado: **sensor -> características -> modelo -> actuador**. Es el mismo dibujo de cualquier sistema de este tipo, desde el que acabas de armar hasta el que separa piezas en una banda transportadora.

---

## Bloque 4: publica tu proyecto {#github}

Tu trabajo tiene que salir de tu computadora. Es lo que se te va a pedir para acreditar el taller y, sobre todo, es lo que vas a volver a abrir en febrero.

**1. Crea el repositorio en GitHub.** En [github.com](https://github.com/), botón **New**. Nómbralo `taller-senal`, déjalo **público** y, muy importante, **no marques ninguna casilla** de las de abajo (nada de "Add a README file"). Tiene que quedar completamente vacío o el push de más adelante va a fallar.

**2. Desde el CMD, en tu carpeta `taller`:**

```
git init
git add .
git commit -m "Taller: clasificador de tres piezas"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/taller-senal.git
git push -u origin main
```

Cambia `TU_USUARIO` por el tuyo. En el `git push` se va a abrir una ventana del navegador para que inicies sesión en GitHub: es normal, es la primera y única vez.

**3. Recarga la página del repositorio.** Ahí tienen que estar tus siete programas, tu `datos.csv`, tu `features.csv` y tu `modelo.pkl`.

Lo que acabas de hacer con esos seis comandos es lo mismo que vas a hacer todas las semanas del curso de Inteligencia Artificial, con la diferencia de que allá vas a hacer un commit por cada avance en vez de uno solo al final.

---

## La cuarta pieza {#cuarta-pieza}

Con `control.py` corriendo, ponle una pieza que **nunca haya visto**: una cartulina de color, un pedazo de madera, tu propia mano.

El sistema no se queda callado ni dice "no sé". Dice **blanca**, o **negra**, o **aluminio**, con la misma seguridad con la que acertaba hace un momento, y prende su color tan tranquilo.

No está descompuesto. Está haciendo exactamente lo que le pediste: repartir lo que llegue entre tres cajones. Nunca le enseñaste que pudiera existir un cuarto, así que para él no existe.

Ese hueco tiene nombre y tiene solución, y es una unidad completa del curso que empieza en febrero: enseñarle a un sistema a reconocer **lo que no encaja**. Es lo que separa un clasificador de laboratorio de uno que puede trabajar en una línea de producción, donde lo que llega raro es justo lo que hay que detectar.

---

## Con lo que te vas {#cierre}

Un sistema completo, armado por ti, que mide el mundo y actúa en consecuencia. Y algo que no se ve en la mesa: ya recorriste una vez, con las manos, buena parte del proyecto que vas a construir durante todo el semestre que viene.

| Lo que hiciste | En el curso de IE043 es |
|---|---|
| `sensor.ino` y el Monitor Serie | Semana 2 |
| `leer_sensor.py` | Semana 2 |
| `adquirir.py` y `datos.csv` | Semana 3 |
| `features.py` | Semana 5 |
| `entrenar.py` y el árbol | Semana 7 |
| `control.py` y el bucle cerrado | Semana 8 |
| La cuarta pieza | Unidad 3, semanas 10 a 13 |

Entre hoy y febrero hay cuatro meses, y el código se te va a olvidar. No importa: lo que no se olvida es que tienes el kit comprado y la computadora lista, y que estas palabras (dataset, característica, entrenar, modelo) ya no son nuevas.

**Esta página se queda publicada.** Si algún día de vacaciones quieres volver a armarlo, está todo aquí: las dos sesiones, el código completo y [la guía de instalación](/curso/senal/requisitos/).
