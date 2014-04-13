if strcmp(cur_alg, 'RSG') == 1
    N_description = 'Iteration limit: ';
else
     N_description = 'Number of iterations: ';
end  
awr = menu(mtitle, [N_description ,num2str(N_iter)] , ['Evaluation sample size (K): ', num2str(N_vali)] , ['Number of runs: ', num2str(Run_times)] , ['Run: ', cur_alg], 'Change the algorithm');
if awr ==1
    N_iter = input('Enter the iteration limit: ');
elseif  awr ==2
    N_vali = input('Enter the size of evaluation sample (K): ');
    data.vali = N_vali;
elseif  awr ==3
    Run_times = input('Enter number of runs : ');
elseif  awr == 4
    eval(cur_alg2);
elseif  awr == 5
    running = 1;
    break
end
