x1 = -3:0.001:1;
x2 = (x1+1) .^ 2;

X1 = [];
Y1 = [];
X2 = [];
Y2 = [];

for k=1:300
    x = random('uniform', -2.8, 0.8, 1, 1);
    y = random('uniform', -0.8, 3.8, 1, 1);
    if y > (x+1)^2 + 0.2
        X1 = [X1 x];
        Y1 = [Y1 y];
    end
    if y < (x+1)^2 - 0.2
        X2 = [X2 x];
        Y2 = [Y2 y];
    end
end

plot(X1, Y1, '+r', X2, Y2, 'ob', x1, x2, '-g');
xlabel('x_1');
ylabel('x_2');