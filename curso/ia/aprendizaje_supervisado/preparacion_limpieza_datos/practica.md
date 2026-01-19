---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

## Práctica

En parejas, recolecten datos de **cualquier sensor disponible** (ej. LDR o HC-SR04) y activen un **actuador** (ej. LED o servomotor) dependiendo de la condición del dato ya **limpio** (ej. normalizado o con imputación).
El objetivo es aplicar al menos **una técnica de limpieza de datos**.

**Script Python (con pistas):**

```python
import serial
import numpy as np

# Abrir puerto serial
arduino = serial.Serial('/dev/ttyUSB0', 9600)

valores = []
for i in range(20):
    data = arduino.readline().decode().strip()
    try:
        valor = float(data)
        valores.append(valor)
    except:
        pass

# TODO: Normalizar los valores
# norm_valores = ...

# TODO: Imputar si hay valores nulos o atípicos
# imputados = ...

print("Valores procesados:", imputados)
# TODO: Decidir si se activa un actuador (ej. LED)
```


