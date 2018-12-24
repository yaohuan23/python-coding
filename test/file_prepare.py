#!/usr/bin/env python
# this file is developed to filter the circRNA
from __future__ import print_function
from __future__ import division
from sys import stderr, exit
import sys
sys.path.append("/Applications/YH-work/python-coding")
sys.path.append("/Applications/YH-work/python-coding/venv/lib/python2.7")
from argparse import ArgumentParser, FileType
from src.yHBaloowTransFilter import file2hash
from src.yHBaloowTransFilter import levelBallowTransFilter
from src.yhBSJAanlysis import circnum2junctionnum
from src.yhBSJAanlysis import circular_filter
from src.yHpregtf2fasta import adjgtf
if __name__ == '__main__':
    description="filter the circRNA-out result & then todo some stastic jobs\
use this script line python program.py --inputfile [inputfile] --samplename [samplename]"
    parser = ArgumentParser(description=description)
    help="you should input a bedfile here"
    parser.add_argument('-i','--inputfile',type=str,help=help)
    help="you should told me the sample name which you are going to treat with"
    parser.add_argument('-n','--samplename',nargs=1,type=str,help=help)
    args = parser.parse_args()

    if not args.inputfile:
        parser.print_help()
        exit(1)
    if args.__contains__("inputfile"):
        bedfile=args.inputfile
        #print(args.inputfile)
    else:
        print("you should in put a bedfile")
        exit(1)
    if args.__contains__("samplename"):
        #print(args.samplename)
        samplename=args.samplename
    else:
        print("You should tell the script the sample name you are going to treat")

    #record_info = file2hash.csv2hash(args.csvfile, args.csvfile)
    #sample_list = record_info["sample_list"]
    #expression_record = record_info["expression_record"]
    #print(levelBallowTransFilter.filter(expression_record,sample_list,1))
    #result_matrix=circnum2junctionnum.juncstatic(args.inputfile,-20)
    #print(result_matrix)
    #circnum2junctionnum.plotDistrubution(result_matrix[1],samplename)
    circular_filter.junctionFilter(bedfile,1,samplename,0.95)
