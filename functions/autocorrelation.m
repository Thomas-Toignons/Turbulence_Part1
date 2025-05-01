function [autoCorr] = autocorrelation(velocity, dl, lmax)
    % Velocity assumed to be a 1D vector field, each sample being 
    % spatially separated by a constant dl
    % Definition of the non-normalized auto correlation function is
    % C(l) = <v(x) * v(x + l)>
    N = length(velocity);
    velocity = velocity - mean(velocity);
    nfft = 2^nextpow2(2*N);             % Zero-pad to next power of 2
    V = fft(velocity, nfft);
    S = V .* conj(V);                   % Power spectrum is used since
                                        % fft is MUCH faster than using 
                                        % averages
    C_full = ifft(S);
    C_full = real(C_full(1:N));         % Keep only valid part
    normalization = (N:-1:1)';          % Number of terms at each lag
    C_full = C_full ./ normalization;   % Normalize for each shift l

    if (lmax < 0)                       % Consider the whole length
        lmax = 1e15;
    end
    maxLagIndex = floor(lmax / dl);
    maxLagIndex = min(maxLagIndex, N-1); % Prevent exceeding signal length
    
    autoCorr = C_full(1:maxLagIndex+1)';
end