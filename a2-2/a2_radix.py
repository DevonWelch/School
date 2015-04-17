# -------------------------
# CSC236 Fall 2013
# Assignment 2 Question 6
# Names: Devon Welch, Hinson Hui
# Student Numbers: 999171747, 1000087595
# -------------------------


def msd_radix(A):
    '''
    Pre-condition: A is a non-empty list of positive integers
    Post-condition: A is sorted in non-decreasing order
    
    You will use a recursive helper function to divide a into buckets 
    based on the d-th digit
    '''
    # Find the length of the largest number in A
    largest = 0;
    for x in A:    # linear search for largest number in A
        if x > largest:
            largest = x
    length = len(str(largest))
    
    # Call recursive helper function
    B = sort_by_digit(A, length)
    for i in range(0, len(A)):
        A[i] = B[i]



# Your recursive helper function goes here.
# State appropriate pre- and post-conditions.
def sort_by_digit(A, length):
    '''
    Pre-condition: A is a non-empty list of positive integers
    Post-condition: A is sorted in non-decreasing order
    '''
    # You may find the following code helpful for defining your buckets.
    buckets = [[],[],[],[],[],[],[],[],[],[]]
    
    # DIVIDE the elements of A into ten different buckets
    base = 10 ** (length - 1)
    for x in A:
        index = int(str(x//base)[-1])
        buckets[index].extend([x])
    
    # RECURSIVELY sort each non-empty bucket
    if length > 1:
        for b in range(0,10):
            if len(buckets[b]) > 0:
                buckets[b] = sort_by_digit(buckets[b], length - 1)
    
    # COMBINE the buckets
    temp = []
    for i in range(0,10):
        temp.extend(buckets[i])
    return temp