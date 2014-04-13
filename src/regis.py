import io
import numpy as np
import matplotlib.pyplot as plt
import random as rnd

def eval(x,y,sig1,sig2,A,b):
    obj = 0
    Nx = x.shape[0]
    Ny = y.shape[0]
    for i in range(0,Nx):
        for j in range(i+1,Nx):
            t = np.dot(A,(x[i,:]-x[j,:])[:, np.newaxis])
            obj += 1.0/(Nx**2)*np.exp(-0.5/sig1*(t**2).sum())
    for i in range(0,Nx):
        for j in range(0,Ny):
            t = np.dot(A,x[i, :][:,np.newaxis])+b-y[j,:][:,np.newaxis]
            obj -= 1.0/(Nx*Ny)*np.exp(-0.5/sig2*(t**2).sum())
    return obj

def regi_solver(x, y, sig1, sig2,max_iter,Astar,bstar):
    Nx = x.shape[0]
    Ny = y.shape[0]
    d = x.shape[1]
    rho = 1
    not_converge = True

    # it = np.random.randint()
    # A = np.eye(d)
    A = np.diag(np.array((0.1,0.2)))
    # A = np.random.multivariate_normal(np.zeros(2),np.eye(2),1)
    A = np.random.rand(2,2)
    # b = np.ones((d,1))*0.3
    b = bstar[:,np.newaxis]
    iter = 0
    dA = np.zeros(max_iter)
    db = np.zeros(max_iter)
    a = 1.0
    c = 1.0
    beta = 0.5
    step = max_iter/10
    while not_converge and iter <max_iter:
        rho = a/(c+np.power(iter,beta))
        samp = rnd.sample(range(Nx), 2)
        samp2 = rnd.sample(range(Ny), 1)
        i = samp[0]
        j = samp[1]
        xi = x[i,:][:,np.newaxis]
        xj = x[j,:][:,np.newaxis]
        xij = (xi - xj)
        tmp = np.dot(A, xij)
        k = samp2[0]
        yk = y[k,:][:,np.newaxis]
        pA = 1.0/(Nx**2)*np.exp(-0.5/(sig1**2)*(tmp**2).sum()) * \
             (-0.5/sig1**2)*(np.dot(A,np.dot(xij,xij.T))+np.dot(np.dot(xij,xij.T),A))
        tmp2 = np.dot(A, xi)+b-yk
        xiyk = (xi-yk)
        pA += -np.exp(-0.5/(sig2**2)*(tmp2**2).sum()) * \
              (-0.5/sig2**2)*(np.dot(A, np.dot(xiyk, xiyk.T))+np.dot(np.dot(xiyk, xiyk.T), A) \
            + np.dot(xi, (b-yk).T) + np.dot(b-yk,xi.T))
        pb = -np.exp(-0.5/(sig2**2)*(tmp2**2).sum()) * \
            (-1.0/sig2**2)*(np.dot(A,xi)-yk)

        A_new = A-rho*pA
        b_new = b-rho*pb
        dA[iter] = np.linalg.norm(A_new-Astar)
        db[iter] = np.linalg.norm(b_new-bstar)
        if iter%step == 0:
            print 'iter '+str(iter)+'(i,j,k) '+str(i)+','+str(j)+','+str(k)+','+ ' dA '+str(dA[i])+' db '+str(db[i])
            # print ' pa '+str(pA)+' pb '+str(pb)
        # b = b_new
        A = A_new
        iter += 1
    return A,b,dA,db


N = 30
K = -20

# x1 = np.linspace(-5,5,N,endpoint=True)
# x1 = x1[:,np.newaxis]
# x2 = K-x1
# x = np.hstack((x1,x2))
# A = np.diag([1,1])
# b = 5*np.ones(2)
# y = np.dot(x,A) + b[np.newaxis,:]
# tmp = np.vstack(((x,y)))
# # Cov = np.cov(tmp.T)
# Std = np.std(tmp,axis=0)
# tmp = tmp/Std[np.newaxis,:]
# x = tmp[0:N,:]
# y = tmp[N:,:]


Cov = 0.5*np.eye(2)
x = np.random.multivariate_normal(np.array((-0.5,-0.5)),Cov,N)
A = np.diag([1,1])
b = 2*np.ones(2)
y = np.dot(x,A) + b[np.newaxis,:]

row = 1
col = 2
plt.close()
plt.figure()
plt.subplot(row,col,1)
plt.scatter(x[:,0],x[:,1],marker='+')
plt.scatter(y[:,0],y[:,1],marker='o')

# plt.savefig('test.eps')
# plt.savefig('vis.eps')

max_iter = 600
(Aa,bb,dA,db) = regi_solver(x,y,1,1, max_iter, A, b)

# plt.close()
# plt.figure()
plt.subplot(row,col,2)
plt.plot(range(1,max_iter+1),dA,'ro',label='dA')
plt.plot(range(1,max_iter+1),db,'bx',label='db')
# plt.legend('dA','db')
plt.savefig('curve.eps')





