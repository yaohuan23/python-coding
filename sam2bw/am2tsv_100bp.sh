#!/bin/bash
###############################################################################
# 
# Author: jingyi
# Created Time: Wed Oct 21 16:14:52 2015
# 
###############################################################################


EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome amFile"
exit
fi


get_count=/data/jingyi/scripts/bam2bw/get_counts_gw.pl
chr_len_bed=/sharedata/genome/$1_chr_len_bed
cleanwig=/data/jingyi/scripts/bam2bw/clean_chr_boundary.py
genomeHeader=/sharedata/genome/$1/$1.fa.fai

if [[ $2 =~ "sam" ]]
then
input=${2%.sam}
samtools view -bt $genomeHeader $input.sam | bamToBed -i - | cut -f1-3 | sort -k1,1 -k2,2n > $input.short
fi

if [[ $2 =~ "bam" ]]
then
input=${2%.bam}
bamToBed -i $input.bam | cut -f1-3 > $input.short
fi

$get_count $input.short 100 $chr_len_bed > $input\_rpk.wig
total_read=`wc -l $input.short`
factor=`echo $total_read | cut -f1 -d" "`
mfactor=$((factor/1000000))
echo "$input\t$mfactor"
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4*10)/'$mfactor'}' $input\_rpk.wig | egrep -v "chrM" | grep -v "_" > $input\_rpkm.wig
$cleanwig $1 $input\_rpkm.wig
awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_rpkm.wig > $input\_100bp_rpkm.tsv

rm $input\_rpkm.wig
rm $input\_rpk.wig
rm $input.short
rm $input\_rpkm.wig.tmp
