---
layout: default
title: Comandos básicos
---

# Comandos básicos

En este documento abordaremos el contenido de otro video que explica los comandos esenciales para manejarse en la terminal de Linux. A continuación, se presentan los comandos en el orden en que son explicados en el video.

## Navegar entre carpetas

**Mostrar el directorio actual**  
Este comando imprime la ruta completa del directorio donde te encuentras actualmente.
```bash
pwd
```

**Listar contenido del directorio**  
Muestra los archivos y directorios en la ubicación actual.
```bash
ls
```

**Cambiar al directorio /home/**  
Este comando te permite moverte al directorio `/home/`.
```bash
cd /home/
```

**Listar el contenido del directorio actual (/home/)**  
Después de cambiar de ubicación, puedes verificar qué hay en el directorio `/home/`.
```bash
ls
```

**Confirmar la ubicación actual**  
El comando `pwd` confirma que ahora estás en `/home/`.
```bash
pwd
```

**Listar contenido nuevamente**  
Revisar el contenido del directorio una vez más.
```bash
ls
```

**Acceder al directorio del usuario "karlos_espinoza"**  
Moverse al directorio específico de un usuario.
```bash
cd karlos_espinoza/
```

**Confirmar la ubicación actual nuevamente**  
Verificar que ahora estás dentro del directorio `/home/karlos_espinoza/`.
```bash
pwd
```

## Permiso denegado

**Volver al directorio principal**  
El comando `cd` sin argumentos te lleva automáticamente al directorio principal del usuario actual.
```bash
cd
```

**Confirmar el directorio principal**  
Puedes verificar tu ubicación actual con `pwd`.
```bash
pwd
```

**Regresar al directorio /home/**  
Moverse de nuevo al directorio `/home/`.
```bash
cd /home/
```

**Listar el contenido del directorio /home/**  
Revisar qué usuarios o carpetas están presentes en `/home/`.
```bash
ls
```

**Intentar acceder al directorio de "arturo_nvargas"**  
Este comando intenta cambiar al directorio `arturo_nvargas`, pero se encuentra con un error debido a permisos insuficientes.
```bash
cd arturo_nvargas/
```
**Resultado esperado:**  
```bash
bash: cd: arturo_nvargas/: Permission denied

