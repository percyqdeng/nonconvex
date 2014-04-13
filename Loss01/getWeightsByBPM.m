% Given the training set X, t
% Returns weights of the seperating hyperplane by Bayes Point Machine
function w = getWeightsByBPM(X,t)

%task = bpm_task(X,t,0,'probit',1);
task = bpm_task(X,t,0,'probit');
ep = train(bpm_ep(task), task);

w = ep.mw;
if cal01Loss(X,t,w) > cal01Loss(X,t,-w)
    w = -1 * w;
end


end

