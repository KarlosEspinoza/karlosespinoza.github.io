---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)

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

---

# 2. Componentes

## Sensores

1. **LDR** + resistencia de 10 kΩ
2. **LM35**
3. **Potenciómetro**

## Actuadores

4. **LED azul** + resistencia de 220 Ω

## Tarjeta

5. **Arduino Uno** o similar

---

# 3. Asignación de pines recomendada

| Componente     | Pin Arduino |
| -------------- | ----------: |
| LDR            |          A0 |
| LM35           |          A1 |
| Potenciómetro  |          A2 |
| LED            |         D13 |

---

# 4. Conexión de cada componente

---

## 4.1 LDR

El LDR no se conecta solo; necesita un **divisor de voltaje**.

$
V_{out} = V_{cc}\frac{R}{R + R_{LDR}}
$

**Nombre de la ecuación:** divisor de voltaje.
**Objetivo:** convertir el cambio de resistencia del LDR en un voltaje que el Arduino pueda medir.

## Conexión

```text
5V ---- LDR ----+---- A0
                |
              10kΩ
                |
               GND
```

---

## 4.2 LM35

El LM35 es un sensor analógico de temperatura.

## Conexión

* Pin 1 → 5V
* Pin 2 → A1
* Pin 3 → GND

### Conversión a temperatura

$$
T = \frac{ADC \cdot 500}{1023} + b
$$

**Nombre de la ecuación:** conversión ADC a temperatura.
**Objetivo:** obtener temperatura en °C a partir de la lectura analógica.

---

## 4.3 Potenciómetro

El potenciómetro funciona como divisor de voltaje.

## Conexión

```text
5V ---- terminal lateral
GND --- terminal lateral opuesta
A2 ---- terminal central
```

---

## 4.4 LED azul

## Conexión

* **D13** → resistencia **220 Ω** → ánodo del LED
* cátodo del LED → **GND**

```text
D13 ---- 220Ω ----|>|---- GND
```

---

# 5. Cómo repartir 5V y GND en el protoboard

* Lleva **5V** al riel positivo
* Lleva **GND** al riel negativo

---

# 6. Resumen de conexiones

| Dispositivo | Terminal | Arduino |
|------------|----------|--------|
| LDR | una pata | 5V |
| LDR | otra pata | A0 |
| Resistencia LDR | un extremo | A0 |
| Resistencia LDR | otro extremo | GND |
| LM35 | VCC | 5V |
| LM35 | OUT | A1 |
| LM35 | GND | GND |
| Potenciómetro | lateral | 5V |
| Potenciómetro | lateral | GND |
| Potenciómetro | central | A2 |
| LED azul | ánodo vía 220Ω | D13 |
| LED azul | cátodo | GND |

---

# 7. Formato de datos que enviará Arduino

```text
LUZ:523,TEMP:27,REF:610
```

---

# 8. Código Arduino actualizado

```cpp
const int pinLuz = A0;
const int pinLM35 = A1;
const int pinPot = A2;
const int pinLED = 13;

void setup() {
  Serial.begin(9600);
  pinMode(pinLED, OUTPUT);
}

int leerTemperatura() {
  int adc = analogRead(pinLM35);
  return (adc * 500L) / 1023 - 32;
}

void loop() {
  int luz = analogRead(pinLuz);
  int temp = leerTemperatura();
  int ref = analogRead(pinPot);

  Serial.print("LUZ:");
  Serial.print(luz);
  Serial.print(",TEMP:");
  Serial.print(temp);
  Serial.print(",REF:");
  Serial.println(ref);

  if (Serial.available()) {
    String comando = Serial.readStringUntil('\n');
    comando.trim();

    if (comando == "LED_ON") {
      digitalWrite(pinLED, HIGH);
    } else {
      digitalWrite(pinLED, LOW);
    }
  }

  delay(500);
}
```

---

# 10. Script Python compatible

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
    if datos["luz"] < datos["ref"]:
        return "LED_ON"
    elif datos["temp"] > 30:
        return "LED_ON"
    else:
        return "LED_OFF"

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

# 11. Salida esperada

```text
Datos: {'luz': 210, 'temp': 26, 'ref': 300}
Acción: LED_ON
```

$$
\text{medición} \rightarrow \text{procesamiento} \rightarrow \text{decisión} \rightarrow \text{acción}
$$

