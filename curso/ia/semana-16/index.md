---
layout: default
title: Inteligencia Artificial
---
[Inicio](/curso/ia)

# Semana 16 - Sobreajuste y preparación para producción (U4)

La semana pasada corriste tu modelo sobre los datos de la banda real y, con mucha probabilidad, la exactitud se desplomó. En tu escritorio acertaba el 88% y en la maqueta anda por el 50%.

Eso no es un fallo de tu trabajo. Es **el problema central del aprendizaje de máquina aplicado**, el que hace que muchísimos modelos que funcionan de maravilla en el laboratorio no lleguen nunca a producción. Esta semana lo entiendes, lo atacas y dejas tu sistema listo para hablarle al PLC.

Es la última semana de contenido del curso.

---

- [Antes de la clase (aprendizaje invertido)](#antes-de-la-clase)
    - [Cómo se trabaja esta guía](#como-se-trabaja)
    - [Bloque 1: por qué funciona aquí y falla allá](#bloque-1)
    - [Bloque 2: empaquetar el modelo y hablarle al PLC](#bloque-2)
    - [Bloque extra: ¿alcanza el tiempo del ciclo?](#bloque-extra)
- [Durante la clase (aprendizaje activo)](#durante-la-clase)
- [Avance de tu proyecto esta semana](#avance-del-proyecto)
    - [Prácticas](#practicas)
    - [Proyecto integrador](#proyecto-integrador)

---

## Antes de la clase (aprendizaje invertido) {#antes-de-la-clase}

### Cómo se trabaja esta guía {#como-se-trabaja}

| Bloque | Qué haces | Qué entregas |
|---|---|---|
| 1 | Diagnosticas por qué tu modelo falla en la banda | Tu diagnóstico con evidencia |
| 2 | Empaquetas el modelo y escribes `prueba_plc.py` | El paquete y el script de conexión |
| Extra | Mides si tu sistema alcanza el ritmo de la banda | El tiempo de ciclo medido |

El bloque 2 se escribe sin hardware. El miércoles se conecta al PLC.

---

### Bloque 1: por qué funciona aquí y falla allá {#bloque-1}

#### Sobreajuste

**Sobreajuste** (*overfitting*) es que el modelo aprendió los detalles y el ruido de tus datos de entrenamiento en vez de la regla general.

La analogía sirve: es el alumno que se aprende de memoria los ejercicios resueltos. Si el examen trae exactamente esos, saca 10. Si trae ejercicios parecidos pero distintos, se hunde. No aprendió a resolver, aprendió los resultados.

Se diagnostica comparando dos números que ya tienes:

| Entrenamiento | Prueba | Diagnóstico |
|---|---|---|
| 0.99 | 0.62 | **Sobreajuste**: memorizó |
| 0.68 | 0.65 | **Subajuste**: el modelo es demasiado simple |
| 0.91 | 0.87 | Sano |

Sus causas habituales: un modelo con demasiada capacidad para los datos que tiene (un árbol sin límite de profundidad, una red con muchas neuronas), pocos ejemplos, o demasiadas características para tan pocos ejemplos.

Y sus remedios: bajarle capacidad al modelo (`max_depth`, menos neuronas), quitar características que no aportan, o conseguir más datos.

#### Pero lo tuyo probablemente no es solo sobreajuste

Aquí está la lección de la semana, y es más profunda.

Tu modelo puede estar perfectamente sano (0.91 en entrenamiento, 0.87 en validación cruzada) y aun así derrumbarse en la banda. Porque el problema no es que haya memorizado: es que **los datos de la banda son de otro mundo**.

Se llama **desajuste de distribución**: los datos con los que entrenaste y los que le llegan en producción no vienen del mismo proceso. Y en tu caso sabes exactamente qué cambió:

| | Tu escritorio | La banda de la maqueta |
|---|---|---|
| Qué mueve la pieza | Tu mano | El motor |
| Velocidad | Variable, la tuya | Constante, la del motor |
| Duración del evento | Como te salía | Fija, distinta a la tuya |
| Vibración | Ninguna | La del motor y la banda |
| Distancia al sensor | La que fijaste | La del montaje de la celda |
| Luz de fondo | La de tu cuarto | La del laboratorio |

Si tu modelo se apoyaba en la **duración** del evento, y en la banda todas las piezas duran lo mismo porque van a velocidad constante, **esa característica dejó de existir para él**. No es que se equivoque: es que le quitaron el suelo.

Y aquí se cierra el arco de la semana 3. ¿Recuerdas la advertencia sobre la velocidad de tu mano? Si sin querer movías cada tipo de pieza a distinta velocidad, tu modelo aprendió tu mano. En la banda tu mano no existe. **Ese modelo tenía que fallar, y ahora sabes exactamente por qué.**

#### Cómo se diagnostica, no se adivina

Compara las distribuciones de tus características entre los dos conjuntos:

```python
import pandas as pd

f_escritorio = pd.read_csv('datos/features.csv')
f_banda      = pd.read_csv('datos/features_banda.csv')

for col in f_escritorio.columns:
    if col in ('ventana', 'etiqueta'):
        continue
    print(f"{col:15s}  escritorio {f_escritorio[col].mean():10.2f}   "
          f"banda {f_banda[col].mean():10.2f}")

# TODO: grafica el histograma de cada caracteristica en los dos conjuntos,
#       encimados, y guarda en figuras/desajuste.png
```

Las características cuyas distribuciones estén corridas entre los dos conjuntos son las culpables. Esa figura es tu diagnóstico y es la evidencia principal del bloque.

#### Las tres salidas

**Reentrenar con datos de la banda.** La correcta, y la que vas a hacer. Los datos que capturaste en la semana 15 son los buenos: son los del mundo donde el sistema va a vivir. Junta los dos conjuntos o quédate solo con los de la banda, y vuelve a entrenar toda la cadena.

**Quitar las características frágiles.** Si la duración ya no discrimina en la banda, quítala. Un modelo con menos características pero todas válidas es mejor que uno con una característica que quedó muerta.

**Aceptar que hay que recapturar.** Con 10 ventanas por clase de la banda no alcanza para entrenar bien. Si tu proyecto lo permite, agenda otro turno y captura más. Es la inversión con mejor retorno de las últimas semanas.

Y una lección general que vale más allá del curso: **el modelo se entrena con datos del mismo mundo donde va a operar.** Todo lo que hicimos en el escritorio fue el prototipo, exactamente como te lo anuncié en la semana 1.

**Lo que entregas de este bloque**

- `figuras/desajuste.png` con los histogramas comparados.
- En `BITACORA.md`, bajo `### Antes de la clase`:
  1. Tu exactitud en entrenamiento, en validación cruzada y en la banda. Los tres números juntos.
  2. Qué características cambiaron más entre los dos conjuntos, con la figura.
  3. Tu diagnóstico: ¿es sobreajuste, es desajuste de distribución, o son los dos?
  4. Sé honesto en esta: **¿hay evidencia de que tu modelo estaba aprendiendo la velocidad de tu mano?**

```bash
git add .
git commit -m "s16 bloque 1: diagnostico del desajuste"
git push
```

---

### Bloque 2: empaquetar el modelo y hablarle al PLC {#bloque-2}

#### El error que rompe los despliegues

Antes del PLC, hay que dejar el modelo bien empaquetado. Y aquí está el error clásico, del que te vengo advirtiendo desde la semana 7: **guardar el modelo sin lo que lo acompaña**.

Un modelo entrenado no es solo el modelo. Es todo esto:

1. El modelo.
2. **El escalador**, con la media y la desviación que calculó al entrenar.
3. **La lista de columnas en su orden exacto.**
4. Los parámetros del procesamiento: tamaño del filtro, umbral del evento, largo de ventana.

Si te falta el escalador, en producción vas a escalar con otros números y el modelo va a recibir un mundo distinto. Si te falta el orden de las columnas, `pandas` te puede armar el vector en otro orden y el modelo va a leer la energía donde esperaba la duración, **sin dar ningún error**. Solo va a responder mal.

La forma robusta es un pipeline completo, con todo dentro:

```python
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
import joblib

pipe = make_pipeline(StandardScaler(), modelo)
pipe.fit(X, y)

paquete = {
    'pipeline': pipe,
    'columnas': list(X.columns),
    'procesamiento': {
        'filtro_k': 5,
        'n_muestras': 200,
        'umbral_evento': 30,
        'fs': 100.0,
    },
    'version': '1.0-banda',
}
joblib.dump(paquete, 'modelo_produccion.pkl')
```

Con esto, usarlo en producción es una línea y no hay manera de que se te olvide escalar:

```python
etiqueta = paquete['pipeline'].predict(X[paquete['columnas']])[0]
```

#### El PLC S7-1214C

En la maqueta el Arduino ya no manda: manda el **PLC Siemens S7-1214C**, que es lo que gobierna la banda, el pistón y los sensores industriales de la celda.

Tu Python se comunica con él por Ethernet, con la biblioteca **python-snap7**:

```bash
pip install python-snap7
```

Si al importarla te sale un error de que no encuentra `snap7.dll`, es porque las versiones viejas de la biblioteca no traen la DLL incluida en Windows. Se resuelve actualizando:

```bash
pip install --upgrade python-snap7
```

La arquitectura queda así:

```
   sensores  -->  PLC S7-1214C  <-- Ethernet -->  PC con Python
   de la celda    192.168.0.1                     192.168.0.10
       |               |                          modelo entrenado
       |               v
       |          banda, piston
       +--------------------+
```

Y fíjate en algo importante: **el modelo es el mismo**. Lo que cambia es a quién le manda la orden. Es exactamente lo que te anticipé en la semana 1 cuando hablamos de prototipo y producción.

#### `prueba_plc.py`

Esta semana solo se prueba la conexión. El control completo es la semana 17.

```python
# prueba_plc.py - verifica la comunicacion con el PLC de la maqueta
import snap7
from snap7.util import get_bool, set_bool

IP   = '192.168.0.1'
RACK = 0
SLOT = 1
DB   = 1          # numero del bloque de datos acordado

plc = snap7.client.Client()
plc.connect(IP, RACK, SLOT)

print("Conectado:", plc.get_connected())
print(plc.get_cpu_info())

# leer un bloque de datos
datos = plc.db_read(DB, 0, 4)          # DB1, desde el byte 0, 4 bytes
print("Bytes leidos:", datos)

# leer un bit concreto: byte 0, bit 0
print("Sensor:", get_bool(datos, 0, 0))

# TODO: escribe un bit y verifica que el actuador responde
#       pista: set_bool(datos, 0, 1, True) y luego plc.db_write(DB, 0, datos)
#       CUIDADO: confirma conmigo que direccion escribir ANTES de correrlo

plc.disconnect()
```

Tres cosas que hay que tener claras antes del miércoles:

**La red.** La PC de control es la `192.168.0.10` y va conectada por Ethernet directo al PLC. Si tu laptop no está en esa red, no vas a conectar. Verifica con `ping 192.168.0.1` desde la terminal.

Y en Windows hay un paso extra: la mayoría de las laptops ya no traen puerto Ethernet, así que se usa un adaptador USB. Además, hay que **poner la IP fija a mano**, porque el PLC no reparte direcciones: Configuración, Red e Internet, Ethernet, Editar la asignación de IP, cambiar de Automático (DHCP) a Manual, y poner IP `192.168.0.20` (o la que te diga yo), máscara `255.255.255.0`. Si la dejas en automático, Windows se asigna una dirección `169.254.x.x` y el ping falla siempre.

**El firewall de Windows** puede bloquear la conexión la primera vez. Si al conectar aparece el aviso de Windows Defender, dale permiso en redes privadas.

**PUT/GET tiene que estar habilitado** en la configuración del PLC, y los bloques de datos sin protección de acceso optimizado. Eso ya está configurado en el equipo del laboratorio.

**No escribas direcciones al azar.** Leer es inofensivo; escribir mueve motores y pistones de verdad. **Antes de escribir cualquier dirección, confírmala conmigo.** Un bit equivocado puede arrancar la banda con alguien con la mano dentro.

**Lo que entregas de este bloque**

- `modelo_produccion.pkl`, el paquete completo, reentrenado con los datos de la banda.
- `codigo/prueba_plc.py` con el `TODO` escrito (no ejecutado todavía).
- En `BITACORA.md`:
  1. Qué contiene tu paquete de producción y para qué sirve cada cosa.
  2. Tu exactitud después de reentrenar con datos de la banda, comparada con la de antes.
  3. Qué características quitaste, si quitaste alguna, y por qué.

```bash
git add .
git commit -m "s16 bloque 2: modelo de produccion y conexion al PLC"
git push
```

---

### Bloque extra: ¿alcanza el tiempo del ciclo? {#bloque-extra}

Opcional, y muy pertinente para la revisión final.

En la semana 8 mediste la latencia de tu bucle. Ahora hay un número contra el cual compararla: **el tiempo entre pieza y pieza en la banda**.

1. Cronometra la banda: cuántos segundos pasan entre que una pieza cruza el sensor y lo cruza la siguiente.
2. Compara con la latencia total de tu bucle.

```
  tiempo de ciclo de la banda:  2.5 s
  latencia de tu bucle:         2.1 s   -> alcanza, con poco margen
  latencia de tu bucle:         3.4 s   -> NO alcanza, se te van piezas
```

Si no alcanza, hay tres salidas y ninguna es "comprar una computadora más rápida":

**Acortar la ventana.** Es casi siempre el cuello de botella, porque tienes que esperar físicamente a que pasen las muestras. Si tu evento dura 40 muestras y estás capturando 200, sobran 160.

**Procesar mientras capturas** en vez de esperar a tener la ventana completa.

**Simplificar el modelo.** Suele ser lo que menos ayuda, porque predecir tarda menos de un milisegundo. Medir antes de optimizar: es la regla.

Documenta los dos números y tu conclusión. En la revisión final voy a preguntar si tu sistema aguanta el ritmo de la línea, y hay que responder con números.

```bash
git add .
git commit -m "s16 extra: tiempo de ciclo y latencia"
git push
```

---

## Durante la clase (aprendizaje activo) {#durante-la-clase}

Última sesión de trabajo del curso. Estamos en el laboratorio, con la maqueta.

**1. Conexión al PLC.** Cada quien corre su `prueba_plc.py` y logra leer un bloque de datos. Es el momento en que el proyecto sale del escritorio. Los problemas típicos son de red y de configuración, y los resolvemos ahí.

**2. Escritura supervisada.** Con la dirección confirmada, cada quien escribe un bit y ve moverse un actuador de la celda. Se hace uno por uno y conmigo presente.

**3. El tablero del desajuste.** Anotamos, por alumno, la exactitud en escritorio, en la banda antes de reentrenar y después de reentrenar. La segunda columna casi siempre es un desastre y la tercera se recupera. Ese es el resumen visual de la Unidad 4.

**4. Plan para la revisión final.** Cada quien sale con una lista concreta de qué le falta para la demo de la semana 17 y con su turno de maqueta agendado.

---

## Avance de tu proyecto esta semana {#avance-del-proyecto}

### Prácticas {#practicas}

1. **Reentrena toda tu cadena con los datos de la banda** y deja `modelo_produccion.pkl` listo.

2. **Deja `prueba_plc.py` funcionando**, con lectura verificada y escritura probada bajo supervisión.

3. **Actualiza el `README.md`** con la ficha final de tu sistema: sensor, características, modelo, exactitud en validación cruzada, exactitud en la banda, tiempo de ciclo.

4. **Prepara la demo de la semana 17.** Necesitas: el bucle completo corriendo sobre la maqueta con el PLC, clasificando y rechazando anomalías, y la bitácora con las 16 semanas.

5. **Escribe tu entrada de `BITACORA.md`**, bajo `### Avance del proyecto`:

   - Tu tabla de exactitudes: escritorio, banda antes de reentrenar, banda después.
   - Qué aprendiste sobre tus propios datos al ver el desajuste.
   - Si tu sistema alcanza el tiempo de ciclo de la banda.
   - Y la reflexión de cierre del curso, que quiero leer con calma: **si volvieras a empezar el semestre desde la semana 3 sabiendo lo que sabes hoy, ¿qué harías distinto al recolectar tus datos?**

   ```bash
   git add .
   git commit -m "s16 proyecto: modelo reentrenado para la banda y conexion al PLC"
   git push
   ```

### Proyecto integrador {#proyecto-integrador}

Semana de integración final sobre la maqueta.

1. **Un solo programa** que lea los sensores de la celda a través del PLC, corra los modelos de los tres módulos y escriba las órdenes de vuelta al PLC.
2. **Definan quién escribe al PLC.** Solo un proceso debe tener permiso de escribir, o van a pelearse por el control de los actuadores. Suele ser el controlador central y los módulos solo devuelven su decisión.
3. **Prueben la secuencia completa** sobre la banda: pieza que entra, sensores que la leen, modelo que decide, pistón que actúa. Con piezas normales y con anomalías.
4. **Cronometren el ciclo del sistema completo** y comparen con el de la banda.
5. **Ensayen la demo de la semana 17.** Tienen una sesión y hay varios equipos; una demo que no se ha ensayado no cabe en el tiempo.
