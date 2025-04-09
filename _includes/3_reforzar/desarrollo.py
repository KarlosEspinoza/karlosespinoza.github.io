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

# Partir
random.shuffle(datos)
umbral = int(porcentaje * len(datos))
training_input = [fila[:4] for fila in datos[:umbral]]
training_output = [fila[4] for fila in datos[:umbral]]
test_input = [fila[:4] for fila in datos[:umbral]]
test_output = [fila[4] for fila in datos[:umbral]]

# Entrenar
from sklearn.linear_model import Perceptron
modelo = Perceptron()
#from sklearn.neighbors import KNeighborsClassifier
#modelo = KNeighborsClassifier(n_neighbors=7)
#from sklearn import svm
#modelo = svm.SVC()
modelo.fit(training_input, training_output)

# Evaluar
prediction = modelo.predict(test_input)
aciertos = 0
errores = 0
longitud_salida = len(test_output)
for i in range(longitud_salida):
    if test_output[i] == prediction[i]:
        aciertos = aciertos + 1
    else:
        errores = errores + 1
print(aciertos*100/longitud_salida)
print(errores*100/longitud_salida)

# Guardar
import joblib
joblib.dump(modelo, "chido.pkl")
