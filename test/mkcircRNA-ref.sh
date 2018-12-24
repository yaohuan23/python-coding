#!/usr/bin/env bash
PYTHON="/Applications/YH-work/python-coding/venv/bin/python2.7"
work_path="/Applications/YH-work/python-coding/test"
#stastic the circular_RNA detected in one experiment
cd $work_path
cat ${sample}1A-BS.txt|awk -v OFS="\t" '{if($12=="M")print $1,$2,$2,$3,$6,$5,$7,$12}' > ${m5CResult}/${sample}methyC.bed
cat ${m5CResult}/${sample}methyC.bed|awk -v OFS="\t" '$7>=0.1 && $6>=10 && $5>=1' > ${m5CResult}/${sample}methyC_qua.bed
/PGD2/yaohuan/script/meRanTK-1.2.1/meRanCall -f ${human_meRanTK_index}/C2T/meRanGh_C2T.fa ${human_meRanTK_index}/G2A/meRanGh_G2A.fa -p 100 -sam ${sample}Vhg19.sam -gref -o ${sample}1A-BS.t    xt -mBQ 20 -mr 0
#Where can download the referance and other useful data: http://hgdownload.cse.ucsc.edu/goldelsnPath/
#step1: merge all the circRNA-result in one bed-file
find $work_path -name \*.bed >inputbed.txt

#cat circular_*.sorted.bed > temp
cat *circ.bed > temp
#file the result by Num of back spliced junction reads.Here we have two method:1 cout the BSJ num by one sample. 2 caculate by the whole sequencing result.
#Here I chose 1. circRNA have >2 uniq BSJ are considered as a positive circRNA.
awk '$5>1' temp >filted2.circresult
cut -f1-3,6 filted2.circresult |sort -n -k2|sort -n -k1|uniq >temp
#cut -f1-3 filted2.circresult |sort -n -k2|sort -n -k1|uniq >temp
mv temp filted2.circresult.bed4

#There are some circRNA which covers many genes. But these result seems not correct. Here I only count the circRNA in one gene regin.
intersectBed -b /PGD2/yaohuan/script/hisat2_RNA-seq/Homo_sapiens.GRCh37.87.gtf -a filted2.circresult.bed4 -wa -wb |cut -f1 -d";" |awk -F "[\n\t]" 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$13}' -|uniq >first_filted.circ_ref.gtf

cut -f1-4 first_filted.circ_ref.gtf |uniq -c |sed 's/^ \{1,\}//g' >circ_cover_geneNum
awk '$1==1{print $0}' circ_cover_geneNum >filted2.circresult.bed4
awk -F "[\t, ]" 'BEGIN{OFS="\t"}{print $2,$3,$4,$5}' filted2.circresult.bed4 >filted2.circresult.bed
awk -F "[\t, ]" '{print $1}' /PGD1/yaohuan/work_place/circularRNA-forPublish/circRNA-coverGenes.txt | sort -n -k1|uniq -c|sed 's/^ \{1,\}//g' >/PGD1/yaohuan/work_place/circularRNA-forPublish/circRNA-coverGenes.txt
awk '$1==1{print $0}' circ_cover_geneNum >filted2.circresult.bed4
awk -F "[\t, ]" 'BEGIN{OFS="\t"}{print $2,$3,$4,$5}' filted2.circresult.bed4 >filted2.circresult.bed
rm filted2.circresult.bed4
#Prepare a file So the detected circRNA pool can be visualized in igv or genome browser.
awk 'BEGIN{OFS="\t"}{print NR,"circ"NR,$1,$4,$2,$3,$3,$3,2,$2","$3-1",",$2+1","$3",",0,"circ"NR,"none","none","-1,-1,"}' filted2.circresult.bed > show.bed

