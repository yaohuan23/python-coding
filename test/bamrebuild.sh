#!/usr/bin/env bash
bedtools=`which bedtools`
samtools = `which samtools`
$align=
cd /PGD1/yaohuan/work_place/cytoplasma-circRNA/hisat2
help(){
NAME=$(basename $0)
cat<<EOF
useage:sh $NAME [output_dir] [file_list]
EOF
}
echo "`date +"%Y-%m-%d %H:%M:%S"` :${1} is being trated"
if [ ! -d $1 ] ;then
OutPutDir=$(pwd)
else
OutPutDir=$1
fi
cd $OutPutDir
if [ ! -f $2 ] ;then
InputFiles_temp=$(find $OutPutDir -maxdepth 1 -name *.urls )
InputFiles=${OutPutDir}/$(basename $InputFiles_temp)
#echo $InputFiles
else
InputFiles=$2
fi
echo "Trying to treat samples in $InputFiles . . ."
if [ ! -f $InputFiles ];then
help
exit 1
fi
#this is the PE mode
while read line
do
echo "sample $line is being treated"
sampleUrl=${line##*,}
FileName=`basename $sampleUrl`
samplename=${FileName%%.bam}
if [ ! -f $sampleUrl ];then
continue
fi
bamFile=$sampleUrl
${samtools} sort -o  ${samplename}-sorted.bam -T ${samplename} -@30\
--reference /PGD1/ref/yangxin_here/Human/Human_genome/hg19/ucsc.hg19.fa $sampleUrl
#samtools depth -a $sampleUrl >$samplename.depth
bedtools bamtobed  -bed12 -split -i  ${samplename}-sorted.bam >${samplename}-sorted.bed
awk '$1 !~ /^chr[0-9,a-z,A-Z]{0,}[m,M,_]{1,}/'  ${samplename}-sorted.bed >temp
mv temp ${samplename}-sorted.bed
YH-rebuildbed.py -i ${samplename} -sorted.bed -o temp
mv temp ${samplename}.short
#
# YH-bed2bw hg19 ${samplename}.short
#awk '$1 !~ /^chr[0-9,a-z,A-Z]{0,}[m,M,_]{1,}/'  /PGD2/yaohuan/script/hisat2_RNA-seq/hg19.chrom.sizes >hg19_chrome.sizes
awk '$1 !~ /^chr[0-9,a-z,A-Z]{0,}[m,M,_]{1,}/'  /PGD1/ref/yangxin_here/Mouse/mm9/mm9.chrom.sizes >mm9.chrom.sizes

 #/PGD2/yaohuan/script/ucsc_tools/bedSort ${samplename}-sorted.bed ${samplename}-sorted.bed

bedtools bedtobam -i  ${samplename}-sorted.bed  -g hg19_chrome.sizes -bed12 >${samplename}-sorted.bam
#/PGD2/yaohuan/script/ucsc_tools/bedToBigBed ${samplename}-sorted.bed  hg19_chrome.sizes ${samplename}-sorted.bb
done< $InputFiles
bedtools bamtobed -bed12 -split -i 2cell-T-rep1.bam >temp.bed