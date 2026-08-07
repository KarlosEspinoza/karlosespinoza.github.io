---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 6 - Características en el dominio de la frecuencia (U2)

La semana pasada describiste tus ventanas mirándolas como lo que son: valores que suben y bajan a lo largo del tiempo. Esta semana las miras de otra manera, que al principio parece rebuscada y termina siendo una de las herramientas más potentes que hay para señales.

La idea es esta: **cualquier señal se puede describir como una suma de oscilaciones de distintas frecuencias**. Y a veces lo que distingue a dos piezas no es qué tan profundo fue el valle, sino qué tan rápido vibra la señal mientras la pieza pasa. Eso en el tiempo casi no se ve; en frecuencia salta a la vista.

Aviso desde ahora, porque es importante y honesto: **puede que a tu señal la frecuencia no le aporte nada**. Si tu evento es una curva lenta y suave, es un resultado esperable. Documentarlo con evidencia también es un resultado válido, y así lo vamos a evaluar.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: mirar una señal en frecuencia](#bloque-1)
    - [Bloque 2: la FFT en Python y las features espectrales](#bloque-2)
    - [Bloque extra: comparar los espectros de tus tres clases](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes qué es el espectro y hasta dónde puedes ver | El espectro de una de tus ventanas |
| 2 | Agregas las features espectrales a `features.py` | `features.csv` con las columnas nuevas |
| Extra | Comparas los espectros promedio de tus tres clases | Una figura comparativa y tu conclusión |

Sobre tu `datos_limpios.csv`. Sin hardware.

---

### Bloque 1: mirar una señal en frecuencia {#bloque-1}

#### Las dos maneras de describir lo mismo

Imagina un acorde de tres notas en un piano. Puedes describirlo de dos formas: dibujando cómo se mueve el aire a lo largo del tiempo (una curva complicadísima), o diciendo "son las notas do, mi y sol". Las dos describen exactamente el mismo sonido. La segunda es la descripción **en frecuencia**, y es incomparablemente más útil.

Con tu señal pasa igual. La curva que graficaste es la descripción en el tiempo. La descripción en frecuencia dice: "esta señal es una oscilación lenta y grande, más un temblorcito rápido y chico, más...". Y ese temblorcito rápido puede ser justo lo que distingue una superficie lisa de una rugosa.

La herramienta que traduce de una descripción a la otra es la **Transformada de Fourier**. Su versión para señales muestreadas se llama **FFT** (Fast Fourier Transform), y en Python es una línea.

#### Qué te devuelve la FFT

El resultado se llama **espectro**: para cada frecuencia, cuánta de esa frecuencia hay en tu señal.

```
magnitud
  ^
  |  |
  |  |
  |  |  |
  |  |  |  .   .  .   .    .
  +--+--+--+---+--+---+----+---> frecuencia (Hz)
     0  5 10  20 30  40   50
```

Una barra alta en 5 Hz significa que tu señal tiene una oscilación fuerte que se repite cinco veces por segundo. La barra en 0 Hz es el valor promedio de la señal, y como ya le corregiste la línea base en la semana 4, debería ser pequeña.

#### Hasta dónde puedes ver: Nyquist

Aquí es donde vuelve la decisión que tomaste en la semana 2 sin saber todavía para qué servía.

**No puedes detectar frecuencias mayores a la mitad de tu frecuencia de muestreo.** Esa es la frecuencia de Nyquist:

$$f_{max} = \frac{f_s}{2}$$

donde $f_s$ es tu frecuencia de muestreo, en muestras por segundo, y $f_{max}$ la frecuencia más alta que tu espectro puede representar.

Si muestreas a 100 Hz, tu espectro llega hasta 50 Hz y de ahí para arriba no existe nada para ti.

La razón es intuitiva: para ver una oscilación completa necesitas al menos dos muestras, una arriba y una abajo. Con menos, la oscilación se te escapa entre lecturas.

Y no se escapa en silencio, que es lo peor: una frecuencia mayor a Nyquist **aparece en tu espectro disfrazada de una frecuencia baja que no existe**. Se llama **aliasing**, y es la razón por la que un ventilador filmado con celular a veces parece girar al revés. Si en tu espectro aparece un pico raro en una frecuencia que no tiene explicación física, sospecha de aliasing.

**Escribe tu Nyquist en la bitácora ahora.** Si muestreaste a 100 Hz, todo lo que digas sobre frecuencias por encima de 50 Hz es inventado.

#### Cuánto detalle tienes

La otra limitante es la resolución en frecuencia:

$$\Delta f = \frac{f_s}{N}$$

donde $N$ es el número de muestras de tu ventana. Con $f_s = 100$ Hz y $N = 200$ muestras, $\Delta f = 0.5$ Hz: tu espectro tiene una barra cada medio hertz. Ventanas más largas dan más detalle en frecuencia.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Tu frecuencia de muestreo $f_s$ (la que quedó en tu `sensor.ino` después de la semana 2).
2. Tu frecuencia de Nyquist, y qué significa para tu señal.
3. Tu resolución $\Delta f$ con el largo de ventana que usas.
4. Tu predicción: ¿esperas que tus clases se distingan en frecuencia? ¿Por qué sí o por qué no?

```bash
git add .
git commit -m "s06 bloque 1: nyquist y resolucion en frecuencia"
git push
```

---

### Bloque 2: la FFT en Python y las features espectrales {#bloque-2}

#### Calcular el espectro

Como tu señal es de números reales, se usa `rfft`, que devuelve solo la mitad útil del espectro:

```python
import numpy as np

FS = 100.0                        # tu frecuencia de muestreo, en Hz

espectro = np.abs(np.fft.rfft(x))          # magnitud de cada frecuencia
frecuencias = np.fft.rfftfreq(len(x), 1/FS)  # a que frecuencia corresponde cada una
```

`x` son las muestras limpias de una ventana. `espectro[i]` es cuánta señal hay en la frecuencia `frecuencias[i]`.

Un detalle que confunde a todo el mundo la primera vez: **la FFT devuelve números complejos**. No nos interesa la parte compleja (que es la fase); nos interesa el tamaño, y por eso va el `np.abs()`.

Y algo importante para tu caso: **tira la primera barra**, la de 0 Hz. Es el promedio de la señal, no una oscilación, y suele ser tan grande que aplasta visualmente todo lo demás.

```python
espectro = espectro[1:]
frecuencias = frecuencias[1:]
```

#### Las cuatro features espectrales

**Frecuencia dominante.** La frecuencia con la barra más alta: la oscilación que más manda en tu señal.

```python
f_dominante = frecuencias[np.argmax(espectro)]
```

**Energía espectral total.** La suma de todas las barras al cuadrado. Qué tanto contenido oscilatorio hay en total.

$$E = \sum_{k} |X_k|^2$$

donde $X_k$ es la magnitud del espectro en la frecuencia $k$.

**Centroide espectral.** El "centro de gravedad" del espectro: el promedio de las frecuencias, pesado por cuánta hay de cada una. Es alto cuando la señal tiene mucho contenido rápido, bajo cuando es lenta y suave.

$$C = \frac{\sum_k f_k \cdot |X_k|}{\sum_k |X_k|}$$

donde $f_k$ es la frecuencia de la barra $k$.

```python
centroide = np.sum(frecuencias * espectro) / np.sum(espectro)
```

Esta es de las más útiles y de las menos conocidas. Si tus piezas tienen superficies distintas, el centroide suele separarlas.

**Energía por bandas.** Partes el espectro en tramos (por ejemplo 0-10 Hz, 10-25 Hz, 25-50 Hz) y calculas la energía de cada uno. Te da un perfil grueso de dónde está la señal.

```python
banda_baja = np.sum(espectro[(frecuencias >= 0) & (frecuencias < 10)]**2)
```

#### Agregar todo a `features.py`

No hagas un archivo aparte. La cadena del proyecto es una sola y las features de frecuencia son features como las demás:

```python
# dentro del bucle sobre ventanas, despues de las features de tiempo

espectro = np.abs(np.fft.rfft(x))[1:]
frecuencias = np.fft.rfftfreq(len(x), 1/FS)[1:]

fila['f_dominante'] = frecuencias[np.argmax(espectro)]
fila['centroide']   = np.sum(frecuencias * espectro) / np.sum(espectro)

# TODO: agrega la energia espectral total
# TODO: agrega la energia de al menos dos bandas, eligiendo los limites
#       segun lo que veas en tus propios espectros
```

Cuidado con una cosa: si tus ventanas no miden todas lo mismo, los vectores `frecuencias` salen distintos entre ventanas. La frecuencia dominante y el centroide se comparan bien igual, porque están en Hz. Las energías de banda también, porque las defines en Hz. Lo que **no** puedes hacer es meter las barras del espectro como características sueltas, porque no corresponderían a las mismas frecuencias entre ventanas.

#### Verifica si sirvió

La misma prueba de la semana pasada: dispersión de una feature de frecuencia contra una de tiempo, coloreada por clase.

Y aquí va la parte honesta. **Si el espectro no separa nada, no lo fuerces.** Muchas señales de este curso son eventos lentos y suaves, y su espectro es casi el mismo para las tres clases. Si ese es tu caso, lo correcto es:

1. Enseñar la gráfica que lo demuestra.
2. Escribir en la bitácora que las features de frecuencia no aportan en tu dominio, con la razón física (tu evento es lento, tu sensor es lento, tu $f_s$ no alcanza).
3. **Quitarlas de `features.csv`**, porque características que no aportan sí estorban.

Eso es un resultado bien hecho, no un fracaso. Lo que sí sería un error es dejarlas ahí "por si acaso" sin haber mirado.

**Lo que entregas de este bloque**

- `codigo/features.py` con las features espectrales y los dos `TODO` resueltos.
- `figuras/espectro.png` con el espectro de una ventana de cada clase.
- `datos/features.csv` actualizado.
- En `BITACORA.md`:
  1. Qué frecuencia dominante tiene tu señal y si tiene sentido físico.
  2. Si las features de frecuencia separan tus clases o no, **con la gráfica que lo respalde**.
  3. Tu decisión: te las quedas o las quitas, y por qué.

```bash
git add .
git commit -m "s06 bloque 2: caracteristicas espectrales"
git push
```

---

### Bloque extra: comparar los espectros de tus tres clases {#bloque-extra}

Opcional. Un espectro por clase dice poco, porque una sola ventana puede ser rara. Lo que de verdad se ve es el **espectro promedio de cada clase**.

Calcula el espectro de todas las ventanas de una clase y promédialos punto a punto. Repite para las tres y grafícalos juntos.

```python
for etiqueta, g in datos.groupby('etiqueta'):
    espectros = []
    for ventana, v in g.groupby('ventana'):
        espectros.append(np.abs(np.fft.rfft(v['valor'].values))[1:])
    # TODO: promedia los espectros de esta clase y grafica
```

Ojo: para promediar necesitas que todos midan lo mismo, así que si tus ventanas son de largo variable hay que recortarlas todas al largo de la más corta.

La pregunta que responde esa figura es la buena: **¿hay alguna banda de frecuencias donde las tres curvas se separen?** Si la hay, esa banda es tu mejor característica espectral y deberías definir una banda de energía justo ahí, en vez de usar los límites genéricos.

```bash
git add .
git commit -m "s06 extra: espectros promedio por clase"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tus espectros calculados y tu decisión tomada sobre si te sirven. Cerramos la etapa de preparación de datos: al terminar hoy, tu `features.csv` es el definitivo con el que vas a entrenar.

**1. La galería de espectros del grupo.** Cada quien enseña sus tres espectros promedio. Como cada uno tiene un dominio distinto, en una sola sesión vemos casos donde la frecuencia lo resuelve todo y casos donde no aporta nada, y por qué. Es la mejor manera de entender cuándo esta herramienta es la adecuada.

**2. Cacería de aliasing.** Revisamos juntos los espectros que tengan picos sin explicación. Casi siempre hay uno o dos en el grupo, y el diagnóstico en vivo enseña más que la teoría.

**3. Congelar el dataset.** Cada quien deja su `features.csv` en su versión final, con las columnas que se va a quedar, y hace push. **De aquí en adelante ese archivo no se toca**, porque si lo cambias a media semana 7 tus resultados dejan de ser comparables. Si necesitas cambiarlo, se documenta en la bitácora como una versión nueva.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu `datos/features.csv` definitivo**, con features de tiempo y las de frecuencia que hayas decidido conservar.

2. **Guarda la figura de espectros** por clase en `figuras/`.

3. **Documenta el estado del dataset** en el `README.md` de tu repositorio: cuántas ventanas por clase, cuántas características y cuáles. Es la ficha técnica de tu proyecto y la voy a leer en la revisión de la semana 9.

4. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Si la frecuencia te sirvió o no, y la explicación física de por qué.
   - La lista final de características con las que vas a entrenar la semana que viene.
   - Cómo se ve la separación de tus clases con el conjunto final. Esta es tu predicción de qué tan bien va a salir el clasificador; en la semana 7 la comparamos con lo que salga.

   ```bash
   git add .
   git commit -m "s06 proyecto: caracteristicas de frecuencia y dataset congelado"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Una decisión de equipo que conviene tomar esta semana, antes de entrenar: **si todos los módulos van a muestrear a la misma frecuencia**.

No es obligatorio, y forzarlo puede ser mala idea si un sensor es más lento que otro. Pero si sus $f_s$ son distintas, en la semana 8 el controlador central va a tener que leer los tres módulos a ritmos diferentes, y eso complica el código. Evalúen si les conviene igualarlos ahora, cuando todavía es barato recapturar, o dejarlos distintos y asumir la complejidad después.

Anoten la decisión y la razón en el README del equipo.
