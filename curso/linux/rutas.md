---
layout: default
title: Rutas
---

# Rutas

En este documento abordaremos el contenido de otro video que explica el uso de rutas absolutas y relativas en la terminal de Linux. A continuación, se presentan los comandos en el orden en que son explicados en el video.

## Rutas absolutas

**Cambiar al directorio `/home/karlos_espinoza/`**  
Este comando te permite moverte directamente al directorio especificado utilizando su ruta completa.
```bash
cd /home/karlos_espinoza/
```

**Mostrar el directorio actual**  
El comando `pwd` imprime la ruta completa del directorio donde te encuentras actualmente.
```bash
pwd
```

**Cambiar al directorio `/home/`**  
Para moverte al directorio `/home/`, utiliza su ruta absoluta.
```bash
cd /home/
```

**Mostrar el directorio actual nuevamente**  
Confirma que ahora estás en `/home/`.
```bash
pwd
```

**Volver al directorio `/home/karlos_espinoza/`**  
Regresa al directorio del usuario `karlos_espinoza` utilizando su ruta absoluta.
```bash
cd /home/karlos_espinoza/
```

## Rutas relativas

**Subir un nivel en el árbol de directorios**  
Con `../`, subes un nivel desde tu ubicación actual.
```bash
cd ../
```

**Confirmar el directorio actual**  
Verifica tu ubicación después de subir un nivel.
```bash
pwd
```

**Listar el contenido del directorio actual**  
Muestra los archivos y carpetas disponibles en el directorio donde te encuentras.
```bash
ls
```

**Intentar acceder a un directorio inexistente**  
Si intentas moverte a un directorio que no existe, como `./casa/`, recibirás un error.
```bash
cd ./casa/
```
**Resultado esperado:**  
```bash
-bash: cd ./casa/: No such file or directory
```

**Usar autocompletar para navegar**  
Con <kbd>Tab</kbd>, puedes autocompletar rutas. Al escribir `cd ./karlos` y presionar <kbd>Tab</kbd>, verás sugerencias como `karlos/` y `karlos_espinoza/`.
```bash
cd ./karlos[TAB]
```

**Moverse al directorio `karlos_espinoza` con autocompletar**  
Selecciona el directorio `karlos_espinoza/`.
```bash
cd ./karlos_espinoza/
```

**Confirmar el directorio actual**  
Verifica que estás en el directorio `karlos_espinoza`.
```bash
pwd
```

**Crear un directorio con un nombre largo**  
Crea un nuevo directorio llamado `Casa_Azul_de_Frida_Kahlo_en_CDMX` en tu ubicación actual.
```bash
mkdir Casa_Azul_de_Frida_Kahlo_en_CDMX
```

**Listar el contenido del directorio**  
Confirma que el nuevo directorio fue creado correctamente.
```bash
ls
```
**Resultado esperado:**  
```bash
Casa
Casa_Azul_de_Frida_Kahlo_en_CDMX
```

**Usar autocompletar con nombres largos**  
Al escribir `cd Casa_` y presionar <kbd>Tab</kbd>, el sistema completará el nombre del directorio.
```bash
cd Casa_[TAB]
```

**Acceder al directorio largo**  
Entra al directorio `Casa_Azul_de_Frida_Kahlo_en_CDMX`.
```bash
cd Casa_Azul_de_Frida_Kahlo_en_CDMX
```

**Subir dos niveles en el árbol de directorios**  
Con `../../`, puedes subir dos niveles desde tu ubicación actual.
```bash
cd ../../
```

**Confirmar el directorio actual**  
Verifica tu ubicación después de subir dos niveles.
```bash
pwd
```
**Resultado esperado:**  
```bash
/home
```

**Crear un archivo dentro de un directorio existente**  
Primero, asegúrate de que el directorio `casa` exista.
```bash
mkdir casa
```

Luego, crea un archivo llamado `raton.txt` dentro del directorio `casa`.
```bash
touch casa/raton.txt
```

**Verificar el contenido de otro directorio relativo**  
Puedes listar los archivos dentro de `casa` desde tu ubicación actual.
```bash
ls ../casa/
```
**Resultado esperado:**  
```bash
raton.txt

