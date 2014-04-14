__author__ = 'qdengpercy'

# from sklearn.ensemble import RandomForestClassifier
from numpy import linalg as LA
import matplotlib.pyplot as plt
import scipy.io
# import Ipython.display as display
import io
import random as rand
# from sigmoid import *
import numpy as np
from astropy.io import ascii

class Para:
    max_iter = 1

    S = 1 # the number of rounds for randomized SA
    def __init__(self, w0, w_star, max_iter = 1000, S = 1, L=1, sig=1):
        self.max_iter = max_iter/S
        self.S = S
        self.L = L
        self.sig = sig
        self.w_star = w_star    #optimal value
        self.w0 = w0    #initial value



def esti_para(x,lmd):
    '''
    estimate parameter of sigmoid function 2-2/n*sum_x 1/(1+e^-wx), using a batch of data, each row of x is a feature
    '''
    (n, p) = x.shape
    w = np.zeros(p)
    z = np.dot(x, w)
    H = 2 * np.dot(x.T, x)/n + lmd * np.eye(p)
    L, v = LA.eig(H)
    L = np.real(np.max(L))
    std = np.var(x, axis=0)
    sig = np.sqrt(np.sum(std))
    return L, sig

def sigmoid(x, w):
    '''
    sigmoid function 1/(1+e^-wx), each row of x is feature
    '''
    z = np.dot(x, w)
    res = 1.0/(1+np.exp(-z))
    return res

def grad_sigmoid(x, w):
    '''
    gradient of sigmoid function sum_x 1/(1+e^-wx), each row of x is a feature
    '''
    z = np.dot(x,w)
    p = 1.0/(1+np.exp(-z))
    grad = np.dot(x.T, p*(1-p))
    return grad

def spsa(x,y,beta,lmd, para):
    (n, p) = x.shape
    N = para.max_iter
    z = x * y[:, np.newaxis]
    z *= beta
    w = para.w0 + 0.0
    L = para.L
    sig = para.sig


def pegasos(x,y,beta,lmd,para):
    (n, p) = x.shape
    N = para.max_iter
    z = x * y[:, np.newaxis]
    z *= beta
    # w = para.w0 + 0.0
    w = np.zeros(p)
    L = para.L
    sig = para.sig


    for k in range(1,N+1):
        eta = 1/(lmd*k)
        ik = np.random.randint(n)
        zk = z[ik, :]
        if np.dot(zk, w) <1:
            w = (1-eta*lmd)*w + eta*zk
        else:
            w = (1-eta*lmd)*w

        w = np.minimum(1,1/(np.sqrt(lmd)*LA.norm(w)))*w
    return w

def rsg(x, y, beta, lmd, steprule, para):
    '''
    2- 2/n \sum 1/(1+exp(-b*y_n*x_n'w)) + lambda*w^2
    '''
    (n, p) = x.shape
    N = para.max_iter
    z = x * y[:, np.newaxis]
    z *= beta
    w = para.w0 + 0.0
    L = para.L
    sig = para.sig

    obj0 = 2 - 2*sigmoid(z, w).sum()/n +lmd * (w**2).sum()
    Df = np.sqrt(2 * obj0/L)
    Dt = Df

    if steprule == 1:
        gamma = np.minimum(1.0/L, Df/(sig*np.sqrt(N)))
        gamma = gamma * np.ones(N+1)
        R = np.random.random_integers(1, N, 1)
    elif steprule ==2:
        gamma = np.minimum(1/L, Dt*np.sqrt(range(1, N+1))/(sig*N))
        prob = (2*gamma-L*(gamma**2))/(2*gamma.sum()-L*(gamma**2).sum())
        R = np.random.choice(N, size=1, p=prob)+1
    else:
        gamma = np.minimum(1/L, Dt/(sig*np.power(N*range(1,N+1), 0.25)))
        prob = (2*gamma-L*(gamma**2))/(2*gamma.sum()-L*(gamma**2).sum())
        R = np.random.choice(N, size=1, p=prob)+1

    obj = np.zeros(R+1)
    grads_norm = np.zeros(R+1)
    acc = np.zeros(R+1)
    bsize = 1
    eta = 1
    for k in range(1, R+1):
        eta = 1.0/k
        ik = np.random.randint(n)
        zk = z[ik, :]
        w -= gamma[k] * (-2*grad_sigmoid(zk[np.newaxis, :], w)/bsize+2*lmd*w) + \
             0 # eta *np.random.normal(0,1,p)

        obj[k] = 2 - 2*sigmoid(z, w).sum()/n + lmd*LA.norm(w)**2
        acc[k] = np.mean(y == np.sign(np.dot(x, w)))
        grad = -2*grad_sigmoid(z, w)/n + 2*lmd * w
        grads_norm[k] = LA.norm(grad)

    # grad = -2*grad_sigmoid(z, w)/n + 2*lmd * w
    # grads_norm = LA.norm(grad)
    # obj = 2 - 2*sigmoid(z, w).sum()/n + lmd*LA.norm(w)**2
    # acc = np.mean(y == np.sign(np.dot(x, w)))

    print 'estimate L: '+str(L)+' sigma: '+str(sig) +' R: '+str(R)
    return w, obj, grads_norm, Df, acc, gamma

