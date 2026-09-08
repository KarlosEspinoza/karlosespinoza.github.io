#!/usr/bin/env bash
# Clona o actualiza los repositorios del proyecto integrador (uno por equipo).
#
# Generico: el nombre del repo de equipo sale del curso.conf (REPO_EQUIPO).
# El repo lo crea el representante del equipo, que en alumnos.csv es la fila
# con la columna `representante` llena; el numero del equipo sale de la
# columna `equipo`, que la llevan todos los integrantes. La URL se arma sola:
# no hace falta ningun CSV aparte con URLs de Classroom.
#
# Si el CSV no trae columna `representante` (formato viejo), se asume que el
# representante es el unico integrante con `equipo` lleno.
#
# Si el curso todavia no usa repo de equipo, deja REPO_EQUIPO vacio en el
# conf: este script avisa y no hace nada.
#
# Uso:
#   ./pull-equipos.sh <curso.conf> [dir-ciclo] [alumnos.csv]

set -euo pipefail
. "$(dirname "$(readlink -f "$0")")/../lib.sh"

cargar_conf "${1:-}"
resolver_dir_ciclo "${2:-}"
resolver_csv "${3:-}"

if [ -z "${REPO_EQUIPO:-}" ]; then
  echo "El curso '$CURSO' no tiene REPO_EQUIPO definido en $CONF."
  echo "Todavia no hay repositorios de equipo que traer. No se hizo nada."
  exit 0
fi

DESTINO="$DIR_CICLO/repos-equipo"
mkdir -p "$DESTINO"

echo "Curso: $CURSO   Repo de equipo: $REPO_EQUIPO"
echo "Ciclo: $DIR_CICLO"
echo

fallidos=(); actualizados=(); clonados=()
declare -A equipos_vistos=() equipos_con_rep=()

while IFS= read -r linea || [ -n "$linea" ]; do
  fila_util "$linea" || continue
  usuario="$(campo "$COL_USUARIO")"
  equipo="$(campo "$COL_EQUIPO")"

  [ -n "$equipo" ] && equipos_vistos["$equipo"]=1
  es_representante || continue

  if [ -z "$equipo" ]; then
    echo "   (hay un representante sin numero de equipo en el CSV, se omite)"
    fallidos+=("representante sin equipo ($usuario)")
    continue
  fi
  if [ -n "${equipos_con_rep[$equipo]:-}" ]; then
    echo "   (equipo $equipo: hay mas de un representante marcado en el CSV, se usa el primero)"
    continue
  fi
  equipos_con_rep["$equipo"]=1

  if [ -z "$usuario" ]; then
    echo "   (equipo $equipo: el representante no tiene usuario de GitHub en el CSV, se omite)"
    fallidos+=("equipo $equipo (representante sin usuario)")
    continue
  fi

  etiqueta="equipo $equipo ($usuario)"
  if clonar_o_actualizar \
      "$(url_repo "$usuario" "$REPO_EQUIPO")" \
      "$DESTINO/equipo-${equipo}-${usuario}" \
      "$etiqueta"; then
    [ "$ACCION" = "clonado" ] && clonados+=("$etiqueta") || actualizados+=("$etiqueta")
  else
    fallidos+=("$etiqueta")
  fi
done < "$CSV_ALUMNOS"

sin_rep=()
for e in "${!equipos_vistos[@]}"; do
  [ -z "${equipos_con_rep[$e]:-}" ] && sin_rep+=("$e")
done

echo
echo "===== Resumen ====="
echo "Equipos en el CSV: ${#equipos_vistos[@]}"
echo "Clonados nuevos:  ${#clonados[@]}"
echo "Actualizados:     ${#actualizados[@]}"
echo "Fallidos:         ${#fallidos[@]}"
if [ "${#fallidos[@]}" -gt 0 ]; then
  printf '  - %s\n' "${fallidos[@]}"
  echo "  (casi siempre es que falta la invitacion de colaborador a $COLABORADOR)"
fi
if [ "${#sin_rep[@]}" -gt 0 ]; then
  echo "Equipos sin representante marcado en el CSV: ${#sin_rep[@]}"
  printf '  - equipo %s\n' $(printf '%s\n' "${sin_rep[@]}" | sort -n)
  echo "  (llena la columna representante de ese equipo, si no no se sabe de que cuenta clonar)"
fi
exit 0
