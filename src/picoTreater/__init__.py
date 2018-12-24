#!/usr/bin/env python
# this file is developed to filter the circRNA
from __future__ import print_function
from __future__ import division
from sys import stderr, exit
import sys
sys.path.append("/Applications/YH-work/python-coding")
sys.path.append("/Applications/YH-work/python-coding/venv/lib/python2.7")
#sys.path.append(" /PGD2/yaohuan/script/hisat2_RNA-seq/YH-tans-app")
from argparse import ArgumentParser, FileType
from src.yHpregtf2fasta import adjgtf
from src.samtreater import samfilter
from src.samtreater import bedFilter
from src.picoTreater import fastFilter
if __name__ == '__main__':
    description=" Rebuid the gtf file and extract the sequence information from a genome\
    to creat a circRNA reference data "
    parser = ArgumentParser(description=description)
    help="you should input a pregtf file "
    parser.add_argument('-i','--inputfile',type=str,help=help)
    help = "you should input a file where the result to put"
    parser.add_argument('-o', '--output', type=str, help=help)
    args = parser.parse_args()

    if not args.inputfile:
        parser.print_help()
        exit(1)
    if args.__contains__("inputfile") and args.__contains__("output"):
        inputFastq=args.inputfile
        outPutfile = args.output
        #print (outPutfile)
        #print(args.inputfile)
    else:
        print("you should in put a bedfile")
        exit(1)
    #fastFilter.filter(inputFastq,outPutfile)
    print(input())