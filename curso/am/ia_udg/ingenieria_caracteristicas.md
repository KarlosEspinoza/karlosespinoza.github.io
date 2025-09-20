---
layout: default
title: Inteligencia Artificial
---
[Curso: Inteligencia Artificial](index)

# Actividad: Ingeniería de Características

## Objetivo

Que el estudiante comprenda y aplique los conceptos de **ingeniería de características** en proyectos de **aprendizaje supervisado**, extrayendo y transformando datos de sensores conectados a un Arduino para mejorar el desempeño de un modelo de machine learning.

## Aportación a los Atributos de Egreso

Esta actividad contribuye al **diseño e implementación de sistemas** (AE2A), pues los estudiantes transformarán lecturas de sensores en características útiles para modelos predictivos. Además, fortalece el **trabajo colaborativo y liderazgo** (AE7A) ya que los alumnos trabajarán en parejas, discutiendo qué características son más relevantes y construyendo soluciones conjuntas en un entorno de incertidumbre.

## Método de enseñanza

Se utilizará **Aprendizaje Experiencial y Basado en la Indagación**. Los estudiantes explorarán los datos reales de sensores, formularán hipótesis sobre qué transformaciones podrían mejorar el modelo, y validarán sus resultados en ejercicios prácticos con Arduino y Python.

## Criterios de evaluación

La evidencia se revisará con lista de cotejo:

* ¿Incluyó código y ejecución en Arduino/Python?
* ¿Aplicó correctamente al menos **dos técnicas de ingeniería de características**?
* ¿Se entregaron capturas/fotos como evidencia?
* ¿El trabajo refleja aportaciones de ambos integrantes?

---

## Desarrollo del Tema
































### Extracción de características

La **extracción de características** consiste en obtener nuevas variables a partir de los datos crudos de los sensores.
Ejemplo matemático: si \$x(t)\$ son lecturas de un sensor en el tiempo, podemos calcular:

* **Media móvil:**

  $$
  \bar{x}(t) = \frac{1}{n}\sum_{i=0}^{n-1} x(t-i)
  $$

* **Varianza:**

  $$
  \sigma^2 = \frac{1}{n}\sum_{i=1}^n (x_i - \mu)^2
  $$

donde \$\mu\$ es la media de los datos.

#### Ejemplo

Un Arduino Nano mide con un **HC-SR04** la distancia a un objeto en movimiento. Si usamos solo un valor puntual, el modelo puede ser inestable. Extraer la **media de 5 lecturas** da una característica más robusta para decidir si activar un **servo** que abre una compuerta.

#### Ejercicio (Arduino Nano + HC-SR04)

<img src="/image/ia/hc-sr04.png" width="600"/>

```cpp
const int trigPin = 9;
const int echoPin = 10;

long duracion;
int distancia;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // Medir distancia
  digitalWrite(trigPin, LOW); delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  duracion = pulseIn(echoPin, HIGH);
  distancia = duracion * 0.034 / 2; // cm

  Serial.println(distancia);
  delay(200);
}
```

Tarea en clase: calcular en Python la media de cada 5 valores recibidos y depositarlos en un CSV.

**guardar_a_csv.py**

```python
import serial, time
import csv   # biblioteca para manejar archivos CSV

# TODO: Leer ~20 valores del Arduino y guardarlos en la lista 'valores'
# pista: ya saben usar readline(), decode(), float() y append()

# Guardar en un archivo CSV
with open('datos.csv', 'w', newline='') as archivo:
    writer = csv.writer(archivo)
    for valor in valores:
        writer.writerow([valor])  # cada fila tiene un valor
```

**calcular_medias.py**

```python
import csv
import numpy as np

valores = []

# Leer archivo CSV con las lecturas originales
with open('datos.csv', 'r') as archivo:
    reader = csv.reader(archivo)
    for fila in reader:
        valores.append(float(fila[0]))

medias = []

# Calcular medias de cada 5 lecturas
for i in range(0, len(valores), 5):
    bloque = valores[i:i+5]
    if len(bloque) == 5:  # solo bloques completos
        media = np.mean(bloque)
        medias.append(media)
        print(f"Media de lecturas {i+1}-{i+5}: {media:.2f}")

# Guardar las medias en un nuevo archivo CSV
with open('medias.csv', 'w', newline='') as archivo:
    writer = csv.writer(archivo)
    writer.writerow(["Media"])  # encabezado
    for m in medias:
        writer.writerow([m])
```
































### Transformación de características

#### Explicación

Se refiere a **convertir datos originales en una forma más útil**. Ejemplos comunes:

* **Escalamiento (Min-Max, Z-score)**
* **Transformaciones logarítmicas** para reducir sesgo en valores muy grandes.
* **Combinaciones** de variables (ej. potencia consumida = Voltaje × Corriente).

#### Ejemplo

Un Arduino Nano recibe la temperatura de un LM35 y el flujo de agua medido por un YF-S201. Por separado, estos valores no dicen mucho sobre el estado del sistema, pero al combinarlos se obtiene la potencia térmica disipada en el agua. Esta nueva variable permite que el Arduino active una válvula controlada por un relé solo cuando la disipación supere un umbral, evitando sobrecalentamiento y optimizando el uso de energía.

