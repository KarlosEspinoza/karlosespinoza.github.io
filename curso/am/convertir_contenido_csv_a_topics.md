import csv

# Abrimos el archivo CSV
with open('datos_area.csv', 'r') as archivo_csv:
    lector = csv.reader(archivo_csv)
    
    # Leemos la primera línea que contiene los encabezados
    encabezados = next(lector)
    print("Encabezados:", encabezados)
    
    # Leemos cada fila y la imprimimos
    for fila in lector:
        ancho = float(fila[0])
        alto = float(fila[1])
        area = float(fila[2])
        print(f"Ancho: {ancho}, Alto: {alto}, Área: {area}")
