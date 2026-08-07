---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 7 - Entrenamiento del clasificador (U2)

Seis semanas preparando el terreno. Esta semana llega el momento por el que se llama así el curso: **el modelo aprende solo la regla que separa tus piezas**.

Tú no vas a escribir ningún `if`. Le vas a entregar tu `features.csv` con las etiquetas y el algoritmo va a encontrar la frontera. Y si en la semana 1 te pareció magia, esta semana vas a ver que no lo es: es geometría, y bastante intuitiva.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: qué significa entrenar](#bloque-1)
    - [Bloque 2: entrenar.py y el modelo guardado](#bloque-2)
    - [Bloque extra: compara tres algoritmos](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes qué es entrenar y cómo deciden k-NN y el árbol | Tu elección de algoritmo, justificada |
| 2 | Escribes `entrenar.py`, entrenas y guardas el modelo | `codigo/entrenar.py` y `modelo.pkl` |
| Extra | Comparas tres algoritmos y eliges con evidencia | La tabla comparativa |

Sobre tu `features.csv`. Sin hardware.

---

### Bloque 1: qué significa entrenar {#bloque-1}

#### X e y

Todo en scikit-learn se organiza igual, y una vez que lo entiendes ya sabes usar cualquier algoritmo de la biblioteca:

**X** es la tabla de características, sin la etiqueta. Una fila por ejemplo, una columna por característica. En tu caso, 90 filas y unas seis columnas.

**y** es el vector de etiquetas. Un valor por fila de X, en el mismo orden.

```python
X = features.drop(columns=['ventana', 'etiqueta'])
y = features['etiqueta']
```

Fíjate que la columna `ventana` también sale: es un identificador, no una característica. Si la dejaras, el modelo podría aprender que "las ventanas del 0 al 29 son madera", que es cierto en tu archivo y completamente inútil en la realidad. Es una fuga de información de manual.

**Entrenar** es una sola línea, y significa: encuentra la regla que mejor asigna cada fila de X a su etiqueta en y.

```python
modelo.fit(X, y)
```

#### La frontera de decisión

Piensa en tu diagrama de dispersión de la semana 5: puntos de tres colores en un plano. Entrenar un clasificador es **trazar las líneas que dividen ese plano en zonas**, una por clase. Cuando llegue un punto nuevo, cae en alguna zona y esa es la predicción.

```
   caracteristica 2
     ^
     |   A A         |
     |  A A A        |   C C
     |   A A     ____|  C C C
     |          /    |   C C
     |   B B   /     |
     |  B B B /      |
     +---------------------> caracteristica 1
```

Lo único en lo que se diferencian los algoritmos es **en la forma de esas fronteras y en cómo las encuentran**. Con dos características es un plano y se puede dibujar; con seis es un espacio de seis dimensiones que no te puedes imaginar, pero la idea es idéntica.

#### k-NN: los vecinos más cercanos

Es el algoritmo más simple que existe y por eso vale la pena entenderlo primero.

**Entrenamiento:** memorizar todos los ejemplos. Literalmente eso, no hace nada más.

**Predicción:** para un punto nuevo, buscar los $k$ ejemplos más cercanos y votar. Si $k = 5$ y tres de los cinco vecinos son madera, la respuesta es madera.

La distancia entre dos ejemplos se mide así:

$$d(a,b) = \sqrt{\sum_{i=1}^{m}(a_i - b_i)^2}$$

donde $a$ y $b$ son dos filas de características y $m$ el número de características.

Y esa fórmula esconde la trampa más importante de k-NN: **si una característica tiene números mucho más grandes que las otras, domina la distancia**. Si tu `energia` vale millones y tu `duracion` vale 40, la duración deja de existir para el algoritmo. Por eso con k-NN **hay que estandarizar**, sin excepción. Lo haces con `StandardScaler`.

El valor de $k$ es tu decisión. Chico ($k=1$) da fronteras muy pegadas a los datos y se traga el ruido. Grande suaviza pero puede borrar clases pequeñas. Para 90 ejemplos, empieza con $k = 5$.

#### Árbol de decisión

El otro extremo: en vez de comparar distancias, hace preguntas.

```
                 rango > 80 ?
                /            \
             si                no
             /                   \
      duracion > 45 ?           madera
       /         \
     si           no
     /              \
  metal          plastico
```

**Entrenamiento:** buscar, para cada nivel, la pregunta que mejor separa las clases, y repetir.

Su gran virtud para este curso es que **puedes leer lo que aprendió**. Con k-NN el conocimiento está repartido en 90 puntos memorizados y no se puede explicar; el árbol te enseña sus reglas, y eso vale oro para tu bitácora y para la revisión de avances. Además no le importa la escala, así que no necesita estandarizar.

Su defecto: si lo dejas crecer sin límite, memoriza. Un árbol suficientemente profundo hace una hojita para cada uno de tus 90 ejemplos y acierta el 100% en entrenamiento sin haber aprendido nada. Se controla con `max_depth`.

#### Por qué hay que partir el dataset

Aquí está la idea más importante de la semana, y la que separa a quien entendió de quien no.

**Si evalúas el modelo con los mismos datos con los que lo entrenaste, el resultado no significa nada.** Un k-NN con $k=1$ evaluado sobre sus propios datos de entrenamiento acierta el 100%, siempre, porque el vecino más cercano de cada punto es él mismo. Y ese modelo puede ser malísimo.

Lo que nos importa no es que acierte en lo que ya vio: es que **acierte en piezas que nunca vio**. A eso se le llama **generalizar**, y es literalmente el objetivo de todo el aprendizaje de máquina.

Por eso el dataset se parte en dos:

- **Entrenamiento** (70-80%): con estos el modelo aprende.
- **Prueba** (20-30%): estos se apartan, el modelo no los ve durante el entrenamiento, y sirven para medir.

```
  tus 90 ventanas
  +---------------------------+--------+
  |      entrenamiento        | prueba |
  |         72                |   18   |
  +---------------------------+--------+
     el modelo aprende         se mide
     de aqui                   aqui
```

Y la partición tiene que ser **estratificada**: que la proporción de clases sea la misma en las dos partes. Si el azar te mete todas las piezas de metal en la parte de prueba, entrenaste un modelo que nunca vio metal. Eso se resuelve con `stratify=y`.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Con cuántos ejemplos vas a entrenar y con cuántos a probar, con los números de tu dataset.
2. Qué algoritmo eliges para empezar y por qué, en función de tu caso concreto.
3. Explica con tus palabras por qué un modelo que acierta 100% en los datos de entrenamiento puede ser inútil.

```bash
git add .
git commit -m "s07 bloque 1: eleccion de algoritmo y particion"
git push
```

---

### Bloque 2: entrenar.py y el modelo guardado {#bloque-2}

```python
# entrenar.py - entrena el clasificador y lo guarda en modelo.pkl
import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, confusion_matrix

features = pd.read_csv('datos/features.csv')

X = features.drop(columns=['ventana', 'etiqueta'])
y = features['etiqueta']

X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size=0.25,
    stratify=y,        # misma proporcion de clases en las dos partes
    random_state=42,   # para que el resultado se pueda repetir
)

escalador = StandardScaler()
X_train_esc = escalador.fit_transform(X_train)
X_test_esc  = escalador.transform(X_test)      # transform, NO fit_transform

modelo = KNeighborsClassifier(n_neighbors=5)
modelo.fit(X_train_esc, y_train)

y_pred = modelo.predict(X_test_esc)

print("Exactitud:", accuracy_score(y_test, y_pred))
print()
print("Matriz de confusion:")
print(confusion_matrix(y_test, y_pred, labels=sorted(y.unique())))
print("Clases en ese orden:", sorted(y.unique()))

# el escalador se guarda junto al modelo: sin el, el modelo no sirve
joblib.dump({'modelo': modelo, 'escalador': escalador, 'columnas': list(X.columns)},
            'modelo.pkl')
print("\nGuardado en modelo.pkl")

# TODO: grafica la matriz de confusion y guardala en figuras/confusion.png
#       pista: ConfusionMatrixDisplay de sklearn.metrics
```

Tres cosas de este código que hay que entender bien, porque son las que se rompen:

**`fit_transform` en train, `transform` en test.** El escalador calcula la media y la desviación con los datos de entrenamiento, y esos mismos valores los aplica al test. Si usaras `fit_transform` en el test, estarías usando información del conjunto de prueba para preparar el modelo, y tu medición quedaría contaminada. Es un error silencioso que infla los resultados.

**`random_state=42`.** Fija el azar de la partición para que cada vez que corras el script te dé exactamente el mismo resultado. Sin esto, cada ejecución da un número distinto y no puedes comparar nada. El 42 no tiene nada de especial; cualquier número sirve mientras no lo cambies.

**Guardar el escalador junto al modelo.** Este es el error más caro de todo el curso, y lo vas a agradecer en la semana 16: si guardas solo el modelo, cuando lo cargues en producción no vas a tener con qué escalar los datos nuevos, y el modelo va a recibir números en otra escala y a responder cualquier cosa. Guarda siempre los tres: modelo, escalador y la lista de columnas en su orden.

#### La matriz de confusión

La exactitud es un solo número y esconde lo importante. La matriz de confusión te dice **qué se confunde con qué**:

```
              predicho
            mad  met  pla
  mad   [    6    0    0 ]
r met   [    0    5    1 ]
e pla   [    0    2    4 ]
a
l
```

La diagonal son los aciertos. Todo lo de fuera son errores, y ahí está la información: en este ejemplo el modelo confunde plástico con metal en dos de seis casos, y la madera la clava siempre. Eso te dice exactamente dónde trabajar.

Con 18 ejemplos de prueba, un error o dos cambian mucho la exactitud. **No te tomes demasiado en serio la tercera cifra decimal**: con este tamaño de dataset, 0.83 y 0.89 son prácticamente lo mismo. En la semana 15 vamos a medir esto de forma más seria con validación cruzada.

**Lo que entregas de este bloque**

- `codigo/entrenar.py` con el `TODO` resuelto.
- `modelo.pkl` en la raíz de tu repositorio.
- `figuras/confusion.png`.
- En `BITACORA.md`:
  1. Tu exactitud en el conjunto de prueba.
  2. Qué par de clases se confunde más, leído de la matriz de confusión.
  3. Si el resultado coincidió con lo que predijiste en la semana 6 al ver la separación de tus clases.

```bash
git add .
git commit -m "s07 bloque 2: clasificador entrenado y guardado"
git push
```

---

### Bloque extra: compara tres algoritmos {#bloque-extra}

Opcional. En vez de quedarte con el primero que probaste, mide.

```python
from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import SVC

modelos = {
    'knn_3':  KNeighborsClassifier(n_neighbors=3),
    'knn_5':  KNeighborsClassifier(n_neighbors=5),
    'arbol_3': DecisionTreeClassifier(max_depth=3, random_state=42),
    'arbol_5': DecisionTreeClassifier(max_depth=5, random_state=42),
    'svm':     SVC(kernel='rbf'),
}

for nombre, m in modelos.items():
    m.fit(X_train_esc, y_train)
    train = m.score(X_train_esc, y_train)
    test  = m.score(X_test_esc, y_test)
    print(f"{nombre:10s}  train {train:.3f}   test {test:.3f}")
```

Y aquí viene lo que de verdad hay que mirar, que no es la columna de test: **es la diferencia entre train y test**.

- Train 1.000 y test 0.61: memorizó. Eso es **sobreajuste**, y es el tema de la semana 16.
- Train 0.70 y test 0.67: el modelo es demasiado simple para el problema.
- Train 0.92 y test 0.88: sano. Este es el que te llevas.

Si usas el árbol, aprovecha que se puede leer:

```python
from sklearn.tree import export_text
print(export_text(arbol, feature_names=list(X.columns)))
```

Te imprime las reglas que aprendió. Pega esas reglas en tu bitácora y explica si tienen sentido físico. Un árbol que dice "si el rango es mayor a 80 entonces es metal" y tú sabes que el metal efectivamente refleja más, es la mejor evidencia posible de que tu sistema aprendió algo real y no ruido.

```bash
git add .
git commit -m "s07 extra: comparacion de algoritmos"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu modelo entrenado y tu matriz de confusión. La sesión es para interpretar, que es lo que va a caer en las preguntas de la revisión de la semana 9.

**1. El tablero del grupo.** Anotamos en el pizarrón la exactitud de cada quien junto a su dominio y su número de características. Aparecen patrones de inmediato: quién tiene resultados sospechosamente perfectos, quién se atoró y por qué. Un 100% con 90 ejemplos casi siempre significa fuga de información, no genialidad.

**2. Autopsia de los errores.** Cada quien toma un ejemplo que su modelo clasificó mal, lo rastrea con la columna `ventana` hasta su señal original en `datos_limpios.csv` y la grafica. La pregunta: **¿tú la habrías clasificado bien mirándola?** A veces la ventana está simplemente mala y el modelo tenía razón en dudar.

**3. Leer el árbol.** Quien haya entrenado un árbol imprime sus reglas y las traduce a lenguaje físico frente al grupo. Es el ejercicio que mejor demuestra si entendiste tu propio sistema, y es exactamente el tipo de pregunta que te voy a hacer en la revisión.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu `modelo.pkl` definitivo** con el algoritmo que hayas elegido, guardado junto con su escalador y sus columnas.

2. **Guarda la matriz de confusión** en `figuras/confusion.png`.

3. **Documenta en el `README.md`** qué algoritmo usa tu sistema, con qué parámetros y qué exactitud alcanza. Es parte de la ficha técnica del proyecto.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué algoritmo elegiste y por qué le ganó a los otros.
   - Tu exactitud en entrenamiento y en prueba, las dos. Si la diferencia es grande, dilo: en la semana 16 vamos a trabajar justo eso.
   - Qué confunde tu modelo y qué crees que lo causa.
   - Y la pregunta incómoda, contéstala en serio: **si tu resultado salió muy bueno, ¿qué evidencia tienes de que no es fuga de información?** Acuérdate de la velocidad de tu mano.

   ```bash
   git add .
   git commit -m "s07 proyecto: clasificador entrenado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Cada integrante entrena el modelo de su propio dominio. Para que la semana que viene los tres se puedan integrar en un controlador, acuerden hoy:

1. **El mismo formato de `modelo.pkl`**: un diccionario con las llaves `modelo`, `escalador` y `columnas`. Si los tres guardan igual, el controlador central los carga a todos con el mismo código.
2. **Una función común de predicción**, con la misma firma en los tres módulos: recibe una ventana cruda, devuelve la etiqueta. Esa función es la interfaz entre el módulo de cada quien y el sistema del equipo.
3. **Comparen sus exactitudes** y detecten cuál módulo es el eslabón débil. En un sistema en cascada, el módulo más flojo limita a todo el conjunto, y conviene reforzarlo entre todos antes de la revisión.
