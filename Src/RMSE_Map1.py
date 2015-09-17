#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys
import random
import numpy

userAvgRatings = {}
movieAvgRatings = {}
globalAvgRating = 0.0
users = 0
movies = 0
latentFactors = 10 # latent factors
alpha = 0.040 #learning rate
lambda_val = 0.3 # regularixation factor
#UMat = []
#VMat = []

def initializeGlobalAvgRatings():        
    # read the global average
    globalAvgFile = open('globalAvg.txt', 'r')
    for line in globalAvgFile:
        data = line.split()
        tag = data[0]
        globalAvgRating = float(data[1])
    return globalAvgRating
    #print globalAvgRating

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
            
        # get the highest user value
        if userId == "HighestUser":
            users = int(user_avgRating)
    return users

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
            
        # get the highest movie value
        if movieId == "HighestMovie":
            movies = int(movie_avgRating)
    #print movieAvgRatings
    return movies

globalAvgRating = initializeGlobalAvgRatings()
users = initializeUserAvgRatings()
movies = initializeMovieAvgRatings()

bMatInit = False 
# since this time we are reading from the UVMatrix file, we need to popu;ate UMat and VMat from the data in that file
UVMatFile = open("UVMat.txt", 'r')
for line in UVMatFile:
    data = line.split()
    tag = data[0]
    rowCount = int(data[1])
    rowValues = data[3:]
    
    # init the matrices with zeroes.
    # if we dont do this then we dont have U and V initialized
    # and cannot fill the matrices when we get UMat or VMat 
    if (not bMatInit):
        latFact = int(data[2])
        UMat = numpy.zeros(shape=(users+1,latentFactors))
        VMat = numpy.zeros(shape=(movies+1,latentFactors))
        bMatInit = True
    
    # check if we have UMat data
    if tag == "U":
        for index,val in enumerate(rowValues):
            UMat[rowCount][index] = float(val)
    
    # check if we have VMat data
    if tag == "V":
        for index,val in enumerate(rowValues):
            VMat[rowCount][index] = float(val)
            
#print "====== UMat initial values ========="
#print UMat
#print "==============="
#print "====== VMat initial values ========="
#print VMat
#print "==============="
    
for line in sys.stdin:
    #remove any leading or trailing whitespace
    line = line.strip()
    data = line.split('::') # Read the input from STDIN 
    userId = data[0]
    movieId = data[1]
    rating = float(data[2])
    
    # get the roe counts for both the matrices
    UMatRowCnt = UMat.shape[0]
    VMatRowCnt = VMat.shape[0]
    
    # fill the user dictionary
    if userId not in userAvgRatings:
        userAvgRatings[userId] = globalAvgRating
    
    # fill the movie dictionary
    if movieId not in movieAvgRatings:
        movieAvgRatings[movieId] = globalAvgRating
    
    # user bias and movie bias
    userBias = userAvgRatings[userId] - globalAvgRating
    movieBias = movieAvgRatings[movieId] - globalAvgRating
    
    #primitiveRating = globalAvgRating + userBias + movieBias
    #normalized_rating = rating - (0.5*userAvgRatings[userId]) - (0.5*movieAvgRatings[movieId])
    
    # to acomodate the conversion between string and int and to query from dictionary
    userIDStr = userId
    movieIDStr = movieId
    
    userId = int(userId)
    movieId = int(movieId)
    
    estimated_norm_rating = 0
    if (userId < UMatRowCnt or movieId < VMatRowCnt):
        estimated_norm_rating = numpy.dot(UMat[userId,:],VMat[movieId,:])
    
    unnormalized_rating = estimated_norm_rating + (0.5*userAvgRatings[userIDStr]) + (0.5*movieAvgRatings[movieIDStr])
    
    # print "RMSE %d %d Actual: %.1f Primitive: %.3f Est_Norm: %.3f Est_UnNorm: %.3f" % (userId, movieId, rating, primitiveRating, normalized_rating, unnormalized_rating)
    #print "RMSE %d %d Actual: %.1f Est_UnNorm: %f" % (userId, movieId, rating, unnormalized_rating)
    print "RMSE " + str(userId) + " " + str(movieId) + " Actual: %.1f" %(rating) + " UnNorm: %.1f" %(unnormalized_rating)
        