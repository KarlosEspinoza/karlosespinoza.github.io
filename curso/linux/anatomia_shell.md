---
layout: default
title: Anatomía del SHELL
---

# Anatomía del SHELL

## ¿Qué es el SHELL?
El shell es una interfaz de línea de comandos que permite interactuar con el sistema operativo Linux. Es donde puedes ejecutar comandos para realizar tareas como navegar por el sistema de archivos, manipular archivos, y ejecutar programas.

### Tipos de Shell
Algunos de los shells más comunes son:

- **Bash (Bourne Again Shell)**: El más popular y usado en distribuciones Linux.
- **Zsh (Z Shell)**: Similar a Bash pero con más funciones.
- **Fish (Friendly Interactive Shell)**: Enfocado en la facilidad de uso.

### Accede a un Shell
Para acceder a un sistema operativo Linux tenemos las siguientes opciones:
- Opción 1: Si tiene Windows 10 o superior, instala Ubuntu para que podamos comenzar. Aquí te dejo un [tutorial](https://youtu.be/L4f1XHrSJEg?si=d_aswQX7xzB9BXRd) que te puede ayudar en este procedimiento.
- Opción 2: Si tienes una Raspberry Pi, accede a una terminal de la Raspberry Pi. Aquí te dejo un [tutorial](https://youtu.be/0CUcVMX_rCg?si=pRM8zWKPwBJ-28Bo) que te puede ayudar en este procedimiento.

Una vez dentro de tu sistema operativo Linux revisa qué shell estás usando:
```bash
echo $SHELL
```

## Anatomía de un Comando en Linux

Un comando en Linux tiene la siguiente estructura:

```bash
comando [opciones] [argumentos]
```

### Ejemplo:
```bash
ls -l /home
```
- **`ls`**: Comando para listar archivos y directorios.
- **`-l`**: Opción que muestra el listado en formato largo.
- **`/home`**: Argumento que indica el directorio a listar.

### Ejemplos para entender los argumentos

1. **`ls`**: Este comando lista los archivos y directorios en el directorio actual.
   ```bash
   ls
   ```

2. **`ls -l`**: Incluye una opción para mostrar el listado en formato largo.
   ```bash
   ls -l
   ```

3. **`ls -la`**: Incluye opciones para mostrar archivos ocultos junto con el formato largo.
   ```bash
   ls -la
   ```

4. **`ls -l /`**: Lista el contenido del directorio raíz (`/`) con detalles.
   ```bash
   ls -l /
   ```

## Consultar o cambiar el SHELL

Durante el video se mencionan varios comandos útiles para interactuar con el sistema. Primero, se utiliza el comando para verificar el usuario activo y la terminal. 

**¿Qué usuario está activo?**  
Este comando muestra información sobre el usuario activo en la terminal y su terminal asociada.
```bash
who am i
```

**Buscar un usuario en el sistema**  
Con este comando se busca si el usuario `karlos_espinoza` está registrado en el sistema operativo verificando el archivo `/etc/passwd`, donde se almacena información sobre los usuarios del sistema.
```bash
grep karlos_espinoza /etc/passwd
```

**Verificar el shell actual**  
Para verificar qué shell estás usando, este comando imprime la ruta completa del intérprete de comandos activo.
```bash
echo $BASH
```

**Cambiar a otro shell básico**  
Para cambiar temporalmente a un shell más simple y estándar, se utiliza este comando.
```bash
sh
```

**Verificar shell después de cambiar**  
Al cambiar al shell `sh`, si intentamos verificar el shell actual con este comando, se verá un cambio, ya que el shell activo no será Bash.
```bash
echo $BASH
```

**Volver al shell Bash**  
Para regresar al shell Bash, simplemente ejecuta este comando.
```bash
bash
```

**Confirmar retorno al Bash**  
Finalmente, al regresar al Bash, este comando nuevamente imprimirá la ruta completa del intérprete Bash activo.
```bash
echo $BASH
```

**Autocompletar nombres de comandos**  
El comando `pas[TAB]` intenta autocompletar el nombre de un comando o archivo que comienza con "pas". Si no hay ambigüedad, lo completa automáticamente; de lo contrario, muestra sugerencias.
```bash
pas[TAB]
```

**Autocompletar comando más definido**  
De manera similar, `pass[TAB]` intentará completar el comando "passwd", ya que es una coincidencia única.
```bash
pass[TAB]
```

**Cambiar la contraseña del usuario**  
Con el comando `passwd`, puedes cambiar la contraseña del usuario actual o de otro usuario (si tienes permisos).
```bash
passwd
```

**Mostrar la fecha actual**  
El comando `date` imprime la fecha y hora actuales del sistema.
```bash
date
```

**Ver el calendario**  
El comando `cal` muestra un calendario mensual en la terminal.
```bash
cal
```

**Mostrar el nombre del host**  
El comando `hostname` imprime el nombre del equipo o host actual.
```bash
hostname
```

**Listar dispositivos PCI**  
El comando `lspci` lista todos los dispositivos PCI (como tarjetas gráficas y de red) conectados al sistema.
```bash
lspci
```

**Mostrar información detallada del hardware**  
Con `lshw`, puedes obtener un informe detallado sobre el hardware del sistema.
```bash
lshw
```

## Comandos para Búsqueda y Control del Shell

**Búsqueda en el historial con <kbd>Ctrl</kbd>+<kbd>r</kbd>**  
Al presionar `Ctrl+r`, puedes realizar una búsqueda en el historial de comandos ejecutados anteriormente. Por ejemplo, al buscar "ls", puedes encontrar el último comando que comenzó con esas letras.
```bash
(reverse-isearch)`': ls
```

**Refinar la búsqueda en el historial**  
Puedes refinar tu búsqueda en el historial utilizando <kbd>Ctrl</kbd>+<kbd>r</kbd> nuevamente y añadiendo más caracteres para especificar el comando que deseas recuperar, como "echo $BASH".
```bash
(reverse-isearch)`': echo $BASH
```

**Generar salida repetitiva e interrumpirla**  
El comando `yes` genera una salida repetitiva de una palabra o frase. En este caso, imprimirá "Soy Chido" continuamente hasta que se interrumpa.
Para detener la ejecución de un comando como `yes`, utiliza la combinación <kbd>Ctrl</kbd>+<kbd>c</kbd>, que envía una señal de interrupción.
```bash
yes "Soy Chido"
```
<kbd>Ctrl</kbd>+<kbd>c</kbd>

