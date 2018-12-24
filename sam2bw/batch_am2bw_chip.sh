#!/bin/bash
EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' webfolder_name genome"
exit
fi

webfolder_name=$1
#script=/data/jingyi/scripts/bam2bw/bam2bw_countcoverage.sh
#script=~/scripts/bam2bw/bam2bw_chip.sh
script=/data/jingyi/scripts/bam2bw/am2bw_chip_total.sh

for file in *.*am
do
echo $file
nohup bash $script $2 $file $webfolder_name & 
done

wait

rm ./header_new.txt
#mkdir ../wig
mv *.wig ../wig
#mkdir ../tsv
mv *.tsv ../tsv
