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

## Cursos publicados

```
curso/
  ia/          ← Inteligencia Artificial (activo, 2026A) — ver curso/ia/CLAUDE.md
  am/          ← Aprendizaje de Máquina (anterior)
  linux/
  python/
  mim/
  webapp/
```

> Las instrucciones específicas de cada curso viven en su propio `CLAUDE.md` dentro del subdirectorio.

## Scripts de revisión de avances (material interno)

`curso/recursos/` tiene los scripts **genéricos, compartidos por todos los cursos**, para traer a
la máquina local los repositorios de los alumnos, sacar el reporte semanal de asistencia a partir
de los commits y agregar la autoevaluación entre pares. No traen nada específico de un curso: lo
que los configura es un `curso.conf` dentro de cada curso (`curso/<curso>/recurso/curso.conf`).

Los datos de alumnos nunca viven en este repositorio (es público): viven en
`~/curso/<curso>/<ciclo>/`. El único paso que escribe en los repositorios de los alumnos es
`~/curso/scripts/aplicar-concentrado.py`, también fuera de aquí, y requiere autorización explícita
de Karlos para cada lote.

Detalle en `curso/recursos/README.md` y el flujo completo en `curso/recursos/revision/README.md`.
Jekyll excluye `**/recurso/**` y `**/recursos/**`, así que nada de esto se publica en el sitio.

## Reglas de escritura para materiales del curso

- En los archivos de contenido que ven los alumnos (`index.md`, `practica.md`, `*_gam.md`, `*_extra.md`) **no usar caracteres especiales** que no se puedan escribir con un teclado normal. Caracteres prohibidos: `—` (em dash), `←`, `→`, `⬛`, y similares. Sustituir por: coma, parentesis, dos guiones `--`, `->`, o reformular la frase. Si se necesita una flecha, usar `->` o `<-`. Los archivos internos como `CLAUDE.md` no tienen esta restriccion.
