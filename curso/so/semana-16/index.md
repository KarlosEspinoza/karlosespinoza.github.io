---
layout: default
title: Fundamentos de Sistemas Operativos
---
[Inicio](/curso/so)

# Semana 16 - Sockets y red (U6)

Última semana de contenido, y la que convierte tu proyecto en un sistema de verdad. Hasta hoy tus cajeros eran una tubería: procesos en la misma máquina, lanzados desde la misma terminal. Esta semana el cajero se va a otra computadora y se conecta por la red, que es como funciona el sistema de una tienda real.

De redes ya sabes bastante por Redes I a III. Lo que aporta este curso es la otra mitad de la historia: **qué es un socket para el sistema operativo**. Y la respuesta enlaza con todo lo que has hecho desde la semana 13, porque un socket es, otra vez, un descriptor de archivo. Aceptar una conexión, leer un pedido y escribir una respuesta son las mismas llamadas al sistema que usaste para los recibos. La red, vista desde tu programa, es un archivo raro.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: el socket como descriptor](#bloque-1)
    - [Bloque 2: tu servidor en la red](#bloque-2)
    - [Bloque extra: un cajero desde otra máquina](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Entiendes el socket como descriptor y la secuencia de llamadas | Tu diagrama de la conexión y tu lectura de `ss` |
| 2 | Pones tu servidor a escuchar y escribes el cliente cajero | `src/ClienteCajero.java` y `evidencias/red.txt` |
| Extra | Conectas un cajero desde otra computadora | La evidencia de la conexión remota |

Un commit al terminar cada bloque. Y lo de siempre: **si te atoras, lo documentas y haces commit igual**, con las cuatro partes de la [subsección `#### Atorones`](/curso/so/semana-01#como-se-trabaja).

---

### Bloque 1: el socket como descriptor {#bloque-1}

#### Qué es un socket

Un **socket** es un extremo de comunicación. Para el sistema operativo es, otra vez, **un descriptor de archivo**: un número en la tabla de tu proceso, sobre el que puedes hacer `read` y `write` igual que sobre un archivo.

Esa uniformidad es una de las mejores ideas de Unix y hay una frase que la resume: *todo es un archivo*. Un archivo del disco, una tubería, un dispositivo, un socket: todos se manipulan con las mismas llamadas al sistema y con los mismos descriptores. Por eso tu `BufferedReader` funciona igual leyendo del catálogo, de la entrada estándar o de la red.

Compruébalo cuando tu servidor esté escuchando:

```bash
ls -l /proc/TU_PID/fd
```

```
lrwx------ 1 karlos karlos 64 ... 0 -> /dev/pts/0
lrwx------ 1 karlos karlos 64 ... 1 -> /home/karlos/so-proyecto/datos/servidor.log
l-wx------ 1 karlos karlos 64 ... 5 -> /home/karlos/so-proyecto/datos/pedidos.log
lrwx------ 1 karlos karlos 64 ... 7 -> socket:[418822]
lrwx------ 1 karlos karlos 64 ... 9 -> socket:[419103]
```

Los descriptores 7 y 9 son sockets. El 7 es el que escucha, el 9 es una conexión de un cajero. Están en la misma tabla que el log, con el mismo tipo de número.

#### La secuencia de llamadas

Del lado del servidor son cuatro llamadas al sistema, en este orden:

```
socket()   -> crea el descriptor. Todavia no sirve para nada
   |
bind()     -> le asigna una DIRECCION: una IP y un PUERTO
   |
listen()   -> lo pone a escuchar, y crea la COLA de conexiones pendientes
   |
accept()   -> saca una conexion de la cola y devuelve un descriptor NUEVO
   |          para hablar con ESE cliente. Se BLOQUEA si no hay ninguna.
   v
read/write sobre el descriptor nuevo
```

Y del lado del cliente, dos:

```
socket()   -> crea el descriptor
connect()  -> se conecta a una IP y un puerto
```

De todo esto, lo que hay que entender bien es `accept()`, porque es donde se equivoca todo el mundo:

- **Devuelve un descriptor distinto** del que escucha. El que escucha sigue escuchando; el nuevo es la conversación con ese cliente concreto. Con 50 cajeros conectados tienes 51 descriptores: 1 escuchando y 50 conversando.
- **Se bloquea** si no hay conexiones pendientes. El proceso queda en estado `S`, sin gastar CPU, exactamente como tu servidor de la semana 2 esperando pedidos. Esperar bien, otra vez.
- **La cola de `listen`** tiene tamaño. Las conexiones que llegan mientras no llamas a `accept` se forman ahí, y si se llena, **se rechazan**. Es el mismo problema de la cola acotada de la semana 12, ahora en el kernel y con parámetros que no controlas del todo.

En Java todo esto viene envuelto:

```java
ServerSocket servidor = new ServerSocket(5000);   // socket + bind + listen
Socket cajero = servidor.accept();                // accept
```

Dos líneas, cuatro llamadas al sistema. En el bloque 2 las vas a ver con `strace`.

#### Puertos, y por qué el tuyo va a ser 5000 y no 80

El **puerto** es un número de 16 bits que identifica a qué proceso de esa máquina va el tráfico. La IP llega a la máquina; el puerto llega al proceso.

| Rango | Nombre | Quién los usa |
|---|---|---|
| 0 a 1023 | Bien conocidos | Servicios estándar (80 web, 22 SSH, 443 HTTPS). **Requieren root** |
| 1024 a 49151 | Registrados | Aplicaciones. **Aquí va el tuyo** |
| 49152 a 65535 | Efímeros | Los que el SO asigna a los clientes automáticamente |

Que los puertos bajos requieran privilegios es una medida de seguridad antigua y sensata: evita que cualquier usuario levante un servicio falso en el puerto del correo. Por eso tu servidor va a escuchar en el 5000, y en producción quien escucha en el 80 es un proxy que sí corre con privilegios.

Y una cosa que confunde: **una conexión se identifica por cuatro datos**, no por uno. La tupla es `(IP origen, puerto origen, IP destino, puerto destino)`. Por eso 50 cajeros pueden estar conectados al mismo puerto 5000 de tu servidor al mismo tiempo: cada uno tiene un puerto de origen distinto, así que las cuatro tuplas son distintas.

#### Mirar las conexiones: `ss`

`ss` (*socket statistics*) es el `ps` de las conexiones:

```bash
ss -ltnp          # los que estan ESCUCHANDO
ss -tnp           # las conexiones establecidas
```

| Opción | Qué hace |
|---|---|
| `-l` | Solo los que escuchan |
| `-t` | Solo TCP |
| `-n` | Números, sin resolver nombres. Mucho más rápido |
| `-p` | Qué proceso es. Puede necesitar `sudo` |

```
State    Recv-Q Send-Q Local Address:Port  Peer Address:Port  Process
LISTEN   0      50           0.0.0.0:5000       0.0.0.0:*     users:(("java",pid=812,fd=7))
ESTAB    0      0          127.0.0.1:5000     127.0.0.1:47122 users:(("java",pid=812,fd=9))
```

Dos cosas que vale la pena leer bien:

- **`0.0.0.0:5000`** significa "escucho en todas las interfaces". Si dijera `127.0.0.1:5000`, solo aceptaría conexiones de la propia máquina, y ningún cajero externo podría conectarse. Es la causa número uno de "mi servidor no acepta conexiones remotas".
- **`Recv-Q` y `Send-Q`** son los buffers del kernel para esa conexión. Si `Send-Q` crece, el cliente no está leyendo lo que le mandas. Es un diagnóstico directo de cuál de los dos lados va lento.

#### El estado TIME_WAIT

Uno que va a aparecer y que desconcierta. Después de cerrar una conexión, el socket se queda un rato en estado `TIME_WAIT`:

```bash
ss -tan | grep TIME-WAIT | wc -l
```

Es a propósito: TCP espera un par de minutos por si llegan paquetes retrasados de esa conexión, para no confundirlos con una conexión nueva en el mismo puerto. La consecuencia práctica que sí te afecta: **si detienes tu servidor y lo relanzas de inmediato, puede decir "Address already in use"**. No es que tu proceso siga vivo; es el socket viejo en `TIME_WAIT`.

Se resuelve con una opción del socket:

```java
ServerSocket servidor = new ServerSocket();
servidor.setReuseAddress(true);
servidor.bind(new InetSocketAddress(5000));
```

**Lo que entregas de este bloque**

En `BITACORA.md`, bajo `### Antes de la clase`:

1. **Tu diagrama de la conexión.** Dibuja (en texto) la secuencia completa de llamadas de los dos lados, desde `socket()` hasta el primer pedido atendido, indicando **en qué punto se bloquea cada uno** y esperando qué.

2. **Por qué `accept()` devuelve un descriptor nuevo.** Explica qué pasaría si devolviera el mismo, con 3 cajeros conectados.

3. **Tu diseño de protocolo.** Tus cajeros y tu servidor tienen que hablar el mismo idioma sobre el socket. Define:

   | | Formato |
   |---|---|
   | Lo que manda el cajero | |
   | Lo que responde el servidor si acepta | |
   | Lo que responde si rechaza | |
   | Cómo se despide el cajero | |

   Lo natural es reusar `ID;PRODUCTO;CANTIDAD` de la semana 3, y esa continuidad es el punto. Si tu formato cambia aquí, di por qué.

4. **Qué puerto vas a usar** y por qué no puedes usar el 80.

```bash
git add .
git commit -m "s16 bloque 1: sockets como descriptores y protocolo"
git push
```

---

### Bloque 2: tu servidor en la red {#bloque-2}

#### El servidor que escucha

Agrega a tu `ServidorPedidos` el modo red. La estructura es la de siempre, con un hilo por conexión, que es exactamente lo que hiciste en la semana 4 con un hilo por pedido:

```java
// Modo red: un hilo por cajero conectado.
static void escuchar(int puerto) throws IOException {

    ServerSocket servidor = new ServerSocket();
    servidor.setReuseAddress(true);                       // evita el TIME_WAIT
    servidor.bind(new InetSocketAddress(puerto));         // socket + bind + listen

    registrar("Escuchando en el puerto " + puerto);

    while (!apagando) {

        Socket cajero = servidor.accept();                // se bloquea aqui
        registrar("Cajero conectado desde " + cajero.getRemoteSocketAddress());

        // Un hilo por conexion. El ciclo vuelve de inmediato a accept().
        Thread hilo = new Thread(() -> atenderCajero(cajero),
                                 "cajero-" + cajero.getPort());
        hilo.start();
    }

    servidor.close();
}

static void atenderCajero(Socket cajero) {

    // try-with-resources: cierra el socket y los flujos pase lo que pase.
    try (Socket s = cajero;
         BufferedReader entrada = new BufferedReader(
                 new InputStreamReader(s.getInputStream()));
         PrintWriter salida = new PrintWriter(s.getOutputStream(), true)) {

        String linea;
        while ((linea = entrada.readLine()) != null) {

            if (linea.equals("ADIOS")) break;

            // TODO: construye el Pedido desde la linea, metelo al buffer
            //       acotado de la semana 12 y responde al cajero:
            //         ACEPTADO;<id>;<total>
            //         RECHAZADO;<id>;<motivo>
            //       Reusa todo lo que ya tienes: no dupliques la logica.

            salida.println("ACEPTADO;...");     // el true del PrintWriter hace flush
        }

    } catch (IOException e) {
        registrar("El cajero se desconecto de golpe: " + e.getMessage());
    }

    registrar("Cajero desconectado");
}
```

Tres detalles que no son opcionales:

**El `true` del `PrintWriter`** activa el autoflush. Sin él, tu respuesta se queda en el buffer de la aplicación y el cajero espera indefinidamente una respuesta que ya escribiste. Es el mismo buffering de la semana 13, y aquí el síntoma no es un log vacío: es un cliente colgado. **Es el error número uno de esta semana.**

**El `try-with-resources` sobre el socket.** Cada conexión es un descriptor, y si no lo cierras se acumulan hasta el `ulimit -n` de la semana 13. Un servidor de red que no cierra sockets muere en cuestión de horas.

**El `catch` de `IOException`.** Un cajero puede desaparecer en cualquier momento: se le acaba la batería, se cae el wifi, alguien cierra la ventana. Tu servidor **no puede caerse por eso**. Si un hilo de conexión muere sin capturar, en el mejor caso pierdes ese cajero, y en el peor te llevas el servidor.

#### El cliente cajero

Crea `src/ClienteCajero.java`:

```java
// ClienteCajero.java - la terminal de un cajero, conectada por red
import java.io.*;
import java.net.Socket;
import java.util.Scanner;

public class ClienteCajero {

    public static void main(String[] args) {

        String host = args.length > 0 ? args[0] : "localhost";
        int puerto  = args.length > 1 ? Integer.parseInt(args[1]) : 5000;

        System.out.println("Cajero conectando a " + host + ":" + puerto);

        try (Socket s = new Socket(host, puerto);            // socket + connect
             BufferedReader respuesta = new BufferedReader(
                     new InputStreamReader(s.getInputStream()));
             PrintWriter envio = new PrintWriter(s.getOutputStream(), true);
             Scanner teclado = new Scanner(System.in)) {

            System.out.println("Conectado desde el puerto local " + s.getLocalPort());
            System.out.println("Escribe pedidos ID;PRODUCTO;CANTIDAD, o ADIOS para salir");

            while (teclado.hasNextLine()) {

                String linea = teclado.nextLine().trim();
                if (linea.isEmpty()) continue;

                envio.println(linea);                        // write al socket

                if (linea.equals("ADIOS")) break;

                // TODO: lee la respuesta del servidor y muestrala con
                //       un formato legible para el cajero.
                //       pista: respuesta.readLine() y split(";")
            }

        } catch (IOException e) {
            System.out.println("No se pudo conectar: " + e.getMessage());
        }

        System.out.println("Cajero desconectado");
    }
}
```

Fíjate en `s.getLocalPort()`: es el puerto efímero que el SO le asignó a **este** cajero. Si abres tres cajeros, cada uno tendrá uno distinto, y ahí está la razón de que los tres puedan hablar con el puerto 5000 al mismo tiempo.

#### Pruébalo

Tres terminales. En la primera, el servidor:

```bash
cd ~/so-proyecto/src
javac *.java
java ServidorPedidos --red 5000
```

En la segunda y la tercera, dos cajeros:

```bash
java ClienteCajero localhost 5000
```

Y en una cuarta, la observación:

```bash
ss -ltnp | grep 5000                          # el que escucha
ss -tnp  | grep 5000                          # las dos conexiones
ls -l /proc/$(pgrep -f ServidorPedidos)/fd | grep socket
```

Guarda la evidencia con los dos cajeros conectados y pedidos en curso:

```bash
cd ~/so-proyecto
{
  echo "=== ss -ltnp ==="; ss -ltnp | grep 5000
  echo "=== ss -tnp ===";  ss -tnp  | grep 5000
  echo "=== descriptores ==="; ls -l /proc/$(pgrep -f ServidorPedidos)/fd
} > evidencias/red.txt 2>&1
```

Y míralo con `strace`, que cierra el círculo de la semana 13:

```bash
strace -f -e trace=socket,bind,listen,accept,accept4,read,write,close \
  -o evidencias/strace_red.txt java -cp src ServidorPedidos --red 5000
```

Ahí están las cuatro llamadas del bloque 1, en orden, con sus descriptores.

**Lo que entregas de este bloque**

1. `src/ServidorPedidos.java` con el modo red y el `TODO` resuelto.
2. `src/ClienteCajero.java` con su `TODO` resuelto.
3. `evidencias/red.txt` con dos cajeros conectados.
4. `evidencias/strace_red.txt` con la secuencia de llamadas.

5. En `BITACORA.md`, bajo `### Antes de la clase`:
   - **Las líneas de `ss`** con los dos cajeros, y la explicación de qué es cada columna. Señala cuál es el socket que escucha y cuáles las conexiones.
   - **Los puertos locales de los dos cajeros**, y por qué son distintos aunque los dos hablen con el 5000.
   - **Las cuatro llamadas del `strace`**, pegadas en orden, con el descriptor que devolvió cada una.
   - **Qué pasa si quitas el `true` del `PrintWriter`.** Pruébalo y describe el síntoma exacto.

```bash
git add .
git commit -m "s16 bloque 2: servidor de red y cliente cajero"
git push
```

---

### Bloque extra: un cajero desde otra máquina {#bloque-extra}

Opcional, y es el que convierte el proyecto en algo demostrable. Hasta ahora todo fue `localhost`, que ni siquiera sale de tu computadora.

**El obstáculo, y es específico de WSL2.** Tu Ubuntu de WSL2 tiene una IP propia, distinta de la de tu Windows, en una red virtual interna. Un cajero de otra computadora que apunte a la IP de tu Windows **no llega solo** a tu servidor de WSL2.

Primero, las IPs:

```bash
hostname -I               # la IP de tu WSL2, tipo 172.x.x.x
ip route | grep default   # la puerta de enlace hacia Windows
```

Y desde **PowerShell en Windows**:

```powershell
ipconfig
```

La IP de tu adaptador wifi o ethernet (tipo `192.168.x.x`) es la que ven los demás.

Ahora hay que conectar las dos. En **PowerShell como administrador**:

```powershell
# Reenvia el puerto 5000 de Windows al 5000 de WSL2
netsh interface portproxy add v4tov4 listenport=5000 listenaddress=0.0.0.0 `
  connectport=5000 connectaddress=LA_IP_DE_TU_WSL2

# Abre el puerto en el firewall de Windows
New-NetFirewallRule -DisplayName "Servidor Pedidos SO" -Direction Inbound `
  -LocalPort 5000 -Protocol TCP -Action Allow

# Comprobar
netsh interface portproxy show all
```

Con eso, tu compañero desde su máquina:

```bash
java ClienteCajero 192.168.1.45 5000
```

Para limpiar cuando termines:

```powershell
netsh interface portproxy delete v4tov4 listenport=5000 listenaddress=0.0.0.0
Remove-NetFirewallRule -DisplayName "Servidor Pedidos SO"
```

Si no funciona, revisa en este orden, que es el orden en que falla de verdad:

| Síntoma | Causa probable | Comprobación |
|---|---|---|
| Ni siquiera llega el intento | Firewall de Windows | Desactívalo temporalmente para probar |
| Se conecta desde tu Windows pero no desde otra máquina | La red del aula aísla los equipos | Prueba con un celular compartiendo datos |
| `Connection refused` | El servidor escucha en `127.0.0.1` y no en `0.0.0.0` | `ss -ltnp` |
| La IP de WSL2 cambió | Cambia en cada reinicio | Vuelve a hacer el `portproxy` |

Ese último punto es real y molesto: **la IP de WSL2 cambia cada vez que reinicias**, así que el `portproxy` hay que rehacerlo. En un servidor de verdad esto no pasa, y saber por qué (la máquina tiene una IP fija o un DNS) es parte de lo que estás aprendiendo.

Anota en tu bitácora:

- Las tres IPs involucradas (WSL2, Windows, cliente) y qué papel juega cada una.
- La salida de `ss -tnp` con la conexión remota establecida: ahí la `Peer Address` ya no es `127.0.0.1`.
- **Cuántos cajeros remotos simultáneos aguantó** tu servidor y qué se rompió primero.

```bash
git add .
git commit -m "s16 extra: cajero remoto desde otra maquina"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Última sesión de contenido del semestre. Llegas con tu servidor escuchando en un puerto. Hoy conectamos el grupo entero.

#### 0. Rescate de atorones

Lo de siempre.

#### 1. La red del salón

La actividad de la semana. Se arman grupos de 4 o 5: **uno pone el servidor, los demás son cajeros de su tienda**.

El que hace de servidor abre el puerto (con el `portproxy` del bloque extra) y anuncia su IP. Los demás:

```bash
java ClienteCajero LA_IP_DEL_COMPANERO 5000
```

Cuatro cajeros reales, en cuatro computadoras, pidiendo del mismo inventario. **Esa es la escena del primer día del curso**, la que dibujamos en el pizarrón en la semana 1 sin saber cómo se hacía.

Mientras corre, el del servidor proyecta:

```bash
watch -n 1 'ss -tnp | grep 5000; echo; ls /proc/$(pgrep -f ServidorPedidos)/fd | wc -l'
```

Se ve la lista de conexiones crecer y encogerse conforme entran y salen cajeros. Después, roten: cada quien hace de servidor una vez.

#### 2. Romper el inventario, ahora en serio

Con cuatro cajeros de verdad, el ejercicio de la semana 5 se puede hacer bien. Pónganse de acuerdo: **a la cuenta de tres, los cuatro piden el último producto**.

Bajen la existencia de un producto a 1 en el catálogo y háganlo:

```
1;paracetamol;1
```

Los cuatro a la vez. Con el inventario protegido de la semana 6, **exactamente uno tiene que recibir ACEPTADO y tres RECHAZADO**. Compruébenlo en las cuatro pantallas.

Y después, la demostración que cierra la Unidad 2 con broche: **quiten el `synchronized`** del `vender`, recompilen, y repitan. Con cuatro cajeros humanos apretando Enter al mismo tiempo van a vender el producto más de una vez. Ahora sí con clientes de verdad, en máquinas de verdad.

Guarden las capturas: es la mejor evidencia de todo el semestre.

#### 3. Qué pasa cuando un cajero se cae

Prueba de robustez, que es lo que separa un ejercicio de un servidor.

Con varios cajeros conectados, uno **cierra la ventana de la terminal de golpe** (no `ADIOS`, no `Ctrl + C`: la X). Observen en el servidor:

- Qué mensaje sale.
- `ss -tnp`: cuánto tarda en desaparecer la conexión.
- `ls /proc/PID/fd | wc -l`: **se liberó el descriptor?**

Si el servidor no se dio cuenta, tiene un problema: esa conexión muerta ocupa un hilo y un descriptor para siempre. La solución en el pizarrón: un tiempo límite de lectura.

```java
cajero.setSoTimeout(30000);        // 30 s sin recibir nada -> excepcion
```

Impleméntenlo y repitan la prueba.

Y el caso opuesto: **maten el servidor** con cajeros conectados. Qué ven los cajeros? Un `readLine()` que devuelve `null`. Su cliente debería decir algo mejor que caerse con una excepción.

#### 4. Cuántos cajeros aguanta

La última medición del semestre. Un cliente que abre muchas conexiones:

```java
// CargaRed.java - N cajeros simultaneos
for (int i = 0; i < n; i++) {
    final int id = i;
    new Thread(() -> {
        try (Socket s = new Socket("localhost", 5000);
             PrintWriter out = new PrintWriter(s.getOutputStream(), true);
             BufferedReader in = new BufferedReader(
                     new InputStreamReader(s.getInputStream()))) {
            for (int j = 0; j < 20; j++) {
                out.println((id * 1000 + j) + ";paracetamol;1");
                in.readLine();
            }
            out.println("ADIOS");
        } catch (IOException e) { }
    }).start();
}
```

```bash
for n in 10 50 100 500 1000; do
  echo -n "n=$n  "
  java CargaRed $n
  ss -tan | grep -c ESTAB
done
```

| Cajeros | Conexiones establecidas | Descriptores del servidor | Hilos (`nlwp`) | Qué se rompió |
|---|---|---|---|---|
| 10 | | | | |
| 50 | | | | |
| 100 | | | | |
| 500 | | | | |
| 1000 | | | | |

Van a chocar con un límite, y va a ser uno de estos tres, **todos conocidos**:

- `Too many open files`: el `ulimit -n` de la semana 13.
- `unable to create native thread`: las pilas de hilos de la semana 11.
- `Connection refused`: la cola de `listen` llena, que es el buffer acotado de la semana 12 pero dentro del kernel.

Ese es el cierre del curso: **los tres límites que encuentras el último día son los tres recursos del sistema operativo que estudiaste durante el semestre**. Descriptores, memoria y colas. El servidor no se rompe por la red: se rompe porque el SO se queda sin algo que darle.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Deja tu servidor con los dos modos:** consola (como hasta ahora) y red (`--red PUERTO`). No borres el primero, que sirve para probar sin levantar nada.

2. **Deja `ClienteCajero` funcionando** y probado con al menos dos cajeros simultáneos, con la respuesta del servidor formateada de forma legible.

3. **Hazlo robusto.** Un cajero que se cae no puede afectar a los demás ni dejar descriptores colgados. Pon el `setSoTimeout` y comprueba que el número de descriptores vuelve a su valor de reposo.

4. **Documenta tu protocolo en el README**: qué manda el cajero, qué responde el servidor en cada caso, y cómo se cierra la conexión.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Qué es un socket para el sistema operativo y por qué es un descriptor.
   - La secuencia de llamadas de los dos lados, con lo que devuelve cada una.
   - Por qué `accept()` devuelve un descriptor nuevo.
   - Cuántos cajeros aguantó tu servidor y **cuál de los tres límites del SO fue el que lo detuvo**.

   ```bash
   git add .
   git commit -m "s16 proyecto: servidor de red con cajeros remotos"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Este es el último avance antes de la entrega final. El sistema tiene que quedar completo.

1. **Sustituyan las tuberías por sockets.** Las tres sucursales se conectan al Servidor Central por red, no por tubería. Con eso el sistema deja de necesitar que todo esté en la misma máquina, que era la limitación que marcaron la semana pasada.

2. **Móntenlo en más de una computadora.** Aunque sea el central en una y una sucursal en otra. Es lo que van a demostrar en la revisión final y es lo que hace que el proyecto se pueda enseñar en una entrevista de trabajo.

3. **Prueben los tres modos de falla** y déjenlos documentados con evidencia:
   - Se cae una sucursal: siguen las otras dos y el central?
   - Se cae el central: qué hacen las sucursales? Guardan los pedidos y reintentan, o rechazan?
   - Se satura una sucursal: afecta a las demás? (Es la contrapresión de la semana 12, ahora sobre la red.)

4. **Preparen la demo final** de la [semana 17](/curso/so/semana-17) y ensáyenla completa, con el montaje en varias máquinas. El montaje es lo que falla el día de la entrega, no el código.
