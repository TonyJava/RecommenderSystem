#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys

userRatings = {}

def addToDictionary(userid, rating):
    # add rating to dictionary userRatings
    if userRatings.get(userId) == None:
        userRatingList = []
        userRatingList.append(rating)
        userRatings[userId] = userRatingList
    else:
        userRatings[userId].append(rating)

def emitUserRatings():
    for key in userRatings.keys():
        ratingsStr = ' '.join(userRatings[key])
        print "URat " + key + " " + ratingsStr

for line in sys.stdin:
    #remove any leading or trailing whitespace
    line = line.strip()
    data = line.split('::') # Read the input from STDIN 
    userId = data[0]
    #movieId = data[1]
    rating = data[2]
    addToDictionary(userId, rating)
emitUserRatings()
