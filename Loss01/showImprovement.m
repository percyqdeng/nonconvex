%X1 vector > X2 vector. X1 pre notoptimal, X2 optimal results
%Write the improvement in percentage +/- standard deviation and p
function showImprovement(m1, s1, m2, s2)

    m = m1 - m2;
    s = sqrt(s1^2 + s2^2);

    r = m / m1; %improvement rate
    sr = r * sqrt((s/m)^2 + (s1/m1)^2); %std of improvement rate
    fprintf('M1 = %f +/- %f \nM2 = %f +/- %f \nMDIFF = %f +/- %f\n', ...
        m1, s1, m2, s2, m, s);    
    fprintf('Improved by %f +/- %f.\n', r, sr);


end
