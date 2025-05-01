function Ek = spectral_energy_density(velocity)
    % FFT is taken on the velocity signal, and the
    % complex conjugate modes are removed, although
    % no rescaling is performed
    fft_vel = fft(velocity)';
    N = length(fft_vel);
    fft_vel = abs(fft_vel);
    Ek = fft_vel(1:(N/2+1));

    % Square Ek to get the (non-normalized) energy spectrum
    Ek = 0.5 * Ek .* conj(Ek);
end