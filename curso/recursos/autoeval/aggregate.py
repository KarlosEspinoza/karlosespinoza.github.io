#!/usr/bin/env python3
"""Agrega las autoevaluaciones anonimas del proyecto integrador.

Busca todos los archivos .csv dentro de la carpeta indicada (cada uno, nombrado
con el codigo del alumno evaluador, es la evaluacion que ese alumno hizo de sus
companeros) y calcula, por cada alumno evaluado, el promedio de las
calificaciones que recibio.

Cada CSV tiene dos columnas, codigo y calificacion, con o sin encabezado
"codigo,calificacion" (distintos cursos piden una u otra convencion): la
primera fila se descarta solo si no es un codigo,calificacion valido.
El nombre del archivo (sin .csv) es el codigo del alumno que evalua (evaluador).

Generico: no depende de ningun curso, solo de la carpeta donde quedaron los
repos clonados por pull-autoevals.sh.

Uso:
    python3 aggregate.py ~/curso/ia/202620/repos-autoeval
    python3 aggregate.py ~/curso/ia/202620/repos-autoeval --csv resultado.csv
"""
import csv
import sys
import glob
import os
from collections import defaultdict

raiz = sys.argv[1] if len(sys.argv) > 1 else "repos-autoeval"
salida_csv = None
if "--csv" in sys.argv:
    salida_csv = sys.argv[sys.argv.index("--csv") + 1]

# recibidas[evaluado] = lista de (evaluador, calificacion)
recibidas = defaultdict(list)
problemas = []

for ruta in glob.glob(os.path.join(raiz, "**", "*.csv"), recursive=True):
    evaluador = os.path.splitext(os.path.basename(ruta))[0]
    # Solo <codigo>.csv: si el archivo vive en el repo del proyecto, junto a
    # el puede haber otros CSV (equipo.csv, datos) que no son autoevaluaciones.
    if not evaluador.isdigit():
        continue
    try:
        with open(ruta, newline="", encoding="utf-8-sig") as f:
            filas = [fila for fila in csv.reader(f) if fila]
    except OSError as e:
        problemas.append(f"{ruta}: no se pudo leer ({e})")
        continue

    if not filas:
        problemas.append(f"{ruta}: vacio")
        continue

    # La primera fila es encabezado solo si no es un codigo,calificacion
    # valido (p. ej. la literal "codigo,calificacion").
    primera = filas[0]
    if len(primera) < 2 or not primera[1].strip().replace(".", "", 1).isdigit():
        filas = filas[1:]

    for fila in filas:
        if len(fila) < 2:
            continue
        evaluado = fila[0].strip()
        cal = fila[1].strip()
        if not evaluado or not cal:
            continue
        if evaluado == evaluador:
            problemas.append(f"{ruta}: {evaluador} se califico a si mismo (ignorado)")
            continue
        try:
            recibidas[evaluado].append((evaluador, float(cal)))
        except ValueError:
            problemas.append(f"{ruta}: calificacion no numerica '{cal}' para {evaluado}")

print(f"{'alumno':<12}{'promedio':>9}{'n':>4}   detalle (evaluador:cal)")
print("-" * 60)
for evaluado in sorted(recibidas):
    pares = recibidas[evaluado]
    prom = sum(c for _, c in pares) / len(pares)
    detalle = ", ".join(
        f"{ev}:{int(c) if c == int(c) else c}" for ev, c in sorted(pares)
    )
    print(f"{evaluado:<12}{prom:>9.1f}{len(pares):>4}   {detalle}")

if salida_csv:
    with open(salida_csv, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["alumno", "promedio_recibido", "n_evaluaciones"])
        for evaluado in sorted(recibidas):
            pares = recibidas[evaluado]
            prom = sum(c for _, c in pares) / len(pares)
            w.writerow([evaluado, f"{prom:.1f}", len(pares)])
    print(f"\nResumen escrito en {salida_csv}")

if problemas:
    print("\nAvisos:", file=sys.stderr)
    for p in problemas:
        print(f"  - {p}", file=sys.stderr)
