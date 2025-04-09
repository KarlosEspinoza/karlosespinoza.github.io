import csv
porcentaje = 0.75

# Importar
with open("banknotes.csv") as f:
    lector = csv. reader(f)
    next(lector)

    entrada = []
    salida = []
    for fila in lector:
        entrada.append([float(fila[0]), float(fila[1]), float(fila[2]), float(fila[3])])
        salida.append(int(fila[4]))

# Partir
umbral = int(porcentaje * len(entrada))
training_input = entrada[:umbral]
training_output = salida[:umbral]
test_input = entrada[umbral:]
test_output = salida[umbral:]

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
