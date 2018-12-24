#!/usr/bin/env bash
#first:mapping step
tophat -g1 --microexon-search -m 2 -G /PGD1/ref/yangxin_here/Human/hg19/tophat/Homo_sapiens.GRCh37.87.gtf \
-p 80 -o ./tophat /PGD1/ref/yangxin_here/Human/hg19/tophat/hg19 fastq 2>align.log
#tophat fusion
nohup bedtools bamtofastq -i unmapped.bam -fq unmapped.fastq
#bedtools bamtofastq -i x.bam -fq /dev/stdout -fq2 /dev/stdout > x.ilv.fq
#
tophat2 --fusion-search --keep-fasta-order --bowtie2 --no-coverage-search -p 80 \
-o OutPut/tophat_fusion /PGD1/ref/yangxin_here/Human/hg19/tophat/hg19 unmapped.fastq

# transcript assemble
cufflinks -u -F 0 -j 0 -p 80 --max-bundle-frags fragments -g /PGD1/ref/yangxin_here/Human/hg19/tophat/Homo_sapiens.GRCh37.87.gtf\
 -o OutPutdir accepted_hits.bam 2>run.log

/PGD2/yaohuan/script/ucsc_tools/gtfTpgnePrep cuflink/transcript.gtf cuflink/transcript.txt
awk 'NR==FNR{x[$1]=$2} NR>FNR{print x[$1]"\t"$0}' \
/PGD1/ref/yangxin_here/Human/hg19/ensemblToGeneName.txt transcript.txt >temp
mv temp transcript.txt

#change the transcript.txt to bed file format
python /usr/bin/YH-genePred2bed.py -i transcript.txt -o transcript.bed
bedtools sort -i transcript.bed >transcript.sorted.bed
#bed2bb
bedToBigBed -type=bed12 sortedbed chromosize sorted.bb

sortedbamTbw.py -i accepted_hits.bam -o Out_dir
#bam2bw Using a python script
/PGD2/yaohuan/script/ucsc_tools/bedGraphToBigWig accepted_hits.bg chrom.size accepted_hits.bw

################tophat fusion mapped result analysis and circRNA extraction




