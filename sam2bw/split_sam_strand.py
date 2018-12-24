#!/usr/bin/env python
"""This is a program to split the strand for sam files"""


__version__ = "0.1"
__description__ = ""

import sys
from optparse import OptionParser
import re

def main():
    usage = "usage: %prog File.sam"
    parser = OptionParser(usage, description=__description__,
            version=__version__)
    parser.add_option("-v", "--verbose",
                    action="store_true", dest="verbose")

    (opts, args) = parser.parse_args()
    
    if len(args) < 1:
        print usage
        sys.exit()

    infileName = args[0]
    input = open(infileName,"r")
    output1 = args[0].split('.')[0] + '.f.sam'
    output2 = args[0].split('.')[0] + '.r.sam'
    read_watson = open(output1,"w")
    read_crick = open(output2,"w")
 
    for line in input:
    	line = line.strip()
	field = line.split('\t')
        flag = int(field[1])
	if flag/16 < 16:
		div = flag/16
	else:
		div = flag/16%16
	#print div
	if div >= 8:
		read = "2nd"
		if div%2 == 1:
			map = "rev"
			strand = "watson"
		else:
			map = "for"
			strand = "crick"	
	else:
		read = "1st"
		if div%2 == 1:
			map = "rev"
			strand = "crick"
		else:
			map = "for"
			strand = "watson"
	#print strand
	# NOTE !!! Based on the end results, the strand should be switched
	if strand == "watson": read_crick.write(line+"\n")	
	elif strand == "crick": read_watson.write(line+"\n")	
	else: print "Errors..strand not assigned"

if __name__ == "__main__":
    main()
