# Propuesta de mejoras: IN235 Fundamentos de Sistemas Operativos

Reunion de academia. Junio 2026.

---

## 1. Errores e inconsistencias en la ficha (correcciones menores, sin debate)

### 1.1 Tipo de curso mal declarado

La ficha dice `Tipo de curso: C` (Curso), pero el horario es 40h teoria + 40h practica = 80h totales.
Un curso tipo C es solo teoria. Con horas de practica, el tipo correcto es `CT` (Curso-Taller).

El plan de estudios (tabla de creditos) ya lo lista como CT. La ficha tiene una incongruencia que debe corregirse.

**Accion:** Cambiar `C` a `CT` en la ficha.

### 1.2 Prerrequisito formal insuficiente

La ficha solo pide `IN227 Fundamentos de Computacion` (1er ciclo, introduccion general).
El contenido real del curso (proyecto en Java con hilos, semaforos, sockets) exige:
- `IN239` Fundamentos de POO (3er ciclo)
- `IN226` Fundamentos de Estructura de Datos (4to ciclo)

Un alumno de 2do o 3er ciclo podria inscribirse y no tener las herramientas para el curso.

**Accion:** Agregar IN239 e IN226 como prerrequisitos formales. O al menos como prerrequisitos recomendados con nota explicita en la ficha.

---

## 2. Cambios estructurales (requieren gestion con coordinacion)

### 2.1 Cambiar area de formacion: de OA a BPO o EO

**Problema actual:** IN235 es Optativa Abierta. Los alumnos pueden graduarse sin tomarla.

Pero IN267 Sistemas Operativos Abiertos (EO, obligatoria, 6to ciclo) asume implicitamente que el alumno entiende: que es un proceso, que son hilos, estados de proceso, sistema de archivos. Sin IN235, los alumnos llegan a IN267 sin ese modelo mental.

IN267 dice "NA" en prerrequisitos. Eso es un problema de diseno del plan, no una defensa de mantener IN235 como optativa.

**Propuesta A (cambio de area):** Cambiar IN235 de OA a BPO (Basica Particular Obligatoria). Esto garantiza que todos los alumnos de Teleinformatica lleguen a IN267 con el fundamento.

**Propuesta B (mas ligera, si A no es viable):** Mantener IN235 como OA pero agregar IN235 como prerrequisito recomendado de IN267 en la ficha de IN267.

El argumento de fondo: IN235 e IN267 son la misma materia en dos capas. IN235 da el modelo conceptual (procesos, concurrencia, archivos, red). IN267 lo aplica sobre Linux. Separarlas con una optativa en medio es un riesgo curricular.

### 2.2 Formalizar el vinculo IN235 -> IN267

Accion complementaria a 2.1: La ficha de IN267 debe mencionar IN235 explicitamente, sea como prerrequisito formal o como conocimiento esperado en la presentacion del curso.

---

## 3. Cambios de contenido (al temario)

### 3.1 Agregar llamadas al sistema como concepto articulador (alta prioridad)

**Problema:** El temario actual tiene U4 "Llamadas al sistema" pero las trata como un tema aislado de E/S. En realidad las syscalls son EL mecanismo que hila todo el curso: cuando Java crea un hilo (U2), gestiona memoria (U3), abre un archivo (U5) o crea un socket (U6), en todos los casos llama al SO via syscall.

Sin este concepto explicito, el alumno no ve la unidad del curso. Ve 6 unidades separadas.

**Propuesta:** Agregar en U1 una subseccion:
```
1.4 Interfaz del SO con los programas: llamadas al sistema
    1.4.1 Espacio de usuario vs espacio del kernel
    1.4.2 Como la JVM usa syscalls (createThread, open, read, write, socket)
    1.4.3 Por que el SO arbitra el acceso a hardware
```

Este tema no agrega carga: se puede cubrir en 30-40 minutos conceptuales y regresa en cada unidad como hilo conductor.

### 3.2 Agregar modelo de proteccion del SO (panorama)

