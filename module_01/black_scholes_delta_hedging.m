% Black-Scholes ve Delta Hedging
clear; clc; close all;

% Parametreler
S0 = 100;  % Hisse fiyatı
K = 110;   % Kullanım fiyatı (strike price)
T = 1;     % Vade süresi (yıl)
r = 0.05;  % Risksiz faiz oranı
sigma = 0.25; % Volatilite
steps = 252; % Günlük adım sayısı (iş günleri)
dt = T / steps;

% Black-Scholes formülü ile call opsiyonu fiyatı
d1 = (log(S0 / K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T));
d2 = d1 - sigma * sqrt(T);
call_price = S0 * normcdf(d1) - K * exp(-r * T) * normcdf(d2);

% Delta hesaplama
delta = normcdf(d1);

% Hedge stratejisi için günlük delta ayarı
S = S0 * exp(cumsum((r - 0.5 * sigma^2) * dt + sigma * sqrt(dt) * randn(steps, 1)));

% Delta hedging uygulanması
cash = zeros(steps, 1); % Nakit pozisyonu
shares = zeros(steps, 1); % Hisse pozisyonu
portfolio_value = zeros(steps, 1); % Portföy değeri
for t = 1:steps
    delta_t = normcdf((log(S(t) / K) + (r + 0.5 * sigma^2) * (T - t * dt)) / (sigma * sqrt(T - t * dt)));
    cash(t) = cash(t-1) * exp(r * dt) - (delta_t - delta) * S(t);
    shares(t) = delta_t;
    portfolio_value(t) = delta_t * S(t) + cash(t);
    delta = delta_t;
end

% Grafiksel gösterim
figure;
subplot(2,1,1);
plot(1:steps, S, 'LineWidth', 2);
xlabel('Gün');
ylabel('Hisse Fiyatı');
title('Hisse Fiyatı');

subplot(2,1,2);
plot(1:steps, portfolio_value, 'LineWidth', 2);
xlabel('Gün');
ylabel('Portföy Değeri');
title('Delta Hedged Portfolio');
grid on;
