---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 2 - La primera señal del sensor (U1)

La semana pasada dibujamos el bucle completo: **sensor -> modelo -> actuador**. Esta semana construyes la primera flecha, la que va del sensor a Python. Todavía no hay modelo ni actuador: hoy la meta es que una señal del mundo físico llegue viva hasta tu computadora y la puedas ver.

Suena modesto, pero es el cimiento de todo lo demás. Un modelo de aprendizaje de máquina no puede ser mejor que los datos con los que lo entrenas, y esos datos van a salir justo de aquí. Si tu señal llega ruidosa, cortada o mal medida, ningún algoritmo lo va a arreglar después.

---

## Antes de la clase (aprendizaje invertido)

Lee esta sección con calma antes de la sesión. En clase la vamos a usar para conectar tu sensor y ver su señal por primera vez.

### El reparto de papeles: Arduino y Python

Una pregunta razonable antes de empezar: si el Arduino ya lee el sensor, ¿para qué necesitamos Python?

Porque cada uno sabe hacer cosas que el otro no:

| | Arduino Nano | Python en tu computadora |
|---|---|---|
| Toca el hardware | Sí, tiene los pines | No |
| Responde en tiempo constante | Sí | No con precisión |
| Guarda miles de lecturas | No, tiene 2 KB de RAM | Sí, sin problema |
| Entrena un modelo | No, imposible | Sí |

El Arduino tiene **2 KB de memoria RAM**. Tu dataset de la semana que viene va a tener miles de lecturas, y entrenar un modelo requiere recorrerlas muchas veces. Eso simplemente no cabe ahí.

Así que el reparto queda así, y se mantiene todo el semestre:

```
   ARDUINO                          PYTHON
   +---------------+                +------------------+
   | lee el sensor | --- serial --> | guarda, procesa, |
   | acciona el    | <-- serial --- | entrena, decide  |
   | actuador      |                |                  |
   +---------------+                +------------------+
     el musculo                       el cerebro
```

El Arduino es el músculo: toca el mundo físico. Python es el cerebro: recuerda, aprende y decide. Y el cable USB entre los dos es el sistema nervioso. Esta semana solo construimos la flecha de ida (sensor -> Python). La flecha de regreso, la que acciona el actuador, la cerramos en la semana 8.

### El puerto serial: un canal de texto

El Arduino y Python se comunican por el **puerto serial**, que va montado sobre el mismo cable USB con el que programas la tarjeta.

Hay una cosa que conviene tener clara desde el principio, porque es fuente de confusión: **por el puerto serial no viajan números, viajan caracteres**. Cuando en el Arduino escribes `Serial.println(512)`, no se mandan los bits del número 512. Se mandan cuatro caracteres: `5`, `1`, `2` y un salto de línea. Del otro lado, Python recibe el texto `"512\n"` y **tú tienes que convertirlo a número**. Ese paso de conversión es responsabilidad tuya, y si se te olvida, terminas sumando textos en vez de valores.

Para que ambos lados se entiendan tienen que estar de acuerdo en la **velocidad**, medida en baudios. Si el Arduino manda a una velocidad y Python escucha a otra, no recibes un error: recibes basura, símbolos sin sentido. Es de los errores más comunes de la semana.

En este curso usaremos **115200 baudios** en lugar de los 9600 típicos. La razón es que vamos a muestrear señales rápido, y a 9600 baudios el canal se satura y empieza a perder lecturas. Con 115200 tienes margen de sobra.

### El protocolo: una lectura por línea

Necesitamos que los datos lleguen con una forma predecible. La convención que usaremos todo el semestre es simple: **una lectura por línea, y si hay varios sensores, separados por comas**.

Con un solo sensor:

```
512
518
530
...
```

Con tres sensores:

```
512,23.4,1
518,23.4,1
530,23.5,0
...
```

Es el mismo formato de un archivo CSV, y no es casualidad: la semana que viene vamos a guardar exactamente esto en `datos.csv`. Al elegir hoy este formato, la próxima semana no tienes que cambiar nada.

Una regla importante: **el Arduino manda solo datos, nunca mensajes para humanos**. Nada de `Serial.println("Leyendo sensor...")`. Ese texto también llega por el mismo canal y rompe a Python cuando intente convertirlo a número. Si necesitas depurar, usa el Monitor Serie del Arduino IDE, pero quita esos mensajes antes de conectar Python.

### pyserial en cuatro pasos

La biblioteca **pyserial** es la que deja a Python leer ese canal. Lo esencial son cuatro pasos:

**1. Abrir el puerto.** Necesitas su nombre (`COM3` en Windows, `/dev/ttyUSB0` en Linux, algo como `/dev/tty.usbserial-XXXX` en macOS) y la misma velocidad que pusiste en el Arduino:

```python
import serial
ser = serial.Serial('/dev/ttyUSB0', 115200, timeout=1)
```