**Problema:** El temario no menciona por que el SO necesita proteger los procesos entre si: anillos de privilegio, espacio de usuario vs kernel, permisos de proceso. IN267 tiene una unidad completa de seguridad Linux (permisos, firewall) que asume que el alumno entiende este modelo.

**Propuesta:** Una subseccion en U1 o al final de U2:
```
Modelo de proteccion: por que el SO controla el acceso a recursos
    - Anillos de privilegio (user space / kernel space)
    - Por que un proceso no puede leer la memoria de otro directamente
    - Permisos de proceso en Linux (panorama)
```

Es contenido conceptual, no practico. 45-60 minutos. Prepara directamente para IN267-U6 (Seguridad en Linux).

### 3.3 Reformular U6: de "Red" a "Interfaces del SO a la red"

**Problema:** El titulo "6. Red" da la impresion de que la unidad ensena redes. Los alumnos ya llevan Redes I-III. Lo que realmente se ensena es como el SO expone servicios de red al programador via la API de sockets.

**Propuesta:** Renombrar a "6. Interfaz del SO a la red: sockets" y agregar como primer tema:
```
6.0 Por que los sockets son una abstraccion del SO (no solo de la red)
```

Esto da coherencia con el resto del curso (el SO abstrae hardware de red igual que abstrae disco en U5).

### 3.4 Mencionar contenedores como contexto moderno (opcional, baja carga)

Los contenedores Docker son exactamente U2 (procesos con namespaces) + U3 (cgroups para memoria) del curso. Un teleinformatico que trabaje en DevOps los vera en su primer semana de trabajo.

**Propuesta:** Una nota al final de U2 o U3:
```
Aplicacion moderna: contenedores y virtualizacion ligera
    - Un contenedor es un proceso del SO con namespaces y cgroups
    - Relacion con lo visto en U2 (procesos) y U3 (memoria)
```

No requiere practica con Docker. Solo el concepto. 20-30 minutos.

### 3.5 Profundidad de U2.8 (Planificacion de procesos)

U2.8 lista 6 tipos de planificacion: lotes, multiprogramacion, FIFO, Tiempo Real, Distribuido, Embebido. Con ~45h efectivas del semestre, cubrir todos a profundidad no es viable.

**Propuesta:** Dividir explicitamente en el programa:
- Lotes, multiprogramacion y FIFO: practica con simulacion en Java
- Tiempo Real, Distribuido, Embebido: panorama comparativo en una sola sesion

Esto ya se hace en la practica pero deberia estar escrito en la ficha para que quede claro el nivel esperado en cada tipo.

---

## 4. Cambios de evaluacion y metodologia

### 4.1 El peso de "Exposiciones" (20%) no genera competencias de ingenieria

La evaluacion actual:
- Practicas 30%
- Tareas 20%
- Exposiciones 20%
- Examenes 25%
- Actividades integradoras 5%

Exponer un tema (AE9 comunicacion) es util, pero 20% para exposiciones en una materia de sistemas operativos prioriza la presentacion sobre la construccion. AE3 dice "diseña, desarrolla y administra sistemas" - eso requiere que el alumno construya software, no que lo exponga.

**Propuesta de redistribucion:**

| Rubro | Peso actual | Peso propuesto |
|---|---|---|
| Proyecto progresivo (codigo + bitacora) | -- | 50% |
| Practicas (evidencias tecnicas) | 30% | 25% |
| Examenes | 25% | 15% |
| Exposicion tecnica del proyecto | 20% | 10% |
| Tareas | 20% | -- |
| Actividades integradoras | 5% | -- |

La "exposicion tecnica del proyecto" reemplaza las exposiciones de tema: el alumno demuestra lo que construyo, no expone teoria. Mantiene AE9 (comunicacion) pero vinculado a AE3 (construccion).

### 4.2 Definir explicitamente las actividades integradoras

El programa dice "5% Actividades integradoras" sin especificar que son. Si se mantiene este rubro, debe definirse:

