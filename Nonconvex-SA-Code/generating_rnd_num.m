stream1 = RandStream('mt19937ar','Seed',seed_val);
% RandStream.setDefaultStream(stream1);
RandStream.setGlobalStream(stream1);
r1 = randi(stream1,N_iter,1,num_rnd);