#!/usr/bin/env python3
"""Agrega las autoevaluaciones anonimas del proyecto integrador.

Busca todos los archivos .csv dentro de la carpeta indicada (cada uno, nombrado
con el codigo del alumno evaluador, es la evaluacion que ese alumno hizo de sus
companeros) y calcula, por cada alumno evaluado, el promedio de las
calificaciones que recibio.

Cada CSV tiene encabezado:  codigo,calificacion
El nombre del archivo (sin .csv) es el codigo del alumno que evalua (evaluador).

Uso:
    python3 aggregate.py repos
    python3 aggregate.py repos --csv resultado.csv
"""
import csv
import sys
import glob
import os
from collections import defaultdict

raiz = sys.argv[1] if len(sys.argv) > 1 else "repos"
salida_csv = None
if "--csv" in sys.argv:
    salida_csv = sys.argv[sys.argv.index("--csv") + 1]

# recibidas[evaluado] = lista de (evaluador, calificacion)
recibidas = defaultdict(list)
problemas = []

for ruta in glob.glob(os.path.join(raiz, "**", "*.csv"), recursive=True):
    evaluador = os.path.splitext(os.path.basename(ruta))[0]
    try:
        with open(ruta, newline="", encoding="utf-8-sig") as f:
            lector = csv.DictReader(f)
            if not lector.fieldnames or "codigo" not in lector.fieldnames or "calificacion" not in lector.fieldnames:
                problemas.append(f"{ruta}: faltan columnas codigo,calificacion")
                continue
            for fila in lector:
                evaluado = (fila.get("codigo") or "").strip()
                cal = (fila.get("calificacion") or "").strip()
                if not evaluado or not cal:
                    continue
                if evaluado == evaluador:
                    problemas.append(f"{ruta}: {evaluador} se califico a si mismo (ignorado)")
                    continue
                try:
                    recibidas[evaluado].append((evaluador, float(cal)))
                except ValueError:
                    problemas.append(f"{ruta}: calificacion no numerica '{cal}' para {evaluado}")
    except OSError as e:
        problemas.append(f"{ruta}: no se pudo leer ({e})")

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
