clear
clc

addpath("../functions/");

params(1).name = 'veldata1.txt';
params(2).name = 'veldata2.txt';
params(3).name = 'veldata3.txt';

Nsamples = Inf;      % Size of the dataset for processing

%% ====> Parameters to be filled <====
large_l_limit = 3.1;   

params(1).lambda = 0.0134; 
params(1).L_C    = 0.2814;    

params(2).lambda = 0.0101;
params(2).L_C    = 0.3402;

params(3).lambda = 0.0092;
params(3).L_C    = 0.4002;

warning('Make sure to fill in the relevant values!');

%% --- Common setup ---
Num   = 100;
l_flat = logspace(log10(0.001), log10(1000), Num)';
S2_all = zeros(3, Num);
S4_all = zeros(3, Num);
F_all  = zeros(3, Num);

%% --- Loop through datasets and compute flatness ---
for i = 1:3
    % --- Read velocity data from file ---
    [u, f, U] = load_data(params(i).name, Nsamples);

    % --- Second Order Structure Function ---
    index = 2;
    S2 = structure_function(u, l_flat, f, U, index);
    SS2 = smooth(S2, 8);
    S2_all(i, :) = SS2;

    % --- Fourth Order Structure Function ---
    index = 4;
    S4 = structure_function(u, l_flat, f, U, index);
    SS4 = smooth(S4, 8);
    S4_all(i, :) = SS4;

    % --- Flatness ---
    F_all(i, :) = SS4 ./ (SS2 .^ 2);
end

%% --- Plot Flatness ---
figure;
for i = 1:3
    semilogx(l_flat, F_all(i,:), 'linewidth', 2);
    hold on;
end
yline(large_l_limit, 'k--', 'LineWidth', 1.2);

xlim([min(l_flat) max(l_flat)]);
ylim([0 12]);
xlabel('$l\;[m]$', 'Interpreter', 'latex', 'fontsize', 14);
ylabel('$F(l) = \frac{S_4(l)}{S_2(l)^2}$', 'Interpreter', 'latex', 'fontsize', 14);
legend({'data1', 'data2', 'data3', 'large-l limit'}, 'Interpreter', 'latex', 'fontsize', 12);

for i = 1:3
    xline(params(i).lambda, '--', ['$\lambda_{' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
    xline(params(i).L_C, '--', ['$L\_C_{' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
end
exportgraphics(gcf, '../figures/flatness.png', 'Resolution',600)