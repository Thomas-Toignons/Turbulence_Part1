clc;
clear;
addpath("../functions/");

%% --- Common Setup ---
if ~exist('params', 'var') || isempty(params)
    params(1).U = 5.28;
    params(2).U = 10.14;
    params(3).U = 13.24;
    params(1).f = 6940;
    params(2).f = 17020;
    params(3).f = 27600;
end

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


%% --- Correlation length ---
params(1).dl = U1 * 1/params(1).f;
params(2).dl = U2 * 1/params(2).f;
params(3).dl = U3 * 1/params(3).f;
%warning('Make sure to set dls correctly')

% Maximum autocorr. length
lmax_autocorr = 10;

% Normalized autocorrelation computation
params(1).Cl = autocorrelation(u1+U1, params(1).dl, lmax_autocorr) * 1/mean(u1.^2);
params(2).Cl = autocorrelation(u2+U2, params(2).dl, lmax_autocorr) * 1/mean(u2.^2);
params(3).Cl = autocorrelation(u3+U3, params(3).dl, lmax_autocorr) * 1/mean(u3.^2);

C1 = params(1).Cl;
C2 = params(2).Cl;
C3 = params(3).Cl;
%warning('Make sure to correctly normalize the autocorrelation !');

% Length vectors
dl1 = params(1).dl;
dl2 = params(2).dl;
dl3 = params(3).dl;

l1 = 0:dl1:(params(1).dl*(length(C1) - 1));
l2 = 0:dl2:(params(2).dl*(length(C2) - 1));
l3 = 0:dl3:(params(3).dl*(length(C3) - 1));

params(1).l = l1;
params(2).l = l2;
params(3).l = l3;


% Find intersections
threshold = exp(-1);
params(1).L_C = l1(find(C1 <= threshold, 1));
params(2).L_C = l2(find(C2 <= threshold, 1));
params(3).L_C = l3(find(C3 <= threshold, 1));
%warning('Make sure to fill Lc properly')

%% --- Plot B ---
lmax_plot = 1;
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

xlabel('$l$ [m]', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$C_{i}(l)$ [-]', 'Interpreter', 'latex', 'FontSize', 14)

% Add LCi to plots
for i = 1:1:3
    xline(params(i).L_C, '--', ['$L_{C' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
end

legend({'$C_1(l)$', '$C_2(l)$', '$C_3(l)$', '$e^{-1}$'}, ...
    'Interpreter', 'latex', 'FontSize', 14)
exportgraphics(gcf, '../figures/cl.png','Resolution', 600)

%% --- Integral scale ---
lmax_plot = 100;    % Initial value: 5
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
Lint_cum1 = cumtrapz(l1,C1);
Lint_cum2 = cumtrapz(l2,C2);
Lint_cum3 = cumtrapz(l3,C3);

 
% Computation of the integral scale
for i=1:3
    Ci = params(i).Cl;
    li = params(i).l;
    linf = li(1:find(Ci<0, 1));
    Cl = Ci(1:find(Ci<0, 1));
    params(i).Lint = trapz(linf, Cl);
end


% Plotting
figure();
hold on; grid on;
plot(l1(1:lmax_idx1), Lint_cum1)
plot(l2(1:lmax_idx2), Lint_cum2)
plot(l3(1:lmax_idx3), Lint_cum3)

xlabel('$l$ [m]', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\int_0^l  \,C_i (s) \,ds $ [m]', 'Interpreter', 'latex', ...
        'FontSize', 14)

for i = 1:1:3
    yline(params(i).Lint, '--', ['$L_{int,' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
end

legend({'$\int_0^lC_1(s)ds$', '$\int_0^lC_2(s)ds$', '$\int_0^lC_3(s)ds$', ...
    }, ...
    'Interpreter', 'latex', 'Location', 'southwest', 'FontSize', 14)
exportgraphics(gcf, '../figures/lint.png','Resolution', 600)

%% Error computations
for i=1:3
    params(i).error = abs((params(i).L_C - params(i).Lint)/params(i).L_C);
    params(i).error*100
end