# leer_sensor.py - lee la señal del sensor y grafica una ventana
import serial
import time
import matplotlib.pyplot as plt

PUERTO = 'COM4'          # el tuyo puede ser otro: COM4, COM5...
BAUDIOS = 9600
N_MUESTRAS = 200          # con delay(10) son unos 2 segundos

ser = serial.Serial(PUERTO, BAUDIOS, timeout=1)
time.sleep(2)             # el Arduino se reinicia al abrir el puerto

valores = []
print("Leyendo... pasa la pieza frente al sensor")

while len(valores) < N_MUESTRAS:
    linea = ser.readline()
    print(linea)          # para ver la señal en vivo

ser.close()
print(f"Listas {len(valores)} muestras")
