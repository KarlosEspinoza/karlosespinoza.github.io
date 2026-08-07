---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 5 - Características en el dominio del tiempo (U2)

Tu dataset limpio tiene, digamos, 90 ventanas de 200 muestras cada una. Eso son 18000 números. Y aquí aparece un problema que no es obvio: **no puedes darle eso a un clasificador tal cual**.

Esta semana haces la traducción que hace posible todo lo demás: convertir cada ventana de 200 números en apenas media docena de números que la describan. Se llaman **características**, o *features*, y son el idioma en el que le vas a hablar a tu modelo.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: por qué una ventana no le sirve al modelo](#bloque-1)
    - [Bloque 2: features.py y la tabla final](#bloque-2)
    - [Bloque extra: inventa una característica de tu dominio](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes qué es una característica y cuáles vamos a usar | Tu lista de features con su justificación |
| 2 | Escribes `features.py` y generas la tabla final | `codigo/features.py` y `datos/features.csv` |
| Extra | Inventas una característica propia de tu dominio | La feature nueva y su gráfica |

Todo sobre tu `datos_limpios.csv`. Sin hardware.

---

### Bloque 1: por qué una ventana no le sirve al modelo {#bloque-1}

#### Tres problemas de darle la ventana completa

**Las ventanas no miden todas lo mismo.** Aunque hayas fijado `N_MUESTRAS`, si en el bloque extra de la semana 3 hiciste detección automática, unas ventanas salen de 180 y otras de 230. Un clasificador necesita que **todos los ejemplos tengan exactamente el mismo número de entradas**. No admite filas de largo variable.

**Son demasiados números para tan pocos ejemplos.** Tienes 90 ejemplos y cada uno con 200 valores. En aprendizaje de máquina eso es una receta conocida para el desastre: con muchas más dimensiones que ejemplos, cualquier modelo encuentra una manera de separar perfectamente tus datos de entrenamiento y falla con todo lo demás. Es la **maldición de la dimensionalidad**, y volvemos a ella en la semana 10.

**La información está repetida.** La muestra 100 y la 101 valen casi lo mismo. De tus 200 números, la mayoría no aportan nada nuevo.

#### Qué es una característica

Una característica es **un número que resume algo de la ventana**. Por ejemplo: "qué tan profundo fue el valle". Un solo número, calculado a partir de las 200 muestras, que captura algo relevante de la forma.

El cambio de mentalidad es este:

```
ANTES:  una ventana = 200 numeros en el tiempo
DESPUES: una ventana = 6 numeros que la describen
```

Y la tabla del modelo queda así, con **una fila por ventana**:

| ventana | media | desv | minimo | maximo | rango | duracion | etiqueta |
|---|---|---|---|---|---|---|---|
| 0 | -12.4 | 18.2 | -61.0 | 3.1 | 64.1 | 38 | madera |
| 1 | -30.1 | 27.6 | -98.4 | 2.8 | 101.2 | 41 | metal |
| 2 | -11.9 | 17.4 | -58.2 | 4.0 | 62.2 | 36 | madera |

Eso es lo que come un clasificador: filas del mismo largo, cada una con su etiqueta.

#### Las características del dominio del tiempo

Se llaman así porque se calculan directo sobre la señal tal como ocurre en el tiempo. En la semana 6 veremos las de frecuencia, que son otra manera de mirar lo mismo.

**Media.** El promedio de la ventana. Después de corregir la línea base, te dice qué tanto en promedio se desvió la señal.

$$\mu = \frac{1}{n}\sum_{i=1}^{n} x_i$$

**Desviación estándar.** Cuánto varía la señal dentro de la ventana. Un evento marcado da desviación alta; una ventana casi plana, baja.

$$\sigma = \sqrt{\frac{1}{n}\sum_{i=1}^{n}(x_i - \mu)^2}$$

**Mínimo y máximo.** Los extremos. En una señal donde la pieza produce un valle, el mínimo es prácticamente "qué tan fuerte fue el evento".

**Rango.** La diferencia entre los dos, $x_{max} - x_{min}$. Suele ser de las más útiles porque no le afecta la línea base.

**Energía.** La suma de los cuadrados. Combina qué tan grande fue la desviación y cuánto duró.

$$E = \sum_{i=1}^{n} x_i^2$$

**Duración del evento.** Cuántas muestras estuvo la señal fuera de la zona de reposo. Necesitas un umbral para definir "fuera".

En todas: $n$ es el número de muestras de la ventana y $x_i$ la muestra $i$ ya limpia y con la línea base corregida.

#### Cuáles elegir

No las eches todas por si acaso. Cada característica que agregas es una dimensión más, y ya vimos que las dimensiones cuestan. La pregunta que hay que hacerse con cada una es: **¿esta debería ser distinta entre mis tres clases?**

Y aquí es donde tu proyecto se separa del de tus compañeros. Si clasificas por tamaño, la **duración** es tu mejor apuesta: una pieza más larga tapa el sensor más tiempo. Si clasificas por material con un sensor óptico, el **mínimo** es la clave: cada material refleja distinto. Si clasificas por estado (buena, marcada, deforme), la **desviación estándar** puede ser la que distinga, porque una superficie irregular hace una señal más quebrada.

Empieza con cinco o seis y justifica cada una en función de **tu** dominio. En la semana 15 vamos a poder medir cuáles sirvieron de verdad.

Y una advertencia que enlaza con lo que hablamos en la semana 3: si moviste la pieza a distinta velocidad según la clase, **la duración va a ser una característica maravillosa por la razón equivocada**. Si tu clasificador de la semana 7 acierta casi todo apoyándose en la duración, y tu dominio no es de tamaño, sospecha de tu mano antes de celebrar.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`, una tabla con las características que vas a calcular:

| Característica | Por qué debería distinguir mis clases |
|---|---|
| ... | ... |

Y una predicción escrita: **cuál crees que va a ser la mejor y cuál la más inútil**. En la semana 15 vamos a volver a leer esta predicción.

```bash
git add .
git commit -m "s05 bloque 1: seleccion de caracteristicas"
git push
```

---

### Bloque 2: features.py y la tabla final {#bloque-2}

#### El patrón: agrupar y resumir

Todo el script es una idea de pandas: agrupar por ventana y calcular un resumen de cada grupo.

```python
# features.py - convierte cada ventana en una fila de caracteristicas
import pandas as pd
import numpy as np

datos = pd.read_csv('datos/datos_limpios.csv')

filas = []

for ventana, g in datos.groupby('ventana'):
    x = g['valor'].values          # las muestras de esta ventana, como arreglo
    etiqueta = g['etiqueta'].iloc[0]

    fila = {
        'ventana':  ventana,
        'media':    x.mean(),
        'desv':     x.std(),
        'minimo':   x.min(),
        'maximo':   x.max(),
        'rango':    x.max() - x.min(),
        'energia':  np.sum(x**2),
        'etiqueta': etiqueta,
    }
    filas.append(fila)

features = pd.DataFrame(filas)

# TODO: agrega la duracion del evento
#       cuantas muestras tienen |valor| por encima de tu umbral
#       pista: np.sum(np.abs(x) > UMBRAL)

# TODO: quita del diccionario las caracteristicas que decidiste no usar

# TODO: guarda features en datos/features.csv (sin el indice de pandas)

print(features.head())
print(features.groupby('etiqueta').size())
```

Fíjate en un detalle: la columna `ventana` la conservamos aunque el modelo no la vaya a usar. Sirve para rastrear un ejemplo raro de vuelta a la señal que lo produjo, y en la semana 7 lo vas a necesitar.

#### La gráfica que decide tu semestre

Con `features.csv` listo, hay una figura que tienes que hacer antes de seguir: un **diagrama de dispersión** de dos características, con un color por clase.

```python
import matplotlib.pyplot as plt

for etiqueta, g in features.groupby('etiqueta'):
    plt.scatter(g['rango'], g['duracion'], label=etiqueta)

plt.xlabel('rango')
plt.ylabel('duracion')
plt.legend()
plt.savefig('figuras/features.png')
```

Cada punto es una pasada de una pieza. Y lo que vas a ver es una de tres cosas:

**Tres nubes bien separadas.** Tu clasificador de la semana 7 va a funcionar. De hecho, con nubes así de separadas casi cualquier algoritmo sirve.

**Nubes que se tocan en los bordes.** Es lo normal y está bien. Ahí es donde el modelo aporta algo: encuentra la frontera mejor de lo que tú la trazarías a ojo.

**Nubes encimadas por completo.** Malas noticias, pero es mucho mejor enterarte hoy. Con **estas dos** características no se pueden separar. Prueba otro par antes de asustarte, porque a lo mejor con otras dos sí se separan. Si ningún par funciona, el problema no son las features: es la señal, y hay que agregar un segundo sensor.

Prueba al menos tres pares distintos de características antes de sacar conclusiones.

**Lo que entregas de este bloque**

- `codigo/features.py` con los tres `TODO` resueltos.
- `datos/features.csv`, una fila por ventana.
- `figuras/features.png` con al menos un diagrama de dispersión coloreado por clase.
- En `BITACORA.md`:
  1. Cuántas filas y cuántas columnas quedó tu `features.csv`, y por qué ese número de filas.
  2. Qué par de características separa mejor tus clases, con la gráfica que lo muestra.
  3. Si hay dos clases que se encimen, cuáles y qué vas a hacer.

```bash
git add .
git commit -m "s05 bloque 2: features.py y tabla de caracteristicas"
git push
```

---

### Bloque extra: inventa una característica de tu dominio {#bloque-extra}

Opcional. Las seis características de arriba son genéricas: sirven para cualquier señal. Las que de verdad ganan competencias son las que alguien inventó porque **conocía el problema**.

Mira tus tres formas promedio de la semana 4 y pregúntate: ¿qué distingue a estas curvas que ninguna de mis seis características está capturando?

Algunas ideas, según lo que veas:

- **Asimetría del evento.** ¿Baja rápido y sube lento, o al revés? Se mide comparando la posición del mínimo con el centro de la ventana.
- **Pendiente máxima.** Qué tan brusco es el flanco de entrada. En numpy es `np.max(np.abs(np.diff(x)))`.
- **Número de cruces.** Cuántas veces la señal cruza cierto nivel. Distingue un evento limpio de uno con rebotes.
- **Área del evento.** La integral de la parte que está fuera del reposo. Junta profundidad y duración en un número.

Elige una, impleméntala, agrégala a `features.py` y grafícala contra la que ya tenías como mejor. Si tu característica inventada separa las clases mejor que las genéricas, la acabas de ganar limpio, y eso se nota en tu revisión de avances.

```bash
git add .
git commit -m "s05 extra: caracteristica propia del dominio"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu `features.csv` generado y tus diagramas de dispersión hechos. La sesión es de análisis, y es la última oportunidad barata de corregir el rumbo antes de entrenar.

**1. La matriz de dispersión.** Graficamos todos los pares de características de golpe con `pandas.plotting.scatter_matrix`, coloreando por clase. En una sola figura ves qué par separa mejor y cuáles características son redundantes entre sí (las que se ven como una diagonal perfecta miden lo mismo y una sobra).

**2. El diagnóstico en voz alta.** Cada quien enseña su mejor dispersión y el grupo dice qué ve. Es más útil de lo que suena: uno se acostumbra a sus propias gráficas y deja de notar lo que tienen de raro.

**3. Los tres casos y qué hacer con cada uno.** Separamos al grupo en quienes tienen clases bien separadas, quienes las tienen tocándose y quienes las tienen encimadas. El tercer grupo se lleva un plan concreto para la semana: agregar un segundo sensor, cambiar de sensor, o redefinir qué tres tipos de pieza va a clasificar. Cualquiera de las tres es una decisión legítima de ingeniería y así se documenta en la bitácora.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Genera tu `datos/features.csv` definitivo**, con las características que hayas decidido después de la clase.

2. **Guarda la matriz de dispersión completa** en `figuras/scatter_matrix.png`.

3. **Si tus clases se encimaban**, ejecuta el plan que acordamos: monta el segundo sensor, recaptura y vuelve a correr toda tu cadena (`adquirir.py` -> `limpiar.py` -> `features.py`). Sí, es rehacer trabajo. Es más barato ahora que en la semana 8.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué características te quedaste y cuáles descartaste, con la razón.
   - Cuál separa mejor tus clases y si coincidió con lo que predijiste en el bloque 1.
   - Si tuviste que recapturar, qué cambiaste y qué mejoró.

   ```bash
   git add .
   git commit -m "s05 proyecto: caracteristicas de tiempo extraidas"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Ahora que cada quien tiene su `features.csv`, aparece el primer problema real de integración: **los tres módulos tienen columnas distintas**.

No las igualen a la fuerza: cada dominio necesita las suyas, y forzar a los tres a usar las mismas empeoraría los tres. Lo que sí hay que acordar es:

1. **Que las columnas de control se llamen igual** (`ventana`, `etiqueta`) para que el código de carga sea el mismo.
2. **Que cada módulo tenga su propio modelo**, no uno compartido. El controlador central de la semana 8 va a preguntarle a cada modelo por separado y juntar las respuestas.
3. **Anoten en el README del equipo la lista de características de cada módulo.** En la revisión de la semana 9 les voy a preguntar por qué cada uno eligió las suyas.
