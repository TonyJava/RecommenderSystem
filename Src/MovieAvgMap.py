#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys

movieRatings = {}

def addToDictionary(movieId, rating):
    # add rating to dictionary movieRatings
    if movieRatings.get(movieId) == None:
        movieRatingList = []
        movieRatingList.append(rating)
        movieRatings[movieId] = movieRatingList
    else:
        movieRatings[movieId].append(rating)

def emitMovieRatings():
    for key in movieRatings.keys():
        ratingStr = ' '.join(movieRatings[key])
        print "MRat " + key + " " + ratingStr

for line in sys.stdin:
    #remove any leading or trailing whitespace
    line = line.strip()
    data = line.split('::') # Read the input from STDIN 
    #userId = data[0]
    movieId = data[1]
    rating = data[2]
    addToDictionary(movieId, rating)
emitMovieRatings()
    