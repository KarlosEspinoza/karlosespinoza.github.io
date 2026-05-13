---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../../index)

# Modelos no lineales elementales

## Objetivo

Al finalizar la sesión, el estudiante **identificará y aplicará modelos no lineales elementales** para describir el comportamiento mecánico de materiales más allá del régimen elástico, distinguiendo entre el **modelo bilineal elastoplástico** y el **modelo de Ramberg–Osgood**, ajustará ambos a datos experimentales sintéticos en Matlab y comparará su desempeño mediante métricas cuantitativas.

---

## Método de enseñanza

**Aprendizaje Basado en Problemas (ABP) + Modelación Computacional Activa**

- El caso guía toda la sesión: el modelo se construye en respuesta a una necesidad real de ingeniería.
- La teoría se introduce progresivamente según lo exige el caso.
- El ejercicio computacional consolida la diferencia práctica entre los dos modelos.

---

## Criterios de evaluación

| Criterio | Descripción | Peso |
|---|---|---|
| Identificación del modelo | Justificación técnica de qué modelo usar y cuándo | 25% |
| Implementación computacional | Scripts funcionales y estructurados en Matlab | 35% |
| Ajuste de parámetros | Estimación correcta con error cuantificado (RMSE, R²) | 25% |
| Análisis e interpretación | Comparación de modelos y discusión de limitaciones | 15% |

---

# Desarrollo del tema

## Caso ejemplo

Un equipo de investigación necesita caracterizar el comportamiento mecánico de un **acero inoxidable 316L** destinado a componentes estructurales de reactores nucleares de IV generación, que operarán a temperaturas cercanas a 600 °C. Los ensayos de tensión muestran que, más allá del límite de fluencia convencional (~180 MPa a esa temperatura), la curva esfuerzo–deformación es claramente no lineal: el material se endurece de forma progresiva con una curvatura suave. El modelo elástico lineal desarrollado en la sesión anterior subestima fuertemente las deformaciones en la zona plástica y no puede usarse para dimensionar el componente. El equipo propone evaluar dos modelos candidatos: uno **bilineal** (rápido de calibrar, útil para estimaciones de primera vuelta) y uno continuo de **Ramberg–Osgood** (más preciso, requerido para validar simulaciones por elemento finito). Ambos modelos deben ajustarse a los datos experimentales disponibles y evaluarse con métricas de error para justificar su elección.

---

## Modelo 1: Bilineal elastoplástico

**Idea central**: aproximar la curva $\sigma$–$\varepsilon$ completa con dos segmentos lineales: uno elástico (pendiente $E$) y uno plástico (pendiente $E_t < E$).

$$
\varepsilon(\sigma) = \begin{cases}
\dfrac{\sigma}{E} & \sigma \leq \sigma_y \\[8pt]
\varepsilon_y + \dfrac{\sigma - \sigma_y}{E_t} & \sigma > \sigma_y
\end{cases}
$$

donde:

- $E$: módulo de Young (zona elástica)
- $\sigma_y$: esfuerzo de fluencia
- $\varepsilon_y = \sigma_y / E$: deformación de fluencia
- $E_t$: módulo tangente plástico ($0 \leq E_t < E$)

**Casos límite:**

| $E_t$ | Interpretación física |
|---|---|
| $E_t = 0$ | Perfectamente plástico (sin endurecimiento) |
| $0 < E_t < E$ | Endurecimiento lineal por deformación |
| $E_t = E$ | Lineal continuo (sin fluencia) |

**Relación con el caso**: permite una estimación rápida del comportamiento del 316L con solo tres parámetros ($E$, $\sigma_y$, $E_t$). La debilidad es que la transición en $\sigma_y$ es abrupta (discontinuidad de pendiente), lo que introduce artificios numéricos en simulaciones de elemento finito.

---

## Modelo 2: Ramberg–Osgood

**Idea central**: ecuación continua que suma la deformación elástica y la plástica en una sola expresión, sin discontinuidad de pendiente.

$$
\varepsilon = \frac{\sigma}{E} + \alpha \frac{\sigma_y}{E} \left(\frac{\sigma}{\sigma_y}\right)^n
$$

donde:

- $E$: módulo de Young
- $\sigma_y$: esfuerzo de referencia (aproxima el límite de fluencia)
- $\alpha$: coeficiente de plasticidad (amplitud de la región no lineal)
- $n$: exponente de endurecimiento ($n > 1$; mayor $n$ → transición más abrupta)

El primer término $\sigma/E$ es la deformación elástica; el segundo término es la deformación plástica no lineal.

**Límite asintótico**: cuando $n \to \infty$, el modelo converge al bilineal perfectamente plástico ($E_t = 0$).

**Relación con el caso**: captura la curvatura suave de la curva $\sigma$–$\varepsilon$ del 316L de forma continua y diferenciable, lo que es indispensable para integrarlo en códigos de elemento finito. Requiere cuatro parámetros y un ajuste numérico no lineal.

---

## Comparación de modelos

