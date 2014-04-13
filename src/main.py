__author__ = 'qdengpercy'


from stoch import *




if __name__ =='__main__':
    ntr = 1000
    nte = 100
    iters = 10000
    beta = 1
    para = Para(iters)
    (xtr, ytr, yH, w) = gen_syn('disc', ntr, nte)
    (w, obj1) = rsg(xtr, ytr, beta, para)