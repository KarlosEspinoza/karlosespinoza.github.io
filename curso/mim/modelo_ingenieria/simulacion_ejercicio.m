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