**Propuesta:** Definirlas como demostraciones de avance del proyecto (10-15 min): el alumno muestra en vivo que el componente del sistema funciona. Esto alinea con la estrategia de proyecto progresivo del CLAUDE.md del curso.

### 4.3 Agregar GitHub como evidencia formal en el programa

Actualmente el programa no menciona control de versiones como instrumento de evaluacion. Pero el historial de commits es la evidencia mas objetiva de progresion semanal del alumno.

**Propuesta:** Agregar en Instrumentos de Evaluacion: `IEI-XX: Repositorio de control de versiones (GitHub)` como parte de la evidencia de practicas.

---

## 5. Bibliografía

Los libros actuales tienen 14-15 años:
- Flynn/McHoes, *Sistemas Operativos*, Cengage 2011
- Elmasri/Carrick, *Sistemas Operativos: un enfoque en espiral*, McGraw-Hill 2010

**Propuesta de actualizacion:**

Basica:
- Arpaci-Dusseau, *Operating Systems: Three Easy Pieces* (OSTEP). Disponible gratis en ostep.org. Actualizado, cubre procesos, concurrencia, memoria y sistemas de archivos con el mismo orden que el curso. Referencia estandar en universidades de primer nivel.

Complementaria:
- Goetz et al., *Java Concurrency in Practice*, Addison-Wesley, 2006. El estandar para concurrencia en Java. Cubre exactamente U2 del curso.
- Kerrisk, *The Linux Programming Interface*, No Starch Press, 2010. Referencia completa de syscalls en Linux. Puente directo con IN267.

Se puede mantener Flynn/McHoes como referencia de consulta pero no como libro principal.

---

## 6. Oportunidades de coordinacion entre materias (sin cambio de programa)

### 6.1 Coordinacion con IN251 Arquitectura de Computadoras (concurrente, 5to ciclo)

IN235-U3 (memoria) e IN251 hablan del mismo tema desde perspectivas complementarias:
- IN251: como funciona la memoria desde el hardware (registros, cache, RAM, buses)
- IN235: como el SO gestiona esa memoria (paginacion, swap, memoria virtual)

Un alumno que cursa ambas en el mismo semestre ve la misma pieza desde dos angulos en paralelo pero sin conexion explicita entre los dos cursos.

**Propuesta:** Agregar una nota en ambas fichas (IN235 e IN251) indicando la relacion complementaria. No requiere cambio de temario, solo sincronizacion de fechas: que U3 de IN235 se imparta mientras IN251 esta en el tema de memoria.

### 6.2 Preparacion explicita para IN264 Fundamentos de Programacion de Sistemas (6to ciclo)

IN264 hace Arduino + LabVIEW (sistemas embebidos). U2.8.6 de IN235 cubre planificacion embebida. Esta es la unica conexion tematica directa entre ambos cursos.

**Propuesta:** En la sesion de planificacion embebida de U2, mencionar explicitamente que IN264 profundizara en esto con hardware real.

---

## Resumen de prioridades

| # | Mejora | Impacto | Esfuerzo |
|---|---|---|---|
| 2.1 | Cambiar area de formacion de OA a BPO | Alto | Alto (coordinacion) |
| 1.2 | Agregar IN239 e IN226 como prerrequisitos | Alto | Bajo |
| 3.1 | Agregar syscalls como concepto articulador en U1 | Alto | Bajo |
| 2.2 | Formalizar vinculo IN235 -> IN267 | Alto | Bajo |
| 4.1 | Redefinir evaluacion hacia proyecto progresivo | Medio | Medio |
| 5.0 | Actualizar bibliografia (agregar OSTEP) | Medio | Bajo |
| 3.2 | Agregar modelo de proteccion del SO | Medio | Bajo |
| 1.1 | Corregir tipo de curso de C a CT | Bajo | Bajo |
| 3.3 | Reformular titulo de U6 | Bajo | Bajo |
| 6.1 | Coordinacion con IN251 | Medio | Bajo |
