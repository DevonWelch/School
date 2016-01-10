from kmeans import *
import sys
import matplotlib.pyplot as plt
plt.ion()

def mogEM(x, K, iters, minVary=0):
  """
  Fits a Mixture of K Gaussians on x.
  Inputs:
    x: data with one data vector in each column.
    K: Number of Gaussians.
    iters: Number of EM iterations.
    minVary: minimum variance of each Gaussian.

  Returns:
    p : probabilities of clusters.
    mu = mean of the clusters, one in each column.
    vary = variances for the cth cluster, one in each column.
    logProbX = log-probability of data after every iteration.
  """
  N, T = x.shape

  # Initialize the parameters
  randConst = 1
  p = randConst + np.random.rand(K, 1)
  p = p / np.sum(p)
  mn = np.mean(x, axis=1).reshape(-1, 1)
  vr = np.var(x, axis=1).reshape(-1, 1)
 
  # Change the initializaiton with Kmeans here
  #--------------------  Add your code here --------------------  
  #mu = mn + np.random.randn(N, K) * (np.sqrt(vr) / randConst)
  mu = KMeans(x, K, 5)
  #------------------------------------------------------------  
  vary = vr * np.ones((1, K)) * 2
  vary = (vary >= minVary) * vary + (vary < minVary) * minVary

  logProbX = np.zeros((iters, 1))

  # Do iters iterations of EM
  for i in xrange(iters):
    # Do the E step
    respTot = np.zeros((K, 1))
    respX = np.zeros((N, K))
    respDist = np.zeros((N, K))
    logProb = np.zeros((1, T))
    ivary = 1 / vary
    logNorm = np.log(p) - 0.5 * N * np.log(2 * np.pi) - 0.5 * np.sum(np.log(vary), axis=0).reshape(-1, 1)
    logPcAndx = np.zeros((K, T))
    for k in xrange(K):
      dis = (x - mu[:,k].reshape(-1, 1))**2
      logPcAndx[k, :] = logNorm[k] - 0.5 * np.sum(ivary[:,k].reshape(-1, 1) * dis, axis=0)
    
    mxi = np.argmax(logPcAndx, axis=1).reshape(1, -1) 
    mx = np.max(logPcAndx, axis=0).reshape(1, -1)
    PcAndx = np.exp(logPcAndx - mx)
    Px = np.sum(PcAndx, axis=0).reshape(1, -1)
    PcGivenx = PcAndx / Px
    logProb = np.log(Px) + mx
    logProbX[i] = np.sum(logProb)

    print 'Iter %d logProb %.5f' % (i, logProbX[i])

    # Plot log prob of data
    plt.figure(1);
    plt.clf()
    plt.plot(np.arange(i), logProbX[:i], 'r-')
    plt.title('Log-probability of data versus # iterations of EM')
    plt.xlabel('Iterations of EM')
    plt.ylabel('log P(D)');
    plt.draw()

    respTot = np.mean(PcGivenx, axis=1).reshape(-1, 1)
    respX = np.zeros((N, K))
    respDist = np.zeros((N,K))
    for k in xrange(K):
      respX[:, k] = np.mean(x * PcGivenx[k,:].reshape(1, -1), axis=1)
      respDist[:, k] = np.mean((x - mu[:,k].reshape(-1, 1))**2 * PcGivenx[k,:].reshape(1, -1), axis=1)

    # Do the M step
    p = respTot
    mu = respX / respTot.T
    vary = respDist / respTot.T
    vary = (vary >= minVary) * vary + (vary < minVary) * minVary
  
  return p, mu, vary, logProbX

def mogLogProb(p, mu, vary, x):
  """Computes logprob of each data vector in x under the MoG model specified by p, mu and vary."""
  K = p.shape[0]
  N, T = x.shape
  ivary = 1 / vary
  logProb = np.zeros(T)
  for t in xrange(T):
    # Compute log P(c)p(x|c) and then log p(x)
    logPcAndx = np.log(p) - 0.5 * N * np.log(2 * np.pi) \
        - 0.5 * np.sum(np.log(vary), axis=0).reshape(-1, 1) \
        - 0.5 * np.sum(ivary * (x[:, t].reshape(-1, 1) - mu)**2, axis=0).reshape(-1, 1)

    mx = np.max(logPcAndx, axis=0)
    logProb[t] = np.log(np.sum(np.exp(logPcAndx - mx))) + mx;
  return logProb

