---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)

# Ruta del proyecto

Su proyecto es un fenómeno de su propia tesis, modelado, simulado y optimizado. No es la tesis
completa: es **un fenómeno** de ella, lo bastante acotado para caber en un semestre y lo bastante
real para que le sirva después.

Esta ruta son los cinco hitos por los que pasa cualquier proyecto de modelado, sea cual sea el
fenómeno. Es el mapa que le dice dónde está usted, no un temario que se recorre al mismo paso que
los demás.

**La ruta es el orden esperado, no una obligación.** El encargo de cada turno lo fija el profesor
según dónde esté realmente su proyecto. Es normal que un hito le tome dos turnos si el fenómeno lo
exige, y es normal que dos alumnos vayan en hitos distintos el mismo día.

---

## Los cinco hitos

### Hito 1: Planteamiento y datos

**La pregunta que responde:** ¿qué fenómeno estoy modelando, y para decidir qué?

- El fenómeno, acotado a una variable independiente y una cantidad medible
- La pregunta de ingeniería que el modelo debe contestar
- Variables, parámetros, supuestos y alcance declarado
- Datos: propios si los tiene, o un experimento sintético reproducible si todavía no

**Evidencia:** su `ficha.md` completa, el conjunto de datos y una gráfica de los datos crudos.

Si aún no tiene datos experimentales, se genera un experimento sintético: un script que produce el
comportamiento del modelo verdadero más ruido y deriva, con semilla fija. No es una simulación de
juguete, es la práctica estándar para validar un método de ajuste antes de gastar material.

### Hito 2: Modelo y parámetros

**La pregunta que responde:** ¿qué modelo describe mis datos, y qué tan bien?

- Un modelo candidato, y **al menos uno alternativo contra el cual compararlo**
- Parámetros estimados de los datos, no copiados de la literatura
- Error cuantificado: MAE, RMSE, R2 o el que corresponda, con sus unidades

**Evidencia:** el ajuste, la gráfica de datos contra modelo, y la tabla de métricas de los dos
modelos.

Un modelo sin error cuantificado no es un modelo, es un dibujo. Y un solo modelo sin alternativa no
demuestra nada: siempre ajusta algo.

### Hito 3: Ecuación de gobierno

**La pregunta que responde:** ¿de qué principio físico sale mi modelo, y qué puedo despreciar?

- La ecuación derivada de un balance de masa, energía o momento
- Su versión adimensional
- Los términos despreciados, con la justificación numérica de por qué se desprecian

**Evidencia:** la derivación escrita y el número adimensional que gobierna su sistema, evaluado con
sus propios valores.

Este es el hito que separa un ajuste de curvas de un modelo con significado físico.

### Hito 4: Simulación verificada

**La pregunta que responde:** ¿mi solución numérica es correcta?

- La ecuación resuelta numéricamente, sea una EDO o una discretización unidimensional
- Estudio de convergencia: qué pasa al refinar el paso o la malla
- Contraste contra los datos del hito 1

**Evidencia:** la gráfica de convergencia y la comparación entre simulación y datos.

Verificar no es comparar contra los datos, eso es validar. Verificar es demostrar que resolvió bien
la ecuación que escribió, independientemente de si esa ecuación era la correcta.

### Hito 5: Optimización

**La pregunta que responde:** ¿cuál es el mejor diseño, y a costa de qué?

- El problema formulado: función objetivo, variables de diseño, restricciones
- El óptimo con restricciones, y cuáles quedaron activas
- El frente de Pareto de sus dos objetivos en conflicto

**Evidencia:** el frente de Pareto y la lectura del compromiso: qué se gana y qué se pierde al
moverse sobre él.

Aquí es donde se paga haber elegido bien el caso en la sesión de arranque. Si su fenómeno no tiene
una variable que el ingeniero pueda elegir, no hay nada que optimizar.

---

## El cierre: manuscrito y defensa

Los cinco hitos son las secciones del manuscrito. Al terminar, usted tiene un artículo corto de 6 a
8 páginas con esta estructura:

| Sección del manuscrito | Sale del hito |
|---|---|
| Introducción y planteamiento | 1 |
| Modelo y estimación de parámetros | 2 |
| Formulación y simplificación | 3 |
| Método numérico y verificación | 4 |
| Optimización y análisis de compromisos | 5 |
| Discusión, limitaciones y conclusiones | Cierre |

El manuscrito no se escribe al final: se escribe en pedazos, un hito a la vez. Cada avance que
entrega es material que ya va redactado en LaTeX y que solo hay que pegar y pulir.

## Cómo se ve la ruta a lo largo del semestre

| Turno | Hito esperado |
|---|---|
| Su turno 1 | Hito 1: planteamiento y datos |
| Su turno 2 | Hito 2: modelo y parámetros |
| Su turno 3 | Hito 3: ecuación de gobierno |
| Su turno 4 | Hito 4: simulación verificada |
| Su turno 5 | Hito 5: optimización |
| Cierre del semestre | Manuscrito completo y defensa |