#### Ejercicio (Arduino Nano + LM35 + YF-S201)

<img src="/image/ia/lm35_yf-s201.png" width="600"/>


Genera ~30 filas con datos sintéticos de temperatura (LM35 simulada) y caudal (YF-S201 simulado) y las guarda en **datos_sinteticos.csv**.

```python
# simular_guardar_csv.py
import csv, random, time

N = 30                  # número de lecturas
T_REF = 25.0            # °C, referencia ambiental típica
random.seed(42)

with open('datos_sinteticos.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['timestamp', 'temp_C', 'flow_Lmin'])  # encabezado
    t0 = time.time()
    for i in range(N):
        # Temperatura simulada alrededor de T_REF con ligera variación
        temp_C = T_REF + random.gauss(3.0, 1.2)  # p.ej., sistema algo más caliente que ambiente
        # Caudal simulado, no negativo
        flow_Lmin = max(0.0, random.gauss(1.2, 0.4))  # L/min
        w.writerow([f"{t0 + i*0.5:.1f}", f"{temp_C:.2f}", f"{flow_Lmin:.3f}"])
```


Leer el CSV y calcular $P = \dot{m}\, c_p\, \Delta T$, donde:

* $\dot{m} \approx \rho \cdot \text{flow\_Lmin}/60$ (kg/s, con $\rho\approx1\,\text{kg/L}$),
* $c_p \approx 4184\,\text{J/(kg·°C)}$,
* $\Delta T = \text{temp\_C} - T_{\text{ref}}$.

> Asume que el agua: $\rho = 1.0\,\text{kg/L}$.

> Usa $T_{\text{ref}} = 25\,^\circ\text{C}$ como referencia.

```python
# calcular_potencia.py
import csv

CP_WATER = 4184.0   # J/(kg·°C)
RHO = 1.0           # kg/L
T_REF = 25.0        # °C

temps_C = []
flows_Lmin = []

# TODO: Leer 'datos_sinteticos.csv' y llenar temps_C y flows_Lmin

potencias_W = []

# TODO: Recorrer las listas y calcular potencia térmica para cada fila
# Fórmulas/pistas:
# - convertir L/min → kg/s: mdot = (flow_Lmin / 60.0) * RHO
# - deltaT = temp_C - T_REF
# - P = mdot * CP_WATER * deltaT
# - potencias_W.append(P)

# TODO: Guardar las potencias en 'potencia_termica.csv'
```











### Selección de características

#### Explicación

La **selección de características** busca identificar cuáles variables realmente aportan información al modelo.
Métodos básicos:

* **Correlación** con la variable objetivo.
* **Prueba y error** eliminando sensores redundantes.

#### Ejemplo

Un sistema con **LDR** y **GP2Y0A21YK0F** predice la apertura de un **relé**. Si se observa que la luz no afecta la predicción, se puede excluir la variable del LDR para simplificar el modelo.

#### Ejercicio (Arduino Nano + LDR + LM35)

En un pasillo con iluminación variable, un Arduino Nano enciende un LED cuando el LDR detecta poca luz (umbrales bajos en el ADC). También hay un LM35 midiendo temperatura, pero esta no influye en la decisión de encender el LED. Al analizar los datos, la correlación entre LED_ON y el LDR será fuerte (negativa: menos luz → más probabilidad de 1), mientras que con temperatura será cercana a cero.

<img src="/image/ia/lm35_ldr_led.png" width="600"/>

```cpp
/* Arduino Nano: LDR (A0), LM35 (A1), LED (D3)
   Emite por Serial: timestamp(ms), ldr_raw(0-1023), temp_C, LED_ON
   Regla: LED_ON = 1 si ldr_raw < LDR_THRESHOLD (poca luz)
   Pequeño ruido en etiqueta (5%) para hacerlo realista.
*/

const int PIN_LDR   = A0;     // LDR en divisor de voltaje -> A0
const int PIN_LM35  = A1;     // LM35 -> salida analógica a A1
const int PIN_LED   = 3;      // LED en D3 (con su resistencia)
const int LDR_THRESHOLD = 300; // umbral de poca luz (ajustable)

void setup() {
  Serial.begin(9600);
  pinMode(PIN_LED, OUTPUT);
  // Semilla pseudo-aleatoria con ruido analógico
  randomSeed(analogRead(A2));
}

float leerTemperaturaC() {
  int adc = analogRead(PIN_LM35);
  // LM35: 10 mV/°C; ADC 10 bits, referencia 5 V
  // temp_C = (adc * 5.0 V / 1023) / 0.01 V/°C = adc * 500 / 1023
  return (adc * 500.0) / 1023.0;
}

void loop() {
  unsigned long t = millis();
  int ldr_raw = analogRead(PIN_LDR);
  float temp_C = leerTemperaturaC();

  // Regla del LED por poca luz
  int led_on = (ldr_raw < LDR_THRESHOLD) ? 1 : 0;

  // Ruido del 5% en la etiqueta para simular errores de rotulado
  if (random(0, 100) < 5) {
    led_on = 1 - led_on;
  }

  digitalWrite(PIN_LED, led_on ? HIGH : LOW);

  // Salida CSV (sin espacios): timestamp,ldr_raw,temp_C,LED_ON
  Serial.print(t);
  Serial.print(",");
  Serial.print(ldr_raw);
  Serial.print(",");
  Serial.print(temp_C, 2);
  Serial.print(",");
  Serial.println(led_on);

  delay(200); // ~5 Hz
}
```

