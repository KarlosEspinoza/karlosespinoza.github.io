---
layout: default
title: Matemáticas para Ingeniería de Materiales
---
[Inicio](../../index)

# Modelo constitutivo elástico

## Objetivo

Al finalizar la sesión, el estudiante **modelará el comportamiento elástico lineal** de un material a partir de datos experimentales, **identificando** el modelo constitutivo apropiado (1D y forma isotrópica 3D/2D), **estimando** (E) y (\nu), y **aplicando** la relación esfuerzo–deformación para predecir respuesta bajo cargas simples.

## Método de enseñanza

**Aprendizaje Basado en Problemas (ABP) + mini-demostración guiada**


## Criterios de evaluación (entregables de clase)

**Entregable (en clase, 1 PDF corto o 1 hoja + scripts):**

1. **Selección del modelo (20%)**: justificación clara de por qué el tramo elástico se modela como lineal; supuestos (isotropía, pequeñas deformaciones, etc.).
2. **Estimación de parámetros (30%)**: cálculo de (E) y (\nu) con método reproducible (regresión/pendiente) y unidades correctas.
3. **Aplicación del modelo (30%)**: predicción de esfuerzos/deformaciones para un estado 1D y un caso 2D (esfuerzo plano o deformación plana) con consistencia matemática.
4. **Calidad técnica (20%)**: código Matlab corre sin errores, gráficas correctas, interpretación breve y correcta (2–5 bullets).

---

# Desarrollo del tema 

## Caso ejemplo

Una empresa fabrica **soportes (brackets) de aluminio 6061-T6** a partir de lámina para un ensamble mecánico. Antes de liberar el diseño, el equipo debe asegurar que, bajo una carga estática, el soporte **no exceda el rango elástico** para evitar deformación permanente y que la **deflexión** sea aceptable. Se cuenta con datos de un **ensayo de tensión** (esfuerzo vs. deformación axial) y mediciones de **deformación transversal** (para estimar $\nu)$. Tu tarea es: estimar $E$ y $\nu$, definir el modelo constitutivo elástico adecuado y predecir la respuesta ante un estado de esfuerzos simple representativo del bracket.

## Conceptos/Modelos

### Esfuerzo y deformación

**Idea:** en el régimen elástico lineal trabajamos con deformaciones pequeñas y proporcionalidad.

* Esfuerzo axial: $\sigma = F/A$
* Deformación axial: $\varepsilon = \Delta L/L_0$

Del ensayo de tensión obtienes $\sigma–\varepsilon$ para identificar el tramo elástico donde la curva es casi recta.

### Ley de Hooke 1D

$$
\sigma = E,\varepsilon
$$

* $E$ = módulo de Young (pendiente en el tramo lineal)

Estimas $E$ con la pendiente de $\sigma$ vs $\varepsilon$ en el tramo elástico del 6061-T6. Con ese $E$ puedes predecir deflexiones y verificar “no fluencia” (por lo menos como primer filtro).

### Efecto Poisson

$$
\nu = -\frac{\varepsilon_\text{transversal}}{\varepsilon_\text{axial}}
$$

Usando mediciones de deformación transversal durante el ensayo, calculas $\nu$. Esto te permite pasar de un modelo 1D a un **modelo isotrópico** consistente (necesario si usas un estado 2D/3D).

### Elasticidad lineal isotrópica

En materiales isotrópicos y lineales, con $E$ y $\nu$ defines completamente el modelo. Dos módulos derivados comunes:

$$
G=\frac{E}{2(1+\nu)},\qquad
K=\frac{E}{3(1-2\nu)}
$$

Si tu bracket trabaja con cortante relevante o compresión volumétrica (contactos/ensamble), $G$ y $K$ ayudan a completar el panorama del comportamiento elástico.

### Forma matricial 2D (esfuerzo plano)

Para láminas delgadas suele usarse **esfuerzo plano** $(\sigma_z \approx 0)$. La relación constitutiva en 2D se escribe:

$$
\begin{bmatrix}\sigma_x\ \sigma_y\ \tau_{xy}\end{bmatrix} = 
\underbrace{
\frac{E}{1-\nu^2}
\begin{bmatrix}
1 & \nu & 0\\
\nu & 1 & 0\\
0 & 0 & \frac{1-\nu}{2}
\end{bmatrix}
}_{\mathbf{D}_{\text{esfuerzo plano}}}
\begin{bmatrix}\varepsilon_x\ \varepsilon_y\ \gamma_{xy}\end{bmatrix}
$$

