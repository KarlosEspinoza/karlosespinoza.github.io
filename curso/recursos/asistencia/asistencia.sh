#!/usr/bin/env bash
# Reporte semanal de asistencia (solo lectura): quien NO entrego nada de los
# bloques de la sesion de guia en su repositorio individual.
#
# Generico: el nombre del repo y la carpeta del ciclo salen del curso.conf.
#
# Primer paso del flujo semanal informal (ver recursos/revision/README.md).
# Se corre despues del pull fresco y antes de redactar el concentrado. No
# escribe en ningun repo de alumno, asi que no necesita autorizacion (a
# diferencia de aplicar-concentrado.py, que si escribe en REVISION.md).
#
# La convencion de commits es la misma en todos los cursos: el bloque 1 y el
# bloque 2 cierran cada uno con "sNN bloque 1: ..." / "sNN bloque 2: ...".
# Un atoron documentado usa el mismo formato de mensaje y cuenta igual que el
# bloque entregado, asi que basta con que el mensaje exista.
#
# Uso:
#   ./asistencia.sh <curso.conf> <semana> [dir-ciclo] [alumnos.csv]
#
# semana: numero de semana (1 o 2 digitos, se normaliza a sNN).
# Escribe <dir-ciclo>/asistencia/asistencia-sNN.md

set -euo pipefail
. "$(dirname "$(readlink -f "$0")")/../lib.sh"

cargar_conf "${1:-}"
SEMANA_RAW="${2:?Uso: ./asistencia.sh <curso.conf> <semana> [dir-ciclo] [alumnos.csv]}"
resolver_dir_ciclo "${3:-}"
resolver_csv "${4:-}"

if ! [[ "$SEMANA_RAW" =~ ^[0-9]+$ ]]; then
  echo "La semana debe ser un numero (recibido: '$SEMANA_RAW')." >&2
  exit 1
fi
SEMANA="$(printf '%02d' "$SEMANA_RAW")"

# Patron de los commits que cuentan como trabajo de la sesion. Se puede
# cambiar por curso con PATRON_ASISTENCIA en el conf, usando {NN} como
# marcador del numero de semana.
MARCA='{NN}'
PATRON_DEFECTO='^s{NN} bloque [12]'
PATRON="${PATRON_ASISTENCIA:-$PATRON_DEFECTO}"
PATRON="${PATRON//$MARCA/$SEMANA}"

REPOS="$DIR_CICLO/repos-individual"
SALIDA="$DIR_CICLO/asistencia/asistencia-s${SEMANA}.md"

sin_usuario=(); sin_repo=(); entregaron=(); nada=()

while IFS= read -r linea || [ -n "$linea" ]; do
  fila_util "$linea" || continue
  codigo="$(campo "$COL_CODIGO")"
  nombre="$(campo "$COL_NOMBRE")"
  usuario="$(campo "$COL_USUARIO")"
  [ -z "$codigo" ] && continue

  if [ -z "$usuario" ]; then
    sin_usuario+=("$codigo ($nombre)")
    continue
  fi

  id="${codigo}-${usuario}"
  repo="$REPOS/$id"
  if [ ! -d "$repo/.git" ]; then
    sin_repo+=("$id ($nombre)")
    continue
  fi

  tiene=0
  while IFS= read -r asunto; do
    if [[ "$asunto" =~ $PATRON ]]; then
      tiene=1
      break
    fi
  done < <(git -C "$repo" log --format=%s 2>/dev/null | tr '[:upper:]' '[:lower:]')

  if [ "$tiene" = 1 ]; then
    entregaron+=("$id ($nombre)")
  else
    nada+=("$id ($nombre)")
  fi
done < "$CSV_ALUMNOS"

echo
echo "===== Asistencia $CURSO s${SEMANA} ====="
echo "Entregaron algo: ${#entregaron[@]}"
echo "No entregaron nada: ${#nada[@]}"
[ "${#nada[@]}" -gt 0 ] && printf '  - %s\n' "${nada[@]}"
echo "Sin usuario de GitHub en el CSV: ${#sin_usuario[@]}"
[ "${#sin_usuario[@]}" -gt 0 ] && printf '  - %s\n' "${sin_usuario[@]}"
echo "Repo no clonado en local: ${#sin_repo[@]}"
[ "${#sin_repo[@]}" -gt 0 ] && printf '  - %s\n' "${sin_repo[@]}"

mkdir -p "$(dirname "$SALIDA")"
{
  echo "# Asistencia $CURSO s${SEMANA}"
  echo
  echo "Generado: $(date '+%Y-%m-%d %H:%M')"
  echo
  echo "## No entregaron nada - ${#nada[@]}"
  echo
  if [ "${#nada[@]}" -gt 0 ]; then printf -- '- %s\n' "${nada[@]}"; else echo "(ninguno)"; fi
  if [ "${#sin_usuario[@]}" -gt 0 ] || [ "${#sin_repo[@]}" -gt 0 ]; then
    echo
    echo "## Aparte: no se pudo verificar (no cuenta como inasistencia)"
    echo
    if [ "${#sin_usuario[@]}" -gt 0 ]; then
      echo "Sin usuario de GitHub en el CSV:"
      printf -- '- %s\n' "${sin_usuario[@]}"
    fi
    if [ "${#sin_repo[@]}" -gt 0 ]; then
      echo "Repo no clonado en local:"
      printf -- '- %s\n' "${sin_repo[@]}"
    fi
  fi
} > "$SALIDA"

echo
echo "Reporte escrito en: $SALIDA"
