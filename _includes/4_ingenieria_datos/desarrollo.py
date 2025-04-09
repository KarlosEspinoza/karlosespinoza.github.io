import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split

# 1. Cargar el dataset
df = pd.read_csv("sensor_readings_2.csv")

# 2. Mostrar información general
print("Primeras filas del dataset:")
print(df.head())
print("\nResumen estadístico:")
print(df.describe())
print("\nTipos de datos:")
print(df.dtypes)

# 3. Verificar valores faltantes
nulos = df.isnull()
#print(nulos.algo2[1])
print("\nValores nulos por columna:")
print(nulos.sum())

# 4. Limpieza: eliminar filas/columnas vacías (si hay)
nulos = df.isnull()
#print(nulos)
df = df.dropna()
nulos = df.isnull()
#print(nulos)

# 5. Visualización básica
sns.countplot(x="clase", data=df)
plt.title("Distribución de clases")
plt.show()

# 6. Ingeniería de características
# Convertir etiquetas (por ejemplo, texto a número)
if df['clase'].dtype == 'object':
    le = LabelEncoder()
    df['clase'] = le.fit_transform(df['clase'])
#print(df)
#print("\nTipos de datos:")
#print(df.dtypes)

# Separar entrada y salida
X = df.drop('clase', axis=1)
y = df['clase']
#print(X)
#print(y)

# 7. Normalización
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
#print(X)
#print(X_scaled)

# 8. División entrenamiento/prueba
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.25, random_state=42, stratify=y
)
#print(X_train)
#print(y_train)

# 9. Guardar los datos procesados (opcional)
np.save("X_train.npy", X_train)
np.save("X_test.npy", X_test)
np.save("y_train.npy", y_train)
np.save("y_test.npy", y_test)
