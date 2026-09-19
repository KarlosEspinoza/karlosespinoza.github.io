# Roadmap del taller "De la senal a la decision"

Documento interno de trabajo. Se actualiza marcando las casillas conforme se avanza.

* **Hoy:** viernes 18 de septiembre de 2026
* **Taller:** lunes 28 (3 h) y martes 29 (4 h) de septiembre de 2026
* **Dias habiles disponibles:** 10

**K** = lo hace Karlos. **C** = lo escribe Claude. **KC** = se trabaja en sesion.

---

## Calendario de un vistazo

| Dia | Fecha | Que tiene que estar listo |
|---|---|---|
| Vie / Sab | 18 y 19 sep | Guia previa y lista de compras escritas |
| Dom | 20 sep | Revision de Karlos a la guia |
| **Lun** | **21 sep** | **La guia sale al coordinador. Ruta critica** |
| Mar | 22 sep | Programa entregado al coordinador |
| Mie | 23 sep | Los 7 archivos de codigo, probados |
| Jue | 24 sep | `dia-01/index.md` y `dia-02/index.md` |
| Vie | 25 sep | USB armado. Revision de las 15 evidencias |
| Sab / Dom | 26 y 27 sep | Ensayo completo con hardware real |
| Lun | 28 sep | Sesion 1 |
| Mar | 29 sep | Sesion 2 |

---

## Fase 0: decisiones cerradas

No se vuelven a discutir. El detalle y el porque estan en `estrategia.md`.

- [x] Nombre y subtitulo
- [x] Ubicacion en el repositorio: `curso/senal/`
- [x] Hardware: cada participante aporta su kit
- [x] Sensores: LDR + TCRT5000 (se descarto el LM35)
- [x] Actuador: LED RGB (se descarto el servo)
- [x] Piezas: cartulina blanca, cartulina negra, papel aluminio
- [x] Modelo: arbol de decision
- [x] Git: cuenta creada antes, commit y push el dia 2
- [x] Reparto de las 7 horas
- [x] `estrategia.md` y `roadmap.md`

---

## Fase 1: la guia previa (RUTA CRITICA, sale el lunes 21)

Bloquea todo lo demas: sin ella no compran el kit ni instalan, y el dia 1 se va en
rescatar. Es lo unico que no se puede recorrer ni un dia.

- [x] **C** `requisitos/index.md`: la guia previa completa
  - [x] Lista de compras con precios aproximados y donde conseguirlo
  - [x] Python con "Add Python to PATH"
  - [x] Visual Studio Code
  - [x] Arduino IDE
  - [x] Driver CH340
  - [x] Git y creacion de la cuenta de GitHub
  - [x] Las 6 bibliotecas: pyserial, numpy, pandas, matplotlib, scikit-learn, joblib
  - [x] Como encontrar el puerto COM en el Administrador de dispositivos
  - [x] **Las 4 comprobaciones con evidencia** (ver abajo)
- [x] **C** `index.md`: portada del taller (que es, para quien, que se llevan)
- [ ] **K** Revisar la guia y la lista de compras
- [ ] **K** Enviarla al coordinador el **lunes 21 de septiembre** a mas tardar
- [ ] **K** Confirmar con el coordinador que el kit queda como requisito de inscripcion

### Las 4 comprobaciones, con fecha limite viernes 25 de septiembre

1. `python --version` y `code --version` responden **en el CMD** (cubre las dos casillas de PATH)
2. `python -c "import serial, numpy, pandas, matplotlib, sklearn, joblib; print('ok')"` imprime `ok`
3. El Blink corriendo en su Nano, con los `delay` cambiados a 200 (foto del Nano y del IDE
   en la misma toma). **Es la comprobacion de mayor valor: resuelve el CH340**, y el cambio
   del `delay` es lo que hace que la foto pruebe que lo subio el
4. `git --version` y su cuenta de GitHub creada

---

## Fase 2: el programa para el coordinador (martes 22)

Aunque solo pidio el titulo. Es el instrumento que consigue que el kit sea requisito y
que la guia se distribuya a tiempo.

