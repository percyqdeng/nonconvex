__author__ = 'qdengpercy'

from sklearn.ensemble import RandomForestClassifier
from numpy import linalg as LA
import matplotlib.pyplot as plt
import io
import random as rand
# from sigmoid import *
import numpy as np
class Para:
    max_iter = 1
    S = 1 # the number of rounds for randomized SA
    def __init__(self, max_iter = 1000, S = 100):
        self.max_iter = max_iter
        self.S = S

def grad_sigmoid(x, w):
    '''
    gradient of sigmoid function sum_x 1/(1+e^-wx), each row of x is a feature
    '''
    z = np.dot(x,w)
    p = 1.0/(1+np.exp(-z))
    grad = np.dot(x.T, p*(1-p))
    return grad


def esti_para(x):
    '''
    estimate parameter of sigmoid function sum_x 1/(1+e^-wx), using a batch of data, each row of x is a feature
    '''
    (n, p) = x.shape
    w = np.zeros(p)
    z = np.dot(x, w)
    p = 1.0/(1+np.exp(-z))
    # grad_mat = x*(p*(1-p))[:,np.newaxis]
    # cov = np.cov(grad_mat,axis = 0)
    # [e, v] = LA.eig(cov)
    # h = p*(1-p)*(1-2*p)
    H = np.dot(x.T, x)
    L, v = LA.eig(H)
    L = np.max(L)
    avg = np.mean(x, axis=0)
    x2 = x - avg[np.newaxis, :]
    e = LA.norm(x2,2,axis=1)**2
    sig = np.sqrt(np.mean(e))
    return L, sig

def sigmoid(x, w):
    '''
    sigmoid function 1/(1+e^-wx), each row of x is feature
    '''
    z = np.dot(x, w)
    res = 1.0/np.exp(-z)
    return res


def rsg(x, y, beta, lmd, steprule, para):
    (n, p) = x.shape
    N = para.max_iter
    z = x * y[:, np.newaxis]
    z *= beta
    w = np.zeros(p)
    batch = 100
    ind = rand.sample(range(n), batch)
    L, sig = esti_para(x[ind, :])
    L /= batch
    L += lmd
    print 'estimate L: '+str(L)+' sigma: '+str(sig)
    obj0 = sigmoid(z, w).sum()/n
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
    grads = np.zeros(R+1)

    for k in range(1, R+1):
        ik = np.random.randint(n)
        zk = z[ik,:]
        w = w - gamma[k] * (grad_sigmoid(zk[np.newaxis, :], w)+lmd*w)
        obj[k] = sigmoid(z, w).sum()/n + lmd*LA.norm(w)**2
        grad = grad_sigmoid(x, w)/n + lmd * w
        grads[k] = LA.norm(grad)
    return w, obj, grads, R, sig, Df

def rsg2(x, y, beta , lmd, steprule, para):
    # run rsg S times and return the optimal candidate
    (n, p) = x.shape
    S = para.S
    ws = np.zeros((S, p))
    grad_norm = np.zeros(S)
    obj = np.zeros(S)
    for s in range(S):
        res = rsg(x, y, beta, lmd, steprule)
        ws[s, :] = res[0]
        obj[s] = res[1][:]
        grad_norm[s] = res[2][:]

    i = np.argmin(np.abs(grad_norm))
    return ws[i, :], grad_norm[i]


