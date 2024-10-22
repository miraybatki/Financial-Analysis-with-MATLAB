% Gelişmiş Portföy Optimizasyonu: Markowitz, Black-Litterman, Risk Parity
clear; clc; close all;

% 1. Veri Hazırlığı: Varlık getirileri ve kovaryans matrisi (örnek veriler)
n_assets = 6;  % Varlık sayısı
mu = [0.10 0.12 0.08 0.07 0.09 0.11]';  % Beklenen getiriler
cov_matrix = [0.05 0.02 0.01 0.01 0.02 0.01;
              0.02 0.06 0.02 0.02 0.01 0.01;
              0.01 0.02 0.07 0.01 0.02 0.02;
              0.01 0.02 0.01 0.08 0.01 0.02;
              0.02 0.01 0.02 0.01 0.09 0.01;
              0.01 0.01 0.02 0.02 0.01 0.1];

% 2. Markowitz Portföy Optimizasyonu
target_return = 0.09;  % Hedeflenen getiri
H = 2 * cov_matrix;  % Hedef fonksiyonun ikinci dereceden terimi
f = zeros(n_assets, 1);  % Lineer terim
Aeq = [ones(1, n_assets); mu'];  % Kısıtlar: ağırlıkların toplamı 1 ve belirli getiri
beq = [1; target_return];  % Eşitlik kısıtları
LB = zeros(n_assets, 1);  % Alt sınır
UB = ones(n_assets, 1);  % Üst sınır
[weights_markowitz, ~] = quadprog(H, f, [], [], Aeq, beq, LB, UB);

% 3. Black-Litterman Modeli Optimizasyonu
tau = 0.05;  % Belirsizlik parametresi
P = [1 0 0 -1 0 0];  % Yatırımcı görüşü (örnek)
Q = [0.02];  % Yatırımcının getiri beklentisi
omega = diag([0.001]);  % Görüşlerin belirsizlik matrisi
Pi = cov_matrix * ones(n_assets, 1);  % Piyasa risk primi
sigma_bl = inv(inv(tau * cov_matrix) + P' * inv(omega) * P);  % BL Kovaryans
mu_bl = sigma_bl * (inv(tau * cov_matrix) * Pi + P' * inv(omega) * Q);  % BL Getiriler
[weights_bl, ~] = quadprog(H, f, [], [], Aeq, [1; mu_bl'], LB, UB);

% 4. Risk Parity Optimizasyonu
initial_weights = ones(n_assets, 1) / n_assets;  % Eşit dağılım
risk_contributions = @(w) (w .* (cov_matrix * w)) / (w' * cov_matrix * w);
objective_function = @(w) sum((risk_contributions(w) - 1/n_assets).^2);
optimal_weights_rp = fmincon(objective_function, initial_weights, [], [], Aeq, beq, LB, UB);

% 5. Sonuçlar ve Grafik Gösterimi
disp('Markowitz Ağırlıkları:'), disp(weights_markowitz');
disp('Black-Litterman Ağırlıkları:'), disp(weights_bl');
disp('Risk Parity Ağırlıkları:'), disp(optimal_weights_rp');
