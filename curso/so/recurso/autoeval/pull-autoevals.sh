#!/usr/bin/env bash
# Clona o actualiza los repositorios privados de autoevaluacion de los alumnos.
#
# Requisito: el asesor debe estar agregado como colaborador en cada repo privado
# (el alumno lo invita). Conviene tener autenticado gh o un token/ssh con acceso.
#
# Uso:
#   ./pull-autoevals.sh                 # usa autoevals.txt
#   ./pull-autoevals.sh otra-lista.txt
#
# La lista tiene una URL de repo por linea. Lineas vacias o con # se ignoran.

set -euo pipefail

LISTA="${1:-autoevals.txt}"
DESTINO="repos"

if [ ! -f "$LISTA" ]; then
  echo "No existe la lista '$LISTA'. Crea una con una URL de repo por linea." >&2
  exit 1
fi

mkdir -p "$DESTINO"

while IFS= read -r url || [ -n "$url" ]; do
  url="$(echo "$url" | tr -d '[:space:]')"
  [ -z "$url" ] && continue
  case "$url" in \#*) continue ;; esac
  nombre="$(basename "$url" .git)"
  if [ -d "$DESTINO/$nombre/.git" ]; then
    echo ">> Actualizando $nombre"
    git -C "$DESTINO/$nombre" pull --ff-only || echo "   (no se pudo actualizar $nombre)"
  else
    echo ">> Clonando $nombre"
    git clone "$url" "$DESTINO/$nombre" || echo "   (no se pudo clonar $url)"
  fi
done < "$LISTA"

echo
echo "Listo. Ahora corre: python3 aggregate.py repos"
