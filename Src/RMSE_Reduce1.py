#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys
import math

nCount = 0
#primitiveSSE = 0
#normalizedSSE = 0
unnormalizedSSE = 0

for line in sys.stdin:
    #remove any leading or trailing whitespace
    line = line.strip()
    data = line.split()
    
    # get the mapper data
    # this is madness, but required..!!
    tag = data[0]
    userid = data[1]
    movieid = data[2]
    rating = float(data[4])
    #primitiveRating = float(data[6])
    #normalized_rating = float(data[8])
    #unnormalized_rating = float(data[10])
    unnormalized_rating = float(data[6])
    
    # compute the errors
    #error_primitive = rating - primitiveRating
    #error_normalized = rating - normalized_rating
    errro_unnormalized = rating - unnormalized_rating
    
    # SSE
    #primitiveSSE = primitiveSSE + math.pow(error_primitive, 2)
    #normalizedSSE = normalizedSSE + math.pow(error_normalized, 2)
    unnormalizedSSE = unnormalizedSSE + (errro_unnormalized * errro_unnormalized)
    
    nCount = nCount + 1

# RMSE
#primitiveRMSE = math.sqrt(primitiveSSE/nCount)
#normalizedRMSE = math.sqrt(normalizedSSE/nCount)
unnormalizedRMSE = math.sqrt(unnormalizedSSE/nCount)

# just emit this
#print "PrimitiveRMSE: %.3f" % primitiveRMSE
#print "NormalizedRMSE: %.3f" % normalizedRMSE
print "UnNormalizedRMSE: %.3f" % unnormalizedRMSE
