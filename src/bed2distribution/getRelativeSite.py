#!/usr/bin/env python

#
#this scriopt is writen by yaohuan to caculate a m5C/m6A site's relative position shown by % form
#

from __future__ import print_function
from __future__ import division
from sys import stderr, exit
from collections import defaultdict as dd, Counter
from argparse import ArgumentParser, FileType


def extract_exons(bedfile, verbose=False):
    for line in bedfile:
        line=line.strip()
        chrom,start,end,strand=line.split("\t")
        #print(line.split("\t"))
        #start=int(start)
        end=int(end)
        start=int(start)
        #print(end)
        #print(end - start)
        step=float((end-start)/50)
        for i in range(0,50,1):
            if strand == "+":
                print('{}\t{}\t{}\t{}\t{}'.format(chrom,int(start+i*step),int(start+i*step+step),strand,float(i/50)))
            else:
                print('{}\t{}\t{}\t{}\t{}'.format(chrom,int(end-i*step-step),int(end-i*step),strand,float(i/50)))
        exit(0)
    #print(bedfile)

if __name__ == '__main__':
    parser = ArgumentParser(
        description='Extract relative site of the exons')
    parser.add_argument('bedfile',
                        nargs='?',
                        type=FileType('r'),
                        help='input GTF file (use "-" for stdin)')
    parser.add_argument('-v', '--verbose',
                        dest='verbose',
                        action='store_true',
                        help='also print some statistics to stderr')

    args = parser.parse_args()
    if not args.bedfile:
        parser.print_help()
        exit(1)
    extract_exons(args.bedfile, args.verbose)
