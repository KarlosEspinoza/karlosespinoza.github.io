#!/usr/bin/env bash
# Base compartida de los scripts genericos de revision (uso del asesor).
#
# No se ejecuta sola: la cargan los scripts de pull-repos/, asistencia/ y
# autoeval/ con
#
#   . "$(dirname "$(readlink -f "$0")")/../lib.sh"
#   cargar_conf "$1"
#
# Lo unico que hace es leer el curso.conf del curso, validar que traiga lo
# minimo y dejar las rutas resueltas en variables. Todo lo especifico de un
# curso (nombre de los repos, carpeta del ciclo, plantillas) vive en ese
# conf, nunca dentro de los scripts.

# ---------------------------------------------------------------------------
# cargar_conf <ruta-al-curso.conf>
#
# Deja definidas:
#   CONF              ruta absoluta del conf
#   RECURSO_CURSO     carpeta donde vive el conf (util dentro del propio conf)
#   CURSO             identificador corto del curso (ia, so, ...)
#   REPO_INDIVIDUAL   nombre fijo del repo individual del alumno
#   REPO_EQUIPO       nombre fijo del repo de equipo (puede venir vacio)
#   REPO_AUTOEVAL     nombre fijo del repo de autoevaluacion (puede venir vacio)
#   COLABORADOR       usuario de GitHub del asesor (solo para mensajes)
#   DIR_CICLO         carpeta de datos del ciclo en curso
#   PLANTILLA_INDIVIDUAL / PLANTILLA_EQUIPO  (pueden venir vacias)
# ---------------------------------------------------------------------------
cargar_conf() {
  local ruta="${1:-}"
  if [ -z "$ruta" ]; then
    echo "Falta la ruta del curso.conf. Ejemplo: .../curso/ia/recurso/curso.conf" >&2
    return 1
  fi
  if [ ! -f "$ruta" ]; then
    echo "No existe el conf '$ruta'." >&2
    return 1
  fi

  CONF="$(readlink -f "$ruta")"
  RECURSO_CURSO="$(dirname "$CONF")"
  export RECURSO_CURSO

  CURSO=""; REPO_INDIVIDUAL=""; REPO_EQUIPO=""; REPO_AUTOEVAL=""
  COLABORADOR=""; DIR_CICLO=""
  PLANTILLA_INDIVIDUAL=""; PLANTILLA_EQUIPO=""

  # shellcheck disable=SC1090
  . "$CONF"

  if [ -z "${CURSO:-}" ] || [ -z "${REPO_INDIVIDUAL:-}" ]; then
    echo "El conf '$CONF' debe definir al menos CURSO y REPO_INDIVIDUAL." >&2
    return 1
  fi

  # Permite escribir DIR_CICLO="~/curso/ia/202620" en el conf.
  DIR_CICLO="${DIR_CICLO/#\~/$HOME}"
  return 0
}

# ---------------------------------------------------------------------------
# resolver_dir_ciclo [override]
#
# El argumento de linea de comandos gana sobre el DIR_CICLO del conf, para
# poder correr sobre el ciclo pasado sin editar el conf.
# ---------------------------------------------------------------------------
resolver_dir_ciclo() {
  local override="${1:-}"
  if [ -n "$override" ]; then
    DIR_CICLO="${override/#\~/$HOME}"
  fi
  if [ -z "${DIR_CICLO:-}" ]; then
    echo "No hay carpeta de ciclo: definela en el conf (DIR_CICLO) o pasala como argumento." >&2
    return 1
  fi
  if [ ! -d "$DIR_CICLO" ]; then
    echo "No existe la carpeta del ciclo '$DIR_CICLO'." >&2
    return 1
  fi
  return 0
}

# ---------------------------------------------------------------------------
# resolver_csv [override]
#
# Deja CSV_ALUMNOS. Por convencion es <dir-ciclo>/alumnos.csv, con encabezado
#   codigo,nombre,email,usuario,equipo,representante
# ---------------------------------------------------------------------------
resolver_csv() {
  local override="${1:-}"
  if [ -n "$override" ]; then
    CSV_ALUMNOS="${override/#\~/$HOME}"
  else
    CSV_ALUMNOS="$DIR_CICLO/alumnos.csv"
  fi
  if [ ! -f "$CSV_ALUMNOS" ]; then
    echo "No existe el CSV de alumnos '$CSV_ALUMNOS'." >&2
    echo "Encabezado esperado: codigo,nombre,email,usuario,equipo,representante" >&2
    return 1
  fi
  detectar_columnas || return 1
  return 0
}

