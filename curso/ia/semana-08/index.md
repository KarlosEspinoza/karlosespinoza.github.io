---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 8 - Redes neuronales y primer bucle de control (U2)

Esta semana cierra la Unidad 2 y es la más importante del curso hasta ahora, porque tu proyecto deja de ser un análisis de datos y **se convierte en un sistema mecatrónico**.

Hasta hoy tu modelo imprime una etiqueta en la pantalla. Al terminar la semana, esa etiqueta va a mover algo. Vas a cerrar el bucle que dibujamos en la semana 1: sensor, modelo, actuador. Eso es lo que hace que este sea un curso de mecatrónica y no de ciencia de datos.

De paso, agregamos el algoritmo que le da nombre popular a la inteligencia artificial: las redes neuronales.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: la red neuronal como clasificador](#bloque-1)
    - [Bloque 2: cerrar el bucle](#bloque-2)
    - [Bloque extra: cuánto tarda tu bucle](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes cómo decide una red neuronal y entrenas una | La red entrenada y su comparación con tu modelo |
| 2 | Escribes `control.py` y `control.ino` | Los dos archivos y tu tabla de acciones |
| Extra | Mides cuánto tarda una vuelta completa del bucle | El tiempo medido y tu conclusión |

El bloque 2 se escribe **sin el Arduino conectado**. El miércoles lo conectas y lo haces funcionar.

---

### Bloque 1: la red neuronal como clasificador {#bloque-1}

#### Una neurona es una suma con umbral

Quita de tu cabeza la imagen del cerebro; no ayuda. Una neurona artificial es esto:

```
   x1 ---w1--\
              \
   x2 ---w2----> [ suma ] --> [ activacion ] --> salida
              /
   x3 ---w3--/
```

Toma sus entradas, las multiplica por unos pesos, las suma, le agrega un sesgo y pasa el resultado por una función:

$$a = f\left(\sum_{i=1}^{m} w_i x_i + b\right)$$

donde:

- $x_i$ son las entradas (tus características)
- $w_i$ son los **pesos**, lo que la red aprende
- $b$ es el **sesgo**, un ajuste que también se aprende
- $f$ es la **función de activación**
- $a$ es la salida de la neurona

Una sola neurona traza una frontera recta, ni más ni menos que eso. Lo interesante viene cuando las pones en capas.

#### Por qué hacen falta capas

Una neurona sola solo separa lo que se puede separar con una línea. Muchos problemas no son así: piensa en una clase cuyos ejemplos rodean a otra, en forma de dona. Ninguna línea recta hace eso.

Al apilar neuronas en **capas ocultas**, las salidas de una capa alimentan a la siguiente, y las fronteras se pueden combinar y curvar. Con suficientes neuronas ocultas, una red puede aproximar prácticamente cualquier frontera.

```
  entradas       capa oculta      salida
  (6 features)   (10 neuronas)    (3 clases)

     o                o
     o                o               o  madera
     o                o               o  metal
     o                o               o  plastico
     o                o
     o                o
     o                o
```

Y la **función de activación** es la pieza que hace que esto funcione. Si fuera lineal, apilar capas no serviría de nada: la composición de funciones lineales sigue siendo lineal, y toda la red colapsaría al equivalente de una sola neurona. La activación que se usa hoy casi siempre es **ReLU**, que es tan simple como parece:

$$\text{ReLU}(z) = \max(0, z)$$

Deja pasar lo positivo y aplasta lo negativo a cero. Esa pequeña no linealidad es todo lo que hace falta.

#### Entrenar la red

Entrenar significa **buscar los pesos y sesgos que minimizan los errores**. El procedimiento se llama retropropagación: se calcula el error en la salida, se reparte hacia atrás para saber cuánta culpa tiene cada peso, y cada peso se ajusta un poquito en la dirección que reduce el error. Se repite miles de veces. Cada pasada completa por los datos es una **época** (*epoch*).

En scikit-learn eso es una clase más, con la misma interfaz que ya conoces:

```python
from sklearn.neural_network import MLPClassifier

red = MLPClassifier(
    hidden_layer_sizes=(10,),   # una capa oculta de 10 neuronas
    max_iter=2000,
    random_state=42,
)
red.fit(X_train_esc, y_train)
```

**Las redes exigen estandarizar.** Más que k-NN, incluso. Con características en escalas muy distintas, el entrenamiento no converge o converge malísimo. Usa el mismo `StandardScaler` de la semana pasada.

#### Cuándo conviene una red y cuándo no

Esto es lo que quiero que te lleves de este bloque, más que la fórmula.

Las redes neuronales brillan con **muchos datos** y con problemas donde la frontera es complicada. Tú tienes 90 ejemplos. En ese régimen, un árbol de decisión o un k-NN suelen igualar o ganarle a una red, y encima se pueden explicar.

Así que es muy posible que tu red salga peor que tu modelo de la semana 7. **Eso no es un fracaso, es el resultado correcto y es la lección de la semana**: el algoritmo más sofisticado no es el mejor por definición. Con pocos datos, la sofisticación se paga en sobreajuste.

Lo que sí es un fracaso es usar una red porque suena mejor en la presentación, sin haber comparado. En la revisión de la semana 9 te voy a preguntar cuál modelo elegiste y por qué, y "porque es inteligencia artificial" no es una respuesta.

**Lo que entregas de este bloque**

Entrena la red sobre tu mismo `features.csv` y compárala con el modelo de la semana 7:

| Modelo | Exactitud train | Exactitud test |
|---|---|---|
| El tuyo de la semana 7 | | |
| Red (10 neuronas) | | |
| Red (50 neuronas) | | |

En `BITACORA.md`, bajo `### Antes de la clase`:

1. Esa tabla llena con tus números.
2. Cuál modelo se queda en tu sistema y por qué.
3. Explica con tus palabras por qué la red no necesariamente gana.

```bash
git add .
git commit -m "s08 bloque 1: red neuronal y comparacion"
git push
```

---

### Bloque 2: cerrar el bucle {#bloque-2}

Aquí está el corazón del curso.

#### El protocolo de vuelta

En la semana 2 construiste la flecha de ida: el Arduino manda números y Python los lee. Ahora falta la de regreso: **Python manda una orden y el Arduino la ejecuta**.

Se hace por el mismo puerto serial, y el protocolo tiene que ser lo más simple posible, porque el Arduino no tiene con qué complicarse: **un solo carácter por orden**.

| Carácter | Significado | Qué hace el actuador |
|---|---|---|
| `A` | pieza tipo A | (lo que decidas para tu clase 1) |
| `B` | pieza tipo B | (lo que decidas para tu clase 2) |
| `C` | pieza tipo C | (lo que decidas para tu clase 3) |
| `0` | reposo | vuelve a la posición neutra |

Tu tabla concreta depende de tus actuadores. Con un servomotor puedes desviar la pieza a tres posiciones distintas; con un LED RGB puedes marcar cada clase de un color; con un relé y un buzzer, dejar pasar o rechazar. Lo importante es que **la decisión del modelo produzca un efecto físico observable**.

#### `control.ino`

```cpp
// control.ino - lee el sensor y obedece las ordenes que llegan de Python
#include <Servo.h>

const int PIN_SENSOR = A0;
Servo servo;

void setup() {
  Serial.begin(115200);
  servo.attach(9);
  servo.write(90);          // posicion neutra
}

void loop() {
  // sigue mandando la lectura del sensor, igual que en la semana 2
  Serial.println(analogRead(PIN_SENSOR));

  // si llego una orden de Python, obedecerla
  if (Serial.available() > 0) {
    char orden = Serial.read();

    switch (orden) {
      case 'A': servo.write(45);  break;
      case 'B': servo.write(90);  break;
      case 'C': servo.write(135); break;
      case '0': servo.write(90);  break;
    }
  }

  delay(10);
}
```

Fíjate en `Serial.available()`: pregunta si hay algo esperando en el buffer de entrada. Si no preguntas y llamas a `Serial.read()` a secas, obtienes `-1` y el `switch` no hace nada, pero es mejor costumbre preguntar.

Y nota que el Arduino **sigue mandando lecturas mientras escucha**. El bucle no se detiene a esperar órdenes: lee, manda, revisa si llegó algo, y vuelve a empezar.

#### `control.py`

Este script junta todo lo que has construido en siete semanas. Léelo con calma, porque es tu sistema completo en 40 líneas:

```python
# control.py - el bucle de control completo
import serial
import time
import numpy as np
import pandas as pd
import joblib

PUERTO = 'COM3'
BAUDIOS = 115200
N_MUESTRAS = 200
UMBRAL = 30          # el mismo que usaste para detectar el evento

paquete = joblib.load('modelo.pkl')
modelo    = paquete['modelo']
escalador = paquete['escalador']
columnas  = paquete['columnas']

ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
time.sleep(2)

ordenes = {'madera': b'A', 'metal': b'B', 'plastico': b'C'}   # ajusta a tus clases

print("Sistema en marcha. Ctrl+C para detener.")

while True:
    # 1. CAPTURAR una ventana
    ventana = capturar_ventana(ser, N_MUESTRAS)

    # 2. LIMPIAR: exactamente lo mismo que hace limpiar.py
    ventana = limpiar(ventana)

    # 3. EXTRAER las caracteristicas, en el mismo orden que en el entrenamiento
    f = calcular_features(ventana)
    X = pd.DataFrame([f])[columnas]

    # 4. DECIDIR
    X_esc = escalador.transform(X)
    etiqueta = modelo.predict(X_esc)[0]

    # 5. ACTUAR
    ser.write(ordenes[etiqueta])
    print(f"-> {etiqueta}")

    time.sleep(0.5)
    ser.write(b'0')        # volver a reposo
```

**Las tres funciones que faltan las escribes tú**, y aquí está el punto pedagógico de la semana:

```python
# TODO: capturar_ventana(ser, n)  -> array de n muestras
#       es lo mismo que hace adquirir.py, sacado a una funcion

# TODO: limpiar(ventana)  -> array limpio
#       tiene que hacer EXACTAMENTE lo mismo que limpiar.py:
#       mismo filtro, misma correccion de linea base, misma normalizacion

# TODO: calcular_features(ventana)  -> diccionario de caracteristicas
#       tiene que calcular EXACTAMENTE las mismas que features.py
```

Lee dos veces la palabra **exactamente**. Es la lección más importante de esta semana:

> **En producción tienes que aplicar el mismo procesamiento que aplicaste al entrenar. Si al entrenar filtraste con $k=5$ y en producción filtras con $k=9$, tu modelo está recibiendo datos de un mundo distinto al que aprendió, y va a fallar sin dar ninguna señal de error.**

Este es el error número uno de los sistemas de aprendizaje de máquina en producción, y tiene nombre: *training-serving skew*. Aparece en empresas grandes, con equipos serios. Y la manera de evitarlo es no duplicar el código: sacar `limpiar()` y `calcular_features()` a un módulo que importen tanto los scripts de entrenamiento como el de control. Si te animas a hacerlo así, mucho mejor.

**Lo que entregas de este bloque**

- `codigo/control.ino` adaptado a tu actuador.
- `codigo/control.py` con las tres funciones escritas.
- En `BITACORA.md`, tu tabla de acciones: qué carácter, qué clase, qué hace el actuador y por qué esa acción tiene sentido en tu dominio.

```bash
git add .
git commit -m "s08 bloque 2: bucle de control completo"
git push
```

---

### Bloque extra: cuánto tarda tu bucle {#bloque-extra}

Opcional, y muy relevante para el despliegue de la Unidad 4.

Una banda transportadora no espera. Si tu sistema tarda tres segundos en decidir y las piezas pasan cada segundo, no sirve por más que acierte el 100%.

Mide cada etapa:

```python
import time

t0 = time.time(); ventana = capturar_ventana(ser, N_MUESTRAS); t1 = time.time()
ventana = limpiar(ventana);                                     t2 = time.time()
f = calcular_features(ventana);                                 t3 = time.time()
etiqueta = modelo.predict(escalador.transform(X))[0];           t4 = time.time()

print(f"capturar:  {t1-t0:.3f} s")
print(f"limpiar:   {t2-t1:.3f} s")
print(f"features:  {t3-t2:.3f} s")
print(f"predecir:  {t4-t3:.3f} s")
print(f"TOTAL:     {t4-t0:.3f} s")
```

Repítelo veinte veces y saca el promedio y el máximo. Y responde en la bitácora: **¿cuál etapa se lleva casi todo el tiempo?**

Casi seguro va a ser la captura, porque tienes que esperar físicamente a que pasen las 200 muestras. Predecir suele tardar menos de un milisegundo. Eso tiene una consecuencia interesante: **el cuello de botella de tu sistema no es la inteligencia artificial, es la adquisición**. Es un resultado que sorprende a mucha gente y vale la pena que lo tengas medido para la revisión final.

```bash
git add .
git commit -m "s08 extra: latencia del bucle de control"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Llegas con `control.py` y `control.ino` escritos y tu modelo elegido. Traes tu Arduino, tu sensor, tu actuador y tus piezas. **Hoy tu sistema funciona por primera vez de extremo a extremo.**

**1. Que el actuador obedezca.** Antes de meter el modelo, se prueba la flecha de regreso sola: cargas `control.ino` y desde el Monitor Serie mandas `A`, `B`, `C` a mano. Si el servo no se mueve, el problema es de hardware o de protocolo, y hay que resolverlo antes de agregar nada más. Depurar por partes es la mitad del oficio.

**2. El bucle completo.** Conectas todo y pasas una pieza. Si el actuador se mueve según lo que es la pieza, cerraste el bucle: ese es el momento del semestre.

**3. Cazar el desajuste.** Casi todos van a ver un fenómeno desconcertante: **el modelo acertaba 90% en el CSV y en vivo se equivoca la mitad de las veces**. No es mala suerte. Es que `limpiar()` o `calcular_features()` en `control.py` no hacen exactamente lo mismo que los scripts originales. Los cazamos comparando: se imprime el vector de características que produce `control.py` y se compara con la fila correspondiente de `features.csv` para la misma ventana. Donde no cuadren los números, ahí está el error.

**4. Video del sistema funcionando.** Cada quien graba treinta segundos de su bucle operando. Es la evidencia principal de la Unidad 2 y va en la revisión de la semana que viene.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu bucle funcionando** con `control.py` y `control.ino`.

2. **Graba el video** del sistema clasificando y actuando, con al menos dos pasadas de cada clase. Súbelo al repositorio o pon el enlace en el `README.md`.

3. **Mide la exactitud en vivo**: pasa diez piezas de cada clase y anota cuántas clasificó bien. Casi siempre es menor que la del CSV, y ese número es más honesto que cualquier otro que hayas obtenido.

4. **Prepárate para la revisión de la semana 9.** Revisa que tu repositorio tenga todo: `datos.csv`, `datos_limpios.csv`, `features.csv`, `modelo.pkl`, los cinco scripts, las figuras y la bitácora completa de las semanas 1 a 8.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Tu tabla de acciones y qué hace tu sistema con cada clase.
   - Tu exactitud en vivo comparada con la del CSV, y a qué le atribuyes la diferencia.
   - Qué falló al conectar todo y cómo lo resolviste. Esta parte es la que más me interesa leer.

   ```bash
   git add .
   git commit -m "s08 proyecto: bucle de control funcionando"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Es la semana de la primera integración de verdad. Construyan un **controlador central** que lea los tres módulos y decida.

1. **Cada módulo expone la misma función:** recibe una ventana cruda, devuelve su etiqueta. Nada más.
2. **El controlador central** las llama a las tres y junta las respuestas en una decisión. Definan qué pasa si dos módulos dicen cosas incompatibles: quién manda, o si hay una acción de "no sé" cuando no coinciden. Esa lógica de arbitraje es la parte de ingeniería del integrador.
3. **Prueben con las piezas de los tres dominios** y anoten los casos en que el sistema completo se equivoca aunque los módulos individuales acierten. Ese es el problema propio de los sistemas integrados y da para una buena discusión en la revisión.

Suban el controlador central al repositorio del equipo. En la revisión de la semana 9 les pregunto por la lógica de arbitraje.
