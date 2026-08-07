---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 15 - Evaluación del modelo (U4)

Tu sistema funciona. En la revisión de la semana pasada lo demostraste. Y sin embargo hay una pregunta que todavía no puedes responder con seriedad: **¿qué tan bien funciona?**

Has estado usando la exactitud, un número calculado sobre 18 ejemplos de prueba. Esta semana vas a ver por qué ese número miente de tres maneras distintas, y vas a aprender a medir en serio. Es lo que separa un proyecto escolar de uno que alguien se atrevería a poner en una línea de producción.

Empieza la Unidad 4, y con ella el camino hacia la maqueta.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: por qué la exactitud engaña](#bloque-1)
    - [Bloque 2: validación cruzada y evaluar.py](#bloque-2)
    - [Bloque extra: ¿me faltan datos?](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes precisión, exhaustividad y F1 aplicados a tu sistema | Tu análisis de qué error te duele más |
| 2 | Escribes `evaluar.py` con validación cruzada | `codigo/evaluar.py` y tu reporte |
| Extra | Averiguas si más datos te ayudarían | La curva de aprendizaje |

Sobre `features.csv`. Sin hardware.

---

### Bloque 1: por qué la exactitud engaña {#bloque-1}

#### Mentira número uno: las clases desbalanceadas

La **exactitud** es la fracción de aciertos sobre el total. Suena razonable hasta que las clases no están balanceadas.

Imagina un sistema de inspección donde el 95% de las piezas son buenas y el 5% defectuosas. Un modelo que responde "buena" siempre, sin mirar nada, tiene **95% de exactitud**. Es un número excelente para un sistema que no detecta ni una sola pieza defectuosa, que es exactamente lo único que se le pedía.

En tu dataset esto no aplica tanto porque lo balanceaste a propósito en la semana 3. Pero **en tus anomalías sí aplica de lleno**: son mucho menos frecuentes que las piezas normales, y ahí la exactitud es engañosa.

#### Mentira número dos: no todos los errores cuestan igual

La exactitud trata todos los errores como equivalentes, y en un sistema real nunca lo son.

Confundir madera con plástico manda una pieza al carril equivocado: se corrige y ya. Dejar pasar una pieza defectuosa puede llegarle al cliente. **Son errores de costo completamente distinto y la exactitud los suma como si fueran lo mismo.**

Para poder distinguirlos hay que nombrar los cuatro casos posibles. Tomando una clase cualquiera como la "positiva":

| | Predijo positivo | Predijo negativo |
|---|---|---|
| **Es positivo** | Verdadero positivo (VP) | Falso negativo (FN) |
| **Es negativo** | Falso positivo (FP) | Verdadero negativo (VN) |

En tu detector de anomalías, tomando "anomalía" como positivo:

- **Falso positivo:** una pieza buena marcada como anómala. Falsa alarma, se detiene la banda de más.
- **Falso negativo:** una pieza defectuosa que pasa como buena. **Este es el caro.**

#### Las tres métricas que sí sirven

**Precisión.** De todo lo que marqué como positivo, cuánto lo era de verdad.

$$P = \frac{VP}{VP + FP}$$

Precisión baja significa muchas falsas alarmas. Es la métrica que te importa si detener el proceso cuesta caro.

**Exhaustividad** (*recall*). De todo lo que era positivo, cuánto alcancé a detectar.

$$R = \frac{VP}{VP + FN}$$

Exhaustividad baja significa que se te escapan casos. Es la métrica que te importa si dejar pasar un defecto es grave.

**F1.** El promedio armónico de las dos, para cuando necesitas un solo número.

$$F_1 = 2 \cdot \frac{P \cdot R}{P + R}$$

Se usa el promedio armónico y no el aritmético porque **castiga los desequilibrios**: si tienes precisión 1.0 y exhaustividad 0.0, el promedio normal daría 0.5 y el F1 da 0. Que es lo correcto, porque ese modelo no sirve.

#### El compromiso

Precisión y exhaustividad **se mueven en direcciones opuestas**, y esto lo viste en la práctica en la semana 12 cuando elegiste el percentil de tu umbral:

- Bajas el umbral: detectas más anomalías (sube la exhaustividad) pero disparas más falsas alarmas (baja la precisión).
- Subes el umbral: menos falsas alarmas (sube la precisión) pero se te escapan más (baja la exhaustividad).

No existe un ajuste que mejore las dos. **Tienes que elegir cuál error prefieres cometer**, y esa elección se hace mirando el proceso, no las matemáticas.

#### Mentira número tres: un solo split es un volado

Esta es la más importante y la que arreglamos en el bloque 2.

Tu exactitud de la semana 7 salió de partir el dataset una vez, con `random_state=42`. Si hubieras puesto 7 en vez de 42, la partición habría sido otra y el número habría salido distinto. Con solo 18 ejemplos de prueba, **un ejemplo más o menos cambia la exactitud en 5 puntos**.

Así que tu 0.89 no es "la exactitud de tu modelo": es la exactitud que te tocó con esa partición concreta. Podría ser 0.78 o 0.94 con otra.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Para **tu** sistema, describe con ejemplos concretos qué es un falso positivo y qué es un falso negativo.
2. Cuál de los dos te duele más y por qué. Piensa en tu dominio, no en general.
3. Con esa respuesta: ¿deberías subir o bajar el umbral de tu detector de anomalías?
4. Calcula a mano, de tu matriz de confusión de la semana 7, la precisión y la exhaustividad de una de tus clases.

```bash
git add .
git commit -m "s15 bloque 1: metricas de evaluacion"
git push
```

---

### Bloque 2: validación cruzada y evaluar.py {#bloque-2}

#### La idea

Si un solo split es un volado, la solución es **hacer muchos y promediar**.

La **validación cruzada de k pliegues** parte tu dataset en $k$ trozos. Entrena con $k-1$ y prueba con el que queda. Repite $k$ veces, rotando cuál es el de prueba. Al final tienes $k$ mediciones.

```
  k = 5

  ronda 1:  [PRUEBA][train ][train ][train ][train ]
  ronda 2:  [train ][PRUEBA][train ][train ][train ]
  ronda 3:  [train ][train ][PRUEBA][train ][train ]
  ronda 4:  [train ][train ][train ][PRUEBA][train ]
  ronda 5:  [train ][train ][train ][train ][PRUEBA]
```

Y esto tiene dos ventajas grandes:

**Todos los ejemplos se usan para probar, exactamente una vez.** Ninguno se desperdicia.

**Obtienes una desviación estándar.** Y eso es lo que de verdad cambia tu manera de reportar:

```
Exactitud: 0.87 +/- 0.04     <- modelo estable, confiable
Exactitud: 0.87 +/- 0.19     <- el mismo promedio, pero es un volado
```

Los dos modelos tienen 0.87 de promedio. El segundo no sirve: dependiendo de con qué datos le toque trabajar, va del 68% al 100%. **Nunca vuelvas a reportar una exactitud sin su desviación.**

Igual que en la semana 7, los pliegues tienen que ser **estratificados** para que cada uno conserve la proporción de clases.

```python
# evaluar.py - evaluacion honesta del clasificador
import pandas as pd
import numpy as np
from sklearn.model_selection import cross_val_score, cross_val_predict, StratifiedKFold
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, confusion_matrix
import joblib

features = pd.read_csv('datos/features.csv')
X = features.drop(columns=['ventana', 'etiqueta'])
y = features['etiqueta']

modelo = joblib.load('modelo.pkl')['modelo']

# el pipeline mete el escalador DENTRO de la validacion cruzada
pipe = make_pipeline(StandardScaler(), modelo)

cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

scores = cross_val_score(pipe, X, y, cv=cv, scoring='accuracy')
print(f"Exactitud: {scores.mean():.3f} +/- {scores.std():.3f}")
print("Por pliegue:", np.round(scores, 3))

y_pred = cross_val_predict(pipe, X, y, cv=cv)

print()
print(classification_report(y, y_pred))
print(confusion_matrix(y, y_pred, labels=sorted(y.unique())))

# TODO: repite la evaluacion con f1_macro en vez de accuracy y compara
# TODO: grafica la matriz de confusion de la validacion cruzada
#       y guardala en figuras/confusion_cv.png
```

#### Por qué el pipeline es obligatorio

Este punto es sutil y es el error más frecuente al hacer validación cruzada.

Si estandarizas **antes** de partir en pliegues, el escalador calcula la media y la desviación usando **todos** los datos, incluidos los que van a servir de prueba en cada ronda. Esa información se filtra al entrenamiento y tu resultado sale mejor de lo que es. Es fuga de información, otra vez, pero por una puerta más discreta.

`make_pipeline` lo resuelve: mete el escalador dentro del proceso, así que en cada ronda se ajusta **solo con los datos de entrenamiento de esa ronda**. Es una línea de código y es la diferencia entre una medición honesta y una inflada.

#### Cómo se lee el classification_report

```
              precision    recall  f1-score   support

      madera       0.93      0.93      0.93        30
       metal       0.84      0.87      0.85        30
    plastico       0.86      0.83      0.85        30

    accuracy                           0.88        90
   macro avg       0.88      0.88      0.88        90
```

Una fila por clase, con sus tres métricas y cuántos ejemplos había (`support`). Aquí se ve lo que la exactitud global esconde: la madera se clasifica muy bien y el metal con el plástico se confunden entre sí. Esa es la información accionable.

**Lo que entregas de este bloque**

- `codigo/evaluar.py` con los dos `TODO` resueltos.
- `figuras/confusion_cv.png`.
- En `BITACORA.md`:
  1. Tu exactitud con su desviación estándar, y qué significa esa desviación en tu caso.
  2. Comparación honesta con el número que reportabas en la semana 7: ¿subió o bajó? Casi siempre baja, y eso es bueno, significa que ahora estás midiendo bien.
  3. Tu `classification_report` pegado, y cuál clase es la más débil de tu sistema.

```bash
git add .
git commit -m "s15 bloque 2: validacion cruzada y reporte"
git push
```

---

### Bloque extra: ¿me faltan datos? {#bloque-extra}

Opcional, y responde una pregunta que te has hecho todo el semestre.

La **curva de aprendizaje** grafica el desempeño en función de cuántos ejemplos usaste para entrenar:

```python
from sklearn.model_selection import learning_curve

tam, train_sc, test_sc = learning_curve(
    pipe, X, y, cv=cv,
    train_sizes=np.linspace(0.2, 1.0, 6),
)

plt.plot(tam, train_sc.mean(axis=1), marker='o', label='entrenamiento')
plt.plot(tam, test_sc.mean(axis=1),  marker='o', label='validacion')
plt.xlabel('numero de ejemplos de entrenamiento')
plt.ylabel('exactitud')
plt.legend()
```

Y se lee así:

**Las dos curvas se juntan y se aplanan.** Ya tienes suficientes datos. Capturar más no te va a servir de nada; si quieres mejorar, necesitas mejores características o un mejor sensor.

**La de validación sigue subiendo al llegar al final.** Te faltan datos. Capturar más ventanas es la inversión más rentable que puedes hacer, y es información concreta y accionable.

**Hay un hueco grande entre las dos.** Sobreajuste: el modelo va mucho mejor en lo que vio que en lo que no. Ese es el tema de la semana que viene.

Escribe en tu bitácora cuál de los tres casos es el tuyo. Es una conclusión de mucho peso para tu revisión final.

```bash
git add .
git commit -m "s15 extra: curva de aprendizaje"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con tu evaluación honesta hecha. Y hoy salimos del salón.

**1. Antes y después.** Anotamos en el pizarrón, por alumno, la exactitud que reportaba en la semana 7 y la que sale con validación cruzada. Para casi todos baja, y para algunos baja mucho. Discutimos qué significa eso y por qué el número nuevo es el bueno.

**2. Quién tiene la desviación más alta.** A quien le salga una desviación grande le buscamos la causa: pocos ejemplos, una clase mal representada, o un par de ventanas atípicas que arrastran un pliegue completo.

**3. Visita a la maqueta.** Vamos al laboratorio. Les enseño la celda con la banda transportadora, el PLC S7-1214C, los sensores capacitivos e inductivos y el pistón. Explico cómo se opera, qué se puede tocar y qué no, y cómo se van a agendar los turnos.

**4. La conversación que abre la Unidad 4.** Con la banda enfrente, la pregunta: **tus datos los capturaste moviendo la pieza a mano. En esta banda la velocidad es constante y distinta a la de tu mano. ¿Qué le va a pasar a tu modelo?** No lo resolvemos hoy: es el tema de la semana 16 y de tu revisión final.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu `evaluar.py` funcionando** y tu evaluación documentada.

2. **Actualiza el `README.md`** con los números honestos: exactitud con desviación, precisión y exhaustividad por clase. Los números viejos se sustituyen, no se acumulan.

3. **Agenda tu turno en la maqueta y captura datos sobre la banda real.** Este es el avance principal de la semana. Con tu sensor montado en la banda, captura al menos 10 ventanas por clase siguiendo el mismo protocolo que diseñaste en la semana 3, y guárdalas en `datos/datos_banda.csv`, con el mismo formato de columnas.

   **No mezcles este archivo con `datos.csv`.** Son dos conjuntos distintos y la semana que viene los vamos a comparar. Ahí está el tema central de la unidad.

4. **Corre tu modelo actual sobre `datos_banda.csv`** y anota qué exactitud da. No la arregles todavía, solo mídela. Es el punto de partida de la semana 16.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Tu evaluación honesta con validación cruzada.
   - La diferencia con lo que reportabas antes, y por qué.
   - Qué error le duele más a tu sistema y qué ajuste harías en consecuencia.
   - **Qué exactitud da tu modelo sobre los datos de la banda**, comparada con la de tus datos de escritorio. Si bajó mucho, no lo escondas: es el resultado que da sentido a toda la Unidad 4.

   ```bash
   git add .
   git commit -m "s15 proyecto: evaluacion honesta y datos de la banda"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Evalúen **el sistema completo**, no los módulos por separado. Es una medición distinta y suele ser peor de lo que esperan.

1. **Exactitud del sistema integrado** contra la de cada módulo por su cuenta. Si el sistema completo acierta menos que sus partes, algo pasa en la lógica de arbitraje.
2. **Aprovechen el turno de laboratorio en equipo** para capturar datos de los tres módulos sobre la misma banda, en la misma corrida. Ese conjunto conjunto es la base de la demo de la semana 17.
3. **Repártanse los turnos** de manera que alcancen: son dos celdas y varios equipos.
