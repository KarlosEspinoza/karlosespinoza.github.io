---
layout: default
title: Editor de texto
---

# Editor de texto

En este documento abordaremos el contenido de otro video que explica cómo utilizar un editor de texto en la terminal de Linux, en este caso `vim`. A continuación, se presentan los comandos en el orden en que son explicados en el video.

**Ir al directorio principal**  
El comando `cd` sin argumentos te lleva automáticamente al directorio principal del usuario actual.
```bash
cd
```

**Listar el contenido del directorio actual**  
Muestra los archivos y directorios en la ubicación actual.
```bash
ls
```
**Resultado esperado:**  
```bash
Casa
Casa_Azul_de_Frida_Kahlo_en_CDMX
casa
```

**Crear un archivo llamado `perro.txt`**  
Este comando crea un archivo vacío llamado `perro.txt` en el directorio actual.
```bash
touch perro.txt
```

**Listar el contenido del directorio nuevamente**  
Confirma que el archivo `perro.txt` fue creado correctamente.
```bash
ls
```
**Resultado esperado:**  
```bash
Casa
Casa_Azul_de_Frida_Kahlo_en_CDMX
casa
perro.txt
```

**Abrir el archivo `perro.txt` con `vim`**  
Este comando abre el archivo `perro.txt` en el editor de texto `vim`.
```bash
vim perro.txt
```

### Dentro de `vim`

**Modo de inserción**  
Para comenzar a escribir en el archivo, presiona <kbd>i</kbd> para entrar en el modo de inserción.

**Escribir en el archivo**  
Escribe el texto dentro del archivo:
```
Qué onda Linux
```

**Salir del modo de inserción**  
Presiona <kbd>Esc</kbd> para salir del modo de inserción.

**Para ingresar un comando de vim**  
Presiona <kbd>Esc</kbd> para salir del modo de inserción, después presiona <kbd>:</kbd>. Verás que se habilitará en la parte de abajo `:` y podrás escribir comandos.

**Guardar cambios**  
Escribe el comando `:w` para guardar los cambios (escribir el archivo). 
```console
:w
```

**Salir de `vim`**  
Escribe el comando `:q` para cerrar el editor y volver a la terminal.
```console
:q
```

## Combinar comandos

**Abrir un archivo y agregar contenido**  
Se utiliza `vim` para crear o editar el archivo `gato_de_Frida.py` dentro del directorio `Casa_Azul_de_Frida_Kahlo_en_CDMX` y agregar contenido al archivo.
```bash
vim ./Casa_Azul_de_Frida_Kahlo_en_CDMX/gato_de_Frida.py
```

**Escribir en el archivo**  
Entra en modo de inserción con <kbd>i</kbd> y escribe lo siguiente:
```python
print("Yo soy un gato azul")
```

**Guardar y salir del archivo**  
Escribe el comando `:wq` para guardar y cerrar el archivo.
```console
:wq
```

## Diferencia de ejecutar un mismo archivo de texto con diferentes comandos

**Abrir y verificar el archivo**  
Abre el archivo `gato_de_Frida.py` con `vim` para asegurarte de que el contenido está correcto.
```bash
vim ./Casa_Azul_de_Frida_Kahlo_en_CDMX/gato_de_Frida.py
```

**Ejecutar el archivo con Python**  
Ejecuta el script usando Python.
```bash
python ./Casa_Azul_de_Frida_Kahlo_en_CDMX/gato_de_Frida.py
```
**Resultado esperado:**  
```bash
Yo soy un gato azul
```

## Ejecutar comandos de la terminal sin salir del editor

**Abrir y editar el archivo**  
Agrega más contenido al archivo `gato_de_Frida.py`.
```bash
vim ./Casa_Azul_de_Frida_Kahlo_en_CDMX/gato_de_Frida.py
```
**Escribir en el archivo**  
```console
print("Yo soy un gato azul")
ojos = 3**8
print(f"Tengo {ojos} ojos")
```

**Guardar cambios**  
Escribe el comando vim `:w` para guardar el archivo.
```console
:w
```

**Ejecutar el archivo desde vim**  
Usa el comando `:!` para ejecutar el archivo sin salir de `vim`.
```console
:!python ./Casa_Azul_de_Frida_Kahlo_en_CDMX/gato_de_Frida.py
```

**Guardar y salir**  
Guarda y cierra el archivo.
```console
:wq
```

## Compilar y ejecutar un script Java

**Cambiar al directorio `Casa`**  
Navega al directorio donde deseas trabajar.
```bash
cd
cd Casa
```

**Crear y editar un archivo Java**  
Abre un archivo llamado `raton.java` con `vim`.
```bash
vim raton.java
```
**Escribir en el archivo**  
En modo de inserción (<kbd>i</kbd>), escribe el siguiente código:
```console
class HolaMundo {```
    public static void main(String[] args){```
        System.out.println("Soy un ratón");```
    }```
}
```

**Guardar cambios**  
Escribe el comando `:w` para guardar el archivo.
```console
:w
```

**Compilar y ejecutar el archivo desde vim**  
Usa el comando `:!` para compilar y ejecutar el archivo directamente.
```console
:!javac raton.java ; java raton
```

