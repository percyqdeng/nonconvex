function printSolution(name, X, t, w)

loss = cal01Loss(X, t, w);
fprintf('%s:\n  *** Loss = %d; w = %s\n', name, loss, mat2str(w',4));

end

