% gen_nylon66.m
% Datos sinteticos ensayo de tension nylon 66 a 23 C

clear; clc;

E_true     = 2800;   % MPa
sigma_y    = 55;     % MPa (esfuerzo de referencia)
alpha_true = 0.45;
n_true     = 3.8;

rng(13);
sigma_vec = linspace(0, 1.6*sigma_y, 70)';   % MPa

eps_clean = sigma_vec/E_true + ...
            alpha_true*(sigma_y/E_true)*(sigma_vec/sigma_y).^n_true;

eps_ruido = 0.012 * max(eps_clean) * randn(size(sigma_vec));
eps_meas  = eps_clean + eps_ruido;

T = table(eps_meas, sigma_vec, ...
    'VariableNames', {'epsilon', 'sigma_MPa'});
writetable(T, 'ensayo_nylon66.csv');
disp('Generado: ensayo_nylon66.csv');
