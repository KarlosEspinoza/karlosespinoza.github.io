#!/usr/bin/env bash
# Clona o actualiza los repositorios privados de autoevaluacion entre pares.
#
# Generico: el nombre del repo sale del curso.conf (REPO_AUTOEVAL) y la URL se
# arma sola con el usuario de GitHub de cada alumno, igual que el repo
# individual. No hace falta juntar URLs a mano.
#
# Solo se intentan los alumnos que participan en el proyecto integrador, es
# decir todos los que tienen usuario en alumnos.csv. Un fallo casi siempre
# significa que ese alumno todavia no creo su repo o no invito al asesor: eso
# es justamente lo que hay que saber antes de cada revision, porque se
# traduce en perder el 10% de la autoevaluacion.
#
# Uso:
#   ./pull-autoevals.sh <curso.conf> [dir-ciclo] [alumnos.csv]
#
# Clona en <dir-ciclo>/repos-autoeval/<codigo>-<usuario>/ y despues:
#   python3 aggregate.py <dir-ciclo>/repos-autoeval

set -euo pipefail
. "$(dirname "$(readlink -f "$0")")/../lib.sh"

cargar_conf "${1:-}"
resolver_dir_ciclo "${2:-}"
resolver_csv "${3:-}"

if [ -z "${REPO_AUTOEVAL:-}" ]; then
  echo "El curso '$CURSO' no tiene REPO_AUTOEVAL definido en $CONF."
  echo "No se hizo nada."
  exit 0
fi

DESTINO="$DIR_CICLO/repos-autoeval"
mkdir -p "$DESTINO"

echo "Curso: $CURSO   Repo de autoevaluacion: $REPO_AUTOEVAL"
echo "Ciclo: $DIR_CICLO"
echo

sin_usuario=(); fallidos=(); ok=()

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
      "$(url_repo "$usuario" "$REPO_AUTOEVAL")" \
      "$DESTINO/${codigo}-${usuario}" \
      "$etiqueta"; then
    ok+=("$etiqueta")
  else
    fallidos+=("$etiqueta")
  fi
done < "$CSV_ALUMNOS"

echo
echo "===== Resumen ====="
echo "Al dia: ${#ok[@]}"
echo "Sin repo de autoevaluacion accesible: ${#fallidos[@]}"
if [ "${#fallidos[@]}" -gt 0 ]; then
  printf '  - %s\n' "${fallidos[@]}"
  echo "  (no lo han creado, le pusieron otro nombre, o no invitaron a $COLABORADOR)"
fi
echo "Sin usuario de GitHub en el CSV: ${#sin_usuario[@]}"
[ "${#sin_usuario[@]}" -gt 0 ] && printf '  - %s\n' "${sin_usuario[@]}"

echo
echo "Ahora corre: python3 $(dirname "$(readlink -f "$0")")/aggregate.py $DESTINO"
exit 0
