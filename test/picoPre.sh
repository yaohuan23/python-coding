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