---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)


# 1. Nuevo modelo del sistema

En lugar de:

[
\mathbf{x} = [L,;T,;D]
]

usas:

[
\mathbf{x} = [L,;T_{dht},;T_{lm35},;P]
]

**Nombre de la ecuación:** vector de entradas del sistema.
**Objetivo:** representar las variables medidas realmente disponibles en tu hardware.

Donde:

* (L): lectura de luz del LDR
* (T_{dht}): temperatura medida por DHT22
* (T_{lm35}): temperatura medida por LM35
* (P): posición del potenciómetro

La salida puede ser:

[
u = f(\mathbf{x})
]

Donde:

* (u): comando de control, por ejemplo `LED_ON` o `LED_OFF`

---

# 2. Qué sistema te recomiendo construir

## Opción más coherente para el taller

### **Sistema de monitoreo ambiental con control por umbrales**

Python recibe datos de:

* luz,
* temperatura,
* referencia ajustable con potenciómetro,

y decide si el LED del Arduino debe encenderse o apagarse.

---

# 3. Idea didáctica del sistema

El **potenciómetro** puede usarse como una **referencia ajustable**, lo cual está excelente para Mecatrónica.

Por ejemplo:

* si la luz baja de cierto umbral → encender LED
* si la temperatura sube de cierto umbral → encender LED
* o hacer que el potenciómetro defina el umbral de activación

Eso es muy bueno porque introduces implícitamente la idea de referencia de control.

---

# 4. Propuesta concreta del sistema

## Entradas

* `LUZ` → del LDR
* `TEMP` → del DHT22 o LM35
* `REF` → del potenciómetro

## Salida

* `LED_ON`
* `LED_OFF`

---

# 5. Qué sensor de temperatura usar

Tienes dos opciones:

## Opción A. Usar **solo DHT22**

Ventaja:

* entrega temperatura digital ya procesada.

## Opción B. Usar **LM35**

Ventaja:

* muy bueno para explicar conversión analógica a temperatura.

## Opción C. Usar ambos

Didácticamente esto es muy interesante porque puedes comparar sensores.

Yo te recomendaría:

### Para simplificar el taller:

* usar **LDR + LM35 + potenciómetro**
* dejar el **DHT22** como extensión opcional

¿Por qué? Porque LDR, LM35 y potenciómetro son analógicos y usan una lógica de lectura muy parecida con `analogRead()`. Eso simplifica muchísimo el cableado y el código Arduino.

---

# 6. Recomendación final de hardware

## Usa estos tres sensores:

* **LDR**
* **LM35**
* **Potenciómetro**

## Actuador:

* **LED integrado del Arduino (pin 13)**

Y si quieres, el DHT22 lo puedes usar como demostración adicional, no como parte obligatoria del sistema principal.

---

# 7. Nuevo protocolo serial

Arduino enviará algo como:

```text
LUZ:523,TEMP:27,REF:610
```

Y Python responderá:

```text
LED_ON
```

o

```text
LED_OFF
```

Esto queda completamente consistente.

---

# 8. Conexión de componentes

---

## 8.1 LDR

Necesita divisor de voltaje:

```text
5V ---- LDR ----+---- A0
                |
              10kΩ
                |
               GND
```

### Pines

* nodo intermedio → **A0**

---

## 8.2 LM35

El LM35 tiene 3 pines. Viéndolo de frente, usualmente:

1. (V_s)
2. (V_{out})
3. GND

## Conexión

* pin 1 → **5V**
* pin 2 → **A1**
* pin 3 → **GND**

### Ecuación del LM35

[
T = \frac{V_{out}}{10 \text{ mV/°C}}
]

Como Arduino usa ADC de 10 bits:

[
V_{out} = \frac{\text{ADC}\cdot 5}{1023}
]

Entonces:

[
T = \frac{\text{ADC}\cdot 5}{1023 \cdot 0.01}
]

[
T \approx \frac{\text{ADC}\cdot 500}{1023}
]

**Objetivo de la ecuación:** convertir la lectura analógica en temperatura en °C.

Donde:

* (\text{ADC}): valor de `analogRead()`
* (V_{out}): voltaje de salida del LM35
* (T): temperatura en °C

---

## 8.3 Potenciómetro

El potenciómetro se conecta como divisor de voltaje.

```text
5V ---- terminal lateral
GND --- terminal lateral opuesta
A2 ---- terminal central
```

### Pines

* terminal central (wiper) → **A2**

Esto te dará una lectura de 0 a 1023.

---

## 8.4 LED

Puedes usar el **LED integrado** del Arduino en el pin 13, así no necesitas cablearlo.

Si quieres LED externo:

```text
D13 ---- 220Ω ----|>|---- GND
```

Pero para simplificar, usa el integrado.

---

# 9. Asignación final de pines

