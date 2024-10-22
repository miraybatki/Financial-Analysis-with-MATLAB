% NPV (Net Present Value) hesaplama
clear; clc; close all;

% Parametreler
cash_flows = [-1000 300 500 700 800]; % Yatırım ve nakit akışları (ilk yıl negatif yatırım)
r = 0.1; % İskonto oranı (faiz oranı %10)

% NPV hesaplama
n = length(cash_flows);
NPV = 0;

for t = 1:n
    NPV = NPV + cash_flows(t) / (1 + r)^(t-1); % İndirgeme formülü
end

% Sonuçların gösterimi
disp(['Projenin Net Bugünkü Değeri (NPV): ', num2str(NPV)]);

% Eğer NPV > 0 ise proje kârlı, NPV < 0 ise proje zararlı
if NPV > 0
    disp('Proje kârlıdır.');
else
    disp('Proje zararlıdır.');
end
