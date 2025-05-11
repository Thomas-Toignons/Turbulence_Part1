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

params(1).u = u1;
params(2).u = u2;
params(3).u = u3;

params(1).U = U1;
params(2).U = U2;
params(3).U = U3;

params(1).L_C = 0.2814;
params(2).L_C = 0.3403;
params(3).L_C = 0.4002;
%warning('Redefine params(i).L_C here if needed')

%% --- Dissipation and Reynolds numbers ---
nu = 1.51e-5;                         % Fluid's viscosity at 1atm and 20°C
outer_scale = 1;

for i = 1:1:3
    u_i = params(i).u;
    ku_i = mean(u_i.^2);
    Lc_i = params(i).L_C;
    params(i).epsilon = 0.5*sqrt(ku_i^3)/Lc_i;

    e_i = params(i).epsilon;
    params(i).lambda = sqrt(15*nu*ku_i/e_i);

    lambda_i = params(i).lambda;
    params(i).Re_lambda = sqrt(ku_i)*lambda_i/nu;
    params(i).Re_outer = params(i).Re_lambda^2;

    params(i).Re_wire = 1e-3*params(i).U/nu;
    params(i).Re_paddle = 100e-3*params(i).U/nu;
end

%warning('Make sure that you filled all of the above numbers')