clear
clc

addpath("../functions/");

%% --- Common setup ---

params(1).name = 'veldata1.txt';
params(2).name = 'veldata2.txt';
params(3).name = 'veldata3.txt';

Nsamples = Inf;      % Size of the dataset for processing

l = [1e-3, 1e-2, 1e-1, 10];

%% --- Loop over datasets ---

for k = 1:3
    [u, f, U] = load_data(params(k).name, Nsamples);

    for y_axis = 1:2  % 1: semilogy, 2: linear
        figure;
        for i = 1:length(l)
            s = subplot(2,2,i);

            [x, d] = increment(u, l(i), f, U);
            h = histogram(d, i*200, 'Normalization', 'probability');
            increments = zeros(h.NumBins, 1);
            values = zeros(h.NumBins, 1);
            dx = h.BinWidth;

            for j = 1:h.NumBins
                increments(j) = (h.BinEdges(j)+h.BinEdges(j+1))/2;
                values(j) = h.Values(j);
            end

            values = values / dx;
            cla(s)

            if y_axis == 1
                semilogy(increments, values, 'linewidth', 1.5)
                ylim([1e-7 5e1])
            else
                plot(increments, values, 'linewidth', 1.5)
            end

            bound = min([abs(min(increments)), max(increments)]);
            xlim([-bound bound])

            G = fit_gaussian(increments, d);
            hold on
            plot(increments, G, 'linewidth', 1.5)

            % Axis labels
            if i == 3 || i == 4
                xlabel('$\delta v_{||}\;[m/s]$', 'Interpreter', 'latex', 'fontsize', 14);
            end
            if i == 1 || i == 3
                ylabel('$P(\delta v_{||})$', 'Interpreter', 'latex', 'fontsize', 14);
            end

            % Legend
            if i == 2
                legend('Dataset PDF', 'Gaussian', 'Interpreter', 'latex', 'fontsize', 11); 
            end

            title(['$l=', num2str(l(i)), '\;m$'], 'Interpreter', 'latex', 'fontsize', 14);
        end

            if y_axis == 1
                y_label = 'SemilogY';
            else
                y_label = 'Linear';
            end
            sgtitle(['Dataset ', num2str(k), ' - ', y_label], ...
                    'Interpreter', 'latex', 'fontsize', 14);

    end
end