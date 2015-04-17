# -------------------------
# CSC236 Fall 2013
# Assignment 2 Question 5
# Names: Devon Welch, Hinson Hui
# Student Numbers: 999171747, 1000087595
# -------------------------



def second_largest_dc(A):
    ''' 
    Pre-condition: A is a list of distinct positive integers of length at least 2
    Post-condition: returns the second largest element of A
    
    You must use a DIVIDE-AND-CONQUER approach for this question.
    It is much easier to do this question by using a recursive helper function,
    and simply calling it once here.
    '''
    
    # Call to recursive helper function goes here
    result = second_largest_dc_helper(A, 0, len(A) - 1)
    
    # Return the correct value here
    return result[1]


# Define your recursive helper function here
# State correct pre- and post-conditions.
def second_largest_dc_helper(A, i, j):
    '''
    Pre-condition: A is a list of distinct positive integers of length at least 2
                   0 <= i, j <= len(A);
    Post-condition: return the largest and second largest element in the sublist
    A - list of distinct positive integers with len(A) >= 2
    i, j - indices
    '''
    
    # Base case
    if j - i == 1:
        if A[i] > A[j]:
            return [A[i], A[j]]
        else:
            return [A[j], A[i]]
    elif j - i == 2:
        l = A[i]
        if A[i + 1] > l:
            x = l
            l = A[i + 1]
        else:
            x = A[i + 1]
        if A[j] > l:
            x = l
            l = A[j]
        elif A[j] > x:
            x = A[j]
        return [l, x]
    
    
    # Recursion
    
    # Divide range into two parts, and solve recursively
    m = (i + j) // 2
    list1 = second_largest_dc_helper(A, i, m)
    list2 = second_largest_dc_helper(A, m + 1, j)
    
    # Combine answers
    if list1[0] > list2[0]:
        if list2[0] >= list1[1]:
            result = [list1[0], list2[0]]
        else:
            result = [list1[0], list1[1]]
    elif list1[0] < list2[0]:
        if list1[0] >= list2[1]:
            result = [list2[0], list1[0]]
        else:
            result = [list2[0], list2[1]]
    elif list1[0] == list2[0]:
        if list1[1] >= list2[1]:
            result = [list1[0], list1[1]]
        else:
            result = [list1[0], list2[1]]

    # Return solution
    return result



def second_largest_it(A):
    ''' 
    Pre-condition: A is a list of distinct integers of length at least 2
    Post-condition: returns the second largest element of A
    
    You must use an iterative approach for this implementation. 
    That is, no recursion should be used!
    '''
    
    # Largest number
    largest = 0
    
    # 2nd largest number
    target = 0
    
    for i in A:
        if i > target:
            if i > largest:
                target = largest
                largest = i
            else:
                target = i
    
    return target
