# Preguntas orales de las revisiones (uso del asesor)

Material INTERNO y generico. Saca preguntas al azar de un banco, las muestra
con sus opciones y registra lo que contesto cada alumno, para no tener que
improvisar ni calificar de memoria el dia de la revision.

```bash
python3 ~/gh/karlosespinoza.github.io/curso/recursos/preguntas/preguntar.py
python3 ~/gh/karlosespinoza.github.io/curso/recursos/preguntas/preguntar.py --resumen
```

## La sesion

Al arrancar pregunta, con valores por defecto sacados del `curso.conf`:

1. **Curso**: solo aparecen los que tienen `BANCO_PREGUNTAS` en su conf.
2. **Ciclo**: las carpetas numericas junto a `DIR_CICLO` (`~/curso/so/202620`, ...).
3. **Numero de revision**.
4. **Semanas** que entran (`1-8`, `1,3,5-7`). Por defecto `REVISION_<n>_SEMANAS`.
5. **Tipos**: una letra por pregunta, en orden. `p` proyecto, `f` facil,
   `d` dificil, `?` se elige con cada alumno. Por defecto `PREGUNTAS_TIPOS`
   (en SO, `p ?`: una sobre su trabajo y otra de los temas).

Despues, por cada alumno:

- Codigo (se valida contra `alumnos.csv` y muestra el nombre).
- Cada pregunta con sus opciones `A`-`D` revueltas: se teclea la letra que
  dijo el alumno. `r` muestra la respuesta solo al asesor, `s` cambia la
  pregunta (por ejemplo si no aplica a su dominio), `q` sale.
- Las de formato rubrica muestran lo que debe aparecer en la respuesta y se
  califican por nivel: Excelente 100, Bueno 80, Suficiente 60, Insuficiente 0.
- Al final un resumen: Enter guarda, o el numero de pregunta para corregir un
  dedazo.

Al alumno no se le dice si acerto: eso le llega en su `REVISION.md`.

Las preguntas se eligen al azar **entre las menos usadas en esa revision**, y
nunca se le repite una al mismo alumno. El grupo esta en el salon y oye las
preguntas de los demas; asi el banco se reparte en vez de repetirse.

## Lo que guarda

`<dir-ciclo>/revision/<n>/preguntas.csv`, una fila por pregunta, y se escribe
al terminar cada alumno (salir a medias no pierde a los anteriores):

```
fecha,codigo,nombre,orden,id,semana,tipo,formato,eleccion,correcta,calificacion,pregunta,respuesta_elegida
```

`--resumen` da el promedio por alumno, que es su nota de Preguntas. De ahi se
arma el bloque del `concentrado.md`.

## El banco

Vive en un repo **privado** (trae las respuestas), un archivo por semana:
`<BANCO_PREGUNTAS>/semana-NN.json`. Cada pregunta:

```json
{
  "id": "S05-09",
  "semana": 5,
  "tipo": "dificil",
  "formato": "opcion",
  "pregunta": "Con 2 hilos en tu maquina nunca falla. Es seguro ese codigo? Justifica.",
  "correcta": "...",
  "distractores": ["...", "...", "..."],
  "respuesta": "explicacion para el asesor y para el REVISION.md"
}
```

- `tipo`: `facil`, `proyecto` o `dificil`.
- `formato`: `opcion` (lleva `correcta` y tres `distractores`) o `rubrica`
  (solo `respuesta`, que es lo que debe aparecer; puede traer sus propios
  `niveles` como `[["Excelente", 100, "descripcion"], ...]`).
- `id`: `S<semana>-<numero>` con el numero que tiene en la pagina publica, para
  que se pueda ubicar de donde salio.

Para usarlo en otro curso: crear su banco y agregar a su `curso.conf`
`BANCO_PREGUNTAS`, `REVISION_<n>_SEMANAS` y, si se quiere, `PREGUNTAS_TIPOS`.
