---
layout: default
title: Permisos
---

# Permisos

En este documento abordaremos el contenido de otro video que explica cómo gestionar permisos en Linux. A continuación, se presentan los comandos en el orden en que son explicados en el video.

## Leer permisos

**Entender los permisos de un archivo o directorio**  
Cada archivo y directorio tiene asociados permisos que se dividen en tres categorías:
1. **Usuario (owner)**: El propietario del archivo o directorio.
2. **Grupo (group)**: Usuarios que pertenecen al mismo grupo que el propietario.
3. **Otros (others)**: Todos los demás usuarios del sistema.

Cada categoría puede tener permisos asignados de la siguiente manera:
- `r` (read) = 4: Permite leer el contenido del archivo o listar el contenido del directorio.
- `w` (write) = 2: Permite modificar el archivo o el contenido del directorio.
- `x` (execute) = 1: Permite ejecutar el archivo o acceder al directorio.

Por ejemplo:
```bash
-rw-r--r-- 1 karlos users 0 Dec 15 08:27 HelloWorld.class
```
Esto indica que:
- El **usuario** `karlos` tiene permisos de lectura y escritura (`rw-`).
- El **grupo** `users` tiene permisos de solo lectura (`r--`).
- **Otros** usuarios también tienen permisos de solo lectura (`r--`).

**Navegar al directorio y listar los permisos**  
Estos comandos te llevan al directorio `Casa` y muestran los permisos de los archivos y directorios en formato detallado.
```bash
cd /home/karlos_espinoza/Casa
pwd
ls -l
```
**Resultado esperado:**  
```bash
total 0
-rw-r--r-- 1 karlos users 0 Dec 15 08:27 HelloWorld.class
-rw-r--r-- 1 karlos users 0 Dec 15 08:27 raton.java
```

**Crear un nuevo directorio y verificar permisos**  
Crea un directorio llamado `nido` y lista los permisos nuevamente.
```bash
mkdir nido
ls -l
```
**Resultado esperado:**  
```bash
total 4
-rw-r--r-- 1 karlos users    0 Dec 15 08:27 HelloWorld.class
drwxr-xr-x 2 karlos users 4096 Dec 15 08:28 nido
-rw-r--r-- 1 karlos users    0 Dec 15 08:27 raton.java
```

**Explicación de los permisos del directorio `nido`:**
El directorio `nido` tiene los permisos `drwxr-xr-x`, que se interpretan de la siguiente manera:

1. **Tipo (`d`)**:
   - El prefijo `d` indica que es un directorio.

2. **Permisos del Usuario (propietario `karlos`)**:
   - `r` (read): Puede listar el contenido del directorio.
   - `w` (write): Puede crear, renombrar, o eliminar archivos y subdirectorios dentro de `nido`.
   - `x` (execute): Puede acceder al directorio y navegar dentro de él.

3. **Permisos del Grupo (`users`)**:
   - `r` (read): Los miembros del grupo pueden listar el contenido del directorio.
   - `x` (execute): Pueden acceder al directorio y navegar dentro de él.
   - **Sin permisos de escritura (`-`)**: No pueden crear, renombrar, ni eliminar archivos o subdirectorios.

4. **Permisos para Otros Usuarios (others):**
   - `r` (read): Pueden listar el contenido del directorio.
   - `x` (execute): Pueden acceder al directorio y navegar dentro de él.
   - **Sin permisos de escritura (`-`)**: No pueden modificar el contenido del directorio.

En resumen, el propietario tiene control total sobre el directorio, mientras que los usuarios del grupo y otros solo pueden acceder y listar su contenido.

Si tienes problemas con el procedimiento, consulta este [videotutorial](https://youtu.be/hCtBNr3BU48?si=SPe7cmNgqNODxZXn).

## Permisos de ejecución

**Configurar permisos para ejecutar un archivo**  
Crea un archivo llamado `alacran`, agrega contenido y ajusta los permisos para que sea ejecutable.
```bash
cd
pwd
cd Casa
whereis python
```
**¿Por qué usamos este comando?**
El comando `whereis python` sirve para localizar la ruta donde está instalado el intérprete de Python. Esto es útil si estamos creando un archivo ejecutable que necesita especificar explícitamente el intérprete en su primera línea (`#!/usr/bin/python`). Saber esta ruta garantiza que el sistema pueda ejecutar correctamente el archivo.

**Resultado esperado:**  
```bash
python: /usr/bin/python /usr/share/man/man1/python.1.gz
```

**Abrir y editar el archivo**  
Edita el archivo `alacran` y agrega el siguiente contenido:
```bash
vim alacran
```
```console
#!/usr/bin/python
print("Soy un Alacran")
```

**Listar los permisos actuales**  
Verifica los permisos del archivo antes de cambiar su configuración.
```bash
ls -l
```
**Resultado esperado:**  
```bash
-rw-r--r-- 1 karlos users   42 Dec 15 08:34 alacran
```

**Cambiar los permisos**  
Usa el comando `chmod` para configurar permisos de lectura, escritura y ejecución. Por ejemplo:
- `7` para el usuario: lectura, escritura y ejecución (`rwx` = 4+2+1).
- `1` para el grupo: solo ejecución (`--x` = 1).
- `0` para otros: sin permisos (`---` = 0).
```bash
chmod 710 alacran
ls -l
```
**Resultado esperado:**  
```bash
-rwx--x--- 1 karlos users   42 Dec 15 08:34 alacran
```

**Ejecutar el archivo**  
Prueba ejecutar el archivo de dos formas diferentes:
```bash
./alacran
/home/karlos/Casa/alacran
```
**Resultado esperado:**  
```bash
Soy un Alacran
```
Si tienes problemas con el procedimiento, consulta este [videotutorial](https://youtu.be/wFmK7OEjWDE?si=qpWNOb6wwugnpNJV).

## Permisos de manera recursiva

**Configurar permisos de forma recursiva**  
Crea un nuevo directorio con subdirectorios y archivos, y ajusta sus permisos recursivamente.
```bash
cd
cd Casa
mkdir -p Cosina/Alacena
cd Cosina
ls
```
**Resultado esperado:**  
```bash
Alacena
```

**Crear un archivo en el directorio**  
Agrega un archivo dentro del directorio `Cosina`.
```bash
touch cucaracha.cpp
ls -l
```
**Resultado esperado:**  
```bash
total 4
drwxr-xr-x 2 karlos users 4096 Dec 15 08:42 Alacena
-rw-r--r-- 1 karlos users    0 Dec 15 08:42 cucaracha.cpp
```

**Cambiar permisos recursivamente**  
Usa el comando `chmod` con la opción `-R` para ajustar permisos en todos los archivos y directorios dentro de `Cosina`. Por ejemplo:
- `7` para el usuario: acceso total (`rwx`).
- `4` para el grupo: solo lectura (`r--`).
- `0` para otros: sin acceso (`---`).
```bash
cd ~/Casa
pwd
ls
chmod -R 740 Cosina
ls -l Cosina/
```

**Resultado esperado:**  
```bash
total 4
drwxr----- 2 karlos users 4096 Dec 15 08:42 Alacena
-rwxr----- 1 karlos users    0 Dec 15 08:42 cucaracha.cpp
```

Si tienes problemas con el procedimiento, consulta este [videotutorial](https://youtu.be/n97R1r-20XA?si=hxvBKlqTvg9yS3fE).

