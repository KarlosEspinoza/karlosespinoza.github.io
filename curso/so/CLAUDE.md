# CLAUDE.md — Curso IN235: Fundamentos de Sistemas Operativos

Materiales del curso de Fundamentos de Sistemas Operativos para Ingeniería en Teleinformática,
5to semestre, CUCSur UdeG.

**Instructor:** Karlos Espinoza (karlos.espinoza@academicos.udg.mx)  
**Horario:** Lunes (en línea) y Miércoles (presencial) 15:00–16:59 hrs  
**Tiempo efectivo por sesión:** ~1.5 h (el resto se va en pase de lista, espera y ajustes)  
**Horas efectivas estimadas del semestre:** ~43–45 h (vs. 80 h del programa oficial)  
**Grupo:** máximo ~15 alumnos, Ingeniería en Teleinformática  
**Conocimientos previos del alumno:** Java (POO + estructuras de datos), Redes I–III

---

## Confidencialidad de la modalidad (IMPORTANTE: NO publicar)

Realidad operativa del curso:
- **Lunes:** aula invertida a distancia. El asesor esta conectado guiando y resolviendo dudas,
  pero los alumnos realizan ellos mismos la actividad. No es viable estar presencial los lunes.
- **Miercoles:** sesion presencial en aula C5, aprendizaje activo sobre el caso central.

PERO el programa institucional asume que **ambas sesiones son presenciales**. En `programa/index.md`
y en cualquier material visible al alumno, **todo debe presentarse como presencial**.

Reglas al generar o editar materiales publicos:
- **Nunca** escribir que la sesion del lunes es "en linea", "a distancia" o "virtual".
- **Modalidad:** Presencial. **Aula:** C5.
- Lo del lunes se presenta como **"Actividades realizadas antes de la clase (aprendizaje invertido)"**
  y lo del miercoles como **"Actividades de aprendizaje activo a realizar durante la clase"**,
  sin nombrar dias ni modalidad en linea.
- El programa debe cumplir la rubrica de syllabus innovador (`recurso/lineamiento-syllabus.md`):
  aprendizaje invertido, aprendizaje activo, evaluacion y retroalimentacion formativas, y criterios
  de evaluacion sumativa con rubricas. Objetivo: la mayoria de categorias en nivel 3 o 4, ninguna en 1 o 2.

---

## Evaluación

| Rubro | Peso |
|---|---|
| Proyecto integrador (equipo) | 50% |
| Prácticas (el proyecto individual, renombrado por la academia) | 35% |
| Actividades integradoras (las coordina la carrera; informa el % por alumno) | 5% |
| Asistencia | 10% |

**Instrumentos de revisión de avances (prácticas):**

| Instrumento | Peso dentro del proyecto |
|---|---|
| Evidencias (código en GitHub, commits, demo) | 50% |
| BITACORA.md con explicación de conceptos | 30% |
| 2 preguntas (orales o escritas) | 20% |

En el **proyecto integrador** se agrega un cuarto instrumento (autoevaluación entre pares) y los pesos quedan: Evidencias 45%, BITACORA.md 25%, Preguntas 20%, **Autoevaluación entre pares 10%**.

**Flujo de entrega y revisión:** el alumno hace `push` a GitHub de sus evidencias y BITACORA.md
**antes del dia de la revision** (a mas tardar la sesion previa de esa semana). El asesor revisa
codigo + bitacora con anticipacion. El dia de la revision (miercoles) la sesion se dedica solo a
las preguntas (orales, o escritas en papel o archivo de texto). Si no hubo push a tiempo, la
revision cuenta como no entregada.

**Sesiones de revisión de avances (miércoles presencial):**
- ⬛ Revisión 1: miércoles 14 de octubre — cierre Unidades 1 y 2
- ⬛ Revisión 2: miércoles 18 de noviembre — cierre Unidades 3 y 4
- ⬛ Revisión 3: miércoles 9 de diciembre — cierre y entrega final

---

## Regla principal: Aprendizaje por proyecto progresivo

> **Cada clase y cada tema debe aportar directamente a las prácticas (proyecto individual) y al proyecto integrador del alumno. Los ejemplos de clase son fragmentos funcionales del proyecto, no ejercicios aislados.**

### Principio

"Lo que se ve en clase hoy, el alumno lo adapta en su proyecto mañana."

### El caso único del curso: Servidor de Pedidos

Existe **un solo sistema que se usa durante todo el semestre**: un servidor que recibe pedidos desde múltiples terminales de cajero, los procesa y gestiona inventario compartido.

