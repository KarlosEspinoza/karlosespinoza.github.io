import csv
import random
import math

# Configuración de reproducibilidad
random.seed(42)

# Cantidad de muestras solicitadas en el ejercicio integrador
n_normal = 50000*100
n_critico = 5000*100

# Lista para almacenar los datos
datos = []

# --- Generación de Datos Normales (50 muestras) ---
# Temperatura LM35: 20°C a 30°C
# LDR (Luz): 500 a 800 (valores ADC)
for _ in range(n_normal):
    temp = random.uniform(20.0, 30.0)
    luz = random.uniform(500, 800)
    label = 0
    # temp_futuro: tendencia + ruido
    temp_futuro = temp + 0.75 + random.gauss(0, 0.3)
    datos.append([round(temp, 2), int(luz), label, round(temp_futuro, 2)])

# --- Generación de Datos Críticos (50 muestras) ---
# Falla 1: Mucho calor (> 36°C) - 25 muestras
for _ in range(25):
    temp = random.uniform(36.0, 45.0)
    luz = random.uniform(500, 800)
    label = 1
    temp_futuro = temp + 0.75 + random.gauss(0, 0.3)
    datos.append([round(temp, 2), int(luz), label, round(temp_futuro, 2)])

# Falla 2: Oscuridad (< 200 ADC) - 25 muestras
for _ in range(25):
    temp = random.uniform(20.0, 30.0)
    luz = random.uniform(50, 150)
    label = 1
    temp_futuro = temp + 0.75 + random.gauss(0, 0.3)
    datos.append([round(temp, 2), int(luz), label, round(temp_futuro, 2)])

# --- Mezclar los datos ---
random.shuffle(datos)

# --- Guardar a CSV ---
output_file = "datos.csv"
header = ['temp', 'luz', 'label', 'temp_futuro']

with open(output_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(header)
    writer.writerows(datos)

print(f"Éxito: Se ha generado '{output_file}' con {len(datos)} registros.")
print("\nPrimeras 5 filas (mezcladas):")
for fila in datos[:5]:
    print(fila)

# Conteo de clases
c_normal = sum(1 for d in datos if d[2] == 0)
c_critico = sum(1 for d in datos if d[2] == 1)
print(f"\nDistribución de clases: Normal: {c_normal}, Crítico: {c_critico}")
