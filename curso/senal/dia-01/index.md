---
layout: default
title: De la señal a la decisión
---
[Inicio](/curso/senal)

# Sesión 1 - Del sensor a los datos

Hoy construyes la primera mitad del sistema: la que va **del mundo físico a un archivo**. Un sensor mira una pieza, el Arduino convierte lo que ve en números, Python los recibe y tú los guardas etiquetados.

Al final de estas tres horas tienes un archivo `datos.csv` con cientos de lecturas de tus tres piezas. Eso es un **dataset**, y es lo único que hace falta para que mañana un modelo aprenda a distinguirlas. Hoy no hay modelo todavía.

---

- [Antes de empezar](#antes-de-empezar)
- [Bloque 1: el circuito](#circuito)
- [Bloque 2: sensor.ino y el Monitor Serie](#sensor-ino)
- [Bloque 3: leer_sensor.py, la señal en Python](#leer-sensor)
- [Bloque 4: adquirir.py y tu dataset](#adquirir)
- [Con lo que te vas](#cierre)

---

## Antes de empezar {#antes-de-empezar}

Crea una carpeta llamada `taller` en tu Escritorio y **copia ahí los archivos de la memoria USB**. Todo el trabajo de los dos días pasa dentro de esa carpeta, sin subcarpetas: los programas, los datos y el modelo viven juntos.

Ábrele el CMD con el truco de la barra de direcciones, tal como viene en [la guía previa](/curso/senal/requisitos/#abrir-cmd): escribes `cmd` en la barra del explorador y presionas Enter.

Deja esa ventana del CMD abierta toda la sesión. Es desde donde se ejecuta todo.

| | Bloque | Terminas con |
|---|---|---|
| 1 | El circuito | Los dos sensores montados en el protoboard |
| 2 | `sensor.ino` y el Monitor Serie | Los números moviéndose cuando acercas la mano |
| 3 | `leer_sensor.py` | La señal dibujándose en vivo en una gráfica |
| 4 | `adquirir.py` | `datos.csv` con tus tres piezas |

---

## Bloque 1: el circuito {#circuito}

Dos sensores, y los dos miden lo mismo (cuánta luz les llega) de maneras distintas. Esa diferencia es el tema de la sesión.

**Desconecta el Arduino de la computadora antes de cablear.** Se conecta cuando el circuito ya está armado y revisado.

### El TCRT5000

Es un módulo de cuatro patas. Trae su propio emisor infrarrojo apuntando hacia afuera y un receptor al lado: manda luz, mide cuánta le rebota.

| Pata del módulo | Va a |
|---|---|
| `VCC` | `5V` del Arduino |
| `GND` | `GND` del Arduino |
| `A0` (o `AO`) | `A0` del Arduino |
| `D0` (o `DO`) | No se conecta |

El tornillito azul del módulo ajusta **la salida digital**, que no vamos a usar. No lo muevas.

### El LDR

Es una fotorresistencia: una resistencia que cambia de valor según la luz que le da. Como el Arduino no mide resistencias, sino voltajes, hay que armarle un **divisor de voltaje** con la resistencia de 10k.

| Conexión | |
|---|---|
| Una pata del LDR | `5V` |
| La otra pata del LDR | al pin `A1` **y también** a una pata de la resistencia de 10k |
| La otra pata de la resistencia de 10k | `GND` |

El punto donde se juntan el LDR y la resistencia es el que lee `A1`. Si el LDR y la resistencia no se tocan en ese punto, el pin va a leer basura.

### Antes de conectar el USB

Revisa tres cosas, en este orden:

1. Que no haya ningún cable entre `5V` y `GND` directo.
2. Que el TCRT5000 esté en `5V` y `GND`, no al revés.
3. Que las patas del Arduino coincidan con lo que dice la tabla, contando desde el extremo de la tarjeta.

Ya revisado, conecta el cable USB.

---

## Bloque 2: sensor.ino y el Monitor Serie {#sensor-ino}

Este es el programa que corre **dentro del Arduino**. Lo único que hace es leer los dos sensores y escribir el par de números por el cable USB, cien veces por segundo.

```cpp
// sensor.ino - manda por el puerto serie la lectura de los dos sensores
// Formato: tcrt,ldr  (un par por linea, sin mensajes de texto)

const int PIN_TCRT = A0;
const int PIN_LDR  = A1;

void setup() {
  Serial.begin(115200);
}

void loop() {
  int tcrt = analogRead(PIN_TCRT);
  int ldr  = analogRead(PIN_LDR);

  Serial.print(tcrt);
  Serial.print(',');
  Serial.println(ldr);

  delay(10);            // 10 ms -> 100 muestras por segundo
}
```

Ábrelo en el Arduino IDE, revisa que en Herramientas estén tu placa, tu procesador y tu puerto COM, y súbelo con el botón de la flecha.

`analogRead` devuelve un número **entre 0 y 1023**. No es voltios ni centímetros: es lo que el convertidor del Arduino mide en ese pin. Para clasificar piezas no necesitamos convertirlo a nada, solo que sea distinto para cada pieza.

### Mira los números

Abre el **Monitor Serie** (la lupa, arriba a la derecha) y pon la velocidad en **115200** en la esquina de abajo. Si ves basura, es que quedó en otra velocidad.

Vas a ver dos números por línea corriendo rápido. Ahora:

1. Acerca la mano al TCRT5000 y aléjala. **El primer número se mueve.**
2. Tapa el LDR con el dedo. **El segundo número se mueve.**
3. Pon la cartulina blanca sobre el sensor, luego la negra, luego el aluminio.

Si el número **sube o baja** al acercar la mano depende de cómo esté armado tu módulo, y da exactamente igual. Lo único que importa es que sea **distinto** para cada pieza.

Ahora la prueba que explica por qué hay dos sensores: **haz sombra sobre el circuito con la mano, sin tocar nada.** El número del LDR cambia mucho. El del TCRT casi no. El TCRT trae su propia luz, así que le da igual la del aula; el LDR mide la luz que haya, y en el aula la hay distinta según la hora y según quién pase por ahí.

Por eso el modelo de mañana va a trabajar con el TCRT.

### Antes de seguir

**Cierra el Monitor Serie.** El puerto COM lo usa un programa a la vez: si lo dejas abierto, Python no va a poder leerlo y el error va a decir "acceso denegado", que no ayuda nada.

---

## Bloque 3: leer_sensor.py, la señal en Python {#leer-sensor}

Los mismos números, pero ahora llegando a tu computadora y dibujándose solos.

```python
# leer_sensor.py - grafica en vivo la senal de los dos sensores
import serial
import time
from collections import deque
import matplotlib.pyplot as plt

PUERTO = 'COM3'           # cambia este por el tuyo
BAUDIOS = 115200
N_VISIBLES = 200          # cuantas muestras se ven a la vez: 2 segundos

ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
time.sleep(2)             # el Arduino se reinicia al abrir el puerto
ser.reset_input_buffer()

tcrt = deque([0] * N_VISIBLES, maxlen=N_VISIBLES)
ldr  = deque([0] * N_VISIBLES, maxlen=N_VISIBLES)

plt.ion()
figura, ejes = plt.subplots()
linea_tcrt, = ejes.plot(tcrt, label='TCRT5000')
linea_ldr,  = ejes.plot(ldr,  label='LDR')
ejes.set_ylim(0, 1023)
ejes.set_xlabel('muestra')
ejes.set_ylabel('lectura (0 a 1023)')
ejes.legend()

print("Pasa las piezas frente al sensor. Cierra la ventana para terminar.")

n = 0
while plt.fignum_exists(figura.number):
    linea = ser.readline().decode('utf-8').strip()
    partes = linea.split(',')
    if len(partes) != 2:
        continue          # linea incompleta, la saltamos
    try:
        tcrt.append(int(partes[0]))
        ldr.append(int(partes[1]))
    except ValueError:
        continue

    n += 1
    if n % 10 == 0:       # redibujar cada 10 muestras, no cada una
        linea_tcrt.set_ydata(tcrt)
        linea_ldr.set_ydata(ldr)
        figura.canvas.draw_idle()
        plt.pause(0.001)

ser.close()
print("Listo")
```

**Cambia `PUERTO` por el tuyo** (el que anotaste del Administrador de dispositivos) y córrelo desde el CMD:

```
python leer_sensor.py
```

Se abre una ventana con dos líneas moviéndose de derecha a izquierda. Pon las tres piezas, una por una, y mira los escalones.

### Qué acaba de pasar

Esas tres líneas de arriba son todo el mecanismo:

```python
ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
linea = ser.readline().decode('utf-8').strip()
partes = linea.split(',')
```

Python abre el mismo puerto COM que usaba el Monitor Serie, lee una línea de texto, la parte por la coma y se queda con dos números. Nada más. El Arduino no sabe que del otro lado hay un programa distinto.

El `time.sleep(2)` no es adorno: al abrir el puerto, el Arduino **se reinicia**. Sin esa pausa, las primeras lecturas llegan cortadas.

### Prueba esto

Cambia `N_VISIBLES` a `50` y vuelve a correrlo. La ventana ahora muestra medio segundo, así que la misma señal se ve mucho más rápida. Ese número es el que decide cuánto pasado ves de una sola vez.

---

## Bloque 4: adquirir.py y tu dataset {#adquirir}

Ver la señal no sirve para entrenar nada. Para eso hay que **guardarla, etiquetada**: doscientos números y, al lado, de qué pieza salieron.

A cada bloque de 200 muestras le vamos a llamar **ventana**. Una ventana son 2 segundos de una pieza quieta frente al sensor.

```python
# adquirir.py - captura ventanas etiquetadas y las guarda en datos.csv
import serial
import time
import csv
import os

PUERTO = 'COM3'           # cambia este por el tuyo
BAUDIOS = 115200
N_MUESTRAS = 200          # largo de cada ventana: 2 segundos
ARCHIVO = 'datos.csv'

etiqueta = input("Etiqueta de esta pieza (blanca, negra o aluminio): ")
n_ventanas = int(input("Cuantas ventanas vas a capturar: "))

# si ya habias capturado antes, seguimos numerando donde nos quedamos
es_nuevo = not os.path.exists(ARCHIVO)
ventana = 0
if not es_nuevo:
    with open(ARCHIVO) as f:
        for fila in csv.DictReader(f):
            ventana = max(ventana, int(fila['ventana']) + 1)

ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
time.sleep(2)             # el Arduino se reinicia al abrir el puerto

archivo = open(ARCHIVO, 'a', newline='')
escritor = csv.writer(archivo)
if es_nuevo:
    escritor.writerow(['ventana', 't', 'tcrt', 'ldr', 'etiqueta'])

for i in range(n_ventanas):
    input(f"\nVentana {ventana} ({etiqueta}). Pon la pieza y presiona Enter...")
    ser.reset_input_buffer()          # tira lo que se acumulo mientras esperabas

    t = 0
    while t < N_MUESTRAS:
        linea = ser.readline().decode('utf-8').strip()
        partes = linea.split(',')
        if len(partes) != 2:
            continue
        try:
            tcrt, ldr = int(partes[0]), int(partes[1])
        except ValueError:
            continue
        escritor.writerow([ventana, t, tcrt, ldr, etiqueta])
        t += 1

    print(f"  {N_MUESTRAS} muestras guardadas")
    ventana += 1

archivo.close()
ser.close()
print(f"\nListo. Datos en {ARCHIVO}")
```

### Cómo se captura

**La pieza va apoyada directamente sobre el sensor, plana y quieta.** No se pasa por enfrente, no se mueve durante los 2 segundos. Lo que estamos midiendo es cuánta luz rebota en ese material, y para eso la distancia tiene que ser siempre la misma.

Córrelo **tres veces**, una por pieza, con **10 ventanas** cada vez:

```
python adquirir.py
```

- Primera corrida: etiqueta `blanca`, 10 ventanas.
- Segunda corrida: etiqueta `negra`, 10 ventanas.
- Tercera corrida: etiqueta `aluminio`, 10 ventanas.

Escribe las etiquetas **exactamente así**, en minúsculas y sin acentos. Para el programa de mañana, `blanca` y `Blanca` son dos piezas distintas.

Entre ventana y ventana, **levanta la pieza y vuelve a ponerla**. Si la dejas puesta las 10 veces vas a capturar diez copias de lo mismo, y el modelo de mañana va a aprender esa posición en vez de aprender el material.

Usa tus tres trozos de cada material, no siempre el mismo. Las diferencias entre trozos son justo lo que el modelo tiene que aprender a ignorar.

### Revisa lo que quedó

Ábrelo desde el CMD:

```
code datos.csv
```

Tiene que tener un encabezado y **6000 filas** de datos: 30 ventanas de 200 muestras. Las columnas son `ventana`, `t`, `tcrt`, `ldr`, `etiqueta`.

Si algo salió mal (una etiqueta con error de dedo, una ventana que capturaste con la pieza equivocada), **borra `datos.csv` y vuelve a empezar**. Son seis minutos. Arrastrar datos malos al día 2 cuesta mucho más caro.

---

## Con lo que te vas {#cierre}

En tu carpeta `taller` tienes ahora un archivo `datos.csv` con 6000 mediciones tuyas, tomadas con tus manos, de tres materiales distintos.

Ese archivo es lo único que vas a necesitar mañana. No lo borres, y no dejes la carpeta en una computadora del laboratorio.

Mañana, en cuatro horas, esos 6000 números se van a convertir en cuatro reglas que deciden solas qué pieza tienen enfrente.
