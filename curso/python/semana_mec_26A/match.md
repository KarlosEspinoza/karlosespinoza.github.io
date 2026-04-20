---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)

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


