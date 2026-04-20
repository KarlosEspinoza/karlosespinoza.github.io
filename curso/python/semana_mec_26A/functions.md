---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)

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


