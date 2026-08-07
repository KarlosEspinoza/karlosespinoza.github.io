---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Configuración del entorno

Lo que necesitas tener listo para trabajar en el curso: primero el software, que se instala en la semana 1, y después el hardware, que empiezas a usar en la semana 2.

Todo el curso se trabaja en **Windows**.

---

- [Software](#software)
    - [Python](#python)
    - [Visual Studio Code](#vscode)
    - [Git](#git)
    - [Arduino IDE y el driver CH340](#arduino-ide)
    - [Las bibliotecas del curso](#bibliotecas)
    - [Verifica que todo quedó bien](#verificacion)
- [Hardware](#hardware)
    - [Lo básico, para todos](#lo-basico)
    - [El sensor, según tu dominio](#el-sensor)
    - [Actuadores](#actuadores)
    - [Lo que no necesitas](#lo-que-no-necesitas)
- [El hardware del laboratorio](#laboratorio)

---

## Software {#software}

### Python {#python}

Instálalo desde [python.org](https://www.python.org/downloads/) y **marca la casilla "Add Python to PATH"** durante la instalación. Esa casilla es la causa de la mayoría de los problemas de la primera semana: si no la marcas, Windows no encuentra Python desde la terminal y hay que reinstalar.

Si al escribir `python` se te abre la Microsoft Store en vez de responder, es un acceso directo falso que trae Windows. Se quita en Configuración, Aplicaciones, Configuración avanzada de la aplicación, Alias de ejecución de la aplicación: desactiva `python.exe` y `python3.exe`.

### Visual Studio Code {#vscode}

Es el editor del curso. Instala también la **extensión de Python** desde el panel de extensiones.

Los comandos que aparecen en las guías van escritos para su terminal integrada, que abres con `Ctrl + ñ`.

### Git {#git}

Instálalo desde [git-scm.com](https://git-scm.com/) y configúralo con tu identidad:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tucorreo@ejemplo.com"
```

Necesitas también una **cuenta en GitHub**. Ahí vive tu proyecto todo el semestre y es la única vía de entrega del curso.

### Arduino IDE y el driver CH340 {#arduino-ide}

Instala el **Arduino IDE** desde [arduino.cc](https://www.arduino.cc/en/software).

Y después instala el **driver CH340**, que es igual de importante y casi nadie lo sabe: los Arduino Nano que usamos llevan un chip USB CH340 y **Windows no trae su driver**. Sin él la tarjeta no aparece por ningún lado, aunque el cable esté bien y el LED encienda. Búscalo como "driver CH340 Windows", instálalo y reinicia.

Para comprobar que quedó: conecta el Arduino, abre el **Administrador de dispositivos** (clic derecho en el botón de Inicio) y busca la sección **Puertos (COM y LPT)**. Debe aparecer algo como `USB-SERIAL CH340 (COM3)`. **Anota ese número de puerto**, lo vas a usar todas las semanas.

Si no hay sección de Puertos, o aparece un dispositivo con un triángulo amarillo, falta el driver.

### Las bibliotecas del curso {#bibliotecas}

Desde la terminal de Visual Studio Code:

```bash
python -m pip install -U numpy pandas matplotlib scikit-learn pyserial joblib
```

| Biblioteca | Para qué la usamos |
|---|---|
| `numpy` | Operaciones sobre las señales |
| `pandas` | Leer y escribir los CSV del dataset |
| `matplotlib` | Todas las gráficas |
| `scikit-learn` | Modelos, escaladores y métricas |
| `pyserial` | Hablar con el Arduino por el puerto serie |
| `joblib` | Guardar y cargar los modelos entrenados |

En la semana 16 se agrega una más, `python-snap7`, para hablarle al PLC de la maqueta. Esa no hace falta instalarla ahora.

### Verifica que todo quedó bien {#verificacion}

```bash
python --version
code --version
git --version
python -c "import numpy, pandas, matplotlib, sklearn, serial, joblib; print('entorno listo')"
```

Si las cuatro responden, ya tienes el entorno del semestre.

---

## Hardware {#hardware}

### Lo básico, para todos {#lo-basico}

| Componente | Cantidad | Notas |
|---|---|---|
| **Arduino Nano** (o UNO compatible) | 1 | Con su cable USB |
| **Protoboard** | 1 | De media o de tamaño completo |
| **Jumpers Dupont** (M-M y M-F) | 20 a 40 | Los M-F son para los módulos de sensores |
| **Resistencias** de 220 ohm y 330 ohm | 5 a 10 | Para los LED |
| **Resistencia** de 10k ohm | 2 | Divisor de voltaje del LDR y pull-ups |

Todo se monta en **protoboard**. En este curso no se suelda nada.

### El sensor, según tu dominio {#el-sensor}

En la semana 1 eliges **qué va a clasificar tu sistema**, y de esa decisión depende qué sensor necesitas. **No compres sensores antes de tener tu dominio registrado**, o vas a terminar con el equivocado.

| Sensor | Qué mide | Tipo de salida | Sirve para clasificar por |
|---|---|---|---|
| **LDR** + resistencia 10k | Luz reflejada | Analógica | Color, material, acabado |
| **GP2Y0A21YK0F** | Distancia (infrarrojo) | Analógica | Tamaño, altura, presencia |
| **HC-SR04** | Distancia (ultrasonido) | Por pulso | Tamaño, altura, nivel |
| **LM35** | Temperatura | Analógica | Estado térmico |
| **A3144** | Campo magnético | Digital | Material (metal contra no metal) |
| **HW-870** | Interrupción de un haz óptico (ranura) | Digital | Conteo, presencia, velocidad de giro |

Dos consejos que te van a ahorrar semanas:

**Empieza con un sensor analógico.** El A3144 y el HW-870 son digitales: solo dan 0 o 1, así que su señal es un escalón y no una forma. Sirven muy bien acompañando a otro sensor, pero solos te van a dar poca información para separar tres tipos de pieza.

El **HW-870** merece una nota aparte: es un optoacoplador de ranura, así que detecta cuando algo interrumpe el haz entre sus dos brazos. Es excelente para **contar** y para medir **velocidad de giro** (poniendo un disco ranurado en un eje), pero no distingue de qué está hecha la pieza ni qué tamaño tiene. Piénsalo como el sensor que te dice *cuándo* pasó algo, no *qué* pasó.

**Es muy probable que acabes necesitando dos.** Casi nunca se separan tres clases con un solo sensor, y en la semana 5 lo vas a ver en tus propias gráficas. Si puedes, ten un segundo sensor a la mano desde el principio.

### Actuadores {#actuadores}

Tu sistema tiene que **mover algo** cuando el modelo decide: eso es lo que lo hace mecatrónico y no ciencia de datos. Con uno basta para empezar.

| Actuador | Para qué sirve en tu sistema |
|---|---|
| **Servo SG90** | Desviar la pieza a una posición por clase. El más usado. |
| **LED RGB** | Marcar cada clase con un color. El más barato y simple. |
| **LED** (5 mm) | Uno por clase, o uno rojo para el rechazo de anomalías |
| **Buzzer** 5V | Alarma al detectar una pieza anómala |
| **Relé** | Encender o detener un motor de mayor potencia |
| **Motor CD** | Mover una banda o un mecanismo propio |

> **Un apunte sobre el servo:** el SG90 mete ruido eléctrico y te lo vas a encontrar en la señal del sensor. Si te pasa, un capacitor de 100 a 470 uF entre 5V y GND, cerca del servo, ayuda bastante. No es obligatorio, pero en el laboratorio se nota.

### Lo que no necesitas {#lo-que-no-necesitas}

Para que no gastes de más, esto **no** hace falta en este curso:

- **Raspberry Pi ni ESP32.** La fase de producción corre sobre el PLC Siemens del laboratorio, no sobre otra tarjeta.
- **Herramientas de soldadura ni placa perforada.** Todo el prototipo va en protoboard.
- **Sensores industriales** (capacitivos, inductivos). Los de la maqueta ya están montados y son del laboratorio.
- **Una computadora potente.** Los modelos de este curso entrenan en segundos en cualquier laptop. No necesitas tarjeta gráfica.

---

## El hardware del laboratorio {#laboratorio}

Además de tu equipo, el curso usa hardware que **no tienes que conseguir tú**, y que se trabaja en el laboratorio a partir de la Unidad 4:

- **Maquetas** con banda transportadora, pistones y sensores capacitivos e inductivos.
- **PLC Siemens S7-1214C**, que gobierna la banda y el pistón.
- **PC de control** conectada por Ethernet directo al PLC.

En la semana 15 vamos al laboratorio, les explico cómo se usa la maqueta, y a partir de ahí cada quien agenda su turno para capturar sus datos definitivos sobre la banda real.
