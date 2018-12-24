#!/bin/bash
EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ];
then
echo "Usage: '$0' genome wig_file"
exit
fi

cleanwig=/data/jingyi/scripts/bam2bw/clean_chr_boundary.py

input=${2%.wig} 
$cleanwig $1 $input.wig
/data4/bingjie/script/bedGraphToBigWig $input.wig ~/sharedata/genome/$1_chromInfo.txt $input.bw
rm $input.wig.tmp
