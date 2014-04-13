%plot 2D cutting plane of the smooth loss function. 
%params.figId : #figure 
%params.X, params.t : input data 
%params.w, params.w0 : weights w, w0 
%params.smoothness : smoothness coeff. K of loss function; 
%params.axisId : w axis defining the cutting plane
%params.range0 = -60; params.range1 = 10; from w(i)-60 to w(i)+10
%params.step = .1; 
function plot01Loss(X,t,w)

params.X = X; 
params.t = t; 
params.w = w; 
params.range0 = -6; params.range1 = 6;
params.step = .2; 

figure(10);


subplot(3,1,[1 2]);

[W1,W2,Z] = mesh01LossGrid(params);
mesh(W1,W2,Z);
hold on;
i0 = int64(floor(length(Z(1,:)) / 2)) + 1;
plot3(W1(i0,i0), W2(i0,i0), Z(i0,i0));%, 'sk', 'markerfacecolor',[0,0,0]);
view(117,24);
xlabel('w_1');
ylabel('w_2');
zlabel('0-1 Loss');
hold off;

%figure(11);
subplot(3,1,3);
i = 2; %axisId
params.range0 = -3; params.range1 = 2;
params.step = .001; 

range0 = params.w(i) + params.range0;
range1 = params.w(i) + params.range1;
x_points = range0:params.step:range1; 
f_points = zeros(1,length(x_points));
for k=1:length(x_points)
    wk = params.w;
    wk(i) = x_points(k);
    f_points(k) = cal01Loss(params.X, params.t, wk);
end

k0 = floor(abs(params.range0)/params.step) + 1;

pl = plot(x_points(k0), f_points(k0), 'ro', x_points, f_points, 'b-');
set(pl,'LineWidth',1);

xlabel(['w_{', num2str(i-1),'}']);
ylabel('0-1 Loss');
legend('Global minimum');


end
