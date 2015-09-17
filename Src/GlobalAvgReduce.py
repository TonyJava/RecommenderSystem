#! /usr/bin/env python
'''
Created on Apr 15, 2015
@author: Jatin
'''

import sys

# same as word count

current_key = None
count = 0
sum = 0
for line in sys.stdin:
    data = line.split()
    key = data[0]
    val = data[1]
    
    if current_key and (current_key != key):
        avg = float(sum)/count
        print current_key + " " + str(avg)
        sum = 0
        count = 0
    else:
        count = count + 1
        sum = sum + float(val)
        current_key = key
avg = float(sum)/count
print current_key + " " + str(avg)

# emit:= GAvg: Global_Average
