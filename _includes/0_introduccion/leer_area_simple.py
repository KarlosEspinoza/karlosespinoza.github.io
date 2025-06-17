# archivo: leer_area_simple.py

# Abrimos el archivo en modo lectura
archivo = open('datos_area.csv', 'r')

# Leemos la primera línea con los encabezados y la imprimimos
encabezados = archivo.readline().strip()
print("Encabezados:", encabezados)

# Leemos cada línea del archivo
for linea in archivo:
    linea = linea.strip()  # quitamos salto de línea y espacios
    columnas = linea.split(',')  # separamos por coma
    
    ancho = float(columnas[0])
    alto = float(columnas[1])
    area = float(columnas[2])
    
    print(f"Ancho: {ancho}, Alto: {alto}, Área: {area}")

# Cerramos el archivo
archivo.close()

