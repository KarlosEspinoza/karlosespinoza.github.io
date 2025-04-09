import joblib
# Cargar
modelo = joblib.load("chido.pkl")

nuevo_cliente = [[4.2027,0.22761,0.96108,0.97282]]
predecir = modelo.predict(nuevo_cliente)

print(predecir)
