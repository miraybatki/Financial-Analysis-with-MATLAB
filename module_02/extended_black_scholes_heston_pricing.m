% Opsiyon Fiyatlama - Genişletilmiş Black-Scholes ve Heston Modeli
clear; clc; close all;

% Black-Scholes Parametreleri
S0 = 100;  % Hisse fiyatı
K = 110;   % Kullanım fiyatı (strike price)
T = 1;     % Vade süresi
r = 0.05;  % Risksiz faiz oranı
sigma = 0.3;  % Volatilite (Black-Scholes için sabit)

% Black-Scholes Opsiyonu Fiyatlama
d1 = (log(S0 / K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T));
d2 = d1 - sigma * sqrt(T);
call_price_bs = S0 * normcdf(d1) - K * exp(-r * T) * normcdf(d2);

disp(['Black-Scholes Call Opsiyon Fiyatı: ', num2str(call_price_bs)]);

% Heston Parametreleri
kappa = 2;  % Reversion hızı
theta = 0.04;  % Uzun dönem volatilite seviyesi
sigma_v = 0.2;  % Volatilitenin volatilitesi
v0 = 0.04;  % Başlangıç volatilitesi
rho = -0.7;  % Hisse ve volatilite arasındaki korelasyon

% Heston Modeli ile Monte Carlo Simülasyonu
n_simulations = 10000;
n_steps = 252;  % İş günleri
dt = T / n_steps;
S = zeros(n_simulations, n_steps);
V = zeros(n_simulations, n_steps);
S(:,1) = S0;
V(:,1) = v0;

for t = 2:n_steps
    dW1 = sqrt(dt) * randn(n_simulations,1);  % Hisse fiyatı için Brown hareketi
    dW2 = rho * dW1 + sqrt(1 - rho^2) * sqrt(dt) * randn(n_simulations,1);  % Volatilite için
    V(:,t) = max(V(:,t-1) + kappa * (theta - V(:,t-1)) * dt + sigma_v * sqrt(V(:,t-1)) .* dW2, 0);
    S(:,t) = S(:,t-1) .* exp((r - 0.5 * V(:,t-1)) * dt + sqrt(V(:,t-1)) .* dW1);
end

% Call opsiyonu ödemesi
payoff = max(S(:,end) - K, 0);
call_price_heston = mean(payoff) * exp(-r * T);

disp(['Heston Modeli Call Opsiyon Fiyatı: ', num2str(call_price_heston)]);

% Sonuçların Grafik Gösterimi
figure;
plot(1:n_steps, mean(S), 'LineWidth', 2);
xlabel('Adım Sayısı');
ylabel('Hisse Fiyatı');
title('Heston Modeli ile Simüle Edilen Hisse Fiyatı');
grid on;
