% ajuste_ramberg_osgood.m
% Ajusta modelo Ramberg-Osgood a datos de ensayo de tension
% Residuales en espacio epsilon (el modelo es explicito: eps = f(sigma))

clear; clc; close all;

% 1) Cargar datos
D     = readtable('ensayo_316L.csv');
sigma = D.sigma_MPa;
eps   = D.epsilon;

% 2) Fijar E (misma estimacion que bilineal)
idx_e  = sigma < 50 & sigma > 0;
p      = polyfit(sigma(idx_e), eps(idx_e), 1);
E_fijo = 1 / p(1);
fprintf('E fijo = %.1f MPa\n', E_fijo);

% 3) Modelo R-O: eps = sigma/E + alpha*(sigma_y/E)*(sigma/sigma_y)^n
%    Parametros libres: [alpha, sigma_y, n]
modelo = @(par, sig) sig/E_fijo + par(1)*(par(2)/E_fijo).*(sig./par(2)).^par(3);

% 4) Ajuste con lsqnonlin
resfun = @(par) modelo(par, sigma) - eps;

p0 = [3/7, 180, 5];         % punto inicial: [alpha, sigma_y, n]
lb = [0.01,  50,  1.5];
ub = [5.00, 400, 20.0];

opts  = optimoptions('lsqnonlin', 'Display', 'off', 'MaxFunctionEvaluations', 5000);
p_hat = lsqnonlin(resfun, p0, lb, ub, opts);

alpha_hat   = p_hat(1);
sigma_y_hat = p_hat(2);
n_hat       = p_hat(3);

% 5) Evaluar y calcular metricas
eps_ro = modelo(p_hat, sigma);
err    = eps - eps_ro;
RMSE   = sqrt(mean(err.^2));
R2     = 1 - sum(err.^2) / sum((eps - mean(eps)).^2);

fprintf('\n=== Parametros estimados ===\n');
fprintf('alpha   = %.4f\n', alpha_hat);
fprintf('sigma_y = %.2f MPa\n', sigma_y_hat);
fprintf('n       = %.3f\n', n_hat);
fprintf('\n=== Metricas (espacio epsilon) ===\n');
fprintf('RMSE = %.6f\n', RMSE);
fprintf('R2   = %.4f\n', R2);

% 6) Grafica
figure; hold on; grid on;
plot(eps*100,    sigma, 'o', 'MarkerSize', 4, 'DisplayName', 'Datos');
plot(eps_ro*100, sigma, '-', 'LineWidth', 2, 'DisplayName', 'Ramberg-Osgood');
xlabel('Deformacion (%)'); ylabel('Esfuerzo (MPa)');
title('Ajuste Ramberg-Osgood - Acero 316L 600 C');
legend; xlim([0 max(eps)*100]); ylim([0 inf]);
