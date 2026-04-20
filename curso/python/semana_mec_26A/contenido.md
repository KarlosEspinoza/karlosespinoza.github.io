---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)


Sí. La mejor forma de hacerlo es que **cada concepto tenga una micropráctica muy corta**, pero que todas formen parte del mismo sistema, de modo que al final no parezcan ejercicios aislados sino etapas de construcción de un programa real.

Voy a proponerte un taller de 4 horas con esta lógica:

[
\text{Aprendizaje del lenguaje} + \text{práctica inmediata} + \text{integración progresiva} \rightarrow \text{programa final funcional}
]

**Objetivo de la ecuación:** representar que el aprendizaje no será por temas sueltos, sino por acumulación de bloques hasta controlar un sistema físico.

Donde:

* (\text{Aprendizaje del lenguaje}): conceptos básicos de Python.
* (\text{Práctica inmediata}): ejercicio corto por concepto.
* (\text{Integración progresiva}): cada práctica reutiliza algo de la anterior.
* (\text{programa final funcional}): lectura de Arduino y envío de comandos.

---

# Propuesta general del proyecto

## Proyecto del taller

**Sistema de monitoreo y control con Python + Arduino**

El Arduino lo llevas tú ya programado para:

1. Enviar por serial datos de sensores.
2. Recibir comandos simples desde Python.

Por ejemplo, Arduino puede enviar algo como:

```text
LUZ:320,TEMP:27,DIST:18
```

y Python responder con un comando como:

```text
LED_ON
```

o

```text
BUZZER_ON
```

---

# Arquitectura del sistema

```text
[Sensores en Arduino] → [Puerto serial] → [Python] → [Lógica de decisión] → [Comando serial] → [Arduino] → [Actuadores]
```

---

# Ecuación conceptual del sistema

[
u = f(x)
]

**Nombre de la ecuación:** ley general de decisión del sistema.
**Objetivo de la ecuación:** mostrar que la salida de control depende de las entradas medidas.

Donde:

* (x): vector de entradas del sistema, por ejemplo luz, temperatura y distancia.
* (f(\cdot)): lógica programada en Python.
* (u): comando enviado al Arduino.

---

# Recomendación didáctica importante

Para que realmente alcancen a ver todos los conceptos, conviene que:

1. **Cada concepto tenga una práctica de 3 a 7 minutos**.
2. Varias prácticas se hagan primero con datos simulados.
3. La integración con Arduino suceda en la segunda mitad.
4. El código final sea una composición de fragmentos ya practicados.

---

# Estructura del taller de 4 horas

## Bloque 1. Fundamentos de Python y manipulación de datos

Duración aproximada: 70 min

## Bloque 2. Estructuras de datos y control de flujo

Duración aproximada: 70 min

## Bloque 3. Funciones, módulos, iteración y trabajo con colecciones

Duración aproximada: 50 min

## Bloque 4. Integración final con Arduino

Duración aproximada: 50 min

---

# Práctica para cada concepto

A continuación te propongo **una práctica por concepto**, todas conectadas con el proyecto.

---

## 1. Syntax

### Idea

Que entiendan la estructura mínima de un programa en Python.

### Micropráctica

Crear un primer script que imprima un mensaje del sistema.

```python
print("Sistema de monitoreo iniciado")
```

### Recordar

* Que Python es sensible a sintaxis correcta.
* Que una instrucción simple ya ejecuta una acción.

---

## 2. Output

### Idea

Mostrar información al usuario.

### Micropráctica

Imprimir valores representativos del sistema.

```python
print("Sensor de luz:", 350)
print("Temperatura:", 27)
print("Distancia:", 18)
```

### Recordar

* Uso de `print()`.
* Cómo mostrar variables y texto.

---

## 3. Comments

### Idea

Documentar el código.

### Micropráctica

Agregar comentarios explicando qué hace cada parte.

```python
# Este script muestra datos iniciales del sistema
print("Sistema listo")

# Aquí simulamos una lectura de luz
print("Luz:", 350)
```

### Recordar

* El comentario no se ejecuta.
* Sirve para conectar código con teoría.

---

## 4. Variables

### Idea

Guardar información para usarla después.

