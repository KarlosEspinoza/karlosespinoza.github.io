# Revision de avances de IA: prompts listos para pegar (uso del asesor)

Material INTERNO. Estos son los prompts del curso de IA **ya con las rutas y
los criterios puestos**. No hay que buscar y reemplazar nada dentro del texto:
**la primera linea del prompt declara la semana**, se cambia ahi el valor y el
resto se pega tal cual.

```
<NN>=03
```

En la revision formal se declara ademas `<numero>` (1, 2 o 3).

El mecanismo generico, comun a todos los cursos, esta explicado en
`curso/recursos/revision/README.md`; aqui solo esta la version aplicada a IA.

Los dos flujos terminan igual:

> **prompt -> revisar manualmente el `concentrado.md` -> autorizar y aplicar**

Nunca se hace `commit`/`push` a un repositorio de alumno sin ese tercer paso
explicito. La regla dura completa esta en `curso/ia/CLAUDE.md`, seccion
"Revision de avances: REVISION.md y el flujo de autorizacion".

| | |
|---|---|
| Ciclo | `~/curso/ia/202620` |
| Conf | `~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf` |
| Repo individual | `clasificador-piezas-ia` |
| Repo de equipo | `integrador-ia` (desde la semana 4) |
| Revisiones formales | semanas 9, 14 y 17 |

---

## Flujo semanal informal (cualquier semana con bloques)

Se corre **al cerrar la sesion**, no durante: si se corre a media sesion,
aparecen como "no entregaron nada" los que todavia estan trabajando.

### 1. Prompt

El pull de los repos y el reporte de asistencia van dentro: no hay que correr
nada antes de pegarlo.

```
<NN>=03

Vamos a hacer la revisión semanal informal de la semana <NN> del curso de IA.
Ciclo: ~/curso/ia/202620.
Conf: ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf
Sustituye <NN> en todo lo que sigue.

1. Corre pull-individuales.sh (y pull-equipos.sh si ya estamos en la semana 4 o
   después) para traer los repos al día.
2. Corre asistencia.sh con la semana <NN> para saber quién no entregó nada
   (genera asistencia-s<NN>.md).
3. De los que sí entregaron algo, revisa los commits de esta semana, el diff, y
   la sección de la semana <NN> de su BITACORA.md. Compara contra lo que la guía
   de esa semana pedía en curso/ia/semana-<NN>/index.md: los dos bloques
   obligatorios y el archivo que le tocaba agregar al proyecto (la tabla de
   progresión está en curso/ia/CLAUDE.md, "Archivos del proyecto del alumno").
4. No es evaluación formal: solo anota algo si de verdad destaca. En este curso
   lo que más vale la pena cazar temprano es:
   - Datos que no sirven: menos repeticiones de las pedidas, clases
     desbalanceadas, una etiqueta capturada en condiciones distintas a las otras.
   - Fuga de información por el protocolo de captura (mover un tipo de pieza más
     rápido que otro, capturar todas las de un tipo seguidas).
   - Código que no corre con las rutas del repo (`datos/...` con diagonal
     invertida, rutas absolutas de su máquina).
   - Un dominio o unas etiquetas que ya no son los que registró al inicio.
   Si no hay nada que valga la pena decirle, no le hagas bloque.
5. Redacta el concentrado.md en
   ~/curso/ia/202620/asistencia/concentrado-s<NN>.md, un bloque por alumno:

   <!-- BLOQUE: ALUMNO <codigo>-<usuario> -->
   ### Nota rápida (<fecha de hoy>)
   <texto corto>
   <!-- FIN BLOQUE -->

   Para los que no entregaron nada, un aviso corto y neutral (sin regañar),
   p. ej. "No veo commits de la semana <NN> (`s<NN> bloque 1`/`s<NN> bloque 2`).
   Si tuviste un problema, cuéntamelo para que quede en la bitácora."
6. Al final del archivo, FUERA de cualquier bloque (aplicar-concentrado.py solo
   lee lo que está dentro de <!-- BLOQUE --> ... <!-- FIN BLOQUE -->, así que
   esto nunca se aplica a ningún repo), agrega:

   ## Incidencias comunes de la semana <NN>

   Agrupa los problemas que se repitieron entre varios alumnos (mismo error,
   mismo malentendido, mismo bloqueo de entorno): de qué se trata, a quiénes les
   pasó (código o usuario) y cuántos. Es para usarla como agenda del rescate de
   atorones de la siguiente sesión y para anotar si algo apunta a que el
   material de esa semana necesita ajuste para el siguiente ciclo.
7. No toques ningún repo de alumno: nada de add/commit/push. Solo escribe el
   concentrado.md. Yo lo reviso y te autorizo aplicar.
```

