---
layout: default
title: MEC.Python
---
[Inicio](/curso/python/semana_mec_26A)

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


