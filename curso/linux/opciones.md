---
layout: default
title: Opciones
---

# Opciones

En este documento abordaremos el contenido de otro video que explica las distintas opciones y comandos útiles en la terminal de Linux. A continuación, se presentan los comandos en el orden en que son explicados en el video.

## Crear y explorar directorios y archivos

**Ir al directorio principal**  
El comando `cd` sin argumentos te lleva automáticamente al directorio principal del usuario actual.
```bash
cd
```

**Crear un archivo llamado `perro.txt`**  
Este comando crea un archivo vacío llamado `perro.txt` en el directorio actual.
```bash
touch perro.txt
```

**Listar el contenido del directorio actual**  
Muestra los archivos y directorios en la ubicación actual.
```bash
ls
```

**Crear un archivo oculto llamado `.gato.txt`**  
Los archivos que comienzan con un punto (.) son ocultos por defecto en Linux.
```bash
touch .gato.txt
```

**Listar el contenido del directorio actual**  
Revisar los archivos visibles en la ubicación actual.
```bash
ls
```

**Crear un directorio llamado `Casa`**  
Este comando crea un nuevo directorio llamado `Casa` en la ubicación actual.
```bash
mkdir Casa
```

**Listar el contenido del directorio nuevamente**  
Verificar que el directorio `Casa` fue creado correctamente.
```bash
ls
```

## Opciones avanzadas con `ls`

**Mostrar detalles de los archivos y directorios**  
La opción `-l` lista los archivos y directorios con información detallada, como permisos, propietario, tamaño y fecha de modificación.
```bash
ls -l
```

**Mostrar archivos ocultos**  
La opción `-a` muestra todos los archivos, incluyendo los ocultos.
```bash
ls -a
```

**Combinar detalles y archivos ocultos**  
Usando las opciones `-la`, se obtiene una lista detallada que incluye los archivos ocultos.
```bash
ls -la
```

**Intercambiar el orden de las opciones**  
Las opciones `-al` son equivalentes a `-la` y producen la misma salida.
```bash
ls -al

