function S = structure_function(u, l, f, U, n)
    % u: vector of perturbative velocity [m/s]
    % l: length for the increment calculation [m]
    % f: frequency of data sampling [Hz]
    % U: mean flow speed [m/s]
    % n : order of the structure function
    % S : vector of the structure function [m/s]

    S = 0.*l;
    
    for i=1:length(l)
        li = l(i);
        [~, d] = increment(u,li,f,U);
        S(i) = mean(d.^n);
    end
    %[~, d] = increment(u, l, f, U);
    %S = mean(d.^n);
end