### 2. Revisar el concentrado

Se lee completo. Para excluir a alguien del lote, se borra su bloque: no hay
autorizacion parcial por comando, lo que quede en el archivo es lo que se
aplica. La seccion de incidencias del final no se aplica a nada, pero es lo
primero que conviene leer: es la radiografia de la semana antes de la
siguiente sesion.

### 3. Autorizar y aplicar

Basta con decirselo a Claude Code ("autorizado, aplicalo"), o correrlo a
mano:

```bash
# dry-run
python3 ~/curso/scripts/aplicar-concentrado.py \
  ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf \
  ~/curso/ia/202620/asistencia/concentrado-s<NN>.md

# ya revisado y autorizado
python3 ~/curso/scripts/aplicar-concentrado.py \
  ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf \
  ~/curso/ia/202620/asistencia/concentrado-s<NN>.md --confirmar
```

El commit queda como el encabezado de la nota (`Nota rapida (<fecha>)`), asi
que en el historial de `REVISION.md` se distingue de una revision formal. El
alumno lo ve con su siguiente `git pull`.

---

## Flujo de revision formal (semanas 9, 14 y 17)

### 1. Prompt

El pull de los repos y el de la autoevaluacion entre pares van dentro.

```
<NN>=09
<numero>=1

Vamos a hacer la revisión formal <numero> (semana <NN>) del curso de IA.
Ciclo: ~/curso/ia/202620.
Conf: ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf
Sustituye <NN> y <numero> en todo lo que sigue.

1. Corre pull-individuales.sh y pull-equipos.sh para traer todos los repos al
   día, y pull-autoevals.sh con aggregate.py para la autoevaluación entre
   pares. Dime quién no tiene su repo autoeval-ia accesible: ese es el 10% que
   pierde en esta revisión.
2. Revisa cada repo individual (clasificador-piezas-ia): codigo/, datos/,
   figuras/ y BITACORA.md. Contrasta contra la lista "Tu sistema debe" de
   curso/ia/semana-<NN>/index.md, que es el instrumento de esta revisión, y
   contra la tabla de progresión de archivos de curso/ia/CLAUDE.md.
3. Revisa cada repo de equipo (integrador-ia): pipeline/ (controlador central,
   fusión, anomalías, cliente del PLC), los módulos de cada dominio, el
   README.md con los acuerdos y la BITACORA.md del equipo.
4. Verifica que el código corra de verdad con los datos que están en el repo:
   rutas relativas, el CSV existe, el modelo se carga. Un repo que no corre no
   puede ser Excelente en evidencias por bonito que esté escrito.
5. Si ya tengo las respuestas a las 2 preguntas de esa revisión, inclúyelas; si
   no, dejamos esa parte para el día de la revisión.
6. Para cada alumno y equipo, asigna nivel (Excelente/Bueno/Suficiente/
   Insuficiente) por instrumento según la rúbrica de evaluacion/individual
   (individual) o evaluacion/proyecto_integrador (equipo), con sus pesos.
7. Redacta el concentrado.md en
   ~/curso/ia/202620/revision/<numero>/concentrado.md, un bloque por alumno y
   por equipo:

   <!-- BLOQUE: ALUMNO <codigo>-<usuario> -->
   ## Revisión <numero> (semana <NN>)

   | Instrumento | Peso | Nivel |
   |---|---|---|
   | Evidencias | 50% | |
   | BITACORA.md | 30% | |
   | Preguntas | 20% | |

   ### Evidencias
   ...
   ### BITACORA.md
   ...
   ### Preguntas
   ...
   ### Para la siguiente revisión
   ...
   <!-- FIN BLOQUE -->

   Para equipo usa <!-- BLOQUE: EQUIPO <numero>-<usuario> --> con los pesos
   45/25/20/10 y la fila de Autoevaluación entre pares, según
   plantilla-equipo.md.
8. No toques ningún repo de alumno: nada de add/commit/push. Solo escribe el
   concentrado.md. Yo lo reviso y te autorizo aplicar.
```

