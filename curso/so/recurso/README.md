# Material interno del curso de Sistemas Operativos

Uso del asesor. No se publica en el sitio (`_config.yml` excluye
`**/recurso/**`), aunque el repositorio del sitio si es publico: lo que de
verdad no puede salir del control del asesor no se escribe aqui.

## Que hay

| Archivo | Que es |
|---|---|
| `curso.conf` | Configuracion del curso para los scripts genericos de `curso/recursos/` |
| `revision/README.md` | **Los prompts ya listos para pegar**, semanal y formal |
| `revision/plantilla-individual.md` | Encabezado del `REVISION.md` de cada alumno |
| `revision/plantilla-equipo.md` | Encabezado del `REVISION.md` de cada equipo |

Los scripts no estan aqui: son los mismos para todos los cursos y viven en
`curso/recursos/`. Este `curso.conf` es lo unico que los hace hablar de SO.

El resto de archivos de esta carpeta (`calendario-clases.md`,
`lineamiento-syllabus.md`, `mejoras.md`, `reporte-laboral.md`,
`resumen-ejecutivo-laboral.md`, `malla-curricular.*`, `plan-de-estudios.pdf`,
`programa_202510.pdf`) no son parte del flujo de revision: son insumos de
diseno del programa, sin datos de alumnos.

## Convenciones de este curso

| Que | Valor |
|---|---|
| Repo individual | `so-proyecto` (semana 1) |
| Repo de equipo | `integrador-so`, lo crea el representante (semana 4) |
| Repo de autoevaluacion | `autoeval-so`, uno privado por alumno |
| Commits de la sesion de guia | `sNN bloque 1: ...` / `sNN bloque 2: ...` |
| Carpeta de datos del ciclo | `~/curso/so/202620/` |
| Revisiones formales | semanas 9, 14 y 17 |
| Pesos individual | Evidencias 50%, BITACORA.md 30%, Preguntas 20% |
| Pesos integrador | Evidencias 45%, BITACORA.md 25%, Preguntas 20%, Autoevaluacion 10% |

## Uso

```bash
R=~/gh/karlosespinoza.github.io/curso/recursos
C=~/gh/karlosespinoza.github.io/curso/so/recurso/curso.conf

# repos al dia
$R/pull-repos/pull-individuales.sh $C
$R/pull-repos/pull-equipos.sh      $C     # desde la semana 4

# quien no entrego nada en la semana 3
$R/asistencia/asistencia.sh $C 3

# antes de cada revision formal
$R/autoeval/pull-autoevals.sh $C
python3 $R/autoeval/aggregate.py ~/curso/so/202620/repos-autoeval
```

Los prompts de este curso, con rutas y criterios ya puestos (solo se cambia el
numero de semana), estan en `revision/README.md`. La explicacion del mecanismo
generico, comun a todos los cursos, esta en
`curso/recursos/revision/README.md`. El unico paso que escribe en los repos de
los alumnos es `~/curso/scripts/aplicar-concentrado.py`, y requiere
autorizacion explicita.

## Antes de la primera corrida del ciclo

1. Llenar `~/curso/so/202620/alumnos.csv` con el padron y el `usuario` de
   GitHub de cada alumno (sale de la URL que entregaron en Classroom).
2. Verificar que `DIR_CICLO` del `curso.conf` apunte al ciclo correcto.
3. Correr `pull-individuales.sh`: los fallidos son los que no invitaron al
   asesor como colaborador. Eso se resuelve la primera semana, no en la
   revision.
