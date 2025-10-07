---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Raspberry Pi y Arduino

## Flujo

1. Cargas el sketch al Arduino desde tu PC (por USB, como siempre).
2. Luego conectas el Arduino a la Raspberry Pi **por pines TX/RX y GND**.
3. El Arduino envía lecturas del **LM35** y recibe comandos (“1 / 0”) para prender y apagar el LED.
4. Un script en la Raspberry (Python) lee los datos y envía instrucciones.

## Circuito

- Raspberry Pi
- MicroSD para Raspberry Pi
- Fuente poder 5V 3A para Raspberry Pi
- Resistencias: 10k, 20k, 330
- LED
- LM35
- Arduino
- Cable USB del Arduino
- Jupers macho-macho
- Jumper hembra-hembra

<img src="/image/ia/lm35_led_arduino_raspberry.png" width="800"/>

> Revisa [Pinout de Raspberry Pi](https://pinout.xyz/)

## Programa de Arduino

Carga este código desde tu **PC (Arduino IDE)**:

```cpp
// Arduino: Envía temperatura y recibe comando LED ON/OFF

const int ledPin = 3;
const int tempPin = A0;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
}

void loop() {
  // Leer LM35 (10mV por °C)
  int raw = analogRead(tempPin);
  float voltage = raw * (5.0 / 1023.0);
  float temperature = voltage * 100.0; // °C

  // Enviar lectura a la Raspberry
  Serial.print("TEMP:");
  Serial.println(temperature);

  // Revisar si hay comando recibido
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');
    command.trim();
    if (command == "1") {
      digitalWrite(ledPin, HIGH);
      Serial.println("LED=ON");
    } else if (command == "0") {
      digitalWrite(ledPin, LOW);
      Serial.println("LED=OFF");
    }
  }

  delay(1000);
}
```

## Configurar la Raspberry Pi

1. **Habilita el puerto UART:**

   ```bash
   sudo raspi-config
   ```

   * Ve a **Interfacing Options → Serial Port**
   * “¿Deseas usar el login shell por serial?” → **No**
   * “¿Deseas habilitar el hardware serial?” → **Sí**
   * [TAB] **Finish**
   * [TAB] **Reboot**

2. **Verifica el dispositivo serial:**

   ```bash
   ls /dev/serial0
   ```

   o

   ```bash
   ls /dev/ttyAMA0
   ```

   Si aparece alguno, ¡ya está listo!

---

## Script en Python (en la Raspberry Pi)

Instala PySerial:

```bash
sudo apt update
sudo apt install python3-serial
```

Luego crea un archivo `arduino_uart.py`:

```python
import serial
import time

# Abre el puerto serial (ajusta si es necesario)
ser = serial.Serial('/dev/serial0', 9600, timeout=1)
time.sleep(2)  # espera que Arduino inicie

try:
    while True:
        # Leer temperatura
        line = ser.readline().decode('utf-8').strip()
        if line:
            print("Arduino", line)

        # Enviar comando LED según temperatura
        if "TEMP:" in line:
            temp = float(line.split(":")[1])
            if temp > 30:
                ser.write(b'LED ON\n')
                print("Raspberry LED ON")
            else:
                ser.write(b'LED OFF\n')
                print("Raspberry LED OFF")

        time.sleep(1)

except KeyboardInterrupt:
    print("Finalizando...")
    ser.close()
```

Ejecuta:

```bash
python3 arduino_uart.py
```

Ejemplo de salida:

```
Arduino → TEMP:28.50
Raspberry → LED OFF
Arduino → TEMP:31.20
Raspberry → LED ON
Arduino → LED=ON
```

