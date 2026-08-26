#!/usr/bin/env bash
# Clona o actualiza los repositorios del proyecto integrador (uno por equipo).
#
# El nombre del repo de equipo esta fijado por convencion (integrador-so, ver
# semana-01 y classroom.md), igual que so-proyecto para el individual. Lo crea
# el representante del equipo, que es la unica fila de cada equipo con la
# columna `equipo` llena en alumnos.csv. La URL se arma sola: no hace falta
# ningun CSV aparte con URLs de Classroom.
#
# Requisito: el representante debe haber agregado a KarlosEspinoza como
# colaborador del repositorio del equipo. gh debe estar autenticado.
#
# Uso:
#   ./pull-equipos.sh alumnos.csv [destino]
#
# El CSV trae encabezado: codigo,nombre,email,usuario,equipo
# Solo se procesan las filas con `equipo` no vacio (los representantes).

set -euo pipefail

CSV="${1:?Uso: ./pull-equipos.sh alumnos.csv [destino]}"
DESTINO="${2:-repos-equipo}"
REPO_NOMBRE="integrador-so"

if [ ! -f "$CSV" ]; then
  echo "No existe el CSV '$CSV'." >&2
  exit 1
fi

mkdir -p "$DESTINO"

fallidos=()
actualizados=()
clonados=()

primero=1
while IFS=, read -r codigo nombre email usuario equipo || [ -n "${codigo:-}" ]; do
  if [ "$primero" = 1 ]; then
    primero=0
    continue
  fi
  usuario="$(echo "${usuario:-}" | tr -d '\r' | xargs)"
  equipo="$(echo "${equipo:-}" | tr -d '\r' | xargs)"
  [ -z "$equipo" ] && continue

  if [ -z "$usuario" ]; then
    echo "   (equipo $equipo: el representante no tiene usuario de GitHub en el CSV, se omite)"
    fallidos+=("equipo $equipo (representante sin usuario)")
    continue
  fi

  destino_equipo="$DESTINO/equipo-${equipo}-${usuario}"
  url="https://github.com/${usuario}/${REPO_NOMBRE}.git"

  if [ -d "$destino_equipo/.git" ]; then
    echo ">> Actualizando equipo $equipo ($usuario)"
    if git -C "$destino_equipo" pull --ff-only -q; then
      actualizados+=("equipo $equipo ($usuario)")
    else
      echo "   (no se pudo actualizar equipo $equipo/$usuario)"
      fallidos+=("equipo $equipo ($usuario)")
    fi
  else
    echo ">> Clonando equipo $equipo ($usuario)"
    if git clone -q "$url" "$destino_equipo"; then
      clonados+=("equipo $equipo ($usuario)")
    else
      echo "   (no se pudo clonar equipo $equipo/$usuario: falta el repo, el nombre, o el acceso de colaborador)"
      fallidos+=("equipo $equipo ($usuario)")
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
