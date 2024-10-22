% VaR - Monte Carlo Simülasyonu ile Risk Yönetimi
clear; clc; close all;

% Parametreler
portfolio_value = 1e6; % Portföy değeri (TL)
mu = 0.12;  % Beklenen yıllık getiri
sigma = 0.25;  % Yıllık volatilite
T = 1/252;  % 1 günlük zaman dilimi
confidence_level = 0.95;  % %95 güven seviyesi

% Monte Carlo simülasyonu
num_simulations = 10000;  % Simülasyon sayısı
random_returns = normrnd(mu * T, sigma * sqrt(T), num_simulations, 1);
future_values = portfolio_value * (1 + random_returns);

% VaR hesaplama
VaR_95 = portfolio_value - prctile(future_values, 100 * (1 - confidence_level));
expected_shortfall = portfolio_value - mean(future_values(future_values < prctile(future_values, 100 * (1 - confidence_level))));

% Sonuçların gösterimi
disp(['1 Günlük %95 VaR: ', num2str(VaR_95), ' TL']);
disp(['1 Günlük Beklenen Zarar: ', num2str(expected_shortfall), ' TL']);

% Grafiksel gösterim
figure;
histogram(future_values, 50, 'Normalization', 'pdf');
hold on;
xline(portfolio_value - VaR_95, 'r', 'LineWidth', 2);
xline(portfolio_value - expected_shortfall, 'b', 'LineWidth', 2);
xlabel('Portföy Değeri (TL)');
ylabel('Olasılık Yoğunluğu');
legend('Simülasyonlar', 'VaR %95', 'Beklenen Zarar');
title('Monte Carlo Simülasyonu ile VaR Hesaplaması');
grid on;
