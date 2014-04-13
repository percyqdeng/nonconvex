__author__ = 'qdengpercy'


import io
import numpy as np
from numpy import linalg as LA
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import random as rnd
# from IPython.display import display

#
path = '/Users/qdengpercy/workspace/nonconvex/output/'


def draw_sig(x, y):
    N = x.shape[0]
    w = np.zeros((2, 1))
    I = np.arange(-9, 9, 0.2)
    J = np.arange(-9, 9, 0.2)
    Ny = len(J)
    Nx = len(I)
    C = 0.01
    I,J = np.meshgrid(I,J)
    res = np.zeros((Ny,Nx))
    for i in range(Nx):
        for j in range(Ny):
            w[:,0] = [I[i,j], J[i,j]]
            z = np.dot(x,w)
            res[j][i] = (1/(1+np.exp(-z*y))).sum()/N + C*(w**2).sum()

    fig = plt.figure()
    ax = fig.add_subplot(121)
    ax.scatter(x[:,0],x[:,1],c=y)
    # plt.scatter(x[:,0],x[:,1],'bo')
    ax = fig.add_subplot(122,projection='3d')
    # ax = fig.gca(projection='3d')
    ax.plot_surface(I,J,res)
    plt.savefig(path+'aaa.eps',format='eps')
    return

def gen_gaussian(N):
    mean1 = -1*np.array((1,1))
    cov1 = 0.5*np.diag((1,1))
    x1 = np.random.multivariate_normal(mean1,cov1,N)
    y1 = np.ones((N,1))
    mean2 = np.array((1,1))
    cov2 = 0.5*np.diag((1,1))
    x2 = np.random.multivariate_normal(mean2, cov2 ,N)
    y2 = -np.ones((N,1))
    return (x1,x2,y1,y2)




(x1,x2,y1,y2) = gen_gaussian(100)

x = np.concatenate((x1,x2),axis=0)
y = np.concatenate((y1,y2),axis=0)
draw_sig(x,y)
# f = plt.figure()
# plt.scatter(x1[:,0],x1[:,1],'bo')

# plt.scatter(x2[:,0],x2[:,1],'ro')
# plt.savefig('aaa.eps',format='eps')
# plt.plot
# display(f)