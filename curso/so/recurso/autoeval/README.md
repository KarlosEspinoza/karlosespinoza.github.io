# Autoevaluacion anonima del proyecto integrador (uso del asesor)

Material INTERNO. Automatiza la recoleccion y el conteo de la autoevaluacion
entre companeros del proyecto integrador, manteniendola anonima entre alumnos.

## Como funciona la anonimidad

El problema: en el repo compartido del equipo todos verian las calificaciones.
La solucion: cada alumno entrega su autoevaluacion en un **repositorio privado
propio** y te agrega como colaborador. Asi:

- Los companeros NO tienen acceso (repo privado, sin ellos) -> anonimo entre pares.
- Tu si lees todo y puedes promediar -> anonimo no significa secreto para ti.

Cada alumno sube un archivo CSV cuyo nombre es su propio codigo de alumno (por
ejemplo `2162628.csv`), con dos columnas:

```csv
codigo,calificacion
2152525,90
2178899,100
```

El nombre del archivo identifica al evaluador; las filas, a quienes evalua.

## Flujo el dia de evaluar

1. Junta las URLs de los repos privados (las entregan en Google Classroom) en
   `autoevals.txt` (una por linea). Usa `autoevals.txt.ejemplo` como plantilla.

2. Clona o actualiza todos:

   ```bash
   ./pull-autoevals.sh
   ```

   Clona en `repos/`. Requiere que ya seas colaborador y tengas acceso
   (gh autenticado, o ssh/token).

3. Agrega los resultados (promedio recibido por alumno):

   ```bash
   python3 aggregate.py repos
   # opcional, ademas exporta un csv:
   python3 aggregate.py repos --csv resultado.csv
   ```

   Imprime, por cada alumno evaluado, su promedio, cuantos lo evaluaron y el
   detalle evaluador:calificacion (solo para ti).

4. Cruza esto con tu evaluacion del proyecto integrador para la nota final.

## Notas

- `autoevals.txt`, `repos/` y `resultado.csv` estan en `.gitignore`: contienen
  URLs privadas y calificaciones, no se versionan en el sitio publico.
- Si un alumno se califica a si mismo, el script lo ignora y lo avisa.
- Si falta un CSV o tiene columnas mal, lo reporta al final sin detener el conteo.
