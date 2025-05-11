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
% Mean flow velocity
params(1).U = U1;
params(2).U = U2;
params(3).U = U3;

% Measurement frequency
params(1).f = sample_freq1;
params(2).f = sample_freq2;
params(3).f = sample_freq3;

% Temporal to spatial conversion
params(1).x = 1/params(1).f * params(1).U * (0:(length(u1) - 1))';
params(2).x = 1/params(2).f * params(2).U * (0:(length(u2) - 1))';
params(3).x = 1/params(2).f * params(2).U * (0:(length(u3) - 1))';

%warning('Make sure to properly fill the above parameters')

%% --- Plot A ---
% We plot the total velocity (fluctuations + average)
figure()
hold on; grid on;
plot(params(1).x, u1 + params(1).U)
plot(params(2).x, u2 + params(2).U)
plot(params(3).x, u3 + params(3).U)

xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$U(x)$', 'Interpreter', 'latex', 'FontSize', 14)
legend({'$U_1$', '$U_2$', '$U_3$'}, 'Interpreter', 'latex', 'FontSize', 14)

%% --- Turbulence intensity ---
params(1).TI = rms(u1)/U1;
params(2).TI = rms(u2)/U2;
params(3).TI = rms(u3)/U3;
%warning('Make sure to fill the turbulence intensity values !');

%% --- Print useful values for nest part ---
fprintf("U1 = %.2f m/s, at f1 = %.2f Hz \n", params(1).U, params(1).f)
fprintf("U2 = %.2f m/s, at f2 = %.2f Hz \n", params(2).U, params(2).f)
fprintf("U3 = %.2f m/s, at f3 = %.2f Hz \n", params(3).U, params(3).f)