### Micropráctica

```python
luz = 350
temperatura = 27
distancia = 18

print(luz)
print(temperatura)
print(distancia)
```

### Ecuación asociada

[
x = \text{valor medido}
]

**Objetivo:** representar que una variable almacena una medición del sistema.

Donde:

* (x): variable en el programa.
* (\text{valor medido}): dato del sensor.

---

## 5. Data Types

### Idea

Reconocer que no todo dato es del mismo tipo.

### Micropráctica

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

### Recordar

* `int`, `float`, `str`, `bool`.

---

## 6. Numbers

### Idea

Operar numéricamente con mediciones.

### Micropráctica

```python
temperatura = 27.5
incremento = 2
nueva_temperatura = temperatura + incremento

print("Temperatura ajustada:", nueva_temperatura)
```

### Ecuación asociada

[
T_{ajustada} = T + \Delta T
]

**Objetivo:** mostrar operación numérica sobre una variable física.

Donde:

* (T): temperatura original.
* (\Delta T): incremento aplicado.
* (T_{ajustada}): resultado.

---

## 7. Casting

### Idea

Convertir tipos de datos.

### Micropráctica

Simular que Arduino envía un valor como texto.

```python
dato_serial = "350"
luz = int(dato_serial)

print(luz)
print(type(luz))
```

### Ecuación asociada

[
x_{numérico} = \text{cast}(x_{texto})
]

**Objetivo:** transformar datos crudos en datos utilizables.

---

## 8. Strings

### Idea

Manipular mensajes que vienen del sistema.

### Micropráctica

```python
mensaje = "LUZ:350"
print(mensaje)

partes = mensaje.split(":")
print(partes)
print("Variable:", partes[0])
print("Valor:", partes[1])
```

### Recordar

* Texto, concatenación, separación.

---

## 9. Booleans

### Idea

Representar estados lógicos del sistema.

### Micropráctica

```python
luz = 250
es_oscuro = luz < 300

print(es_oscuro)
print(type(es_oscuro))
```

### Ecuación asociada

[
b =
\begin{cases}
\text{True} & \text{si } x < 300 \
\text{False} & \text{si } x \ge 300
\end{cases}
]

**Objetivo:** modelar una condición lógica.

Donde:

* (x): valor de luz.
* (b): estado booleano.

---

## 10. Operators

### Idea

Usar operadores aritméticos, relacionales y lógicos.

### Micropráctica

```python
luz = 250
temp = 31

print(luz + 50)
print(temp > 30)
print(luz < 300 and temp > 25)
```

### Recordar

* `+`, `-`, `*`, `/`
* `<`, `>`, `==`
* `and`, `or`, `not`

---

## 11. Lists

### Idea

Guardar varias lecturas.

### Micropráctica

```python
lecturas_luz = [320, 300, 280, 260, 250]

print(lecturas_luz)
print("Primera lectura:", lecturas_luz[0])
print("Última lectura:", lecturas_luz[-1])
```

### Ecuación asociada

[
L = [x_1, x_2, x_3, \dots, x_n]
]

**Objetivo:** representar un conjunto ordenado de lecturas.

Donde:

* (L): lista de datos.
* (x_i): lectura (i)-ésima.

---

## 12. Tuples

### Idea

Guardar configuraciones fijas.

### Micropráctica

```python
puertos_validos = ("COM3", "COM4", "/dev/ttyUSB0")
print(puertos_validos)
print(puertos_validos[0])
```

### Recordar

* Una tupla es ordenada pero inmutable.

---

## 13. Sets

### Idea

Eliminar duplicados en estados o valores.

### Micropráctica

```python
estados = ["LED_ON", "LED_OFF", "LED_ON", "BUZZER_ON", "LED_OFF"]
estados_unicos = set(estados)

print(estados_unicos)
```

### Recordar

* Un `set` no conserva duplicados.

---

## 14. Dictionaries

### Idea

Asociar nombre del sensor con su valor.

### Micropráctica

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

### Ecuación asociada

[
D = {k_1:x_1,; k_2:x_2,; k_3:x_3}
]

**Objetivo:** representar variables nombradas del sistema.

Donde:

