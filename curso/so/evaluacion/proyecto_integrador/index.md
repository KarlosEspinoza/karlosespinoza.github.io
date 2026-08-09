---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Proyecto integrador

**Ingeniería en Teleinformática - Quinto semestre**
**Valor: 50% de la calificación final**

El proyecto integrador es un **sistema multi-sucursal** desarrollado en equipo. Cada integrante aporta su propio Servidor de Pedidos, el que construye en sus prácticas, como una **sucursal** del sistema. Un **Servidor Central** las conecta, consolida la información de todas y ofrece una vista única del negocio.

El resultado es un sistema distribuido de verdad: varios procesos independientes corriendo sobre Linux, comunicándose por sockets, con un registro central de eventos y con las tres sucursales pudiendo caerse sin arrastrar a las demás. Es el mismo tipo de arquitectura que opera un punto de venta multi-tienda como SICAR.

---

- [Formación de equipos](#equipos)
- [Arquitectura del sistema](#arquitectura)
- [Lo que construyen, unidad por unidad](#lo-que-construyen)
- [El repositorio del equipo](#repositorio)
- [Cómo se revisa](#como-se-revisa)
    - [Las tres revisiones](#las-tres-revisiones)
    - [Cómo se califica cada instrumento](#rubricas)
- [Autoevaluación entre pares](#autoevaluacion)
- [Atributos de egreso](#atributos)

---

## Formación de equipos {#equipos}

- Equipos de **2 o 3 integrantes**. No se permiten de 1 ni de 4 o más.
- **Cada integrante tiene un dominio diferente**, porque cada uno aporta su sucursal.
- Se registra en la primera semana subiendo a Classroom un `equipo.csv` con una línea por integrante. Lo sube cada uno de los integrantes, el mismo archivo.

Ejemplo de un equipo de 3:

| Integrante | Dominio (sucursal) |
|---|---|
| Alumno A | Restaurante |
| Alumno B | Farmacia |
| Alumno C | Librería |

El Servidor Central **no pertenece a nadie en particular**: es responsabilidad compartida del equipo, y en la revisión cualquier integrante puede tener que explicarlo.

---

## Arquitectura del sistema {#arquitectura}

```
                   Servidor Central
        (registro consolidado + vista de sucursales)
                /          |          \
           [socket]     [socket]    [socket]
              |             |            |
        Sucursal A     Sucursal B   Sucursal C
        (Restaurante)  (Farmacia)   (Libreria)
              |             |            |
           Cajeros       Cajeros      Cajeros
          (clientes)   (clientes)   (clientes)
```

Cada sucursal es el `ServidorPedidos` de un integrante, con su propio inventario y su propio catálogo. Lo que se comparte no es el inventario: es **el formato de los mensajes** y los acuerdos de diseño.

---

## Lo que construyen, unidad por unidad {#lo-que-construyen}

| Unidad | Semanas | Lo que agrega el equipo |
|---|---|---|
| **U1** Perspectivas y Linux | 1 a 3 | Las tres sucursales corren a la vez en una máquina como procesos independientes. Acuerdan el formato de línea de un pedido, que va a durar todo el semestre |
| **U2** Procesos y concurrencia | 4 a 8, 10 | El Central atiende a las tres sucursales en hilos separados. Acuerdan el modelo de concurrencia y el orden global de candados del equipo. Demuestran la condición de carrera del sistema integrado y la resuelven, y diagnostican un interbloqueo entre dos componentes |
| **U3** Memoria | 11 y 12 | Deciden dónde vive el catálogo en el sistema integrado. El Central aplica contrapresión hacia las sucursales: una sucursal saturada no puede tumbar a las otras dos |
| **U4** Entrada y salida | 13 | Cada sucursal emite sus recibos y el Central lleva el registro consolidado de las tres |
| **U5** Archivos | 15 | El registro del Central va indexado, con consulta cruzada: un cajero de una sucursal consulta un pedido de otra |
| **U6** Red | 16 | Las sucursales dejan las tuberías y se conectan al Central **por socket**, en más de una computadora. Prueban los tres modos de falla |

Lo que se agrega cada semana viene en la sección **Proyecto integrador** de la [página de esa semana](/curso/so).

---

## El repositorio del equipo {#repositorio}

Un repositorio **privado** del equipo, con el asesor agregado como colaborador, aparte del repositorio individual de cada quien.

```
integrador-so/
  README.md            integrantes, dominios, como se corre, Y LOS ACUERDOS DEL EQUIPO
  BITACORA.md          bitacora del equipo
  src/
    ServidorCentral.java       conecta a todas las sucursales
    ConexionSucursal.java      un hilo por sucursal conectada
    RegistroCentral.java       el log consolidado, con su indice
    PanelAdmin.java            cliente que monitorea todo el sistema
  datos/
    central.log        eventos de todas las sucursales
  evidencias/          salidas de terminal del sistema completo
```

Las sucursales **no se copian aquí**: cada una vive en el repositorio individual de su dueño. Lo que el README del equipo tiene que decir es de quién es cada sucursal y cómo se lanza.

**El `README.md` del equipo es el documento más importante del integrador**, porque es donde viven los acuerdos. Sin escribir, un acuerdo no existe. Tiene que traer, como mínimo:

| Acuerdo | Se decide en |
|---|---|
| El formato de línea de un pedido | Semana 3 |
| El modelo de concurrencia (hilo por pedido o pool, y de qué tamaño) | Semana 4 |
| El orden global de candados | Semana 7 |
| La política de planificación del Central | Semana 10 |
| Dónde vive el catálogo y cómo se evita que los ids se repitan entre sucursales | Semanas 11 y 15 |
| El protocolo sucursal-Central | Semana 16 |

---

## Cómo se revisa {#como-se-revisa}

En las **mismas tres semanas** que las prácticas: 9, 14 y 17. El equipo hace `push` antes de la fecha de entrega, el asesor revisa el código y la bitácora con anticipación, y el día de la revisión la sesión se dedica a las preguntas. En la revisión final hay además **demostración en vivo**.

**Si no hay push a tiempo, la revisión cuenta como no entregada.**

Las preguntas son al equipo y **cualquier integrante puede tener que contestarlas**. Es a propósito: un sistema que solo entiende quien lo escribió no está integrado.

Además, **cada integrante actualiza y hace push de su autoevaluación antes de cada revisión** (ver abajo).

### Las tres revisiones {#las-tres-revisiones}

| | Semana | Qué cierra | Peso |
|---|---|---|---|
| Revisión 1 | 9 | Las tres sucursales corriendo, el Central concurrente, la condición de carrera del sistema demostrada y resuelta | 33% |
| Revisión 2 | 14 | Contrapresión, memoria del sistema completo, registro consolidado | 34% |
| Revisión final | 17 | Sockets, montaje en más de una máquina, consulta cruzada, los tres modos de falla, demo | 33% |

La lista contra la que se revisa está en la página de cada revisión:

- [Semana 9, proyecto integrador](/curso/so/semana-09#integrador-entrega)
- [Semana 14, proyecto integrador](/curso/so/semana-14#integrador-entrega)
- [Semana 17, proyecto integrador](/curso/so/semana-17#integrador-entrega)

### Cómo se califica cada instrumento {#rubricas}

| Instrumento | Peso dentro de la revisión |
|---|---|
| Evidencias: código, commits y funcionamiento del sistema completo | 45% |
| `BITACORA.md` del equipo | 25% |
| Dos preguntas el día de la revisión | 20% |
| Autoevaluación entre pares | 10% |

| Nivel | Qué se ve en las evidencias |
|---|---|
| Excelente | El sistema completo corre de punta a punta, montado en más de una máquina. Los acuerdos están escritos y se respetan en las tres sucursales. Los modos de falla están probados con evidencia. Commits de **todos** los integrantes, repartidos en el semestre |
| Bueno | El sistema corre y las sucursales se conectan, con algún acuerdo sin escribir o algún modo de falla sin probar |
| Suficiente | Las piezas funcionan por separado pero el sistema integrado no arranca completo |
| Insuficiente | No corre, o el historial muestra que lo hizo una sola persona |

**Los commits de todos los integrantes son parte de la evidencia.** Un repositorio donde el 90% de los commits son de una persona dice algo, y lo dice antes de que nadie pregunte.

---

## Autoevaluación entre pares {#autoevaluacion}

Cada integrante evalúa la contribución real de sus compañeros. Es **anónima entre ustedes**: nadie del equipo ve lo que pusieron los demás, solo el asesor. Vale el **10% de cada revisión**.

Para que sea anónima **no se entrega en el repositorio del equipo**, porque ahí todos se verían. Va por un canal privado y separado.

**Cómo se configura, una sola vez en el semestre:**

1. Crea un **repositorio privado** solo para tu autoevaluación, con el nombre que quieras (por ejemplo `autoeval-so`). Distinto de `so-proyecto`.
2. **Agrega al asesor como colaborador** (Settings, Collaborators, Add people, usuario `KarlosEspinoza`). Esa invitación es el aviso de que tu repositorio existe: no hace falta entregar la URL en ningún otro lado. Si quieres confirmarlo, mándala por **comentario privado** en la publicación de Classroom, que solo lee el asesor.
3. Dentro, crea un archivo de texto llamado con **tu propio código de alumno** y terminación `.csv`. Si tu código es `2162628`, el archivo se llama `2162628.csv`. **El nombre del archivo dice quién evalúa**, así que no lo cambies.

**El contenido** es una línea por cada compañero de tu equipo, con su código y la calificación de 0 a 100. No te incluyas a ti mismo.

```
codigo,calificacion
2152525,90
2178899,100
```

La primera línea es exactamente `codigo,calificacion`.

**Cómo se entrega:** antes de **cada una de las tres revisiones** actualizas tu archivo y haces `push`. Son tres entregas, no una: la participación de un compañero puede cambiar entre unidades y esto lo tiene que reflejar.

**Qué estás calificando:** si cumplió lo que le tocaba, si lo entregó a tiempo para que los demás pudieran seguir, y si se puede contar con él cuando algo se rompe. No es simpatía.

**Reglas:**

- La calificación que recibe cada integrante es el **promedio de lo que le pusieron sus compañeros**, ponderado con la evaluación del asesor.
- **Si no haces push antes de una revisión, pierdes ese 10% en esa revisión.** No afecta a tus compañeros: su promedio se calcula solo con las autoevaluaciones que sí se entregaron.

---

## Atributos de egreso {#atributos}

- **AE2, nivel introductorio:** identifica y resuelve problemas complejos de sistemas de información mediante el diseño de un sistema distribuido multi-sucursal que opera sobre Linux.
- **AE4, nivel medio:** reproduce un ambiente simulado que integra procesos concurrentes, gestión de memoria, entrada/salida y comunicación en red en un solo sistema funcional.
- **AE6, nivel medio:** desarrolla un sistema de información que permite analizar e interpretar datos consolidados de múltiples fuentes, evaluando el comportamiento del sistema operativo bajo carga concurrente.
