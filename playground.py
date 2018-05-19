#GIVEN AN ARRAY OF INTERGER SLOPES, FIND THE MINIMIMUM INCREMENT/DECREMENT NEEDED TO MAKE THE ARRAY INCREASING OR DECREASING
#[9,7,8,6,2,3,3] -> 2
#[1,2,2,3,3,4] ->0 (ALREADY INCREASING

def minChange(_slopes):
    # if negative, we are decreasing
    # if positive, we are increasing
    direction = _slopes[-1] - _slopes[0]

    # total change
    min = 0

    for i in range:
        print(i,fibonacci[i])






if __name__ == '__main__':
    slope1 = [9,7,8,6,2,3,3]
    slope2 = [1,2,2,3,3,4]
    minChange()