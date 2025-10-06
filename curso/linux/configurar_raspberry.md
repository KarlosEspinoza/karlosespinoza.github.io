---
layout: default
title: Configurar Raspberry
---

# Configurar Raspberry

---

- [Preparar Memoria micro SD](#preparar-memoria-micro-sd)
- [Instalar Raspberry Pi Imager](#instalar-raspberry-pi-imager)
- [Instalar y configurar Raspberry Pi OS](#instalar-y-configurar-raspberry-pi-os)
- [Encender Raspberry Pi](#encender-raspberry-pi)
- [Conectarse al Raspberry Pi por SSH](#conectarse-al-raspberry-pi-por-ssh)
- [Trabajar en el Raspberry Pi usando Visual Studio Code](#programar-en-el-raspberry-pi-usando-visual-studio-code)

---

## Preparar Memoria micro SD

Necesitarás una memoria micro SD.
Cualquier memoría micro SD te será util siendo igual o superior a 4GB.
Si quisieras obtener un mejor rendimiento te recomiendo revisar las especificaciones técnicas del Raspberry Pi que utilizarás.
Revisa en particular la velocidad de escritura y lectura para que puedas compararlas con la compra que harás.

Siendo un memoria micro SD vendra con un adaptador de memoria SD, donde insertarás la micro SD.
Asegurate de insertarla correctamente y poner el seguro del adaptador en abierto.

![Adaptador de memoria SD](https://cdn.shopify.com/s/files/1/0229/7903/files/SD_Adapter_Lock_large.JPG?v=1494366116)

Esta adaptador lo podrás insertar en tu lector de memoria SD interno de tu computadora.
![Lector interno de memoria SD](https://hardzone.es/app/uploads-hardzone.es/2023/01/lector-tarjetas-sd-portada-1200x675.jpg)
Si tu computadora no cuentas con lector interno de memoria SD, puedes comprar un adaptador USB a SD.
![Lector de tarjetas SD](https://shop.sandisk.com/content/dam/store/en-us/assets/products/accessories/quickflow-sd-usb-a-memory-card-reader/gallery/quickflow-sd-usb-a-memory-card-reader-up.png.thumb.319.319.png)

## Instalar Raspberry Pi Imager

Descarga Raspberry Pi Imager de [raspberrypi.com/software/](https://www.raspberrypi.com/software/).
El Wizard de instalación basicamente solo te pide dar clic en boton Instalar y Finalizar.
![Raspberry Pi Imager](/image/raspberry_pi_imager.jpg)
Si tienes problemas con el procedimiento te recomiendo consultar este 
[videotutorial](https://youtu.be/pfo7-OS2rlI).

## Instalar y configurar Raspberry Pi OS

Seleccionamos la placa Raspberry que estes utilizando dando clic en le botón <kbd>CHOOSE DEVICE</kbd>.
En mi caso, por ejemplo estoy usando Raspberry Pi 2 W.

Despues Seleccionamos el sistema operativo que queremos instalar dando clic en el botón <kbd>CHOOSE OS</kbd>.
Te recomiendo optimizar tu instalación utilizando la opción **Raspberry Pi OS (other)** y finalmente selecionamos **Raspberry Pi OS Lita (32-bit)**.

Selecionamos la memoria SD en el botón <kbd>COOSE STORAGE</kbd>.
Es importante tengas cuidado en este paso, pues si no selecionas la memoria correcta podrías borrar el contenido de alguna otra memoria que tengas conectada.

### Configuración del Raspberry Pi

En la pestaña **General** selecionamos **Set hostname** y escribimos un nombre de como se llamará nuestro raspberry.
Por ejemplo **raspberrypi-karlos**.

Ahora selecionamos **Set user name and password** y colocamos un nombre de usuario y password.
Procura que el nombre de usuario solo contenga letras sin caracteres especiales ni espacios, y escribe un password que recuerdes.

Activa la casilla **Configurar wireless LAN**.
En el **SSID** escribe el nombre de tu red wifi y en el **Password** la contraseña de tu wifi.
Selecciona el código del pais (ej. para México, ME).

Selecciona **Set local settings** y escoge tu zona horaria.
Por ejemplo, **Mexico/General**.
En el teclado, seleccional el codigo del que estas utilizando ahora mismo en tu computadora ya que será con el que accederas.
Por ejemplo yo estoy utilizando un teclado americano, por tanto mi codigo será **us**.

Nos pasamos a la pestaña **Services** y slecionamos la opción **Enable SSH** y **Use password authentication**.

Finalmente le damos clic al botón <kbd>SAVE</kbd> y cerramos la ventana.
Te seguirá apareciendo el dialogo donde te pregunta si quieres aplicar estos ajustes, y le damos clic al botón <kbd>YES</kbd>.

En seguida le damos clic al botón <kbd>NEXT</kbd> y nos aparecerá un dialogo pidiendonos confirmación para borrar y escribir la memoria SD.
Confiramos dando clic en el botón <kbd>YES</kbd>, y comenzará a escribirlo.
Una vez terminado damos clic en <kbd>CONTINUE</kbd> y podemos retirar la memoria para insertarala en el Raspberry.

Si tienes problemas con el procedimiento te recomiendo consultar este 
[videotutorial](https://youtu.be/6B4I4itqD6U).
De igual forma [aquí](https://www.raspberrypi.com/documentation/computers/getting-started.html) puede encontrar documentación adicional.

## Encender Raspberry Pi

Una vez configurada tu memoria SD e insertada en el Raspberry ya podrás la fuente de poder al Raspberry Pi.
Recuerda que hay dos formas de energizarlo, por el puerto micro-USB o por los pines que tiene destinados para este proposito.
Consulta la hoja de especificaciones de tu Raspberry Pi para identificar estos pines y ten mucho cuidado de utilizar una fuente de poder de mucha calidad, ya que el Raspberry es muy sencible a esto.
Mi recomendación es que lo energizes por el puerto micro-USB.

Una vez lo energizes encendera y se conectará a la red wifi que configuramos ateriormente.

## Conectarse al Raspberry Pi por SSH

El primer paso es que tu computadora este conectado a la misma red que configuramos en el Raspberry Pi.
Para ello lo que haremos sera comprobar si hay comunicación entre tu computadora y el Raspberry Pi.
Para esto abriremos el **CMD** y en la terminal escribiremos el siguiente comando para probar la configuracion con el raspberry.
En mi caso mi raspberry se llama **raspberrypi-karlos**.
```console
ping -n 3 raspberrypi-karlos.local
```
Si en la respuestas encuentras en el texto **Received = 3**, quiere decir que si tienes conexión.
En este punto me gustaría aclarar que en la espuesta encontraras al que dice **time=2ms**.
Esto indica la latencia de tu conexión, entre entre menos milisegundos **ms** mejor, pero eso depende de la calidad de todos los componentes en tu red.

Ahora nos conectaremos por SSH utilizando el nombre de usuario que configuramos anteriormente.
En mi caso mi nombre de usuario es **karlos** mi password **perrito2025** y el nombre de mi Raspberry Pi es **raspberrypi-karlos**.
```console
ssh karlos@raspberrypi-karlos.local
```
Nos preguntará que si estamos seguros de continuar le escribimos **yes** y damos enter.
En seguida preguntará por el password.
Considera que mientras empieces a escribir no veras que escribe nada pero si se están enviando lo que escribes.
Al finalizar da enter, y si escribiste bien todo te respondera con el prompt **$**.
Esto indica que ya estas dentro.

Para salir escribimos **exit**.
```console
exit
```
Si tienes problemas con el procedimiento te recomiendo consultar este 
[videotutorial](https://youtu.be/7geKihnn4RI).

## Desabilitar a NetworkManager

Para esta seccióin te pido sigas los pasos como los voy mencionando, mas adelante entenderas cada parte de lo que se hace aqui. Ahora solo sigue esto para mejorar la experiencia de conexxión con el Raspberry Pi.
En mi experiencia, me ha resultado mejor desabilitar a **NetworkManager**, el gestor por defecto que trae **Raspberry pi OS**.
En su lugar iprefiero utilizar a **systemd-netword** y a **wpa_supplicant** directamente. 
El primero gestiona la IP y el segundo la autentificación WiFi.
```bash
sudo systemctl disable --now NetworkManager.service
sudo systemctl disable --now dhcpcd.service

```
Ahora habilitaremos que puedas conectarte por ethernet por **DHCP**, ya sea que tengas un adaptador USB-ethernet o tu placa Raspberry ya venga con la interfaz ethernet.
Crearemos el siguiente archivo.
```bash
sudo nano /mnt/etc/systemd/network/eth0.network
```
Dentro colocaremos lo siguiente
```ini
[Match]
Name=eth0

[Network]
DHCP=yes
```
Editaremos el archivo **/etc/wpa_supplicant/wpa_supplicant-wlan0.conf**.
```bash
sudo nano /etc/systemd/system/wpa_supplicant@wlan0.service.d/
```
Dentro escribimos lo siguiente.
Aqui configurarás todas las redes en las que planeas que el Raspberry Pi se conecte y les dar'as la prioridad que consideres con la propiedad **priority**.
```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=MX

network={
    ssid="MiRedCasa"
    psk="contraseña123"
    key_mgmt=WPA-PSK
    priority=5
}

network={
    ssid="RedCelular"
    psk="otraClave"
    key_mgmt=WPA-PSK
    priority=1
}
```
Para evitar que el servicio **/etc/wpa_supplicant/wpa_supplicant-wlan0.conf** arranque antes que la interfaz **wlan0**, creamos y editamos el archivo **/etc/systemd/network/wlan0.network**.
```bash
sudo nano /etc/systemd/network/wlan0.network
```
Dentro pondremos el siguiente contenido.
```ini
[Match]
Name=wlan0

[Network]
DHCP=yes

```
Creamos el directorio **/etc/systemd/system/wpa_supplicant@wlan0.service.d/**.
```bash
sudo mkdir /etc/systemd/system/wpa_supplicant@wlan0.service.d/
```
Dentro se esa carpeta crearemos el el archivo **/etc/systemd/system/wpa_supplicant@wlan0.service.d/wait-for-device.conf**.
```bash
sudo nano /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
```
Escribimos el siguiente contenido.
```ini
[Unit]
After=sys-subsystem-net-devices-wlan0.device
Requires=sys-subsystem-net-devices-wlan0.device

[Service]
Restart=on-failure
RestartSec=3
```
Finalmente habilitamos a **systemd-netword**, **system-resolved** y a **wpa_supplicant**.
Reiniciaremos para ver si todo funciona bien.
Ten en cuenta que si algo no escribiste correctamente fallar'a el proceso y tendras que iniciar nuevamente.
```bash
sudo systemctl enable systemd-networkd
sudo systemctl enable systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo systemctl enable wpa_supplicant@wlan0.service
sudo reboot
```


## Trabajar en el Raspberry Pi usando Visual Studio Code

### Conectarse

Para este paso considerare que ya tienes instalado Visual Studio Code, si no es así te recomiendo que atiendas el tema Instalacion y uso en Visual Studio Code del curso de Linux.
Eso será suficiente para que puedas avanzar en lo siguiente.

Abre Visual Studio Code y dirigete a la barra inferior izquierda y buscarl ebotón azul <kbd>><</kbd>.
Esto te abrira en en la barra de busqueda un menú donde seleccionaremos la opción **SSH**.
Lo que instalara la extenxión que permitirá las conecciones SSH en Visual Studio Code.
Despues de instalar cerrara el menú y volveremos a dar clic en el botón  <kbd>><</kbd>.
Ahora nos aparecerá la opción **Conect to host**.
Selecionamos esa opción y nos pedirá los datos de conexión a los que ingresamos nuestro usuario y nuestro hosta.
En mi caso es **karlos@raspberrypi-karlos.local**.
En seguida pedirá el **password** con el que configuramos nuestro Raspberry Pi.

### Trabajar con carpetas y archivo usando el Explorador

Nos diriguimos a **View** despues a **Explorer** y damos click en el botón <kbd>Open Folder</kbd>.
Nos aparecerá un menú preguntandonos a que directorio nos queremos ubicar en nuestrro Raspberry Pi.
Aceptaremos el que nos ofrece por defecto **/gome/karlos** dando click en el botón <kbd>OK</kbd>.
Nos volverta a pedir el **password** y abremos ingresado.

Ahora crearemos una carpeta.
Dirigeremos nuestro mouse al espacio de **Explorador** a nuestra carpeta raiz **KARLOS [SSH: RASPBERRYPI-KARLOS.LOCAL]** y nos aparecerá un botón de una **carpeta con el simbolo +**.
Al darle clic nos pedirá el nombre que queremos darle a la carpeta.
Para este ejemplo escribiré **linux** y damos enter para aceptar el nombre.

Ahora crearemos un archivo dentro de esta carpeta.
Para ello diriguimos nuestro mouse al simpolo **>** que parece a un lado de nuestra carpeta **linux** y damos clic.
Esto abrirá la carpeta y cambiará el simpolo a **v**.
Despues dirigeremos nuestro mouse al espacio de **Explorador** a nuestra carpeta raiz **KARLOS [SSH: RASPBERRYPI-KARLOS.LOCAL]** y nos aparecerá un botón de un **hoja con el simbolo +**.
Le daremos como nombre de archivo **hola.py**.
Esto nos abrira el archivo.

En el archivo escribiremos el siguiente código.
```python
print("Hola Raspberry Pi")
```
Guardamos en **File** y despues **Save**.

### Trabajar con la Terminal

Ahora ejeutaremos el script.
Para ello no dirigimos a **View**, despues **Terminal**.
Nos abrira la terminal y en ella nos cambiaremos a la carpeta con el siguiente comando
```bash
cd linux
```
En seguida ejeutaremos el script con el comando
```bash
python hola.py
```

Una vez terminamos de trabajar cerraremos la conecxión dando clic al botón azul <kbd>><</kbd>.
En el menú selecionamos la opción **Close Remote Conection**.

Si tienes problemas con el procedimiento te recomiendo consultar este 
[videotutorial](https://youtu.be/fQRQIupAqgI).

## Arduino

Esta es la forma más sencilla y confiable:

```bash
cd ~
mkdir -p bin/arduino
cd bin/arduino
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
```

Esto:

* Detecta automáticamente tu arquitectura (ARM o ARM64)
* Descarga la versión más reciente
* Instala el binario en el directorio actual

Después, mueve el ejecutable a un directorio del PATH:

```bash
sudo mv bin/arduino-cli /usr/local/bin/
```

Verifica que funcione:

```bash
arduino-cli version
```

---

### 🧰 Configuración inicial

Una vez instalado, crea el archivo de configuración:

```bash
arduino-cli config init
```

Esto crea `~/.arduino15/arduino-cli.yaml`

Puedes editarlo con `nano ~/.arduino15/arduino-cli.yaml` si deseas cambiar rutas o añadir proxies.

---

### 📦 Instalar cores y librerías

Ejemplo para instalar el core de Arduino AVR (Uno, Nano, etc.):

```bash
arduino-cli core update-index
arduino-cli core install arduino:avr
```

Listar placas disponibles:

```bash
arduino-cli board listall
```

Compilar un sketch:

```bash
arduino-cli compile --fqbn arduino:avr:uno /ruta/a/tu/sketch
```

Subirlo (asegúrate de que el usuario tenga permisos sobre `/dev/ttyUSB0`):

```bash
arduino-cli upload -p /dev/ttyUSB0 --fqbn arduino:avr:uno /ruta/a/tu/sketch
```


