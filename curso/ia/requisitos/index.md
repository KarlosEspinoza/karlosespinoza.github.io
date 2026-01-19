---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

## Paquetes Python que deben instalar con `pip`

* `numpy`
* `pandas`
* `matplotlib`
* `scikit-learn`
* `pyserial`
* `joblib`

Los puedes instalar todos con el siguiente comando:

```bash
python -m pip install -U numpy pandas matplotlib scikit-learn pyserial joblib
```

## Lista de componentes electrónicos

| Categoría            | Componente                                | Cantidad sugerida |
| -------------------- | ----------------------------------------- | ----------------: |
| MCU                  | **Arduino Nano** (o UNO compatible)       |                 1 |
| Sensores             | **LM35** (temperatura analógica)          |               1–2 |
| Sensores             | **LDR** + **resistencia 10 kΩ** (divisor) |             1 + 1 |
| Sensores             | **HC-SR04** (ultrasonido)                 |                 1 |
| Actuadores           | **LED** (5mm)                             |               2–5 |
| Actuadores           | **LED RGB** (4 pines)                     |                 1 |
| Actuadores           | **Buzzer** 5V                             |                 1 |
| Actuadores           | **Servo SG90**                            |                 1 |
| Montaje              | Protoboard                                |                 1 |
| Montaje              | Jumpers Dupont (M-M y M-F)                |             20–40 |
| Pasivos              | Resistencias **220 Ω / 330 Ω**            |              5–10 |
| Alimentación         | Cable USB para Arduino                    |                 1 |
| (Opcional pero útil) | Fuente 5V (power bank o adaptador)        |                 1 |

> **Tip”**: el **servo SG90** puede meter ruido eléctrico; si quieres blindarte, agrega un capacitor (100–470 µF) entre 5V y GND cerca del servo. (No es obligatorio, pero ayuda mucho en laboratorio.) 

## Base permanente (soldada por el estudiante)

Esta parte **se suelda una sola vez** y llega lista a clase.

### Placa y conexión base

| Componente                                     |  Cantidad | Observaciones técnicas            |
| ---------------------------------------------- | --------: | --------------------------------- |
| **Placa perforada (PCB universal)**            |         1 | Tamaño sugerido: 5×7 cm o 7×9 cm  |
| **Headers macho (1×40, cortable)**             | 2–3 tiras | Para señales (A0, D2, D3, etc.)   |
| **Headers hembra (1×40, cortable)**            | 1–2 tiras | Para conectar sensores sin soldar |
| **Borneras / terminales de tornillo para PCB** |       4–8 | 2 o 3 pines (Vcc, GND, señal)     |
| **Jumpers cortos soldados (puentes)**          |    varios | Distribución común de 5V y GND    |

### Herramientas mínimas

| Herramienta                          | Recomendación          |
| ------------------------------------ | ---------------------- |
| **Soldador de punta fina (30–60 W)** | Tipo lápiz             |
| **Estaño para electrónica**          | Con núcleo de flux     |
| **Bomba o malla desoldadora**        | Para correcciones      |
| **Pinzas de punta / cortador**       | Para headers y cables  |
| **Multímetro**                       | Continuidad y voltajes |

## Proyecto final

En tu “Proyecto Final” se abre la puerta a usar **Arduino/ESP32** y despliegue con **Raspberry Pi**. 

* **Raspberry Pi** (para integración/producción). incluye la fuente de poder original, porque la antena de wifi del Raspberry es muy sensible a la fuente de poder.
* **ESP32** (si van a hacerlo inalámbrico o con mayor potencia)
* Sensores extra según aplicación


