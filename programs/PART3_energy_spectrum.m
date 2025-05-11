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

% For Taylor frozen flow
dl1 = U1 / sample_freq1;
dl2 = U2 / sample_freq2;
dl3 = U3 / sample_freq3;

% Length vectors, from results of questions 1.1 (need to be oyt back here)
N = length(u1);     % Same for all datasets
l1 = dl1 * (0:N-1)';         % params(1).x
l2 = dl2 * (0:N-1)';         % params(2).x
l3 = dl3 * (0:N-1)';         % params(3).x

% Total length
L1 = l1(N);
L2 = l2(N);
L3 = l3(N);


%% --- Energy spectrum ---
% Put in prefactors
norm1 = L1/(2*pi*N^2);
norm2 = L2/(2*pi*N^2);
norm3 = L3/(2*pi*N^2);
%warning('Make sure to have properly written the normalization')

Ek1 = spectral_energy_density(u1) * norm1;
Ek2 = spectral_energy_density(u2) * norm2;
Ek3 = spectral_energy_density(u3) * norm3;

% Define E(k), k > 0
% We just remove the first value of the energy spectrum, associated to k=0
Ek1 = Ek1(2:end);
Ek2 = Ek2(2:end);
Ek3 = Ek3(2:end);

% Define the wave number/scales
k1 = 2*pi/L1 * (1:N/2);
k2 = 2*pi/L2 * (1:N/2);
k3 = 2*pi/L3 * (1:N/2);
warning('Define E(k), k > 0 properly, and the k vectors as well')

% Signal filtering
span = 0.001;
method = 'moving';

Ek1_smooth = smooth(Ek1,span,method);
Ek2_smooth = smooth(Ek2,span,method);
Ek3_smooth = smooth(Ek3,span,method);
%warning('Make sure that you filtered the spectrums')

%% Plot C
figure()
loglog(k1, Ek1_smooth, 'DisplayName', 'Data 1')
hold on;
grid on;
loglog(k2, Ek2_smooth, 'DisplayName', 'Data 2')
loglog(k3, Ek3_smooth, 'DisplayName', 'Data 3')

% Add K41 scaling predictions
loglog(1:1:1000, (1:1:1000).^(-5/3), '--k', 'DisplayName', 'K41 prediction')
%warning('Make sure that you add the proper prediction')

% Add estimates for integral and Kolmogorov length scales
params(1).eta_e = 2*pi * (3e2)^-1;
params(2).eta_e = 2*pi * (2.8e2)^-1;
params(3).eta_e = 2*pi * (2.7e2)^-1;
params(1).Lint_e = 2*pi * (3)^-1;
params(2).Lint_e = 2*pi * (2.5)^-1;
params(3).Lint_e = 2*pi * (4)^-1;
%warning(['Make sure to add the estimates for the integral and ' ...
%    'Kolmogorov length scales'])

% Labels
xlabel('$k$', 'Interpreter', 'latex')
ylabel('$E(k)$', 'Interpreter', 'latex')
legend('Interpreter', 'latex')

% Plot correlation length scales Lci
for i = 1:1:3
    xline(2*pi/params(i).eta_e, '--', ['$\eta_{E' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');

    xline(2*pi/params(i).Lint_e, '--', ['$L_{int,E' num2str(i) '}$'], ...
        'Interpreter', 'latex', 'fontsize', 10, ...
        'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
end
% xlim([5e-2, 1e4])           % You can ajust this if you need it

%% Parsival's theorem
Parsival_rel_err1 = (0.5 * mean(u1.^2) - trapz(k1, Ek1))/(0.5*mean(u1.^2));
Parsival_rel_err2 = (0.5 * mean(u2.^2) - trapz(k2, Ek2))/(0.5*mean(u2.^2));
Parsival_rel_err3 = (0.5 * mean(u3.^2) - trapz(k3, Ek3))/(0.5*mean(u3.^2));
%warning('Check Parsivals theorem here')