* (k_i): nombre de la variable.
* (x_i): valor asociado.

---

## 15. If...Else

### Idea

Tomar decisiones de control.

### Micropráctica

```python
luz = 250

if luz < 300:
    print("Encender LED")
else:
    print("Apagar LED")
```

### Ecuación asociada

[
u =
\begin{cases}
\text{LED_ON} & \text{si } L < 300 \
\text{LED_OFF} & \text{si } L \ge 300
\end{cases}
]

**Objetivo:** convertir una medición en una acción de control.

Donde:

* (L): nivel de luz.
* (u): comando al actuador.

---

## 16. Match

### Idea

Seleccionar acción según el tipo de sensor o evento.

### Micropráctica

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

---

## 17. While Loops

### Idea

Leer continuamente el sistema.

### Micropráctica

```python
contador = 0

while contador < 5:
    print("Leyendo sistema...", contador)
    contador += 1
```

### Ecuación asociada

[
t = t + 1
]

**Objetivo:** representar iteración temporal.

Donde:

* (t): contador o paso temporal.

---

## 18. For Loops

### Idea

Recorrer lecturas almacenadas.

### Micropráctica

```python
lecturas = [320, 300, 280, 260]

for valor in lecturas:
    print("Lectura:", valor)
```

### Recordar

* Iterar elemento por elemento.

---

## 19. Functions

### Idea

Encapsular lógica reutilizable.

### Micropráctica

```python
def evaluar_luz(valor):
    if valor < 300:
        return "LED_ON"
    else:
        return "LED_OFF"

resultado = evaluar_luz(250)
print(resultado)
```

### Ecuación asociada

[
u = f(L)
]

**Objetivo:** modelar la decisión como una función.

Donde:

* (L): lectura de luz.
* (f): regla programada.
* (u): comando resultante.

---

## 20. Range

### Idea

Generar secuencias para pruebas.

### Micropráctica

```python
for i in range(5):
    print("Prueba número", i)
```

### Recordar

* Generación automática de secuencias enteras.

---

## 21. Arrays

En Python puro, para este taller conviene tratarlos como listas. Si quieres mencionar que en cómputo científico se usan arreglos reales con NumPy, puedes decirlo sin profundizar demasiado.

### Micropráctica

```python
temperaturas = [24, 25, 26, 27, 28]
print(temperaturas[2])
```

### Nota didáctica

Puedes decirles:

> “En este taller usamos listas como arreglos básicos. Más adelante en IA usaremos arreglos numéricos con NumPy.”

---

## 22. Iterators

### Idea

Entender que una colección puede recorrerse internamente como flujo de datos.

### Micropráctica

```python
lecturas = [100, 200, 300]
it = iter(lecturas)

print(next(it))
print(next(it))
print(next(it))
```

### Recordar

* Qué hay detrás de un `for`.
* Concepto útil para procesamiento de datos.

---

## 23. Modules

### Idea

Usar librerías existentes para ampliar capacidades.

### Micropráctica 1: módulo estándar

```python
import math

valor = 16
raiz = math.sqrt(valor)
print(raiz)
```

### Micropráctica 2: módulo que usarán al final

```python
import serial
print("Módulo serial cargado")
```

### Recordar

* Que no todo se programa desde cero.
* Que `pyserial` será clave para conectar con Arduino.

---

# Cómo conectar todas las microprácticas en un solo proyecto

Ahora viene lo más importante: que no queden aisladas.

---

# Secuencia integradora del taller

## Etapa 1. Datos simulados

Primero trabajan con valores escritos manualmente:

```python
luz = 250
temperatura = 28
distancia = 15
```

Con esto practican:

* Variables
* Data types
* Numbers
* Booleans
* Operators
* If...Else

---

## Etapa 2. Datos organizados

Luego encapsulan datos en estructuras:

```python
datos = {
    "luz": 250,
    "temperatura": 28,
    "distancia": 15
}
```

Aquí practican:

* Lists
* Tuples
* Sets
* Dictionaries

---

## Etapa 3. Lógica del sistema

Luego crean funciones para decidir acciones:

```python
def evaluar_sistema(datos):
    if datos["luz"] < 300:
        return "LED_ON"
    elif datos["distancia"] < 10:
        return "BUZZER_ON"
    else:
        return "IDLE"
```

