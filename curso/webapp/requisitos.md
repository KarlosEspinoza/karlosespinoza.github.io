---
layout: default
title: Webapp
---

# Montar servidor

## Instalar los paquetes necesarios
```bash
pacman -S apache php mariadb pymyadmin php-iconv
```

## Configura a PHP
Edita **/etc/php/php.ini**.
```bash
vim /etc/php/php.ini
```
Corrigue las siguientes variables.
```bash
display_errors = On
display_startup_errors = On
extension=mysqli
extension=pdo_mysql

```

## Configurar Apache
Edita **/etc/httpd/conf/http.conf**.
```bash
vim /etc/httpd/conf/http.conf
```
Activa los siguientes comandos.
```bash
#LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
# Esto es para PHP y va al final de todos los LoadModule
LoadModule php_module modules/libphp.so
# Esto es para PHP y va al final de todos los Include
Include conf/extra/php_module.conf

# phpMyAdmin configuration al final del archivo
Include conf/extra/phpmyadmin.conf
```

## Configurar MariaDB
```bash
sudo mariadb -u root -p
MariaDB> CREATE USER 'monty'@'localhost' IDENTIFIED BY 'some_pass';
MariaDB> GRANT ALL PRIVILEGES ON mydb.* TO 'monty'@'localhost';
```

## Iniciar servicios
Inicia los servicios **mariadb** y **httpd**.
```bash
systemctl start mariadb
systemctl start httpd
```
Revisa que el estado de **mariadb** y **httpd** diga **active (running)**.
```bash
systemctl status mariadb
systemctl status httpd
```

## Redactar WebApp
Crea **/srv/http/index.php**.
```bash
```
Escribe el siguiente codigo PHP.
```bash
<?php
echo "Hola PHP\n";
?>
```

## Consulta la WebApp
[localhost/index.php](localhost/index.php)
