fprintf('     \n');
if (strcmp(cur_alg, 'RSG') == 1) || (strcmp(cur_alg, '2-RSG') == 1)
    fprintf('      Iteration limit :%d\n',N_iter);
    
else
    fprintf('       Number of iterations :%d\n',N_iter);
end
if strcmp(data.problem, 'Least_sqr') == 1
    fprintf('     \n');
    fprintf('       Mean of function values :% 5.4f', mean_loss);
    fprintf('     \n');
    fprintf('      Variance of function values:% 4.2e\n', var_loss);
elseif strcmp(data.problem, 'Reg') == 1
    fprintf('     \n');
    fprintf('       Mean of squared norm of gradient :% 5.4f', mean_grad);
    fprintf('     \n');
    fprintf('      Variance of squared norm of gradinet:% 4.2e\n', var_grad);
elseif strcmp(data.problem, 'SVM') == 1
    fprintf('     \n');
    fprintf('       Mean of squared norm of gradient :% 5.4f', mean_grad);
    fprintf('     \n');
    fprintf('      Variance of squared norm of gradinet:% 4.2e\n', var_grad);
    fprintf('     \n');
    fprintf('      Average corresponding missclasification error:% 5.2f\n', mean_loss);
elseif strcmp(data.problem, 'Trig') == 1
    fprintf('     \n');
    fprintf('       Mean of squared norm of gradient :% 5.4f', mean_grad);
    fprintf('     \n');
    fprintf('      Variance of squared norm of gradinet:% 4.2e\n', var_grad);
    fprintf('     \n');
    fprintf('      Mean of corresponding function values:% 4.2e\n', var_grad);
end
