clc;
clear;

addpath("../functions/");

%% --- Common Setup ---
params(1).name = 'veldata1.txt';
params(2).name = 'veldata2.txt';
params(3).name = 'veldata3.txt';

%% --- Loading data ---
[u1, sample_freq1, U1] = ...
    load_data(params(1).name, Inf);
[u2, sample_freq2, U2] = ...
    load_data(params(2).name, Inf);
[u3, sample_freq3, U3] = ...
    load_data(params(3).name, Inf);

% If not set
% params(1).U = 0;
% params(2).U = 0;
% params(3).U = 0;
% params(1).f = 0;
% params(2).f = 0;
% params(3).f = 0;

%% --- Correlation length ---
params(1).dl = 1;
params(2).dl = 1;
params(3).dl = 1;
warning('Make sure to set dls correctly')

lmax_autocorr = 10;                         % Maximum autocorr. length
C1 = autocorrelation(u1, params(1).dl, lmax_autocorr) * 1;
C2 = autocorrelation(u2, params(2).dl, lmax_autocorr) * 1;
C3 = autocorrelation(u3, params(3).dl, lmax_autocorr) * 1;
warning('Make sure to correctly normalize the autocorrelation !');

% Length vectors
l1 = 0:dl1:(params(1).dl*(length(C1) - 1));
l2 = 0:dl2:(params(2).dl*(length(C2) - 1));
l3 = 0:dl3:(params(3).dl*(length(C3) - 1));

% Find intersections
params(1).L_C = 1;
params(2).L_C = 1;
params(3).L_C = 1;
warning('Make sure to fill Lc properly')

%% --- Plot B ---
lmax_plot = 1.1;
lmax_idx1 = find(l1 >= lmax_plot, 1);
lmax_idx2 = find(l2 >= lmax_plot, 1);
lmax_idx3 = find(l3 >= lmax_plot, 1);
if isempty(lmax_idx1)
    lmax_idx1 = length(l1);
end
if isempty(lmax_idx2)
    lmax_idx2 = length(l2);
end
if isempty(lmax_idx3)
    lmax_idx3 = length(l3);
end

figure();
hold on;
plot(l1(1:lmax_idx1), C1(1:lmax_idx1))
plot(l2(1:lmax_idx2), C2(1:lmax_idx2))
plot(l3(1:lmax_idx3), C3(1:lmax_idx3))
plot([0, l1(lmax_idx1)], 1 / exp(1) * [1, 1], ':k')
grid on;

xlabel('$l$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$C_{i}(l)$', 'Interpreter', 'latex', 'FontSize', 14)

% Add LCi to plots
for i = 1:1:3
    xline(params(i).L_C, '--', ['$L_{C' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
end

legend({'$C_1(l)$', '$C_2(l)$', '$C_3(l)$', '$e^{-1}$'}, ...
    'Interpreter', 'latex', 'FontSize', 14)


%% --- Integral scale ---
lmax_plot = 5;
lmax_idx1 = find(l1 >= lmax_plot, 1);
lmax_idx2 = find(l2 >= lmax_plot, 1);
lmax_idx3 = find(l3 >= lmax_plot, 1);
if isempty(lmax_idx1)
    lmax_idx1 = length(l1);
end
if isempty(lmax_idx2)
    lmax_idx2 = length(l2);
end
if isempty(lmax_idx3)
    lmax_idx3 = length(l3);
end

% 1.2.3 Cumulative integral
Lint_cum1 = 1:1:lmax_idx1;
Lint_cum2 = 1:1:lmax_idx2;
Lint_cum3 = 1:1:lmax_idx3;
params(1).Lint = 0;
params(2).Lint = 0;
params(3).Lint = 0;
warning('Make sure to fill the cumulative integral properly')

% Plotting
figure();
hold on; grid on;
plot(l1(1:lmax_idx1), Lint_cum1)
plot(l2(1:lmax_idx2), Lint_cum2)
plot(l3(1:lmax_idx3), Lint_cum3)

xlabel('$l$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\int_0^l  \,C_i (s) \,ds $', 'Interpreter', 'latex', ...
        'FontSize', 14)

for i = 1:1:3
    yline(params(i).Lint, '--', ['$L_{int,' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
end

legend({'$\int_0^lC_1(s)ds$', '$\int_0^lC_2(s)ds$', '$\int_0^lC_3(s)ds$', ...
    }, ...
    'Interpreter', 'latex', 'Location', 'southwest', 'FontSize', 14)