| Característica | Bilineal | Ramberg–Osgood |
|---|---|---|
| Parámetros | 3 ($E$, $\sigma_y$, $E_t$) | 4 ($E$, $\sigma_y$, $\alpha$, $n$) |
| $\varepsilon = f(\sigma)$ | Explícita (lineal por tramos) | Explícita (ley de potencia) |
| Continuidad | $C^0$ (kink en $\sigma_y$) | $C^\infty$ (curva suave) |
| Ajuste a datos reales | Aproximado | Más preciso |
| Complejidad de calibración | Regresión lineal por zonas | Mínimos cuadrados no lineales |
| Uso típico | Estimación rápida, FEM simple | Validación, FEM avanzado |

> Ambos modelos expresan $\varepsilon$ como función explícita de $\sigma$. Esto es natural para Ramberg–Osgood y corresponde a la **forma inversa** del bilineal. La ventaja: los residuales de ajuste pueden calcularse en el mismo espacio ($\varepsilon$) para ambos modelos, haciendo comparables las métricas RMSE y R².

---

# Ejercicio en clase

Dado un ensayo sintético de un acero 316L a 600 °C, ajusta ambos modelos y compara su capacidad de representar los datos.

## Script 1: Generación de datos sintéticos

Guarda como `gen_316L.m` y ejecútalo primero. Genera `ensayo_316L.csv`.

```matlab
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
```

---

## Script 2: Ajuste del modelo bilineal

Guarda como `ajuste_bilineal.m`.

```matlab
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

% 3) Esfuerzo de fluencia: metodo del 0.2% offset
% La linea offset tiene pendiente 1/E y pasa por eps = 0.002
% Interseccion con la curva: buscar donde eps_datos = eps_offset
eps_offset = sigma/E_est + 0.002;   % linea desplazada 0.2%
dif = eps - eps_offset;
idx_cross = find(dif(1:end-1) .* dif(2:end) <= 0, 1);
if isempty(idx_cross)
    idx_cross = round(numel(sigma)*0.45);
end

sigma_y_est = sigma(idx_cross);
eps_y_est   = sigma_y_est / E_est;
fprintf('sigma_y estimado = %.2f MPa (offset 0.2%%)\n', sigma_y_est);

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
```

---

## Script 3: Ajuste del modelo Ramberg–Osgood

Guarda como `ajuste_ramberg_osgood.m`.

```matlab
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

% 4) Ajuste con lsqnonlin (Optimization Toolbox)
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
```

---

## Discusión guiada

- ¿Por qué el R² del bilineal puede ser alto si visualmente la "rodilla" no ajusta bien?
- ¿En qué región de la curva cada modelo tiene mayor error?
- ¿Cuándo usarías el bilineal y cuándo el Ramberg–Osgood en un proyecto de investigación?
- Si aumentas $n$ en el modelo R-O generador, ¿qué le pasa a la curva? ¿y si aumentas $\alpha$?

---

# Ejercicio de tarea

## Caso

Un laboratorio de polímeros ha caracterizado un **nylon 66** (poliamida 66) a temperatura ambiente mediante ensayo de tensión uniaxial. La curva muestra una transición suave desde el régimen elástico hacia la zona plástica, sin un límite de fluencia claramente definido. El material se emplea en conectores de precisión donde la deformación no debe superar el 2%. El equipo requiere:

1. Estimar los parámetros del modelo Ramberg–Osgood usando los datos del archivo `ensayo_nylon66.csv` (generado con el script adjunto).
2. Evaluar si el modelo bilineal también describe adecuadamente este material.
3. Determinar el **esfuerzo máximo admisible** tal que la deformación total no exceda $\varepsilon = 0.02$ usando el modelo R-O ajustado (requiere despejar $\sigma$ de forma numérica con `fzero`).
4. Reportar en tabla los parámetros ajustados, RMSE y R² de ambos modelos.
5. Concluir en 5–7 líneas qué modelo recomendaría para este material y por qué.

### Script para generar datos de la tarea

Guarda como `gen_nylon66.m` y ejecútalo para obtener `ensayo_nylon66.csv`.

```matlab
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
```

### Estructura del PDF (LaTeX)

- Introducción (contexto del material y restricción de diseño, 3–4 líneas)
- Metodología (estimación de E, criterio de ajuste, solver inverso)
- Resultados (tabla de parámetros + gráfica comparativa)
- Determinación del $\sigma_{max}$ para $\varepsilon \leq 0.02$
- Conclusiones (qué modelo recomienda, limitaciones)

---

# Actividad de gamificación

### "Identifica el modelo" (5–8 min)

**Dinámica**: El profesor proyecta **4 curvas $\sigma$–$\varepsilon$ anónimas** generadas con distintos parámetros. Los equipos identifican en 60 segundos qué tipo de modelo es y estiman a ojo el parámetro clave.

**Equipos**: 2–3 equipos.

| Ronda | Pregunta | Tiempo | Puntos |
|---|---|---|---|
| 1 | ¿Cuál curva es bilineal y cuál R-O? Argumenta. | 60 s | 2 pts |
| 2 | Para la curva bilineal proyectada, estima $\sigma_y$ y $E_t$ solo con la gráfica (±20% cuenta). | 60 s | 2 pts |
| 3 | Se muestran 3 curvas R-O con distinto $n$. Ordénalas de menor a mayor $n$. | 60 s | 2 pts |

**Pista para ronda 1**: el bilineal tiene una "rodilla" visible; el R-O es siempre suave.

**Gana** el equipo con más puntos. En caso de empate, desempate por rapidez de respuesta.
