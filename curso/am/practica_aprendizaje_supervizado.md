---
layout: default
title: Aprendizaje Supervisado
---
# Projecto: Aprendizaje supervisado
## Set de datos
El siguiente set de datos corresponden a un adaptación de [Enviromental Sensor Telemetry Data de Kaggle](https://www.kaggle.com/garystafford/environmental-sensor-data-132k). 
Donde se colocaron 3 Raspberry Pi en diferentes lugares, cada Raspberry Pi tiene una dirección MAC.
En la columna "device" se encuentra las direcciones MAC para cada muestra. 
Cada Raspberry Pi mide la humedad, presencia de luz, gas LP, presencia de movimiento, humo y temperatura.

[datos.csv](/datos/am/supervisado/practica/1/datos.csv)

## Desarrollo de la máquina de aprendizja supervizado
Aqui tienes el pseudocodigo y algunas muestras de codigo que si debes de incluir en tu proyecto.
**desarrollo.py**
```python
# Importa las librerias que necesites
# [HACER]

# Etapa. Importar los datos
# [HACER]

# Etapa. Procesa los datos.
# [HACER]
if df['device'].dtype == 'object':
    le = LabelEncoder()
    df['device'] = le.fit_transform(df['device'])
    device = le.classes_
# [HACER]

# Etapa. Define los modelos a utilizar.
modelos = {
    "Logistic Regression": LogisticRegression(max_iter=1000),
    "Perceptron": Perceptron(),
    "SVM": SVC(),
    "KNN (k=5)": KNeighborsClassifier(n_neighbors=5),
    "Decision Tree": DecisionTreeClassifier(),
    "Random Forest": RandomForestClassifier(),
    "Gradient Boosting": GradientBoostingClassifier(),
    "Stochastic GD": SGDClassifier(max_iter=1000, tol=1e-3),
    "Naive Bayes": GaussianNB(),
    "MLP (Neural Net)": MLPClassifier(max_iter=1000)
}

# Etapa. Entrena y evalua los modelos
for nombre, modelo in modelos.items():
    # [HACER]
    # Etapa. Guarda el mejor modelo
    # [HACER]

```

## Produccion de la máquina de aprendizaje supervisado
Una vez tengas identificado y guardado el mejor modelo llevalo a producción en tu Raspberry Pi.
**produccion.py**
```python
# Ingresa una nueva muestra (la temperatura y la humedad la leeras de DHT11, lo demas si puede ser invetado)
# [HACER]

# Carga el modelo
# [HACER]

# Realiza la predicción
# [HACER]

# Imprime el resultado
# [HACER]

```

