---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad de Gamificación: **“¿Regresión o Clasificación?”**

## Instrucciones para ti (profesor)

1. **Divide la clase en 2–3 equipos**.
2. **Proyecta los siguientes datos** (los alumnos los verán en pantalla).
3. Cada equipo debe decidir, **lo más rápido posible**, si el problema corresponde a **Regresión (R)** o **Clasificación (C)**.
4. También deben proponer, en una frase, qué modelo aplicarían (**Regresión lineal, k-NN, etc.**).
5. Gana el equipo con **más respuestas correctas y rápidas**.

---

## Datos a proyectar (ejemplos reales de sensores y actuadores)

| Caso | Sensor / Actuador             | Variable objetivo (Y)                                | ¿Regresión o Clasificación? |
| ---- | ----------------------------- | ---------------------------------------------------- | --------------------------- |
| 1    | LM35 (temp.)                  | °C medidos vs referencia                             | R                           |
| 2    | HC-SR04 (distancia) + Servo   | Clase: “Cerca”=0, “Lejos”=1                          | C                           |
| 3    | LDR (luz)                     | Intensidad de luz en lux                             | R                           |
| 4    | LDR (luz) + LED               | Clase: LED\_ON (0/1)                                 | C                           |
| 5    | GP2Y0A21YK0F (IR)             | Distancia estimada en cm                             | R                           |
| 6    | A3144 (Hall) + buzzer         | Clase: magnetismo presente (1) / ausente (0)         | C                           |
| 7    | HC-SR04 + Motor CD            | Velocidad de motor en RPM                            | R                           |
| 8    | LM35 + Relé                   | Clase: Relé activo (1) / inactivo (0) según umbral   | C                           |
| 9    | HW-870 (sensor humedad suelo) | Humedad en %                                         | R                           |
| 10   | HW-870 + LED RGB              | Clase: “Seco”=Rojo, “Medio”=Amarillo, “Húmedo”=Verde | C                           |

---

## Dinámica rápida

* El profesor lee **un caso al azar** y da **5 segundos** para que cada equipo levante tarjeta/papel con **R** o **C**.
* Si aciertan, ganan **0.1 punto sobre la calificación final**.
* Respuesta extra (qué modelo usarían) da **0.05 puntos adicionales**.
* Al final, gana el equipo con mayor puntaje.


