---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 11 - Agrupamiento: K-Means y DBSCAN (U3)

La semana pasada viste que tus datos tienen estructura propia, y que esa estructura a veces coincide con tus etiquetas y a veces no. Pero solo la miraste. Esta semana la vas a **encontrar automáticamente**, sin decirle al algoritmo cuáles son tus clases.

Los dos algoritmos que vamos a usar son muy distintos entre sí, y esa diferencia es la clave de la semana: uno te obliga a asignar cada punto a un grupo, y el otro tiene permitido decir **"este punto no pertenece a ninguno"**. Ese permiso es exactamente lo que tu sistema necesita para detectar una pieza desconocida.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: K-Means, agrupar por cercanía](#bloque-1)
    - [Bloque 2: DBSCAN, agrupar por densidad](#bloque-2)
    - [Bloque extra: cuántos grupos hay de verdad](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes K-Means y lo comparas con tus etiquetas | La parte de K-Means de `codigo/clustering.py` |
| 2 | Aplicas DBSCAN y ves qué marca como ruido | `clustering.py` completo y su figura |
| Extra | Eliges el número de grupos con evidencia | La curva del codo o de silueta |

Sobre `features.csv` y `anomalias.csv`. Sin hardware.

---

### Bloque 1: K-Means, agrupar por cercanía {#bloque-1}

#### Qué es agrupar

**Agrupar** (*clustering*) es partir tus ejemplos en grupos de manera que los de un grupo se parezcan entre sí y se diferencien de los de otros grupos. Sin etiquetas. El algoritmo no sabe qué es madera ni metal; solo ve puntos y distancias.

#### Cómo funciona K-Means

Es un procedimiento de cuatro pasos que se repite hasta que deja de cambiar:

1. Elegir $k$ y poner $k$ centros al azar.
2. Asignar cada punto al centro que le quede más cerca.
3. Mover cada centro al promedio de los puntos que le tocaron.
4. Volver al paso 2 hasta que los centros ya no se muevan.

```
   inicio (centros al azar)      despues de converger

     x   . .  .                    . .  .
       .  . .                     . x .           <- el centro se movio
    .  .        . .              .          . .      al medio de su grupo
         x        .                       . x .
      .        . .  .                  .    .  .
```

Lo que K-Means minimiza es la suma de distancias al cuadrado de cada punto a su centro:

$$J = \sum_{j=1}^{k} \sum_{x \in C_j} \|x - \mu_j\|^2$$

donde $C_j$ es el grupo $j$, $\mu_j$ su centro y $\|x - \mu_j\|$ la distancia del punto a su centro.

#### Sus tres limitaciones

Conviene tenerlas claras porque explican los resultados raros:

**Hay que decirle $k$.** El algoritmo no descubre cuántos grupos hay: tú se lo impones. Si le pides cuatro grupos a unos datos que tienen tres, va a partir uno en dos sin avisarte.

**Todo punto acaba en un grupo.** No existe "ninguno". Una pieza rarísima va a ser asignada al grupo menos malo, exactamente el mismo problema que tiene tu clasificador supervisado. Por eso K-Means solo no sirve para detectar anomalías.

**Prefiere grupos redondos y del mismo tamaño.** Si tus clases forman nubes alargadas o una rodea a otra, K-Means las va a cortar mal, porque solo sabe medir distancia a un centro.

#### Comparar los grupos con tus etiquetas

Aquí está lo interesante del ejercicio. Corres K-Means con $k=3$ **sin darle las etiquetas**, y después comparas los grupos que encontró con las clases que tú sabías.

```python
# clustering.py - agrupa el dataset sin usar las etiquetas
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans

features = pd.read_csv('datos/features.csv')

X = features.drop(columns=['ventana', 'etiqueta'])
y = features['etiqueta']            # solo para comparar al final

X_esc = StandardScaler().fit_transform(X)

kmeans = KMeans(n_clusters=3, n_init=10, random_state=42)
grupos = kmeans.fit_predict(X_esc)

# la tabla que compara lo que encontro con lo que era
print(pd.crosstab(y, grupos))

# TODO: grafica los datos en el plano de PCA de la semana pasada,
#       coloreando por GRUPO en vez de por etiqueta, y guardala
#       en figuras/clustering.png
```

La tabla cruzada es la evidencia de la semana:

```
grupo        0   1   2
etiqueta
madera      28   2   0
metal        1  27   2
plastico     0   3  27
```

Léela así: **si cada fila tiene casi todo su peso en una sola columna, K-Means encontró tus clases por su cuenta**. Es un resultado fuerte: significa que tus tres tipos de pieza son grupos naturales en tus datos, no una división arbitraria que tú inventaste.

Si en cambio te sale algo como esto:

```
grupo        0   1   2
etiqueta
madera      15  15   0
metal       14  16   0
plastico     0   0  30
```

Lo que te está diciendo es que **plástico es genuinamente distinto**, pero que madera y metal no se distinguen entre sí con tus características, y que la división que K-Means encontró en ellas es otra cosa (a lo mejor las capturadas al principio contra las del final de la sesión). Eso es información valiosísima que tus etiquetas te estaban ocultando.

Un detalle: **los números de los grupos no significan nada**. El grupo 0 no es "madera"; es solo el primer centro que le tocó. Compara la estructura de la tabla, no los números.

**Lo que entregas de este bloque**

- La parte de K-Means de `codigo/clustering.py`, con su `TODO` resuelto.
- En `BITACORA.md`, bajo `### Antes de la clase`:
  1. Tu tabla cruzada, pegada tal cual.
  2. Si K-Means encontró tus clases o no, y qué te dice eso de tu problema.
  3. Si no las encontró: ¿qué crees que separó en su lugar?

```bash
git add .
git commit -m "s11 bloque 1: K-Means y comparacion con las etiquetas"
git push
```

---

### Bloque 2: DBSCAN, agrupar por densidad {#bloque-2}

#### Otra manera de pensar un grupo

K-Means piensa un grupo como "los puntos cercanos a un centro". DBSCAN lo piensa distinto: **un grupo es una región donde los puntos están apretados**, y lo que separa a dos grupos es el vacío entre ellos.

Ese cambio de definición trae la consecuencia que nos interesa: **un punto que está en una zona vacía no pertenece a ningún grupo**. DBSCAN lo etiqueta como **ruido**, con el valor `-1`.

Eso es una detección de anomalías, y salió sola de la definición.

#### Los dos parámetros

**`eps`**: el radio de vecindad. Qué tan cerca tienen que estar dos puntos para considerarse vecinos.

**`min_samples`**: cuántos vecinos necesita un punto dentro de ese radio para contar como parte de una zona densa.

Con esos dos, cada punto cae en una de tres categorías:

- **Núcleo:** tiene al menos `min_samples` vecinos dentro de `eps`. Está en el corazón de un grupo.
- **Frontera:** tiene pocos vecinos, pero está dentro del radio de un punto núcleo. Está en la orilla del grupo.
- **Ruido:** ni una cosa ni la otra. **Es tu anomalía.**

```
      . . . .
     . . . . .          <- zona densa: grupo 0
      . . . .
                              .        <- ruido (-1)
          . . .
         . . . .        <- zona densa: grupo 1
          . . .
```

#### Elegir eps

Es la parte delicada, porque el resultado depende muchísimo de ese número:

- **`eps` muy chico:** casi todo es ruido. DBSCAN no encuentra ninguna zona lo bastante densa.
- **`eps` muy grande:** todo es un solo grupo gigante y no hay ruido.

Como trabajas sobre datos estandarizados, un buen punto de partida es entre 0.5 y 1.5. **Pruébalo y mira cuánto ruido marca.** Si tu dataset son 90 ventanas capturadas con cuidado, un `eps` razonable debería marcar como ruido unas pocas, no la mitad.

```python
from sklearn.cluster import DBSCAN

dbscan = DBSCAN(eps=0.8, min_samples=5)
grupos_db = dbscan.fit_predict(X_esc)

n_grupos = len(set(grupos_db)) - (1 if -1 in grupos_db else 0)
n_ruido  = list(grupos_db).count(-1)

print(f"Grupos encontrados: {n_grupos}")
print(f"Puntos marcados como ruido: {n_ruido}")

# TODO: prueba al menos cuatro valores de eps y arma una tabla
#       eps | grupos encontrados | puntos de ruido

# TODO: cuando tengas tu eps elegido, grafica en el plano de PCA
#       marcando los puntos de ruido con un simbolo distinto
```

Y fíjate en algo que K-Means no puede hacer: **DBSCAN te dice cuántos grupos hay**. No se lo dijiste tú. Si tus datos tienen tres grupos naturales bien separados, DBSCAN encuentra tres. Si encuentra dos, es porque dos de tus clases están pegadas.

#### La prueba de fuego

Aquí es donde esta semana se vuelve útil para tu proyecto. Junta tu `features.csv` normal con las características de tus piezas raras de `anomalias.csv`, corre DBSCAN sobre todo junto, y responde:

**¿DBSCAN marcó tus piezas raras como ruido?**

```python
# TODO: carga anomalias.csv, calcula sus caracteristicas con el mismo features.py,
#       pegalas debajo de las normales y corre DBSCAN sobre el conjunto completo.
#       Luego cuenta cuantas de las raras quedaron con grupo -1.
```

Si las marcó, acabas de construir tu primer detector de anomalías, sin haberle enseñado ni una sola anomalía. Si no las marcó, no pasa nada: significa que tus piezas raras se parecen demasiado a las normales en el espacio de tus características, y eso es justo el problema que ataca el autoencoder de la semana 12.

**Lo que entregas de este bloque**

- `codigo/clustering.py` completo, con los tres `TODO` resueltos.
- `figuras/clustering.png` con los grupos de DBSCAN y el ruido marcado.
- En `BITACORA.md`:
  1. Tu tabla de `eps` contra grupos y ruido, y qué valor elegiste.
  2. Cuántos grupos encontró DBSCAN sin que se lo dijeras, y si coincide con tus tres clases.
  3. Cuántas de tus piezas raras quedaron marcadas como ruido. Este número es el resultado principal de la semana.

```bash
git add .
git commit -m "s11 bloque 2: DBSCAN y deteccion de ruido"
git push
```

---

### Bloque extra: cuántos grupos hay de verdad {#bloque-extra}

Opcional. En el bloque 1 le dijiste a K-Means que buscara tres grupos porque tú tienes tres clases. Pero, ¿y si tus datos tienen dos, o cinco?

**El método del codo.** Corre K-Means con $k$ de 1 a 8 y grafica la inercia (la suma de distancias al cuadrado, que es el `J` de la fórmula de arriba):

```python
inercias = []
for k in range(1, 9):
    km = KMeans(n_clusters=k, n_init=10, random_state=42).fit(X_esc)
    inercias.append(km.inertia_)

plt.plot(range(1, 9), inercias, marker='o')
plt.xlabel('k'); plt.ylabel('inercia')
```

La inercia siempre baja al aumentar $k$ (con $k$ = número de puntos, es cero). Lo que se busca es el **codo**: el punto donde deja de bajar bruscamente y empieza a bajar despacio. Ahí está el número natural de grupos.

**El coeficiente de silueta.** Más objetivo, porque tiene un máximo claro. Mide, para cada punto, qué tan cerca está de su propio grupo comparado con el grupo vecino más cercano. Va de -1 a 1, y más alto es mejor.

```python
from sklearn.metrics import silhouette_score

for k in range(2, 9):
    km = KMeans(n_clusters=k, n_init=10, random_state=42).fit(X_esc)
    print(k, silhouette_score(X_esc, km.labels_))
```

Y la pregunta que hay que responder en la bitácora: **si el mejor $k$ no es 3, ¿qué significa eso para tu problema?** Puede querer decir que dos de tus clases son en realidad la misma para tu sensor, o que una de ellas tiene dos variantes que tú tratabas como una. Las dos son conclusiones interesantes y bien fundadas.

```bash
git add .
git commit -m "s11 extra: numero natural de grupos"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu tabla cruzada y tu DBSCAN corrido. La sesión es de interpretación.

**1. El tablero de tablas cruzadas.** Cada quien enseña la suya. Separamos al grupo en dos: a quienes K-Means les encontró sus clases y a quienes no. Y reconstruimos por qué. Casi siempre la diferencia está en la calidad de la separación que ya se veía en la semana 5, y eso cierra el arco: las decisiones de la Unidad 2 se pagan aquí.

**2. Torneo de eps.** Comparamos qué valor eligió cada quien y cuánto ruido marcó. Se ve muy claro el efecto del parámetro y por qué no hay un valor universal.

**3. El marcador de anomalías.** Anotamos en el pizarrón, por alumno, **cuántas de sus piezas raras detectó DBSCAN**. Ese número, de cero a diez, es el punto de partida de la semana 12, y lo vamos a comparar con lo que consiga el autoencoder. A quien le haya salido bajo no le fue mal: tiene el caso difícil, que es el más interesante.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja `codigo/clustering.py` funcionando** con K-Means y DBSCAN.

2. **Guarda la figura comparativa** en `figuras/clustering.png`: el mismo plano de PCA tres veces, coloreado por etiqueta real, por grupo de K-Means y por grupo de DBSCAN. Puestas lado a lado se lee de un vistazo qué encontró cada método.

3. **Anota tu tasa de detección**: de tus N piezas raras, cuántas marcó DBSCAN como ruido. Es tu línea base para la semana que viene.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Si la estructura natural de tus datos coincide con tus etiquetas.
   - Tu `eps` elegido y cómo lo elegiste.
   - Tu tasa de detección de piezas raras con DBSCAN.
   - Y una reflexión que quiero leer: **¿qué te enseñó el agrupamiento sobre tu problema que las etiquetas no te habían dicho?**

   ```bash
   git add .
   git commit -m "s11 proyecto: agrupamiento y linea base de deteccion"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Corran el agrupamiento **sobre los datos de los tres módulos juntos**, en un solo espacio de características.

Es un experimento revelador: si al agrupar todo aparecen tres grandes grupos que corresponden a los tres dominios, quiere decir que los módulos están midiendo cosas muy distintas y que integrarlos es sumar información. Si en cambio los datos de dos módulos se revuelven, esos dos están midiendo casi lo mismo y el sistema integrado no gana tanto como creían.

Sea cual sea el resultado, es material directo para la revisión de la semana 14. Anótenlo en el README del equipo con la figura.