*{\mathbf{D}*{\text{esfuerzo plano}}}
**Relación con el caso:** el bracket de lámina puede aproximarse como esfuerzo plano en regiones lejos de concentraciones. Con (\mathbf{D}) puedes predecir (\varepsilon) o (\sigma) bajo una combinación simple de (\sigma_x,\sigma_y,\tau_{xy}).

## Ejercicio

### Instrucciones

1. Cargar datos $\sigma–\varepsilon$ y $\varepsilon_t$ (transversal) desde CSV.
2. Identificar un rango elástico (por ejemplo $\varepsilon\le 0.0015$ o por selección automática simple).
3. Estimar $E$ con regresión lineal en el rango elástico.
4. Estimar $\nu$ con promedio (o regresión) de $-\varepsilon_t/\varepsilon$ en el rango elástico.
5. Calcular $G$ y $K$.
6. **Predicción 1D:** para una carga $F$ y área $A$, predecir $\varepsilon$ y $\Delta L$.
7. **Predicción 2D (esfuerzo plano):** dado un estado $(\sigma_x,\sigma_y,\tau_{xy})$, calcular $(\varepsilon_x,\varepsilon_y,\gamma_{xy})$.

---

## Datos: CSV (generación)

### Matlab genera el CSV

Guarda como `gen_datos_ensayo_6061.m` y ejecútalo. Te crea `ensayo_6061.csv`.

```matlab
% gen_datos_ensayo_6061.m
% Genera datos sintéticos realistas (elásticos) para un 6061-T6
clear; clc;

E_true  = 69e9;     % Pa
nu_true = 0.33;

% Deformación axial (0 a 0.002)
eps_ax = linspace(0, 0.0020, 120)';

% Esfuerzo elástico: sigma = E*eps + ruido pequeño
sigma = E_true .* eps_ax .* (1 + 0.01*randn(size(eps_ax))); % 1% ruido

% Deformación transversal: eps_t = -nu*eps_ax + ruido
eps_tr = -nu_true .* eps_ax .* (1 + 0.02*randn(size(eps_ax))); % 2% ruido

T = table(eps_ax, eps_tr, sigma, 'VariableNames', ...
    {'epsilon_axial','epsilon_transversal','sigma_Pa'});

writetable(T, 'ensayo_6061.csv');
disp('Listo: ensayo_6061.csv');
```

---

## Script 1: estimar $E$ y $\nu$ + gráficas

Guarda como `ajuste_elastico.m`.

```matlab
% ajuste_elastico.m
clear; clc; close all;

% 1) Cargar datos
T = readtable('ensayo_6061.csv');
eps  = T.epsilon_axial;
epsT = T.epsilon_transversal;
sig  = T.sigma_Pa;

% 2) Definir rango elástico (simple y controlable)
% Ajusta este umbral si quieres:
eps_max_elast = 0.0015;
idx = eps <= eps_max_elast & eps > 0; % evita eps=0 para nu

eps_e  = eps(idx);
sig_e  = sig(idx);
epsT_e = epsT(idx);

% 3) Estimar E con regresión lineal sig = E*eps + b
p = polyfit(eps_e, sig_e, 1);
E_est = p(1);
b_est = p(2);

% 4) Estimar nu con promedio de -epsT/eps (o regresión)
nu_i = -epsT_e ./ eps_e;
nu_est = mean(nu_i);

% 5) Derivados
G_est = E_est/(2*(1+nu_est));
K_est = E_est/(3*(1-2*nu_est));

% 6) Reporte en consola
fprintf('--- Estimación parámetros elásticos ---\n');
fprintf('E_est  = %.3f GPa\n', E_est/1e9);
fprintf('nu_est = %.4f\n', nu_est);
fprintf('G_est  = %.3f GPa\n', G_est/1e9);
fprintf('K_est  = %.3f GPa\n', K_est/1e9);
fprintf('Intercepto (ideal ~0): b = %.3e Pa\n', b_est);

% 7) Gráficas
figure; 
plot(eps, sig/1e6, 'o'); grid on;
xlabel('\epsilon axial'); ylabel('\sigma (MPa)');
title('Ensayo tensión: \sigma vs \epsilon');

% Línea ajustada
hold on;
sig_fit = polyval(p, eps_e);
plot(eps_e, sig_fit/1e6, '-', 'LineWidth', 2);
legend('Datos','Ajuste elástico');

figure;
plot(eps_e, nu_i, 'o'); grid on;
xlabel('\epsilon axial (rango elástico)'); ylabel('\nu_i = -\epsilon_t/\epsilon');
title('Estimación de Poisson en el rango elástico');
yline(nu_est, '--', 'LineWidth', 2);
legend('Muestras','Promedio');
```

