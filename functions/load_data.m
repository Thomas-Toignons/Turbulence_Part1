function [u, f, U] = load_data(filename, Nsamples)
    % u (m/s): velocity fluctuations
    % U (m/s): velocity average
    % f (Hz): acquisition frequency
    raw_data = read_file(strcat("../data/",filename));
    f = raw_data(3);
    data = raw_data(4:end);
    N = min(Nsamples, length(data));
    data = data(1:N);
    U = mean(data);
    u = data - U;
    u = flip(u);
end
