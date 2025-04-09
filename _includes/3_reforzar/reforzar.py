import csv
import random
import joblib

porcentaje = 0.75

# Importar
with open("banknotes.csv") as f:
    lector = csv. reader(f)
    next(lector)

    datos = []
    for fila in lector:
        datos.append([float(fila[0]), float(fila[1]), float(fila[2]), float(fila[3]), int(fila[4])])
## *Combinar*
nuevos_clientes = [
        [1.5099,0.039307,6.2332,-0.30346],
        [4.2027,0.22761,0.96108,0.97282]
        ]
decision_banqueros = [1,0]
for x, y in zip(nuevos_clientes, decision_banqueros):
    x.append(y)
    datos.append(x)

# Partir
random.shuffle(datos)
umbral = int(porcentaje * len(datos))
training_X = [fila[:4] for fila in datos[:umbral]]
training_y = [fila[4] for fila in datos[:umbral]]
test_X = [fila[:4] for fila in datos[:umbral]]
test_y = [fila[4] for fila in datos[:umbral]]

# Re-entrenar
modelo = joblib.load("chido.pkl")
modelo.fit(training_X, training_y)

# Evaluar
prediction = modelo.predict(test_X)
aciertos = 0
errores = 0
longitud_salida = len(test_y)
for y, p in zip(test_y, prediction):
    if y == p:
        aciertos = aciertos + 1
    else:
        errores = errores + 1
print(aciertos*100/longitud_salida)
print(errores*100/longitud_salida)

# Guardar
import joblib
joblib.dump(modelo, "chido.pkl")
