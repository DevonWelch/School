%% get the digit data
clear all

%load fruit_train
%load fruit_valid
load digits;
inputs_train = [train2 train3];
inputs_valid = [valid2 valid3];
inputs_test = [test2 test3];
target_train = [zeros(size(train2, 2), 1) ; ones(size(train3, 2), 1)]';
target_valid = [zeros(size(valid2, 2), 1) ; ones(size(valid3, 2), 1)]';
target_test = [zeros(size(test2, 2), 1) ; ones(size(test3, 2), 1)]';

clear train2;
clear train3;
clear valid2;
clear valid3;
clear test2;
clear test3;

%% initialize the net structure.
num_inputs = size(inputs_train, 1);
num_hiddens = 10;
num_outputs = 1;

%%% make random initial weights smaller, and include bias weights
W1 = 0.01 * randn(num_inputs, num_hiddens);
b1 = zeros(num_hiddens, 1);
W2 = 0.01 * randn(num_hiddens, num_outputs);
b2 = zeros(num_outputs, 1);

dW1 = zeros(size(W1));
dW2 = zeros(size(W2));
db1 = zeros(size(b1));
db2 = zeros(size(b2));

eps = 0.1;  %% the learning rate 
momentum = 0.0;   %% the momentum coefficient

num_epochs = 100; %% number of learning epochs (number of passes through the
                 %% training set) each time runbp is called.

total_epochs = 0; %% number of learning epochs so far. This is incremented 
                    %% by numEpochs each time runbp is called.

%%% For plotting learning curves:
min_epochs_per_plot = 200;
train_errors = zeros(1, min_epochs_per_plot);
valid_errors = zeros(1, min_epochs_per_plot);
epochs = [1 : min_epochs_per_plot];


