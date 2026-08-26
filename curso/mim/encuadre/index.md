---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)

# Sesión de arranque

De esta sesión salen tres cosas: su caso admitido, el calendario de turnos y su primer encargo. Es
la única sesión del semestre en la que no hay nadie en el banquillo.

---

## Antes de la sesión

Traiga **una página** sobre su tesis, escrita, con tres cosas y nada más:

1. **Qué mide.** La cantidad que su trabajo cuantifica en el laboratorio.
2. **Qué controla.** Lo que usted decide antes de hacer el experimento: una composición, una
   temperatura, un tiempo, una dosis, un espesor.
3. **Qué quiere lograr.** El resultado que perseguiría si todo saliera bien.

No traiga el marco teórico ni los antecedentes. Esas tres cosas son las que determinan si su tema se
puede modelar en este curso, y ninguna de ellas está en la introducción de su protocolo.

Tenga instalados [Matlab](../matlab), [LaTeX](../latex/) y git antes de la sesión.

---

## Durante la sesión

| Minutos | Qué pasa |
|---|---|
| 0 a 20 | Cómo funciona el curso: la clínica, los papeles, el encargo, las reglas duras |
| 20 a 60 | Cada quien presenta su tesis en 10 minutos y se extrae en vivo su pregunta de modelado |
| 60 a 75 | Se llenan las tres fichas y se sortea el orden de turnos |
| 75 a 90 | Alta en el repositorio, estructura de carpetas y primer push |

La dinámica completa está en [Dinámica del curso](../tutoria/). Léala antes si quiere llegar con
preguntas.

---

## La ficha de admisión

Su caso no es su tesis: es **un fenómeno** de su tesis. Para que sirva en este curso tiene que pasar
cuatro casillas, y las cuatro se llenan en esta sesión, en voz alta y entre todos:

| # | Casilla | Ejemplo |
|---|---|---|
| 1 | Una variable independiente continua | Tiempo, temperatura, posición, concentración |
| 2 | Una cantidad medible que el fenómeno produce | Longitud de grieta, porcentaje de remoción, resistencia |
| 3 | **Una variable de diseño**: algo que usted elige, no que observa | Espesor, fracción de refuerzo, temperatura de proceso |
| 4 | **Dos objetivos en conflicto** entre sí | Resistencia contra peso, remoción contra costo |

Las casillas 3 y 4 son las que deciden. Sin variable de diseño no hay nada que optimizar, y sin
conflicto entre objetivos el problema se resuelve subiendo un número hasta el tope. Si su tema no
las trae de entrada, no se cambia de tema: **se reencuadra**.

### Cómo se reencuadra un tema

La mayoría de las tesis de materiales llegan sin variable de diseño porque están escritas desde la
caracterización. Se saca así:

| Si su tesis es sobre... | La variable de diseño suele ser | Los dos objetivos en conflicto |
|---|---|---|
| Caracterización de un material nuevo | Un parámetro del proceso de obtención | La propiedad objetivo contra el tiempo o costo de proceso |
| Síntesis de un polímero o un compuesto | Composición, temperatura, tiempo de curado | Rendimiento contra energía consumida |
| Adsorción o remediación ambiental | Dosis de adsorbente, pH, tiempo de contacto | Porcentaje de remoción contra costo del adsorbente |
| Materiales para construcción | Fracción de reemplazo de cemento | Resistencia a compresión contra huella de carbono |
| Recubrimientos e ingeniería de superficies | Espesor, temperatura de depósito | Dureza contra adherencia |
| Desgaste y tribología | Carga, acabado superficial, tratamiento | Vida útil contra costo del tratamiento |

Su tema no tiene que aparecer en la tabla. Lo que tiene que aparecer es el patrón: **toda variable
que usted fija antes del experimento es candidata a variable de diseño**.

### Si todavía no tiene datos

No es un problema y no cambia nada. Se trabaja con un experimento sintético: un script que genera el
comportamiento del modelo verdadero, más ruido de medición y deriva, con semilla fija para que sea
reproducible. Cuando lleguen sus datos reales, se sustituye el archivo y todo lo demás sigue igual.

---

## Lo que sale de la sesión

- **Su `ficha.md`** subida al repositorio, con las cuatro casillas llenas y aprobadas
- **El calendario de turnos** del semestre, sorteado y escrito en el `README.md`
- **Su primer encargo**, dictado por el profesor y registrado en `encargos.md`
- **Su carpeta creada** en `alumnos/<su codigo>/` con el primer commit hecho

Quien salga de esta sesión sin ficha aprobada no tiene proyecto, y el primer turno le llega en tres
semanas. Vale la pena llegar con la página escrita.

---

## Alta en el repositorio

El profesor crea el repositorio privado y manda la invitación de colaborador al correo
institucional. **Acepte la invitación el mismo día**: mientras no la acepte, no puede hacer push y
no existe para el curso.

Los cuatro comandos de la sesión:

```console
> git clone <url-del-repositorio>
> cd mim-actividades-<ciclo>
> git add alumnos/<su-codigo>/ficha.md
> git commit -m "t00 ficha: caso admitido"
> git push
```

Antes de cualquier push posterior, siempre:

```console
> git pull
```

Si nunca ha usado git, con esos cinco comandos le alcanza para todo el semestre. La estructura de
carpetas y la regla de propiedad están en [Dinámica del curso](../tutoria/#el-repositorio).
