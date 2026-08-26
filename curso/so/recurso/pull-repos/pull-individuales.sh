#!/usr/bin/env bash
# Clona o actualiza los repositorios so-proyecto (individuales) de los alumnos.
#
# Requisito: cada alumno debe haber agregado a KarlosEspinoza como colaborador
# en su repositorio so-proyecto (privado). gh debe estar autenticado
# (git usa el credential helper de gh sobre https).
#
# Uso:
#   ./pull-individuales.sh alumnos.csv [destino]
#
# El CSV trae encabezado: codigo,nombre,email,usuario,equipo
# Se ignoran (y se reportan al final) las filas sin usuario: ese alumno
# todavia no dio su cuenta de GitHub.

set -euo pipefail

CSV="${1:?Uso: ./pull-individuales.sh alumnos.csv [destino]}"
DESTINO="${2:-repos-individual}"
REPO_NOMBRE="so-proyecto"

if [ ! -f "$CSV" ]; then
  echo "No existe el CSV '$CSV'." >&2
  exit 1
fi

mkdir -p "$DESTINO"

sin_usuario=()
fallidos=()
actualizados=()
clonados=()

primero=1
while IFS=, read -r codigo nombre email usuario equipo || [ -n "${codigo:-}" ]; do
  if [ "$primero" = 1 ]; then
    primero=0
    continue
  fi
  codigo="$(echo "${codigo:-}" | tr -d '\r' | xargs)"
  usuario="$(echo "${usuario:-}" | tr -d '\r' | xargs)"
  [ -z "$codigo" ] && continue

  if [ -z "$usuario" ]; then
    sin_usuario+=("$codigo")
    continue
  fi

  destino_alumno="$DESTINO/${codigo}-${usuario}"
  url="https://github.com/${usuario}/${REPO_NOMBRE}.git"

  if [ -d "$destino_alumno/.git" ]; then
    echo ">> Actualizando $codigo ($usuario)"
    if git -C "$destino_alumno" pull --ff-only -q; then
      actualizados+=("$codigo ($usuario)")
    else
      echo "   (no se pudo actualizar $codigo/$usuario)"
      fallidos+=("$codigo ($usuario)")
    fi
  else
    echo ">> Clonando $codigo ($usuario)"
    if git clone -q "$url" "$destino_alumno"; then
      clonados+=("$codigo ($usuario)")
    else
      echo "   (no se pudo clonar $codigo/$usuario: falta el repo, el nombre, o el acceso de colaborador)"
      fallidos+=("$codigo ($usuario)")
    fi
  fi
done < "$CSV"

echo
echo "===== Resumen ====="
echo "Clonados nuevos:  ${#clonados[@]}"
echo "Actualizados:     ${#actualizados[@]}"
echo "Fallidos:         ${#fallidos[@]}"
if [ "${#fallidos[@]}" -gt 0 ]; then
  printf '  - %s\n' "${fallidos[@]}"
fi
echo "Sin usuario de GitHub en el CSV: ${#sin_usuario[@]}"
if [ "${#sin_usuario[@]}" -gt 0 ]; then
  printf '  - %s\n' "${sin_usuario[@]}"
fi
