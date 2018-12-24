#!/bin/bash
EXPECTED_ARGS=3
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome samFile web_folder"
exit
fi

web_folder=$3
#use a sorted bam file instead of sam file
input=${2%.bam}
#name=${2%_dba.sam}
chr_len_bed=/PGD1/ATAC-seq-script_bofeng/sam2bw/$1_chr_len_bed
genomeHeader=/PGD1/ref/exome2/$1/ucsc\.$1.fa.fai
get_count=/PGD1/ATAC-seq-script_bofeng/sam2bw/get_counts_gw.pl
wig2bigwig=/PGD1/ATAC-seq-script_bofeng/sam2bw/wig2bigwig.sh
cleanwig=/PGD1/ATAC-seq-script_bofeng/sam2bw/clean_chr_boundary.py
#chr=/data/jingyi/scripts/bam2bw/GO.bed2wig_$1_wei
#note: this script will lose chr22,chrX,Y when mapping hg19. Due to line 81 @ convert_bed2wig_wei.pl;
chr=/PGD1/ATAC-seq-script_bofeng/sam2bw/GO.bed2wig_$1_wei
chr_len=/PGD1/ATAC-seq-script_bofeng/sam2bw/$1_chr_len.txt
#UCSCheader="track type=bigWig name=$input\_rpkm description=$input\_rpkm bigDataUrl=http://166.111.156.41/bofeng/$web_folder/$input.bw viewLimits=3:12 visibility=2 windowingFunction=maximum maxHeightPixels=30 autoScale=off color=0,0,255"
#

echo $input

bedtools bamtobed -i ${input}.bam | awk '$5==60{print $1"\t"$2"\t"$3}' - > $input.short
#samtools view -bt $genomeHeader $input.sam | bamToBed -i - | awk '$4~/\/1/' | cut -f1-3,6 | sort -k1,1 -k2,2n > $input.short
$get_count $input.short 100 $chr_len_bed > $input\_rpk.wig &
total_read=`wc -l $input.short`
factor=`echo $total_read | cut -f1 -d" "`

if [ $factor -gt 1000000 ];
then
mfactor=$((factor/1000000)) ### Here it is actually /1,000,000 * 10 = 100,000 to get 1kb per million
elif [ $factor -gt 100000 ];
then
mfactor=$((factor/100000))
else
mfactor=$((factor/10000))
fi
echo "$input\t$mfactor"


slopBed -i $input.short -g $chr_len -l 0 -r 250 -s > $input.long.bed
$chr $input.long.bed 1 $1
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,(($4*10)/('$mfactor'*3))}' $input.long.bed.min1.wig | egrep -v "chrM" | grep -v "_" > $input.wig
$cleanwig $1 $input.wig
#awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_rpkm.wig > $input\_rpkm.tsv
sort -k1,1 -k2,2n $input.wig > $input\_sort.wig
mv $input\_sort.wig $input.wig
$wig2bigwig $1 $input.wig
#mv $input.bw /webhtml/bofeng/$web_folder/
echo $UCSCheader | cat header.txt - > header_new.txt
#sed 's/\\_/_/g' header_new.txt > header.txt
#mv $input.wig $input\_300bp_rpkm.wig
#awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_300bp_rpkm.wig > $input\_300bp_rpkm.tsv &

#### for calculation #####

#$get_count $input.short 100 $chr_len_bed > $input\_rpk.wig
#awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4*10)/'$mfactor'}' $input\_rpk.wig | egrep -v "chrM" | grep -v "_" > $input\_100bp_rpkm.wig
#$cleanwig $1 $input\_100bp_rpkm.wig
#echo "$input\_cal_wig_cleaned"

#awk '{printf "%s\t%d\t%.2f\n",$1,($2+$3)/2,$4}' $input\_100bp_rpkm.wig > $input\_100bp_rpkm.tsv

rm $input.short
rm $input\_rpk.wig
rm $input.long.bed*
rm $input*.wig.tmp
#rm header_new.txt
