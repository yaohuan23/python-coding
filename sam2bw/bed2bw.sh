#!/bin/bash

EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome bedFile"
exit
fi

input=${2%.short}
chr_len_bed=/sharedata/genome/$1_chr_len_bed
genomeHeader=/sharedata/genome/$1/$1.fa.fai
get_count=/data/jingyi/scripts/bam2bw/get_counts_gw.pl
wig2bigwig=/data/jingyi/scripts/bam2bw/wig2bigwig.sh
cleanwig=/data/jingyi/scripts/bam2bw/clean_chr_boundary.py
split_strand=/data/jingyi/scripts/bam2bw/split_sam_strand.py
UCSCheader="track type=bigWig name=$input description=$input bigDataUrl=http://166.111.156.41/jingyi/web/$web_folder/$input\_rpkm.bw viewLimits=3:20 visibility=2 windowingFunction=maximum maxHeightPixels=30 autoScale=off color=0,0,255"


echo $input

sort -k1,1 -k2,2n $input.short > $input.bed 
$get_count $input.bed 100 $chr_len_bed > $input\_rpk.wig
total_read=`wc -l $input.bed`
factor=`echo $total_read | cut -f1 -d" "`
echo $factor
mfactor=$((factor/100000)) ### Here it is actually /1,000,000 * 10 = 100,000 to get 1kb per million
if [ $mfactor != 0 ]; 
then 
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4/'$mfactor'*10)}' $input\_rpk.wig | egrep -v "chrM" > $input\_rpkm.wig
$cleanwig $1 $input\_rpkm.wig
#awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_rpkm.wig > $input\_rpkm.tsv
#sort -k1,1 -k2,2n $input\_rpkm.wig > $input\_rpkm_sorted.wig
$wig2bigwig $1 $input\_rpkm.wig
echo $UCSCheader | cat ./header.txt - > ./header_new.txt
sed 's/\\_/_/g' ./header_new.txt > ./header.txt
#mv $input\_rpkm.bw /webhtml/henchen/
fi


#split the strand if necessary

rm $input\_rpkm.wig.tmp
#rm $input.tsv
rm $input.rpk.wig
rm $input.bed

#rm $input.short
#rm $input.f.short
#rm $input.r.short


