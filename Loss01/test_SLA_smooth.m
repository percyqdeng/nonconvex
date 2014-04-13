clc;

D = 3; % dimension of data
N = 1000;
[X,t] = generateTestData(N, D, 0.2);

w = getWeightsByPointsSelection3(X, t);
w = getWeightsByPointsSelection2(X, t);
w = w / norm(w);

figure(4);
subplot(1,2,1);
iw=3;
x = (w(iw)-20):0.005:(w(iw)+20);
m = floor(length(x) / 2);
r = floor(0.02*length(x));
i2 = (m-r):1:(m+r);
y0 = zeros(size(x));
y1 = zeros(size(x));
y10 = zeros(size(x));
y100 = zeros(size(x));

for k=1:length(x)
    w(iw) = x(k);
    y0(k) = cal01Loss(X, t, w);
    y1(k) = calSmoothLoss(X,t,w,1,0);
    y10(k) = calSmoothLoss(X,t,w,10,0);
    y100(k) = calSmoothLoss(X,t,w,100,0);
end

pl = plot(x,y0,'-k', x,y1,'-r', x,y10,'-m', x,y100, '-b');
set(pl,'LineWidth',1);

xlabel('w_1');
ylabel('Loss');
legend('0-1 Loss', 'Sigmoidal Loss K=1', 'Smooth Loss K=10', 'Smooth Loss K=100');

subplot(1,2,2);
pl2 = plot(x(i2),y0(i2),'-k', x(i2),y1(i2),'-r', x(i2),y10(i2),'-m', x(i2),y100(i2), '-b');
set(pl2,'LineWidth',1);

xlabel('w_1');
ylabel('Loss');
legend('0-1 Loss', 'Sigmoidal Loss K=1', 'Smooth Loss K=10', 'Smooth Loss K=100');
