#!/usr/bin/env python
# this file is developed to filter the circRNA
from __future__ import print_function
from __future__ import division
from sys import stderr, exit
import sys
sys.path.append("/Applications/YH-work/python-coding")
sys.path.append("/Applications/YH-work/python-coding/venv/lib/python2.7")
from argparse import ArgumentParser, FileType
from src.yHpregtf2fasta import adjgtf
if __name__ == '__main__':
    description=" Rebuid the gtf file and extract the sequence information from a genome\
    to creat a circRNA reference data "
    parser = ArgumentParser(description=description)
    help="you should input a pregtf file "
    parser.add_argument('-i','--inputfile',type=str,help=help)
    args = parser.parse_args()

    if not args.inputfile:
        parser.print_help()
        exit(1)
    if args.__contains__("inputfile"):
        pregtfFile=args.inputfile
        #print(args.inputfile)
    else:
        print("you should in put a bedfile")
        exit(1)

    #adjgtf.rebuidGtf(pregtfFile)
    adjgtf.getBSJR(pregtfFile,"/Applications/YH-work/python-coding/test/circref-jun.fa")
    adjgtf.getaroundBSJ(pregtfFile,"/Applications/YH-work/python-coding/test/circref-Aroud.fa")