def rsg2(x, y, beta, lmd, steprule, para):
    # run rsg S times and return the optimal candidate
    (n, p) = x.shape
    S = para.S
    ws = np.zeros((S, p))
    grad_norm = np.zeros(S)
    obj = np.zeros(S)
    for s in range(S):
        res = rsg(x, y, beta, lmd, steprule, para)
        ws[s, :] = res[0]
        obj[s] = res[1]
        grad_norm[s] = res[2]

    i = np.argmin(np.abs(grad_norm))
    return ws[i, :], obj[i], grad_norm[i],0, 0, 0



def rsg2v(x, y, beta, lmd, steprule, para):
    (n, p) = x.shape
    N = para.max_iter * para.S
    z = x * y[:, np.newaxis]
    z *= beta
    w = para.w0 + 0.0
    L = para.L
    S = para.S
    sig = para.sig

    obj0 = 2 - 2*sigmoid(z, w).sum()/n +lmd * (w**2).sum()
    Df = np.sqrt(2 * obj0/L)
    Dt = Df

    if steprule == 1:
        gamma = np.minimum(1.0/L, Df/(sig*np.sqrt(N)))
        gamma = gamma * np.ones(N+1)
        R = np.random.random_integers(1, N, S)
    elif steprule ==2:
        gamma = np.minimum(1/L, Dt*np.sqrt(range(1, N+1))/(sig*N))
        prob = (2*gamma-L*(gamma**2))/(2*gamma.sum()-L*(gamma**2).sum())
        R = np.random.choice(N, size=1, p=prob)+1
    else:
        gamma = np.minimum(1/L, Dt/(sig*np.power(N*range(1,N+1), 0.25)))
        prob = (2*gamma-L*(gamma**2))/(2*gamma.sum()-L*(gamma**2).sum())
        R = np.random.choice(N, size=1, p=prob)+1


    ws = np.zeros((S, p))
    grad_norm = np.zeros(S)
    obj = np.zeros(S)

    # R_sup = R.max()
    # obj = np.zeros(R_sup+1)
    # grads = np.zeros(R_sup+1)
    # phase 1, run SA
    i = 0

    for k in range(1, N+1):
        ik = np.random.randint(n)
        # generate samples
        # xk, yk = sample_batch(p, para)
        zk = z[ik, :]
        w -= gamma[k] * (-2*grad_sigmoid(zk[np.newaxis, :], w)+2*lmd*w)
        if k in R:
            ws[i, :] = w
            obj[i] = 2-2*sigmoid(z, w).sum()/n + lmd*LA.norm(w)**2
            grad = -2*grad_sigmoid(z, w)/n + 2*lmd * w
            grad_norm[i] = LA.norm(grad)
            i += 1

        # grad = grad_sigmoid(x, w)/n + lmd * w
        # grads[k] = LA.norm(grad)
    # phase two, select from candidates


    i = np.argmin(np.abs(grad_norm))
    return ws[i, :], obj[i], grad_norm[i], 0,0,0



def sa(x, y, beta, N, opt):
    '''
    oridinary stochastic gradient descent  obj: 1/n*\sum_x 1/(1+exp(-beta*w*x)) + R(w)
    '''
    (n, p) = x.shape
    z = x * y[:, np.newaxis]
    z *= beta

