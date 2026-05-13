% gen_316L.m
% Datos sinteticos de curva sigma-epsilon para acero 316L a 600 C
% Modelo real: Ramberg-Osgood parametrizado en sigma

clear; clc; close all;

% Parametros "verdaderos" (tipicos de literatura para 316L a 600 C)
E_true     = 150e3;  % MPa  (modulo a 600 C, reducido vs temperatura ambiente)
sigma_y    = 180;    % MPa  (esfuerzo de referencia)
alpha_true = 3/7;    % coeficiente de plasticidad (valor clasico)
n_true     = 5.0;    % exponente de endurecimiento

% Rango de esfuerzos: de 0 a 1.5*sigma_y
rng(42);
sigma_vec = linspace(0, 1.5*sigma_y, 80)';   % MPa

% Deformacion del modelo R-O: epsilon = sigma/E + alpha*(sigma_y/E)*(sigma/sigma_y)^n
eps_clean = sigma_vec/E_true + ...
            alpha_true*(sigma_y/E_true)*(sigma_vec/sigma_y).^n_true;

% Ruido en deformacion (1.5% de la deformacion maxima)
eps_ruido = 0.015 * max(eps_clean) * randn(size(sigma_vec));
eps_meas  = eps_clean + eps_ruido;

% Guardar CSV
T = table(eps_meas, eps_clean, sigma_vec, ...
    'VariableNames', {'epsilon', 'epsilon_clean', 'sigma_MPa'});
writetable(T, 'ensayo_316L.csv');
disp('Generado: ensayo_316L.csv');

% Grafica
figure; hold on; grid on;
plot(eps_clean*100, sigma_vec, '-', 'LineWidth', 2, 'DisplayName', 'Curva real');
plot(eps_meas*100,  sigma_vec, 'o', 'MarkerSize', 4, 'DisplayName', 'Datos medidos');
xlabel('Deformacion (%)'); ylabel('Esfuerzo (MPa)');
title('Ensayo sintetico - Acero 316L a 600 C');
legend; xlim([0 inf]); ylim([0 inf]);
