z = initial_solution;
if strcmp(cur_alg2, 'RSGF_2V') == 1
    r = N_iter;
else
    generating_rnd_num;
    r = r1;
end
total_run = total_run+1;
Run_number = Run_number + 1;
dv = 0;
while dv == 0
    zero_classic_SA;
    if norm(z) < 1e+4
        dv = 1;
        final_sol(Run_number,:) = z;
        final_solution = final_sol(Run_number,:)';
        total_solution(total_run,:) = final_solution;
    else
        z = initial_solution;
    end
end