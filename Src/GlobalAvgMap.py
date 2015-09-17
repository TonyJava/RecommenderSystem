#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys

for line in sys.stdin:
    #remove any leading or trailing whitespace
    line = line.strip()
    data = line.split('::') # Read the input from STDIN 
    userId = data[0]
    movieId = data[1]
    rating = data[2]
    
    print "GAvg: " + rating
    