def vis_sig(x, w0, beta=1, lmd=0.01):
    '''
    visualize sigmoid function
    1/(1 + exp(-beta*x*w))
    '''
    n, p = x.shape
    d = np.random.multivariate_normal(np.zeros(p),np.eye(p), 1)
    d = np.squeeze(d)
    eta = np.linspace(-10,10,100)
    obj = np.zeros(len(eta))
    for i, x in enumerate(eta):
        w = w0 + d*eta
        obj[i] = 1-sigmoid(x, w).sum()/n + lmd*LA.norm(w)**2
    plt.title('1d-view')
    plt.plot(eta, obj)


def sample_batch(n, p, para):
    x = np.random.binomial(1, 0.05, (n,p))
    x = np.squeeze(x)
    y = np.sign(np.dot(x, w))
    return x, y

def gen_syn(ftr_type,w_star, ntr=100, nte=1):
    '''
    get synthetic dataset as in Ghadimi's paper
    '''
    p = len(w_star)
    w = w_star

    if ftr_type == 'real':
        # x = np.random.multivariate_normal(mean, cov, ntr+nte)
        x = np.random.uniform(0, 1, (ntr+nte, p))
        nz = np.random.binomial(1, 0.95, (ntr+nte, p))
        x *= nz
        y = np.sign(np.dot(x, w))
        ytr = y[:ntr]
        yte = y[ntr:]

        xtr = x[:ntr, :]
        xte = x[ntr:, :]
        # yH = ytr[:, np.newaxis] * xtr
        # margin = np.min(np.dot(yH, w))
    elif ftr_type == 'disc':
        # binomial distribution with 0.05 sparse
        x = np.random.binomial(1, 0.05, (ntr+nte, p))
        y = np.sign(np.dot(x, w))
        ytr = y[:ntr]
        yte = y[ntr:]

        xtr = x[:ntr, :]
        xte = x[ntr:, :]
        # yH = ytr[:, np.newaxis] * xtr

    return xtr, ytr, xte, yte

def plot_convergence():
    x0, y0, w_star, w0 = load_Ghadi_data(0)
    lmd = 0.01
    L, sig = esti_para(x0, lmd)
    w0 = 5*w0
    # S = 5
    nte =1
    ntr = 6000
    step_rule = 1
    beta = 1

    (xtr, ytr, xte, yte) = gen_syn('disc', w_star, ntr, nte)
    para1 = Para(w0, w_star, ntr, 1, L, sig)
    (w, obj1, grads,  Df, acc_tr, gamma) = rsg(xtr, ytr, beta, lmd,  step_rule, para1)

    R = len(grads) -1
    plt.subplot(2,2,1)
    plt.ylabel('obj')
    plt.plot(range(1,R+1), obj1[1:R+1],'r')
    plt.subplot(2,2,2)
    plt.plot(range(1,R+1), grads[1:R+1],'r')
    plt.ylabel('norm of gradient',fontsize=11)
    plt.subplot(2,2,3)
    plt.plot(range(1,R+1), acc_tr[1:R+1],'r')
    plt.ylabel('accuracy',fontsize=11)
    plt.savefig('converg'+str(lmd)+'.eps')
             # plt.figure()
    # plt.plot(range(1,R+1), acc_tr[1:R+1],'r')

def load_Ghadi_data(choice=1):
    path = '../data/'
    if choice ==0:
        filename = "SVM-n100.mat"
    elif choice == 1:
        filename = "SVM-n500.mat"
    else:
        filename = "SVM-n1000.mat"

    data = scipy.io.loadmat(path+filename)
    w0 = np.squeeze(data['z_ini'])
    w_star = np.squeeze(data['z_sample'])
    xtr = data['estimate_matrix']
    ytr = np.squeeze(data['estimate_lable'])
    xtr = xtr.toarray()
    return xtr, ytr,w_star, w0

