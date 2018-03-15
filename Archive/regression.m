function coeff = regression(timeSeries)
    [n, ~] = size(timeSeries);
    specXaxis = 0:1/n:1-1/n;
    regressXaxis = [ones(n,1) specXaxis'];
    coeff = regress(timeSeries, regressXaxis);
end

