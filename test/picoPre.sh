#!/usr/bin/env bash
cutadapt -g ^NNNNGGG --discard-untrimmed -o 2cell-rep2-T_CAGATC_pool_R1trim_1ok.fastq.gz 2>>run.log
#cut the adapters
cutadapt -a AGATCGGAAGAG -A CTCTTCCGATCT  -o 2cell-rep2-T_CAGATC_pool_R1trim_1ok.fastq.gz -p  2cell-rep2-T_CAGATC_pool_R1trim_1ok.fastq.gz \
2cell-rep2-T_CAGATC_pool_R1trim_1ok.fastq 2cell-rep2-T_CAGATC_pool_R1trim_2ok.fastq
#filter contains
cutadapt -a GTCATGGATAACCTAGTGGGAGGTTCGCTGCTAAGCACGTGACCTTGCTT -a AGACGTGTGCTCTT -a  CCNNNCC -a CCNNCC -a CCNCC -a CCCC -a TCCGATCTGAGA --discard-trimmed -o 2cell-rep2-T_CAGATC_pool_R1trim_1clean.fastq.gz 2cell-rep2-T_CAGATC_pool_R1trim_1ok.fastq

/PGD2/yaohuan/script/meRanTK-1.2.1/meRanT align -o ./meRanTresult -f scBS-rep2_GATGT_L006_R1_001_cut.fastq.gz -r scBS-rep2_GATGT_L006_R2_001_cut.fastq.gz -t 60 -k 10 -S scBS-rep2-pool.sam -un -ud ./meRanTunalign -ra -MM -i2g /PGD2/yaohuan/script/hg19_mm9/mm9/45S_Mus.map -x /PGD2/yaohuan/script/hg19_mm9/mm9/45S_Mus.fasta -mbp

/PGD2/yaohuan/script/meRanTK-1.2.1/meRanCall -f /PGD1/ref/exome2/mm9/mm9.fa -p 100 -sam  8cell-rep2-BSVmm9.sam -gref -o 8cell-rep2-BSV.txt  -mBQ 20 -mr 0

$HISAT2 -p $NUMCPUS  -x ${GENOMEIDX} \
 94      -1 ${FASTQLOC}/${reads1[$i]} \
 95      -2 ${FASTQLOC}/${reads2[$i]} \
 96      -S ${TEMPLOC}/${sample}.sam 2>${ALIGNLOC}/${sample}.alnstats
/PGD2/yaohuan/script/hisat2/hisat2-2.1.0/hisat2 -p 80 -x /PGD1/ref/yangxin_here/Human/Human_genome/hisat2_index/hg19/hg19_trans
/PGD2/yaohuan/script/hisat2_RNA-seq/Homo_sapiens.GRCh37.87.gtf



cat /media/jiawei/yaohaun1/work_place/scBS/20181126/Sample_scBS-rep2/scBS-rep2_GATGT_L006_R1_001_cut.fastq >>scBS_R1_001_qua.fastq &
zcat /media/jiawei/yaohaun1/seq-fastq-data/20181217YH-singlecellBS/Project_2018930/Sample_single-BS-1To12/single-BS-1To12_GATGT_pool_trim.fastq.gz >>scBS_R1_001_qua.fastq
CC.CCC.CCCC
/media/jiawei/yaohaun1/seq-fastq-data/20181221YH/Project_single-cell-BST/Sample_single-BS-1To10ribPlus/single-BS-1To10ribPlus_CGATGT_pool_R1_001.fastq.gz
 nohup cutadapt -a CCC -a CCNCC --discard-trimmed -o scBS_R1_001_trim.fastq scBS_R1_001_qua.fastq &


/PGD2/yaohuan/script/meRanTK-1.2.1/meRanGh align -o meRanresult -f scBS-total-noindex-minC_final.fastq -t 110 -S scBS-total-noindex-minC_final_mm9.sam -ds -id $mm9meRanTK_index /PGD1/ref/yangxin_here/Mouse/mm9/mm9_genomefa/BSmm9 -GTF /PGD1/ref/yangxin_here/Mouse/mm9/mm9_genomefa/Mus_musculus.NCBIM37.67.gtf -mbp -fmo -mmr 0.01 2>&1 > /dev/null

awk 'BEGIN{OFS="\t"}{print "m5CSite"FNR,$1}' all.fa >temp
mv temp all.fa
sed -i 's/^/@/g' all.fa
cat /media/jiawei/yaohaun1/seq-fastq-data/20181126YH-singlecellBS-T/Project_2018930/Sample_scBS-rep2/scBS-rep2_GATGT_L006_R1_001.fastq.gz /media/jiawei/yaohaun1/seq-fastq-data/20181228YH/Project_single-cell-BST/Sample_scBSrep2_1-12/scBSrep2_1-12_CGATGT_pool_R1_001.fastq.gz /media/jiawei/yaohaun1/seq-fastq-data/20181116YH/Project_2018930/Sample_scBS-rep2/scBS-rep2_GATG_pool_R1_001.fastq.gz
sed -i 's/^/@/g' temp${sample}.reads
 66 sed -i 's/\t/\n/g' temp${sample}.reads
 67 awk '{if(NR%2==0){print $0"\n+\n"gensub(/[ATGC]/,"I","g")}else{print $0}}' temp${sample}.reads >${sample}sites.fastq
$STRINGTIE -p $NUMCPUS  -o ${ALIGNLOC}/${sample}.gtf \
113    -l ${sample} ${ALIGNLOC}/${sample}.bam
 cat ${sample}1A-BS.txt|awk -v OFS="\t" '{if($12=="M")print $1,$2,$2,$3,$6,$5,$7,$12}' >${sample}_methyC.bed
 73 cat ${sample}_methyC.bed|awk -v OFS="\t" '$7>=0.1 && $6>=10 && $5>=1' > ${sample}-methyC_qua.bed

bedtools genomecov -split  -ibam SRR5183491_sorted.bam -g

 sed -i  '/^GL/d' siNSUN2-mRNA-T-for-circ.gtf