**2. Esperar dos segundos.** Esto sorprende a todo el mundo la primera vez: **abrir el puerto reinicia el Arduino**. Si empiezas a leer de inmediato, las primeras líneas llegan cortadas o vacías porque la tarjeta apenas está arrancando. Se resuelve esperando:

```python
import time
time.sleep(2)
```

**3. Leer una línea y convertirla.** `readline()` devuelve *bytes*, no texto, así que hay que decodificarlos, quitarles el salto de línea y recién entonces convertirlos a número:

```python
linea = ser.readline().decode('utf-8').strip()
valor = float(linea)
```

**4. Cerrar el puerto** al terminar, con `ser.close()`. Si no lo cierras, el puerto queda ocupado y la siguiente ejecución falla con un error de permiso o de puerto en uso. Si te pasa, cierra el Monitor Serie del Arduino IDE (que también ocupa el puerto) y vuelve a intentar.

Un detalle que te va a ahorrar corajes: **de vez en cuando llega una línea incompleta**, sobre todo la primera. No es un bug tuyo, es normal en comunicación serial. Por eso conviene envolver la conversión en un `try` y simplemente ignorar lo que no se pueda convertir:

```python
try:
    valor = float(linea)
except ValueError:
    continue   # linea incompleta o basura, la saltamos
```

### La frecuencia de muestreo

En el Arduino, el `delay()` al final del `loop()` decide cada cuánto tomas una lectura. Ese intervalo define la **frecuencia de muestreo**: cuántas muestras por segundo obtienes.

```
delay(10)   ->  una lectura cada 10 ms   ->  100 muestras por segundo (100 Hz)
delay(100)  ->  una lectura cada 100 ms  ->  10 muestras por segundo  (10 Hz)
```

Elegir bien este número importa más de lo que parece. Si muestreas **demasiado lento**, la pieza pasa entre dos lecturas y te pierdes el evento completo: en tu CSV no queda rastro de que algo pasó. Si muestreas **demasiado rápido**, generas montañas de datos casi idénticos que no aportan información y sí hacen más lento todo lo demás.

La regla práctica para esta semana: **necesitas al menos 20 o 30 muestras mientras la pieza cruza frente al sensor**. Si tu pieza tarda medio segundo en pasar, 100 Hz te da unas 50 muestras, que está bien. Si tarda apenas una décima de segundo, vas a necesitar muestrear más rápido.

En la semana 6, cuando veamos frecuencia, vamos a volver sobre esto con más rigor. Por ahora quédate con la idea de que **la frecuencia de muestreo es una decisión de diseño, no un número que se pone al azar**.

### Una señal no es un número: es una forma

Este es el concepto central de la semana, y el que cambia cómo vas a pensar tu proyecto.

Cuando mides temperatura con un LM35, un solo valor te dice algo útil: 24 grados. Pero cuando una pieza cruza frente a tu sensor, **el valor aislado no significa nada**. Lo que identifica a la pieza es cómo cambia la lectura a lo largo del tiempo: cuánto baja, qué tan rápido, cuánto dura, si tiene uno o dos valles.

```
valor
  ^
  |  ----\             /------      <- sin pieza: valor de reposo
  |       \           /
  |        \_________/              <- la pieza esta pasando
  |
  +----------------------------> tiempo
        |<-- el evento -->|
```

A ese tramo de señal que contiene el evento completo le llamamos **ventana**, y es la unidad de trabajo del resto del curso. Tu dataset de la semana 3 no va a tener lecturas sueltas: va a tener **una ventana por cada vez que pasó una pieza**, con su etiqueta. Y en la semana 5 vas a convertir cada ventana en unos cuantos números que la describen.

Por eso hoy no basta con ver que el sensor responde. Lo que buscas es **reconocer la forma del evento**: dónde empieza, dónde termina, y si tus tres tipos de pieza dibujan formas distinguibles. Esa observación de hoy es la que hace posible todo lo demás.

---

## Durante la clase (aprendizaje activo)

Traes tu Arduino, tu sensor y tus piezas. Trabajamos en tres momentos:

**1. Que llegue el primer dato.** Cargas `sensor.ino`, corres `leer_sensor.py` y logras que los números aparezcan en la terminal. Aquí es donde salen los tropiezos clásicos: el puerto equivocado, la velocidad que no coincide, el Monitor Serie abierto ocupando el puerto. Los resolvemos entre todos, porque son los mismos que te van a volver a aparecer todo el semestre.

**2. Ver la forma del evento.** Con el sensor ya leyendo, pasas una pieza y graficas la ventana. Ajustas la posición del sensor, la distancia y el `delay()` hasta que el evento se vea claro y completo. No sirve una señal que apenas se mueve ni una que se sale de rango.

