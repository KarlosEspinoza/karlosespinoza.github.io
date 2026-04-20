---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)

# Observa una variable

Aquí todavía no hay Arduino.
Solo una variable escrita a mano.

```python
luz = 250
print("Nivel de luz:", luz)
```

## Qué se construye aquí

Un primer programa que **lee una variable interna y la muestra**.

## Conceptos que caben aquí

* Syntax
* Output
* Comments
* Variables
* Data Types
* Numbers

---

# Decide algo con esa variable

Ahora ya no solo muestra, sino que decide.

```python
luz = 250

if luz < 300:
    print("Encender LED")
else:
    print("Apagar LED")
```

## Qué se construye aquí

Ya tienes un **observador + tomador de decisiones**.

## Conceptos que caben aquí

* Booleans
* Operators
* If...Else

---

# Convierte la decisión en una función

Aquí haces explícito que la decisión del sistema es una función.

$$
u = f(x)
$$

**Nombre de la ecuación:** función de decisión.
**Objetivo:** separar la lógica del sistema del resto del código.

Donde:

* $x$: entrada, por ejemplo la luz.
* $f$: regla de decisión.
* $u$: salida, por ejemplo `LED_ON`.

```python
def evaluar_luz(luz):
    if luz < 300:
        return "LED_ON"
    else:
        return "LED_OFF"

accion = evaluar_luz(250)
print(accion)
```

## Qué se construye aquí

Ahora el programa ya tiene una **pieza reutilizable**.

## Conceptos que caben aquí

* Functions
* Strings
* Return values

---

# Prueba muchos valores

Ahora el estudiante ve que la función sirve para más de una medición.

```python
lecturas = [250, 320, 280, 500]

for luz in lecturas:
    accion = evaluar_luz(luz)
    print("Luz:", luz, "->", accion)
```

## Qué se construye aquí

Un **simulador básico** del sistema.

## Conceptos que caben aquí

* Lists
* For Loops
* Range
* Arrays como listas

---

# Trabaja continuamente

Ahora ya se parece más a un sistema real: no corre una vez, sino en tiempo continuo.

$$
x(k+1) \leftarrow \text{nueva lectura}
$$

**Objetivo:** introducir la lógica de operación repetitiva del sistema.

Donde:

* $k$: instante discreto.
* $x(k+1)$: nueva medición.

```python
contador = 0

while contador < 5:
    luz = 250 + contador * 20
    accion = evaluar_luz(luz)
    print("Luz:", luz, "->", accion)
    contador += 1
```

## Qué se construye aquí

Un sistema que **observa y decide repetidamente**.

## Conceptos que caben aquí

* While Loops
* Numbers
* Operators

---

# Usar varias variables

Aquí entra el salto importante: dejar de pensar en un solo sensor.

En lugar de:

```python
luz = 250
```

pasas a:

```python
datos = {
    "luz": 250,
    "temp": 27,
    "dist": 18
}
```

## Por qué esta etapa sí tiene sentido

Porque el formato serial real del Arduino normalmente llegará como un conjunto de datos, no como una sola variable. Entonces esta etapa ya prepara directamente para eso.

## Ejemplo

```python
datos = {
    "luz": 250,
    "temp": 27,
    "dist": 18
}

print(datos["luz"])
print(datos["temp"])
print(datos["dist"])
```

## Qué se construye aquí

El estudiante empieza a trabajar con una **representación estructurada del sistema**.

## Conceptos que caben aquí

* Dictionaries
* Keys and values
* Data organization

---

# Decide con varias variables

Ahora la función ya no recibe una sola variable, sino un diccionario completo.

$$
u = f(\text{luz}, \text{temp}, \text{dist})
$$

**Objetivo:** pasar de un sistema monovariable a uno multivariable.

```python
def evaluar_sistema(datos):
    if datos["dist"] < 10:
        return "BUZZER_ON"
    elif datos["temp"] > 30:
        return "BUZZER_ON"
    elif datos["luz"] < 300:
        return "LED_ON"
    else:
        return "IDLE"

datos = {
    "luz": 250,
    "temp": 27,
    "dist": 18
}

accion = evaluar_sistema(datos)
print(accion)
```

