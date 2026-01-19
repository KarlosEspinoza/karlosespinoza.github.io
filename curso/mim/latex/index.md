---
layout: default
title: Matemáticas para Ingeniería de Materiales
---

[Inicio](index)

# LaTex

## Instalación

Descarga el instalador para Windows llamado [MikTex](https://miktex.org/download) ye ejecuta el instalador. 
Puede seguir los pasos del instalador (Wizard) segun señala la [guía oficial](https://miktex.org/howto/install-miktex). 
Solo te recomiendo que este el paso donde te pregunta el tamaño de hoja usaras indica **Carta** y que instale siempre (**Always**) los paquetes.

![Tamaño de hoja y instalación de paquetes](/image/latex/basic-miktex-settings.png)

## Uso en Visual Studio Code

Recomiendo que uses Visual Studio Code para editar tus documentos. 
Si nunca lo haz usado lo puedes descargar desde su [aquí]() y puedes entender como usarlo siguiendo esta [guía oficia](https://code.visualstudio.com/docs/introvideos/basics).
Puedes usar la extensión **Latex-Worksop** de Visual Studio Code para facilitar el uso de LaTex, aqui te dejo la [guía oficial](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) de la extensión.
Pero antes de instalarlo instala **Perl** desde su enlace [oficial](https://strawberryperl.com/).

### Compilar

Para compilar ejecuta en la terminal lo siguiente.
```console
> pdflatex main.tex
```

## Uso básico

### Estructura mínima de un documento LaTeX

Todo documento LaTeX tiene esta estructura básica:

```latex
\documentclass{article}

\begin{document}

Aquí va el contenido del documento.

\end{document}
```

**Nunca debe faltar**:

* `\documentclass`
* `\begin{document}`
* `\end{document}`

### Escribir texto normal

Dentro del entorno `document` puedes escribir texto normalmente:

```latex
\documentclass{article}

\begin{document}

Este es mi primer documento en LaTeX.
Estoy aprendiendo a escribir tareas con este sistema.
Notaras que aunque estoy escribiendo en diferente linea, LaTex sigue considerando todo esto como un párrafo.

Hasta ahora que dejé una linea en blanco LaTex empieza a considerar a esto como un nuevo párrafo.
De igual forma, notarás que                  unque dejé muchos espacios Latex los ignorará.
Con esto ya aprendiste a crear un documento con texto normal.

\end{document}
```

**Notas importantes**:

* Un **renglón vacío** crea un nuevo párrafo.
* No importa cuántos espacios pongas, LaTeX los ignora.

### Título, autor y fecha (opcional pero útil)

```latex
\documentclass{article}

\title{Tarea 1}
\author{Nombre del estudiante}
\date{\today}

\begin{document}

\maketitle

Este es el contenido de la tarea.

\end{document}
```

### Secciones y subsecciones

#### Secciones

```latex
\section{Introducción}
Este es el texto de la introducción.
```

#### Subsecciones

```latex
\subsection{Objetivo}
Aquí se describe el objetivo del trabajo.
```

#### Ejemplo completo

```latex
\documentclass{article}

\begin{document}

\section{Introducción}
Este trabajo presenta un ejemplo básico de LaTeX.

\subsection{Objetivo}
Aprender a usar secciones y subsecciones.

\section{Conclusión}
LaTeX es útil para escribir tareas.

\end{document}
```

La numeración es automática.

### Escribir ecuaciones

#### Ecuación dentro del texto

```latex
La fórmula es $x^2 + 1 = 0$ y se usa frecuentemente.
```

#### Ecuación centrada (recomendada)

```latex
\begin{equation}
x^2 + 1 = 0
\end{equation}
```

No se necesita ningún paquete adicional para estas ecuaciones básicas.

### Tablas simples

#### Tabla básica de 2 columnas

```latex
\begin{table}
\caption{Título de la tabla}
\begin{tabular}{|c|c|}
\hline
Columna 1 & Columna 2 \\
\hline
Dato 1 & Dato 2 \\
\hline
\end{tabular}
\end{table}
```

Explicación rápida:

* `|c|c|` → dos columnas centradas
* `&` separa columnas
* `\\` cambia de fila
* `\hline` crea líneas horizontales
* El título se escribe con `\caption`.

### Insertar imágenes (figuras)

Para imágenes **solo usaremos un paquete básico**, necesario:

```latex
\usepackage{graphicx}
```

#### Ejemplo completo

```latex
\documentclass{article}
\usepackage{graphicx}

\begin{document}

\section{Figura de ejemplo}

\begin{figure}
\centering
\includegraphics[width=0.5\textwidth]{imagen.png}
\caption{Ejemplo de una imagen}
\end{figure}

\end{document}
```

Importante:

* La imagen (`imagen.png`) debe estar subida al proyecto.
* `width=0.5\textwidth` controla el tamaño.
* `\usepackage` debe de ir antes de `\begin{docment}`

### Listas

#### Lista con viñetas

```latex
\begin{itemize}
\item Primer punto
\item Segundo punto
\item Tercer punto
\end{itemize}
```

#### Lista numerada

```latex
\begin{enumerate}
\item Paso uno
\item Paso dos
\item Paso tres
\end{enumerate}
```

---

### Ejemplo final completo (modelo de tarea)

```latex
\documentclass{article}
\usepackage{graphicx}

\title{Tarea de Matemáticas}
\author{Juan Pérez}
\date{\today}

\begin{document}

\maketitle

\section{Introducción}
Este documento es una tarea escrita en LaTeX.

\section{Ecuaciones}
Una ecuación importante es:
\begin{equation}
x^2 - 4 = 0
\end{equation}

\section{Tabla}
\begin{table}
\caption{Título de la tabla}
\begin{tabular}{|c|c|}
\hline
Columna 1 & Columna 2 \\
\hline
Dato 1 & Dato 2 \\
\hline
\end{tabular}
\end{table}

\section{Figura}

\begin{figure}
\centering
\includegraphics[width=0.5\textwidth]{imagen.png}
\caption{Ejemplo de una imagen}
\end{figure}

\section{Conclusión}
LaTeX permite escribir documentos ordenados y claros.

\end{document}
```