def debug_grad(x):
    '''
    check the gradient and objective value with finite difference
    '''
    (n, p) = x.shape
    w = np.random.multivariate_normal(np.zeros(p), np.eye(p), 1)
    w = np.squeeze(w)
    grad1 = grad_sigmoid(x, w)/n

    obj1 = sigmoid(x, w).sum()/n
    xi = np.random.multivariate_normal(np.zeros(p), np.eye(p), 1)
    xi = np.squeeze(xi)

    delta = 0.01
    diff = np.zeros(p)
    for i in range(p):
        xi = np.zeros(p)
        xi[i] =delta
        diff[i] = sigmoid(x, w+xi).sum()/n - sigmoid(x,w-xi).sum()/n
    grad2 = diff/(2*delta)
    res = LA.norm(grad1 - grad2)
    return res, grad1, grad2

def add_noise(xtr, ratio = 0.1):
    n, p = xtr.shape

    flag = np.random.binomial(1,ratio,(n,p))
    # ratio = 0.01
    noise = np.random.normal(0,1,(n,p))
    xtr = xtr + noise * flag
    return xtr

if __name__ == '__main__':
    '''
        toy test
            '''
    plot_convergence()
    beta = 2
    lmd = .01
    choiceset = np.array([0,1,2])
    choiceset = np.array([0])
    dimset = np.array([100, 500, 1000])
    dimest = np.array([100])
    # for choice in choiceset:
    #     # choice =
    #
    #
    # # self, w0, w_star, max_iter = 1000, S = 100, L=1, sig=1):
    # #
    #
    #     x0, y0, w_star, w0 = load_Ghadi_data(choice)
    #     w0 = 5 * w0
    #     L, sig = esti_para(x0, lmd)
    #     S = 5
    #     rep = 20
    #     num = 4
    #     acc_test = np.zeros((num, len(dimset), rep))
    #     grad_normsq = np.zeros((num-1,len(dimset), rep))
    #     acc_te = np.zeros([num, len(dimset), rep])
    #     Ntr = np.array((1000, 5000, 25000))
    #     for j,ntr in enumerate(Ntr):
    #         para1 = Para(w0, w_star, ntr, 1, L, sig)
    #         para2 = Para(w0, w_star, ntr, 5, L, sig)
    #         para3 = Para(w0, w_star, ntr, 5, L, sig)
    #         nte = 67000
    #
    #         step_rule = 1
    #         for i in range(rep):
    #             print 'rep'+str(i)
    #             (xtr, ytr, xte, yte) = gen_syn('disc', w_star, ntr, nte)
    #             xtr = add_noise(xtr, 0)
    #             (w, obj1, grads,  Df, acc_tr, gamma) = rsg(xtr, ytr, beta, lmd,  step_rule, para1)
    #             grad_normsq[0,j,i] = grads**2
    #             acc_te[0,j,i] = np.mean(yte == np.sign(np.dot(xte,w)))
    #
    #             (w, obj2, grads,  Df, acc_tr, gamma) = rsg2(xtr, ytr, beta, lmd,  step_rule, para2)
    #             grad_normsq[1,j,i] = grads**2
    #             acc_te[1,j,i] = np.mean(yte == np.sign(np.dot(xte,w)))
    #
    #             (w, obj3, grads,  Df, acc_tr, gamma) = rsg2v(xtr, ytr, beta, lmd,  step_rule, para3)
    #             grad_normsq[2,j,i] = grads**2
    #             acc_te[2,j,i] = np.mean(yte == np.sign(np.dot(xte, w)))
    #
    #             (w) = pegasos(xtr, ytr, beta, lmd, para1)
    #             acc_te[3,j,i] = np.mean(yte == np.sign(np.dot(xte, w)))
    #
    #     var_normsq = np.var(grad_normsq,axis=2)
    #     mean_normsq = np.mean(grad_normsq,axis=2)
    #     mean_acc = np.mean(acc_te,axis=2)


        # ascii.write(mean_acc.T,str(dim[choice])+'acc.tex',format='latex')
        # ascii.write(mean_normsq.T,str(dim[choice])+'mean_nm.tex',format='latex')
        # ascii.write(var_normsq.T,str(dim[choice])+'var_nm.tex',format='latex')
    # plt.figure()
    # plt.plot(range(1,R+1), obj1[1:R+1],'b')
    #
    # plt.ylabel('obj')
    # plt.figure()
    # plt.plot(range(1,R+1), grads[1:R+1],'r')
    # plt.ylabel('norm of gradient')
    # plt.figure()
    # plt.plot(range(1,R+1), acc_tr[1:R+1],'r')