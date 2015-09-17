#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys

current_key = None
sum = 0.0
count = 0

# These are required because the ReadMe file says it contains approx values of movies.
# So we dont have the exact count and the highest id of the use and the movie
# This is important to know coz the values goes out of range when creating the U and V matrices
highestUser = 0

for line in sys.stdin:
    # split only twice. we dont want to lose ratings..
    data = line.split(" ",2)
    #tag = data[0]
    userId = data[1]
    ratings = data[2]
    
    key = userId
    
    if current_key and (current_key != key):
        avg = float(sum)/count
        print current_key + " " + str(avg)
        sum = 0
        count = 0
        
        usID = int(current_key)
        if usID > highestUser:
            highestUser = usID
    
    ratList = ratings.split()
    for rating in ratList:
        count = count + 1
        sum = sum + float(rating)
        current_key = key

avg = float(sum)/count
print current_key + " " + str(avg)

# used for creating the matrices when updating
print "HighestUser " + str(highestUser)
# emit:= UserId User_Rating_Avg
