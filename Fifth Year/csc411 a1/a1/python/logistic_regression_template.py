import numpy as np
from check_grad import check_grad
from plot_digits import *
from utils import *
from logistic import *
import matplotlib.pyplot as plt

_SMALL_CONSTANT = 1e-10

def run_logistic_regression():
    train_inputs, train_targets = load_train()
    #train_inputs, train_targets = load_train_small()
    test_inputs, test_targets = load_test()
    valid_inputs, valid_targets = load_valid()

    N, M = train_inputs.shape

    # TODO: Set hyperparameters
    hyperparameters = {
                    'learning_rate': .05,
                    'weight_regularization': .5,
                    'num_iterations': 100
                 }

    # Logistic regression weights
    #weights = np.random.rand(len(train_inputs[0]) + 1, 1)
    #weights = (np.random.rand(len(train_inputs[0]) + 1, 1) - 0.5) * 2
    #weights = np.zeros((len(train_inputs[0])+1, 1))
    weights = np.ones((len(train_inputs[0])+1, 1)) - .9
    #weights = np.reshape(np.append(np.mean(train_inputs, axis=0), np.mean(np.mean(train_inputs, axis=0))), (len(train_inputs[0])+1, 1))
    #weights = np.ones((len(train_inputs[0])+1, 1)) - np.zeros((len(train_inputs[0])+1, 1))

    # Verify that your logistic function produces the right gradient.
    # diff should be very close to 0.
    run_check_grad(hyperparameters)

    training_ce = []
    valid_ce = []

    # Begin learning with gradient descent
    for t in xrange(hyperparameters['num_iterations']):

        # TODO: you may need to modify this loop to create plots, etc.

        # Find the negative log likelihood and its derivatives w.r.t. the weights.
        f, df, predictions = logistic(weights, train_inputs, train_targets, hyperparameters)
        
        # Evaluate the prediction.
        cross_entropy_train, frac_correct_train = evaluate(train_targets, predictions)

        if np.isnan(f) or np.isinf(f):
            raise ValueError("nan/inf error")

        # update parameters
        weights = weights - hyperparameters['learning_rate'] * df / N

        # Make a prediction on the valid_inputs.
        predictions_valid = logistic_predict(weights, valid_inputs)

        # Evaluate the prediction.
        cross_entropy_valid, frac_correct_valid = evaluate(valid_targets, predictions_valid)
        
        # print some stats
        stat_msg = "ITERATION:{:4d}  TRAIN NLOGL:{:4.2f}  TRAIN CE:{:.6f}  "
        stat_msg += "TRAIN FRAC:{:2.2f}  VALID CE:{:.6f}  VALID FRAC:{:2.2f}"
        print stat_msg.format(t+1,
                              float(f / N),
                              float(cross_entropy_train),
                              float(frac_correct_train*100),
                              float(cross_entropy_valid),
                              float(frac_correct_valid*100))
        
        training_ce.append(cross_entropy_train)
        valid_ce.append(cross_entropy_valid)      
        
    predictions_test = logistic_predict(weights, test_inputs)
    cross_entropy_test, frac_correct_test = evaluate(test_targets, predictions_test) 
    print(str(cross_entropy_test) + ', ' + str((frac_correct_test * 100)))
        
    plt.plot(range(1, hyperparameters["num_iterations"]+1), training_ce, label="cross entropy train")
    plt.plot(range(1, hyperparameters["num_iterations"]+1), valid_ce, label="cross entropy valid")
    plt.legend()
    plt.show()

def run_check_grad(hyperparameters):
    """Performs gradient check on logistic function.
    """

    # This creates small random data with 20 examples and 
    # 10 dimensions and checks the gradient on that data.
    num_examples = 20
    num_dimensions = 10

    weights = np.random.randn(num_dimensions+1, 1)
    data = np.random.randn(num_examples, num_dimensions)
    targets = np.round(np.random.rand(num_examples, 1), 0)

    diff = check_grad(logistic,      # function to check
                      weights,
                      0.001,         # perturbation
                      data,
                      targets,
                      hyperparameters)

    print "diff =", diff

