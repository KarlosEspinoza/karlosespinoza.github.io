---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../index)

# Modelo matemático en ingeniería

# Objetivo

Que el estudiante **comprenda el concepto de modelo matemático en ingeniería de materiales**, identifique sus **supuestos, variables y alcances**, y sea capaz de **formular, implementar y analizar** un modelo teórico básico aplicado a un problema real de ciencia de materiales.

# Método de enseñanza

**Aprendizaje Basado en Casos (Case-Based Learning)** + **Aprendizaje Activo con Modelación Computacional**

* El caso guía toda la sesión.
* La teoría se introduce solo cuando el caso lo exige.
* El ejercicio computacional consolida la abstracción matemática.

# Criterios de evaluación

| Criterio                     | Descripción                                                          | Peso |
| ---------------------------- | -------------------------------------------------------------------- | ---- |
| Comprensión conceptual       | Identificación correcta de variables, supuestos y alcance del modelo | 30%  |
| Formulación matemática       | Correcta definición del modelo y ecuaciones                          | 25%  |
| Implementación computacional | Código funcional y bien estructurado en Matlab                       | 25%  |
| Análisis e interpretación    | Interpretación física de resultados                                  | 20%  |

# Desarrollo del tema

## Caso

Durante el diseño de un nuevo recubrimiento cerámico para aplicaciones de alta temperatura, un equipo de ingeniería observa que el crecimiento de microgrietas depende fuertemente de la temperatura de operación. 
Ensayos experimentales muestran que, al incrementar la temperatura, la tasa de propagación de la grieta aumenta de forma no lineal. 
Sin embargo, realizar pruebas experimentales para cada condición térmica resulta costoso y lento. 
El equipo decide construir un **modelo matemático simplificado** que relacione temperatura y longitud de grieta, permitiendo predecir el comportamiento del material bajo distintas condiciones y evaluar límites seguros de operación antes de fabricar nuevos prototipos.

## Modelos clave

### ¿Qué es un modelo matemático en ingeniería?

Un modelo matemático es una **representación abstracta** de un fenómeno físico real mediante variables, parámetros y ecuaciones, cuyo objetivo es **explicar, predecir o controlar** el comportamiento del sistema.

**Relación con el caso:**

Aquí, el fenómeno real es el crecimiento de microgrietas; el modelo permitirá predecir su evolución sin ensayos físicos repetidos.

### Variables, parámetros y supuestos

| Elemento               | Ejemplo en el caso                       |
| ---------------------- | ---------------------------------------- |
| Variable independiente | Temperatura ($T$)                        |
| Variable dependiente   | Longitud de grieta ($a(t)$)              |
| Parámetros             | Constantes de material                   |
| Supuestos              | Material homogéneo, temperatura uniforme |

**Relación con el caso:**

Los supuestos delimitan **cuándo el modelo es válido** y evitan sobreinterpretar resultados.

### Modelo fenomenológico simple (ecuación diferencial)

Se propone un modelo tipo ley de potencia:

$$
\frac{da}{dt} = k \cdot T^n
$$

donde:

* $a(t)$: longitud de grieta
* $T$: temperatura
* $k, n$: parámetros del material

$$
\frac{da}{dt}=k,T^n
\Rightarrow a(t) = a_0 + k \cdot T^n \cdot t
$$

**Relación con el caso:**

Este modelo no describe todos los mecanismos físicos, pero captura la **tendencia dominante** observada experimentalmente.

### Limitaciones del modelo

* No incluye efectos microestructurales
* No considera cambios de fase

### Alcances del modelo

* Útil para predicción preliminar
* Reduce costos experimentales

Un buen modelo **no es el más complejo**, sino el **adecuado para la pregunta de ingeniería**.

## Ejercicio en clase 

Utilizando el modelo propuesto, simula la evolución de la longitud de una grieta durante 10 horas para distintas temperaturas.

### Datos

```matlab
% datos_ejercicio.m
% Genera datos sintéticos tipo "experimento" (ground truth + ruido)
% para crecimiento de grieta a(t) en función de T, con el modelo:
% a(t) = a0 + k*T^n*t

clear; clc; close all;

% -------------------------
% Parámetros "verdaderos"
% -------------------------
a0_true = 0.10;     % mm (longitud inicial)
k_true  = 1.2e-8;   % mm/h/°C^n  (ajusta magnitud)
n_true  = 3.1;      % exponente (no linealidad vs T)

% -------------------------
% Diseño experimental
% -------------------------
T_list = [650 700 750 800 850 900]';   % °C (condiciones)
t = (0:0.5:10)';                       % horas (mediciones cada 0.5 h)

% -------------------------
% Ruido de medición
% -------------------------
rng(7);                     % semilla reproducible
sigma_mm = 2;           % desviación estándar del ruido en mm
drift_mm = 0.0003;          % deriva sistemática por hora (mm/h), opcional

% -------------------------
% Generación de datos
% -------------------------
rows = [];
for i = 1:numel(T_list)
    T = T_list(i);

    a_clean = a0_true + (k_true*(T^n_true)).*t;          % señal ideal
    a_drift = drift_mm * t;                               % deriva
    a_noise = sigma_mm * randn(size(t));                  % ruido gaussiano

    a_meas = a_clean + a_drift + a_noise;                 % "medición"

    % Construir tabla larga: una fila por medición
    Ti = T * ones(size(t));
    block = table(Ti, t, a_meas, ...
        'VariableNames', {'T_C','t_h','a_mm'});

    rows = [rows; block]; %#ok<AGROW>
end

% Guardar CSV
fname = 'datos_ejercicio.csv';
writetable(rows, fname);

disp(['CSV generado: ', fname]);
disp('Columnas: T_C, t_h, a_mm (medida), a_clean_mm (ideal sin ruido)');

% Vista rápida
figure; hold on; grid on;
temps = unique(rows.T_C);
for i = 1:numel(temps)
    idx = rows.T_C == temps(i);
    plot(rows.t_h(idx), rows.a_mm(idx), '.', 'DisplayName', sprintf('T=%d°C', temps(i)));
end
xlabel('Tiempo (h)');
ylabel('Longitud de grieta a (mm)');
title('Datos sintéticos tipo experimento (ground truth con ruido)');
legend('Location','northwest');
```