# ---------------------------------------------------------------------------
# detectar_columnas
#
# Lee el encabezado del CSV y deja el indice de cada columna en COL_*. Las
# columnas se buscan por nombre, no por posicion, asi que da igual el orden y
# que un curso traiga columnas de mas.
#
# Columnas reconocidas: codigo, nombre, email (o correo), usuario, equipo,
# representante. Solo codigo y usuario son obligatorias.
#
# La columna `representante` es opcional: si no viene, se asume el formato
# viejo, donde el unico que llevaba numero en `equipo` era el representante.
# ---------------------------------------------------------------------------
detectar_columnas() {
  local encabezado campo i=0
  IFS= read -r encabezado < "$CSV_ALUMNOS"
  encabezado="$(echo "$encabezado" | tr -d '\r')"

  local -a campos
  IFS=, read -r -a campos <<< "$encabezado"

  COL_CODIGO=-1; COL_NOMBRE=-1; COL_EMAIL=-1
  COL_USUARIO=-1; COL_EQUIPO=-1; COL_REPRESENTANTE=-1

  for campo in "${campos[@]}"; do
    campo="$(echo "$campo" | tr -d '\r' | xargs | tr '[:upper:]' '[:lower:]')"
    case "$campo" in
      codigo)        COL_CODIGO=$i ;;
      nombre)        COL_NOMBRE=$i ;;
      email|correo)  COL_EMAIL=$i ;;
      usuario)       COL_USUARIO=$i ;;
      equipo)        COL_EQUIPO=$i ;;
      representante) COL_REPRESENTANTE=$i ;;
    esac
    i=$((i + 1))
  done

  if [ "$COL_CODIGO" -lt 0 ] || [ "$COL_USUARIO" -lt 0 ]; then
    echo "El encabezado de '$CSV_ALUMNOS' debe traer al menos las columnas codigo y usuario." >&2
    echo "Encabezado leido: $encabezado" >&2
    return 1
  fi
  return 0
}

# ---------------------------------------------------------------------------
# Lectura de filas
#
#   while IFS= read -r linea || [ -n "$linea" ]; do
#     fila_util "$linea" || continue          # salta encabezado y lineas vacias
#     codigo="$(campo "$COL_CODIGO")"
#   done < "$CSV_ALUMNOS"
# ---------------------------------------------------------------------------
FILA_PRIMERA=1

# Parte la linea en el arreglo FILA. Devuelve 1 si es el encabezado o una
# linea vacia, para poder saltarla con `|| continue`.
fila_util() {
  local linea="${1//$'\r'/}"
  if [ "$FILA_PRIMERA" = 1 ]; then
    FILA_PRIMERA=0
    return 1
  fi
  [ -z "${linea//[[:space:],]/}" ] && return 1
  IFS=, read -r -a FILA <<< "$linea"
  return 0
}

# Valor de una columna de la fila actual, ya limpio. Si la columna no existe
# en este CSV (indice -1), devuelve vacio.
campo() {
  local i="${1:--1}"
  if [ "$i" -lt 0 ]; then echo ""; return 0; fi
  limpia "${FILA[$i]:-}"
}

# El alumno de la fila actual es el representante de su equipo?
# Con columna `representante`: cuando trae algo. Sin ella (formato viejo):
# cuando la columna `equipo` no esta vacia.
es_representante() {
  if [ "$COL_REPRESENTANTE" -ge 0 ]; then
    [ -n "$(campo "$COL_REPRESENTANTE")" ]
  else
    [ -n "$(campo "$COL_EQUIPO")" ]
  fi
}

# URL del repositorio de un alumno. Se arma sola con el usuario de GitHub y el
# nombre fijo del repo del curso. BASE_GIT existe solo para poder probar los
# scripts contra repos locales; en uso normal no se define.
url_repo() {
  echo "${BASE_GIT:-https://github.com}/${1}/${2}.git"
}

# Quita retornos de carro de Windows y espacios de sobra.
limpia() {
  echo "${1:-}" | tr -d '\r' | xargs
}

# Clona si no existe, o hace pull --ff-only si ya estaba. Imprime lo que hace.
# Uso: clonar_o_actualizar <url> <destino> <etiqueta>
# Devuelve 0 si quedo al dia, 1 si fallo, y deja ACCION en clonado|actualizado|fallido.
clonar_o_actualizar() {
  local url="$1" destino="$2" etiqueta="$3"
  if [ -d "$destino/.git" ]; then
    echo ">> Actualizando $etiqueta"
    if git -C "$destino" pull --ff-only -q; then
      ACCION="actualizado"; return 0
    fi
    echo "   (no se pudo actualizar $etiqueta)"
    ACCION="fallido"; return 1
  fi
  echo ">> Clonando $etiqueta"
  if git clone -q "$url" "$destino"; then
    ACCION="clonado"; return 0
  fi
  echo "   (no se pudo clonar $etiqueta: falta el repo, el nombre, o el acceso de colaborador)"
  ACCION="fallido"; return 1
}
