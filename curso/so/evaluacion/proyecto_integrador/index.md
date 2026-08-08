---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Proyecto Integrador

**Ingeniería en Teleinformática - Quinto Semestre**  
**Valor:** 50% de la calificación final

---

## Descripción general

El proyecto integrador es un **Sistema Multi-Sucursal** desarrollado en equipo. Cada integrante aporta su propio servidor de pedidos (el que construye en sus prácticas) como una sucursal del sistema. Un **Servidor Central** los conecta, agrega información de todas las sucursales y ofrece una vista consolidada del negocio.

El resultado es un sistema distribuido real: múltiples procesos independientes corriendo sobre Linux y comunicándose por sockets, con inventario consolidado entre sucursales y una bitácora central de eventos. Es el mismo tipo de arquitectura cliente-servidor que opera un punto de venta multi-tienda como SICAR.

---

## Formación de equipos

- Equipos de **2 o 3 integrantes** (no se permiten equipos de 1 ni de 4 o más).
- **Cada integrante debe tener un dominio diferente** al de sus compañeros, ya que cada uno aporta su sucursal.
- Regístrate con tu equipo y dominios con el asesor durante la primera semana.

**Ejemplo para un equipo de 3:**

| Integrante | Dominio (sucursal) | Servidor de la sucursal |
|---|---|---|
| Alumno A | Restaurante | `ServidorPedidos.java` del restaurante |
| Alumno B | Farmacia | `ServidorPedidos.java` de la farmacia |
| Alumno C | Librería | `ServidorPedidos.java` de la librería |

> El Servidor Central no pertenece a ninguno en particular: es responsabilidad compartida del equipo.

---

## Lo que construyen, capa por capa

Al igual que las prácticas, el integrador crece con cada unidad del curso. Cada tema visto en clase se aplica al sistema del equipo:

| Unidad | Lo que agrega el equipo al sistema |
|---|---|
| **U1** Perspectivas y Linux | Cada sucursal corre sobre Linux (WSL2) como proceso observable (`ps`, `top`). Opcional: cada sucursal en su propio contenedor Docker para mostrar el aislamiento entre sucursales. |
| **U2** Procesos | Cada sucursal corre como proceso independiente. El equipo muestra los procesos corriendo simultáneamente en el SO. |
| **U2** Concurrencia | El Servidor Central recibe pedidos de todas las sucursales en hilos simultáneos. El inventario central se protege con semáforos. |
| **U3** Memoria y diagnóstico | El Servidor Central mantiene en memoria un resumen consolidado del inventario de todas las sucursales y diagnostica su consumo conforme crecen las sucursales y los pedidos. |
| **U4** E/S | El Servidor Central lee los catálogos de cada sucursal al arrancar y escribe eventos en una bitácora central mediante llamadas al sistema. |
| **U5** Archivos | La bitácora central (`bitacora.log`) registra eventos de todas las sucursales en organización secuencial. Se puede consultar por sucursal (acceso directo). |
| **U6** Red | Cada servidor de sucursal se conecta al Servidor Central por socket. El panel de administración es un cliente adicional que monitorea todo el sistema. |

---

## Arquitectura del sistema

```
                   Servidor Central
          (inventario consolidado + bitacora.log)
                /          |          \
           [socket]     [socket]    [socket]
              |             |            |
        Sucursal A     Sucursal B   Sucursal C
        (Restaurante)  (Farmacia)   (Libreria)
              |             |            |
           Cajeros       Cajeros      Cajeros
          (clientes)   (clientes)   (clientes)
```

---

## Estructura del repositorio

```
proyecto-integrador/
  README.md                    # Integrantes, dominios y descripción del sistema
  BITACORA.md                  # Bitácora del equipo: conceptos del SO aplicados
  src/
    ServidorCentral.java       # Servidor que conecta todas las sucursales
    ConexionSucursal.java      # Hilo que gestiona cada sucursal conectada
    InventarioCentral.java     # Inventario consolidado (concurrencia)
    PanelAdmin.java            # Cliente administrador: monitorea todo el sistema
    GestorBitacora.java        # Escritura concurrente a la bitacora central
  bitacora.log                 # Registro de eventos de todas las sucursales

  sucursal-a/                  # Servidor de la sucursal del integrante A (modificado)
    ServidorPedidos.java
    ClienteCajero.java
    catalogo.txt
    pedidos.log

  sucursal-b/                  # Servidor de la sucursal del integrante B (modificado)
    ServidorPedidos.java
    ClienteCajero.java
    catalogo.txt
    pedidos.log

  sucursal-c/                  # Servidor de la sucursal del integrante C (modificado)
    ServidorPedidos.java
    ClienteCajero.java
    catalogo.txt
    pedidos.log
```

> Cada integrante modifica su `ServidorPedidos.java` para que, además de atender cajeros, reporte sus eventos al Servidor Central.

---

## Revisiones de avances

El proyecto se revisa en las **mismas 3 semanas** que las prácticas. El equipo debe hacer **push a GitHub de sus avances antes del día de la revisión** (a más tardar en la sesión previa de esa semana), para que el asesor revise el código y la BITACORA.md con anticipación. El día de la revisión la sesión se dedica únicamente a las **preguntas (orales o escritas, en papel o en archivo de texto)**. Si el equipo no hizo el push a tiempo, no hay nada que revisar y la revisión cuenta como no entregada. Además, cada integrante actualiza y hace push de su autoevaluación privada antes de cada revisión (ver la sección "Autoevaluación del equipo"). En cada revisión cuentan:

