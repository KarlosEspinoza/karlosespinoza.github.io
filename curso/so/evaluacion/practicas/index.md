---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Prácticas

**Ingeniería en Teleinformática - Quinto Semestre**  
**Valor:** 35% de la calificación final

---

## Descripción general

Las prácticas del curso consisten en construir, de manera **individual**, un Servidor de Pedidos para el dominio de negocio que tú elijas. El servidor no se entrega al final del semestre: **crece semana a semana** conforme avanzamos en los temas del curso. Lo que vemos en clase lo adaptas ese mismo día a tu sistema y lo registras en tu BITACORA.md.

Al finalizar el semestre tendrás un servidor funcional, corriendo sobre Linux, que demuestra en un solo sistema todos los conceptos del SO vistos en clase y las prácticas que pide hoy el campo laboral (operar Linux, concurrencia, diagnóstico, archivos y red).

---

## Elige tu dominio

El dominio es el tipo de negocio cuyo servidor construyes. Todos los dominios comparten la misma estructura: un servidor que recibe pedidos de múltiples clientes y gestiona un inventario compartido.

| Dominio | Ejemplo de pedido | Ejemplo de inventario |
|---|---|---|
| Restaurante | Orden de platillos en mesa | Existencia de ingredientes |
| Farmacia | Solicitud de medicamentos | Stock de medicamentos |
| Librería | Pedido de libros | Ejemplares disponibles |
| Taller de servicio | Orden de reparación | Disponibilidad de técnicos |
| Renta de equipo | Reserva de herramientas | Unidades disponibles |
| Estacionamiento | Solicitud de lugar | Cajones libres |
| Veterinaria | Cita o servicio | Consultorios disponibles |

> Dos alumnos no pueden elegir el mismo dominio. Regístralo con el asesor durante la primera semana.

---

## Lo que construyes, capa por capa

El servidor parte de cero en la semana 1 y crece con cada unidad. Cada tema que vemos en clase lo aplicas de inmediato en tu proyecto:

| Unidad | Lo que agregas a tu servidor |
|---|---|
| **U1** Perspectivas y Linux | Tu servidor corre sobre Linux (WSL2). Lo observas como proceso con `ps` y `top`, rediriges su salida a un log y lo consultas. Explicas qué es un contenedor (namespaces, cgroups) y, de forma opcional, lo ejecutas dentro de Docker para ver el aislamiento. |
| **U2** Procesos y concurrencia | Cada pedido se procesa en un hilo. El inventario compartido se protege con semáforo: demuestras la condición de carrera y su solución. Tu servidor maneja una señal para apagarse de forma ordenada y (opcional) comunica dos procesos con un pipe. |
| **U3** Memoria y diagnóstico | El catálogo se carga en memoria (HashMap) al arrancar. Implementas un buffer de pedidos pendientes con tamaño máximo. Mides el consumo de memoria y explicas qué pasa ante una fuga o el OOM killer. |
| **U4** E/S | El servidor lee el catálogo desde `catalogo.txt` al inicio y escribe un recibo en archivo por cada pedido atendido. Identificas las llamadas al sistema involucradas. |
| **U5** Archivos | Los pedidos se persisten en `pedidos.log` (organización secuencial). El catálogo permite búsqueda directa por ID de producto. |
| **U6** Red | El cajero/cliente se conecta al servidor por socket. El servidor atiende al menos 2 clientes simultáneos. |

---

## Estructura del repositorio

```
proyecto-individual/
  README.md                # Tu nombre, dominio elegido y descripción del proyecto
  BITACORA.md              # Explicación semanal: cómo aplicaste cada tema del SO
  src/
    ServidorPedidos.java   # Servidor principal: proceso, hilos, concurrencia
    Pedido.java            # Modelo del pedido (datos del pedido)
    GestorInventario.java  # Inventario compartido protegido con semáforo
    GestorArchivos.java    # Lectura del catalogo y escritura de recibos y log
    ClienteCajero.java     # Terminal de cajero: cliente que se conecta por socket
  catalogo.txt             # Catalogo de productos o servicios del dominio
  pedidos.log              # Registro persistente de todos los pedidos atendidos
```

> Entregas la URL de tu repositorio en Google Classroom **una sola vez** al inicio del semestre. Todas las revisiones se hacen sobre el mismo repo actualizado.

---

