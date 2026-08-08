# Reporte: lo que el campo laboral demanda sobre Sistemas Operativos (2025-2026)

Insumo para discusion en la Academia de Computacion. Analiza lo que piden las
ofertas de trabajo en roles de software, infraestructura y sistemas, no lo que
dicta el programa academico.

Fecha de elaboracion: junio 2026.
Autor: Karlos Espinoza.

---

## Nota metodologica (leer primero)

Este reporte distingue dos tipos de fuente para que el argumento sea defendible:

- **Fuentes primarias (alta confianza):** encuestas con muestra y metodologia
  publica (Stack Overflow Developer Survey, CNCF Annual Survey), medicion directa
  de sitios (W3Techs), censo (TOP500), portales de salario con datos propios
  (Glassdoor MX, Indeed MX, Levels.fyi). En el texto se marcan con [P].
- **Fuentes secundarias (referenciales):** agregadores que consolidan lo anterior
  (commandlinux, prepare.sh). Sirven para tendencia y magnitud, no como dato
  exacto. Se marcan con [S].

Limitaciones reconocidas:
1. Buena parte de los datos salariales globales son de Estados Unidos; se incluye
   una seccion aparte con el mercado mexicano y de Guadalajara.
2. "Lo que pide el mercado DevOps" no equivale a "lo que debe ensenar un curso de
   Fundamentos de SO". La seccion 5 separa explicitamente conceptos de SO de
   herramientas de mercado.

---

## 1. Sobre que sistema operativo es la demanda

Respuesta: **Linux**, de forma consistente en todas las fuentes primarias.

| Indicador | Cifra | Fuente |
|---|---|---|
| Desarrolladores que usan Linux (primario o secundario) | 78.5% | Stack Overflow 2025 [P1] |
| Distro mas usada profesionalmente | Ubuntu 27.7%, Debian 10.4% | Stack Overflow 2025 [P1] |
| Sitios web con SO conocido que corren Linux | 61.3% | W3Techs 2026 [P2] |
| Sitios web sobre familia Unix (Linux+BSD+otros) | 91.6% | W3Techs 2026 [P2] |
| VMs Linux en Google Cloud / AWS / Azure | 91.6% / 83.5% / 61.8% | W3Techs / cloud [P2] |
| Supercomputadoras TOP500 con Linux | 100% (8 anos seguidos) | TOP500 nov-2025 [P3] |
| Kubernetes en produccion (sobre Linux) | 82% de quienes usan contenedores | CNCF 2025 [P4] |

Matiz importante para la discusion: en el **escritorio del desarrollador** Windows
sigue siendo comun (de ahi WSL2). Pero el **destino del software** (servidor,
nube, contenedor) es Linux. El alumno desarrolla donde sea, pero despliega en
Linux. Por eso la competencia exigida es operar Linux, no solo conocerlo.

---

## 2. Mercado local: Guadalajara y Jalisco

Guadalajara es uno de los tres polos tecnologicos del pais (junto con CDMX y
Monterrey), con fuerte presencia de nearshore para empresas de EUA [P7].

Evidencia de vacantes reales (OCCMundial, busqueda "DevOps" y "Linux" en
Guadalajara) [S5]:
- Grupo Coppel: Ingeniero DevOps (pipelines, automatizacion de configuracion).
- Manufactura aeroespacial de EUA: DevOps senior para equipo nearshore en GDL.
- Requisitos recurrentes: experiencia Java/DevOps, equipos agiles, Linux como
  base operativa.

Salarios mensuales (MXN) para DevOps en Guadalajara:

| Nivel | Salario mensual aprox. | Fuente |
|---|---|---|
| Promedio compensacion total (zona GDL) | ~$36,670 | Levels.fyi [P8] |
| Promedio nacional DevOps | ~$35,000 - $38,676 | Glassdoor / Indeed MX [P8] |
| Senior (5+ anos, certificaciones, K8s/AWS) | $60,000 - $75,000+ | KeepCoding / UNIR [S6] |

Lectura para la academia: lo mejor pagado localmente lo marcan las mismas
tecnologias que a nivel global (Linux + contenedores + nube). El mercado de GDL
no es una excepcion al patron internacional, lo refleja.

---

## 3. Habilidades de SO ordenadas por demanda (fuentes primarias)

Los porcentajes de esta tabla provienen de encuestas con metodologia publica
(Stack Overflow, JetBrains, CNCF, Docker), no de agregadores. La cifra indica
nivel de adopcion entre desarrolladores o entre usuarios de contenedores, segun
la fuente.