### Script de simulación

```matlab
% ejercicio_evaluar_modelo.m
% Objetivo didáctico: partir de datos experimentales sintéticos,
% proponer un modelo sencillo y cuantificar su ajuste/precisión.

clear; clc; close all;

% -------------------------
% 1) Cargar datos
% -------------------------
D = readtable('datos_ejercicio.csv');
T = D.T_C;     % °C
t = D.t_h;     % h
a = D.a_mm;    % mm (medida)

% -------------------------
% 2) Propuesta de modelo (candidato)
% -------------------------
% Propuesta mínima (misma que originó los datos): a(t) = a0 + k*T^n*t
% Aquí NO ajustamos: usamos valores propuestos/estimados a mano.
a0 = 0.10;      % mm (propuesto)
k  = 1.2e-8;    % mm/h/°C^n (propuesto)
n  = 3.1;       % (propuesto)

a_hat = a0 + (k*(T.^n)).*t;

% -------------------------
% 3) Métricas de ajuste / error
% -------------------------
err = a - a_hat;

MAE  = mean(abs(err));
RMSE = sqrt(mean(err.^2));

% MAPE puede explotar si a ~ 0 o cambia de signo; lo hacemos robusto
eps0 = 1e-6;
MAPE = mean(abs(err) ./ max(abs(a), eps0)) * 100;

% R² global
SSE = sum(err.^2);
SST = sum((a - mean(a)).^2);
R2  = 1 - SSE/SST;

fprintf('\n=== Ajuste del modelo propuesto ===\n');
fprintf('MAE  = %.6f mm\n', MAE);
fprintf('RMSE = %.6f mm\n', RMSE);
fprintf('MAPE = %.3f %%\n', MAPE);
fprintf('R^2  = %.4f\n', R2);

% -------------------------
% 4) Gráficas: datos vs modelo por temperatura
% -------------------------
figure; hold on; grid on;
temps = unique(T);

for i = 1:numel(temps)
    Ti = temps(i);
    idx = (T == Ti);

    % datos
    plot(t(idx), a(idx), '.', 'DisplayName', sprintf('Datos %d°C', Ti));

    % modelo (línea)
    tgrid = linspace(min(t(idx)), max(t(idx)), 200)';
    agrid = a0 + (k*(Ti^n)).*tgrid;
    plot(tgrid, agrid, '-', 'HandleVisibility', 'off');
end

xlabel('Tiempo (h)');
ylabel('Longitud de grieta a (mm)');
title('Datos experimentales sintéticos vs modelo propuesto');
legend('Location','northwest');

% -------------------------
% 5) Opcional: tabla resumen por temperatura
% -------------------------
MAE_T  = zeros(size(temps));
RMSE_T = zeros(size(temps));

for i = 1:numel(temps)
    idx = (T == temps(i));
    e = (a(idx) - a_hat(idx));
    MAE_T(i)  = mean(abs(e));
    RMSE_T(i) = sqrt(mean(e.^2));
end

resumen = table(temps, MAE_T, RMSE_T, 'VariableNames', {'T_C','MAE_mm','RMSE_mm'});
disp('--- Resumen por temperatura ---');
disp(resumen);

writetable(resumen, 'resumen_error_por_T.csv');
disp('Guardado: resumen_error_por_T.csv');
```

---

### Discusión guiada

* ¿Cómo puede R² ser casi 1 si el error es enorme?

# Tarea

## Caso

Un material polimérico presenta degradación térmica que sigue una tasa proporcional a la temperatura. Formula un modelo matemático, simula el proceso durante 8 horas para tres temperaturas distintas y discute el alcance del modelo.

### Requisitos

* Modelo matemático
* Simulación en Matlab
* Análisis crítico
* Entrega en **PDF (LaTeX)**


# Actividad de gamificación

### **“El modelo correcto”**

* Se forman 2 equipos
* Se proyectan **2 modelos matemáticos** distintos para el mismo fenómeno
* Cada equipo:

  * Identifica **supuestos**
  * Decide **cuál usaría y por qué**
* Gana el equipo con **mejor justificación técnica**, no el más complejo

