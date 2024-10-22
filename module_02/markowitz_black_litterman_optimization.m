% Gelişmiş Portföy Optimizasyonu - Markowitz + Black-Litterman
clear; clc; close all;

% Parametreler
n_assets = 6;  % Hisse sayısı
tau = 0.05;  % Belirsizlik parametresi
risk_free_rate = 0.02;  % Risksiz faiz oranı

% Varlık getirileri ve kovaryans matrisi (örnek veriler)
mu_market = [0.10 0.12 0.08 0.07 0.09 0.11]'; % Piyasa getirileri
cov_market = [0.05 0.02 0.01 0.01 0.02 0.01;
              0.02 0.06 0.02 0.02 0.01 0.01;
              0.01 0.02 0.07 0.01 0.02 0.02;
              0.01 0.02 0.01 0.08 0.01 0.02;
              0.02 0.01 0.02 0.01 0.09 0.01;
              0.01 0.01 0.02 0.02 0.01 0.1];

% Risk toleransı ve piyasa ağırlıkları
market_weights = [0.2 0.15 0.25 0.10 0.15 0.15]';
risk_aversion = 3; % Yatırımcının riskten kaçınma parametresi

% Black-Litterman için yatırımcının görüşleri
P = [1 0 0 0 -1 0;
     0 1 0 -1 0 0];
Q = [0.03; 0.02]; % İki hisse arasındaki görüş farkları

% Hesaplamalar
omega = diag([0.001, 0.001]);  % Görüşlerin belirsizlik matrisi
Pi = risk_aversion * cov_market * market_weights; % Piyasa risk primi
sigma_bl = inv(inv(tau * cov_market) + P' * inv(omega) * P); % BL kovaryans matrisi
mu_bl = sigma_bl * (inv(tau * cov_market) * Pi + P' * inv(omega) * Q); % BL getiriler

% Markowitz optimizasyonu
H = 2 * cov_market;  % Hedef fonksiyonun ikinci dereceden terimi
f = zeros(n_assets, 1);  % Lineer terim
Aeq = [ones(1, n_assets); mu_bl']; % Ağırlıklar toplamı 1 ve belirli getiri kısıtı
beq = [1; risk_free_rate]; % Risksiz getiri kısıtı

% Ağırlık sınırları
LB = zeros(n_assets, 1); % Alt sınır (negatif ağırlık yok)
UB = ones(n_assets, 1);  % Üst sınır (%100'e kadar yatırım yapılabilir)

% Optimizasyon
options = optimoptions('quadprog', 'Display', 'off');
[weights_bl, ~] = quadprog(H, f, [], [], Aeq, beq, LB, UB, [], options);

% Portföy risk ve getirisi
port_return = mu_bl' * weights_bl;
port_risk = sqrt(weights_bl' * cov_market * weights_bl);

% Sonuçlar
disp('Black-Litterman Modeline Göre Optimum Portföy Dağılımı:');
disp(weights_bl');
disp(['Portföy Getirisi: ', num2str(port_return)]);
disp(['Portföy Riski: ', num2str(port_risk)]);

% Grafik: Efficient Frontier ve BL Portföyü
figure;
plot(0.05:0.01:0.15, 0.05:0.01:0.15, '--b');
hold on;
scatter(port_risk, port_return, 'r', 'filled');
xlabel('Risk (Volatilite)');
ylabel('Getiri');
title('Efficient Frontier ve Black-Litterman Portföyü');
grid on;
