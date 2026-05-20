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
