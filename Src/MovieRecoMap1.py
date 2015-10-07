#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin


output: 
NV userid movieid normalizedRating

eg:
NV 134 235 0.632123

NV => normalized value
'''

import sys
import random

userAvgRatings = {}
movieAvgRatings = {}

def initializeUserAvgRatings():
    # read user average ratings
    userAvgFile = open('userRatings_Avg.txt', 'r')
    for line in userAvgFile:
        data = line.split()
        userId = data[0]
        user_avgRating = data[1]
        
        #There will be a single entry for each userId. 
        #So we dont need to worry about checking if exists. 
        #We can directly add as its definitely not going to be there
        if userId != "HighestUser":
            userAvgRatings[userId] = float(user_avgRating)
    #print userAvgRatings
    #Free up resources
    #userAvgFile.close()

def initializeMovieAvgRatings():
    # read movie average ratings
    movieAvgFile = open('movieRatings_Avg.txt', 'r')
    for line in movieAvgFile:
        data = line.split()
        movieId = data[0]
        movie_avgRating = data[1]
        
        #There will be a single entry for each userId. 
        #So we dont need to worry about checking if exists. 
        #We can directly add as its definitely not going to be there
        if movieId != "HighestMovie":
            movieAvgRatings[movieId] = float(movie_avgRating)
    #print movieAvgRatings
    
    #Free up resources
    #movieAvgFile.close()

def main():
    initializeUserAvgRatings()
    initializeMovieAvgRatings()
    
    for line in sys.stdin:
        #remove any leading or trailing whitespace
        line = line.strip()
        data = line.split('::') # Read the input from STDIN 
        userId = data[0]
        movieId = data[1]
        rating = float(data[2])
        
        #rating = float(rating)
        normRating = rating - (0.5*userAvgRatings[userId]) - (0.5*movieAvgRatings[movieId])
        print "NV " + str(userId) + " " + str(movieId) + " %f" % normRating

main()