#!/usr/bin/env python
# this file is developed to filter the circRNA
from __future__ import print_function
from __future__ import division
from sys import stderr, exit
from argparse import ArgumentParser, FileType
from yHBaloowTransFilter import levelBallowTransFilter
from yHBaloowTransFilter import file2hash
if __name__ == '__main__':
    parser = ArgumentParser(
        description='Do filter of the Ballow assembled transcriptions')
    parser.add_argument('csvfile',
                        nargs='?',
                        type=FileType('r'),
                        help='input GTF file (use "-" for stdin)')
    parser.add_argument('-v', '--verbose',
                        dest='verbose',
                        action='store_true',
                        help='also print some statistics to stderr')

    args = parser.parse_args()
    if not args.csvfile:
        parser.print_help()
        exit(1)
    record_info = file2hash.csv2hash(args.csvfile, args.csvfile)
    sample_list = record_info["sample_list"]
    expression_record = record_info["expression_record"]
    print(levelBallowTransFilter.filter(expression_record,sample_list,0))