| Componente    | Pin |
| ------------- | --: |
| LDR           |  A0 |
| LM35          |  A1 |
| Potenciómetro |  A2 |
| LED           | D13 |

Si luego quieres agregar DHT22:

| Componente | Pin |
| ---------- | --: |
| DHT22 DATA |  D2 |

---

# 10. Lógica del sistema

Puedes hacer que Python decida así:

[
u =
\begin{cases}
\text{LED_ON} & \text{si } L < L_{ref} \
\text{LED_ON} & \text{si } T > 30 \
\text{LED_OFF} & \text{en otro caso}
\end{cases}
]

**Objetivo de la ecuación:** encender el LED si hay poca luz o si la temperatura rebasa cierto umbral.

Donde:

* (L): luz medida
* (L_{ref}): referencia de luz tomada del potenciómetro
* (T): temperatura del LM35

Esto queda muy bien para un taller.

---

# 11. Código Arduino recomendado

Este código usa solo **LDR + LM35 + potenciómetro + LED**.

```cpp
const int pinLuz = A0;
const int pinLM35 = A1;
const int pinPot = A2;
const int pinLED = 13;

void setup() {
  Serial.begin(9600);
  pinMode(pinLED, OUTPUT);
  digitalWrite(pinLED, LOW);
}

int leerTemperaturaLM35() {
  int adc = analogRead(pinLM35);
  int tempC = (adc * 500L) / 1023;   // aproximación en °C
  return tempC;
}

void loop() {
  int luz = analogRead(pinLuz);
  int temp = leerTemperaturaLM35();
  int ref = analogRead(pinPot);

  // Enviar datos a Python
  Serial.print("LUZ:");
  Serial.print(luz);
  Serial.print(",TEMP:");
  Serial.print(temp);
  Serial.print(",REF:");
  Serial.println(ref);

  // Leer comando desde Python
  if (Serial.available()) {
    String comando = Serial.readStringUntil('\n');
    comando.trim();

    if (comando == "LED_ON") {
      digitalWrite(pinLED, HIGH);
    }
    else if (comando == "LED_OFF") {
      digitalWrite(pinLED, LOW);
    }
    else if (comando == "IDLE") {
      digitalWrite(pinLED, LOW);
    }
  }

  delay(500);
}
```

---

# 12. Código Python alineado con este Arduino

```python
import serial
import time

arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
time.sleep(2)

def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        if ":" in parte:
            clave, valor = parte.split(":")
            datos[clave.lower()] = int(valor)

    return datos

def evaluar_sistema(datos):
    if datos["luz"] < datos["ref"]:
        return "LED_ON"
    elif datos["temp"] > 30:
        return "LED_ON"
    else:
        return "LED_OFF"

while True:
    try:
        linea = arduino.readline().decode().strip()

        if linea:
            datos = parsear_datos(linea)
            accion = evaluar_sistema(datos)

            print("Datos:", datos)
            print("Acción:", accion)

            arduino.write((accion + "\n").encode())

        time.sleep(0.2)

    except Exception as e:
        print("Error:", e)
```

---

# 13. Qué significa esta lógica

## Caso 1

Si el ambiente está oscuro respecto al umbral definido por el potenciómetro:

[
L < REF
\Rightarrow \text{LED_ON}
]

## Caso 2

Si la temperatura es alta:

[
T > 30
\Rightarrow \text{LED_ON}
]

## Caso 3

Si nada de eso ocurre:

[
\text{LED_OFF}
]

---

# 14. Por qué esta solución es mejor para tu taller

Porque ahora tienes:

## Hardware real y disponible

* sí corresponde al código

## Menor complejidad de cableado

* no dependes de HC-SR04 ni buzzer

## Muy buena progresión didáctica

* analogRead
* parsing
* lógica
* comunicación serial
* control

## Relación con IA

Todavía puedes introducir la idea de *features*:

[
\mathbf{x} = [\text{luz}, \text{temp}, \text{ref}]
]

y una regla de decisión:

[
\hat{y} = f(\mathbf{x})
]

---

# 15. Qué haría yo como profesor

Yo estructuraría el taller así:

## Sistema base

* LDR
* LM35
* potenciómetro
* LED

## Extensión opcional

* DHT22 para comparar temperatura digital vs analógica

Así no comprometes el flujo del taller.

---

# 16. Mi recomendación final

Para que el taller sea sólido y no se te complique el montaje:

### Qué sí usar

* LDR
* LM35
* potenciómetro
* LED integrado

### Qué no usar en la versión principal

* DHT22, salvo como extensión

Porque el DHT22 mete una librería y un protocolo distinto, mientras que con LDR/LM35/potenciómetro todo es muy uniforme y elegante.

---

Puedo darte enseguida una **versión didáctica completa del taller** ya corregida a este nuevo hardware, con:

* objetivo por etapa,
* microprácticas por concepto,
* script Arduino final,
* script Python final,
* y cómo presentarlo en clase.

