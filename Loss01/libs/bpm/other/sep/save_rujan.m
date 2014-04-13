function save_rujan(fname,x,y)
% Save data in rujan's format

[d,n] = size(x);
y = (y+1)/2;
fid = fopen(fname,'w');
fprintf(fid,'%d %d data 0\n', d, n);
for i = 1:n
  fprintf(fid, '%g ', x(:,i));
  fprintf(fid, '%d\n', y(i));
end
fclose(fid);