def check_params():
    
    #train_inputs, train_targets = load_train()
    train_inputs, train_targets = load_train_small()
    valid_inputs, valid_targets = load_valid()   
    test_inputs, test_targets = load_test()
    lambdas = [10, 1, 0.1, 0.01, 0.001]
    
    training_ce = [0] * len(lambdas)
    valid_ce = [0] * len(lambdas)
    training_error = [0] * len(lambdas)
    valid_error = [0] * len(lambdas)
    test_error = [0] * len(lambdas)
    
    N, M = train_inputs.shape    
    
    for num in range(len(lambdas)):   
        
        # TODO: Set hyperparameters
        hyperparameters = {
            'learning_rate': .05,
            'weight_regularization': lambdas[num],
            'num_iterations': 100
        }        
        
        for i in xrange(10):
        
            training_ce_show = []
            valid_ce_show = []        
        
            # Logistic regression weights
            #weights = np.random.rand(len(train_inputs[0]) + 1, 1)
            #weights = (np.random.rand(len(train_inputs[0]) + 1, 1) - 0.5) * 2
            #weights = np.zeros((len(train_inputs[0])+1, 1))
            weights = np.ones((len(train_inputs[0])+1, 1)) - .9
            #weights = np.random.normal(0, 1.0/hyperparameters["weight_regularization"], (len(train_inputs[0])+1,1))
            #weights = np.ones((len(train_inputs[0])+1, 1)) - np.zeros((len(train_inputs[0])+1, 1))            
        
            # Verify that your logistic function produces the right gradient.
            # diff should be very close to 0.
            run_check_grad(hyperparameters)
        
            # Begin learning with gradient descent
            
            for t in xrange(hyperparameters['num_iterations']):
        
                # TODO: you may need to modify this loop to create plots, etc.
        
                # Find the negative log likelihood and its derivatives w.r.t. the weights.
                f, df, predictions = logistic_pen(weights, train_inputs, train_targets, hyperparameters)
                
                # Evaluate the prediction.
                cross_entropy_train, frac_correct_train = evaluate(train_targets, predictions)
        
                if np.isnan(f) or np.isinf(f):
                    raise ValueError("nan/inf error")
        
                # update parameters
                weights = weights - hyperparameters['learning_rate'] * df / N
        
                # Make a prediction on the valid_inputs.
                predictions_valid = logistic_predict(weights, valid_inputs)
        
                # Evaluate the prediction.
                cross_entropy_valid, frac_correct_valid = evaluate(valid_targets, predictions_valid)   
                
                predictions_test = logistic_predict(weights, test_inputs)
                
                cross_entropy_test, frac_correct_test = evaluate(test_targets, predictions_test)
                
                #stat_msg = "ITERATION:{:4d}  TRAIN NLOGL:{:4.2f}  TRAIN CE:{:.6f}  "
                #stat_msg += "TRAIN FRAC:{:2.2f}  VALID CE:{:.6f}  VALID FRAC:{:2.2f}"
                #print stat_msg.format(t+1,
                                      #float(f / N),
                                      #float(cross_entropy_train),
                                      #float(frac_correct_train*100),
                                      #float(cross_entropy_valid),
                                      #float(frac_correct_valid*100)) 
                                      
                #training_ce_show.append(cross_entropy_train)
                #valid_ce_show.append(cross_entropy_valid)        
                
            
                
            training_ce[num] += cross_entropy_train
            valid_ce[num] += cross_entropy_valid
            #training_error[num] += (1 - (frac_correct_train / 100))
            #valid_error[num] += (1 - (frac_correct_valid / 100))
            training_error[num] += 1 - frac_correct_train
            valid_error[num] += 1 - frac_correct_valid         
            test_error[num] += 1 - frac_correct_test
            
            #plt.plot(range(1, hyperparameters["num_iterations"]+1), training_ce_show, label="cross entropy train")
            #plt.plot(range(1, hyperparameters["num_iterations"]+1), valid_ce_show, label="cross entropy valid")
            #plt.legend()
            #plt.show()        
            
        training_ce[num] = training_ce[num] / 10
        valid_ce[num] = valid_ce[num] / 10
        training_error[num] = training_error[num] / 10
        valid_error[num] = valid_error[num] / 10
        test_error[num] = test_error[num] / 10
        
        
    plt.figure()
        
    t_ce = plt.plot(lambdas, training_ce, label="cross entropy train")
    v_ce = plt.plot(lambdas, valid_ce, label="cross entropy valid")
    plt.legend()
    plt.show()
    
    plt.figure()
    
    plt.plot(lambdas, training_error, label="training error")
    plt.plot(lambdas, valid_error, label="valid error")
    plt.legend()
    plt.show()
    
    return test_error[3]

if __name__ == '__main__':
    run_logistic_regression()