## Qué se construye aquí

Ahora sí tienes casi la lógica final del sistema.

## Conceptos que caben aquí

* Dictionaries
* If...Else
* Functions
* Booleans
* Operators

---

# Recibe datos como texto

Aquí viene la transición crucial hacia serial.
Arduino no manda un diccionario de Python. Manda texto.

Por ejemplo:

```text
LUZ:250,TEMP:27,DIST:18
```

Entonces antes de usar serial real, practican con una cadena escrita a mano.

```python
linea = "LUZ:250,TEMP:27,DIST:18"
print(linea)
```

Luego la separan.

```python
partes = linea.split(",")
print(partes)
```

Y la convierten a diccionario.

```python
def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        clave, valor = parte.split(":")
        datos[clave.lower()] = int(valor)

    return datos

linea = "LUZ:250,TEMP:27,DIST:18"
datos = parsear_datos(linea)
print(datos)
```

## Qué se construye aquí

Esta etapa sí conecta directamente con serial, porque **parsear una cadena es exactamente lo que harán cuando lean del puerto**.

## Conceptos que caben aquí

* Strings
* Casting
* Split
* For
* Dictionaries
* Functions

---

# Programa completo pero aún sin serial real

Aquí unes todo:

1. una línea de texto
2. parseo a diccionario
3. evaluación del sistema
4. impresión de la acción

```python
def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        clave, valor = parte.split(":")
        datos[clave.lower()] = int(valor)

    return datos

def evaluar_sistema(datos):
    if datos["dist"] < 10:
        return "BUZZER_ON"
    elif datos["temp"] > 30:
        return "BUZZER_ON"
    elif datos["luz"] < 300:
        return "LED_ON"
    else:
        return "IDLE"

linea = "LUZ:250,TEMP:27,DIST:18"
datos = parsear_datos(linea)
accion = evaluar_sistema(datos)

print("Datos:", datos)
print("Acción:", accion)
```

## Qué se construye aquí

Ya tienen el programa lógico completo.
Solo falta sustituir la línea escrita manualmente por una línea leída desde serial.

---

# Sustituir la línea manual por lectura serial

Consulta el apartado de [hardware](hardware) para consultar como esta el circuito y el programa del Arduino.
Sin el systema funcionando correctamente no funcionara este apartado.

Antes tenían:

```python
linea = "LUZ:250,TEMP:27,DIST:18"
```

Ahora tienen:

```python
linea = arduino.readline().decode().strip()
```

Ese cambio hace que sientan que **todo lo anterior sí sirvió**.

```python
import serial
import time

arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
time.sleep(2)

def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        clave, valor = parte.split(":")
        datos[clave.lower()] = int(valor)

    return datos

def evaluar_sistema(datos):
    if datos["dist"] < 10:
        return "BUZZER_ON"
    elif datos["temp"] > 30:
        return "BUZZER_ON"
    elif datos["luz"] < 300:
        return "LED_ON"
    else:
        return "IDLE"

while True:
    linea = arduino.readline().decode().strip()

    if linea:
        datos = parsear_datos(linea)
        accion = evaluar_sistema(datos)

        print("Datos:", datos)
        print("Acción:", accion)
```

---

# Enviar el comando al Arduino

Ahora se cierra el lazo.

$$
u(k) = f(x(k))
$$

**Objetivo:** que la decisión calculada por Python se convierta en una acción física.

```python
arduino.write((accion + "\n").encode())
```

Programa completo:

```python
import serial
import time

arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
time.sleep(2)

def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        clave, valor = parte.split(":")
        datos[clave.lower()] = int(valor)

    return datos

def evaluar_sistema(datos):
    if datos["dist"] < 10:
        return "BUZZER_ON"
    elif datos["temp"] > 30:
        return "BUZZER_ON"
    elif datos["luz"] < 300:
        return "LED_ON"
    else:
        return "IDLE"

while True:
    linea = arduino.readline().decode().strip()

    if linea:
        datos = parsear_datos(linea)
        accion = evaluar_sistema(datos)

        print("Datos:", datos)
        print("Acción:", accion)

        arduino.write((accion + "\n").encode())

    time.sleep(0.2)
```

---