El ID de cada bloque es el mismo que usan `pull-individuales.sh` y
`pull-equipos.sh` para nombrar la carpeta: `<codigo>-<usuario>` para alumno,
`<numero>-<usuario>` para equipo.

### 2. Revisar el concentrado

Igual que en el flujo semanal: se lee completo y se quitan los bloques que no
se vayan a aplicar.

### 3. Autorizar y aplicar

Basta con decirselo a Claude Code ("autorizado, aplicalo"), o correrlo a
mano:

```bash
# dry-run
python3 ~/curso/scripts/aplicar-concentrado.py \
  ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf \
  ~/curso/ia/202620/revision/<numero>/concentrado.md

# ya revisado y autorizado
python3 ~/curso/scripts/aplicar-concentrado.py \
  ~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf \
  ~/curso/ia/202620/revision/<numero>/concentrado.md --confirmar
```

Valida todos los repos antes de tocar cualquiera (clonados y limpios) y
aborta el lote completo si algo no cuadra, en vez de aplicar la mitad.

---

## Comandos sueltos

Todo esto lo corre Claude Code desde el prompt. Estan aqui por si hace falta
correr uno solo, sin sesion.

```bash
R=~/gh/karlosespinoza.github.io/curso/recursos
C=~/gh/karlosespinoza.github.io/curso/ia/recurso/curso.conf

$R/pull-repos/pull-individuales.sh $C            # repos individuales al dia
$R/pull-repos/pull-equipos.sh      $C            # repos de equipo (desde la semana 4)
$R/asistencia/asistencia.sh        $C <NN>       # quien no entrego nada
$R/autoeval/pull-autoevals.sh      $C            # autoevaluacion entre pares
python3 $R/autoeval/aggregate.py ~/curso/ia/202620/repos-autoeval
```

---

## Que se espera en cada semana

Para no tener que abrir la guia cada vez. Los nombres de archivo estan
congelados: si el alumno los cambio, eso mismo es lo que hay que decirle.

| Semana | Lo que debe aparecer en el repo |
|---|---|
| 01 | Repo creado, `README.md` con su dominio, `BITACORA.md`, carpetas `codigo/ datos/ figuras/` |
| 02 | `codigo/sensor.ino`, `codigo/leer_sensor.py`, primera figura de la senal |
| 03 | `codigo/adquirir.py` -> `datos/datos.csv` etiquetado, y el protocolo de captura en la bitacora |
| 04 | `codigo/limpiar.py` -> `datos/datos_limpios.csv` |
| 05 | `codigo/features.py` -> `datos/features.csv` |
| 06 | `codigo/features.py` con FFT |
| 07 | `codigo/entrenar.py` -> `modelo.pkl` y su matriz de confusion |
| 08 | `codigo/control.py`, `codigo/control.ino`: bucle de control cerrado |
| 09 | **Revision 1** (cierre U1 y U2) |
| 10 | `codigo/pca.py`, `datos/anomalias.csv` |
| 11 | `codigo/clustering.py` |
| 12 | `codigo/autoencoder.py` -> `detector.pkl` |
| 13 | `codigo/control.py` con las anomalias integradas |
| 14 | **Revision 2** (cierre U3) |
| 15 | `codigo/evaluar.py`, `datos/datos_banda.csv` (datos de la maqueta) |
| 16 | `codigo/prueba_plc.py` -> `modelo_produccion.pkl` |
| 17 | **Revision final**: demo del bucle completo sobre la maqueta con PLC |

La `BITACORA.md` de cada semana lleva siempre las dos subsecciones fijas:
`### Antes de la clase` (los bloques de la guia) y `### Avance del proyecto`.
Que falte una de las dos es de las cosas mas utiles que se pueden senalar
temprano, porque el 30% de cada revision sale de ahi.
