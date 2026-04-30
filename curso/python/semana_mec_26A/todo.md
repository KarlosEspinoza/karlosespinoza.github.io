---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)

# Syntax

## Idea

Que entiendan la estructura mínima de un programa en Python.

## Micropráctica

Crear un primer script que imprima un mensaje del sistema.

```python
print("Sistema de monitoreo iniciado")
```



# Output

## Idea

Mostrar información al usuario.

## Micropráctica

Imprimir valores representativos del sistema.

```python
print("Sensor de luz:", 350)
print("Temperatura:", 27)
print("Distancia:", 18)
```



# Comments

## Idea

Documentar el código.

## Micropráctica

Agregar comentarios explicando qué hace cada parte.

```python
# Este script muestra datos iniciales del sistema
print("Sistema listo")

# Aquí simulamos una lectura de luz
print("Luz:", 350)
```



# Variables

## Idea

Guardar información para usarla después.

## Micropráctica

```python
luz = 350
temperatura = 27
distancia = 18

print(luz)
print(temperatura)
print(distancia)
```

## Ecuación asociada

$
x = \text{valor medido}
$

**Objetivo:** representar que una variable almacena una medición del sistema.

Donde:

* (x): variable en el programa.
* (\text{valor medido}): dato del sensor.



# Data Types

## Idea

Reconocer que no todo dato es del mismo tipo.

## Micropráctica

```python
luz = 350              # int
temperatura = 27.5     # float
estado = "activo"      # str
alarma = True          # bool

print(type(luz))
print(type(temperatura))
print(type(estado))
print(type(alarma))
```

### Recuerda

* `int`, `float`, `str`, `bool`.



# Numbers

## Idea

Operar numéricamente con mediciones.

## Micropráctica

```python
temperatura = 27.5
incremento = 2
nueva_temperatura = temperatura + incremento

print("Temperatura ajustada:", nueva_temperatura)
```

## Ecuación asociada

$
T_{ajustada} = T + \Delta T
$

**Objetivo:** mostrar operación numérica sobre una variable física.

Donde:

* $T$: temperatura original.
* $\Delta T$: incremento aplicado.
* $T_{ajustada}$: resultado.



# Casting

## Idea

Convertir tipos de datos.

## Micropráctica

Simular que Arduino envía un valor como texto.

```python
dato_serial = "350"
luz = int(dato_serial)

print(luz)
print(type(luz))
```

## Ecuación asociada

$
x_{numérico} = \text{cast}(x_{texto})
$

**Objetivo:** transformar datos crudos en datos utilizables.



# Strings

## Idea

Manipular mensajes que vienen del sistema.

## Micropráctica

```python
mensaje = "LUZ:350"
print(mensaje)

partes = mensaje.split(":")
print(partes)
print("Variable:", partes[0])
print("Valor:", partes[1])
```



# Booleans

## Idea

Representar estados lógicos del sistema.

## Micropráctica

```python
luz = 250
es_oscuro = luz < 300

print(es_oscuro)
print(type(es_oscuro))
```

## Ecuación asociada

$$
b =
\begin{cases}
\text{True} & \text{si } x < 300 \\
\text{False} & \text{si } x \ge 300
\end{cases}
$$

**Objetivo:** modelar una condición lógica.

Donde:

* $x$: valor de luz.
* $b$: estado booleano.



# Operators

### Idea

Usar operadores aritméticos, relacionales y lógicos.

## Micropráctica

```python
luz = 250
temp = 31

print(luz + 50)
print(temp > 30)
print(luz < 300 and temp > 25)
```

## Recordar

* `+`, `-`, `*`, `/`
* `<`, `>`, `==`
* `and`, `or`, `not`



# Lists

## Idea

Guardar varias lecturas.

## Micropráctica

```python
lecturas_luz = [320, 300, 280, 260, 250]

print(lecturas_luz)
print("Primera lectura:", lecturas_luz[0])
print("Última lectura:", lecturas_luz[-1])
```

## Ecuación asociada

$
L = [x_1, x_2, x_3, \dots, x_n]
$

**Objetivo:** representar un conjunto ordenado de lecturas.

Donde:

* $L$: lista de datos.
* $x_i$: lectura $i$-ésima.



# Tuples

## Idea

Guardar configuraciones fijas.

## Micropráctica

```python
puertos_validos = ("COM3", "COM4", "/dev/ttyUSB0")
print(puertos_validos)
print(puertos_validos[0])
```

## Recordar

* Una tupla es ordenada pero inmutable.



# Sets

## Idea

Eliminar duplicados en estados o valores.

## Micropráctica

