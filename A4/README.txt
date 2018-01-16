#---------------------------------------------------------------
# Assignment:           4
# Due Date:             April 1, 2016
# Name:                 Chuan Yang
# Unix ID:              chuan1
# Lecture Section:      B1
# Lab Section:          H3
# Teaching Assistant(s):   ----- -----

Run:

PART 1: xspim -mapped_io -exception_file lab4-exception.s -file a4-pyramid.s
PART 2: xspim -mapped_io -exception_file lab4-exception.s -file a4-random.s


Algorithm of calculate the X:

main idea: get the last 2 digits of the sum

1. get the sum of the ascii number of all the input characters
2. use and(logical and) with (0111 1111)bin = 0x7f = (127)dec
   because 99 = (0110 0011)bin, so we firstly need to get the number in these digits
3. check the number we get in step 2:
	if X >= 100:    X-= 100
	else:	 	continue
4. print X

