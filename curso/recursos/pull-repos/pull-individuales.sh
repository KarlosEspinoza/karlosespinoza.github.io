#!/usr/bin/env bash
# Clona o actualiza los repositorios individuales de los alumnos de un curso.
#
# Generico: todo lo del curso (nombre del repo, carpeta del ciclo) sale del
# curso.conf que se pasa como primer argumento.
#
# Requisito: cada alumno debe haber agregado al asesor como colaborador en su
# repositorio (privado). gh debe estar autenticado, porque git usa su
# credential helper sobre https.
#
# Uso:
#   ./pull-individuales.sh <curso.conf> [dir-ciclo] [alumnos.csv]
#
# El CSV trae encabezado con al menos las columnas codigo y usuario; se
# reconocen por nombre, no por posicion. Las filas sin usuario se ignoran y se
# reportan al final: ese alumno todavia no dio su cuenta de GitHub.

set -euo pipefail
. "$(dirname "$(readlink -f "$0")")/../lib.sh"

cargar_conf "${1:-}"
resolver_dir_ciclo "${2:-}"
resolver_csv "${3:-}"

DESTINO="$DIR_CICLO/repos-individual"
mkdir -p "$DESTINO"

echo "Curso: $CURSO   Repo: $REPO_INDIVIDUAL"
echo "Ciclo: $DIR_CICLO"
echo

sin_usuario=(); fallidos=(); actualizados=(); clonados=()

while IFS= read -r linea || [ -n "$linea" ]; do
  fila_util "$linea" || continue
  codigo="$(campo "$COL_CODIGO")"
  usuario="$(campo "$COL_USUARIO")"
  [ -z "$codigo" ] && continue

  if [ -z "$usuario" ]; then
    sin_usuario+=("$codigo")
    continue
  fi

  etiqueta="$codigo ($usuario)"
  if clonar_o_actualizar \
      "$(url_repo "$usuario" "$REPO_INDIVIDUAL")" \
      "$DESTINO/${codigo}-${usuario}" \
      "$etiqueta"; then
    [ "$ACCION" = "clonado" ] && clonados+=("$etiqueta") || actualizados+=("$etiqueta")
  else
    fallidos+=("$etiqueta")
  fi
done < "$CSV_ALUMNOS"

echo
echo "===== Resumen ====="
echo "Clonados nuevos:  ${#clonados[@]}"
echo "Actualizados:     ${#actualizados[@]}"
echo "Fallidos:         ${#fallidos[@]}"
if [ "${#fallidos[@]}" -gt 0 ]; then
  printf '  - %s\n' "${fallidos[@]}"
  echo "  (casi siempre es que falta la invitacion de colaborador a $COLABORADOR)"
fi
echo "Sin usuario de GitHub en el CSV: ${#sin_usuario[@]}"
[ "${#sin_usuario[@]}" -gt 0 ] && printf '  - %s\n' "${sin_usuario[@]}"
exit 0
