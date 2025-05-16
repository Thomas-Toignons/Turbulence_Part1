%% ========================================================================
%  7_2_dissipation_estimate.m
%
%  This script estimates the energy dissipation rate (ε) from the second-
%  and third-order structure functions, S₂(l) and S₃(l), using the three
%  given velocity datasets.

% The estimation formulae are:
% - From S₃(l):  S₃(l) ≈ 4/5 * ε * l      (valid in the inertial range)
% - From S₂(l):  S₂(l) ≈ C₂ * ε^(3/2) * l^(3/2)   with C₂ ≈ 2.1 (Sreenivasan)
%
%  Complete the missing parts below to compute the dissipation rate.
%  Compare your estimates to those based on integral-scale quantities 
%  discussed in Section 1.4.
% ========================================================================

clear
clc

addpath("../functions/");

files = {'veldata1.txt', 'veldata2.txt', 'veldata3.txt'};
Nsamples = Inf;  % Define the number of samples to read

%% --- Common setup ---
params(1).file = num2str(cell2mat(files(1)));
params(1).epsilon = 0.6255;
params(1).lambda = 0.0134; 
params(1).L_C    = 0.2814;    

params(2).file = num2str(cell2mat(files(2)));
params(2).epsilon = 5.1715;
params(2).lambda = 0.0101;
params(2).L_C    = 0.3402;

params(3).file = num2str(cell2mat(files(3)));
params(3).epsilon = 12.0096;
params(3).lambda = 0.0092;
params(3).L_C    = 0.4002;




%% --- Computing dissipation ---
num = 100;
%l = logspace(log10(params(1).lambda), log10(params(1).L_C), num); % We create values in the inertial range
l = logspace(log10(2e-2), log10(2e-1), num); % We create values within the inertial range


for i = 1:length(files)
    % --- Load and preprocess data ---
    % Call a function to load and preprocess the velocity data
    [u, f, U] = load_data(params(i).file, Nsamples);

    % --- Compute Structure Functions ---
    % Compute the second-order structure function: 
    str_fct(i).S2 = structure_function(u, l, f, U, 2); 

    % Compute the third-order structure function:
    str_fct(i).S3 = structure_function(u, l, f, U, 3);

    g = fit(((-4/5).*l)', str_fct(i).S3', 'poly1');
    params(i).gS3 = g;
    params(i).epsilon_S3 = g(1);

    g = fit(((2.1^(2/3)).*l)', ((str_fct(i).S2).^(2/3))', 'poly1');
    params(i).gS2 = g;
    params(i).epsilon_S2 = g(1);
end

%% Plot the third order structure function
figure;
x = -4/5*l;
for i=1:3
    plot(-4/5*l, str_fct(i).S3, LineWidth=1.5);
    hold on
    legend({'Data 1', 'Data 2','Data 3'})
    xlabel('$- \frac{4}{5} l$', 'Interpreter','latex')
    ylabel('$S_3(l)$', 'Interpreter','latex')
end

for i=1:3
    fit = params(i).gS3;
    plot(x,fit(x), Color='black', LineStyle='--');
    hold on
end

exportgraphics(gcf, '../figures/epsilon_S3.png', 'Resolution',600)


%% Plot the second order structure function
figure;
for i=1:3
    plot(2.1^(2/3)*l, (str_fct(i).S2).^(2/3));
    hold on
    legend({'Data 1', 'Data 2', 'Data 3'})
    xlabel('$C_2^{2/3} l$', 'Interpreter','latex')
    ylabel('$S_2^{2/3}(l)$', 'Interpreter','latex')
end

x = 2.1^(2/3)*l;
for i=1:3
    fit = params(i).gS2;
    plot(x,fit(x), Color='black', LineStyle='--');
    hold on
end

exportgraphics(gcf, '../figures/epsilon_S2.png', 'Resolution',600)


%% 
    % TODO: linear regression over the inertial range -> epsilon = -5/4*a
    % --- Estimate ε from S3 ---
    % params(i).epsilon_S3 = params(i).S3/(-4/5*l);
    % 
    % % --- Estimate ε from S2 ---
    % params(i).epsilon_S2 = (params(i).S2 / 2.1)^(2/3) * l^(4/3);
    % 
    % % --- Comparison of the estimates ---
    % params(i).relative_error_S3 = (params(i).epsilon - params(i).epsilon_S3)/params(i).epsilon;
    % params(i).relative_error_S2 = (params(i).epsilon - params(i).epsilon_S2)/params(i).epsilon;


%% Dispaly the results
params(1)
params(2)
params(3)