function [m,v] = gpr(x,y,r,b)
% Gaussian process regression in 1D with Gaussian kernel
% b controls kernel width
% small b produces polynomial interpolant of min degree
% m is mean of the interpolant over the range r
% v is the pointwise variance

kxx = exp(-b/2*distance(x,x));
ikxx = inv(kxx);
alpha = ikxx*y';
krx = exp(-b/2*distance(r,x));
m = krx*alpha;
v = 1 - diag(krx*ikxx*krx');
