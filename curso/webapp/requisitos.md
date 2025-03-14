# Montar servidor

## Instalar los paquetes necesarios
```bash
pacman -S apache php mariadb pymyadmin php-iconv
```

## Configura a PHP
```bash
vim /etc/php/php.ini
-------------
display_errors = On
display_startup_errors = On
extension=mysqli
extension=pdo_mysql

```

## Configurar Apache
```bash
vim /etc/httpd/conf/http.conf
-------------
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
```bash
systemctl start mariadb
systemctl start apache
systemctl status mariadb
systemctl status apache
```

## Redactar WebApp
```bash
vim /srv/http/index.php
------------
<?php
phpinfoi();
?>
```

## Consultar WebApp
[localhost/index.php](localhost/index.php)
