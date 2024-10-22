% Heston modeli ile opsiyon fiyatlama
clear; clc; close all;

% Parametreler
S0 = 100;  % Başlangıç hisse fiyatı
K = 110;   % Kullanım fiyatı (strike price)
T = 1;     % Vade süresi
r = 0.05;  % Risksiz faiz oranı
v0 = 0.04; % Başlangıç volatilite
kappa = 2; % Reversion hız katsayısı
theta = 0.04; % Uzun dönem volatilite
sigma_v = 0.2; % Volatilitenin volatilitesi
rho = -0.7; % Hisse ve volatilite arasındaki korelasyon

% Monte Carlo simülasyonu
N = 1000; % Simülasyon sayısı
dt = T/252; % Zaman adımı (günlük)

% Fiyat ve volatilite simülasyonu
S = zeros(N, 252);
V = zeros(N, 252);
S(:,1) = S0;
V(:,1) = v0;

for t = 2:252
    dW1 = sqrt(dt) * randn(N,1); 
    dW2 = rho * dW1 + sqrt(1 - rho^2) * sqrt(dt) * randn(N,1);
    
    V(:,t) = V(:,t-1) + kappa * (theta - V(:,t-1)) * dt + sigma_v * sqrt(max(V(:,t-1),0)) .* dW2;
    S(:,t) = S(:,t-1) .* exp((r - 0.5 * V(:,t-1)) * dt + sqrt(max(V(:,t-1),0)) .* dW1);
end

% Call opsiyonu ödemesi
payoff = max(S(:,end) - K, 0);
call_price = mean(payoff) * exp(-r * T);

% Sonuçlar
disp(['Heston Modeli ile Call Opsiyonu Fiyatı: ', num2str(call_price)]);
