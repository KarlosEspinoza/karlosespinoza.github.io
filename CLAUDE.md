# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Sitio GitHub Pages de Karlos Espinoza (karlos.espinoza@academicos.udg.mx).
Usado principalmente para publicar materiales de cursos universitarios.

## Comandos

```bash
# Servir localmente (abre Chrome en http://127.0.0.1:4000/)
make run

# Servir con livereload en red local (sin abrir Chrome)
make local

# Equivalente directo
bundle exec jekyll serve --host 0.0.0.0 --livereload
```

## Tecnología del sitio

- **Generador:** Jekyll con tema Minimalistic
- **Math:** MathJax (delimitadores `$` inline, `$$` bloque)
- **Diagramas:** Mermaid (plugin `jekyll-mermaid`)
- **Markdown:** kramdown + GFM
- **Frontmatter obligatorio** en cada página:
  ```yaml
  ---
  layout: default
  title: Inteligencia Artificial
  ---
  ```
- **Enlace de regreso** al inicio al principio de cada subpágina:
  ```markdown
  [Inicio](/curso/ia)
  ```

## Estructura de cursos

```
curso/
  ia/          ← Inteligencia Artificial (activo, 2026A)
  am/          ← Aprendizaje de Máquina (anterior)
  linux/
  python/
  mim/
  webapp/
```

---

## Curso de Inteligencia Artificial (IE043)

**Universidad:** Centro Universitario de la Costa Sur (CUCSUR), UdeG
**Carrera:** Ingeniería Mecatrónica, 7mo semestre
**Horario:** Lunes y Miércoles 9:00–11:00 hrs (sesiones 120 min; actividades: 90 min)
**Metodologías:** ABP, Aula Invertida, Gamificación, Aprendizaje Colaborativo, Aprendizaje Experiencial

### Hardware disponible en clase

- **Microcontrolador:** Arduino Nano
- **Sensores:** LM35, HC-SR04, LDR, A3144, HW-870, GP2Y0A21YK0F
- **Actuadores:** Servomotor, Motor CD, Buzzer, LED, LED RGB, Válvula, Relé

### Atributos de Egreso que se trabajan en cada actividad

- **AE2A:** Diseñar e implementar sistemas en automatización, control, robótica y sistemas embebidos mediante proyectos integradores.
- **AE7A:** Favorecer el trabajo colaborativo y el liderazgo en equipos multidisciplinarios.

### Evaluación

| Rubro | Peso |
|---|---|
| Proyecto integrador | 50% |
| Prácticas | 20% |
| Evaluación individual | 15% |
| Asistencia y participación | 10% |
| Actividades extra-curriculares | 5% |

### Contenido temático y archivos existentes

```
curso/ia/
  index.md                          ← Índice del curso
  programa/index.md                 ← Programa institucional completo
  template.md                       ← Plantilla base para nuevas páginas
  todo.md                           ← Notas de desarrollo del curso
  proyecto/index.md                 ← Proyecto final (rúbrica completa)

  conceptos_flujo_ml/index.md       ← U1: Introducción ✅

  aprendizaje_supervisado/
    conceptos/index.md              ← U2.1 ✅
    preparacion_limpieza_datos/     ← U2.2 ✅
    ingenieria_caracteristicas/     ← U2.3 ✅
    modelos_supervisados/           ← U2.4 ✅
    redes_neuronales/               ← U2.5 ✅

  aprendizaje_no_supervisado/
    conceptos/index.md              ← U3.1 ✅
    preparacion_reduccion/index.md  ← U3.2 ✅
    tecnicas_principales/index.md   ← U3.3 ✅
    (autoencoders)                  ← U3.4 ❌ pendiente
    (deteccion_anomalias)           ← U3.5 ❌ pendiente

  evaluacion_modelo/
    metricas/index.md               ← U4.1 ✅
    validacion_cruzada/index.md     ← U4.2 ✅
    (hiperparametros)               ← U4.3 ❌ pendiente
    (sobreajuste_subajuste)         ← U4.4 ❌ pendiente
    (integracion_redes_neuronales)  ← U4.5 ❌ pendiente
    (despliegue_modelos)            ← U4.6 ❌ pendiente
```

### Estructura de cada tema (patrón establecido)

Cada subdirectorio de tema contiene:
- `index.md` — actividad de clase (90 min): objetivo, atributos egreso, método, criterios, desarrollo con circuito Arduino + código Python
- `practica.md` — práctica de laboratorio
- `*_gam.md` + `*_datos.csv` — actividad de gamificación (5–10 min)
- `*_extra.md` — actividad extra para casa (40 min, vale 0.1 pts sobre calificación final)

### Prompts de generación de materiales

| Archivo | Uso |
|---|---|
| `prompt_tema.md` | Generar actividad de clase (90 min) con circuito Arduino y código Python |
| `prompt_gam.md` | Generar actividad de gamificación (5–10 min) |
| `prompt_extra.md` | Generar actividad extra para casa (40 min) |
| `prompt_circ.md` | Generar conexiones de circuitos en KiCad |

### Convenciones de contenido

- Los ejemplos siempre usan contexto de **Ingeniería Mecatrónica** (sensores físicos, sistemas embebidos)
- Los ejercicios de código son **incompletos a propósito**: el pseudocódigo de cosas ya vistas (leer pin analógico, escribir CSV, etc.) lo completan los alumnos
- Las ecuaciones se documentan con sus variables debajo de la fórmula
- Los circuitos reutilizan el del tema anterior cuando es posible; se amplían solo si el tema lo requiere