Aquí practican:

* Functions
* If...Else
* Strings
* Booleans

---

## Etapa 4. Iteración temporal

Luego repiten el análisis continuamente:

```python
while True:
    print("Leyendo y evaluando sistema")
```

Aquí practican:

* While
* For
* Range
* Iterators

---

## Etapa 5. Integración con módulo serial

Finalmente se comunican con Arduino.

---

# Programa final integrador con Arduino

Este programa ya incorpora la mayoría de los conceptos.

```python
import serial
import time

# -----------------------------
# CONFIGURACIÓN DEL SISTEMA
# -----------------------------
PUERTO = '/dev/ttyUSB0'   # Cambiar según tu equipo
BAUDRATE = 9600

# Tupla: configuración fija posible
comandos_validos = ("LED_ON", "LED_OFF", "BUZZER_ON", "IDLE")

# -----------------------------
# FUNCIÓN PARA PARSEAR DATOS
# Ejemplo de entrada:
# "LUZ:320,TEMP:27,DIST:18"
# -----------------------------
def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        clave, valor = parte.split(":")
        datos[clave.lower()] = int(valor)

    return datos

# -----------------------------
# FUNCIÓN DE DECISIÓN
# u = f(x)
# -----------------------------
def evaluar_sistema(datos):
    luz = datos["luz"]
    temp = datos["temp"]
    dist = datos["dist"]

    if dist < 10:
        return "BUZZER_ON"
    elif luz < 300:
        return "LED_ON"
    elif temp > 30:
        return "LED_OFF"
    else:
        return "IDLE"

# -----------------------------
# FUNCIÓN PARA ENVIAR COMANDO
# -----------------------------
def enviar_comando(arduino, comando):
    if comando in comandos_validos:
        arduino.write((comando + "\n").encode())

# -----------------------------
# PROGRAMA PRINCIPAL
# -----------------------------
arduino = serial.Serial(PUERTO, BAUDRATE, timeout=1)
time.sleep(2)

print("Sistema iniciado")

while True:
    linea = arduino.readline().decode().strip()

    if linea:
        print("Dato recibido:", linea)

        datos = parsear_datos(linea)
        print("Diccionario:", datos)

        comando = evaluar_sistema(datos)
        print("Comando:", comando)

        enviar_comando(arduino, comando)

    time.sleep(0.2)
```

---

# Qué conceptos sí aparecen en el programa final

| Concepto     | Aparece en el programa final                      |
| ------------ | ------------------------------------------------- |
| Syntax       | Sí                                                |
| Output       | Sí                                                |
| Comments     | Sí                                                |
| Variables    | Sí                                                |
| Data Types   | Sí                                                |
| Numbers      | Sí                                                |
| Casting      | Sí                                                |
| Strings      | Sí                                                |
| Booleans     | Sí                                                |
| Operators    | Sí                                                |
| Lists        | Sí, en el parseo implícito por `split()`          |
| Tuples       | Sí                                                |
| Sets         | No indispensable en el final, pero sí en práctica |
| Dictionaries | Sí                                                |
| If...Else    | Sí                                                |
| Match        | Puede integrarse opcionalmente                    |
| While Loops  | Sí                                                |
| For Loops    | Sí                                                |
| Functions    | Sí                                                |
| Range        | En práctica                                       |
| Arrays       | Como listas                                       |
| Iterators    | En práctica                                       |
| Modules      | Sí (`serial`, `time`)                             |

---

# Versión opcional del programa final usando `match`

Si quieres que también aparezca ese concepto en el integrador, podemos usarlo para convertir un comando lógico en una acción textual más clara.

```python
def describir_comando(comando):
    match comando:
        case "LED_ON":
            return "Encender LED"
        case "LED_OFF":
            return "Apagar LED"
        case "BUZZER_ON":
            return "Activar buzzer"
        case "IDLE":
            return "Sistema en espera"
        case _:
            return "Comando desconocido"
```

Y dentro del ciclo:

```python
descripcion = describir_comando(comando)
print(descripcion)
```

---

# Script de Arduino sugerido para que todo esto funcione