```python
estados = ["LED_ON", "LED_OFF", "LED_ON", "BUZZER_ON", "LED_OFF"]
estados_unicos = set(estados)

print(estados_unicos)
```

## Recordar

* Un `set` no conserva duplicados.



# Dictionaries

## Idea

Asociar nombre del sensor con su valor.

## Micropráctica

```python
datos = {
    "luz": 320,
    "temperatura": 27,
    "distancia": 18
}

print(datos)
print("Luz:", datos["luz"])
print("Temperatura:", datos["temperatura"])
```

## Ecuación asociada

$
D = {k_1:x_1,; k_2:x_2,; k_3:x_3}
$

**Objetivo:** representar variables nombradas del sistema.

Donde:

* $k_i$: nombre de la variable.
* $x_i$: valor asociado.



# If...Else

## Idea

Tomar decisiones de control.

## Micropráctica

```python
luz = 250

if luz < 300:
    print("Encender LED")
else:
    print("Apagar LED")
```

## Ecuación asociada

$$
u =
\begin{cases}
\text{LED_ON} & \text{si } L < 300 \\
\text{LED_OFF} & \text{si } L \ge 300
\end{cases}
$$

**Objetivo:** convertir una medición en una acción de control.

Donde:

* $L$: nivel de luz.
* $u$: comando al actuador.



# Match

## Idea

Seleccionar acción según el tipo de sensor o evento.

## Micropráctica

```python
sensor = "temperatura"

match sensor:
    case "luz":
        print("Procesar sensor de luz")
    case "temperatura":
        print("Procesar sensor de temperatura")
    case "distancia":
        print("Procesar sensor de distancia")
    case _:
        print("Sensor no reconocido")
```

### Recordar

* Selección múltiple más limpia que varios `if`.



# While Loops

## Idea

Leer continuamente el sistema.

## Micropráctica

```python
contador = 0

while contador < 5:
    print("Leyendo sistema...", contador)
    contador += 1
```

## Ecuación asociada

$
t = t + 1
$

**Objetivo:** representar iteración temporal.

Donde:

* $t$: contador o paso temporal.



# For Loops

## Idea

Recorrer lecturas almacenadas.

## Micropráctica

```python
lecturas = [320, 300, 280, 260]

for valor in lecturas:
    print("Lectura:", valor)
```

## Recordar

* Iterar elemento por elemento.



# Functions

## Idea

Encapsular lógica reutilizable.

## Micropráctica

```python
def evaluar_luz(valor):
    if valor < 300:
        return "LED_ON"
    else:
        return "LED_OFF"

resultado = evaluar_luz(250)
print(resultado)
```

## Ecuación asociada

$
u = f(L)
$

**Objetivo:** modelar la decisión como una función.

Donde:

* $L$: lectura de luz.
* $f$: regla programada.
* $u$: comando resultante.



# Range

## Idea

Generar secuencias para pruebas.

## Micropráctica

```python
for i in range(5):
    print("Prueba número", i)
```

## Recordar

* Generación automática de secuencias enteras.



# Arrays

En cómputo científico se usan arreglos reales con NumPy.
Para fines practicos, aquí solo usaremos listas.

## Micropráctica

```python
temperaturas = [24, 25, 26, 27, 28]
print(temperaturas[2])
```



# Iterators

## Idea

Entender que una colección puede recorrerse internamente como flujo de datos.

## Micropráctica

```python
lecturas = [100, 200, 300]
it = iter(lecturas)

print(next(it))
print(next(it))
print(next(it))
```

## Recordar

* Qué hay detrás de un `for`.
* Concepto útil para procesamiento de datos.



# Modules

## Idea

Usar librerías existentes para ampliar capacidades.

## Micropráctica 1: módulo estándar

```python
import math

valor = 16
raiz = math.sqrt(valor)
print(raiz)
```

## Micropráctica 2: módulo que usarán al final

```python
import serial
print("Módulo serial cargado")
```

## Recordar

* Que no todo se programa desde cero.
* Que `pyserial` será clave para conectar con Arduino.



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


# 1. Arquitectura completa del sistema

$$
\mathbf{x} = [L,\;T,\;R]
$$

$$
u = f(\mathbf{x})
$$

**Nombre de la ecuación:** modelo de entrada–salida del sistema.
**Objetivo:** representar que el sistema recibe tres variables medidas y genera una acción de control.

Donde:

* $L$: lectura de luz
* $T$: temperatura (LM35)
* $R$: referencia (potenciómetro)
* $u$: comando de salida enviado desde Python al Arduino

En tu caso, Python evaluará esos datos y devolverá algo como:

* `LED_ON`
* `LED_OFF`
* `IDLE`

