import csv
import matplotlib.pyplot as plt

# --- Configuración de archivos ---
input_file = "datos.csv"
output_image = "visualizacion_datos.png"

# --- Lectura de datos ---
temp = []
luz = []
label = []
temp_futuro = []

try:
    with open(input_file, mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            temp.append(float(row['temp']))
            luz.append(float(row['luz']))
            label.append(int(row['label']))
            temp_futuro.append(float(row['temp_futuro']))
except FileNotFoundError:
    print(f"Error: No se encontró '{input_file}'. Ejecuta 'datos.py' primero.")
    exit()

# --- Crear la figura ---
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# 1. Gráfica de Clasificación (Temp vs Luz)
# Separar puntos por clase para la leyenda
t_normal = [temp[i] for i in range(len(label)) if label[i] == 0]
l_normal = [luz[i] for i in range(len(label)) if label[i] == 0]
t_critico = [temp[i] for i in range(len(label)) if label[i] == 1]
l_critico = [luz[i] for i in range(len(label)) if label[i] == 1]

ax1.scatter(t_normal, l_normal, c='blue', label='Normal (0)', alpha=0.6, edgecolors='w')
ax1.scatter(t_critico, l_critico, c='red', label='Crítico (1)', alpha=0.6, edgecolors='w')
ax1.set_title("Clasificación: Temperatura vs Luz")
ax1.set_xlabel("Temperatura (°C)")
ax1.set_ylabel("Luz (Valor ADC)")
ax1.legend()
ax1.grid(True, linestyle='--', alpha=0.7)

# 2. Gráfica de Regresión (Temp Actual vs Temp Futura)
ax2.scatter(temp, temp_futuro, c='green', alpha=0.5, label='Datos')
# Línea de tendencia ideal (identidad aproximada)
lims = [min(temp), max(temp)]
ax2.plot(lims, [l + 0.75 for l in lims], 'r--', label='Tendencia teórica (+0.75°C)')
ax2.set_title("Regresión: Temperatura Actual vs Futura")
ax2.set_xlabel("Temperatura Actual (°C)")
ax2.set_ylabel("Temperatura Futura (°C)")
ax2.legend()
ax2.grid(True, linestyle='--', alpha=0.7)

# Mostrar gráficas de forma interactiva
plt.show()