def q3():
  iters = 10
  minVary = 0.01
  inputs_train, inputs_valid, inputs_test, target_train, target_valid, target_test = LoadData('digits.npz')
  # Train a MoG model with 20 components on all 600 training
  # vectors, with both original initialization and kmeans initialization.
  #------------------- Add your code here ---------------------
  #m = mogEM(inputs_train, 20, 20, 0.01)
  #return m
def q4():
  iters = 10
  minVary = 0.01
  errorTrain = np.zeros(4)
  errorTest = np.zeros(4)
  errorValidation = np.zeros(4)
  print(errorTrain)
  numComponents = np.array([2, 5, 15, 25])
  T = numComponents.shape[0]  
  inputs_train, inputs_valid, inputs_test, target_train, target_valid, target_test = LoadData('digits.npz')
  train2, valid2, test2, target_train2, target_valid2, target_test2 = LoadData('digits.npz', True, False)
  train3, valid3, test3, target_train3, target_valid3, target_test3 = LoadData('digits.npz', False, True)
  
  for t in xrange(T): 
    K = numComponents[t]
    # Train a MoG model with K components for digit 2
    #-------------------- Add your code here --------------------------------
    mog2train = mogEM(train2, K, iters, minVary)
    #mog2test = mogEM(test2, K, iters, minVary)
    #mog2valid = mogEM(valid2, K, iters, minVary)
    
    # Train a MoG model with K components for digit 3
    #-------------------- Add your code here --------------------------------
    mog3train = mogEM(train3, K, iters, minVary)
    #mog3test = mogEM(test3, K, iters, minVary)
    #mog3valid = mogEM(valid3, K, iters, minVary)
    
    # Caculate the probability P(d=1|x) and P(d=2|x),
    # classify examples, and compute error rate
    # Hints: you may want to use mogLogProb function
    #-------------------- Add your code here --------------------------------
    prior2 = np.sum(target_train)/np.size(target_train)
    prior3 = 1 - prior2
    p2train = np.exp(mogLogProb(mog2train[0], mog2train[1], mog2train[2], inputs_train)) * prior2
    p3train = np.exp(mogLogProb(mog3train[0], mog3train[1], mog3train[2], inputs_train)) * prior3
    p1tr = p2train / (p2train + p3train)
    p2tr = p3train / (p2train + p3train)
    
    p2valid = np.exp(mogLogProb(mog2train[0], mog2train[1], mog2train[2], inputs_valid)) * prior2
    p3valid = np.exp(mogLogProb(mog3train[0], mog3train[1], mog3train[2], inputs_valid)) * prior3
    p1va = p2valid / (p2valid + p3valid)
    p2va = p3valid / (p2valid + p3valid)
    
    p2test = np.exp(mogLogProb(mog2train[0], mog2train[1], mog2train[2], inputs_test)) * prior2
    p3test = np.exp(mogLogProb(mog3train[0], mog3train[1], mog3train[2], inputs_test)) * prior3
    p1te = p2test / (p2test + p3test)
    p2te = p3test / (p2test + p3test)
    
    errorTrain[t] = np.sum(abs(p1tr - target_train) < 0.5) / float(p1tr.size)
    errorTest[t] = np.sum(abs(p1te - target_test) < 0.5) / float(p1te.size)
    errorValidation[t] = np.sum(abs(p1va - target_valid) < 0.5) / float(p1va.size)
    
  # Plot the error rate
  plt.clf()
  #-------------------- Add your code here --------------------------------
  plt.plot(numComponents, errorTrain, 'b', label='Train Error')
  plt.plot(numComponents, errorTest, 'g', label='Test Error')
  plt.plot(numComponents, errorValidation, 'r', label='Validation Error')
  plt.xlabel('Num Components')
  plt.ylabel('Classification Error')
  plt.legend()  

  plt.draw()
  raw_input('Press Enter to continue.')

def q5():
  # Choose the best mixture of Gaussian classifier you have, compare this
  # mixture of Gaussian classifier with the neural network you implemented in
  # the last assignment.

  # Train neural network classifier. The number of hidden units should be
  # equal to the number of mixture components.

  # Show the error rate comparison.
  #-------------------- Add your code here --------------------------------

  raw_input('Press Enter to continue.')

if __name__ == '__main__':
  m = q3()
  q4()
  q5()

