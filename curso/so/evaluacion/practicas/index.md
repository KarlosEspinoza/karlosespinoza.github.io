---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Prácticas

**Ingeniería en Teleinformática - Quinto semestre**
**Valor: 35% de la calificación final**

Las prácticas del curso son **un solo proyecto que construyes tú, semana a semana**: un Servidor de Pedidos para el dominio de negocio que elijas. No se entrega al final del semestre. Crece con cada tema, y lo que ves en la guía del lunes lo aplicas a tu sistema esa misma semana.

Al terminar tendrás un servidor funcional corriendo sobre Linux que atiende cajeros por red, protege un inventario compartido, administra su memoria y deja rastro en disco de todo lo que hace. En un solo sistema están los seis temas del curso y las cuatro cosas que pide hoy el trabajo real: operar Linux, concurrencia, diagnóstico y red.

---

- [Elige tu dominio](#dominio)
- [Lo que construyes, unidad por unidad](#lo-que-construyes)
- [Tu repositorio](#repositorio)
    - [Estructura](#estructura)
    - [BITACORA.md](#bitacora)
    - [Los commits](#commits)
    - [Si te atoras](#atorones)
- [Cómo se revisa](#como-se-revisa)
    - [Las tres revisiones](#las-tres-revisiones)
    - [Cómo se califica cada instrumento](#rubricas)
- [Sobre copiar](#sobre-copiar)
- [Atributos de egreso](#atributos)

---

## Elige tu dominio {#dominio}

El dominio es el tipo de negocio cuyo servidor construyes. Todos comparten la misma estructura, un servidor que recibe pedidos de varios cajeros y gestiona un inventario compartido, y lo que cambia es qué se pide y qué se agota.

| Dominio | Ejemplo de pedido | Ejemplo de inventario |
|---|---|---|
| Restaurante | Orden de platillos en mesa | Existencia de ingredientes |
| Farmacia | Solicitud de medicamentos | Stock de medicamentos |
| Librería | Pedido de libros | Ejemplares disponibles |
| Taller de servicio | Orden de reparación | Disponibilidad de técnicos |
| Renta de equipo | Reserva de herramientas | Unidades disponibles |
| Estacionamiento | Solicitud de lugar | Cajones libres |
| Veterinaria | Cita o servicio | Consultorios disponibles |

Tu dominio necesita cumplir dos cosas: que haya **algo que se pida** y **algo que se acabe**. Sin un recurso limitado no hay dos cajeros peleando por lo mismo, y ahí se cae la mitad del curso.

**Dos alumnos no pueden tener el mismo dominio**, porque cada uno será una sucursal distinta del proyecto integrador. Se registra en la primera semana y se resuelve por orden de commit.

Los dominios donde el recurso **se libera** (técnicos, consultorios, cajones, herramientas) son más ricos que los de consumo puro: dan mejores casos en las semanas 6 y 7. Si estás indeciso, ve por uno de esos.

---

## Lo que construyes, unidad por unidad {#lo-que-construyes}

| Unidad | Semanas | Lo que le agregas a tu servidor |
|---|---|---|
| **U1** Perspectivas y Linux | 1 a 3 | Tu servidor existe y corre como proceso sobre Linux. Lo observas desde fuera con `ps`, `top` y `/proc`, y lo pones a crear otro proceso. Entiendes qué es un contenedor y, opcionalmente, lo ejecutas en Docker |
| **U2** Procesos y concurrencia | 4 a 8, 10 | Cada pedido se atiende en su propio hilo. Demuestras la condición de carrera sobre el inventario y la resuelves. Provocas un interbloqueo y lo diagnosticas con `jstack`. Tu servidor se apaga de forma ordenada al recibir una señal, y planifica en qué orden atiende los pedidos |
| **U3** Memoria | 11 y 12 | El catálogo vive en memoria y mides lo que cuesta. La cola de pedidos deja de crecer sin límite y aprendes a distinguir las dos formas en que un proceso muere por falta de memoria |
| **U4** Entrada y salida | 13 | Tu servidor emite un recibo por venta y registra cada pedido. Ves las llamadas al sistema ocurrir con `strace` y entiendes el buffering |
| **U5** Archivos | 15 | El log de pedidos se escribe en append y le construyes un índice para consultar un pedido por su id sin recorrer el archivo |
| **U6** Red | 16 | El cajero se convierte en un cliente que se conecta por socket, desde otra máquina, y tu servidor atiende a varios a la vez |

El detalle de cada semana está en la [lista de actividades](/curso/so). Ahí viene qué se hace, qué se entrega y qué archivos se agregan.

---

## Tu repositorio {#repositorio}

Es **privado**, se llama `so-proyecto`, y tiene al usuario `KarlosEspinoza` agregado como colaborador. Privado porque todos los repositorios del grupo se llaman igual y uno público lo encuentra cualquiera buscando el nombre. **Sin la invitación de colaborador tu trabajo es invisible y cuenta como no entregado.**

La URL se entrega en Google Classroom **una sola vez en todo el semestre**. De ahí en adelante tu entrega es hacer `push`.

Al terminar el curso puedes cambiarlo a público si quieres enseñarlo cuando busques trabajo.

### Estructura {#estructura}

Es la misma para todo el grupo y para todo el semestre. No la cambies: es la que permite revisar tu proyecto sin andar buscando archivos.

```
so-proyecto/
  README.md          quien eres, tu dominio, como se corre y tus decisiones de diseno
  BITACORA.md        una seccion por semana
  src/               todo el codigo Java
  datos/             catalogo.txt, pedidos.log, servidor.log, recibos/
  evidencias/        salidas de terminal: procesos.txt, strace.txt, deadlock.txt, ...
```

Las clases van creciendo con las semanas. Al final del curso tu `src/` tiene esto:

| Archivo | Aparece en |
|---|---|
| `ServidorPedidos.java` | Semana 2, y crece casi todas las semanas |
| `GeneradorPedidos.java` | Semana 3 |
| `Pedido.java` | Semana 3 |
| `GestorInventario.java` | Semana 5, protegido en la 6, con caché en la 11 |
| `PruebaCarrera.java` | Semana 5 |
| `PruebaBloqueo.java` | Semana 7 |
| `PlanificadorPedidos.java` | Semana 10 |
| `Producto.java` | Semana 11 |
| `BufferPedidos.java` | Semana 12 |
| `GestorArchivos.java` | Semana 13, con índice en la 15 |
| `ClienteCajero.java` | Semana 16 |

**Los nombres no se cambian.** La progresión de las semanas los encadena, y un archivo renombrado a media semana rompe lo que viene después.

`evidencias/` es propia de este curso. En Sistemas Operativos buena parte de lo que demuestras **no es código: es la salida de un comando**, con tus propios números de proceso y tus propios tiempos medidos. Sin un lugar fijo se pierde.

### BITACORA.md {#bitacora}

Es donde explicas **con tus propias palabras** qué entendiste y cómo lo aplicaste. No es un trámite: **vale el 30% de cada revisión**, y es lo que más se nota cuando se escribe a última hora.

Lleva una sección por semana, y cada semana tiene siempre las mismas dos partes:

```markdown
## Semana 5 - Condición de carrera

### Antes de la clase

(los entregables de los bloques de la guía)

### Avance del proyecto

(lo que le agregaste a tu servidor)
```

Lo que más peso tiene es que las explicaciones sean **tuyas y de tu dominio**. "El semáforo protege la sección crítica" vale la mitad que "puse el candado desde el `if` que consulta la existencia hasta el `put` que la descuenta, porque si lo pongo solo en el `put` dos cajeros pueden pasar el `if` con la última caja de amoxicilina".

Y a partir de la semana 10, las **tablas de medición llenas con tus propios números**. La medición es el trabajo de esas semanas; una tabla vacía se nota de inmediato.

### Los commits {#commits}

El mensaje del commit dice qué estabas haciendo sin que haya que abrir nada. Usa siempre este formato, donde `sNN` es el número de semana:

| Cuándo | Mensaje |
|---|---|
| Al terminar el bloque 1 | `s05 bloque 1: seccion critica e intercalado` |
| Al terminar el bloque 2 | `s05 bloque 2: condicion de carrera reproducida` |
| Si hiciste el bloque extra | `s05 extra: barrido de configuraciones` |
| Al terminar el avance del proyecto | `s05 proyecto: inventario compartido` |

**Un commit al terminar cada bloque, no uno solo al final.** El historial repartido a lo largo de las semanas es evidencia en sí mismo, y se mira en cada revisión.

### Si te atoras {#atorones}

Es la regla más importante del semestre. **Nunca te quedes sin entregar por no haberlo logrado:** un bloque que no salió, pero que está bien documentado, **cuenta como entregado, completo**.

Documentado quiere decir cuatro cosas, en una subsección `#### Atorones` de tu bitácora:

1. El **comando exacto** que ejecutaste.
2. El **mensaje de error completo, copiado y pegado**, no descrito de memoria.
3. **Qué intentaste**, en orden, mínimo dos cosas.
4. **Dónde te quedaste** exactamente.

El formato completo, con ejemplo, está en la [semana 1](/curso/so/semana-01#como-se-trabaja).

Un "no me salió" a secas no cuenta.

---

## Cómo se revisa {#como-se-revisa}

El proyecto se revisa **tres veces**, en las semanas 9, 14 y 17. Cada revisión funciona igual:

1. **Haces `push` antes de la fecha de entrega**, que es antes del día de la revisión.
2. **El asesor revisa tu código y tu bitácora con anticipación.**
3. **El día de la revisión la sesión se dedica solo a las preguntas.**

**Si no hay push a tiempo, la revisión cuenta como no entregada.** No hay nada que revisar.

Las preguntas son **dos**, orales o escritas. Una sobre **tu propio trabajo**, con tu código en pantalla ("enséñame dónde está tu sección crítica y por qué empieza ahí"). Otra sobre **los temas de las unidades** ("por qué un zombi es un problema si no consume CPU ni memoria"). Puedes tener tu bitácora abierta: no es un examen de memoria, y si la escribiste bien, la mitad de las respuestas están ahí.

### Las tres revisiones {#las-tres-revisiones}

| | Semana | Qué cierra | Peso |
|---|---|---|---|
| Revisión 1 | 9 | Unidades 1 y 2: Linux, procesos, hilos, concurrencia | 33% |
| Revisión 2 | 14 | Unidades 3 y 4, más planificación: memoria, diagnóstico, llamadas al sistema | 34% |
| Revisión final | 17 | Unidades 5 y 6: archivos, red, y el sistema completo con demostración en vivo | 33% |

**La lista contra la que se revisa vive en la página de cada revisión**, y es la única versión que cuenta:

- [Semana 9: lo que debe tener tu servidor](/curso/so/semana-09#tu-servidor-debe)
- [Semana 14: lo que se agrega](/curso/so/semana-14#tu-servidor-debe)
- [Semana 17: el sistema completo](/curso/so/semana-17#tu-servidor-debe)

Ahí viene también cómo prepararte, con la corrida de punta a punta que conviene hacer unos días antes.

### Cómo se califica cada instrumento {#rubricas}

| Instrumento | Peso dentro de la revisión |
|---|---|
| Evidencias: código en GitHub, commits, demostración | 50% |
| `BITACORA.md` | 30% |
| Dos preguntas el día de la revisión | 20% |

**Evidencias**

| Nivel | Qué se ve |
|---|---|
| Excelente | Funciona todo lo de la lista. Las evidencias son de tu máquina y coherentes entre sí. Las decisiones de diseño están justificadas con mediciones propias. Commits repartidos a lo largo de las semanas |
| Bueno | Funciona lo esencial. Falta algún punto menor o alguna justificación |
| Suficiente | El servidor corre, pero falta lo central de la unidad (la condición de carrera sin demostrar, la cola sin límite, el modo red sin terminar) |
| Insuficiente | No corre, no hay evidencias propias, o todos los commits son de los últimos días |

Lo que separa excelente de bueno **no es la cantidad de código: es la coherencia y la justificación**. Que tu catálogo tenga los productos que usa tu generador. Que las cinco corridas rotas y las cinco resueltas vengan de la misma prueba. Que puedas decir por qué le pusiste esa capacidad al buffer y con qué medición lo decidiste.

**BITACORA.md**

| Nivel | Qué se ve |
|---|---|
| Excelente | Todas las semanas con sus dos subsecciones, conceptos explicados con tus palabras y aplicados a tu dominio, tablas de medición llenas con tus números, atorones con las cuatro partes |
| Bueno | Todas las semanas, con explicaciones correctas pero cercanas al texto de la guía |
| Suficiente | Faltan semanas, o son listas de comandos sin explicación, o las tablas están vacías |
| Insuficiente | No existe, o se escribió de golpe al final |

**Preguntas**

| Nivel | Qué se ve |
|---|---|
| Excelente | Contestas las dos con precisión y puedes señalar en tu código dónde está lo que explicas |
| Bueno | Contestas las dos con la idea correcta, aunque falte precisión en algún término |
| Suficiente | Contestas una bien y la otra a medias |
| Insuficiente | No puedes explicar tu propio código |

Si una falta justificada te cae el día de una revisión, se acuerda otra fecha (artículo 55 del Reglamento General de Evaluación y Promoción de Alumnos). Avisa en cuanto lo sepas y tramita la justificación ante la Coordinación de Carrera.

---

## Sobre copiar {#sobre-copiar}

Cada quien tiene un dominio distinto, su propio catálogo y sus propios productos. Pero además, en este curso **las evidencias son salidas de tu propia máquina**: tus números de proceso, tus tiempos medidos, el rastro de llamadas al sistema de tu proceso, tus cinco corridas con sus números irrepetibles. El código de otro no produce tus números.

Y el 20% de cada revisión son preguntas sobre tu propio código, en el momento. Ahí es donde se cae el trabajo que no hiciste tú: **si no puedes explicar por qué escribiste una línea, esa línea no cuenta como tuya.**

Apoyarse en un compañero para entender está bien y es parte del curso. Copiar se ve.

---

## Atributos de egreso {#atributos}

- **AE2, nivel introductorio:** identifica y resuelve problemas de sistemas de información mediante la implementación de un servidor concurrente que opera sobre Linux y gestiona memoria, archivos y red.
- **AE4, nivel medio:** reproduce un ambiente simulado (el servidor de pedidos) que demuestra el comportamiento del sistema operativo ante concurrencia, administración de memoria, entrada/salida y comunicación en red.
