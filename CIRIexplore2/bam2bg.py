from __future__ import print_function
from __future__ import division
from sys import stderr, exit
import sys
sys.path.append("/PGD2/yaohuan/script/CIRCexplorer2-master/circ2")
sys.path.append("/usr/local/lib/python2.7/dist-packages")
import pysam
import pybedtools
from argparse import ArgumentParser, FileType
from collections import defaultdict
from YHparser import parse_fusion_bam, Segment


def bam2bg(map_bam_fname, out_dir):
    print('Create BigWig file...')
    #map_bam_fname = "/PGD1/yaohuan/work_place/circRNAm5C-distribution/Tdata/lengthcircRNA/lengthfilter/hisat2/tophat/accepted_hits.bam"
    #out_dir = "/PGD1/yaohuan/work_place/circRNAm5C-distribution/Tdata/lengthcircRNA/lengthfilter/hisat2"
    # pysam.index(map_bam_fname)
    map_bam = pysam.Samfile(map_bam_fname, 'rb')
    chrom_size_fname = '%s/tophat/chrom.size' % out_dir
    with open(chrom_size_fname, 'w') as chrom_size_f:
        for seq in map_bam.header['SQ']:
            chrom_size_f.write('%s\t%s\n' % (seq['SN'], seq['LN']))
            mapped_reads = map_bam.mapped
        for read in map_bam:
            read_length = read.rlen
            break
        s = 1000000000.0 / mapped_reads / read_length
        #or s = 1
        map_bam = pybedtools.BedTool(map_bam_fname)
        bedgraph_fname = '%s/tophat/accepted_hits.bg' % out_dir
        with open(bedgraph_fname, 'w') as bedgraph_f:
            for line in map_bam.genome_coverage(bg=True,
                                                g=chrom_size_fname,
                                                scale=s, split=True):
                value = str(int(float(line[3]) + 0.5))
                bedgraph_f.write('\t'.join(line[:3]) + '\t%s\n' % value)

def tophat_fusion_parse(fusion, out, pair_flag=False):
    '''
    Parse fusion junctions from TopHat-Fusion aligner
    '''
    print('Start parsing fusion junctions from TopHat-Fusion...')
    fusions = defaultdict(int)
    for i, read in enumerate(parse_fusion_bam(fusion, pair_flag)):
        chrom, strand, start, end, xp_info = read
        segments = [start, end]

        if pair_flag is True:
            part_chrom, part_pos, part_cigar = xp_info.split()
            part_pos = int(part_pos)

            if chrom != part_chrom:
                continue

        if (i + 1) % 2 == 1:  # first fragment of fusion junction read
            interval = [start, end]
        else:  # second fragment of fusion junction read
            sta1, end1 = interval
            sta2, end2 = segments
            if end1 < sta2 or end2 < sta1:  # no overlap between fragments
                sta = sta1 if sta1 < sta2 else sta2
                end = end1 if end1 > end2 else end2

                if pair_flag is True:
                    if part_pos < sta or part_pos > end:
                        continue

                fusions['%s\t%d\t%d' % (chrom, sta, end)] += 1
    total = 0
    with open(out, 'w') as outf:
        for i, pos in enumerate(fusions):
            outf.write('%s\tFUSIONJUNC_%d/%d\t0\t+\n' % (pos, i, fusions[pos]))
            total += fusions[pos]
    outf.close()
    print('Converted %d fusion reads!' % total)


if __name__ == '__main__':
    description=" convert a bam to bg file format & then bg changed to bw "
    parser = ArgumentParser(description=description)
    help="you shouls input a bam and a output filename line *.bg with  absolute location"
    parser.add_argument('-i','--fusionFile',type=str,help=help)
    help="you shouls input a bam and a output dir"
    parser.add_argument('-o','--outputFile',type=str,help=help)
    args = parser.parse_args()
    if not args.inputfile:
        parser.print_help()
        exit(1)
    if not args.output:
        parser.print_help()
        exit(1)
    if args.__contains__("fusionFile"):
        fusion_f = args.fusionFile
        #print(args.inputfile)
    if args.__contains__("outputFile"):
        outfile = args.outputFile
    else:
        print("you should in put a bedfile")
        exit(1)
   # bam2bg(map_bam_fname, out_dir)
    tophat_fusion_parse(fusion_f,outfile)