**3. Comparar tus tres tipos.** Capturas una ventana de cada tipo de pieza y las graficas juntas. Aquí viene la pregunta que nos vamos a llevar a la semana 3: **¿se distinguen a simple vista?** Si dos de tus tipos dibujan la misma forma, tienes un problema de diseño que es mejor descubrir hoy que en la semana 7, cuando el modelo no logre separarlos. La solución suele ser mover el sensor, cambiarlo o agregar un segundo sensor que mida otra cosa.

---

## Avance de tu proyecto esta semana

### Conecta tu sensor

Elige el sensor con el que vas a trabajar y conéctalo. Según el tipo de salida, así se lee:

| Tipo de salida | Sensores | Cómo se lee en Arduino |
|---|---|---|
| Analógica | LM35, LDR, GP2Y0A21YK0F | `analogRead(A0)`, devuelve 0 a 1023 |
| Digital | A3144 | `digitalRead(2)`, devuelve 0 o 1 |
| Por pulso | HC-SR04 | `pulseIn()` sobre el pin de eco |

Si vas a usar otro de los sensores disponibles, revisa en su hoja de datos cuál de estos tres casos le corresponde.

Un consejo sobre la elección: **un sensor digital como el A3144 te da solo dos valores**, así que su "señal" es un escalón, no una forma rica. Sirve muy bien combinado con otro sensor, pero él solo te va a dar poca información para clasificar tres tipos. Si tu dominio lo permite, empieza con uno analógico.

### Prácticas

1. **Programa `sensor.ino`.** Este código está completo, solo ajusta el pin y el `delay()` a tu caso:

   ```cpp
   // sensor.ino - envia la lectura del sensor por el puerto serial
   // Formato: un valor por linea. Sin mensajes de texto.

   const int PIN_SENSOR = A0;

   void setup() {
     Serial.begin(115200);
   }

   void loop() {
     int valor = analogRead(PIN_SENSOR);
     Serial.println(valor);
     delay(10);            // 10 ms -> 100 muestras por segundo
   }
   ```

   Antes de pasar a Python, ábrelo en el Monitor Serie del Arduino IDE (a 115200) y confirma que los números cambian cuando acercas la pieza. **Cierra el Monitor Serie antes de correr Python**, o el puerto estará ocupado.

2. **Escribe `leer_sensor.py`.** Te dejo lista la parte nueva del tema (la lectura serial). La parte de graficar ya la sabes hacer de cursos anteriores, esa la completas tú:

   ```python
   # leer_sensor.py - lee la señal del sensor y grafica una ventana
   import serial
   import time
   import matplotlib.pyplot as plt

   PUERTO = '/dev/ttyUSB0'   # Windows: 'COM3'
   BAUDIOS = 115200
   N_MUESTRAS = 200          # con delay(10) son unos 2 segundos

   ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
   time.sleep(2)             # el Arduino se reinicia al abrir el puerto

   valores = []
   print("Leyendo... pasa la pieza frente al sensor")

   while len(valores) < N_MUESTRAS:
       linea = ser.readline().decode('utf-8').strip()
       try:
           valor = float(linea)
       except ValueError:
           continue          # linea incompleta, la saltamos
       valores.append(valor)
       print(valor)          # para ver la señal en vivo

   ser.close()
   print(f"Listas {len(valores)} muestras")

   # TODO: graficar 'valores' con matplotlib
   # pista: plt.plot(), etiqueta los ejes (muestra y valor del sensor)
   #        y guarda la figura con plt.savefig('senal.png')
   ```

3. **Captura la señal de tus tres tipos de pieza.** Corre el script una vez por cada tipo, pasando la pieza mientras lee, y guarda las tres gráficas en tu repositorio.

4. **Grafica las tres juntas** en una sola figura para compararlas. Esta gráfica es la evidencia principal de la semana.

5. **Escribe tu entrada de `BITACORA.md`** y haz push. Responde con tus palabras:

   - Qué mide tu sensor y qué le pasa a la señal cuando la pieza pasa.
   - Qué frecuencia de muestreo elegiste y por qué (cuántas muestras alcanzas a tomar mientras la pieza cruza).
   - Si tus tres tipos de pieza se distinguen a simple vista, y si no, qué vas a cambiar.

   ```bash
   git add .
   git commit -m "semana 2: lectura de la señal del sensor desde Python"
   git push
   ```

### Proyecto integrador

Con tu equipo, comparen las señales que capturó cada quien. Dos cosas que decidir:

1. **Si sus sensores se estorban entre sí.** Dos sensores infrarrojos apuntando cerca uno del otro se interfieren, y un motor cerca de un sensor Hall mete ruido. Es mejor detectarlo ahora que cuando ya estén montados sobre la banda.
2. **Un formato común de línea.** Si desde hoy los tres módulos mandan sus datos con el mismo formato (`valor1,valor2,valor3`), el controlador central de la Unidad 2 va a poder leerlos a todos con el mismo código. Anótenlo en el README del equipo.
