function [x, d] = increment(u, l, f, U)
    % u: vector of perturbative velocity [m/s]
    % l: length for the increment calculation [m]
    % f: frequency of data sampling [Hz]
    % U: mean flow speed [m/s]
    % x: vector of positions [m]
    % d: vector of velocity increments [m/s]
    
    dx = U / f;                   % Spatial resolution [m]
    N_shift = round(l/dx);      % Convert length l to index shift
    d = u((1+N_shift):end) - u(1:(end-N_shift));    % Compute velocity increment
    x = (0:length(d)-1)*dx;

    %N = length(u);
    %n_shift = round(l*f/U);
    %x = (0:(N-n_shift-1)) * U/f;
    %d = u(n_shift+1:end) - u(1:(end-n_shift));
    
end