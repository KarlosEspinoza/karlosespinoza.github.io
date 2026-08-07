---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 10 - Aprendizaje no supervisado y PCA (U3)

Tu clasificador funciona. Pero tiene un límite del que quizá no te has dado cuenta: **solo sabe de las tres piezas que le enseñaste**. Si en la banda aparece una cuarta cosa, un tornillo, un pedazo de cartón, una pieza rota, tu modelo va a responder con toda seguridad que es una de las tres, porque es lo único que sabe decir.

Esta semana empieza la Unidad 3, que se trata justamente de eso: **encontrar estructura en los datos sin que nadie te diga las respuestas**. Y arrancamos con la herramienta que se usa antes que ninguna otra cuando llegas a un conjunto de datos nuevo: el análisis de componentes principales.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: aprender sin etiquetas](#bloque-1)
    - [Bloque 2: PCA sobre tu dataset](#bloque-2)
    - [Bloque extra: cuántas componentes hacen falta](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes qué es aprender sin etiquetas y para qué sirve reducir | Tu respuesta a por qué tu sistema lo necesita |
| 2 | Aplicas PCA a tu `features.csv` | `codigo/pca.py` y `figuras/pca.png` |
| Extra | Decides cuántas componentes conservar | La curva de varianza acumulada |

Sobre tu `features.csv`. Sin hardware, toda la Unidad 3 se trabaja sobre datos.

---

### Bloque 1: aprender sin etiquetas {#bloque-1}

#### La diferencia

**Supervisado** es lo que llevas haciendo desde la semana 3: cada ejemplo trae su respuesta correcta, puesta por ti. El algoritmo aprende a reproducir esa respuesta.

**No supervisado** es entregar los datos **sin etiquetas** y preguntar: ¿qué estructura hay aquí? El algoritmo no puede acertar ni equivocarse, porque no hay respuesta correcta. Lo que hace es encontrar patrones: qué ejemplos se parecen entre sí, cuáles son raros, qué direcciones de variación existen.

| | Supervisado | No supervisado |
|---|---|---|
| Entrada | X con sus etiquetas y | Solo X |
| Pregunta | ¿De qué clase es esto? | ¿Qué estructura hay aquí? |
| Se evalúa con | Exactitud contra la verdad | No hay verdad contra qué comparar |
| En tu sistema | Clasificar las tres piezas | Detectar lo que no es ninguna de las tres |

#### Por qué tu sistema lo necesita

Tres razones concretas, y no son teóricas:

**Porque etiquetar cuesta.** Te tomó una sesión entera capturar 90 ventanas etiquetadas. En una línea de producción real hay millones de piezas y nadie las va a etiquetar a mano.

**Porque aparecen cosas que no estaban en el catálogo.** Tu banda va a recibir piezas defectuosas, pedazos, cosas que se cayeron. Ninguna tiene etiqueta porque nunca las viste. Y son justo las que más importa detectar.

**Porque el patrón puede no ser el que tú creías.** Tú dividiste tu dominio en tres clases porque a ti te pareció que eran tres. Si al agrupar los datos sin etiquetas salen cinco grupos, o dos, eso te está diciendo algo sobre tu problema que tus etiquetas escondían.

#### Por qué reducir dimensiones

Tu `features.csv` tiene, digamos, ocho columnas. Eso significa que cada ventana es un punto en un espacio de ocho dimensiones, y ahí aparecen dos problemas.

**No lo puedes ver.** Puedes graficar dos características a la vez, pero eso son solo dos de las 28 combinaciones posibles, y ninguna te enseña la estructura completa.

**El espacio se vacía.** Esta es la **maldición de la dimensionalidad**, y es menos obvia. Imagina 90 puntos repartidos en una línea: quedan bien juntitos. Los mismos 90 puntos en un cuadrado ya se ven dispersos. En un cubo, más. En ocho dimensiones, tus 90 ejemplos están tan separados unos de otros que **todos están lejos de todos**, y la noción misma de "vecino cercano" que usa k-NN empieza a perder sentido.

Además, tus características están correlacionadas: el `rango` y la `desviacion` miden casi lo mismo. Estás pagando dos dimensiones por una sola información.

#### La idea de PCA

**PCA** (*Principal Component Analysis*, análisis de componentes principales) busca **las direcciones en las que tus datos más varían**, y las usa como ejes nuevos.

```
  caracteristica 2
    ^                    . 
    |              .  .  .        <- la nube esta estirada
    |          .  . .  .             en esta direccion
    |      . . .  .
    |   .  . .                       PC1 apunta hacia alla
    +--------------------> caracteristica 1
```

Si la nube de puntos está estirada en diagonal, esa diagonal es la dirección donde hay más información. PCA la encuentra y la llama **primera componente principal (PC1)**. La segunda componente es la dirección de mayor variación restante, perpendicular a la primera. Y así.

Lo clave: **las primeras componentes suelen concentrar casi toda la variación**. Si PC1 y PC2 juntas explican el 85% de lo que varía en tus datos, puedes quedarte solo con esas dos, graficarlas en un plano, y estar viendo el 85% de la información que tenías en ocho dimensiones.

Una advertencia sobre lo que PCA no es: **las componentes no son tus características**. PC1 es una mezcla de todas ellas, algo como "0.5 por rango más 0.3 por energía menos 0.2 por duración". Por eso PCA gana en visualización y pierde en interpretación. Es un intercambio consciente.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Cuántas características tiene tu `features.csv` y por qué eso es difícil de visualizar.
2. Qué le pasaría a tu sistema actual si por la banda pasara un objeto que no es ninguna de tus tres clases. Sé concreto: ¿qué respondería tu modelo?
3. Con tus palabras, qué busca PCA.

```bash
git add .
git commit -m "s10 bloque 1: aprendizaje no supervisado"
git push
```

---

### Bloque 2: PCA sobre tu dataset {#bloque-2}

#### Estandarizar no es opcional

PCA busca direcciones de máxima varianza, y la varianza depende de la escala. Si tu `energia` vale millones y tu `duracion` vale 40, la energía se va a llevar toda la primera componente **solo porque sus números son más grandes**, no porque tenga más información.

Con PCA, estandarizar antes es obligatorio. Sin excepción.

```python
# pca.py - reduce las caracteristicas a dos componentes y las grafica
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

features = pd.read_csv('datos/features.csv')

X = features.drop(columns=['ventana', 'etiqueta'])
y = features['etiqueta']          # NO se usa para calcular el PCA, solo para colorear

X_esc = StandardScaler().fit_transform(X)

pca = PCA(n_components=2)
componentes = pca.fit_transform(X_esc)

print("Varianza explicada por cada componente:", pca.explained_variance_ratio_)
print("Varianza acumulada de las dos:", pca.explained_variance_ratio_.sum())

# TODO: grafica componentes[:,0] contra componentes[:,1],
#       un color por etiqueta, con leyenda y ejes etiquetados
#       (PC1 y PC2, con el porcentaje de varianza de cada uno)
# TODO: guarda la figura en figuras/pca.png
```

Fíjate en algo importante: **`y` no entra en el cálculo**. PCA es no supervisado, no sabe que existen tus clases. Las etiquetas se usan solo para pintar los puntos de colores **después**, y así poder juzgar el resultado. Eso es lo que hace que la gráfica sea interesante.

#### Cómo leer tu gráfica

Lo que vas a ver es una nube de puntos en dos ejes nuevos, coloreada por clase. Y hay tres lecturas posibles:

**Los colores quedan separados.** Excelente. Significa que la estructura natural de tus datos coincide con tus clases: la variación dominante de tu señal es precisamente lo que distingue tus piezas. Tu problema está bien planteado y es una gran señal para la semana 11.

**Los colores se mezclan.** No necesariamente es malo. PCA busca la dirección de mayor **varianza**, que no siempre es la de mayor **separación entre clases**. Puede pasar que lo que más varía en tus datos sea algo que no distingue las piezas, como el ruido de fondo. Tu clasificador supervisado puede seguir funcionando bien.

**Un punto solitario, lejos de todos.** Ese es un atípico, y merece que lo investigues. Rastréalo con la columna `ventana` hasta su señal original y grafícala. Suele ser una ventana mala que se te coló, y esa misma técnica es la base de la detección de anomalías de la semana 12.

#### Cuánta información conservaste

`explained_variance_ratio_` te dice qué fracción de la varianza total captura cada componente:

```
[0.62, 0.23]  ->  PC1 explica el 62%, PC2 el 23%, juntas el 85%
```

Ese 85% es la respuesta a "cuánto perdí al pasar de ocho dimensiones a dos". Perdiste el 15%. Si el número te sale bajo, digamos 45%, quiere decir que tus datos son genuinamente multidimensionales y que la gráfica en dos ejes está escondiendo bastante.

**Lo que entregas de este bloque**

- `codigo/pca.py` con los dos `TODO` resueltos.
- `figuras/pca.png` con los puntos coloreados por clase y los porcentajes en los ejes.
- En `BITACORA.md`:
  1. Qué porcentaje de varianza explican tus dos primeras componentes.
  2. Si tus clases se separan solas en el plano de PCA, y qué significa que sí o que no.
  3. Si viste algún punto atípico, cuál ventana era y qué encontraste al graficar su señal.

```bash
git add .
git commit -m "s10 bloque 2: PCA del dataset"
git push
```

---

### Bloque extra: cuántas componentes hacen falta {#bloque-extra}

Opcional. Dos componentes son buenas para graficar, pero para alimentar un modelo la pregunta es otra: **cuántas conservar para no perder casi nada**.

Calcula el PCA con todas las componentes y grafica la varianza acumulada:

```python
import numpy as np

pca_todo = PCA().fit(X_esc)
acumulada = np.cumsum(pca_todo.explained_variance_ratio_)

plt.plot(range(1, len(acumulada)+1), acumulada, marker='o')
plt.axhline(0.95, linestyle='--')
plt.xlabel('numero de componentes')
plt.ylabel('varianza acumulada')
```

El criterio habitual es quedarse con las que alcanzan el **95%**. Lee de tu gráfica cuántas son en tu caso.

Y hay un experimento que vale la pena, porque conecta las dos unidades: **reentrena tu clasificador de la semana 7 usando las componentes de PCA en vez de tus características originales**. Compara la exactitud. Pueden pasar dos cosas y las dos enseñan:

- **Igual o mejor con menos dimensiones:** tus características tenían información redundante, y PCA la compactó. Tu sistema se vuelve más rápido sin perder nada.
- **Peor:** PCA descartó una dirección que era poco variable pero muy discriminativa. Es un recordatorio de que varianza no es lo mismo que utilidad para clasificar.

```bash
git add .
git commit -m "s10 extra: componentes necesarias y clasificacion sobre PCA"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu `pca.png` hecho. La sesión es de lectura de gráficas, que es una habilidad y se entrena.

**1. La galería de PCA del grupo.** Todas las gráficas juntas. Como cada quien tiene un dominio distinto, en media hora vemos casos con clases perfectamente separadas, casos revueltos, y casos con dos clases pegadas y una aparte. Cada figura tiene una historia y la reconstruimos entre todos.

**2. Cacería de atípicos.** Quien tenga puntos solitarios los rastrea hasta su señal cruda y la enseña. Casi siempre hay una explicación concreta: la pieza se atoró, se le cayó, el sensor se movió. Es la primera vez que detectamos una anomalía en el curso, y lo hicimos sin ninguna etiqueta que dijera "anómalo". Esa es la idea completa de la Unidad 3.

**3. El experimento del intruso.** Aquí se ve el problema que vamos a resolver el resto de la unidad. Cada quien mete al `features.csv` una ventana de **un objeto que no es ninguna de sus tres clases**, sin etiqueta, y vuelve a correr el PCA. La pregunta: **¿el intruso cae fuera de las tres nubes?** Si cae fuera, ya tienes la intuición de cómo se detecta una pieza desconocida. Y de paso confirmamos lo que tu clasificador supervisado hace con ella: responder con seguridad una de las tres, que es exactamente el problema.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Captura de 5 a 10 ventanas de "piezas raras"**: objetos que no son ninguna de tus tres clases. Un tornillo, una goma, un pedazo de cartón, una de tus piezas pero rota o al revés. Guárdalas en `datos/anomalias.csv`, con el mismo formato y la etiqueta `anomalia`.

   Este archivo lo vas a usar todo el resto de la unidad. **No lo mezcles con `datos.csv`**: es un conjunto aparte.

2. **Corre tu clasificador de la semana 7 sobre esas piezas raras** y anota qué responde. Vas a ver que responde con total seguridad, y ese resultado es el que justifica todo lo que viene.

3. **Genera `figuras/pca.png` con las anomalías incluidas**, marcadas con un símbolo distinto.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué objetos usaste como piezas raras y por qué esos.
   - Qué respondió tu clasificador ante ellas.
   - Si en el plano de PCA caen fuera de tus tres grupos o se camuflan dentro de alguno. Si se camuflan, va a ser un caso difícil en la semana 12 y conviene saberlo desde ahora.

   ```bash
   git add .
   git commit -m "s10 proyecto: PCA y captura de piezas anomalas"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Una pregunta de diseño para el equipo, que conviene discutir ahora: **quién detecta las anomalías**.

Hay dos arquitecturas posibles y las dos son defendibles:

1. **Cada módulo detecta las suyas.** Cada integrante entrena su propio detector sobre su propio dominio. Es más preciso porque cada uno conoce su señal, pero triplica el trabajo.
2. **Un módulo detector para todo el sistema.** Uno solo, que mire las señales de los tres. Es menos preciso, pero es un módulo y no tres.

Discútanlo, elijan, y **anoten la razón en el README del equipo**. En la revisión de la semana 14 les voy a preguntar por qué eligieron esa y no la otra.
