% Risk Parity Portföy Optimizasyonu
clear; clc; close all;

% Parametreler
n_assets = 5;  % Varlık sayısı
cov_matrix = [0.04 0.01 0.02 0.01 0.02;
              0.01 0.05 0.01 0.02 0.01;
              0.02 0.01 0.06 0.01 0.02;
              0.01 0.02 0.01 0.07 0.01;
              0.02 0.01 0.02 0.01 0.08]; % Kovaryans matrisi

% Başlangıç portföy ağırlıkları (eşit dağılım)
initial_weights = ones(n_assets, 1) / n_assets;

% Risk katkısı hesaplama fonksiyonu
risk_contributions = @(w) (w .* (cov_matrix * w)) / (w' * cov_matrix * w);

% Risk Parity optimizasyon fonksiyonu
objective_function = @(w) sum((risk_contributions(w) - 1/n_assets).^2);

% Ağırlık sınırları ve kısıtlar
LB = zeros(n_assets, 1);
UB = ones(n_assets, 1);
Aeq = ones(1, n_assets);
beq = 1;

% Optimizasyon
options = optimoptions('fmincon', 'Display', 'off');
optimal_weights = fmincon(objective_function, initial_weights, [], [], Aeq, beq, LB, UB, [], options);

% Sonuçlar
disp('Risk Parity Portföy Ağırlıkları:');
disp(optimal_weights');

% Risk katkılarını kontrol etme
final_risk_contributions = risk_contributions(optimal_weights);
disp('Risk Katkıları:');
disp(final_risk_contributions');

% Portföyün beklenen riski (standart sapma)
portfolio_risk = sqrt(optimal_weights' * cov_matrix * optimal_weights);
disp(['Portföy Riski: ', num2str(portfolio_risk)]);
