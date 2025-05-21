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
vim /etc/httpd/conf/httpd.conf
```

Configura a MariaDB.
```bash
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
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
Creamos a **phpmyadmin.conf**
```bash
vim /etc/httpd/conf/extra/phpmyadmin.conf
----
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>
```



Activa los siguientes comandos.
```bash
# Comentamos la siguiente linea
#LoadModule mpm_event_module modules/mod_mpm_event.so

# Descomentamos la siguiente linea
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so

# Esto es para PHP y va al final de todos los LoadModule
LoadModule php_module modules/libphp.so

# Esto es para PHP y va al final de todos los Include
Include conf/extra/php_module.conf

# phpMyAdmin configuration al final del archivo
Include conf/extra/phpmyadmin.conf
```

## Configurar MariaDB
Creamos un usuario con todos los privilegios.
```bash
sudo mariadb -u root -p
MariaDB> CREATE USER 'karlos'@'localhost' IDENTIFIED BY 'algun_pass';
MariaDB> GRANT ALL PRIVILEGES ON mydb.* TO 'karlos'@'localhost';
```
### Pasword o usuario olvidado
Si olvidaste el usuario o el password puedes primero listar a los usuarios con los siguientes comandos.
```bash
sudo mariadb
> SELECT User FROM mysql.global_priv;
```
Ya que veas el nombre del usuario puedes cambiar su contraseña con el siguiente comando.
```bash
> ALTER USER 'karlos'@'localhost' IDENTIFIED BY 'otro_pass';
```
De igual forma puedes borrar al usuario.
```bash
DROP USER 'karlos'@'localhost';
```

## Redactar WebApp
Crea **/srv/http/index.php**.
```bash
vim /srv/http/index.php
```
Escribe el siguiente codigo PHP.
```bash
<?php
echo "Hola PHP\n";
?>
```

## Consulta la WebApp
[localhost/index.php](localhost/index.php)
