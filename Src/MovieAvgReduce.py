#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys

# same as word count

current_key = None
sum = 0.0
count = 0

# These are required because the ReadMe file says it contains approx values of movies.
# So we dont have the exact count and the highest id of the use and the movie
# This is important to know coz the values goes out of range when creating the U and V matrices
highestMovie = 0

for line in sys.stdin:
    # split only twice. we dont want to lose ratings..
    data = line.split(" ",2)
    tag = data[0]
    movieId = data[1]
    ratings = data[2]
    
    key = movieId
    
    if current_key and (current_key != key):
        avg = float(sum)/count
        print current_key + " " + str(avg)
        sum = 0
        count = 0
        
        movID = int(current_key)
        if movID > highestMovie:
            highestMovie = movID
    
    ratList = ratings.split()
    for rating in ratList:
        count = count + 1
        sum = sum + float(rating)
        current_key = key

avg = float(sum)/count
print current_key + " " + str(avg)

# used for craeting the matrices while updating
print "HighestMovie " + str(highestMovie)
# emit:= MovieId Movie_Rating_Avg