Es el mismo tipo de sistema que opera en empresas como SICAR (puntos de venta). Todos los conceptos del SO encajan de forma natural y obligada — no forzada.

| Unidad | Lo que se agrega al sistema | Por qué ese tema aparece naturalmente |
|---|---|---|
| **U1** – Perspectivas | El servidor existe como proceso en el SO. Lo observamos: `ps`, `top`, estados | El SO es lo que hace que el servidor exista y corra |
| **U2** – Procesos | Cada pedido se maneja en un hilo separado. Dos cajeros piden el último producto al mismo tiempo → condición de carrera, resuelta con semáforo | La concurrencia aparece sola cuando hay múltiples cajeros simultáneos |
| **U3** – Memoria | El catálogo de productos se mantiene en memoria (caché). Cola de pedidos pendientes → administración del buffer | Sin gestión de memoria el servidor se cae bajo carga |
| **U4** – E/S | El servidor lee el catálogo desde un archivo al arrancar y escribe un recibo por cada pedido | El sistema necesita leer y escribir — ahí entran las llamadas al sistema |
| **U5** – Archivos | Los pedidos se persisten en un log (`pedidos.txt`). Búsqueda directa por ID de producto en el catálogo | Los archivos son la memoria permanente del servidor |
| **U6** – Red | El cajero es un cliente que se conecta por socket al servidor. Múltiples cajeros simultáneos | El sistema completo: cliente → socket → servidor → archivo |

**Progresión visible semana a semana:**

```
Semana 1  → Sesión 1: presentación del curso + nicknames (sin laptops, sin setup)
            Tarea 0 (asíncrona): video de configuración + primer push ❌ video pendiente grabar
Semana 2  → un proceso que imprime "Servidor listo"
Semana 4  → ese proceso acepta pedidos en texto plano
Semana 6  → dos cajeros simultáneos sin que se rompa el inventario
Semana 8  → comunicación entre procesos con pipes
Semana 11 → catálogo cargado en memoria con caché
Semana 13 → lectura/escritura de archivos con llamadas al sistema
Semana 15 → log persistente de todos los pedidos
Semana 16 → cajero como cliente que se conecta por socket
```

Al final del semestre el sistema es un servidor funcional end-to-end.

**Las prácticas** (nombre institucional del proyecto individual) son ese mismo servidor, cada alumno con su propio dominio (restaurante, farmacia, renta de equipos, librería, etc.).  
**El proyecto integrador** es una versión más completa desarrollada en equipo, que integra todos los subsistemas.

### Cómo aplicarlo al generar materiales

- **Un solo caso central**: todos los ejemplos de código de todas las clases pertenecen al mismo sistema. No se inventa un nuevo contexto por tema.
- El alumno no parte de cero en su proyecto: **adapta y extiende lo que ya construimos juntos en clase**.
- Los temas se presentan en el **orden en que se necesitan en el proyecto**, no solo en el orden del temario oficial.
- Cada unidad **agrega una capa de funcionalidad** al caso central (procesos → concurrencia → memoria → archivos → red).
- Las actividades del lunes (en línea) preparan el concepto; las del miércoles (presencial) lo aplican sobre el caso central.

### Implicaciones para el diseño de cada clase

1. **Conectar con el proyecto desde el inicio de la sesión**: "Hoy vamos a agregar X a nuestro proyecto."
2. **El código de ejemplo es incompleto a propósito** en las partes que el alumno ya sabe (Java básico, estructuras de datos); solo se deja listo el fragmento nuevo del tema del día.
3. **El cierre de cada sesión** indica explícitamente qué debe cambiar/agregar el alumno en su proyecto antes de la siguiente clase.
4. **BITACORA.md del alumno** debe crecer con cada tema: el alumno explica con sus palabras cómo aplicó el concepto en su proyecto y hace `git push` de esa entrada junto con el código.

---

## Contexto de los proyectos

### Prácticas (proyecto individual)
- La academia pidió que el proyecto individual se considere y se nombre **Prácticas** (misma dinámica). En todo material visible al alumno usar **Prácticas**, no "proyecto individual".
- Cada alumno desarrolla su propia aplicación que simula o usa conceptos del SO.
- El proyecto crece semana a semana conforme se avanza en el temario.
- Los detalles y rúbrica están en `evaluacion/practicas/index.md`.