| Instrumento | Peso dentro de la revisión |
|---|---|
| Evidencias: código, commits y funcionamiento del sistema completo entregados en GitHub antes de la revisión | 45% |
| BITACORA.md del equipo: explicación de los conceptos aplicados | 25% |
| 2 preguntas (orales o escritas), una por integrante seleccionada al azar | 20% |
| Autoevaluación entre pares: contribución de cada integrante al equipo | 10% |

---

### Revisión 1 - Miércoles 14 de octubre
**Perspectivas, Linux, Procesos y Concurrencia**

**El sistema debe:**
- Correr las sucursales sobre Linux (WSL2) como **procesos independientes** (muestran los procesos en `ps` o `top`)
- El Servidor Central recibe mensajes de cada sucursal en **hilos separados**
- El inventario central maneja el acceso concurrente con **semáforos**
- El sistema no pierde datos cuando dos sucursales actualizan el inventario al mismo tiempo

**La BITACORA.md debe explicar:**
- ¿Cómo se organizan los procesos del sistema? (diagrama de procesos) ¿Qué aportaría ejecutar cada sucursal en un contenedor?
- ¿Qué problemas de concurrencia aparecen en el inventario central?
- ¿Cómo los resolvió el equipo?

---

### Revisión 2 - Miércoles 18 de noviembre
**Memoria, diagnóstico, E/S y Archivos parciales**

**El sistema debe:**
- El Servidor Central mantiene el inventario consolidado en **memoria** (suma de todas las sucursales)
- **Diagnosticar** el consumo de memoria del Servidor Central conforme aumentan las sucursales y los pedidos
- Al arrancar, leer los catálogos de cada sucursal desde sus archivos
- Registrar cada evento (pedido recibido, inventario actualizado) en `bitacora.log`
- La escritura concurrente a `bitacora.log` está protegida (sin líneas mezcladas)

**La BITACORA.md debe explicar:**
- ¿Cómo administra la memoria el Servidor Central y cómo diagnostica su consumo?
- ¿Cómo se garantiza que la bitácora es consistente si varias sucursales escriben al mismo tiempo?

---

### Revisión 3 - Miércoles 9 de diciembre
**Archivos, Red y Sistema completo**

**El sistema debe:**
- `bitacora.log` en organización secuencial con consulta por sucursal (acceso directo)
- `PanelAdmin.java` conectado al Servidor Central por socket, muestra el estado en tiempo real de todas las sucursales
- Al menos **2 cajeros por sucursal** y el panel de admin conectados simultáneamente
- El sistema completo funcionando: cajero -> sucursal -> servidor central -> bitácora

**La BITACORA.md debe incluir:**
- Una sección por cada unidad del curso explicando cómo aparece ese concepto en el sistema integrador
- Tabla de contribución de cada integrante al código del integrador

---

## Autoevaluación del equipo

Cada integrante evalúa de forma **anónima** la contribución real de sus compañeros al proyecto integrador. La evaluación es privada: tus compañeros nunca ven la calificación que les pusiste; solo la ve el asesor. La autoevaluación vale el **10% de cada revisión de avances**.

Para que sea anónima, la autoevaluación **no se entrega en el repositorio del equipo** (ahí todos se verían). Se entrega por un canal privado y separado:

**Cómo se entrega:**
1. Cada integrante crea un **repositorio privado** de GitHub solo para su autoevaluación (por ejemplo `autoeval-so`) y **agrega al asesor como colaborador**. Al ser privado y sin tus compañeros, nadie más puede verlo.
2. Dentro del repositorio coloca un archivo CSV cuyo nombre sea **tu propio código de alumno**, por ejemplo `2162628.csv`.
3. El archivo tiene dos columnas, `codigo` y `calificacion`: una fila por cada compañero al que calificas (no te incluyas a ti mismo). La calificación va de 0 a 100.
4. Entrega la URL de tu repositorio privado en Google Classroom **una sola vez**. Después, **antes de cada una de las 3 revisiones**, actualiza tu archivo `<tu_codigo>.csv` con tu evaluación de esa etapa y haz push.

**Ejemplo:** el alumno `2162628`, en un equipo con `2152525` y `2178899`, sube el archivo `2162628.csv`:

```csv
codigo,calificacion
2152525,90
2178899,100
```

**Reglas:**
- La calificación que recibe cada integrante es el **promedio de las calificaciones que le asignaron sus compañeros**, ponderado con la evaluación del asesor.
- **Si no haces push de tu autoevaluación antes de una revisión, pierdes el 10% de la autoevaluación en esa revisión** (cuenta como no entregada). Esto **no afecta a tus compañeros**: el promedio que ellos reciben se calcula solo con las autoevaluaciones que sí se entregaron.

---

## Calificación

| Revisión | Fecha | Peso |
|---|---|---|
| Revisión 1 | 14 de octubre | 33% |
| Revisión 2 | 18 de noviembre | 34% |
| Revisión 3 | 9 de diciembre | 33% |

> El proyecto integrador equivale al **50% de la calificación final del curso**.

---

## Atributos de Egreso

- **AE2 Nivel Introductorio:** Identifica y resuelve problemas complejos de sistemas de información mediante el diseño de un sistema distribuido multi-sucursal que opera sobre Linux.
- **AE4 Nivel Medio:** Reproduce un ambiente simulado que integra procesos concurrentes, gestión de memoria, E/S y comunicación en red en un solo sistema funcional.
- **AE6 Nivel Medio:** Desarrolla un sistema de información que permite analizar e interpretar datos consolidados de múltiples fuentes, evaluando el comportamiento del SO bajo carga concurrente.
