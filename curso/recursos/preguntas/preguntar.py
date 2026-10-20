#!/usr/bin/env python3
"""Preguntas orales de las revisiones de avances (uso del asesor).

Generico para cualquier curso: busca los curso/<curso>/recurso/curso.conf que
definen BANCO_PREGUNTAS (carpeta con un semana-NN.json por semana, en un repo
privado porque trae las respuestas) y pregunta, en este orden:

    curso -> ciclo -> numero de revision -> semanas -> tipos de pregunta

Despues entra al ciclo de evaluacion: codigo del alumno, y por cada pregunta
la muestra con sus opciones (en orden revuelto) y pide la opcion que eligio el
alumno. Las preguntas de formato "rubrica" (las que se contestan sobre el
codigo del propio alumno) muestran lo que debe aparecer en la respuesta y se
califican por nivel.

Cada alumno se guarda al terminar sus preguntas en
    <dir-ciclo>/revision/<n>/preguntas.csv
asi que se puede salir y volver a entrar sin perder nada.

Uso:
    python3 preguntar.py               evaluar
    python3 preguntar.py --resumen     calificacion de preguntas por alumno
"""
import csv
import datetime
import glob
import json
import os
import random
import re
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ_CURSOS = os.path.dirname(os.path.dirname(AQUI))  # .../curso

TIPOS = {"f": "facil", "p": "proyecto", "d": "dificil"}

# Niveles de las preguntas de rubrica. Los mismos de la rubrica de preguntas
# de las practicas; una pregunta del banco puede traer los suyos en "niveles".
NIVELES = [
    ("Excelente", 100, "con precision, y senala en su codigo donde esta"),
    ("Bueno", 80, "la idea correcta, le falta precision en algun termino"),
    ("Suficiente", 60, "a medias"),
    ("Insuficiente", 0, "no puede explicarlo"),
]

COLUMNAS = ["fecha", "codigo", "nombre", "orden", "id", "semana", "tipo",
            "formato", "eleccion", "correcta", "calificacion", "pregunta",
            "respuesta_elegida"]

COLOR = sys.stdout.isatty()


def c(texto, codigo):
    return f"\033[{codigo}m{texto}\033[0m" if COLOR else texto


def negrita(t): return c(t, "1")
def tenue(t): return c(t, "2")
def verde(t): return c(t, "32")
def rojo(t): return c(t, "31")
def amarillo(t): return c(t, "33")


class Salir(Exception):
    pass


def leer(mensaje, defecto=None):
    sufijo = f" [{defecto}]" if defecto not in (None, "") else ""
    try:
        r = input(f"{mensaje}{sufijo}: ").strip()
    except EOFError:
        raise Salir()
    return r if r else (defecto or "")


# ---------------------------------------------------------------------------
# Configuracion
# ---------------------------------------------------------------------------
def cargar_conf(ruta):
    """Lee un curso.conf (sintaxis de shell sencilla: CLAVE=valor)."""
    vars_ = {"HOME": os.path.expanduser("~"),
             "RECURSO_CURSO": os.path.dirname(os.path.abspath(ruta))}
    with open(ruta, encoding="utf-8") as f:
        for linea in f:
            linea = linea.strip()
            m = re.match(r"^([A-Z_][A-Z0-9_]*)=(.*)$", linea)
            if not m:
                continue
            clave, valor = m.group(1), m.group(2).strip()
            if len(valor) >= 2 and valor[0] == valor[-1] and valor[0] in "\"'":
                valor = valor[1:-1]
            valor = re.sub(r"\$\{?([A-Z_][A-Z0-9_]*)\}?",
                           lambda x: vars_.get(x.group(1), x.group(0)), valor)
            vars_[clave] = os.path.expanduser(valor)
    return vars_


def cursos_disponibles():
    cursos = []
    for ruta in sorted(glob.glob(os.path.join(RAIZ_CURSOS, "*", "recurso", "curso.conf"))):
        conf = cargar_conf(ruta)
        if conf.get("BANCO_PREGUNTAS"):
            cursos.append((conf.get("CURSO", ""), conf))
    return cursos


