""" Methods for doing logistic regression."""

import numpy as np
from utils import sigmoid

def logistic_predict(weights, data):
    """
    Compute the probabilities predicted by the logistic classifier.

    Note: N is the number of examples and 
          M is the number of features per example.

    Inputs:
        weights:    (M+1) x 1 vector of weights, where the last element
                    corresponds to the bias (intercepts).
        data:       N x M data matrix where each row corresponds 
                    to one data point.
    Outputs:
        y:          :N x 1 vector of probabilities. This is the output of the classifier.
    """
    
    t = np.transpose(np.repeat(np.reshape(weights[:-1], (len(weights)-1, 1)), len(data), axis = 1))
    f_e = data * t
    z_sums = np.sum(f_e, axis=1)    
    
    x = -z_sums - weights[-1]
    y = sigmoid(z_sums + weights[-1])

    return np.reshape(y, (len(y), 1))

def evaluate(targets, y):
    """
    Compute evaluation metrics.
    Inputs:
        targets : N x 1 vector of binary targets. Values should be either 0 or 1
        y       : N x 1 vector of probabilities.
    Outputs:
        ce           : (scalar) Cross entropy.  CE(p, q) = E_p[-log q].  Here
                       we want to compute CE(targets, y).
        frac_correct : (scalar) Fraction of inputs classified correctly.
    """
    # TODO: Finish this function
    
    
    num_correct = np.sum(np.equal(np.round(y), targets))

    ce = -np.sum(targets * np.log(y))

    frac_correct = float(num_correct) / (len(y) + 1)
    
    
    return ce, frac_correct

def logistic(weights, data, targets, hyperparameters):
    """
    Calculate negative log likelihood and its derivatives with respect to weights.
    Also return the predictions.

    Note: N is the number of examples and 
          M is the number of features per example.

    Inputs:
        weights:    (M+1) x 1 vector of weights, where the last element
                    corresponds to bias (intercepts).
        data:       N x M data matrix where each row corresponds 
                    to one data point.
        targets:    N x 1 vector of binary targets. Values should be either 0 or 1.
        hyperparameters: The hyperparameters dictionary.

    Outputs:
        f:       The sum of the loss over all data points. This is the objective that we want to minimize.
        df:      (M+1) x 1 vector of derivative of f w.r.t. weights.
        y:       N x 1 vector of probabilities.
    """
    
    t = np.transpose(np.repeat(np.reshape(weights[:-1], (len(weights)-1, 1)), len(data), axis = 1))
    f_e = data * t
    z_sums = np.sum(f_e, axis=1)
    y = sigmoid(z_sums +weights[-1])
    f = np.sum(np.log(1 + np.exp(-z_sums - weights[-1])) + (1 - np.transpose(targets)) * (z_sums + weights[-1]))
    df = np.sum(data * np.transpose(((-np.exp(-z_sums - weights[-1]) / (1 + np.exp(-z_sums - weights[-1]))) + (1 - np.transpose(targets)))), axis = 0)
    df = np.append(df, np.sum(np.transpose(((-np.exp(-z_sums - weights[-1]) / (1 + np.exp(-z_sums - weights[-1]))) + (1 - np.transpose(targets)))), axis = 0))
    df = np.reshape(df, ((len(df), 1)))

    return f, df, np.reshape(y, (len(y), 1))


def logistic_pen(weights, data, targets, hyperparameters):
    """
    Calculate negative log likelihood and its derivatives with respect to weights.
    Also return the predictions.

    Note: N is the number of examples and 
          M is the number of features per example.

    Inputs:
        weights:    (M+1) x 1 vector of weights, where the last element
                    corresponds to bias (intercepts).
        data:       N x M data matrix where each row corresponds 
                    to one data point.
        targets:    N x 1 vector of binary targets. Values should be either 0 or 1.
        hyperparameters: The hyperparameters dictionary.

    Outputs:
        f:             The sum of the loss over all data points. This is the objective that we want to minimize.
        df:            (M+1) x 1 vector of derivative of f w.r.t. weights.
    """

    wr = hyperparameters['weight_regularization']
    
    t = np.transpose(np.repeat(np.reshape(weights[:-1], (len(weights)-1, 1)), len(data), axis = 1))
    f_e = data * t
    z_sums = np.sum(f_e, axis=1)
    y = sigmoid(z_sums +weights[-1])
    f = np.sum(np.log(1 + np.exp(-z_sums - weights[-1])) + (1 - np.transpose(targets)) * (z_sums + weights[-1]))
    df = np.sum(data * np.transpose(((-np.exp(-z_sums - weights[-1]) / (1 + np.exp(-z_sums - weights[-1]))) + (1 - np.transpose(targets)))), axis = 0)
    df = np.append(df, np.sum(np.transpose(((-np.exp(-z_sums - weights[-1]) / (1 + np.exp(-z_sums - weights[-1]))) + (1 - np.transpose(targets)))), axis = 0))

    f += np.dot(weights[:-1].transpose()[0], weights[:-1].transpose()[0]) * wr / 2
    df = np.reshape(df, ((len(df), 1)))
    df += np.reshape(np.append(weights[:-1] * wr, 0), (len(weights), 1))

    f += (weights[-1, 0] ** 2) * wr / 2
    df[-1] += weights[-1,0] * wr    

    return f, df, np.reshape(y, (len(y), 1))