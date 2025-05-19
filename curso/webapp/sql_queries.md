---
layout: default
title: Webapp
---

# SQL query en PHP
Creamos el archivo **/srv/httpd/query.php**.
```bash
vim /srv/httpd/query.php
```
Escribimos el siguiente código para conectarnos a nuestra base de datos **tyest** con el usuario **karlos** y tu password **algun_pass**..

```bash
<?php
echo "Hola query";
$pdo = new PDO('mysql:host=localhost;port3306;dbname=test','karlos','algun_pass');
?>
```
