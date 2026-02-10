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
