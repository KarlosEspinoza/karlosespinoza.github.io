---
layout: default
title: Fundamentos de Sistemas Operativos
---
# Fundamentos de Sistemas Operativos

**IN235 - Ingeniería en Teleinformática, quinto semestre**

Este curso no se estudia, se construye. Durante el semestre vas a levantar un sistema completo: un **Servidor de Pedidos** que recibe pedidos desde varias terminales de cajero, los atiende al mismo tiempo y gestiona un inventario compartido. Es el mismo tipo de sistema que opera una empresa de punto de venta.

No hay temas sueltos. Cada semana le agrega una capa al mismo servidor: primero existe como proceso, luego atiende a varios cajeros a la vez sin romper el inventario, luego administra su memoria, luego escribe en archivos, y al final recibe conexiones por red desde otra máquina.

---

- [Empieza aquí](#empieza-aqui)
- [Cómo funciona cada semana](#como-funciona)
- [Las 17 semanas](#las-semanas)
- [Evaluación](#evaluacion)
- [Referencia](#referencia)

---

## Empieza aquí {#empieza-aqui}

1. **[Semana 1](/curso/so/semana-01)**: instala tu entorno, crea tu repositorio y elige el dominio de tu negocio.
2. **[Configuración del entorno](/curso/so/entorno)**: la versión larga de la instalación, con las fallas típicas de cada paso. Si algo se atora, está ahí.

---

## Cómo funciona cada semana {#como-funciona}

Cada semana tiene la misma forma:

| Sección | Qué es |
|---|---|
| **Antes de la clase** | Una guía de trabajo partida en dos bloques obligatorios y uno extra. Se trabaja durante la sesión, no la noche anterior |
| **Durante la clase** | Lo que hacemos en conjunto sobre lo que preparaste: medir, romper, depurar y comparar |
| **Avance de tu proyecto** | Lo que le agregas a tu servidor esa semana |

Cuatro reglas que valen para las 17 semanas:

- **Cada bloque termina con algo concreto que subes a tu repositorio**, con su propio commit. Un commit por bloque, nunca uno solo al final.
- **El bloque extra es opcional.** Es para quien terminó los dos primeros y quiere que su proyecto llegue más lejos. No hace falta para la clase del miércoles.
- **La clase arranca donde terminó tu guía.** Si no la trabajaste, no vas a tener con qué trabajar.
- **Si te atoras, lo documentas y haces commit igual.** Un bloque que no salió pero está bien documentado cuenta como entregado. El formato, con sus cuatro partes, está en la [semana 1](/curso/so/semana-01#como-se-trabaja).

---

## Las 17 semanas {#las-semanas}

| | Tema | Unidad |
|---|---|---|
| 1 | [Encuadre y configuración del entorno](/curso/so/semana-01) | U1 |
| 2 | [Linux y el primer proceso](/curso/so/semana-02) | U1 |
| 3 | [Contenedores y concepto de proceso](/curso/so/semana-03) | U1-U2 |
| 4 | [Hilos: pedidos concurrentes](/curso/so/semana-04) | U2 |
| 5 | [Condición de carrera](/curso/so/semana-05) | U2 |
| 6 | [Exclusión mutua y semáforos](/curso/so/semana-06) | U2 |
| 7 | [Bloqueos y sincronización](/curso/so/semana-07) | U2 |
| 8 | [Comunicación entre procesos](/curso/so/semana-08) | U2 |
| **9** | **[Revisión de avances 1](/curso/so/semana-09)** | **U1-U2** |
| 10 | [Planificación de procesos](/curso/so/semana-10) | U2 |
| 11 | [Administración de memoria](/curso/so/semana-11) | U3 |
| 12 | [Diagnóstico de memoria](/curso/so/semana-12) | U3 |
| 13 | [Llamadas al sistema y E/S](/curso/so/semana-13) | U4 |
| **14** | **[Revisión de avances 2](/curso/so/semana-14)** | **U3-U4** |
| 15 | [Sistemas de archivos](/curso/so/semana-15) | U5 |
| 16 | [Sockets y red](/curso/so/semana-16) | U6 |
| **17** | **[Revisión final](/curso/so/semana-17)** | **Todo** |

---

## Evaluación {#evaluacion}

| Rubro | Peso |
|---|---|
| [Proyecto integrador](/curso/so/evaluacion/proyecto_integrador) (en equipo) | 50% |
| [Prácticas](/curso/so/evaluacion/practicas) (tu proyecto individual) | 35% |
| Actividades integradoras (las coordina la carrera) | 5% |
| Asistencia | 10% |

Las prácticas y el proyecto integrador se califican en **tres revisiones de avances**, en las semanas 9, 14 y 17. En cada una haces `push` antes de la fecha de entrega, el asesor revisa tu código y tu bitácora con anticipación, y el día de la revisión la sesión se dedica a las preguntas.

**Si no hay push a tiempo, la revisión cuenta como no entregada.**

---

## Referencia {#referencia}

- [Programa del curso](/curso/so/programa)
- [Configuración del entorno](/curso/so/entorno)
- [Prácticas: instrucciones y rúbrica](/curso/so/evaluacion/practicas)
- [Proyecto integrador: instrucciones y rúbrica](/curso/so/evaluacion/proyecto_integrador)
