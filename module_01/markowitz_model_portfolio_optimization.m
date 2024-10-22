% Gelişmiş Markowitz portföy optimizasyonu
clear; clc; close all;

% Hisse sayısı
n = 8;

% Getiri oranları (örnek veriler)
mu = [0.12 0.10 0.07 0.05 0.04 0.03 0.02 0.01]'; 

% Varyans-kovaryans matrisi (riske ilişkin örnek veriler)
sigma = [0.04 0.01 0.02 0.01 0.03 0.01 0.02 0.00;
         0.01 0.05 0.01 0.01 0.02 0.01 0.01 0.00;
         0.02 0.01 0.06 0.02 0.01 0.01 0.00 0.01;
         0.01 0.01 0.02 0.07 0.02 0.01 0.00 0.00;
         0.03 0.02 0.01 0.02 0.08 0.01 0.01 0.01;
         0.01 0.01 0.01 0.01 0.01 0.09 0.02 0.01;
         0.02 0.01 0.00 0.00 0.01 0.02 0.10 0.01;
         0.00 0.00 0.01 0.00 0.01 0.01 0.01 0.03];

% Hedef getiri seviyesi ve eşitsizlik kısıtları
target_return = 0.06; % Hedeflenen getiri oranı
LB = zeros(n, 1); % Alt sınır (negatif ağırlıklar yok)
UB = ones(n, 1);  % Üst sınır (%100'e kadar yatırım yapılabilir)
Aeq = [ones(1,n); mu']; % Kısıtlar: toplam yatırım %100 olmalı ve hedef getiri sağlanmalı
beq = [1; target_return]; % Eşitlik kısıtları: toplam 1 ve belirli getiri

% Hedef fonksiyonun parametreleri (quadprog için)
H = 2 * sigma; % Varyans-kovaryans matrisi
f = zeros(n, 1); % Doğrusal terim sıfır

% Optimizasyon (quadprog kullanarak)
options = optimoptions('quadprog','Display','off'); 
[X_optimal, fval, exitflag] = quadprog(H, f, [], [], Aeq, beq, LB, UB, [], options);

% Portföyün riski ve getirisi
portfolio_risk = sqrt(X_optimal' * sigma * X_optimal);
portfolio_return = mu' * X_optimal;

% Sonuçların gösterimi
disp('Optimal portföy dağılımı:');
disp(X_optimal);
disp(['Portföyün beklenen getirisi: ', num2str(portfolio_return)]);
disp(['Portföyün beklenen riski: ', num2str(portfolio_risk)]);

% Grafik gösterimi (Efficient Frontier)
target_returns = linspace(min(mu), max(mu), 100);
risks = zeros(1, length(target_returns));

for i = 1:length(target_returns)
    beq = [1; target_returns(i)];
    [X_opt, ~] = quadprog(H, f, [], [], Aeq, beq, LB, UB, [], options);
    risks(i) = sqrt(X_opt' * sigma * X_opt);
end

% Grafik çizimi
figure;
plot(risks, target_returns, '-b', 'LineWidth', 2);
xlabel('Risk (Standard Deviation)');
ylabel('Expected Return');
title('Efficient Frontier');
grid on;
hold on;

% Optimal noktayı işaretleyin
plot(portfolio_risk, portfolio_return, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
legend('Efficient Frontier', 'Optimal Portfolio');