def elegir_curso():
    cursos = cursos_disponibles()
    if not cursos:
        sys.exit("Ningun curso.conf define BANCO_PREGUNTAS.")
    nombres = [n for n, _ in cursos]
    print(tenue("Entre [corchetes] va el valor por defecto: Enter lo acepta."))
    print("Cursos disponibles: " + ", ".join(nombres))
    while True:
        r = leer("Curso", nombres[0] if len(nombres) == 1 else None)
        for n, conf in cursos:
            if r == n:
                return conf
        print(rojo(f"  '{r}' no es uno de: {', '.join(nombres)}"))


def elegir_ciclo(conf):
    dir_ciclo = conf.get("DIR_CICLO", "")
    padre = os.path.dirname(dir_ciclo)
    ciclos = sorted(d for d in os.listdir(padre)
                    if d.isdigit() and os.path.isdir(os.path.join(padre, d))) \
        if os.path.isdir(padre) else []
    if ciclos:
        print("Ciclos disponibles: " + ", ".join(ciclos))
    while True:
        r = leer("Ciclo", os.path.basename(dir_ciclo))
        ruta = os.path.join(padre, r)
        if os.path.isdir(ruta):
            return ruta
        print(rojo(f"  No existe {ruta}"))


def parsear_semanas(texto):
    semanas = set()
    for parte in re.split(r"[,\s]+", texto.strip()):
        if not parte:
            continue
        if "-" in parte:
            a, b = parte.split("-", 1)
            semanas.update(range(int(a), int(b) + 1))
        else:
            semanas.add(int(parte))
    return sorted(semanas)


def cargar_banco(carpeta):
    preguntas = []
    for ruta in sorted(glob.glob(os.path.join(carpeta, "semana-*.json"))):
        with open(ruta, encoding="utf-8") as f:
            for p in json.load(f):
                p["_archivo"] = os.path.basename(ruta)
                preguntas.append(p)
    ids = [p["id"] for p in preguntas]
    repetidos = {i for i in ids if ids.count(i) > 1}
    if repetidos:
        sys.exit(f"Ids repetidos en el banco: {', '.join(sorted(repetidos))}")
    return preguntas


def cargar_alumnos(dir_ciclo):
    ruta = os.path.join(dir_ciclo, "alumnos.csv")
    alumnos = {}
    if os.path.exists(ruta):
        with open(ruta, newline="", encoding="utf-8-sig") as f:
            for fila in csv.DictReader(f):
                codigo = (fila.get("codigo") or "").strip()
                if codigo:
                    alumnos[codigo] = (fila.get("nombre") or "").strip()
    return alumnos


