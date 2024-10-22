% Opsiyon Fiyatlama ve Delta Hedging
clear; clc; close all;

% Black-Scholes Parametreleri
S0 = 100;  % Hisse fiyatı
K = 110;   % Kullanım fiyatı
T = 1;     % Vade süresi
r = 0.05;  % Risksiz faiz oranı
sigma = 0.25;  % Volatilite (sabit)

% 1. Black-Scholes Opsiyon Fiyatlama
d1 = (log(S0 / K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T));
d2 = d1 - sigma * sqrt(T);
call_price_bs = S0 * normcdf(d1) - K * exp(-r * T) * normcdf(d2);

disp(['Black-Scholes Call Opsiyon Fiyatı: ', num2str(call_price_bs)]);

% 2. Delta Hedging Stratejisi
delta_bs = normcdf(d1);  % Delta (Hedge oranı)
disp(['Black-Scholes Delta: ', num2str(delta_bs)]);

% 3. Heston Modeli Fiyatlama
kappa = 2; theta = 0.04; sigma_v = 0.2; v0 = 0.04; rho = -0.7;
n_simulations = 10000; n_steps = 252;
S = zeros(n_simulations, n_steps); V = zeros(n_simulations, n_steps);
S(:,1) = S0; V(:,1) = v0;
for t = 2:n_steps
    dW1 = sqrt(T/n_steps) * randn(n_simulations,1);
    dW2 = rho * dW1 + sqrt(1 - rho^2) * sqrt(T/n_steps) * randn(n_simulations,1);
    V(:,t) = max(V(:,t-1) + kappa * (theta - V(:,t-1)) * T/n_steps + sigma_v * sqrt(V(:,t-1)) .* dW2, 0);
    S(:,t) = S(:,t-1) .* exp((r - 0.5 * V(:,t-1)) * T/n_steps + sqrt(V(:,t-1)) .* dW1);
end
payoff_heston = max(S(:,end) - K, 0);
call_price_heston = mean(payoff_heston) * exp(-r * T);
disp(['Heston Modeli Call Opsiyon Fiyatı: ', num2str(call_price_heston)]);

% 4. Monte Carlo Simülasyonu ile Opsiyon Fiyatlama
n_simulations_mc = 10000;
payoffs_mc = zeros(n_simulations_mc, 1);
for i = 1:n_simulations_mc
    S_T = S0 * exp((r - 0.5 * sigma^2) * T + sigma * sqrt(T) * randn());
    payoffs_mc(i) = max(S_T - K, 0);
end
call_price_mc = mean(payoffs_mc) * exp(-r * T);
disp(['Monte Carlo Call Opsiyon Fiyatı: ', num2str(call_price_mc)]);