#A text file can be seem in igv only when you name the file in "ensGene-XX" format.
mv show.bed ensGene-circRNA.txt
#Denoval assemble circRNA exons
cd ../hisat2
find ./ -name \*.bam >mergelist.txt
samtools merge -h -b mergelist.txt -@80 -o all-circRNA.bam
samtools view -bh -L ../circ_out/filted2.circresult.bed all-circRNA.bam >all-circRNA-filted.bam
nohup YH-bam2bw.sh hg19 all-circRNA-filted.bam all-circRNA-filted &
/PGD2/yaohuan/script/stringtie -p 80 -o all-circRNA-filted.gtf -l all-circRNA-filted all-circRNA-filted.bam
#I found that there are still some exons out of the circRNA range.So the next scripts are tring to filter the outRange-exons
awk '$3=="exon"' all-circRNA-filted.gtf |cut -f1,4,5|sort -n -k2 |sort -n -k1|uniq >temp_gtfFilter.bed
cd ../circ_out
mv ../hisat2/temp_gtfFilter.bed ./
mv ../hisat2/all-circRNA-filted.gtf ./
#only leave the exons included in circRNA pool
intersectBed -a temp_gtfFilter.bed -b filted2.circresult.bed -wa >Inexons.bed
sort -n -k2 Inexons.bed |sort -n -k1 |uniq >uniqInexons.bed
awk 'NR==FNR{x[$1$2$3]=1}NR>FNR{if(x[$1$2$3] !=1){print $0}}' uniqInexons.bed temp_gtfFilter.bed >uniqOutexons.bed
awk 'NR==FNR{x[$1$2$3]=1}NR>FNR{if(x[$1$4$5] !=1){print $0}}' uniqOutexons.bed all-circRNA-filted.gtf >Pre-HelacircRNA.gtf
$PYTHON /Applications/YH-work/python-coding/test/pregtf2fastq.py -i $work_path/preGTF.gtf > circRNA.gtf
sed -i '/^$/ d' circRNA.gtf
grep -v "99999999999" circRNA.gtf >temp
mv temp circRNA.gtf
YH-gffcompare -r /PGD2/yaohuan/script/hisat2_RNA-seq/grch37_tran/Homo_sapiens.GRCh37.87.gtf
YH-gtf2bed12.perl circRNA.gtf >circRNA-hela.bed12
intersectBed -a filted2.circresult.bed -b circRNA-hela.bed12 -wa -wb |awk '$4==$10 && (($3-$12)+($2-$11))<50 && ((-$3+$12)+(-$2+$11))<50' |cut -f5-16 |sort -k4|uniq > final-circRNA-hela.bed12
cut -f10 final-circRNA-hela.bed12 |sort -n|uniq -c|sed 's/^ \{1,\}//g'  > circ-exonCover.result
cut -f11 final-circRNA-hela.bed12 |awk -F '[,]' '{b[NR]=$0;for(i=1;i<=NF-1;i++)a[NR]+=$i}END{for(i=1;i<NR;i++)print b[i]"\t"a[i]}'|cut -f2>circRNA-length.csv
bedtools getfasta -fi /PGD1/ref/yangxin_here/Human/Human_genome/hg19/ucsc.hg19.fa -bed  final-circRNA-hela.bed12 -fo circRNA-hela.fa -s -split -fullHeader

#circular rna expression
find /PGD1/yaohuan/work_place/cytoplasma-circRNA/circ_out -name circular_\*sorted.bed >inputBed.txt
awk 'NR==FNR{x[$1$2$3]=1}NR>FNR{if(x[$1$2$3]){print $0}}' final-circRNA-hela.bed12 circular_N2KO-circRNA-goodcondition.sorted.bed|less
while read line;
 do
  filename1=${line%%.*}
  filename=${filename1##*/}
  awk 'NR==FNR{x[$1$2$3]=1}NR>FNR{if(x[$1$2$3]){print $0}}' final-circRNA-hela.bed12 $line >$filename-expression.bed
  done <inputBed.txt

find /PGD1/yaohuan/work_place/cytoplasma-circRNA/circ_out -name \*expression.bed >inputBed.txt
while read line;
do
  filename1=${line%%.*}
  filename=${filename1##*/}
  awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$6,$5,$7}' $line >$filename.expression
  done <inputBed.txt


find /PGD1/yaohuan/work_place/cytoplasma-circRNA/circ_out -name \*.expression >input-expression.txt
while read line;
do
  filename1=${line%%-expression*}
  filename=${filename1##*/}
  awk 'BEGIN{OFS="\t"} NR==FNR{x[$1$2$3$4]=$0}NR>FNR{if(x[$1$2$3$6]){print x[$1$2$3$6]}else{print $1,$2,$3,$6,0,0}}'  $line final-circRNA-hela.bed12|uniq >$filename-expression.bed
  done <input-expression.txt