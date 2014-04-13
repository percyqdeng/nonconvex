function show_vs(data, w, w2)
% plot the version space as a sphere

[d,n] = size(data);
if d == 2
  % 1D version space on the circle
  clf
  draw_circle([0;0], 1, 'b');
  axis([-1 1 -1 1]*1.2)
  for i = 1:n
    draw_line_clip(data(1,i), 0, -data(2,i), 'Color', 'g');
  end
  return
end
if d ~= 3
  error('version space is not 2D')
end

% plot a sphere
clf
[x,y,z] = sphere;
h = surf(x,y,z);
shading interp
if 0
  % Laplacian prior
  b = 1;
  c = (b/2*exp(-b*abs(x))) .* (b/2*exp(-b*abs(y))) .* (b/2*exp(-b*abs(z)));
  set(h, 'CData', c)
  %set(h, 'CDataMapping', 'direct')
else
  set(h,'FaceColor',[1 1 0]);
end
%material dull
% extra bright for poster
%set(h,'SpecularStrength',0)
set(h,'AmbientStrength',0.5)
set(h,'DiffuseStrength',0.5)

w = w/norm(w)*1.1;
view(w);
light('Position',w);
light('Position',w,'Style','local');

hold on
plot3(w(1), w(2), w(3), 'rx');
h = text(w(1), w(2)+0.1, w(3)+0.1, 'Bayes');
set(h,'FontSize',6);
if nargin > 2
  w2 = w2./repmat(sqrt(sum(w2.^2)),3,1)*1.1;
  plot3(w2(1,:), w2(2,:), w2(3,:), 'ro');
  h = text(w2(1,1), w2(2,1)+0.1, w2(3,1)+0.1, 'SVM');
  set(h,'FontSize',6);
end
hold off


for i = 1:n
  % plot a hyperplane
  if 1
    x = 1.1*[-1 -1; 1 -1; 1 1; -1 1]';
    y = x(2,:);
    x = x(1,:);
  end
  if 0
    z = (-1e-2 - x*data(1,i) - y*data(2,i))/data(3,i);
    patch(x,y,z,[1 0 0])
  end
  % blue faces toward valid solutions
  z = (1e-2 - x*data(1,i) - y*data(2,i))/data(3,i);
  h = patch(x,y,z,[0 1 1]);
  % this brightens without killing lighting
  set(h,'AmbientStrength',0.3)
  %set(h,'SpecularStrength',1)
  % this kills lighting effects
  set(h,'DiffuseStrength',0.5);
end

% gouraud shows edges better
lighting gouraud
axis([-1 1 -1 1 -1 1]*1.1)
axis square
axis off
