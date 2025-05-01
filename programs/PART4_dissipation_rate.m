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
% You need params(i).L_C from part 2
warning('Redefine params(i).L_C here if needed')

%% --- Dissipation and Reynolds numbers ---
nu = 1;                         % Fluid's viscosity
outer_scale = 1;
for i = 1:1:3
    params(i).epsilon = 1;
    params(i).lambda = 1;
    params(i).Re_lambda = 1;
    params(i).Re_outer = 1;
end
warning('Make sure that you filled all of the above numbers')