#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys
import random
import numpy

'''
*** From ReadMe. Do not trust these values...they are approx...wasted my time... *** :(

# 10M
users = 71567 #users
movies = 10681 #movies
'''
'''
# 1M
users = 6040 #users
movies = 3900 #movies
'''
'''
# 100K
users = 943 #users
movies = 1682 #movies
'''

latentFactors = 10 # latent factors
alpha = 0.040 #learning rate
lambda_val = 0.3 # regularixation factor
users = 0
movies = 0
UMat = []
VMat = []

def emitUMatrix():
    count = 0
    for uMatRow in UMat:
        urowVals = str(' '.join("%.3f" % i for i in uMatRow))
        print "U " + str(count) + " " + str(latentFactors) + " " + urowVals
        count += 1
        
def emitVMatrix():
    count = 0
    for vMatRow in VMat:
        vrowVals = str(' '.join("%.3f" % j for j in vMatRow))
        print "V " + str(count) + " " + str(latentFactors) + " " + vrowVals
        count += 1

def getHighestUserCount():
    #print "================"
    userAvgFile = open('userRatings_Avg.txt', 'r')
    for line in userAvgFile:
        data = line.split()
        key = data[0]
        val = data[1]
        
        #print key
        #There will be a single entry for each userId. 
        #So we dont need to worry about checking if exists. 
        #We can directly add as its definitely not going to be there
        if key == "HighestUser":
            users = int(val)
    return users
    #print "================"
    #print userAvgRatings
    #Free up resources
    #userAvgFile.close()

def getHighestMovieCount():
    #print "================"
    movieAvgFile = open('movieRatings_Avg.txt', 'r')
    for line in movieAvgFile:
        data = line.split()
        key = data[0]
        val = data[1]
        
        #print key
        #There will be a single entry for each userId. 
        #So we dont need to worry about checking if exists. 
        #We can directly add as its definitely not going to be there
        if key == "HighestMovie":
            movies = int(val)
    return movies
    #print "================"
    


users = getHighestUserCount()
movies = getHighestMovieCount()

#print "Users : " + str(users)
#print "Movies : " + str(movies)

# create U and V matrices with initial random values
#UMat = (numpy.random.rand(users + 1, latentFactors) - 0.5)
#VMat = (numpy.random.rand(movies + 1, latentFactors) - 0.5)

bMatInit = False 
# since this time we are reading from the UVMatrix file, we need to popu;ate UMat and VMat from the data in that file
UVMatFile = open("UVMat.txt", 'r')
for line in UVMatFile:
    
    data = line.split()
    
    #init
    if (not bMatInit):
        latFact = int(data[2])
        UMat = numpy.zeros(shape=(users+1,latFact))
        VMat = numpy.zeros(shape=(movies+1,latFact))
        bMatInit = True
    
    tag = data[0]
    rowCount = int(data[1])
    rowValues = data[3:]
    
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
    data = line.split()
    #tag = data[0]
    userid = int(data[1])
    movieid = int(data[2])
    normalized_rating = float(data[3])
    
    #print "Userid : " + str(userid) + "Movieid : " + str(movieid)
    # get error
    error = normalized_rating - numpy.dot(UMat[userid,:], VMat[movieid,:])
    
    # Update matrices..!!    
    for i in xrange(latentFactors):
        UMat[userid][i] = UMat[userid][i] + alpha * (2 * error * VMat[movieid][i] - (lambda_val * UMat[userid][i]))
        VMat[movieid][i] = VMat[movieid][i] + alpha * (2 * error * UMat[userid][i] - (lambda_val * VMat[movieid][i]))
        #UMat[userid][i] = UMat[userid][i] + alpha * (2 * error * VMat[movieid][i])
        #VMat[movieid][i] = VMat[movieid][i] + alpha * (2 * error * UMat[userid][i])

#print "====== UMat After update values ========="
#print UMat
#print "==============="
#print "====== VMat After update values ========="
#print VMat
#print "==============="
emitUMatrix()
emitVMatrix()
