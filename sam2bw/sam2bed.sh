#!/bin/bash
EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome amFile"
exit
fi

genomeHeader=/sharedata/genome/$1/$1.fa.fai

if [[ $2 =~ "sam" ]]
then
input=${2%.sam}
samtools view -bt $genomeHeader $input.sam | bamToBed -i - | cut -f1-3 | sort -k1,1 -k2,2n > $input.bed
fi

if [[ $2 =~ "bam" ]]
then
input=${2%.bam}
bamToBed -i $input.bam | cut -f1-3 > $input.bed
fi


