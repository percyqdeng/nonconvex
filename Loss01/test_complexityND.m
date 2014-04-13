

D = 8; % dimension of data
N = 5000;

A= [1 2 3 4];

tic
k = 1
while k < N^3 * D^2
    B = (A*3)./2.9;
    k = k+1;
end

toc