% Kar-Zarar ve Maliyet Analizi
clear; clc; close all;

% Parametreler
sales_price = 300; % Tişört satış fiyatı
standard_cost = 150; % Standart üretim maliyeti
special_costs = [350 200 250 100]; % Özel üretim maliyetleri
production_quantity = 1000; % Üretim miktarı
market_share = 0.2; % Pazar payı
market_size = 5000; % Pazar büyüklüğü (satılabilir tişört adedi)

% Pazar payına göre satış miktarı
sales_quantity = market_size * market_share;

% Kar hesaplama (standart üretim)
standard_profit = (sales_price - standard_cost) * sales_quantity;

% Kar hesaplama (özel üretim)
special_profits = (sales_price - special_costs) .* sales_quantity;

% Sonuçların gösterimi
disp(['Standart üretimden elde edilen toplam kar: ', num2str(standard_profit), ' TL']);
disp('Özel üretim seçeneklerinden elde edilen karlar:');
disp(special_profits);

% En yüksek karı sağlayan üretim seçeneği
[max_profit, idx] = max(special_profits);
disp(['En yüksek karı sağlayan özel üretim maliyeti: ', num2str(special_costs(idx)), ' TL']);
disp(['Bu üretimden elde edilecek toplam kar: ', num2str(max_profit), ' TL']);
