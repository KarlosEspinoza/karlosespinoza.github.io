---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 13 - La anomalía como señal de control (U3)

Ya tienes dos modelos: uno que clasifica y otro que detecta lo raro. Pero el detector sigue imprimiendo números en la pantalla, igual que el clasificador antes de la semana 8.

Esta semana cierras la Unidad 3 haciendo con el detector lo que hiciste con el clasificador: **conectarlo al mundo físico**. Al terminar, tu sistema va a saber hacer algo que casi ningún proyecto estudiantil hace: **reconocer que no sabe, y actuar en consecuencia**.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: qué hace un sistema cuando no sabe](#bloque-1)
    - [Bloque 2: control.py con anomalías](#bloque-2)
    - [Bloque extra: la bitácora de anomalías](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes la confianza del modelo y diseñas tu lógica de decisión | Tu diagrama de decisión |
| 2 | Integras el detector en `control.py` y `control.ino` | Los dos archivos actualizados |
| Extra | Registras las anomalías en un archivo para revisarlas | `datos/registro.csv` y su script |

El bloque 2 se escribe sin hardware. El miércoles lo conectas.

---

### Bloque 1: qué hace un sistema cuando no sabe {#bloque-1}

#### El problema de la seguridad excesiva

Tu clasificador de la semana 7 **siempre responde algo**. Le pases lo que le pases, devuelve una de tus tres etiquetas. No tiene la opción de callarse.

Eso, en un sistema que mueve actuadores, es peligroso. Una pieza defectuosa clasificada con toda confianza como buena sigue de largo y se va con el cliente.

#### La confianza no basta, pero ayuda

Casi todos los clasificadores de scikit-learn pueden decirte, además de su respuesta, **qué tan seguros están**:

```python
probabilidades = modelo.predict_proba(X_esc)
print(probabilidades)     # [[0.05, 0.90, 0.05]]  -> 90% seguro de la clase 2
confianza = probabilidades.max()
```

Con eso puedes poner una regla: si la confianza es menor a 0.6, no clasifiques, rechaza. Es el **umbral de rechazo**, y es útil.

Pero tiene un límite serio que hay que entender: **un modelo puede estar muy seguro y estar muy equivocado**. Si le pasas un objeto completamente ajeno a tus tres clases, el modelo lo proyecta en el único espacio que conoce y puede darte 0.95 de confianza en una respuesta absurda. La confianza mide qué tan lejos está el punto de la frontera entre clases, no qué tan lejos está de todo lo que ha visto.

Por eso hacen falta los dos mecanismos:

| Mecanismo | Qué detecta |
|---|---|
| Umbral de rechazo (`predict_proba`) | Piezas que caen justo entre dos de tus clases |
| Detector de anomalías (autoencoder) | Piezas que no se parecen a nada conocido |

Son problemas distintos y se atienden por separado.

#### El orden importa

La lógica de tu sistema queda así, y el orden no es negociable:

```
   llega una ventana
          |
          v
   +--------------+
   | es anomala?  |  <- autoencoder: error > umbral ?
   +--------------+
      |         |
     si         no
      |         |
      v         v
   RECHAZO   +------------------+
             | clasificar       |
             +------------------+
                     |
                     v
             +------------------+
             | confianza < 0.6? |
             +------------------+
                |          |
               si          no
                |          |
                v          v
             RECHAZO    ACTUAR segun la clase
```

**Primero se pregunta si es anómala, y solo después se clasifica.** Al revés no tiene sentido: clasificar algo que no pertenece a ninguna de tus clases es trabajo desperdiciado, y el resultado es basura que podrías llegar a usar por error.

Es exactamente lo que hace un operador humano competente: primero mira si el objeto le resulta familiar, y solo si lo es, decide de qué tipo es.

#### Diseña tu acción de rechazo

La acción de rechazo tiene que ser **distinguible de las tres normales**. Si tu servo va a 45, 90 y 135 grados para tus tres clases, el rechazo no puede ser ninguna de esas.

Algunas opciones, según tu hardware:

| Acción | Con qué | Cuándo conviene |
|---|---|---|
| Cuarta posición del servo | Servomotor | Hay un carril de descarte |
| Detener la banda | Relé al motor | La anomalía requiere intervención humana |
| Alarma y dejar pasar | Buzzer o LED | Solo quieres registrar, no interrumpir |
| Marcar en rojo | LED RGB | Sistema de inspección, no de separación |

No hay una correcta. Lo que sí hay es una **justificación correcta**: qué le cuesta más a tu proceso, detenerse de más o dejar pasar una pieza mala.

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Tu diagrama de decisión completo, con tus clases y tus acciones concretas (puedes copiar el de arriba y adaptarlo).
2. Qué hace tu sistema ante una anomalía y por qué esa acción y no otra.
3. Explica con tus palabras por qué el detector de anomalías va **antes** que el clasificador.
4. Da un ejemplo de una pieza que pasaría el detector de anomalías pero debería ser rechazada por baja confianza.

```bash
git add .
git commit -m "s13 bloque 1: logica de decision con rechazo"
git push
```

---

### Bloque 2: control.py con anomalías {#bloque-2}

#### El bucle completo

Tomas tu `control.py` de la semana 8 y le insertas el detector antes de la clasificación:

```python
# control.py - bucle de control con deteccion de anomalias
import serial, time
import pandas as pd
import numpy as np
import joblib

CONFIANZA_MINIMA = 0.6

clas = joblib.load('modelo.pkl')
det  = joblib.load('detector.pkl')

ordenes = {'madera': b'A', 'metal': b'B', 'plastico': b'C', 'rechazo': b'R'}

while True:
    ventana = capturar_ventana(ser, N_MUESTRAS)
    ventana = limpiar(ventana)
    f = calcular_features(ventana)

    # ---- 1. es anomala? ----
    X_det = pd.DataFrame([f])[det['columnas']]
    X_det_esc = det['escalador'].transform(X_det)
    reconstruido = det['autoencoder'].predict(X_det_esc)
    error = np.mean((X_det_esc - reconstruido)**2)

    if error > det['umbral']:
        print(f"ANOMALIA (error {error:.4f} > {det['umbral']:.4f})")
        ser.write(ordenes['rechazo'])
        time.sleep(1)
        ser.write(b'0')
        continue                      # no se clasifica, se pasa a la siguiente

    # ---- 2. clasificar ----
    X_cla = pd.DataFrame([f])[clas['columnas']]
    X_cla_esc = clas['escalador'].transform(X_cla)

    probabilidades = clas['modelo'].predict_proba(X_cla_esc)[0]
    confianza = probabilidades.max()
    etiqueta  = clas['modelo'].classes_[probabilidades.argmax()]

    # ---- 3. confianza suficiente? ----
    if confianza < CONFIANZA_MINIMA:
        print(f"DUDOSA: parece {etiqueta} pero solo al {confianza:.0%}")
        ser.write(ordenes['rechazo'])
    else:
        print(f"{etiqueta} ({confianza:.0%})")
        ser.write(ordenes[etiqueta])

    time.sleep(0.5)
    ser.write(b'0')
```

Fíjate en el `continue`: cuando detecta una anomalía, **el bucle se salta la clasificación por completo**. Ese es el diagrama de decisión traducido a código.

Y nota que los dos modelos tienen su propio escalador y su propia lista de columnas. Son dos paquetes independientes y hay que respetarlos: usar el escalador del clasificador para el detector daría resultados sin sentido.

#### `control.ino`

Solo hay que agregar el caso nuevo:

```cpp
    switch (orden) {
      case 'A': servo.write(45);  break;
      case 'B': servo.write(90);  break;
      case 'C': servo.write(135); break;
      case 'R':                         // rechazo
        servo.write(0);
        digitalWrite(PIN_LED_ROJO, HIGH);
        tone(PIN_BUZZER, 1000, 500);
        break;
      case '0':
        servo.write(90);
        digitalWrite(PIN_LED_ROJO, LOW);
        break;
    }
```

Adáptalo a los actuadores que tengas. Lo importante es que **el rechazo se note**: si tu sistema rechaza una pieza y nadie se entera, no rechazó nada.

#### Un detalle que va a pasar

Cuando lo pruebes en vivo, es muy probable que veas **falsas alarmas seguidas**: el detector marca como anómalas piezas perfectamente normales.

La causa casi siempre es la misma y ya la conoces: el `limpiar()` o el `calcular_features()` de `control.py` no producen exactamente los mismos números que los scripts con los que entrenaste. El detector de anomalías es **más sensible a eso que el clasificador**, porque su trabajo es justamente notar lo que se sale de lo aprendido. Una diferencia pequeña en el procesamiento se le presenta como algo desconocido.

Si te pasa, ese es el diagnóstico: compara el vector de características que produce `control.py` con la fila de `features.csv` de la misma ventana, número por número.

**Lo que entregas de este bloque**

- `codigo/control.py` con el detector integrado.
- `codigo/control.ino` con el caso de rechazo.
- En `BITACORA.md`, tu tabla de acciones completa: las tres clases más el rechazo, con el carácter, el actuador y el efecto físico.

```bash
git add .
git commit -m "s13 bloque 2: anomalias integradas al bucle de control"
git push
```

---

### Bloque extra: la bitácora de anomalías {#bloque-extra}

Opcional, y es lo que hacen los sistemas industriales de verdad.

Un sistema que rechaza una pieza y no deja constancia desperdicia información valiosa. Lo que se hace es **registrar cada anomalía** para revisarla después: así se aprende qué está fallando en el proceso y, con el tiempo, esas piezas registradas se convierten en datos de entrenamiento para la siguiente versión del modelo.

```python
import csv
from datetime import datetime

def registrar_anomalia(error, umbral, ventana):
    with open('datos/registro.csv', 'a', newline='') as f:
        w = csv.writer(f)
        w.writerow([datetime.now().isoformat(), round(error, 5), round(umbral, 5)])

    # TODO: guarda tambien la ventana cruda, en datos/anomalias_capturadas/
    #       con el timestamp en el nombre del archivo, para poder revisarla
```

Y después de una corrida, ese registro se analiza:

```python
# TODO: cuenta cuantas anomalias hubo, a que hora,
#       y grafica el error de reconstruccion a lo largo del tiempo
```

Esa última gráfica es interesantísima si la corres un rato largo: **si el error promedio de las piezas normales va subiendo con el tiempo**, no es que las piezas cambien, es que tu sistema se está desajustando (el sensor se ensucia, la luz cambia, la pieza se desgasta). Eso se llama **deriva del modelo** y es la razón por la que en la industria los modelos se reentrenan periódicamente. Volvemos a esto en la semana 16.

```bash
git add .
git commit -m "s13 extra: registro de anomalias"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con `control.py` integrado. Traes tu hardware, tus piezas normales y tus piezas raras. **Hoy tu sistema queda completo**: clasifica, detecta lo que no conoce y actúa en los dos casos.

**1. Que se note el rechazo.** Primero se prueba la acción de rechazo sola, mandando `R` a mano desde el Monitor Serie, igual que hicimos en la semana 8. Depurar por partes, siempre.

**2. El sistema completo.** Pasas piezas normales y piezas raras alternadas, y el sistema tiene que hacer lo correcto en los dos casos. Este es el momento en que tu proyecto queda terminado en su versión de prototipo.

**3. La ronda de anomalías cruzadas.** Cada quien le pasa al sistema del compañero una de sus propias piezas raras, que ese sistema nunca ha visto ni fue diseñado para reconocer. Es la prueba más honesta del semestre y siempre da sorpresas.

**4. Caza de falsas alarmas.** Vemos a quién le dispara el detector con piezas normales y diagnosticamos en vivo. Casi siempre es el desajuste entre el procesamiento del entrenamiento y el del control, y resolverlo en clase con ayuda vale por tres horas de intentarlo solo.

**5. Video del sistema completo.** Cada quien graba su bucle operando con los dos comportamientos: clasificación correcta y rechazo de una anomalía. Es la evidencia principal para la revisión de la semana 14.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu bucle completo funcionando** con clasificación, detección de anomalías y umbral de confianza.

2. **Graba el video** con al menos dos pasadas de cada clase y dos anomalías rechazadas. Súbelo o enlázalo desde el `README.md`.

3. **Mide el sistema completo en vivo**, con 10 piezas normales y 10 raras:

   | | Correctas | Total | Tasa |
   |---|---|---|---|
   | Clasificación de piezas normales | | | |
   | Detección de anomalías | | | |
   | Falsas alarmas | | | |

4. **Prepárate para la revisión de la semana 14.** Tu repositorio debe tener toda la Unidad 3: `pca.py`, `clustering.py`, `autoencoder.py`, `control.py` actualizado, `detector.pkl`, `anomalias.csv`, las figuras y la bitácora de las semanas 10 a 13.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Tu tabla de medición en vivo.
   - Qué anomalía se le escapó a tu sistema y por qué crees que se le escapó.
   - Cuántas falsas alarmas tuviste y qué las causaba.
   - Y la reflexión de cierre de la unidad: **¿en qué se parece y en qué se diferencia lo que hace tu detector de anomalías de lo que hace tu clasificador?**

   ```bash
   git add .
   git commit -m "s13 proyecto: sistema completo con rechazo de anomalias"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Integren la detección de anomalías en el controlador central, según la arquitectura que eligieron.

Y definan la política de arbitraje completa del sistema, que es la parte de ingeniería del integrador:

1. **Si un módulo dice anomalía y los otros clasifican con confianza**, ¿qué gana?
2. **Si dos módulos clasifican cosas incompatibles**, ¿es eso una anomalía en sí misma? Es una idea buena y vale la pena que la consideren: la incoherencia entre módulos es una señal de que algo raro está pasando, aunque ningún detector individual lo haya notado.
3. **Prueben el sistema completo** con piezas normales de los tres dominios y con anomalías, y documenten los casos en que el sistema integrado se equivoca aunque los módulos individuales acierten.

Todo al README del equipo, con la figura del diagrama de decisión del sistema completo. En la revisión de la semana 14 les pregunto por la política de arbitraje.
