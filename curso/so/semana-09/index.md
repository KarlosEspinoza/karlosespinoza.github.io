---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 9 - Revisión de avances 1

Cierre de las Unidades 1 y 2: perspectivas del sistema operativo, Linux, procesos y concurrencia. Es la primera de las tres revisiones del semestre y cubre ocho semanas de trabajo, desde que tu servidor era un proceso dormido hasta que atiende varios pedidos a la vez sin descuadrar el inventario.

La revisión funciona en dos tiempos, y conviene que lo tengas claro desde ahora: **tú haces `push` antes**, yo reviso tu código y tu bitácora con anticipación, y **el día de la revisión la sesión se dedica solo a las preguntas**. No hay que traer nada impreso ni presentar nada preparado; lo que se evalúa es lo que está en tu repositorio y lo que sepas contestar sobre él.

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

Revisa también, hoy y no ese día, que tu repositorio siga siendo privado y que mi usuario `KarlosEspinoza` aparezca como colaborador. Un repositorio al que no tengo acceso es un repositorio que no puedo evaluar.

### Tu servidor debe {#tu-servidor-debe}

Esta es la lista contra la que se revisa. Cada punto tiene que poder demostrarse con algo que esté en tu repositorio.

1. **Correr sobre Linux como un proceso identificable.** Tu `ServidorPedidos` arranca, registra su PID y se queda vivo esperando trabajo. Se puede observar desde fuera con `ps` y `top`.

2. **Escribir un registro de su actividad**, con hora, en la salida o en `datos/servidor.log`.

3. **Recibir pedidos en el formato acordado** (`ID;PRODUCTO;CANTIDAD`), tanto tecleados por consola como enviados por una tubería desde `GeneradorPedidos`.

4. **Atender cada pedido en su propio hilo.** Se tiene que poder ver que varios pedidos se traslapan en el tiempo, en el log y con `nlwp` o `top -H`.

5. **Tener un inventario compartido** (`GestorInventario`) cargado desde `datos/catalogo.txt`, con al menos 8 productos y existencias bajas.

6. **Demostrar la condición de carrera.** Con `PruebaCarrera` y la evidencia de las cinco corridas dando resultados distintos.

7. **Demostrar que la resolvió.** Con la sección crítica protegida y la evidencia de las cinco corridas dando el mismo resultado correcto.

8. **Demostrar un interbloqueo y su diagnóstico.** Con `PruebaBloqueo` y la salida de `jstack` donde se ve el ciclo.

9. **Apagarse de forma ordenada** al recibir `SIGTERM`: dejar de aceptar pedidos, terminar los que empezó, imprimir el resumen. Y no hacerlo con `SIGKILL`.

10. **Cuadrar las cuentas.** Al terminar una corrida con carga, existencia inicial menos ventas confirmadas tiene que ser igual a la existencia final, para cada producto.

Los puntos 6 y 7 juntos son el corazón de la revisión. Un servidor que nunca falló no demuestra nada: lo que se evalúa es que **puedas enseñar el sistema roto, el sistema arreglado, y explicar la diferencia**.

### Tu repositorio debe {#tu-repositorio-debe}

```
so-proyecto/
  README.md                        tu nombre, tu codigo, tu dominio, tu orden de candados
  BITACORA.md                      las 8 semanas, con sus dos subsecciones cada una
  src/
    ServidorPedidos.java
    GeneradorPedidos.java
    Pedido.java
    GestorInventario.java
    PruebaCarrera.java
    PruebaBloqueo.java
  datos/
    catalogo.txt                   al menos 8 productos, existencias bajas
    servidor.log
  evidencias/
    procesos.txt                   semana 2
    servidor.txt                   semana 2
    hijo.txt                       semana 3
    hilos.txt                      semana 4
    carrera.txt                    semana 5, las 5 corridas rotas
    carrera_resuelta.txt           semana 6, las 5 corridas correctas
    deadlock.txt                   semana 7, el jstack
    senales.txt                    semana 8, las 3 senales
```

Y el historial de commits, que es una evidencia en sí mismo: **commits repartidos a lo largo de las ocho semanas**, con los mensajes en el formato `sNN bloque 1:`, `sNN bloque 2:`, `sNN proyecto:`.

### Proyecto integrador {#integrador-entrega}

1. **Repositorio del equipo** con el sistema multi-sucursal, su README con los acuerdos del equipo (formato de línea de pedido, modelo de concurrencia, orden global de candados) y la bitácora del equipo.

2. **Las tres sucursales corriendo a la vez**, con evidencia de los tres procesos y sus PIDs.

3. **La condición de carrera del sistema integrado**, demostrada y resuelta.

4. **Autoevaluación entre pares:** cada integrante actualiza su archivo `<codigo>.csv` en su repositorio privado y hace push **antes de la revisión**. Si no hay push, ese 10% se pierde en esta revisión. No afecta a tus compañeros.

---

## Durante la clase (revisión) {#durante-la-clase}

La sesión se dedica a las preguntas. Son **dos por alumno**, orales o escritas, y salen de dos bolsas distintas:

- **Una sobre tu propio trabajo.** Se hace sobre tu código, abierto en la pantalla. Del tipo: "enséñame dónde está la sección crítica de tu servidor y explícame por qué empieza ahí y no dos líneas después".
- **Una sobre los temas de las unidades.** Del banco de preguntas de las ocho semanas. Del tipo: "por qué un zombi es un problema si no consume CPU ni memoria?".

Tres cosas que conviene que sepas de antemano:

- **Se puede contestar mal y seguir aprobando.** Las preguntas valen 20%. Lo que no se puede es no tener el trabajo.
- **La pregunta sobre tu código es la que más pesa** en la práctica, porque es donde se ve si el trabajo es tuyo. Si no puedes explicar por qué escribiste una línea, esa línea no cuenta como tuya.
- **Puedes traer tu bitácora abierta.** No es un examen de memoria. Si escribiste bien la bitácora, la mitad de las respuestas están ahí, y eso es exactamente lo que se quiere premiar.

Para el proyecto integrador, la pregunta es al equipo y cualquier integrante puede tener que contestarla.

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
| **Excelente** | Los 10 puntos de la lista funcionan. Las evidencias son de su propia máquina y son coherentes entre sí. El historial de commits está repartido a lo largo de las 8 semanas |
| **Bueno** | Funciona lo esencial (procesos, hilos, carrera demostrada y resuelta). Falta algún punto menor o alguna evidencia. Los commits están repartidos |
| **Suficiente** | El servidor corre y atiende con hilos, pero la condición de carrera no está demostrada o no está resuelta. Faltan varias evidencias |
| **Insuficiente** | El servidor no corre, o no hay evidencias propias, o todos los commits son de los últimos días |

El criterio que separa "excelente" de "bueno" no es la cantidad de código: es la **coherencia**. Que los PIDs de tu evidencia de la semana 2 sean plausibles, que tu catálogo tenga los productos que usa tu generador, que las cinco corridas rotas y las cinco resueltas vengan de la misma prueba.

### Cómo se califica la bitácora {#rubrica-bitacora}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Las 8 semanas con sus dos subsecciones. Los conceptos explicados **con sus propias palabras** y aplicados a su dominio. Los atorones documentados con las cuatro partes. Se nota que se escribió cada semana |
| **Bueno** | Las 8 semanas, con explicaciones correctas pero cercanas al texto de la guía. Algún hueco menor |
| **Suficiente** | Faltan semanas, o las entradas son listas de comandos sin explicación |
| **Insuficiente** | No existe, o son tres párrafos escritos de golpe al final |

Lo que más peso tiene aquí: **que las explicaciones sean tuyas y usen tu dominio**. Una bitácora que dice "el semáforo protege la sección crítica" vale la mitad que una que dice "puse el candado desde el `if` que consulta la existencia hasta el `put` que la descuenta, porque si lo pongo solo en el `put` dos cajeros pueden pasar el `if` con la última caja de amoxicilina".

### Cómo se califican las preguntas {#rubrica-preguntas}

| Nivel | Qué se ve |
|---|---|
| **Excelente** | Contesta las dos, con precisión, y puede señalar en su código dónde está lo que explica |
| **Bueno** | Contesta las dos con la idea correcta, aunque le falte precisión en algún término |
| **Suficiente** | Contesta una bien y la otra a medias |
| **Insuficiente** | No puede explicar su propio código |

---

## Cómo prepararte {#como-prepararte}

Lo más útil que puedes hacer no es repasar: es **correr tu propio sistema completo una vez, de principio a fin**, unos días antes. Casi todos los problemas aparecen ahí, con tiempo de arreglarlos.

```bash
cd ~/so-proyecto/src
javac *.java                                      # compila todo, sin errores

java GeneradorPedidos 200 | java ServidorPedidos > /tmp/final.log 2>&1 &
sleep 3
ps -o pid,nlwp,stat,%cpu -C java                  # varios hilos vivos
kill -15 $(pgrep -f ServidorPedidos)              # apagado ordenado
tail -12 /tmp/final.log                           # el resumen cuadra

java -cp . PruebaCarrera                           # cuadra siempre
java PruebaBloqueo &                               # se traba
jstack $(pgrep -f PruebaBloqueo) | grep -A 8 deadlock
kill -9 $(pgrep -f PruebaBloqueo)
```

Y tres preguntas que conviene que puedas contestar sin dudar, porque son las que más se preguntan:

1. **Enséñame tu sección crítica y dime dónde empieza y dónde termina, y por qué ahí.**
2. **Por qué usaste hilos y no procesos para atender los pedidos?** Dos razones, y las mediste las dos.
3. **Tu servidor está al 0% de CPU. Está bien o está mal?** Depende, y la respuesta es lo interesante.

Si alguna falta justificada te cae el día de la revisión, se acuerda otra fecha (artículo 55 del Reglamento General de Evaluación y Promoción de Alumnos). Avísame en cuanto lo sepas, y tramita la justificación ante la Coordinación de Carrera.