### Proyecto integrador (equipo)
- Equipos de ~3 alumnos desarrollan un sistema más completo que integra múltiples subsistemas del SO (procesos, memoria, archivos, red).
- Los detalles y rúbrica están en `evaluacion/proyecto_integrador/index.md`.
- **Autoevaluación anónima entre pares:** NO va en el repo del equipo (ahí todos se verían).
  Cada alumno entrega un repo privado propio con un archivo CSV nombrado con su propio codigo de alumno
  (p. ej. `2162628.csv`, columnas `codigo,calificacion`; el nombre del archivo identifica al evaluador)
  y agrega al asesor como colaborador. Así los compañeros no se ven entre sí; solo el asesor lee todo.
  Automatización en `recurso/autoeval/`: `pull-autoevals.sh` (clona/actualiza desde `autoevals.txt`)
  y `aggregate.py` (promedio recibido por alumno). Ver `recurso/autoeval/README.md`.
  Vale **10% de cada revisión** (4to instrumento del integrador). El alumno actualiza su archivo `<codigo>.csv`
  con push **antes de cada una de las 3 revisiones**. Si no hace push, pierde ese 10% en esa revisión;
  no afecta a los compañeros (el promedio se calcula solo con las autoevaluaciones entregadas).

---

## Contexto laboral de los egresados

Los alumnos de Teleinformática suelen insertarse en:
- **Desarrollo backend** (empresa local SICAR — puntos de venta, Java/.NET)
- **DevOps / administración de servidores** (Linux, Docker, bash)
- **Soporte IT** (diagnóstico de sistemas, redes)
- **Desarrollo embebido** (IoT, sistemas embebidos)
- **Trabajo remoto** (startups, freelance)

Los ejemplos y proyectos deben reflejar estos contextos reales.

---

## Stack tecnológico del curso

- **Laptop del alumno:** Windows 10/11 (la gran mayoría)
- **Linux:** WSL2 (sin necesidad de VM ni dual boot)
- **Lenguaje principal:** Java (ya lo dominan desde semestres previos)
- **Editor:** Visual Studio Code
- **Control de versiones:** Git + GitHub (un repositorio por alumno, crece semana a semana)
- **Documentación:** Markdown en el propio repo (`BITACORA.md`) — no se usa Google Docs
- **Plataforma:** Google Classroom (el alumno entrega solo la URL de su repo, una sola vez)

---

## Ajuste de profundidad por tema

Dado el tiempo efectivo real (~45 h), se aplica la siguiente priorización:

| Unidad | Tratamiento |
|---|---|
| U1 – Perspectivas iniciales | Conceptual, ágil. 2 sesiones (~3 h). |
| U2 – Procesos | Núcleo del curso. Máxima profundidad. Concurrencia completa en Java. Planificación: lotes y FIFO en práctica; Tiempo Real/Distribuido/Embebido como panorama comparativo en una sola sesión. |
| U3 – Memoria | Conceptual + simulación en Java (heap/stack del JVM como referencia). |
| U4 – E/S | Conceptual con llamadas al sistema básicas. IN264 (siguiente semestre) profundiza. |
| U5 – Sistemas de archivos | Práctico: operaciones de archivo en Java + estructura del FS de Linux vía WSL2. |
| U6 – Red | Práctico: sockets en Java (ya conocen redes teóricamente de Redes I–III). |

---

## Estructura de archivos del curso

```
curso/so/
  index.md                        ← Índice del curso
  programa/index.md               ← Programa institucional completo
  entorno/index.md                ← Configuración del entorno: video + especificaciones de entrega ❌ pendiente
  CLAUDE.md                       ← Este archivo
  evaluacion/
    practicas/index.md            ← Instrucciones y rúbrica de las prácticas / proyecto individual (servidor de pedidos)
    proyecto_integrador/index.md  ← Instrucciones y rúbrica proyecto integrador (multi-sucursal)
  recurso/                        ← Material de trabajo INTERNO (no publicado al alumno)
    reporte-laboral.md            ← Qué demanda el campo laboral sobre SO (insumo para la academia)
    resumen-ejecutivo-laboral.md  ← Resumen de una página del reporte laboral
    calendario-clases.md          ← Cálculo de sesiones reales por ciclo (festivos, revisiones)
    lineamiento-syllabus.md       ← Rúbrica UdeG de syllabus innovador (aplicar al programa)
    mejoras.md                    ← Notas de mejoras del curso
    malla-curricular.csv / .pdf   ← Malla de Ing. en Teleinformática
    plan-de-estudios.pdf          ← Plan de estudios
    programa_202510.pdf           ← Programa institucional previo (referencia)

  (temas se agregarán aquí conforme avance el semestre)
  perspectivas_iniciales/
  procesos/
  memoria/
  entrada_salida/
  sistemas_archivos/
  red/
```