| # | Habilidad / herramienta | Adopcion | Fuente |
|---|---|---|---|
| 1 | Docker / contenedores | 71.1% de desarrolladores; #1 herramienta mas usada; +17 pts en un ano (mayor salto del estudio) | Stack Overflow 2025 [P1] |
| 1b | Contenedores entre profesionales de TI | 92% (vs 80% en 2024) | Docker State of App Dev 2025 [P6] |
| 2 | Kubernetes (orquestacion) | 82% lo corre en produccion (vs 66% en 2023) | CNCF 2025 [P4] |
| 3 | Prometheus (observabilidad) | ~75% en produccion; 89% invierte en el | CNCF 2024 [P4] |
| 4 | GitHub Actions (CI/CD) | 51% (CNCF); 62% en proyectos personales / 41% en orgs (JetBrains) | CNCF 2024 [P4] / JetBrains 2025 [P5] |
| 5 | Argo CD (GitOps/CI-CD) | 45% | CNCF 2024 [P4] |
| 6 | Jenkins (CI/CD) | 44% | CNCF 2024 [P4] |
| 7 | GitLab (CI/CD) | 34% | CNCF 2024 [P4] |
| 8 | Azure Pipelines (CI/CD) | 24% | CNCF 2024 [P4] |
| 9 | Linux en produccion (procesos, permisos, logs, servicios) | base implicita (78.5% usa Linux) | Stack Overflow 2025 [P1] |
| 10 | Python / Bash (automatizacion) | herramientas de scripting dominantes en DevOps | JetBrains 2025 [P5] / linuxcareers [S3] |

Dato fuerte para la discusion: dos fuentes primarias independientes coinciden en
que los contenedores son ya el sustrato estandar, no una moda. Stack Overflow
reporta Docker como la herramienta numero 1 con el mayor salto interanual de todo
el estudio (+17 pts) [P1], y CNCF reporta Kubernetes en produccion al 82%,
describiendolo como el "SO de facto" de las cargas modernas [P4].

> Nota: las cifras finas por herramienta que circulan en agregadores (p. ej.
> "Docker 59%", "Jenkins 35%") quedan sustituidas aqui por las de encuesta
> primaria. Difieren porque cada estudio mide poblaciones distintas
> (desarrolladores en general vs usuarios de contenedores vs profesionales de TI);
> por eso se indica la base de cada porcentaje.

---

## 4. Habilidades de SO ordenadas por mejor pago (global)

| Rol / habilidad | Rango anual (EUA) | Fuente |
|---|---|---|
| eBPF + Kubernetes Engineer | $98,000 - $224,000 | ZipRecruiter [S4] |
| Cloud / Platform Architect (K8s, SRE) | $130,000 - $230,000 | jobtower [S4] |
| Cloud Infrastructure Engineer | ~$189,000 | refontelearning [S4] |
| Site Reliability Engineer (SRE) | ~$166,500 | refontelearning [S4] |
| DevOps Engineer (mediana) | $177,500 | DevOps Market Report H2 2025 [S1] |
| Linux Systems Administrator | $77,000 - $130,830 | Glassdoor [S4] |

Patron: lo mejor pagado combina Linux + contenedores + nube + observabilidad a
bajo nivel. Cuanto mas cerca del kernel y de la operacion real en produccion,
mejor el sueldo (eBPF es el ejemplo extremo: requiere base solida de Linux y C/Go).

---

## 5. Distincion clave: conceptos de SO vs herramientas de mercado

Esta es la objecion academica mas probable, y conviene anticiparla. Las
herramientas que pide el mercado **descansan sobre conceptos clasicos de SO**. No
son temas nuevos que desplacen al temario: son la aplicacion del temario.

| Herramienta que pide el mercado | Concepto de SO que la sostiene (temario) |
|---|---|
| Docker / contenedores | Procesos, namespaces, cgroups, aislamiento, sistema de archivos |
| Kubernetes | Planificacion (scheduling), gestion de recursos, procesos distribuidos |
| Bugs de concurrencia en servicios | Hilos, condiciones de carrera, exclusion mutua, deadlocks |
| Sockets / microservicios | Comunicacion entre procesos, llamadas al sistema |
| Diagnostico de servicio caido (OOM, fugas) | Gestion de memoria, planificacion, senales |
| systemd / daemons / cron | Procesos, estados de proceso, arranque del sistema |

Conclusion de la seccion 5: el curso **no debe ensenar Docker o Kubernetes como
fin**, sino ensenar los conceptos de SO **usando** esas herramientas como
laboratorio donde el concepto se vuelve tangible. El mercado no pide menos teoria
de SO: pide poder aplicarla para operar y diagnosticar.

---

## 6. Lo que ya casi no aparece en las ofertas

Sigue teniendo valor formativo, pero no como requisito directo de contratacion:

- Implementar algoritmos de planificacion (FIFO, Round Robin, SJF) desde cero.
- Paginacion y segmentacion a nivel de bits.
- Comparativas historicas de arquitecturas de SO (Mach, Minix, etc.).
- Administracion directa de hardware fisico (salvo embebido muy especifico).

