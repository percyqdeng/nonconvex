%X1 vector > X2 vector. X1 pre notoptimal, X2 optimal results
%Write the improvement in percentage +/- standard deviation and p
function showImprovementStats(X1, X2)

X = X1 - X2;
[h p] = ttest(X);
if h == 0
    fprintf('No substantial improvement (cant reject H0 at a = 0.05)');
else
    m = mean(X);
    m1 = mean(X1);
    m2 = mean(X2);
    s = std(X);
    s1 = std(X1);
    s2 = std(X2);

    r = m / m1; %improvement rate
    sr = r * sqrt((s/m)^2 + (s1/m1)^2); %std of improvement rate
    fprintf('M1 = %f +/- %f \nM2 = %f +/- %f \nMDIFF = %f +/- %f\n', ...
        m1, s1, m2, s2, m, s);    
    fprintf('Improved by %f +/- %f (H0 rejected: p = %f)\n', r, sr, p);
end


end
