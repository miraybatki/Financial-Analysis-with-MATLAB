% Markowitz portföy yönetimi
clear, clc, close all
% Hisse sayısı
n = 5;

% Alt ve üst sınırlar
LB = [0 0 0 0 0]';
UB = [1 1 1 1 1]';

% Hedef getiri için hisse getirileri
r1 = 0.8; r2 = 0.4; r3 = 0.1; r4 = 0.15; r5 = 0.1;
Aeq = [1 1 1 1 1; r1 r2 r3 r4 r5];

% Hedef getiri
rt = 0.25;
beq = [1; rt];

% Eşitsizlik kısıtları
A = [-1 -1 0 0 0; 1 1 0 0 0; 0 0 -1 -1 -1; 0 0 1 1 1];
b = [-0.4; 0.6; -0.3; 0.7];

f = [0; 0; 0; 0; 0];
H = [
    3.0 1.2 0.7 0.5 0.3;
    1.2 4.0 0.3 0.8 0.6;
    0.7 0.3 2.5 0.4 0.2;
    0.5 0.8 0.4 3.2 0.9;
    0.3 0.6 0.2 0.9 2.8
];

% İlk çözüm
X = quadprog(H, f, A, b, Aeq, beq, LB, UB);
risk = 1/2 * X' * H * X;

% Hedef getiriyi değiştirelim ve sonuçları saklayalım
LB = [0 0 0 0 0]';
UB = [1 1 1 1 1]';
f = [0; 0; 0; 0; 0];
r1 = 0.1; r2 = 0.3; r3 = 0.2; r4 = 0.15; r5 = 0.1;
Aeq = [1 1 1 1 1; r1 r2 r3 r4 r5];
A = [-1 -1 0 0 0; 1 1 0 0 0; 0 0 -1 -1 -1; 0 0 1 1 1];
b = [-0.4; 0.6; -0.3; 0.7];
H = [
    3.0 1.2 0.7 0.5 0.3;
    1.2 4.0 0.3 0.8 0.6;
    0.7 0.3 2.5 0.4 0.2;
    0.5 0.8 0.4 3.2 0.9;
    0.3 0.6 0.2 0.9 2.8
];

sonuc = [];
for rt = 0.1:0.01:0.3
    beq = [1; rt];
    X = quadprog(H, f, A, b, Aeq, beq, LB, UB);
    risk = 1/2 * X' * H * X;
    sonuc = [sonuc; rt risk X'];
end

sonuc = sonuc(1:15, :);

Riskler = sonuc(:, 2);
Getiriler = sonuc(:, 1);

figure()
plot(Riskler, Getiriler, '*-');
xlabel('Risk (Variance)');
ylabel('Return');
title('Efficient Frontier');
grid on;

% Hesaplanan matrisi göstermek için
disp('Hedef Getiri, Risk ve Portföy Dağılımı:');
disp(sonuc);