## Script 2: aplicar el modelo al caso (predicciones 1D y 2D)

Guarda como `predicciones_bracket.m`.

```matlab
% predicciones_bracket.m
clear; clc;

% Carga E y nu desde el script anterior (o repite lectura/estimación)
% Aquí, por simplicidad, leeremos y estimaremos rápido:
T = readtable('ensayo_6061.csv');
eps  = T.epsilon_axial;
epsT = T.epsilon_transversal;
sig  = T.sigma_Pa;

eps_max_elast = 0.0015;
idx = eps <= eps_max_elast & eps > 0;

p = polyfit(eps(idx), sig(idx), 1);
E  = p(1);
nu = mean( -epsT(idx) ./ eps(idx) );

% --- Predicción 1D (barra equivalente del bracket) ---
% Supón: una “sección equivalente” A y una longitud efectiva L0
F  = 1200;      % N (ejemplo)
A  = 30e-6;     % m^2 (30 mm^2)
L0 = 50e-3;     % m (50 mm)

sigma_1D = F/A;          % Pa
eps_1D   = sigma_1D/E;   % -
dL       = eps_1D*L0;    % m

fprintf('--- Predicción 1D ---\n');
fprintf('sigma = %.2f MPa\n', sigma_1D/1e6);
fprintf('eps   = %.6f\n', eps_1D);
fprintf('dL    = %.3f mm\n', dL*1e3);

% --- Predicción 2D (esfuerzo plano) ---
% Estado de esfuerzos representativo en una zona del bracket (ejemplo):
sigma_x = 80e6;   % Pa
sigma_y = 20e6;   % Pa
tau_xy  = 15e6;   % Pa

% Matriz D de esfuerzo plano
D = (E/(1-nu^2)) * [ 1, nu, 0;
                    nu, 1, 0;
                    0,  0, (1-nu)/2 ];

% Resolver para deformaciones: [epsx; epsy; gamxy] = inv(D)*[sigx; sigy; tauxy]
sig_vec = [sigma_x; sigma_y; tau_xy];
eps_vec = D \ sig_vec;

eps_x = eps_vec(1);
eps_y = eps_vec(2);
gam_xy = eps_vec(3);

fprintf('\n--- Predicción 2D (esfuerzo plano) ---\n');
fprintf('eps_x  = %.6e\n', eps_x);
fprintf('eps_y  = %.6e\n', eps_y);
fprintf('gamma_xy = %.6e\n', gam_xy);
```

**Qué entregan al final (en clase):**

* Valores estimados $E,\nu,G,K$ (con unidades)
* 2 gráficas (ajuste elástico y $\nu$ vs $\varepsilon$)
* Predicción 1D y 2D con interpretación corta:

  * ¿La $\sigma$ 1D está claramente dentro del rango elástico usado?
  * ¿El orden de magnitud de deformaciones 2D tiene sentido?


# Ejercicio de tarea

## Caso (tarea)

Se diseña un **tirante de aluminio 6061-T6** para un sub-ensamble ligero. El tirante trabaja principalmente a tensión, pero en una zona de unión (placa delgada) se aproxima **esfuerzo plano**.

1. Con el archivo `ensayo_6061.csv`, estima $E$ y $\nu$ usando un criterio razonable de rango elástico (explica tu criterio).
2. **Parte A (1D):** para $F=1800\ \text{N}$, $A=25\ \text{mm}^2$, $L_0=80\ \text{mm}$, calcula $\sigma,\varepsilon,\Delta L$.
3. **Parte B (2D, esfuerzo plano):** en la placa, asume $\sigma_x=90\ \text{MPa}$, $\sigma_y=35\ \text{MPa}$, $\tau_{xy}=10\ \text{MPa}$. Calcula $\varepsilon_x,\varepsilon_y,\gamma_{xy}$.
4. Concluye en 5–7 líneas: validez del modelo y limitaciones (linealidad, isotropía, concentración de esfuerzos, etc.).

### Datos para la tarea

Usan **el mismo `ensayo_6061.csv`** (generado en clase)

### Estructura mínima del PDF (LaTeX)

* Introducción (2–3 líneas)
* Metodología (rango elástico + estimación (E,\nu))
* Resultados (tabla corta + 1 figura)
* Cálculos (1D y 2D)
* Conclusiones (limitaciones)