def leer_registro(ruta):
    if not os.path.exists(ruta):
        return []
    with open(ruta, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def guardar(ruta, filas):
    nuevo = not os.path.exists(ruta)
    os.makedirs(os.path.dirname(ruta), exist_ok=True)
    with open(ruta, "a", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=COLUMNAS)
        if nuevo:
            w.writeheader()
        w.writerows(filas)


# ---------------------------------------------------------------------------
# Evaluacion
# ---------------------------------------------------------------------------
def escoger(banco, tipo, semanas, ya_hechas, usos):
    """Al azar entre las menos usadas en esta revision, sin repetir al alumno.

    Preferir las menos usadas reparte el banco: el grupo esta en el salon y oye
    las preguntas de los demas.
    """
    candidatas = [p for p in banco if p["tipo"] == tipo and p["semana"] in semanas
                  and p["id"] not in ya_hechas]
    if not candidatas:
        return None
    minimo = min(usos.get(p["id"], 0) for p in candidatas)
    return random.choice([p for p in candidatas if usos.get(p["id"], 0) == minimo])


def preparar(p):
    """Arma la presentacion de una pregunta: opciones revueltas o niveles."""
    if p["formato"] == "opcion":
        opciones = [(p["correcta"], True)] + [(d, False) for d in p["distractores"]]
        random.shuffle(opciones)
        return {"p": p, "opciones": opciones}
    niveles = [tuple(n) for n in p.get("niveles", NIVELES)]
    return {"p": p, "niveles": niveles}


def mostrar(pres, orden, total):
    p = pres["p"]
    print()
    print(negrita(f"--- Pregunta {orden} de {total}   [{p['id']}]  {p['tipo']}, semana {p['semana']} ---"))
    print()
    print("  " + negrita(p["pregunta"]))
    print()
    if "opciones" in pres:
        for i, (texto, _) in enumerate(pres["opciones"]):
            print(f"  {chr(ord('A') + i)})  {texto}")
    else:
        print(tenue("  Lo que debe aparecer en la respuesta:"))
        print("  " + p["respuesta"])
        print()
        for i, (nombre, puntos, desc) in enumerate(pres["niveles"]):
            print(f"  {i + 1})  {nombre:<12} {puntos:>3}   {tenue(desc)}")
    print()


def capturar(pres):
    """Devuelve (eleccion, correcta, calificacion, texto) o 'otra'."""
    p = pres["p"]
    if "opciones" in pres:
        letras = "".join(chr(ord("a") + i) for i in range(len(pres["opciones"])))
        while True:
            r = leer(f"Eligio ({letras[0]}-{letras[-1]}), r=ver respuesta, s=otra pregunta, q=salir").lower()
            if r == "q":
                raise Salir()
            if r == "s":
                return "otra"
            if r == "r":
                i = next(i for i, (_, ok) in enumerate(pres["opciones"]) if ok)
                print(tenue(f"  Correcta: {chr(ord('A') + i)}.  {p['respuesta']}"))
                continue
            if len(r) == 1 and r in letras:
                texto, ok = pres["opciones"][letras.index(r)]
                return r.upper(), "si" if ok else "no", 100 if ok else 0, texto
            print(rojo("  No entendi."))
    else:
        n = len(pres["niveles"])
        while True:
            r = leer(f"Nivel (1-{n}), s=otra pregunta, q=salir").lower()
            if r == "q":
                raise Salir()
            if r == "s":
                return "otra"
            if r.isdigit() and 1 <= int(r) <= n:
                nombre, puntos, _ = pres["niveles"][int(r) - 1]
                return nombre, "", puntos, ""
            print(rojo(f"  Teclea el numero del nivel (1 a {n}), no los puntos."))


def evaluar_alumno(codigo, nombre, slots, banco, semanas, registro, ruta_csv):
    ya_hechas = {f["id"] for f in registro if f["codigo"] == codigo}
    usos = {}
    for f in registro:
        usos[f["id"]] = usos.get(f["id"], 0) + 1

    respuestas = []  # (pres, captura)
    for orden, slot in enumerate(slots, 1):
        tipo = slot
        if slot == "?":
            while True:
                r = leer(f"Tipo de la pregunta {orden} (f=facil, p=proyecto, d=dificil)").lower()
                if r in TIPOS:
                    tipo = TIPOS[r]
                    break
        while True:
            p = escoger(banco, tipo, semanas, ya_hechas, usos)
            if p is None:
                print(rojo(f"  Ya no quedan preguntas de tipo {tipo} para este alumno en esas semanas."))
                return None
            ya_hechas.add(p["id"])
            pres = preparar(p)
            mostrar(pres, orden, len(slots))
            cap = capturar(pres)
            if cap != "otra":
                respuestas.append((pres, cap))
                break

    # Confirmacion antes de guardar: permite corregir un dedazo.
    while True:
        print()
        for i, (pres, (elec, ok, cal, _)) in enumerate(respuestas, 1):
            marca = "" if ok == "" else (verde(" correcta") if ok == "si" else rojo(" incorrecta"))
            print(f"  {i}) [{pres['p']['id']}] {elec}{marca}  -> {cal}")
        r = leer("Enter guarda, o el numero de pregunta para corregir su captura", "")
        if r == "":
            break
        if r.isdigit() and 1 <= int(r) <= len(respuestas):
            pres = respuestas[int(r) - 1][0]
            mostrar(pres, int(r), len(respuestas))
            cap = capturar(pres)
            if cap != "otra":
                respuestas[int(r) - 1] = (pres, cap)

    ahora = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    filas = []
    for orden, (pres, (elec, ok, cal, texto)) in enumerate(respuestas, 1):
        p = pres["p"]
        filas.append({"fecha": ahora, "codigo": codigo, "nombre": nombre,
                      "orden": orden, "id": p["id"], "semana": p["semana"],
                      "tipo": p["tipo"], "formato": p["formato"],
                      "eleccion": elec, "correcta": ok, "calificacion": cal,
                      "pregunta": p["pregunta"], "respuesta_elegida": texto})
    guardar(ruta_csv, filas)
    return filas


def configurar():
    conf = elegir_curso()
    dir_ciclo = elegir_ciclo(conf)
    revision = leer("Numero de revision", "1")
    semanas = parsear_semanas(leer("Semanas que entran (ej. 1-8)",
                                   conf.get(f"REVISION_{revision}_SEMANAS", "")))
    if not semanas:
        sys.exit("Sin semanas no hay preguntas.")

    banco = [p for p in cargar_banco(conf["BANCO_PREGUNTAS"]) if p["semana"] in semanas]
    conteo = {t: sum(1 for p in banco if p["tipo"] == t) for t in TIPOS.values()}
    print(tenue("  En el banco para esas semanas: " +
                ", ".join(f"{n} {t}" for t, n in conteo.items())))

    print("Tipos de pregunta, una letra por pregunta y en orden:")
    print(tenue("  f=facil, p=proyecto, d=dificil, ?=lo eliges con cada alumno"))
    while True:
        r = leer("Tipos", conf.get("PREGUNTAS_TIPOS", "p ?"))
        slots = [s for s in re.split(r"[,\s]+", r.lower()) if s]
        if slots and all(s in TIPOS or s == "?" for s in slots):
            slots = [TIPOS.get(s, s) for s in slots]
            break
        print(rojo("  Solo f, p, d o ?, separados por espacio."))

    ruta_csv = os.path.join(dir_ciclo, "revision", revision, "preguntas.csv")
    return conf, dir_ciclo, revision, semanas, banco, slots, ruta_csv


def principal():
    conf, dir_ciclo, revision, semanas, banco, slots, ruta_csv = configurar()
    alumnos = cargar_alumnos(dir_ciclo)
    print()
    print(negrita(f"{conf['CURSO']}, ciclo {os.path.basename(dir_ciclo)}, revision {revision}, "
                  f"semanas {semanas[0]}-{semanas[-1]}, preguntas: {' '.join(slots)}"))
    print(tenue(f"Se guarda en {ruta_csv}"))

    evaluados = 0
    try:
        while True:
            print()
            codigo = leer(negrita("Codigo del alumno (q para terminar)")).strip()
            if codigo.lower() == "q":
                break
            if not codigo:
                continue
            nombre = alumnos.get(codigo, "")
            if alumnos and not nombre:
                if leer(amarillo(f"  {codigo} no esta en alumnos.csv. Seguir? (s/n)"), "n").lower() != "s":
                    continue
            elif nombre:
                print("  " + negrita(nombre))
            registro = leer_registro(ruta_csv)
            previas = [f for f in registro if f["codigo"] == codigo]
            if previas:
                if leer(amarillo(f"  Ya tiene {len(previas)} respuestas en esta revision. Agregar mas? (s/n)"),
                        "n").lower() != "s":
                    continue
            if evaluar_alumno(codigo, nombre, slots, banco, semanas, registro, ruta_csv):
                evaluados += 1
                print(verde("  Guardado."))
    except (Salir, KeyboardInterrupt):
        print()
        print(amarillo("Salida. El alumno que estaba a medias no se guardo."))
    print(f"Alumnos evaluados en esta sesion: {evaluados}. Registro: {ruta_csv}")


def resumen():
    conf = elegir_curso()
    dir_ciclo = elegir_ciclo(conf)
    revision = leer("Numero de revision", "1")
    ruta_csv = os.path.join(dir_ciclo, "revision", revision, "preguntas.csv")
    registro = leer_registro(ruta_csv)
    if not registro:
        sys.exit(f"No hay registro en {ruta_csv}")
    por_alumno = {}
    for f in registro:
        por_alumno.setdefault((f["codigo"], f["nombre"]), []).append(f)
    print(f"{'codigo':<11}{'promedio':>9}   detalle (id:calificacion)   nombre")
    print("-" * 78)
    for (codigo, nombre), filas in sorted(por_alumno.items()):
        prom = sum(float(f["calificacion"]) for f in filas) / len(filas)
        detalle = ", ".join(f"{f['id']}:{f['calificacion']}" for f in filas)
        print(f"{codigo:<11}{prom:>9.1f}   {detalle}   {nombre}")


if __name__ == "__main__":
    if "--resumen" in sys.argv:
        resumen()
    else:
        principal()
