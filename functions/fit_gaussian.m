function G=fit_gaussian(du, pdf_du)
    % du     : vector of velocity increments [m]
    % pdf_du : probability density function (PDF)
    % G      : A gaussian distribution fit G(du)
    mu = mean(pdf_du);
    sigma = std(pdf_du);
    G = normpdf(du, mu, sigma);
    %error('Implement the fit_gaussian function!');
end