- [x] **C** `programa/index.md`, siguiendo el formato de `curso/ia/programa/index.md`
  - [x] Informacion del taller (denominacion, dirigido a, duracion, cupo, fechas, aula)
  - [x] Justificacion, con el material que aporta el participante escrito sin ambiguedad
  - [x] Alineacion con el PE: AE2A y AE7A
  - [x] Objetivo general y objetivos especificos
  - [x] Requisitos previos del participante
  - [x] Contenido tematico por sesion, con horas
  - [x] Metodologia
  - [x] Material y equipo: participante / instructor / **requerimientos del aula**
  - [x] Acreditacion: asistencia mas repositorio con el bucle funcionando
  - [x] Instructor
- [x] **C** Enlazar `programa/` desde `index.md` (lo puso Karlos el 2026-09-19)
- [ ] **K** Entregar el programa y el titulo al coordinador
- [ ] **K** Confirmar aula con corriente para 15 laptops mas 15 Arduinos, y proyector

---

## Fase 3: el codigo (miercoles 23)

Siete archivos, escritos completos y **probados con hardware real** antes de repartirse.
Los nombres coinciden a proposito con los de IE043.

- [ ] **C** `recurso/codigo/sensor.ino` -- lee LDR y TCRT5000, imprime por serie
- [ ] **C** `recurso/codigo/leer_sensor.py` -- pyserial y grafica en vivo
- [ ] **C** `recurso/codigo/adquirir.py` -- captura ventanas etiquetadas a `datos.csv`
- [ ] **C** `recurso/codigo/features.py` -- media, minimo, maximo y desviacion a `features.csv`
- [ ] **C** `recurso/codigo/entrenar.py` -- arbol, accuracy, `export_text`, `modelo.pkl`
- [ ] **C** `recurso/codigo/control.py` -- bucle cerrado, predice y manda el color
- [ ] **C** `recurso/codigo/control.ino` -- recibe el comando y prende el LED RGB
- [ ] **K** Probar los 7 con el hardware real
- [ ] **C** Diagrama de conexiones del protoboard (LDR, TCRT5000, LED RGB)

---

## Fase 4: el material de las sesiones (jueves 24)

- [x] **C** `dia-01/index.md` -- del sensor a los datos
- [x] **C** `dia-02/index.md` -- de los datos a la decision
- [x] **C** Enlazar `dia-01/` y `dia-02/` desde los dos numerales de `index.md`
- [x] **C** `CLAUDE.md` del taller (puede ser corto y apuntar a `README.md`)
- [x] **C** Enlazar el taller desde `curso/index.md` y desde `index.md` de la raiz
- [x] **K** Decidir si se agrega al menu de `_config.yml` (si, 2026-09-19)

---

## Fase 5: el USB (viernes 25)

Contra el internet malo. Se copia a varias memorias, no a una.

El USB se arma en `~/curso/senal/usb/` (fuera de este repositorio, son ~900 MB).

- [x] **C** Instaladores completos de Windows: Python 3.14.7, VS Code 1.138.0,
      Git 2.55.0.5 y Arduino IDE 2.3.10 (mas el .zip portable del IDE)
- [x] **C** El nucleo de placas AVR y su toolchain, que el instalador del IDE **no**
      incluye. Sin esto, una maquina recien instalada no puede subir nada al Nano sin
      internet. Va en `instaladores/arduino-nucleo-avr/` con su `package_index.json`
- [ ] **K** Driver CH340. A proposito no se bajo de un espejo: es un driver y se baja
      del fabricante, <https://www.wch-ic.com/downloads/CH341SER_EXE.html>
- [x] **C** `pip download` de las 6 bibliotecas para Windows, en dos juegos:
      `bibliotecas/py314/` y `bibliotecas/py313/`. Probado con
      `pip install --no-index --find-links`: resuelve los 19 paquetes sin red
- [x] **C** Los 7 archivos de codigo, en `codigo/`. Se regeneran de las paginas
      publicadas con `usb/regenerar-codigo.sh` (las paginas son la fuente de verdad)
- [ ] **K** Checkpoints de respaldo: `datos.csv`, `features.csv`, `modelo.pkl`.
      **Salen del ensayo con hardware real (fase 7), no se inventan**: si no se parecen
      a lo que ve el grupo, el respaldo estorba
