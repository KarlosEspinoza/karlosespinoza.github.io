# CLAUDE.md — Taller: De la senal a la decision

Materiales del taller practico de adquisicion de senales y aprendizaje automatico en
sistemas embebidos, para 6to semestre de Ingenieria Mecatronica, CUCSUR UdeG.

**Instructor:** Karlos Espinoza (karlos.espinoza@academicos.udg.mx)
**Fechas:** lunes 28 (3 h) y martes 29 (4 h) de septiembre de 2026, 7 horas en total
**Cupo:** 15 alumnos, Windows los 15, cada quien aporta su kit
**Origen:** peticion del coordinador de carrera, para preparar al grupo que en el
siguiente ciclo lleva **IE043 Inteligencia Artificial** (`../ia/`)

Este archivo es el resumen operativo. El detalle esta en los tres documentos internos de
abajo y no se repite aqui.

---

## Las tres fuentes de verdad, y en que orden se leen

| Archivo | Que es | Cuando se toca |
|---|---|---|
| `README.md` | Orientacion para quien llega en frio: datos duros, reglas, convenciones | Cuando cambia algo que un recien llegado necesita saber de inmediato |
| `estrategia.md` | El **porque** de cada decision. Es la fuente de verdad del diseno | **Primero**, antes que el material, siempre que una tarea obligue a mover una decision |
| `roadmap.md` | Las tareas pendientes, con casillas y fechas | Se marca la casilla al terminar cada tarea |

Flujo de trabajo, tal como lo fija `README.md`:

1. Leer `estrategia.md` completo.
2. Abrir `roadmap.md` y buscar la primera casilla sin marcar.
3. Trabajar esa tarea y marcar la casilla al terminar.

Si una tarea obliga a cambiar una decision cerrada (fase 0 del roadmap), **se actualiza
`estrategia.md` primero** y despues el material. Los acuerdos posteriores al 2026-09-18 se
anotan en la bitacora al final de `roadmap.md`.

**K** = lo hace Karlos, **C** = lo escribe Claude, **KC** = en sesion. Las tareas **K**
(probar el hardware, armar el USB, hablar con el coordinador, el ensayo) no se pueden
cerrar desde aqui: se le recuerdan a Karlos, no se marcan solas.

---

## Estado

Hoy solo existen `README.md`, `estrategia.md` y `roadmap.md`. **Todo lo publicable esta
por escribirse** (`index.md`, `requisitos/`, `programa/`, `dia-01/`, `dia-02/`,
`recurso/`), y el directorio completo todavia no esta en git. El taller tampoco aparece
aun en `curso/index.md` ni en el menu `navigation:` de `_config.yml`; son tareas de la
fase 4 del roadmap.

---

## Comandos

Jekyll se sirve **desde la raiz del repositorio**, no desde este directorio:

```bash
cd /home/karlos/gh/karlosespinoza.github.io
make run     # jekyll serve + abre Chrome en http://127.0.0.1:4000/
make local   # jekyll serve --host 0.0.0.0 --livereload (sin abrir Chrome)
```

El taller queda en <http://127.0.0.1:4000/curso/senal/>. No hay build ni tests: la unica
prueba real del material es correr los 7 archivos de codigo contra el hardware, y esa es
tarea de Karlos (fase 3 y ensayo de la fase 7).

---

## Lo que manda cuando hay que decidir

El objetivo real, el que gana sobre el objetivo declarado del programa, es que el martes
29 a las 13:00 los 15 participantes tengan: entorno instalado y probado, kit comprado y
funcionando, cuenta de GitHub viva con un push hecho, y el flujo completo recorrido una
vez con las manos. **No es que aprendan aprendizaje automatico**; 7 horas no alcanzan y
pretenderlo es lo que romperia el taller.

De ahi salen las cinco reglas de diseno (detalle en `estrategia.md`, seccion 5). Si se
rompe una, el taller no cierra:

1. **Ninguna instalacion dentro del taller.** Se instala antes y se verifica con evidencia.
2. **Todo el codigo va escrito y entregado.** El participante ejecuta y modifica un
   parametro; no escribe desde cero. Esto distingue al taller de IE043.
3. **Un solo camino.** Mismo sensor, mismas piezas, mismo codigo para los 15.
4. **Cero teoria.** Los conceptos se nombran al pasar, cuando ocurren en la pantalla.
5. **Checkpoints de respaldo.** `datos.csv`, `features.csv` y `modelo.pkl` ya hechos en el
   USB, para que un atorado en una etapa no quede fuera de las siguientes.

Calibracion heredada de IE043: **30 minutos de contenido toman cerca de una hora real.**

---

## El caso y los 7 archivos

Clasificador de tres piezas (cartulina blanca, cartulina negra, papel aluminio) con
LDR + TCRT5000, arbol de decision de scikit-learn y un LED RGB que muestra la decision.
El arbol se eligio por `export_text`: imprime las reglas que aprendio, y esa es la unica
idea conceptual que el taller se compromete a dejar instalada.

