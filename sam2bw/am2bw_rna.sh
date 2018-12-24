#!/bin/bash
EXPECTED_ARGS=3
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' bamFile web_folder genome"
exit
fi

web_folder=$2
genome=$3
chr_len_bed=/sharedata/genome/$genome_chr_len_bed
genomeHeader=/sharedata/genome/$genome/$genome.fa.fai
get_count=/data/jingyi/scripts/bam2bw/get_counts_gw.pl
wig2bigwig=/data/jingyi/scripts/bam2bw/wig2bigwig.sh
cleanwig=/data/jingyi/scripts/bam2bw/clean_chr_boundary.py
#UCSCheader="track type=bigWig name=$input description=$input bigDataUrl=http://166.111.156.41/jingyi/web/$web_folder/$input\_rpkm.bw viewLimits=3:20 visibility=2 windowingFunction=maximum maxHeightPixels=30 autoScale=off color=0,0,255"

if [[ $1 =~ "sam" ]]
then
input=${1%.sam}
samtools view -bt $genomeHeader $input.sam | bamToBed -i - | cut -f1-3 | sort-bed - > $input.short
fi

if [[ $1 =~ "bam" ]]
then
input=${1%.bam}
bamToBed -i $input.bam | cut -f1-3 > $input.short
fi

#exit

echo $input
total_read=`wc -l $input.short`
UCSCheader="track type=bigWig name=$input description=$input bigDataUrl=http://166.111.156.41/jingyi/web/$web_folder/$input\_rpkm.bw viewLimits=3:20 visibility=2 windowingFunction=maximum maxHeightPixels=30 autoScale=off color=0,0,255"
$get_count $input.short 100 $chr_len_bed > $input\_rpk.wig
factor=`echo $total_read | cut -f1 -d" "`
mfactor=$((factor/1000000)) ### Here it is actually 1,000,000 / 10 = 100,000 to get 1kb per million
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4*10)/'$mfactor'}' $input\_rpk.wig | egrep -v "chrM" | grep -v '_' > $input\_rpkm.wig
$cleanwig $genome $input\_rpkm.wig
awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_rpkm.wig > $input\_rpkm.tsv &
sort-bed $input\_rpkm.wig > $input\_sort.wig
mv $input\_sort.wig $input\_rpkm.wig
$wig2bigwig $genome $input\_rpkm.wig
mv $input\_rpkm.bw /data/jingyi/web/$web_folder/
echo $UCSCheader | cat ./header.txt - > ./header_new.txt
sed 's/\\_/_/g' ./header_new.txt > ./header.txt
rm $input\_rpkm.short
#rm $input\_rpkm.wig.tmp
rm $input\_rpk.wig
#rm $input.short
#rm $input\_rpkm.wig 
#rm header_new.txt


