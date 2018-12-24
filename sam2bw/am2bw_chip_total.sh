#!/bin/bash
EXPECTED_ARGS=3
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome amFile web_folder"
exit
fi


web_folder=$3
chr_len_bed=~/sharedata/genome/$1_chr_len_bed
genomeHeader=~/sharedata/genome/$1/$1.fa.fai
get_count=/data/jingyi/scripts/bam2bw/get_counts_gw.pl
wig2bigwig=/data/jingyi/scripts/bam2bw/wig2bigwig.sh
cleanwig=/data/jingyi/scripts/bam2bw/clean_chr_boundary.py
chr=/data/jingyi/scripts/bam2bw/GO.bed2wig_$1_wei
chr_len=~/sharedata/genome/$1_chr_len.txt

if [[ $2 =~ "sam" ]]
then
input=${2%.sam}
samtools view -bt $genomeHeader $input.sam | bamToBed -i - | cut -f1-3 | sort-bed - > $input.short
fi

if [[ $2 =~ "bam" ]]
then
input=${2%.bam}
bamToBed -i $input.bam | cut -f1-3 > $input.short
fi

UCSCheader="track type=bigWig name=$input\_atac description=$input\_atac bigDataUrl=http://166.111.156.41/jingyi/web/$web_folder/$input.bw viewLimits=3:12 visibility=2 windowingFunction=maximum maxHeightPixels=30 autoScale=off color=0,0,255"


$get_count $input.short 100 $chr_len_bed > $input\_rpk.wig &
total_read=`wc -l $input.short`
factor=`echo $total_read | cut -f1 -d" "`
mfactor=$((factor/100000)) 
echo "$input\t$mfactor"

#####  for visulization ######

slopBed -i $input.short -g $chr_len -l 0 -r 250 -s > $input.long.bed
$chr $input.long.bed 1 $1
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4*100)/('$mfactor'*3)}' $input.long.bed.min1.wig | egrep -v "chrM" | grep -v "_" > $input.wig
$cleanwig $1 $input.wig
sort-bed $input.wig > $input\_sort.wig 
#sort -k1,1 -k2,2n $input.wig > $input\_sort.wig 
mv $input\_sort.wig $input.wig
$wig2bigwig $1 $input.wig
mv $input.bw /webhtml/jingyi/web/$web_folder/
echo $UCSCheader | cat header.txt - > header_new.txt
sed 's/\\_/_/g' header_new.txt > header.txt
mv $input.wig $input\_300bp_rpkm.wig

#### for calculation #####

awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4*10)/'$mfactor'}' $input\_rpk.wig | egrep -v "chrM" | grep -v "_" > $input\_100bp_rpkm.wig
$cleanwig $1 $input\_100bp_rpkm.wig
echo "$input\_cal_wig_cleaned"

awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_100bp_rpkm.wig > $input\_100bp_rpkm.tsv

rm $input.short
rm $input\_rpk.wig
rm $input.long.bed*
rm $input*.wig.tmp
rm header_new.txt
