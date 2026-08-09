---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 17 - Revisión final

Cierre del curso. Se revisa el sistema completo: el Servidor de Pedidos de principio a fin, con cajeros conectándose por red, inventario compartido protegido, memoria administrada, y todo lo que ocurre registrado en disco. Es el mismo sistema que dibujamos en el pizarrón en la semana 1, cuando todavía no sabíamos cómo se hacía nada de esto.

A diferencia de las dos revisiones anteriores, esta tiene **demostración en vivo**: hay que ponerlo a correr y enseñarlo funcionando. El código y la bitácora se revisan antes, como siempre, y la sesión se dedica a la demo y a las preguntas.

---

- [Antes de la clase (entrega previa)](#antes-de-la-clase)
    - [Tu servidor debe](#tu-servidor-debe)
    - [Tu repositorio debe](#tu-repositorio-debe)
    - [Proyecto integrador](#integrador-entrega)
- [Durante la clase (revisión)](#durante-la-clase)
    - [La demostración](#la-demostracion)
- [Lo que se evalúa](#lo-que-se-evalua)
    - [Cómo se califican las evidencias](#rubrica-evidencias)
    - [Cómo se califica la bitácora](#rubrica-bitacora)
    - [Cómo se califican las preguntas](#rubrica-preguntas)
- [Cómo prepararte](#como-prepararte)
- [Después del curso](#despues-del-curso)

---

## Antes de la clase (entrega previa) {#antes-de-la-clase}

Haz `push` a GitHub de todo tu trabajo **antes de la fecha de entrega**, que es antes del día de la revisión. **Si no hay push a tiempo, la revisión cuenta como no entregada.**

### Tu servidor debe {#tu-servidor-debe}

Todo lo de las revisiones 1 y 2 sigue vigente. Lo nuevo de las Unidades 5 y 6:

1. **Escribir el log de pedidos en modo append**, sin sobrescribir nunca lo anterior.

2. **Tener un índice de posiciones** que permita consultar un pedido por su id con acceso directo, sin recorrer el archivo.

3. **Persistir el índice**, de modo que el arranque no tenga que reconstruirlo leyendo el log completo.

4. **Aceptar conexiones de cajeros por socket**, con un hilo por conexión y un puerto propio.

5. **Tener un cliente `ClienteCajero`** que se conecte, mande pedidos y muestre la respuesta.

6. **Responder a cada pedido** con aceptación o rechazo, y con el motivo.

7. **Sobrevivir a la caída de un cajero** sin perder descriptores ni afectar a los demás.

8. **Cerrar todo lo que abre**: archivos y sockets. El número de descriptores vuelve a su valor de reposo después de la carga.

9. **Apagarse ordenadamente** con `SIGTERM`, cerrando conexiones, vaciando buffers y dejando el resumen completo.

10. **Cuadrar las cuentas de punta a punta**: lo que dicen los cajeros que compraron, lo que dice el log, lo que dicen los recibos y lo que dice el inventario final tienen que ser la misma historia.

El punto 10 es el que se mira con más cuidado. Un sistema donde el log dice una cosa y el inventario otra no está terminado, aunque cada pieza funcione por separado.

### Tu repositorio debe {#tu-repositorio-debe}

```
so-proyecto/
  README.md          quien eres, tu dominio, como se corre, y TUS DECISIONES DE DISENO
  BITACORA.md        las 16 semanas
  src/               las 12 clases del proyecto
  datos/             catalogo.txt, pedidos.log (muestra), recibos/ (muestra)
  evidencias/        las salidas de terminal de todo el semestre
```

El `README.md` es lo primero que se lee y esta semana pesa más que nunca. Tiene que traer, además de quién eres y cuál es tu dominio:

- **Cómo se compila y cómo se corre**, con los comandos exactos, incluyendo el modo red.
- **El protocolo** entre cajero y servidor.
- **Tus decisiones de diseño con su justificación**: política de planificación, capacidad y política del buffer, orden global de candados, estrategia de buffering, qué se hace con los recibos a largo plazo.

Escríbelo pensando en alguien que llega a tu repositorio sin haber tomado el curso. Es, literalmente, lo que va a pasar cuando lo enseñes buscando trabajo.

Y el historial de commits: **repartido a lo largo de las 16 semanas**, con los mensajes en formato.

### Proyecto integrador {#integrador-entrega}

1. **El sistema multi-sucursal completo**, con las sucursales conectadas al Servidor Central **por socket**, no por tubería.

2. **Montado en más de una computadora**, aunque sea el central en una máquina y una sucursal en otra.

3. **Consulta cruzada funcionando**: un cajero de una sucursal consulta un pedido de otra a través del central.

4. **Los tres modos de falla documentados con evidencia**: se cae una sucursal, se cae el central, se satura una sucursal.

5. **Autoevaluación entre pares:** cada integrante actualiza su archivo `<codigo>.csv` y hace push **antes de la revisión**. Es la última de las tres.

---

## Durante la clase (revisión) {#durante-la-clase}

La sesión tiene dos partes: la demostración y las preguntas.

### La demostración {#la-demostracion}

**Cinco minutos por alumno para las prácticas, diez por equipo para el integrador.** El tiempo es corto a propósito: hay que decidir antes qué enseñar.

Un guion que funciona, y que puedes seguir tal cual:

| Minuto | Qué enseñas |
|---|---|
| 0 a 1 | Arrancas el servidor. Se ve el catálogo cargado, el puerto escuchando, la memoria inicial |
| 1 a 2 | Conectas dos cajeros y mandas pedidos. Se ven las respuestas y los recibos apareciendo |
| 2 a 3 | Saturas: mandas más pedidos de los que puedes atender. **Rechaza, no muere** |
| 3 a 4 | Consultas un pedido por id con el índice. Enseñas `ss` y los descriptores |
| 4 a 5 | `kill -15`: apagado ordenado, resumen final, las cuentas cuadran |

Consejos de quien ha visto muchas demos fallar:

- **Ten todo compilado y el catálogo cargado antes de empezar.** Compilar en vivo se come la mitad del tiempo.
- **Ten las terminales ya abiertas** y en el directorio correcto.
- **No improvises el orden.** Escríbelo en un papel.
- **Si algo falla, sigue.** Una demo con un tropiezo explicado vale más que una demo abortada. Sabes diagnosticar: hazlo en voz alta, que también se evalúa.

### Las preguntas

**Dos por alumno**, igual que siempre: una sobre tu trabajo, con tu código en pantalla, y otra sobre los temas del curso. En esta última revisión las preguntas de tema pueden venir de **cualquiera de las seis unidades**, no solo de las últimas dos.

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
| **Excelente** | El sistema completo corre de punta a punta con cajeros por red. La demo sale. Las cuentas cuadran entre log, recibos e inventario. El `README.md` permite que un extraño lo corra. Commits repartidos en las 16 semanas |
| **Bueno** | El sistema corre y atiende por red, con algún punto de la lista incompleto o alguna incoherencia menor entre las cuentas |
| **Suficiente** | El servidor funciona en modo consola pero el modo red no está terminado, o el log no tiene índice |
| **Insuficiente** | No corre, o no hay demo, o el trabajo se hizo en los últimos días |

### Cómo se califica la bitácora {#rubrica-bitacora}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Las 16 semanas completas, con sus dos subsecciones, las tablas de medición llenas con números propios, los conceptos explicados con sus palabras y aplicados a su dominio, y los atorones documentados con las cuatro partes |
| **Bueno** | Las 16 semanas, con alguna incompleta y la mayoría de las mediciones |
| **Suficiente** | Faltan varias semanas, o las últimas están claramente escritas de golpe |
| **Insuficiente** | No existe o está sin terminar |

### Cómo se califican las preguntas {#rubrica-preguntas}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Contesta las dos con precisión, respalda con sus mediciones y **conecta unidades distintas** (por ejemplo, explica el límite de cajeros con lo de descriptores y memoria) |
| **Bueno** | Contesta las dos con la idea correcta |
| **Suficiente** | Contesta una bien y la otra a medias |
| **Insuficiente** | No puede explicar su propio sistema |

Lo que distingue "excelente" en esta última revisión es **conectar**. El curso entero está diseñado para que al final se vea que los zombis de la semana 2, las pilas de hilos de la semana 11 y los descriptores de la semana 13 son el mismo fenómeno: recursos finitos del sistema operativo que un descuido agota.

---

## Cómo prepararte {#como-prepararte}

Corre tu sistema completo, de punta a punta, **al menos dos días antes**. Con la demo, no solo con los comandos.

```bash
cd ~/so-proyecto/src
javac *.java

# 1. Arranque
java ServidorPedidos --red 5000 &
PID=$!
sleep 2
ss -ltnp | grep 5000
grep VmRSS /proc/$PID/status

# 2. Cajeros
java ClienteCajero localhost 5000     # en otra terminal, y otra mas

# 3. Saturacion
java CargaRed 200                      # rechaza, no muere
ss -tan | grep -c ESTAB

# 4. Consulta por indice
# desde un cajero: consulta 4711

# 5. Apagado
kill -15 $PID
# resumen completo, cuentas cuadradas

# 6. Coherencia de punta a punta
wc -l ../datos/pedidos.log
ls ../datos/recibos | wc -l
grep -c ATENDIDO ../datos/pedidos.log   # tiene que coincidir con los recibos
```

Y cinco preguntas que recorren el curso completo:

1. **Por qué tu servidor atiende con hilos y no con procesos?** Dos razones, las dos medidas.
2. **Enséñame la sección crítica y explícame por qué empieza donde empieza.**
3. **Cuánto le cuesta a tu servidor emitir un recibo, en llamadas al sistema?**
4. **Cuántos cajeros aguanta y qué recurso del SO se acaba primero?**
5. **Si tu servidor desaparece de madrugada sin dejar nada en el log, qué revisas y en qué orden?**

Si alguna falta justificada te cae el día de la revisión, se acuerda otra fecha (artículo 55 del Reglamento General de Evaluación y Promoción de Alumnos). Avísame en cuanto lo sepas, y tramita la justificación ante la Coordinación de Carrera.

---

## Después del curso {#despues-del-curso}

Dos cosas que conviene que hagas y que no valen puntos.

**Cambia tu repositorio a público.** Ya no hay razón para tenerlo privado, y lo que tienes ahí es un servidor concurrente, con manejo de memoria, persistencia indexada y red, construido en 16 semanas y documentado semana a semana. Es de las mejores cosas que puedes enseñar cuando busques trabajo, sobre todo para backend, DevOps o soporte de sistemas. La bitácora, que parecía un trámite, es lo que demuestra que entiendes lo que escribiste y no solo que lo copiaste.

**Vuelve a leer la tabla del bloque extra de la semana 1.** Aquella donde predijiste, sin saber nada, qué haría tu servidor en cada unidad y qué se rompería si el sistema operativo no se lo diera. Compárala con lo que acabas de construir. Esa comparación es el resumen del curso mejor que cualquier examen.
