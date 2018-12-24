#!/bin/bash
###############################################################################
# 
# Author: jingyi
# Created Time: Thu Sep 10 10:32:34 2015
# 
###############################################################################

EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome amFile"
exit
fi
genomeHeader=/data/jingyi/sharedata/genome/$1/$1.fa.fai
input=${2%.sam}
chr_len=/data/jingyi/sharedata/genome/$1_chr_len.txt
chr=/data/jingyi/scripts/bam2bw/GO.bed2wig_$1_wei

if [[ $2 =~ "sam" ]]
then
input=${2%.sam}
samtools view -bt $genomeHeader $input.sam | bamToBed -i - | cut -f1-3 | sort -k1,1 -k2,2n > $inp
fi

if [[ $2 =~ "bam" ]]
then
input=${2%.bam}
bamToBed -i $input.bam | cut -f1-3 > $input.short
fi

total_read=`wc -l $input.short`
factor=`echo $total_read | cut -f1 -d" "`
mfactor=$((factor/1000000))

slopBed -i $input.short -g $chr_len -l 0 -r 250 -s > $input.long.bed
$chr $input.long.bed 1 $1
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4*10)/('$mfactor'*3)}' $input.long.bed.min1.wig | egrep -v "chrM" | grep -v "_" | grep -v track > $input\_300bp_rpkm.wig
rm $input.short
rm $input\_rpk.wig
rm $input.long.bed*