Los siete archivos viven en `recurso/codigo/` y usan **los mismos nombres que en IE043**,
a proposito, para que en febrero reconozcan el proyecto. No renombrarlos:

`sensor.ino`, `leer_sensor.py`, `adquirir.py`, `features.py`, `entrenar.py`,
`control.py`, `control.ino`

---

## Convenciones de escritura

Heredadas de `../../CLAUDE.md` y de `../ia/CLAUDE.md`:

* **El nombre se escribe con acentos en todo lo publicado** ("De la señal a la decisión"):
  titulo, portada, menu de `_config.yml`, `curso/index.md` e `index.md` de la raiz. Sin
  acentos queda solo el directorio `senal/` y los documentos internos.
* **Frontmatter obligatorio** en toda pagina publicada, con el mismo `title`:
  ```yaml
  ---
  layout: default
  title: De la señal a la decisión
  ---
  ```
* **`[Inicio](/curso/senal)`** (absoluto, como en `curso/ia/`) al principio de cada subpagina.
* **Sin caracteres especiales** en lo que ve el participante (`index.md`, `requisitos/`,
  `programa/`, `dia-01/`, `dia-02/`): nada de em dash, flechas tipograficas ni emoji.
  Usar `->`, `<-`, `--`, coma o reformular. Los archivos internos (`README.md`,
  `estrategia.md`, `roadmap.md`, este) no tienen la restriccion.
* Los documentos internos de este directorio ademas **se escriben sin acentos**; el
  material publicado si los lleva.
* **Anclas explicitas `{#id}`** en el indice de las paginas largas: kramdown se come los
  acentos al generar los ids solos.
* **Windows siempre**, los 15: puertos `COM3`/`COM4`/`COM5`, nunca `/dev/ttyUSB0`.
  Rutas de Python con `/`.
* **El CMD es la unica terminal.** No la integrada de VS Code, no PowerShell, no Git Bash.
  VS Code es solo el editor: se abre con `code <archivo>` y se ejecuta con
  `python <archivo>`, las dos ventanas a la vez. El CMD se abre escribiendo `cmd` en la
  barra de direcciones del explorador, asi queda parado en la carpeta de trabajo. Ningun
  material del taller le pide al participante instalar extensiones de VS Code.
* `programa/index.md` sigue el formato de `curso/ia/programa/index.md`.

---

## Fechas que bloquean

| Fecha | Que |
|---|---|
| **lun 21 sep 2026** | La guia previa (`requisitos/index.md`) sale al coordinador. **Ruta critica**: sin ella no compran el kit ni instalan |
| vie 25 sep 2026 | Limite de las 4 comprobaciones con evidencia. Revision y rescate individual |
| sab 26 o dom 27 sep | Ensayo completo con hardware real. No se salta |

Equivalente local a la regla de modificaciones de `../ia/` y `../so/`: una vez que la guia
previa se envio, **cambiar la lista de compras o las 4 comprobaciones perjudica a quien ya
compro o ya instalo**. A partir de ese momento se puede corregir, aclarar o relajar, pero
agregar o endurecer requiere avisarle a Karlos para que el lo comunique.

---

## Lo que no hay que hacer

* **Reabrir las decisiones cerradas** de la fase 0 del roadmap sin una razon nueva
  (sensores, piezas, actuador, modelo, reparto de las 7 horas).
* **Agregar contenido "porque cabe".** No cabe.
* **Meter temas de IE043** que quedaron fuera a proposito: FFT, normalizacion, redes
  neuronales, no supervisado, PCA, PLC, metricas mas alla de accuracy, dominio propio por
  participante. La lista y el porque estan en `estrategia.md`, seccion 9.
* **Escribir codigo incompleto a proposito.** Esa es la tecnica de IE043; aqui el codigo
  va completo.
* **Suponer que hay internet** en el aula, ni en el material ni en el plan.

---

## Publico vs. excluido

`_config.yml` de la raiz excluye del sitio `**/CLAUDE.md`, `**/README.md`,
`**/estrategia.md`, `**/roadmap.md` y `**/recurso/**`, asi que nada de lo interno se
publica. Pero **el repositorio es publico**: lo excluido no se sirve, se sigue leyendo en
GitHub. Nada de datos personales de participantes aqui, ni siquiera en archivos excluidos.

---

## Relacion con IE043

El taller es la version minima del caso central de IE043 (clasificador de piezas sobre
banda transportadora). La tabla que mapea cada bloque con su semana del curso esta en
`estrategia.md`, seccion 10.

Entre el taller (septiembre de 2026) y el curso (enero o febrero de 2027) hay cuatro
meses. Lo que sobrevive es el kit comprado y el entorno instalado; el codigo en los dedos
se olvida. Por eso el material se queda publicado en el sitio y el cierre del martes les
dice que semanas del curso acaban de recorrer.