El mercado no pide saber como funciona el kernel por dentro al detalle: pide saber
operar, diagnosticar y automatizar los sistemas que corren sobre el.

---

## Referencias

### Primarias (alta confianza)

[P1] Stack Overflow Developer Survey 2025 (49,000+ respondentes, 177 paises).
https://survey.stackoverflow.co/2025/ y resultados:
https://stackoverflow.blog/2025/12/29/developers-remain-willing-but-reluctant-to-use-ai-the-2025-developer-survey-results-are-here/

[P2] W3Techs - Usage Statistics and Market Share of Operating Systems for
Websites (medicion directa de sitios, 2026).
https://w3techs.com/technologies/overview/operating_system y
https://w3techs.com/technologies/details/os-linux

[P3] TOP500 - lista de supercomputadoras (nov-2025), 100% Linux.
https://www.top500.org/statistics/list/

[P4] CNCF Annual Cloud Native Survey (Kubernetes en produccion 82% en 2025;
CI/CD: GitHub Actions 51%, Argo 45%, Jenkins 44%, GitLab 34%, Azure Pipelines 24%;
observabilidad: Prometheus ~75% en produccion, 89% invierte en el. Datos 2024-2025).
https://www.cncf.io/announcements/2026/01/20/kubernetes-established-as-the-de-facto-operating-system-for-ai-as-production-use-hits-82-in-2025-cncf-annual-cloud-native-survey/
Encuesta 2024 (PDF): https://www.cncf.io/wp-content/uploads/2025/04/cncf_annual_survey24_031225a.pdf
Encuesta 2025 (PDF): https://www.cncf.io/wp-content/uploads/2026/01/CNCF_Annual_Survey_Report_final.pdf

[P5] JetBrains - The State of Developer Ecosystem 2025 (24,534 desarrolladores,
194 paises; GitHub Actions 62% personal / 41% en organizaciones).
https://devecosystem-2025.jetbrains.com/ y
https://devecosystem-2025.jetbrains.com/tools-and-trends

[P6] Docker - 2025 State of Application Development Report (uso de contenedores
entre profesionales de TI 92%, vs 80% en 2024).
https://www.docker.com/blog/2025-docker-state-of-app-dev/

[P7] Contexto de Guadalajara como polo tecnologico (nearshore, ecosistema).
Referido en analisis de mercado de Levels.fyi y notas de la industria.

[P8] Salarios DevOps Mexico / Guadalajara: Levels.fyi
https://www.levels.fyi/es-mx/t/software-engineer/focus/devops/locations/guadalajara-metropolitan-area
Glassdoor MX https://www.glassdoor.com.mx/Sueldos/devops-sueldo-SRCH_KO0,6.htm
Indeed MX https://mx.indeed.com/career/devops/salaries

### Secundarias (referenciales, agregadores)

[S1] DevOps Job Market Report H2 2025 (mediana $177,500).
https://devopsprojectshq.com/role/devops-market-h2-2025/

[S2] Real-time DevOps skills trends (frecuencia de skills en ofertas). prepare.sh.
https://prepare.sh/trends/devops

[S3] Linux Career Opportunities in 2025. LinuxCareers Blog.
https://www.linuxcareers.com/resources/blog/2025/11/linux-career-opportunities-in-2025-skills-in-high-demand/

[S4] Salarios por habilidad (eBPF, K8s, SRE, sysadmin): ZipRecruiter, jobtower,
refontelearning, Glassdoor.
https://www.ziprecruiter.com/Jobs/Ebpf-Kubernetes ,
https://www.refontelearning.com/blog/top-paying-devops-skills-in-2025-observability-kubernetes-more ,
https://www.jobtower.io/articles/highest-paying-tech-jobs-2025

[S5] OCCMundial - vacantes DevOps y Linux en Guadalajara, Jalisco.
https://www.occ.com.mx/empleos/de-devops/en-jalisco/en-la-ciudad-de-guadalajara/ ,
https://www.occ.com.mx/empleos/de-linux/en-jalisco/en-la-ciudad-de-guadalajara/

[S6] Salario senior DevOps Mexico: KeepCoding, UNIR Mexico.
https://keepcoding.io/blog/salario-devops-engineer-en-mexico/ ,
https://mexico.unir.net/noticias/ingenieria/que-hace-cuanto-gana-devops/

[S7] Cuotas de mercado Linux (servidor, nube, distros), consolidado. commandlinux.
https://commandlinux.com/statistics/linux-server-market-share/

---

Advertencia de uso: las cifras no provienen de un censo unico oficial. Las
primarias [P] tienen metodologia publica; las secundarias [S] consolidan datos de
terceros. El reporte sirve para sustentar decisiones de enfoque del curso, no como
estadistica exacta al decimal.
