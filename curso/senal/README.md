# De la senal a la decision

> **Taller practico de adquisicion de senales y aprendizaje automatico en sistemas embebidos**

Taller de 7 horas para el grupo de 6to semestre de Ingenieria Mecatronica del CUCSUR, que
en el siguiente ciclo lleva **IE043 Inteligencia Artificial** (`../ia/`). Lo pidio el
coordinador de carrera para preparar al grupo.

Este archivo orienta a quien llegue en frio (persona o agente). El *por que* de cada
decision esta en `estrategia.md`; lo que falta por hacer, en `roadmap.md`.

---

## Datos duros

| | |
|---|---|
| Fechas | lunes 28 de septiembre de 2026 (3 h) y martes 29 (4 h) |
| Duracion | 7 horas |
| Cupo | 15 alumnos |
| Instructor | Karlos Espinoza, karlos.espinoza@academicos.udg.mx |
| Sistema operativo | Windows, los 15 |
| Hardware | Lo aporta cada participante. **El laboratorio no presta** |
| Kit | Arduino Nano, cable USB, protoboard, jumpers, resistencias, LDR, TCRT5000, LED RGB |
| Piezas a clasificar | cartulina blanca, cartulina negra, papel aluminio |
| Modelo | Arbol de decision (scikit-learn) |

---

## Por donde empezar

1. Lee `estrategia.md` completo. Son las decisiones y su porque.
2. Abre `roadmap.md` y busca la primera casilla sin marcar.
3. Trabaja esa tarea. Al terminar, marca la casilla.

Si una tarea obliga a cambiar una decision cerrada, **se actualiza `estrategia.md`
primero** y despues el material.

---

## Lo que el taller es y lo que no es

**Es** la puesta a punto del grupo antes de que empiece IE043: que lleguen en febrero con
el entorno instalado y probado, el kit comprado y funcionando, una cuenta de GitHub viva,
y el flujo completo recorrido una vez con las manos.

**No es** un curso de introduccion a la inteligencia artificial. Siete horas no alcanzan
para eso, y pretenderlo es lo que romperia el taller.

Cuando haya que decidir si algo entra o sale, gana el objetivo de arriba.

---

## Las cinco reglas de diseno

Son lo que hace que el flujo completo quepa en 7 horas. Si se rompe una, el taller no
cierra. El detalle esta en `estrategia.md`, seccion 5.

1. **Ninguna instalacion dentro del taller.** Se instala antes y se verifica con evidencia.
2. **Todo el codigo va escrito y entregado.** El participante ejecuta y modifica un
   parametro; no escribe desde cero. Esto distingue al taller de IE043, donde el alumno si
   escribe y se equivoca.
3. **Un solo camino.** Mismo sensor, mismas piezas, mismo codigo para los 15.
4. **Cero teoria.** Los conceptos se nombran al pasar, en una frase, cuando ocurren en la
   pantalla.
5. **Checkpoints de respaldo.** El USB lleva `datos.csv`, `features.csv` y `modelo.pkl` ya
   hechos, para que un atorado en una etapa no quede fuera de las siguientes.

---

## Estructura

```
curso/senal/
  README.md           <- este archivo (interno)
  estrategia.md       <- el porque de cada decision (interno)
  roadmap.md          <- tareas pendientes (interno)
  CLAUDE.md           <- instrucciones para Claude Code (interno)
  index.md            <- portada del taller
  requisitos/index.md <- LA GUIA PREVIA: instalacion y lista de compras
  programa/index.md   <- programa formal para el coordinador
  dia-01/index.md     <- sesion 1: del sensor a los datos
  dia-02/index.md     <- sesion 2: de los datos a la decision
  recurso/            <- NO se publica (Jekyll lo excluye)
    codigo/           <- los 7 archivos que se reparten en el USB
    checkpoints/      <- datos.csv, features.csv, modelo.pkl de respaldo
```

Los siete archivos de codigo usan **los mismos nombres que en IE043**, a proposito, para
que en febrero reconozcan el proyecto:

`sensor.ino`, `leer_sensor.py`, `adquirir.py`, `features.py`, `entrenar.py`,
`control.py`, `control.ino`

---

## Convenciones de escritura

Heredadas del repositorio (`../../CLAUDE.md`) y de IE043 (`../ia/CLAUDE.md`):

* **El nombre del taller se escribe con acentos en todo lo publicado**: "De la señal a
  la decisión". Sin acentos (`senal`) queda solo el nombre del directorio y los documentos
  internos, que se escriben sin acentos por convencion de este directorio.
* **Frontmatter obligatorio** en toda pagina publicada:
  ```yaml
  ---
  layout: default
  title: De la señal a la decisión
  ---
  ```
* **`[Inicio](/curso/senal)`** al principio de cada subpagina.
* **Sin caracteres especiales** en lo que ve el participante (`index.md`,
  `requisitos/`, `dia-01/`, `dia-02/`, `programa/`): prohibidos `---` largo, flechas
  tipograficas y similares. Usar `->`, `<-`, coma, dos guiones o reformular. Los archivos
  internos (`README.md`, `estrategia.md`, `roadmap.md`, `CLAUDE.md`) no tienen esta
  restriccion.
* **Indice con anclas explicitas `{#id}`** en las paginas largas, porque kramdown se come
  los acentos al generar los ids solos.
* **Windows siempre**: puertos `COM3`, `COM4`, `COM5`, nunca `/dev/ttyUSB0`. Rutas de
  Python con `/`.
* **El CMD es la unica terminal**, no la integrada de VS Code, no PowerShell, no Git Bash.
  VS Code es solo el editor y se abre con el comando `code <archivo>`; se ejecuta con
  `python <archivo>`. Se abre el CMD escribiendo `cmd` en la barra de direcciones del
  explorador, para que quede parado en la carpeta de trabajo. El porque, en `estrategia.md`,
  seccion 5.

---

## Lo que no hay que hacer

* **Reabrir las decisiones cerradas** de la fase 0 del roadmap sin una razon nueva.
* **Agregar contenido "porque cabe".** No cabe: son 7 horas con un grupo de nivel bajo,
  donde 30 minutos de contenido toman cerca de una hora real.
* **Meter temas de IE043** que quedaron fuera a proposito: FFT, normalizacion, redes
  neuronales, no supervisado, PLC. La lista completa y el porque estan en `estrategia.md`,
  seccion 9.
* **Escribir codigo incompleto a proposito.** Eso es la tecnica de IE043. Aqui el codigo
  va completo.
* **Suponer que hay internet** en el aula.

---

## Relacion con el curso de IE043

El taller es la version minima del caso central de IE043 (clasificador de piezas sobre
banda transportadora). La tabla que mapea cada bloque del taller con su semana del curso
esta en `estrategia.md`, seccion 10.

El hueco entre el taller (septiembre de 2026) y el curso (enero o febrero de 2027) es de
cuatro meses. Lo que sobrevive es el kit comprado y el entorno instalado; el codigo en los
dedos se olvida. Por eso el material se queda publicado en el sitio.
