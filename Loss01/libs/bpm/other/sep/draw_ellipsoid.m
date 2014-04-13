function h = draw_ellipsoid(m, v)

c = chol(v);
[x,y,z] = sphere(50);
s = size(x);
p = [x(:) y(:) z(:)]*c;
p = p + repmat(m', rows(p), 1);
x = reshape(p(:,1), s);
y = reshape(p(:,2), s);
z = reshape(p(:,3), s);
held = ishold;
hold on
h = surf(x,y,z);
set(h,'FaceColor','interp','EdgeColor','none');
set(h,'FaceColor',[1 0 0.5]);
set(h,'AmbientStrength',0.3,'DiffuseStrength', 0.8, 'SpecularStrength', 0, ...
    'SpecularExponent', 10, 'SpecularColorReflectance', 1.0);
if ~held
  hold off
end
