import numpy as np
from l2_distance import l2_distance
from utils import *
import matplotlib.pyplot as plt
from util import *

def run_knn(k, train_data, train_labels, valid_data):
    """Uses the supplied training inputs and labels to make
    predictions for validation data using the K-nearest neighbours
    algorithm.

    Note: N_TRAIN is the number of training examples,
          N_VALID is the number of validation examples, 
          and M is the number of features per example.

    Inputs:
        k:            The number of neighbours to use for classification 
                      of a validation example.
        train_data:   The N_TRAIN x M array of training
                      data.
        train_labels: The N_TRAIN x 1 vector of training labels
                      corresponding to the examples in train_data 
                      (must be binary).
        valid_data:   The N_VALID x M array of data to
                      predict classes for.

    Outputs:
        valid_labels: The N_VALID x 1 vector of predicted labels 
                      for the validation data.
    """

    print train_data.shape
    print train_labels.shape
    print valid_data.shape

    dist = l2_distance(valid_data.T, train_data.T)
    nearest = np.argsort(dist, axis=1)[:,:k]

    train_labels = train_labels.reshape(-1)
    valid_labels = train_labels[nearest]

    # note this only works for binary labels
    valid_labels = (np.mean(valid_labels, axis=1) >= 0.5).astype(np.int)
    valid_labels = valid_labels.reshape(-1,1)

    print train_labels
    print valid_labels
    return valid_labels

def test_knn():
    
    train_data, valid_data, test_data, train_labels, valid_labels, test_labels = LoadData('digits.npz')
    classification_rate = []
    #train_data, train_labels = load_train()
    #if t_or_v == "t":
        #valid_data, correct_labels = load_test()
    #else:
        #valid_data, correct_labels = load_valid()
    x = np.append(valid_data, test_data, 1)
    y = np.append(valid_labels, test_labels, 1)[0]
    for num in [1,3,5,7,9]:
        classification_rate.append\
            (get_c_rate(run_knn(num, train_data.T, train_labels.T, x.T), \
             y.T))
    plt.plot([1,3,5,7,9], classification_rate)
    plt.xlabel("Num Neighbours")
    plt.ylabel("Classification Rate")
    plt.show()
    return classification_rate

def get_c_rate(valid_labels, correct_labels):
    
    count = 0.0
    for i in range(len(valid_labels)):
        if valid_labels[i] == correct_labels[i]:
            count += 1
    return count/len(valid_labels)