---

## Estrategia de entrega de evidencias

### Formato de entrega

Todo vive en el repositorio GitHub del alumno. No se usa Google Docs.

| Archivo | Contenido |
|---|---|
| `README.md` | Nombre del alumno, dominio elegido (restaurante, farmacia, etc.), descripción del proyecto |
| `BITACORA.md` | Explicación conceptual semanal: el alumno escribe con sus palabras cómo aplicó cada tema del SO en su proyecto |
| `src/` | Código Java del proyecto, crece con cada unidad |

El alumno entrega la URL del repo en Google Classroom **una sola vez** al inicio del semestre. Todas las revisiones siguientes se hacen sobre el mismo repo actualizado.

### Por qué todo en Markdown dentro del repo

- El instructor usa **Claude Code para revisar**: puede leer código y bitácora juntos en la misma sesión, sin cambiar de herramienta.
- `BITACORA.md` versionado en Git: los commits muestran que el alumno fue escribiendo semana a semana, no todo al final.
- Claude Code puede cruzar lo que el alumno *dice* que hizo (BITACORA) con lo que *realmente* implementó (src/), detectando inconsistencias.
- Elimina Google Docs como plataforma separada: menos fricción para el alumno, menos contexto que cambiar para el instructor.
- Los **commits son evidencia natural** de la progresión semanal, sin necesidad de entregar ZIPs.
- Git y Markdown son habilidades laborales directamente aplicables (SICAR, DevOps, trabajo remoto).

### Flujo del instructor en día de revisión

```bash
# repos.txt tiene las URLs de los 15 alumnos (se llena una sola vez al inicio)
while read repo; do git clone $repo; done < repos.txt

# Para actualizar repos ya clonados en revisiones siguientes
for d in */; do git -C "$d" pull; done

# Luego abrir Claude Code en la carpeta de cada alumno y revisar
```

### Tarea 0 - Configuracion del entorno (asincrona, antes de sesion 2)

No se hace en clase. El primer dia los alumnos probablemente no llevan laptop y el internet del campus
no es confiable. La solucion es un video grabado por el instructor, publicado en Google Classroom.

❌ **Video pendiente grabar.**

El video cubre:
1. Verificar que WSL2 esta funcional en Windows.
2. Instalar Git en WSL2 y configurar nombre/email.
3. Crear cuenta en GitHub (quien no tenga).
4. Usar el template repo del instructor para crear el repo propio del proyecto.
5. Editar `README.md` con nombre, dominio elegido (restaurante, farmacia, etc.).
6. Agregar primera entrada en `BITACORA.md`.
7. `git add . && git commit -m "inicio" && git push`.
8. Pegar la URL del repo en Google Classroom.

Entregable: URL del repositorio en Google Classroom.
Al tener las 15 URLs, el instructor las guarda en `repos.txt` para las revisiones con Claude Code.

---

## Convenciones para generar materiales

- **Frontmatter obligatorio** en cada página: `layout: default` y `title`
- **Enlace de regreso** al inicio de cada subpágina: `[Inicio](/curso/so)`
- **Contexto de los ejemplos:** preferentemente escenarios de backend, servidores o sistemas que los alumnos reconocerían en empresas como SICAR o en trabajo remoto
- **Código siempre en Java** salvo que el tema lo requiera diferente (bash para scripts de shell, etc.)
- **Los ejercicios son incompletos a propósito**: el pseudocódigo de lo ya visto (Java básico, colecciones, etc.) lo completan los alumnos; solo el fragmento nuevo del tema del día está listo
- **Cada sesión termina con una tarea de proyecto**: indicación explícita de qué debe agregar el alumno a sus prácticas (proyecto individual) antes de la siguiente clase

### Regla de caracteres especiales

En los archivos de contenido que ven los alumnos (`index.md`, `practica.md`, y cualquier página publicada del curso) **no usar caracteres especiales** que no se puedan escribir con un teclado normal.

Caracteres prohibidos: `—` (em dash), `←`, `→`, `⬛`, y similares.

Sustituciones:
- `—` entre dos clausulas -> `:` o `,`
- `—` como parentesis -> `( )`
- `—` como separador de titulo o rango -> `-`
- flecha direccional -> `->` o `<-`

Los archivos internos como `CLAUDE.md` no tienen esta restricción.
