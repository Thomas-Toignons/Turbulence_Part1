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


%% --- Frozen flow hypothesis ---
params(1).U = 0;
params(2).U = 0;
params(3).U = 0;
params(1).f = 0;
params(2).f = 0;
params(3).f = 0;

params(1).x = 1 * (0:(length(u1) - 1))';
params(2).x = 1 * (0:(length(u2) - 1))';
params(3).x = 1 * (0:(length(u3) - 1))';

warning('Make sure to properly fill the above parameters')


%% --- Plot A ---
figure()
hold on; grid on;
plot(params(1).x, u1 + params(1).U)
plot(params(2).x, u2 + params(2).U)
plot(params(3).x, u3 + params(3).U)

xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$U(x)$', 'Interpreter', 'latex', 'FontSize', 14)
legend({'$U_1$', '$U_2$', '$U_3$'}, 'Interpreter', 'latex', 'FontSize', 14)

%% --- Turbulence intensity ---
params(1).I = 0;
params(2).I = 0;
params(3).I = 0;
warning('Make sure to fill the turbulence intensity values !');