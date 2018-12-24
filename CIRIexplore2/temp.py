import sys
sys.path.append("/PGD2/yaohuan/script/CIRCexplorer2-master/circ2")
sys.path.append("/usr/local/lib/python2.7/dist-packages")
import pysam
print('Create BigWig file...')
map_bam_fname = "/PGD1/yaohuan/work_place/circRNAm5C-distribution/Tdata/lengthcircRNA/lengthfilter/hisat2/tophat/accepted_hits.bam"
out_dir="/PGD1/yaohuan/work_place/circRNAm5C-distribution/Tdata/lengthcircRNA/lengthfilter/hisat2"
pysam.index(map_bam_fname)
map_bam =  pysam.AlignmentFile(map_bam_fname, 'rb')
chrom_size_fname = '%s/tophat/chrom.size' % out_dir
with open(chrom_size_fname, 'w') as chrom_size_f:
    for seq in map_bam.header['SQ']:
        chrom_size_f.write('%s\t%s\n' % (seq['SN'], seq['LN']))
        mapped_reads = map_bam.mapped
    for read in map_bam:
        read_length = read.query_length
        break
s = 1000000000.0 / mapped_reads / read_length
map_bam = pybedtools.BedTool(map_bam_fname)
bedgraph_fname = '%s/tophat/accepted_hits.bg' % out_dir
with open(bedgraph_fname, 'w') as bedgraph_f:
    for line in map_bam.genome_coverage(bg=True,
                                            g=chrom_size_fname,
                                            scale=s, split=True):
        value = str(int(float(line[3]) + 0.5))
        bedgraph_f.write('\t'.join(line[:3]) + '\t%s\n' % value)

