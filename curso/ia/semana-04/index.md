---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 4 - Limpieza y normalización de señales (U2)

Ya tienes tu dataset. Si lo graficaste con cuidado, seguramente notaste que las ventanas de una misma clase no salen idénticas: unas están más arriba, otras tiemblan más, alguna tiene un pico rarísimo que no corresponde a nada.

Esta semana no agregas funcionalidad nueva a tu sistema. Le quitas basura. Y aunque suene menos emocionante que entrenar un modelo, es lo que decide si tu clasificador de la semana 7 va a servir. Un modelo entrenado con señales sucias aprende el ruido, y el ruido no se repite.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: el ruido y cómo se quita](#bloque-1)
    - [Bloque 2: poner todas las ventanas en la misma escala](#bloque-2)
    - [Bloque extra: elegir el filtro con evidencia](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes de dónde viene el ruido y filtras tu señal | La parte del filtro de `codigo/limpiar.py` |
| 2 | Corriges la línea base y normalizas | `limpiar.py` completo y `datos/datos_limpios.csv` |
| Extra | Comparas tamaños de filtro y eliges con evidencia | Una gráfica comparativa y tu decisión |

**Buena noticia: a partir de esta semana ya no necesitas el Arduino ni para el lunes ni para trabajar en casa.** Todo se hace sobre el `datos.csv` que capturaste, que ya está en tu repositorio. El hardware vuelve a hacer falta hasta la semana 8.

---

### Bloque 1: el ruido y cómo se quita {#bloque-1}

#### De dónde sale lo que sobra

Tu señal no es solo la pieza. Es la pieza más todo lo demás que el sensor alcanzó a captar. Vale la pena distinguir tres cosas, porque no se tratan igual:

**Ruido.** Variación pequeña y rápida que aparece en todas las lecturas. Viene del cable, de la fuente de alimentación, del motor que está cerca, de la luz fluorescente que parpadea a 120 Hz. Se ve como si la línea vibrara. Se quita con un filtro.

**Valores atípicos.** Lecturas sueltas absurdas: un 0 o un 1023 en medio de una señal que ronda 500. Suelen venir de un cable flojo o de una interferencia de un instante. No se filtran, se detectan y se quitan.

**Deriva.** El valor de reposo que se va moviendo lentamente a lo largo de la sesión: el LDR lee distinto a las 9 que a las 11 porque entró más luz por la ventana. No es ruido y no se quita filtrando: se corrige por ventana, y eso lo vemos en el bloque 2.

#### El filtro de media móvil

Es el filtro más simple que existe y para lo que necesitamos es suficiente. La idea: cada valor se reemplaza por el promedio de él y sus vecinos.

$$y_i = \frac{1}{k} \sum_{j=0}^{k-1} x_{i-j}$$

donde:

- $x_i$ es la muestra original en la posición $i$
- $y_i$ es la muestra ya filtrada
- $k$ es el **tamaño de la ventana del filtro**, cuántas muestras se promedian

Cuidado con la palabra ventana, que aquí significa otra cosa: la ventana del filtro son unas pocas muestras vecinas ($k$ = 5, por ejemplo), no la ventana del evento completo que son 200.

Funciona porque el ruido es aleatorio: sube y baja sin patrón, así que al promediar se cancela solo. La señal verdadera cambia despacio y sobrevive al promedio casi intacta.

En pandas es una línea:

```python
valores_filtrados = valores.rolling(window=5, center=True).mean()
```

`center=True` centra el promedio en la muestra en vez de tomar solo las anteriores, para que la señal no se recorra en el tiempo.

#### Lo que el filtro te cobra

Ningún filtro es gratis, y esto es lo que hay que entender:

**Aplana los picos.** Si tu evento es un valle angosto y profundo, promediar lo hace menos profundo. Con $k$ grande puedes borrar exactamente la característica que distinguía tus clases.

**Come muestras en las orillas.** Con `center=True` y $k=5$, las primeras y últimas dos muestras quedan como `NaN`, porque no tienen suficientes vecinos. Hay que decidir qué hacer con ellas: quitarlas o rellenarlas.

La regla práctica: **$k$ debe ser mucho más chico que la duración de tu evento**. Si tu evento dura 40 muestras, un $k$ de 5 lo suaviza sin deformarlo; un $k$ de 30 te lo destruye. Empieza con 5 y compara.

#### Los valores atípicos

Un promedio móvil no borra un valor absurdo, lo reparte entre sus vecinos: en vez de un pico feo tienes cinco muestras contaminadas. Los atípicos se quitan **antes** de filtrar.

Para tu caso lo más simple funciona: sabes el rango físico de tu sensor, así que todo lo que quede fuera es imposible y se descarta.

```python
# el analogRead de un Arduino no puede dar nada fuera de 0 a 1023
datos = datos[(datos['valor'] >= 0) & (datos['valor'] <= 1023)]
```

Si tu sensor da distancia en centímetros y de repente aparece un 900, tampoco es real. Ajusta los límites a lo que tu sensor puede medir de verdad.

**Lo que entregas de este bloque**

Empieza `codigo/limpiar.py`. Esta parte la escribes tú, con lo que ya sabes de pandas de cursos anteriores:

```python
# limpiar.py - quita ruido y normaliza el dataset
import pandas as pd

datos = pd.read_csv('datos/datos.csv')

# TODO: quita los valores fuera del rango fisico de tu sensor

# TODO: aplica el filtro de media movil a la columna 'valor',
#       ventana por ventana (no a toda la columna de un jalon:
#       eso mezclaria el final de una ventana con el inicio de la siguiente)
#       pista: datos.groupby('ventana')['valor'].transform(...)

# TODO: decide que hacer con los NaN de las orillas
```

Ojo con el segundo `TODO`, que es el error clásico de la semana: si filtras la columna completa de un solo golpe, las últimas muestras de la ventana 0 se promedian con las primeras de la ventana 1, que son de otra pasada y a lo mejor de otra clase. Hay que filtrar **dentro de cada ventana**.

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Qué tipo de ruido ves en tu señal y de dónde crees que viene.
2. Qué rango físico tiene tu sensor y qué valores estás descartando por imposibles.
3. Qué tamaño de filtro elegiste y por qué, en relación con la duración de tu evento.

```bash
git add .
git commit -m "s04 bloque 1: filtrado y valores atipicos"
git push
```

---

### Bloque 2: poner todas las ventanas en la misma escala {#bloque-2}

Ya tienes la señal sin ruido. Falta el problema de la deriva, y es el que más te va a ayudar.

#### El problema de la línea base

Grafica dos ventanas de la misma clase, una capturada al principio de la sesión y otra al final. Lo más probable es que tengan la misma forma pero a distinta altura, porque el valor de reposo se movió.

Para tu modelo eso es un desastre: dos ejemplos de la misma clase le llegan como números completamente distintos. Y al revés, una ventana de madera al final de la sesión puede parecerse más a una de metal del principio que a las de su propia clase.

La solución es **corregir la línea base**: a cada ventana se le resta su propio valor de reposo.

$$x'_i = x_i - b$$

donde:

- $x_i$ es la muestra filtrada
- $b$ es la **línea base** de esa ventana, su valor de reposo
- $x'_i$ es la muestra corregida

¿Y cómo se calcula $b$? Con las primeras muestras de la ventana, las de antes de que la pieza apareciera:

```python
# la linea base de cada ventana: promedio de sus primeras 20 muestras
base = datos[datos['t'] < 20].groupby('ventana')['valor'].mean()
```

Después de esto, todas tus ventanas arrancan cerca de cero y lo que queda es **la desviación que causó la pieza**, que es justo lo que quieres medir. Es probablemente el paso que más mejora tu clasificador en todo el semestre.

Esto también es la razón por la que en la semana 2 insistimos en que la ventana empezara antes del evento. Si tu ventana arranca justo cuando la pieza ya está encima, no tienes de dónde sacar la línea base.

#### Normalizar

Corregir la línea base pone todas las ventanas a arrancar de cero, pero no iguala sus alturas. Y hay un caso donde eso importa mucho: **cuando tienes más de un sensor**.

Imagina que el primero da valores de 0 a 1023 y el segundo temperaturas de 20 a 30. Para varios algoritmos, el primero pesa cien veces más que el segundo, no porque sea más informativo sino porque sus números son más grandes. Normalizar arregla eso.

Hay dos formas estándar:

**Min-max**, que lleva todo al rango de 0 a 1:

$$x' = \frac{x - x_{min}}{x_{max} - x_{min}}$$

donde $x_{min}$ y $x_{max}$ son el mínimo y el máximo de esa columna.

**Estandarización (z-score)**, que deja media 0 y desviación 1:

$$z = \frac{x - \mu}{\sigma}$$

donde $\mu$ es la media de la columna y $\sigma$ su desviación estándar.

Cuál usar: **min-max** cuando conoces bien los límites físicos de tu sensor y no hay atípicos (que la aplastarían toda). **Z-score** cuando hay atípicos o no sabes los límites. Para este curso, con un solo sensor y la línea base ya corregida, cualquiera sirve; lo importante es que sepas justificar la que elegiste.

Y una advertencia para la que todavía no tienes contexto pero que vas a agradecer: **los valores de $x_{min}$, $x_{max}$, $\mu$ y $\sigma$ que uses se guardan**, porque en producción vas a tener que aplicar exactamente los mismos. Volvemos a esto en la semana 16, que es donde se rompe si no lo hiciste bien.

**Lo que entregas de este bloque**

- `codigo/limpiar.py` completo, generando `datos/datos_limpios.csv` con las mismas columnas que `datos.csv`.
- Una figura `figuras/limpieza.png` con la misma ventana antes y después de limpiar, para que se vea qué cambió.
- En `BITACORA.md`:
  1. Cuánto se movió tu línea base entre la primera y la última ventana de la sesión.
  2. Qué normalización elegiste y por qué.
  3. Al comparar antes y después: ¿se parecen más entre sí las ventanas de una misma clase?

```bash
git add .
git commit -m "s04 bloque 2: linea base y normalizacion"
git push
```

---

### Bloque extra: elegir el filtro con evidencia {#bloque-extra}

Opcional. En el bloque 1 elegiste un tamaño de filtro con una regla práctica. Aquí lo eliges con datos.

Toma una ventana representativa y grafícala con cuatro filtros distintos en la misma figura: sin filtro, $k=3$, $k=9$ y $k=25$.

```python
for k in [1, 3, 9, 25]:
    suave = ventana['valor'].rolling(window=k, center=True).mean()
    plt.plot(suave, label=f'k = {k}')
plt.legend()
```

Y responde con la gráfica enfrente: a partir de qué $k$ empieza a deformarse la forma del evento, y cuál es el más grande que todavía la conserva. Ese es tu filtro.

Si quieres ir más lejos, mide en vez de mirar: calcula la profundidad del valle (o la altura del pico) para cada $k$ y grafica cómo se va perdiendo. Ahí se ve de golpe el compromiso entre suavizar y deformar.

```bash
git add .
git commit -m "s04 extra: comparacion de tamaños de filtro"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con `limpiar.py` funcionando y tu `datos_limpios.csv` generado. La sesión es para mirar los datos en serio, que es algo que casi nadie hace y que es donde aparecen los problemas.

**1. La galería de ventanas.** Graficas todas tus ventanas de una clase encimadas, en gris claro, y encima el promedio de todas en negro. Esa figura te dice de un vistazo cuánto varían tus ejemplos dentro de una misma clase. Si varían muchísimo, algo pasó en la captura.

**2. Cazar la ventana mala.** En toda captura hay dos o tres pasadas que salieron mal: se te resbaló la pieza, la moviste al revés, se te olvidó cambiarla. Hoy las buscamos y decidimos qué hacer con ellas. La regla: **se puede quitar una ventana mala, pero se anota en la bitácora cuál y por qué**. Quitar datos sin dejar registro es como se fabrican resultados falsos.

**3. La comparación que importa.** Las tres clases, con su promedio y su banda de variación, en una sola figura. La pregunta: **¿las bandas de dos clases se traslapan por completo?** Si sí, ningún modelo va a poder separarlas con esta señal, y es mejor saberlo hoy que en la semana 7. La salida suele ser agregar un segundo sensor, y todavía estamos a tiempo.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Genera `datos/datos_limpios.csv`** con tu `limpiar.py` terminado.

2. **Guarda la figura de la galería de ventanas** por clase en `figuras/`. Es la evidencia principal de la semana.

3. **Documenta las ventanas que descartaste**, si descartaste alguna: cuáles, cuántas y por qué. Si después de quitarlas alguna clase quedó por debajo del mínimo, hay que recapturar.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué le hiciste a tu señal, en orden, y por qué en ese orden.
   - Qué tanto se parecen entre sí las ventanas de una misma clase después de limpiar, comparado con antes.
   - Si dos de tus clases se traslapan, qué vas a hacer al respecto.

   ```bash
   git add .
   git commit -m "s04 proyecto: dataset limpio y normalizado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Comparen sus figuras de galería. Dos cosas:

1. **Quién tiene la señal más limpia y por qué.** Casi siempre hay un módulo del equipo cuya señal sale mucho mejor que las otras, y la razón suele ser el montaje: mejor sujeción, mejor distancia, menos vibración. Eso se copia entre ustedes.
2. **El mismo orden de limpieza para los tres módulos.** Si uno normaliza y otro no, cuando integren los módulos en la semana 8 los valores no van a ser comparables. Escriban el orden acordado (atípicos, filtro, línea base, normalización) en el README del equipo.
