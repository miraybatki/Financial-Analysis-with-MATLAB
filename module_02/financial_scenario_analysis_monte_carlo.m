% Senaryo Analizi ve Monte Carlo Simülasyonu ile Finansal Karar
clear; clc; close all;

% Parametreler
initial_investment = -50000; % Başlangıç yatırımı
years = 5; % Yatırımın süresi (yıl)
annual_revenue_mean = 15000; % Yıllık ortalama gelir
annual_revenue_std = 5000; % Gelirdeki belirsizlik (standart sapma)
annual_cost_mean = 7000; % Yıllık ortalama maliyet
annual_cost_std = 2000; % Maliyetteki belirsizlik (standart sapma)
r = 0.08; % İskonto oranı (faiz oranı)

% Simülasyon parametreleri
n_simulations = 10000;

% Monte Carlo Simülasyonu
NPV_results = zeros(n_simulations, 1);
for i = 1:n_simulations
    revenues = normrnd(annual_revenue_mean, annual_revenue_std, [years, 1]);
    costs = normrnd(annual_cost_mean, annual_cost_std, [years, 1]);
    cash_flows = revenues - costs;
    NPV = initial_investment;
    for t = 1:years
        NPV = NPV + cash_flows(t) / (1 + r)^t;
    end
    NPV_results(i) = NPV;
end

% Beklenen NPV ve Risk Analizi
mean_NPV = mean(NPV_results);
std_NPV = std(NPV_results);
probability_positive_NPV = sum(NPV_results > 0) / n_simulations;

% Sonuçların gösterimi
disp(['Beklenen NPV: ', num2str(mean_NPV)]);
disp(['NPV Standart Sapması: ', num2str(std_NPV)]);
disp(['Pozitif NPV Olasılığı: ', num2str(probability_positive_NPV)]);

% Grafiksel gösterim
figure;
histogram(NPV_results, 50, 'Normalization', 'pdf');
xlabel('Net Bugünkü Değer (NPV)');
ylabel('Olasılık Yoğunluğu');
title('Monte Carlo Simülasyonu ile NPV Dağılımı');
grid on;
