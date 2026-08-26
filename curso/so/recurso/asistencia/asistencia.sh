#!/usr/bin/env bash
# Reporte semanal de asistencia (solo lectura): quien NO entrego nada de los
# bloques de la sesion de guia del lunes en su so-proyecto.
#
# Primer paso del flujo semanal informal (ver recurso/revision/README.md,
# seccion "Flujo semanal informal"): se corre despues del pull fresco y
# antes de redactar el concentrado.md. No escribe en ningun repo de alumno,
# asi que no necesita autorizacion (a diferencia de aplicar-concentrado.py,
# que si escribe en REVISION.md y si la necesita).
#
# La convencion del curso (CLAUDE.md) es que el bloque 1 y el bloque 2
# cierran cada uno con un commit "sNN bloque 1: ..." / "sNN bloque 2: ...".
# Un atoron documentado usa el mismo formato de mensaje y cuenta igual que
# el bloque entregado, asi que basta con que el mensaje exista.
#
# Uso:
#   ./asistencia.sh alumnos.csv semana dir-ciclo [repos]
#
# semana:    numero de semana (1-2 digitos, se normaliza a sNN).
# dir-ciclo: carpeta del ciclo, p.ej. ~/curso/so/202620. Ahi se escribe
#            asistencia/asistencia-sNN.md (crea la carpeta si hace falta).
# repos:     carpeta con los repos ya clonados (default: dir-ciclo/repos-individual).

set -euo pipefail

CSV="${1:?Uso: ./asistencia.sh alumnos.csv semana dir-ciclo [repos]}"
SEMANA_RAW="${2:?Uso: ./asistencia.sh alumnos.csv semana dir-ciclo [repos]}"
DIR_CICLO="${3:?Uso: ./asistencia.sh alumnos.csv semana dir-ciclo [repos]}"
REPOS="${4:-$DIR_CICLO/repos-individual}"

if [ ! -f "$CSV" ]; then
  echo "No existe el CSV '$CSV'." >&2
  exit 1
fi
if ! [[ "$SEMANA_RAW" =~ ^[0-9]+$ ]]; then
  echo "La semana debe ser un numero (recibido: '$SEMANA_RAW')." >&2
  exit 1
fi
SEMANA="$(printf '%02d' "$SEMANA_RAW")"
PAT1="^s${SEMANA} bloque 1"
PAT2="^s${SEMANA} bloque 2"
SALIDA="$DIR_CICLO/asistencia/asistencia-s${SEMANA}.md"

sin_usuario=()
sin_repo=()
entregaron=()
nada=()

primero=1
while IFS=, read -r codigo nombre email usuario equipo || [ -n "${codigo:-}" ]; do
  if [ "$primero" = 1 ]; then primero=0; continue; fi
  codigo="$(echo "${codigo:-}" | tr -d '\r' | xargs)"
  nombre="$(echo "${nombre:-}" | tr -d '\r' | xargs)"
  usuario="$(echo "${usuario:-}" | tr -d '\r' | xargs)"
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
    if [[ "$asunto" =~ $PAT1 ]] || [[ "$asunto" =~ $PAT2 ]]; then
      tiene=1
      break
    fi
  done < <(git -C "$repo" log --format=%s 2>/dev/null | tr '[:upper:]' '[:lower:]')

  if [ "$tiene" = 1 ]; then
    entregaron+=("$id ($nombre)")
  else
    nada+=("$id ($nombre)")
  fi
done < "$CSV"

echo
echo "===== Asistencia s${SEMANA} ====="
echo "Entregaron algo: ${#entregaron[@]}"
echo "No entregaron nada: ${#nada[@]}"
[ "${#nada[@]}" -gt 0 ] && printf '  - %s\n' "${nada[@]}"
echo "Sin usuario de GitHub en el CSV: ${#sin_usuario[@]}"
[ "${#sin_usuario[@]}" -gt 0 ] && printf '  - %s\n' "${sin_usuario[@]}"
echo "Repo no clonado en local: ${#sin_repo[@]}"
[ "${#sin_repo[@]}" -gt 0 ] && printf '  - %s\n' "${sin_repo[@]}"

mkdir -p "$(dirname "$SALIDA")"
{
  echo "# Asistencia s${SEMANA}"
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