## Revisiones de avances

El proyecto se revisa **3 veces** a lo largo del semestre. Debes hacer **push a GitHub de tus avances antes del día de la revisión** (a más tardar en la sesión previa de esa semana), de modo que el asesor revise tu código y tu BITACORA.md con anticipación. El día de la revisión la sesión se dedica únicamente a las **preguntas (orales o escritas, en papel o en archivo de texto)** sobre lo que entregaste. Si no hiciste el push a tiempo, no hay nada que revisar y la revisión cuenta como no entregada. En cada revisión cuentan:

| Instrumento | Peso dentro de la revisión |
|---|---|
| Evidencias: código, commits y funcionamiento del servidor entregados en GitHub antes de la revisión | 50% |
| BITACORA.md: explicación, con tus palabras, de los conceptos aplicados | 30% |
| 2 preguntas (orales o escritas) sobre tu sistema y los conceptos del curso, el día de la revisión | 20% |

---

### Revisión 1 - Miércoles 14 de octubre
**Unidades 1 y 2: Perspectivas, Linux, Procesos y Concurrencia**

**El servidor debe:**
- Correr sobre Linux (WSL2) como proceso identificable (lo muestras con `ps` o `top`) y registrar su actividad en un log
- Aceptar pedidos por consola y procesarlos en **hilos separados**
- Demostrar una **condición de carrera** sobre el inventario (versión sin protección)
- Resolver la condición de carrera con un **semáforo** (versión final)
- Manejar una **señal** para apagado ordenado (por ejemplo SIGINT); de forma opcional, comunicar dos procesos con un **pipe**

**La BITACORA.md debe explicar:**
- ¿Qué es un proceso y cómo vive tu servidor en el SO? ¿Qué es un contenedor?
- ¿Por qué usar hilos para los pedidos?
- ¿Qué es la condición de carrera y cómo la resolviste en tu inventario?

---

### Revisión 2 - Miércoles 18 de noviembre
**Unidades 3 y 4: Memoria, diagnóstico y E/S**

**El servidor debe:**
- Leer `catalogo.txt` al arrancar y cargarlo en memoria (HashMap)
- Mantener un **buffer en memoria** de pedidos pendientes con capacidad máxima
- **Diagnosticar** su uso de memoria: qué pasa cuando el buffer se llena y qué significan una fuga de memoria y el OOM killer
- Escribir un **recibo en archivo** (`recibo_NNN.txt`) por cada pedido atendido
- Identificar las **llamadas al sistema** involucradas (apertura, lectura, escritura, cierre)

**La BITACORA.md debe explicar:**
- ¿Cómo organiza tu servidor el catálogo en memoria?
- ¿Qué pasa si el buffer de pedidos se llena y cómo lo diagnosticas?
- ¿Qué llamadas al sistema realiza tu servidor al leer el catálogo y al escribir el recibo?

---

### Revisión 3 - Miércoles 9 de diciembre
**Unidades 5 y 6: Archivos y Red - Sistema completo**

**El servidor debe:**
- Persistir todos los pedidos en `pedidos.log` en **organización secuencial**
- Permitir consultar un pedido por su ID (acceso directo al log)
- Aceptar conexiones de **clientes por socket** (`ClienteCajero.java`)
- Atender al menos **2 cajeros simultáneos** sin perder pedidos
- Demostrar el sistema completo: cajero -> socket -> servidor -> archivo

**La BITACORA.md debe incluir una sección por cada unidad** del curso explicando cómo se aplica ese concepto en tu servidor.

---

## Calificación

Cada revisión vale aproximadamente un tercio de la calificación de las prácticas.

| Revisión | Fecha | Peso |
|---|---|---|
| Revisión 1 | 14 de octubre | 33% |
| Revisión 2 | 18 de noviembre | 34% |
| Revisión 3 | 9 de diciembre | 33% |

> Las prácticas equivalen al **35% de la calificación final del curso**.

---

## Atributos de Egreso

- **AE2 Nivel Introductorio:** Identifica y resuelve problemas de sistemas de información mediante la implementación de un servidor concurrente que opera sobre Linux y gestiona memoria, archivos y red.
- **AE4 Nivel Medio:** Reproduce un ambiente simulado (servidor de pedidos) que demuestra el comportamiento del SO ante concurrencia, administración de memoria, E/S y comunicación en red.