Tú dijiste que Arduino lo harás tú, así que te propongo una lógica muy simple y robusta.

## Idea de hardware

* LDR en A0
* sensor de temperatura analógico o valor simulado
* sensor de distancia o valor simulado
* LED en pin 13
* buzzer en pin 12

## Formato que envía Arduino

```text
LUZ:320,TEMP:27,DIST:18
```

## Comandos que recibe

* `LED_ON`
* `LED_OFF`
* `BUZZER_ON`
* `IDLE`

---

### Arduino ejemplo

```cpp
const int pinLuz = A0;
const int pinLED = 13;
const int pinBuzzer = 12;

void setup() {
  Serial.begin(9600);
  pinMode(pinLED, OUTPUT);
  pinMode(pinBuzzer, OUTPUT);
}

void loop() {
  int luz = analogRead(pinLuz);

  // Datos simulados para completar el ejemplo
  int temp = 27;
  int dist = 18;

  Serial.print("LUZ:");
  Serial.print(luz);
  Serial.print(",TEMP:");
  Serial.print(temp);
  Serial.print(",DIST:");
  Serial.println(dist);

  if (Serial.available()) {
    String comando = Serial.readStringUntil('\n');
    comando.trim();

    if (comando == "LED_ON") {
      digitalWrite(pinLED, HIGH);
      digitalWrite(pinBuzzer, LOW);
    }
    else if (comando == "LED_OFF") {
      digitalWrite(pinLED, LOW);
      digitalWrite(pinBuzzer, LOW);
    }
    else if (comando == "BUZZER_ON") {
      digitalWrite(pinBuzzer, HIGH);
    }
    else if (comando == "IDLE") {
      digitalWrite(pinBuzzer, LOW);
    }
  }

  delay(500);
}
```

---

# Propuesta de dinámica de clase

## Hora 1

Fundamentos:

* Syntax
* Output
* Comments
* Variables
* Data Types
* Numbers
* Casting
* Strings
* Booleans
* Operators

## Hora 2

Estructuras:

* Lists
* Tuples
* Sets
* Dictionaries
* If...Else
* Match

## Hora 3

Flujo y modularidad:

* While
* For
* Functions
* Range
* Arrays
* Iterators
* Modules

## Hora 4

Integración:

* leer serial
* parsear datos
* decidir acción
* enviar comando
* probar con Arduino

---

# Recomendación docente importante

No todos los conceptos deben tener el mismo peso. Yo te sugeriría esta jerarquía:

## Conceptos críticos para el objetivo final

* Variables
* Data types
* Casting
* Strings
* Dictionaries
* If...Else
* While
* Functions
* Modules

## Conceptos importantes pero superficiales

* Lists
* Tuples
* For
* Range
* Booleans
* Operators

## Conceptos de exposición breve

* Sets
* Match
* Iterators
* Arrays

Eso permite que “sí vean todo”, pero sin sacrificar el proyecto final.

---

# Qué entregable podrían generar ellos

Al final, cada estudiante o equipo puede entregar:

1. Un script en Python que lea y procese datos.
2. Un script que envíe comandos al Arduino.
3. Una pequeña modificación personal del criterio de control.

Por ejemplo:

* un equipo controla por luz,
* otro por temperatura,
* otro por distancia,
* otro combina dos condiciones.

---

# Cierre conceptual hacia tu curso de IA

Puedes terminar diciendo algo como esto en el taller:

[
\mathbf{x} = [\text{luz}, \text{temp}, \text{dist}]
]

[
\hat{y} = f(\mathbf{x})
]

**Nombre de la ecuación:** modelo entrada-salida.
**Objetivo:** introducir la idea de que en IA un algoritmo recibe variables de entrada y produce una salida o decisión.

Donde:

* (\mathbf{x}): vector de características o *features*.
* (f(\mathbf{x})): regla o modelo.
* (\hat{y}): decisión del sistema.

Así les muestras que este taller ya era, en el fondo, una introducción a la lógica de IA.

---

Puedo darte ahora la **versión siguiente ya lista para impartir**, con formato de:

**tema → mini explicación → práctica → tiempo estimado → código**

para que tengas el taller minuto a minuto.

