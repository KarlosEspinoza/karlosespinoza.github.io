# Resumen ejecutivo: el campo laboral y los Sistemas Operativos (2025-2026)

Insumo para la Academia de Computacion. Que pide el mercado en roles de software,
infraestructura y sistemas. Sintesis del reporte completo (`reporte-laboral.md`).

---

## Conclusion en una frase

El mercado no pide menos teoria de Sistemas Operativos: pide poder **aplicarla**
para operar y diagnosticar sistemas que corren sobre **Linux** y dentro de
**contenedores**.

---

## Los 4 hechos mas solidos (fuente primaria)

1. **El destino del software es Linux.** 78.5% de desarrolladores lo usa
   (Stack Overflow 2025); 91.6% de los sitios web corre sobre familia Unix/Linux
   (W3Techs); 100% de las supercomputadoras TOP500 (8 anos seguidos). Windows
   queda en el escritorio del dev (de ahi WSL2); la produccion es Linux.

2. **Los contenedores son el sustrato estandar, no una moda.** Docker es la
   herramienta #1 del estudio Stack Overflow 2025 (71.1%, mayor salto del ano:
   +17 pts). Entre profesionales de TI el uso de contenedores llego a 92%
   (Docker 2025).

3. **Kubernetes en produccion: 82%** (vs 66% en 2023). CNCF lo describe como el
   "SO de facto" de las cargas modernas (CNCF 2025).

4. **El mercado local refleja el patron global.** En Guadalajara hay vacantes
   reales (Coppel, nearshore) que piden Linux + DevOps; salario DevOps promedio
   ~$36,670 MXN/mes, senior $60,000-$75,000+ (Levels.fyi, Glassdoor MX).

---

## Lo que el mercado pide (por demanda)

Linux en produccion -> Docker/contenedores -> Kubernetes -> CI/CD
(GitHub Actions, Jenkins, GitLab) -> observabilidad (Prometheus, Grafana) ->
scripting (Python, Bash) -> concurrencia y sockets.

## Lo que ya casi no aparece como requisito de contratacion

Implementar algoritmos de planificacion desde cero, paginacion a nivel de bits,
comparativas historicas de SO, administracion de hardware fisico.

---

## El puente con el temario (anticipando la objecion)

Las herramientas que paga el mercado **descansan en conceptos clasicos del temario**:

| Lo que pide el mercado | Concepto de SO que lo sostiene |
|---|---|
| Docker / contenedores | Procesos, namespaces, cgroups, aislamiento, archivos |
| Kubernetes | Planificacion, gestion de recursos, procesos distribuidos |
| Bugs en servicios | Hilos, condiciones de carrera, exclusion mutua, deadlocks |
| Sockets / microservicios | Comunicacion entre procesos, llamadas al sistema |
| Diagnostico (OOM, fugas) | Gestion de memoria, senales, planificacion |

**Propuesta de enfoque:** ensenar los conceptos del temario usando contenedores y
Linux como laboratorio donde el concepto se vuelve tangible. No agregar Docker o
Kubernetes como temas-fin, sino como vehiculo para que el alumno aplique procesos,
memoria, concurrencia y archivos.

---

## Fuentes primarias

Stack Overflow Developer Survey 2025 (49,000+ resp.) - https://survey.stackoverflow.co/2025/ |
CNCF Annual Cloud Native Survey 2025 - https://www.cncf.io/reports/ |
W3Techs Operating Systems for Websites - https://w3techs.com/technologies/overview/operating_system |
TOP500 (nov-2025) - https://www.top500.org/ |
JetBrains State of Developer Ecosystem 2025 - https://devecosystem-2025.jetbrains.com/ |
Docker State of App Dev 2025 - https://www.docker.com/blog/2025-docker-state-of-app-dev/ |
Salarios MX: Levels.fyi, Glassdoor MX, Indeed MX.

Detalle completo, tablas y referencias secundarias en `reporte-laboral.md`.
