clear
clc

addpath("../functions/");

%% --- Common setup ---

params(1).name = 'veldata1.txt';
params(2).name = 'veldata2.txt';
params(3).name = 'veldata3.txt';

Nsamples = Inf;      % Size of the dataset for processing

l = [1e-3, 1e-2, 1e-1, 10];

%% --- Loop through datasets ---
figure;
for j = 1:3  % dataset loop
    [u, f, U] = load_data(params(j).name, Nsamples);

    for i = 1:length(l)  % loop over l values     
        [x, d] = increment(u, l(i), f, U);
        subplot(3, 4, (j-1)*4 + i)
        plot(x, d);
        xlim([min(x) max(x)]);
        ylim([-15 15]);
        yline(0, '-');

        % Axes labels
        if j == 3
            xlabel('$x\;[m]$', 'Interpreter', 'latex', 'fontsize', 14);
        end
        if i == 1
            ylabel('$\delta v_{||}\;[m/s]$', 'Interpreter', 'latex', 'fontsize', 14);
        end

        % Title
        subplot_title = ['$l=', num2str(l(i)), '\;m$'];
        title(subplot_title, 'Interpreter', 'latex', 'fontsize', 12);

        % print mean increment (should be ~0)
        disp(['Dataset ', num2str(j), ', l = ', num2str(l(i)), ': mean = ', num2str(mean(d))]);
    end
end
