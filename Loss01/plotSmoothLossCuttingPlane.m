%plot 2D cutting plane of the smooth loss function. 
%params.figId : #figure 
%params.X, params.t : Input data 
%params.w : Weights 
%params.K : Smoothness coeff. K of loss function; 
%params.R : Regularization coefficient of regularizer; 
%params.axisId : w axis defining the cutting plane
%params.range0 = -60; params.range1 = 10; from w(i)-60 to w(i)+10
%params.step = .1; 
function plotSmoothLossCuttingPlane(params)

figure(params.figId);

i = params.axisId;

range0 = params.w(i) + params.range0;
range1 = params.w(i) + params.range1;
x_points = range0:params.step:range1; 
f_points = zeros(1,length(x_points));
for k=1:length(x_points)
    wk = params.w;
    wk(i) = x_points(k);
    f_points(k) = calSmoothLoss(params.X, params.t, wk, params.K, params.R);
end

k0 = floor(abs(params.range0)/params.step) + 1;
plot(x_points(k0), f_points(k0), 'ro', x_points, f_points, 'b-');
xlabel(['Cutting Plane Along w_{', num2str(i-1),'}']);
ylabel(['Smooth Loss Value (K=', num2str(params.K), ', R=', num2str(params.R),')']);
legend(['w_{', num2str(i-1), '} = ', num2str(params.w(i))]);


end
