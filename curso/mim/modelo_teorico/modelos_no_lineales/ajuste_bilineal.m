% ajuste_bilineal.m
% Ajusta modelo bilineal a datos de ensayo de tension
% Residuales en espacio epsilon: eps_modelo(sigma) - eps_datos

clear; clc; close all;

% 1) Cargar datos
D     = readtable('ensayo_316L.csv');
sigma = D.sigma_MPa;
eps   = D.epsilon;

% 2) Estimar E: pendiente inicial (sigma pequena, zona lineal)
idx_e = sigma < 50 & sigma > 0;
p     = polyfit(sigma(idx_e), eps(idx_e), 1);   % eps = (1/E)*sigma
E_est = 1 / p(1);
fprintf('E estimado = %.1f MPa\n', E_est);

% 3) Esfuerzo de fluencia: offset pequeno (0.05%)
% El 0.2% clasico sobreestima sigma_y cuando se ajusta a datos R-O, porque
% en R-O la deformacion plastica en sigma_y es alpha*(sigma_y/E) ~ 0.05%, no 0.2%.
% Un offset de 0.0005 encuentra el cruce cerca del sigma_y real del modelo.
eps_offset = sigma/E_est + 0.0005;
dif = eps - eps_offset;
idx_cross = find(dif(1:end-1) .* dif(2:end) <= 0, 1);
if isempty(idx_cross)
    idx_cross = round(numel(sigma)*0.45);
end

sigma_y_est = sigma(idx_cross);
eps_y_est   = sigma_y_est / E_est;
fprintf('sigma_y estimado = %.2f MPa (offset 0.05%%)\n', sigma_y_est);

% 4) Modulo tangente E_t: pendiente en zona plastica
idx_p = sigma > sigma_y_est;
if sum(idx_p) > 3
    pp = polyfit(sigma(idx_p), eps(idx_p), 1);
    Et_est = 1 / pp(1);
else
    Et_est = 0;
end
fprintf('Et estimado = %.1f MPa\n', Et_est);

% 5) Evaluar modelo bilineal (en espacio epsilon)
eps_bilin = zeros(size(sigma));
for i = 1:numel(sigma)
    if sigma(i) <= sigma_y_est
        eps_bilin(i) = sigma(i) / E_est;
    else
        eps_bilin(i) = eps_y_est + (sigma(i) - sigma_y_est) / Et_est;
    end
end

% 6) Metricas de ajuste
err  = eps - eps_bilin;
RMSE = sqrt(mean(err.^2));
R2   = 1 - sum(err.^2) / sum((eps - mean(eps)).^2);

fprintf('\n=== Metricas (espacio epsilon) ===\n');
fprintf('RMSE = %.6f\n', RMSE);
fprintf('R2   = %.4f\n', R2);

% 7) Grafica
figure; hold on; grid on;
plot(eps*100,        sigma, 'o', 'MarkerSize', 4, 'DisplayName', 'Datos');
plot(eps_bilin*100,  sigma, '-', 'LineWidth', 2, 'DisplayName', 'Bilineal');
plot(eps_offset*100, sigma, '--', 'LineWidth', 1, 'DisplayName', 'Linea 0.2% offset');
xline(eps_y_est*100, ':', 'epsilon_y');
xlabel('Deformacion (%)'); ylabel('Esfuerzo (MPa)');
title('Ajuste bilineal - Acero 316L 600 C');
legend; xlim([0 max(eps)*100]); ylim([0 inf]);