def rsg2v(x, y, beta, lmd, steprule, para):
    (n, p) = x.shape
    S = para.S
    N = para.max_iter * S
    z = x * y[:, np.newaxis]
    z *= beta
    w = np.zeros(p)
    batch = 100
    ind = rand.sample(range(n), batch)
    L, sig = esti_para(x[ind, :])
    L /= batch
    L += lmd
    print 'estimate L: '+str(L)+' sigma: '+str(sig)
    obj0 = sigmoid(z, w).sum()/n
    Df = np.sqrt(2 * obj0/L)
    Dt = Df

    # R here corresponds to the indices of the S candidates
    if steprule == 1:
        gamma = np.minimum(1.0/L, Df/(sig*np.sqrt(N)))
        gamma = gamma * np.ones(N+1)
        # R = np.random.random_integers(1, N, 1)
        R = np.random.choice(N, size=S, replace=False)+1
    elif steprule ==2:
        gamma = np.minimum(1/L, Dt*np.sqrt(range(1, N+1))/(sig*N))
        prob = (2*gamma-L*(gamma**2))/(2*gamma.sum()-L*(gamma**2).sum())
        R = np.random.choice(N, size=S, p=prob)+1
    else:
        gamma = np.minimum(1/L, Dt/(sig*np.power(N*range(1,N+1), 0.25)))
        prob = (2*gamma-L*(gamma**2))/(2*gamma.sum()-L*(gamma**2).sum())
        R = np.random.choice(N, size=S, p=prob)+1

    R_sup = R.max()
    obj = np.zeros(R_sup+1)
    grads = np.zeros(R_sup+1)
    # phase 1, run SA
    i = 0
    w_cand = np.zeros(S,p)
    for k in range(1, R_sup+1):
        ik = np.random.randint(n)
        zk = z[ik, :]
        w = w - gamma[k] * (grad_sigmoid(zk[np.newaxis, :], w)+lmd*w)
        if k in R:
            w_cand[i, :] = w
            i += 1
        obj[k] = sigmoid(z, w).sum()/n + lmd*LA.norm(w)**2
        grad = grad_sigmoid(x, w)/n + lmd * w
        grads[k] = LA.norm(grad)
    # phase two, select from candidates
    grad_cand = grads[R]

    i = np.argmin(np.abs(grad_cand))
    return w_cand[i, :]



def sa(x, y, beta, N, opt):
    '''
    oridinary stochastic gradient descent  obj: 1/n*\sum_x 1/(1+exp(-beta*w*x)) + R(w)
    '''
    (n, p) = x.shape
    z = x * y[:, np.newaxis]
    z *= beta

def gen_syn(ftr_type, ntr, nte):
    '''
    get synthetic dataset as in Ghadimi's paper
    '''
    p = 100
    mean = np.zeros(p)
    cov = np.eye(p)
    w = np.random.multivariate_normal(mean, cov, 1)
    w = np.squeeze(w)
    w /= LA.norm(w, 1)
    if ftr_type == 'real':
        x = np.random.multivariate_normal(mean, cov, ntr+nte)
        y = np.sign(np.dot(x, w))
        ytr = y[:ntr]
        yte = y[ntr:]
        # add noise to data
        noise = np.random.multivariate_normal(mean, 0.8*cov, ntr+nte)
        x += noise
        xtr = x[:ntr, :]
        xte = x[ntr:, :]
        yH = ytr[:, np.newaxis] * xtr
        margin = np.min(np.dot(yH, w))
    elif ftr_type == 'disc':
        x = np.random.binomial(1, 0.95, (ntr+nte, p))
        # x[x == 0] = -1
        y = np.sign(np.dot(x, w))
        ytr = y[:ntr]
        yte = y[ntr:]
        # add noise to data
        # flips = np.random.binomial(1, 0.95, (ntr+nte, p))
        # flips[flips == 0] = -1
        # x *= flips
        xtr = x[:ntr, :]
        xte = x[ntr:, :]
        yH = ytr[:, np.newaxis] * xtr

    return xtr, ytr, xte, yte, w

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

if __name__ == '__main__':
    '''
        toy test
            '''

    ntr = 1000
    nte = 10000
    iters = 10000
    beta = 1
    lmd = .1
    para = Para(iters)
    (xtr, ytr, xte, yte, w) = gen_syn('disc', ntr, nte)
    # res = debug_grad(xtr)
    (w, obj1, grads, R, sig, Df) = rsg(xtr, ytr, beta, lmd,  1, para)

    # R = len(obj1)
    plt.plot(range(1,R+1), obj1[1:R+1],'b')
    plt.ylabel('obj')
    plt.figure()
    plt.plot(range(1,R+1), grads[1:R+1],'r')
    plt.ylabel('norm of gradient')