% compre SVM and BPM
% BPM is smooth while SVM is sparse
% smoothness is at odds with sparsity?

% example3 is model selection example

if 0
  clf
  mobile_points(10,'o')
  mobile_points(10,'x')
  axis manual
  c = get(gca,'children');
  X = [];
  Y = [];
  for i = 1:length(c)
    xd = get(c(i),'xdata');
    yd = get(c(i),'ydata');
    m = get(c(i),'marker');
    X = [X; xd(:) yd(:)];
    Y = [Y; repmat(strcmp(m, 'o'), length(xd), 1)];
  end
  Y = 2*Y-1;
  save example2.mat X Y
end

figure(1)
i1 = find(Y > 0);
i0 = find(Y < 0);
plot(X(i1,1), X(i1,2), 'o', X(i0,1), X(i0,2), 'x');

% addpath('/u/tpminka/tex/phd/matlab/svm')
global p1
% example2: wide = 0.5, narrow = 0.2
% example3: wide = 0.6, narrow = 0.08
if 1
  p1 = 0.05;
  ker = 'rbf';
else
  p1 = 1;
  ker = 'poly';
end
K = svkernelmtx(ker,X);
C = diag(Y)*K*diag(Y);
[s,alpha] = ep_kernel(C);
fprintf('evidence = %g\n', s)
alpha = alpha';

%m = min(abs(K*diag(Y)*alpha));

inc = 5e-3;
if 1
  r = -1:inc:1;
  Xt = lattice(repmat([-1 inc 1], 2, 1))';
else
  % example2
  r = -0.5:inc:1.5;
  Xt = lattice(repmat([-0.5 inc 1.5], 2, 1))';
end

Kt = svkernelmtx(ker,Xt,X)*diag(Y);
Yt = sign(Kt*alpha);
Yt = reshape(Yt, length(r), length(r));
hold on
[c,h1] = contour(r, r, Yt, [0 0], 'r');
hold off
drawnow
return

if 0
  % normalize cols (not needed for rbf kernel)
  z = sqrt(1./diag(K));
  K = scale_rows(scale_cols(K,z),z);
  Kt = scale_cols(Kt,z);
end
% for example3 it is important to set bias=0
Cslack = Inf;
[alpha,bias,K,margin] = svc(X,Y,K,Cslack,0);
% addpath('/u/tpminka/tex/phd/matlab')
%alpha = kbilliard(X,Y,ker,alpha,10000);

b = (radius(X,K)/margin)^2;
fprintf('margin bound = %g\n', b);

% span bound
epsilon = svtol(Cslack);
svii = find( alpha > epsilon & alpha < (Cslack - epsilon));
Ksv = K(svii,svii);
q = alpha(svii)./diag(inv(Ksv)) - 1;
%q = alpha(svii) - diag(inv(Ksv));
b = sum(q > 0);
fprintf('span bound = %g\n', b);

Yt = sign(Kt*alpha+bias);
Yt = reshape(Yt, length(r), length(r));
hold on
[c,h2] = contour(r, r, Yt, [0 0], 'b');
hold off

if 0
  % for example2
  axis([-0.4 1 -0.5 1.5])
  set(gca,'xtick',[],'ytick',[])
  legend([h1,h2], 'BPM','SVM')

  axis([0 0.7 0 1])
  set(gca,'xtick',[],'ytick',[])
  set(gcf,'Paperpos',[0.25 2.5 3 4])
  print -dpng gpc.png
end
