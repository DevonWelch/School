%%%%% Test network's performance on the test set %%%%%
num_test_cases = size(inputs_test, 2);
h_input = W1' * inputs_test + repmat(b1, 1, num_test_cases);  % Input to hidden layer.
h_output = 1 ./ (1 + exp(-h_input));  % Output of hidden layer.
logit = W2' * h_output + repmat(b2, 1, num_test_cases);  % Input to output layer.
prediction = 1 ./ (1 + exp(-logit));  % Output prediction.
test_CE = -mean(mean(target_test .* log(prediction) + (1 - target_test) .* log(1 - prediction)));

fprintf(1,'Test CE=%f\n', test_CE);

