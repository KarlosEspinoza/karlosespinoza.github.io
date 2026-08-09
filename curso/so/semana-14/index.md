---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 14 - Revisión de avances 2

Cierre de las Unidades 3 y 4: administración de memoria, diagnóstico, llamadas al sistema y entrada/salida. Se agrega también la planificación de procesos de la semana 10, que cerró la Unidad 2 después de la revisión anterior.

El formato es el mismo de la revisión 1: **haces `push` antes**, yo reviso tu código y tu bitácora con anticipación, y **el día de la revisión la sesión se dedica solo a las preguntas**. La diferencia es que ahora tu servidor ya no es un ejercicio: mide su propia memoria, controla su saturación y deja rastro en disco de todo lo que hace.

---

- [Antes de la clase (entrega previa)](#antes-de-la-clase)
    - [Tu servidor debe](#tu-servidor-debe)
    - [Tu repositorio debe](#tu-repositorio-debe)
    - [Proyecto integrador](#integrador-entrega)
- [Durante la clase (revisión)](#durante-la-clase)
- [Lo que se evalúa](#lo-que-se-evalua)
    - [Cómo se califican las evidencias](#rubrica-evidencias)
    - [Cómo se califica la bitácora](#rubrica-bitacora)
    - [Cómo se califican las preguntas](#rubrica-preguntas)
- [Cómo prepararte](#como-prepararte)

---

## Antes de la clase (entrega previa) {#antes-de-la-clase}

Haz `push` a GitHub de tu código, tus evidencias y tu `BITACORA.md` **antes de la fecha de entrega**, que es antes del día de la revisión. **Si no hay push a tiempo, la revisión cuenta como no entregada.**

### Tu servidor debe {#tu-servidor-debe}

Todo lo de la revisión 1 sigue vigente: el servidor corre, atiende con hilos, el inventario está protegido y se apaga ordenadamente. Sobre eso, lo nuevo:

1. **Planificar los pedidos con una política elegible** (FIFO y SJF como mínimo), con estadísticas de espera promedio y máxima al terminar.

2. **Resolver la inanición**, con envejecimiento si elegiste SJF, o justificar por qué no aplica si elegiste FIFO.

3. **Cargar el catálogo en memoria una sola vez al arrancar**, en una estructura de acceso por clave, y reportar cuántos productos cargó y en cuánto tiempo.

4. **Reportar su propia memoria**: heap usado al arrancar, después de cargar el catálogo, y en el resumen final.

5. **Tener una cola acotada** (`BufferPedidos`) con una política de desbordamiento elegida y justificada, y contadores de aceptados, rechazados, descartados y ocupación máxima.

6. **No tener estructuras que crezcan sin límite.** Si guardas historial, tiene tope o va a disco.

7. **Emitir un recibo por venta confirmada** en `datos/recibos/`, con el formato de tu dominio.

8. **Registrar todos los pedidos** en `datos/pedidos.log`, atendidos y rechazados.

9. **Cerrar todos los descriptores que abre.** El número de `/proc/PID/fd` no crece con la carga.

10. **Tener un log que se pueda seguir con `tail -f`**, con la decisión de buffering tomada a propósito.

Los puntos 5 y 6 son los que más peso tienen. Un servidor que atiende bien cuando todo va bien no demuestra gran cosa; lo que se evalúa es que **sepa comportarse cuando lo saturas**, y que puedas enseñar la evidencia de las dos situaciones.

### Tu repositorio debe {#tu-repositorio-debe}

Lo de la revisión 1, más:

```
so-proyecto/
  src/
    PlanificadorPedidos.java       semana 10
    Producto.java                  semana 11
    BufferPedidos.java             semana 12
    GestorArchivos.java            semana 13
  datos/
    pedidos.log
    recibos/                       unos pocos ejemplos, no doscientos
  evidencias/
    planificacion.txt              semana 10, FIFO contra SJF
    memoria.txt                    semana 11, VmSize y VmRSS
    buffer.txt                     semana 12, las politicas de desbordamiento
    strace.txt                     semana 13, las llamadas al sistema
```

Y el `README.md` con tus decisiones de diseño escritas y justificadas: política de planificación, capacidad y política del buffer, estrategia de buffering del log, orden global de candados.

### Proyecto integrador {#integrador-entrega}

1. **El Servidor Central con contrapresión hacia las sucursales**, demostrada: una sucursal saturando no tumba a las otras dos.

2. **La decisión de dónde vive el catálogo** en el sistema integrado, implementada y justificada en el README.

3. **El log consolidado de las tres sucursales** en el central, y los recibos de cada sucursal por separado.

4. **La medición del sistema completo bajo saturación**: memoria de los cuatro procesos, ocupación de colas, rechazos por componente.

5. **Autoevaluación entre pares:** cada integrante actualiza su archivo `<codigo>.csv` y hace push **antes de la revisión**. Si no hay push, ese 10% se pierde en esta revisión.

---

## Durante la clase (revisión) {#durante-la-clase}

Igual que la revisión 1: **dos preguntas por alumno**, una sobre tu propio trabajo con tu código en pantalla, y otra sobre los temas de las unidades.

Lo que cambia en esta revisión es el tipo de pregunta sobre tu código. En la primera se preguntaba "dónde está y por qué". Ahora se pregunta **"cuánto y con qué evidencia"**: cuánta memoria ocupa cada producto de tu catálogo, cuántas llamadas al sistema cuesta un recibo, qué capacidad le pusiste al buffer y con qué medición lo decidiste.

Por eso las mediciones de las semanas 11 a 13 no son ejercicios sueltos: son las respuestas de esta revisión. Si están en tu bitácora con tus números, la contestas leyendo.

Puedes traer tu bitácora abierta.

---

## Lo que se evalúa {#lo-que-se-evalua}

| Instrumento | Prácticas | Proyecto integrador |
|---|---|---|
| Evidencias (código, commits, demo) | 50% | 45% |
| `BITACORA.md` | 30% | 25% |
| Dos preguntas | 20% | 20% |
| Autoevaluación entre pares | | 10% |

### Cómo se califican las evidencias {#rubrica-evidencias}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Los 10 puntos funcionan. Las decisiones de diseño están **justificadas con mediciones propias**, no con opiniones. El servidor se comporta bien bajo saturación y puede demostrarlo |
| **Bueno** | Funciona lo esencial (planificación, catálogo en memoria, buffer acotado, recibos). Alguna decisión sin medición que la respalde |
| **Suficiente** | El servidor escribe recibos y tiene el catálogo en memoria, pero la cola sigue sin límite o no hay mediciones |
| **Insuficiente** | No corre, no hay evidencias propias, o todos los commits son de los últimos días |

Lo que separa "excelente" de "bueno" en esta revisión es **la justificación con números**. "Le puse capacidad 50 al buffer" vale la mitad que "le puse 50 porque con mi carga la ocupación máxima fue 38 y con 200 los rechazos no bajaron pero la memoria subió 40 MB".

### Cómo se califica la bitácora {#rubrica-bitacora}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Las semanas 10 a 13 completas con sus dos subsecciones. **Las tablas de medición llenas con sus propios números.** Conceptos explicados con sus palabras y aplicados a su dominio. Atorones con las cuatro partes |
| **Bueno** | Las cuatro semanas, con explicaciones correctas y la mayoría de las tablas llenas |
| **Suficiente** | Faltan semanas, o las tablas de medición están vacías o copiadas del ejemplo de la guía |
| **Insuficiente** | No existe, o se escribió de golpe al final |

Una tabla de medición vacía se nota de inmediato y cuesta mucho, porque **la medición es el trabajo** de estas cuatro semanas.

### Cómo se califican las preguntas {#rubrica-preguntas}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Contesta las dos con precisión y **respalda con sus propias mediciones** |
| **Bueno** | Contesta las dos con la idea correcta, sin los números |
| **Suficiente** | Contesta una bien y la otra a medias |
| **Insuficiente** | No puede explicar sus propias decisiones de diseño |

---

## Cómo prepararte {#como-prepararte}

Como la vez pasada: corre tu sistema completo unos días antes, de principio a fin.

```bash
cd ~/so-proyecto/src
javac *.java

# Operacion normal
java -cp . GeneradorPedidos 100 | java -cp . ServidorPedidos SJF 2 50 > /tmp/normal.log 2>&1
tail -15 /tmp/normal.log            # planificacion, buffer, memoria, todo cuadra

ls ../datos/recibos | wc -l          # hay un recibo por venta confirmada
wc -l ../datos/pedidos.log           # hay una linea por pedido

# Bajo saturacion
java -cp . GeneradorPedidos 5000 | java -cp . ServidorPedidos SJF 1 20 | tail -8
# tiene que rechazar, no morir

# Memoria y descriptores
java -cp . ServidorPedidos ... &
PID=$!
grep -E "VmSize|VmRSS" /proc/$PID/status
ls /proc/$PID/fd | wc -l             # no crece con la carga
kill -15 $PID                        # apagado ordenado con resumen
```

Y cinco preguntas que conviene que puedas contestar sin dudar:

1. **Por qué `VmSize` de tu servidor es tanto mayor que `VmRSS`?** Con tus dos números.
2. **Cuánta RAM ocupa cada producto de tu catálogo en memoria, y por qué es más que en el archivo?**
3. **Qué capacidad le pusiste a tu buffer y con qué medición lo decidiste?**
4. **Cuántas llamadas al sistema cuesta emitir un recibo tuyo?** Enséñalas en tu `strace`.
5. **Si tu servidor desaparece sin dejar nada en el log, qué es lo primero que revisas?**

Si alguna falta justificada te cae el día de la revisión, se acuerda otra fecha (artículo 55 del Reglamento General de Evaluación y Promoción de Alumnos). Avísame en cuanto lo sepas, y tramita la justificación ante la Coordinación de Carrera.
