---
layout: default
title: De la señal a la decisión
---
[Inicio](/curso/senal)

# Antes del taller

El taller es el **lunes 28 y el martes 29 de septiembre**, y son solo 7 horas. En esas 7 horas no hay tiempo de instalar nada: el lunes arrancamos con todo el mundo corriendo código.

Por eso esta página. Te pide dos cosas, y las dos tienen fecha:

1. **Comprar tu kit.** Es tuyo y lo traes contigo. El laboratorio no presta material.
2. **Instalar el software y mandarme la evidencia**, a más tardar el **viernes 25 de septiembre**.

Todo se trabaja en **Windows**.

> **El kit tiene que estar en tus manos antes del viernes 25, no el lunes 28.** Una de las cuatro comprobaciones se hace con el Arduino conectado a tu computadora, así que si el paquete llega el fin de semana ya es tarde.

---

- [Lista de compras](#compras)
    - [El kit](#kit)
    - [Las tres piezas](#piezas)
    - [Cuánto vas a gastar y dónde conseguirlo](#gasto)
- [Instala el software](#software)
    - [Python](#python)
    - [Visual Studio Code](#vscode)
    - [Git y tu cuenta de GitHub](#git)
    - [Arduino IDE y el driver CH340](#arduino)
    - [Tu puerto COM](#puerto-com)
- [El CMD, que es donde vas a trabajar](#cmd)
    - [Ábrelo en la carpeta donde estás trabajando](#abrir-cmd)
    - [Los tres comandos que tienen que responder](#tres-comandos)
    - [Así se trabaja: editar y ejecutar](#editar-ejecutar)
    - [Si alguno no responde: el PATH](#path)
- [Las bibliotecas de Python](#bibliotecas)
- [Las cuatro comprobaciones](#comprobaciones)
    - [Cómo me mandas la evidencia](#evidencia)
- [Si algo no funciona](#problemas)
- [Qué llevas el lunes](#que-llevar)

---

## Lista de compras {#compras}

### El kit {#kit}

Es el mismo para los 15. Nada de esto se suelda: todo se monta en protoboard.

| Componente | Cantidad | Notas | Aprox. |
|---|---|---|---|
| **Arduino Nano** (o UNO compatible) | 1 | **Con su cable USB.** Revisa que venga incluido | 150 a 250 |
| **Protoboard** | 1 | De media o de tamaño completo | 60 a 100 |
| **Jumpers Dupont** M-M y M-F | 20 a 40 | Los M-F son para el módulo del sensor | 50 a 80 |
| **TCRT5000** (módulo) | 1 | Sensor óptico de reflexión. El principal del taller | 20 a 40 |
| **LDR** (fotorresistencia) | 1 | El segundo sensor, el que sí depende de la luz del cuarto | 10 a 20 |
| **LED RGB** de 5 mm, cátodo común | 1 | Cuatro patas. Es el que muestra la decisión del modelo | 10 a 25 |
| **Resistencias** de 220 ohm | 3 | Una por color del LED RGB | 5 a 20 |
| **Resistencia** de 10k ohm | 1 | El divisor de voltaje del LDR | la bolsa |

Dos avisos sobre el cable, que es donde más gente se atora:

- **El cable del Nano casi siempre es mini USB, no micro USB.** No es el de tu celular. Si tu Nano viene sin cable, cómpralo junto con la tarjeta y compara los conectores ahí mismo.
- **Que no sea un cable de solo carga.** Los cables baratos que vienen con las power banks muchas veces no llevan los hilos de datos, y con uno de esos la computadora nunca ve el Arduino. Si el tuyo no funciona, prueba con otro antes de pensar que la tarjeta está mal.

Si el TCRT5000 lo consigues como componente suelto en vez de módulo, dímelo antes de comprarlo: el módulo ya trae sus resistencias y el suelto no.

### Las tres piezas {#piezas}

Son las que va a aprender a distinguir tu sistema. Iguales para todos:

- **Cartulina blanca**
- **Cartulina negra**
- **Papel aluminio**

Trae **3 trozos de cada material, de unos 5 por 5 centímetros**. Cuestan casi nada y seguramente ya tienes dos de los tres en tu casa.

**Pega el aluminio sobre un pedazo de cartón o de cartulina**, con pegamento en barra y bien estirado. Una arruga cambia cómo rebota la luz, y si tus tres trozos de aluminio están arrugados de forma distinta, el modelo del martes los va a ver como tres cosas diferentes. Plano y parejo.

### Cuánto vas a gastar y dónde conseguirlo {#gasto}

| | Aproximado |
|---|---|
| El kit completo | 300 a 500 pesos |
| Las tres piezas | 20 a 40 pesos |
| **Total** | **alrededor de 350 a 550 pesos** |

Los precios varían mucho entre proveedores, así que compara. Todo lo del kit lo vas a volver a usar el siguiente ciclo en el curso de Inteligencia Artificial: no es un gasto para dos días.

**Cómpralo en tienda física si puedes.** Si lo vas a pedir por internet, **pídelo a más tardar el lunes 21 de septiembre**, y considera ponerte de acuerdo con tus compañeros para hacer un solo pedido: sale más barato el envío y llega todo junto.

---

## Instala el software {#software}

Son cuatro instalaciones: Python, Visual Studio Code, Git y el Arduino IDE.

En tres de ellas hay **una sola casilla que de verdad importa**, y es siempre la misma idea: que el programa quede agregado al **PATH**. El PATH es la lista de carpetas donde Windows busca los programas cuando escribes su nombre en una terminal. Si el programa no está en esa lista, existe en tu computadora pero la terminal no lo encuentra, y vas a ver el clásico `no se reconoce como un comando`.

Marca esas casillas y el resto de la guía sale solo. No las marques y vas a pelearte con tu computadora toda la semana.

### Python {#python}

Instálalo desde [python.org](https://www.python.org/downloads/). En la primera pantalla del instalador, **antes de darle a Install Now**, marca abajo la casilla **"Add python.exe to PATH"**:

![Primera pantalla del instalador de Python, con la casilla Add python.exe to PATH hasta abajo](/image/instalacion_python.jpg)

En la imagen la casilla aparece **sin marcar**: esa es exactamente la que tienes que marcar tú. Es la causa de la mayoría de los problemas de la primera semana; si se te pasa, hay que volver a correr el instalador.

Si al escribir `python` en la terminal se te abre la Microsoft Store en vez de responder, es un acceso directo falso que trae Windows. Se quita en Configuración, Aplicaciones, Configuración avanzada de la aplicación, Alias de ejecución de la aplicación: desactiva `python.exe` y `python3.exe`.

### Visual Studio Code {#vscode}

Descárgalo de [code.visualstudio.com](https://code.visualstudio.com/download). En la pantalla **"Select Additional Tasks"**, deja marcada la casilla **"Add to PATH (requires shell restart)"**:

![Pantalla Select Additional Tasks del instalador de Visual Studio Code, con la casilla Add to PATH marcada](/image/vscode_installer.jpg)

Esa casilla viene marcada por defecto, así que basta con no desmarcarla. Es la que hace que el comando `code` funcione, y con ese comando vas a abrir todos los archivos del taller.

**En el taller, Visual Studio Code es nada más el editor**: sirve para ver el código y cambiarle un número. No le instales ninguna extensión, no uses su terminal integrada y no uses sus botones de ejecutar. **Todo lo que se ejecuta se ejecuta desde el CMD**, que es la siguiente sección.

### Git y tu cuenta de GitHub {#git}

Instala Git desde [git-scm.com](https://git-scm.com/). Son muchas pantallas y **se dejan todas como vienen**. La única que vale la pena mirar es **"Adjusting your PATH environment"**, donde tiene que quedar seleccionada la opción de en medio:

![Pantalla Adjusting your PATH environment del instalador de Git, con la segunda opcion seleccionada](/image/senal/git_path.svg)

Es la que trae seleccionada por defecto y dice **"Git from the command line and also from 3rd-party software"**. Esa es la que deja funcionando `git` desde el CMD. La primera opción, "Use Git from Git Bash only", es justo la que no queremos.

**El instalador agrega un programa llamado Git Bash. En el taller no se usa.** Es una terminal aparte, con sus propias reglas, y mezclarla con el CMD es la forma más rápida de acabar sin saber dónde estás parado. Si se te abrió al terminar de instalar, ciérralo.

Crea también tu **cuenta en GitHub** si no tienes una, en [github.com](https://github.com/). Ahí publicas tu proyecto el martes. **Anota tu nombre de usuario**, me lo mandas con la evidencia.

### Arduino IDE y el driver CH340 {#arduino}

Instala el **Arduino IDE** desde [arduino.cc](https://www.arduino.cc/en/software).

Y después instala el **driver CH340**, que es igual de importante y casi nadie lo sabe: los Arduino Nano que usamos llevan un chip USB CH340 y **Windows no trae su driver**. Sin él la tarjeta no aparece por ningún lado, aunque el cable esté bien y el LED de la tarjeta encienda. Búscalo como "driver CH340 Windows", instálalo y **reinicia la computadora**.

### Tu puerto COM {#puerto-com}

Con el Arduino conectado, abre el **Administrador de dispositivos** (clic derecho en el botón de Inicio) y busca la sección **Puertos (COM y LPT)**. Debe aparecer algo como `USB-SERIAL CH340 (COM3)`.

**Anota ese número.** Lo vas a escribir en el código los dos días del taller.

Si no hay sección de Puertos, o aparece un dispositivo con un triángulo amarillo, falta el driver. Si no aparece nada de nada, sospecha del cable antes que de la tarjeta.

> Un detalle que te va a morder el lunes si no lo sabes desde ahora: **el puerto lo usa un programa a la vez.** Si dejas abierto el Monitor Serie del Arduino IDE, Python no va a poder leer el sensor, y el error no dice "cierra el Monitor Serie", dice "acceso denegado".

---

## El CMD, que es donde vas a trabajar {#cmd}

El **CMD** (también le dicen Símbolo del sistema) es la terminal de Windows, y es la **única** que usamos en el taller. Ahí corres `python`, `pip`, `code` y `git`. No vamos a usar la terminal de Visual Studio Code, ni Git Bash, ni PowerShell: con los 15 trabajando en la misma terminal, cuando algo falla lo resolvemos en un minuto en vez de en diez.

### Ábrelo en la carpeta donde estás trabajando {#abrir-cmd}

Este truco te va a ahorrar mucho tiempo los dos días. En el **Explorador de archivos**, entra a la carpeta donde tienes tus archivos, haz clic en la **barra de direcciones**, escribe `cmd` y presiona Enter:

![Tres pasos: la barra de direcciones del explorador, la palabra cmd escrita en ella, y el CMD abierto en esa misma carpeta](/image/senal/cmd_explorador.svg)

1. Clic en la barra de direcciones, donde dice el nombre de la carpeta. Se selecciona toda la ruta.
2. Escribe `cmd` encima y presiona Enter.
3. Se abre el CMD **ya parado en esa carpeta**, como se ve en el texto antes del `>`.

Eso es lo importante: el CMD siempre está "parado" en alguna carpeta, y solo ve los archivos de esa carpeta. Si lo abres desde el menú de Inicio vas a caer en `C:\Users\tu-usuario` y tendrías que navegar a mano con el comando `cd`. Con el truco de la barra de direcciones te ahorras eso.

### Los tres comandos que tienen que responder {#tres-comandos}

Crea una carpeta llamada `taller` en el Escritorio, ábrele el CMD ahí con el truco de arriba y escribe estos tres comandos, uno por uno:

```
python --version
code --version
git --version
```

| Comando | Qué debe contestar |
|---|---|
| `python --version` | Algo que empieza con `Python 3.` |
| `code --version` | Un número de versión, y abajo dos líneas más de letras y números |
| `git --version` | Algo como `git version 2.47.1.windows.1` |

**Si alguno contesta `no se reconoce como un comando interno o externo`, no está en el PATH.** Ve a [la sección del PATH](#path) más abajo.

> **Antes de dar nada por roto: cierra el CMD y ábrelo otra vez.** El CMD lee el PATH una sola vez, cuando arranca. Si instalaste un programa con la ventana del CMD ya abierta, esa ventana no se entera. Es la explicación de la mitad de los `no se reconoce`.

### Así se trabaja: editar y ejecutar {#editar-ejecutar}

Este es el ciclo completo del taller, y no hay más. Pruébalo ahora, en la carpeta `taller` que acabas de crear, con el CMD abierto ahí:

```
code prueba.py
```

Se abre Visual Studio Code con un archivo vacío llamado `prueba.py`. Escribe adentro esta línea:

```python
print("hola")
```

Guarda con `Ctrl + S` (el archivo se crea al guardar) y **regresa a la ventana del CMD**, sin cerrar Visual Studio Code. Ahí escribe:

```
python prueba.py
```

Tiene que contestar `hola`. Se ve así:

```
C:\Users\karlos\Desktop\taller>python prueba.py
hola

C:\Users\karlos\Desktop\taller>
```

Si llegaste hasta aquí, tu computadora ya está lista para el taller: `code` para abrir y editar, `python` para ejecutar, las dos ventanas abiertas al mismo tiempo. Los dos días vas a hacer exactamente esto, con archivos que yo te doy.

### Si alguno no responde: el PATH {#path}

La forma más rápida y segura de arreglarlo es **volver a correr el instalador** del programa que falla y esta vez marcar la casilla. No pierdes nada de lo que ya tenías instalado:

| Programa | Qué haces |
|---|---|
| **Python** | Vuelve a correr el instalador, elige **Modify**, dale Next y marca **"Add Python to environment variables"** |
| **Visual Studio Code** | Vuelve a correr el mismo instalador que descargaste y en **"Select Additional Tasks"** marca **"Add to PATH"** |
| **Git** | Vuelve a correr el instalador y en **"Adjusting your PATH environment"** elige la opción de en medio |

Si prefieres agregarlo a mano, para los tres es el mismo procedimiento: menú de Inicio, escribe `variables de entorno`, abre **"Editar las variables de entorno de esta cuenta"**, selecciona la variable **Path**, botón **Editar**, botón **Nuevo**, pega la carpeta, Aceptar en todo.

| Programa | Carpeta que se agrega |
|---|---|
| Python | `C:\Users\<tu usuario>\AppData\Local\Programs\Python\Python313` y también la subcarpeta `Scripts` (el número cambia según la versión que hayas instalado) |
| Visual Studio Code | `C:\Users\<tu usuario>\AppData\Local\Programs\Microsoft VS Code\bin` |
| Git | `C:\Program Files\Git\cmd` |

Y al terminar, **cierra el CMD y ábrelo otra vez**, si no, sigue viendo el PATH viejo.

---

## Las bibliotecas de Python {#bibliotecas}

Con el CMD abierto, en una sola línea:

```
python -m pip install -U pyserial numpy pandas matplotlib scikit-learn joblib
```

| Biblioteca | Para qué la usamos |
|---|---|
| `pyserial` | Hablar con el Arduino por el puerto serie |
| `numpy` | Operaciones sobre la señal del sensor |
| `pandas` | Leer y escribir los CSV con los datos |
| `matplotlib` | Todas las gráficas |
| `scikit-learn` | Entrenar el modelo que toma la decisión |
| `joblib` | Guardar el modelo entrenado y volver a cargarlo |

Tarda unos minutos y descarga bastante. **Hazlo con una conexión buena, en tu casa.** En el aula no cuentes con internet.

Se escribe `python -m pip` y no solo `pip` a propósito: así se instala en el mismo Python que vas a ejecutar después, aunque tengas más de uno instalado.

---

## Las cuatro comprobaciones {#comprobaciones}

Instalar no es lo mismo que que funcione. Estas cuatro comprobaciones son la diferencia, y son lo que me mandas **a más tardar el viernes 25 de septiembre**. Todas se hacen en el **CMD**.

**1. Python y Visual Studio Code responden.**

```
python --version
code --version
```

El primero contesta algo que empieza con `Python 3.` y el segundo un número de versión.

*Evidencia:* captura de pantalla de la ventana del CMD con los dos comandos y sus respuestas.

**2. Las bibliotecas cargan.** En el mismo CMD:

```
python -c "import serial, numpy, pandas, matplotlib, sklearn, joblib; print('ok')"
```

Tiene que imprimir `ok` y nada más. Si imprime un `ModuleNotFoundError`, esa biblioteca no quedó instalada.

*Evidencia:* captura de pantalla del CMD con el comando y el `ok`.

**3. El Blink corriendo en tu Nano.** Esta es la importante de las cuatro: si el LED parpadea, ya quedó resuelto el CH340, el cable y el puerto, que es casi todo lo que puede salir mal.

1. Conecta el Nano con su cable.
2. Abre el Arduino IDE y carga el ejemplo: menú Archivo, Ejemplos, 01.Basics, Blink.
3. Menú Herramientas, Placa, Arduino AVR Boards, **Arduino Nano**.
4. Menú Herramientas, Procesador, **ATmega328P (Old Bootloader)**. Casi todos los Nano que se venden por aquí son clones y necesitan esta opción; si falla, regresa y prueba con `ATmega328P` a secas.
5. Menú Herramientas, Puerto, el COM que anotaste.
6. **Cambia los dos `delay(1000)` por `delay(200)`**, para que parpadee rápido.
7. Botón Subir (la flecha). Espera el mensaje **Subido**.

*Evidencia:* una foto donde se vea, en la misma toma, **tu Nano conectado con el LED encendido** y **la pantalla del Arduino IDE** con el `delay(200)` y el mensaje Subido.

**4. Git y tu cuenta de GitHub.** En el CMD:

```
git --version
```

*Evidencia:* captura de pantalla con la respuesta, y **tu nombre de usuario de GitHub** escrito en el correo.

### Cómo me mandas la evidencia {#evidencia}

Un solo correo a **karlos.espinoza@academicos.udg.mx**, antes del **viernes 25 de septiembre**:

- **Asunto:** `Taller senal - Tu Nombre Completo`
- **Adjuntos:** las 3 capturas y la foto.
- **En el cuerpo:** tu nombre de usuario de GitHub y el número de tu puerto COM.

No es un trámite: con esos correos sé quién llega listo el lunes y a quién tengo que ayudar antes. Si no me llega el tuyo, doy por hecho que algo se atoró y te busco.

---

## Si algo no funciona {#problemas}

| Lo que ves | Qué es | Qué haces |
|---|---|---|
| `'python' no se reconoce como un comando` | Faltó la casilla "Add python.exe to PATH" | Cierra y abre el CMD. Si sigue, arréglalo como dice [la sección del PATH](#path) |
| `'code' no se reconoce como un comando` | Faltó "Add to PATH" en Visual Studio Code | Lo mismo de arriba |
| `'git' no se reconoce como un comando` | Quedó la opción "Use Git from Git Bash only" | Lo mismo de arriba |
| Se abre la Microsoft Store al escribir `python` | El alias falso de Windows | Configuración, Aplicaciones, Configuración avanzada de la aplicación, Alias de ejecución: desactiva `python.exe` y `python3.exe` |
| `'pip' no se reconoce` | Lo mismo del PATH | Usa siempre `python -m pip` en vez de `pip` |
| `ModuleNotFoundError: No module named 'serial'` | Instalaste `serial` en vez de `pyserial`, o no se instaló | `python -m pip install -U pyserial` |
| No aparece ningún COM en el Administrador de dispositivos | Falta el driver CH340, o el cable es de solo carga | Instala el driver y reinicia. Si sigue igual, prueba otro cable |
| `avrdude: stk500_recv(): programmer is not responding` al subir | Bootloader equivocado | Herramientas, Procesador, cambia entre `ATmega328P (Old Bootloader)` y `ATmega328P` |
| `Access is denied` o "el puerto está ocupado" | Otro programa tiene el puerto | Cierra el Monitor Serie del Arduino IDE |

**Escríbeme antes del viernes**, con el **texto exacto del error** y una captura. Un problema de instalación se resuelve por correo en diez minutos; el lunes en el aula cuesta media clase.

Llevo una memoria USB con los instaladores y las bibliotecas, por si el internet del aula falla, pero **es una red de seguridad, no el plan**. El lunes no hay tiempo de instalar desde cero.

---

## Qué llevas el lunes {#que-llevar}

- Tu **computadora y su cargador**.
- El **kit completo**, en una bolsita: Nano, cable, protoboard, jumpers, TCRT5000, LDR, LED RGB y resistencias.
- Las **tres piezas**, 3 trozos de cada material.
- El número de tu **puerto COM**, anotado.
- Tu **usuario de GitHub**.

Si no conseguiste el kit, ven de todas formas y dímelo el lunes temprano: trabajas en pareja. Lo que no tiene remedio es llegar sin el software instalado.
