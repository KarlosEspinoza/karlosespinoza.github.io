import serial
import time

arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
time.sleep(2)

def parsear_datos(linea):
    datos = {}
    partes = linea.split(",")

    for parte in partes:
        clave, valor = parte.split(":")
        datos[clave.lower()] = int(valor)

    return datos

def evaluar_sistema(datos):
    if datos["luz"] < datos["ref"]:
        return "LED_ON"
    elif datos["temp"] > 30:
        return "LED_ON"
    else:
        return "LED_OFF"

while True:
    linea = arduino.readline().decode().strip()

    if linea:
        datos = parsear_datos(linea)
        accion = evaluar_sistema(datos)

        print("Datos:", datos)
        print("Acción:", accion)

        arduino.write((accion + "\n").encode())

    time.sleep(0.2)