```python
# leer_y_guardar_csv.py
# Lee líneas CSV del Arduino con el formato:
# timestamp,ldr_raw,temp_C,LED_ON
# y las guarda en ldr_temp_led.csv con encabezado.

import serial, time, csv

PORT = '/dev/ttyUSB0'   # Windows: 'COM3', macOS: '/dev/tty.usbserial-XXXX'
BAUD = 9600
N_SAMPLES = 120         # cuántas filas guardamos

ser = serial.Serial(PORT, BAUD, timeout=2)
time.sleep(2)  # dar tiempo a que el Arduino reinicie

with open('ldr_temp_led.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['timestamp', 'ldr_raw', 'temp_C', 'LED_ON'])  # encabezado

    count = 0
    while count < N_SAMPLES:
        try:
            line = ser.readline().decode('utf-8').strip()
            if not line:
                continue
            # Esperamos: t,ldr,temp,led
            parts = line.split(',')
            if len(parts) != 4:
                continue

            t_ms   = float(parts[0])
            ldr    = float(parts[1])
            temp_c = float(parts[2])
            led_on = int(float(parts[3]))  # por si viene como "1.0"

            w.writerow([t_ms, ldr, temp_c, led_on])
            count += 1
        except Exception as e:
            # Ignora líneas malformadas y sigue leyendo
            continue

ser.close()
print(f"OK: guardadas {N_SAMPLES} filas en ldr_temp_led.csv")
```

```python
# correlacion_con_objetivo.py
import csv
import math

# --- utilidades ---
def pearson_r(x, y):
    """Correlación de Pearson r(x,y) sin dependencias externas."""
    n = len(x)
    if n < 2 or len(y) != n:
        raise ValueError("Listas con longitud inválida")
    mx = sum(x) / n
    my = sum(y) / n
    num = sum((xi - mx)*(yi - my) for xi, yi in zip(x, y))
    denx = math.sqrt(sum((xi - mx)**2 for xi in x))
    deny = math.sqrt(sum((yi - my)**2 for yi in y))
    return 0.0 if denx == 0 or deny == 0 else num/(denx*deny)

# --- leer CSV ---
ldr_vals, temps, y = [], [], []
with open('ldr_temp_led.csv', 'r') as f:
    reader = csv.reader(f)
    next(reader)  # saltar encabezado
    for row in reader:
        # columnas: timestamp, ldr_raw, temp_C, LED_ON
        ldr_vals.append(float(row[1]))
        temps.append(float(row[2]))
        y.append(float(row[3]))  # 0/1

# --- calcular correlaciones ---
r_ldr = pearson_r(y, ldr_vals)   # se espera valor negativo (menos luz -> LED=1)
r_temp = pearson_r(y, temps)     # se espera ~0 (independiente)

print(f"r(LED_ON, LDR)   = {r_ldr:.3f}")
print(f"r(LED_ON, TempC) = {r_temp:.3f}")

# --- guardar a CSV ---
with open('correlaciones.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['variable', 'r_con_LED_ON'])
    w.writerow(['LDR', f"{r_ldr:.6f}"])
    w.writerow(['TempC', f"{r_temp:.6f}"])
```
























---

## Práctica (para casa, 30 min)

En parejas, recolecten datos de **2 sensores distintos** (ej. HC-SR04 + LDR) y activen un actuador (ej. Servo o LED RGB).
Guarden esos datos sensores y actuadores en un CSV (datos_crudos.csv) con un script python.
Lean el CSV apliquen una **transformación** y estimen la **correlación** de los sensores con el actuador.

---

## Entregables

* Código Arduino y Python usado en ejercicios y práctica.
* Capturas de pantalla/fotos de la ejecución y montaje.
* Breve descripción (3–5 líneas) de donde estan aplicados los conceptos aprendidos.
* Evidencia entregada en un **Google Docs con capturas, código y descripción breve**.

---

## Actividad de Gamificación (5–10 minutos)

**“Feature Battle”**

* Dividir la clase en **2 equipos**.
* Se proyecta un conjunto de 10 valores de un sensor (ej. distancia de HC-SR04).
* Cada equipo debe proponer **la mejor característica** (ej. media, rango, varianza, normalización) que pueda usarse para decidir si un servo se activa.
* El profesor elige la característica más **robusta y justificada**.
* Equipo ganador obtiene puntos extra o premio sorpresa.


## Actividad Extra

Si quieres aprender más sobre este tema, te invito a revisar [este material](ingenieria_caracteristicas_extra).