- [x] **C** `LEEME.txt` con las instrucciones de instalacion sin red
- [ ] **K** Probar una vez el rescate del nucleo AVR sin red, en Windows limpio
- [ ] **K** Copiar a 3 o 4 memorias

---

## Fase 6: verificacion y rescate (viernes 25)

- [ ] **K** Revisar las 15 evidencias recibidas
- [ ] **K** Lista de quien esta listo y quien no
- [ ] **K** Rescate individual por correo de los que fallaron
- [ ] **K** Confirmar quien no consiguio el kit, para armar parejas el lunes

---

## Fase 7: el ensayo (sabado 26 o domingo 27)

No se salta. Es la unica prueba real de que las 7 horas cierran.

- [ ] **K** Recorrer el flujo completo con el hardware, de punta a punta
- [ ] **K** Cronometrar cada bloque contra el reparto de `estrategia.md`
- [ ] **K** Verificar que los checkpoints de respaldo funcionan como entrada de la etapa siguiente
- [ ] **KC** Ajustar tiempos y material segun lo que salga del ensayo

---

## Fase 8: durante el taller

- [ ] Lunes 28: sesion 1. Terminar con `datos.csv` en las 15 maquinas
- [ ] Martes 29: sesion 2. Terminar con el bucle cerrado funcionando
- [ ] **K** Lista de asistencia y de repositorios entregados

---

## Fase 9: despues

- [ ] **K** Constancias, si el coordinador las pide
- [ ] **KC** Notas de lo que fallo, al final de `estrategia.md`
- [ ] **K** Guardar la lista de participantes: son el grupo que entra a IE043
- [ ] **KC** Revisar si `curso/ia/requisitos/index.md` y la semana 01 se pueden aligerar
      para este grupo, que ya llegara con el entorno y el kit

---

## Bitacora de decisiones posteriores

Los cambios que se acuerden despues del 2026-09-18 se anotan aqui con fecha, y el porque
se pasa a `estrategia.md`.

* **2026-09-19.** La terminal del taller es el **CMD**, no la terminal integrada de Visual
  Studio Code. VS Code queda como editor y se abre con `code <archivo>`; nadie instala la
  extension de Python. Consecuencias: la guia previa se organiza alrededor del PATH y lleva
  tres figuras (instalador de Python, de VS Code y de Git), la comprobacion 1 ahora incluye
  `code --version`, y `dia-01` y `dia-02` se escriben con el CMD. El porque, en
  `estrategia.md`, seccion 5.

* **2026-09-19.** El nombre **publicado** del taller lleva acentos: "De la señal a la
  decisión" con enye y tilde, en el titulo de las paginas, la portada, el menu de
  `_config.yml`, `curso/index.md` y el `index.md` de la raiz. En el menu y en los dos
  indices aparece con el sufijo "(taller)", para que se distinga de las materias. Sin
  acentos quedan solo el directorio `senal/` y los documentos internos. Va tambien en el
  cartel, el oficio, el programa y la constancia.

* **2026-09-19.** El modelo se guarda con **joblib**, no con `pickle`, igual que en IE043
  (`semana-07` lo escribe con `joblib.dump`; las semanas 08, 13, 15 y 16 lo leen con
  `joblib.load`). No cuesta una instalacion extra: `joblib` es dependencia obligatoria de
  scikit-learn, asi que ya venia con el. Se agrego explicito a la linea de `pip install` y
  a la comprobacion 2 para que nadie se pregunte de donde salio. El archivo se sigue
  llamando `modelo.pkl`.

* **2026-09-19.** Se confirmo que **si se puede instalar todo sin internet**, con una
  excepcion que casi se nos va: el instalador del Arduino IDE 2.3.10 no trae el nucleo de
  placas AVR (se reviso el paquete completo: 7650 archivos, sin `avrdude` ni `boards.txt`),
  asi que lo baja la primera vez que se abre. Se agrego al USB el nucleo, su toolchain y
  el `package_index.json`, con el procedimiento de la carpeta `staging`. Los demas
  instaladores si son completos, y las ruedas de Python instalan con `--no-index`
  (probado). La leyenda "no se requiere conexion a internet en el aula" del programa se
  queda. Las ruedas dependen de la version exacta de Python, por eso hay dos juegos.

<!-- 2026-09-XX: ... -->
