Claro — lo que quieres es **un “experimento sintético”**: generar un CSV que parezca datos reales (ground truth con ruido) y luego **ajustar el modelo** para mostrar cómo “calza” con esos datos.

Abajo te dejo una versión lista para clase, con **2 scripts Matlab**:

1. `generar_ground_truth.m` → crea `ground_truth_experimento.csv`
2. `ajuste_y_simulacion.m` → estima parámetros del modelo y grafica ajuste vs datos

La idea: tenemos datos de **longitud de grieta a(t)** medidos a varias **temperaturas T**, y asumimos un modelo simple:

[
\frac{da}{dt}=k,T^n
\Rightarrow a(t)=a_0 + k,T^n,t
]

---

## 1) Script Matlab: generar CSV “ground truth” con ruido

Guárdalo como: **`generar_ground_truth.m`**

```matlab
% generar_ground_truth.m
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
sigma_mm = 0.004;           % desviación estándar del ruido en mm
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
    block = table(Ti, t, a_meas, a_clean, ...
        'VariableNames', {'T_C','t_h','a_mm','a_clean_mm'});

    rows = [rows; block]; %#ok<AGROW>
end

% Guardar CSV
fname = 'ground_truth_experimento.csv';
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

---

## 2) Script Matlab: ajustar (k,n,a0) y comparar simulación vs datos

Guárdalo como: **`ajuste_y_simulacion.m`**

Este script estima parámetros resolviendo mínimos cuadrados no lineales con `lsqnonlin` (Optimization Toolbox).
Si no tienes toolbox, abajo te pongo alternativa.

```matlab
% ajuste_y_simulacion.m
% Lee ground_truth_experimento.csv y ajusta el modelo:
% a(t) = a0 + k*T^n*t
% usando mínimos cuadrados no lineales.

clear; clc; close all;

fname = 'ground_truth_experimento.csv';
D = readtable(fname);

T = D.T_C;     % °C
t = D.t_h;     % h
a = D.a_mm;    % mm (medición)

% -------------------------
% Modelo (función)
% -------------------------
model = @(p, T, t) p(1) + (p(2) .* (T.^p(3))) .* t;  % p = [a0, k, n]

% -------------------------
% Ajuste (lsqnonlin)
% -------------------------
% p0: conjetura inicial razonable
p0 = [0.08, 1e-8, 3.0];

% límites (para evitar cosas absurdas)
lb = [0,   0,   0];
ub = [1.0, 1e-4, 10];

% residuales
resfun = @(p) model(p, T, t) - a;

opts = optimoptions('lsqnonlin', ...
    'Display','iter', ...
    'MaxFunctionEvaluations', 5000, ...
    'FunctionTolerance', 1e-12);

[p_hat, resnorm, residual, exitflag] = lsqnonlin(resfun, p0, lb, ub, opts);

a0_hat = p_hat(1);
k_hat  = p_hat(2);
n_hat  = p_hat(3);

fprintf('\n=== Parámetros estimados ===\n');
fprintf('a0 = %.5f mm\n', a0_hat);
fprintf('k  = %.3e mm/h/°C^n\n', k_hat);
fprintf('n  = %.3f\n', n_hat);
fprintf('resnorm = %.6f | exitflag = %d\n', resnorm, exitflag);

% -------------------------
% Métricas simples
% -------------------------
a_pred_all = model(p_hat, T, t);
SSE = sum((a - a_pred_all).^2);
SST = sum((a - mean(a)).^2);
R2  = 1 - SSE/SST;
RMSE = sqrt(mean((a - a_pred_all).^2));

fprintf('\n=== Calidad de ajuste ===\n');
fprintf('R^2  = %.4f\n', R2);
fprintf('RMSE = %.5f mm\n', RMSE);

% -------------------------
% Graficar: datos vs ajuste por temperatura
% -------------------------
figure; hold on; grid on;
temps = unique(T);
for i = 1:numel(temps)
    Ti = temps(i);
    idx = (T == Ti);

    % datos
    plot(t(idx), a(idx), '.', 'DisplayName', sprintf('Datos T=%d°C', Ti));

    % curva ajustada (misma malla temporal)
    tgrid = linspace(min(t(idx)), max(t(idx)), 100)';
    a_fit = model(p_hat, Ti*ones(size(tgrid)), tgrid);
    plot(tgrid, a_fit, '-', 'HandleVisibility','off');
end
xlabel('Tiempo (h)');
ylabel('Longitud de grieta a (mm)');
title('Ajuste del modelo a(t)=a0 + k*T^n*t vs datos (ground truth con ruido)');
legend('Location','northwest');

% -------------------------
% Guardar resultados de ajuste
% -------------------------
results = table(a0_hat, k_hat, n_hat, R2, RMSE, resnorm, exitflag, ...
    'VariableNames', {'a0_hat','k_hat','n_hat','R2','RMSE','resnorm','exitflag'});
writetable(results, 'parametros_ajustados.csv');
disp('Guardado: parametros_ajustados.csv');
```

---

## Si NO tienes Optimization Toolbox (alternativa rápida)

Puedes ajustar con `fminsearch` (base Matlab). No usa límites, pero funciona bien si pones una buena penalización:

```matlab
% alternativa_sin_toolbox.m
clear; clc; close all;

D = readtable('ground_truth_experimento.csv');
T = D.T_C; t = D.t_h; a = D.a_mm;

model = @(p) p(1) + (p(2) .* (T.^p(3))) .* t;

% costo SSE + penalización suave para mantener parámetros razonables
cost = @(p) sum((model(p) - a).^2) + 1e6*(p(2)<0) + 1e6*(p(3)<0) + 1e6*(p(1)<0);

p0 = [0.08, 1e-8, 3.0];
p_hat = fminsearch(cost, p0);

fprintf('a0=%.5f, k=%.3e, n=%.3f\n', p_hat(1), p_hat(2), p_hat(3));
```

---

## Cómo usar esto en clase (flujo didáctico de 90 min)

1. Ejecutan `generar_ground_truth.m` → obtienen CSV “experimental”
2. “Como no sabemos k y n, los estimamos” → ejecutan `ajuste_y_simulacion.m`
3. Discusión:

   * ¿Qué pasa si aumento el ruido `sigma_mm`?
   * ¿Qué tan identificable es `n` si el rango de T es pequeño?
   * ¿Cuándo el modelo lineal en tiempo deja de ser válido? (p. ej. si k depende de a)

---

Si quieres, lo subo un nivel (más realista para materiales): hacemos que la tasa dependa también de la grieta, por ejemplo
[
\frac{da}{dt}=k,T^n,a^m
]
y ahí sí el ajuste requiere integrar ODE y ajustar parámetros (muy buen ejemplo doctoral).

