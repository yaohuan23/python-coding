#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import sys
import argparse
import sys
def show_dir(dir_path):
    pwd=os.getcwd()
    sh_script=''' 
    #！/usr/bin/sh
    ls -1 {} >{}/ballow_temp
    '''.format(dir_path,dir_path)
    os.system(sh_script)
    sh_script = '''
    #! /usr/bin/sh
    sed -i 's#^#{}#g' {}/ballow_temp'''.format(dir_path, dir_path)
    print (sh_script)
    print("%s/ballow_temp" % dir_path)
    #ballow_file = file("{}/ballow_temp" % dir_path)
    #for line in ballow_file:
     #   line=line.strip()
      #  print(line)

#print(sh_script)
    #print(tmp_str)
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Do filter of the Ballow assembled transcriptions')
    parser.add_argument('csvfile',
                        help='input GTF file (use "-" for stdin)')
    parser.add_argument('-v', '--verbose',
                        dest='verbose',
                        action='store_true',
                        help='also print some statistics to stderr')

    args = parser.parse_args()
    if not args.csvfile:
        parser.print_help()
        exit(1)
    file_list=show_dir(args.csvfile)