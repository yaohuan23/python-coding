#!/usr/bin/env Rscript
# run this in the output directory for rnaseq_pipeline.sh
# passing the pheno data csv file as the only argument 
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
# assume no output directory argument was given to rnaseq_pipeline.sh
  pheno_data_file <- paste0(getwd(), "/chrX_data/geuvadis_phenodata.csv")
} else {
  pheno_data_file <- args[1]
}

library(ballgown)
library(RSkittleBrewer)
library(genefilter)
library(dplyr)
library(devtools)

bg <- ballgown(dataDir = pheno_data_file, samplePattern="YH")
pData(bg) = data.frame(id=sampleNames(bg), group=c(1,2,3,4,5))
bg_filted <- subset(bg, "rowVars(texpr(bg)) > 1", genomesubset=TRUE)
#For circRNA-seq Data should nornolize first for DE analysis
GAPDH=subset(bg,"gene_name=='GAPDH'")
norno_value=texpr(GAPDH)[1,]
a=t(norno_value*t(texpr(bg_filted))*10000)

#if the transcriptone should nornollized to another transcript level or 
#for(i in seq(1,length(sampleNames(bg)))){
 #      bg_filted@expr$trans[,9+i*2]=a[,i]
 #	}                                
#


#bg_filted@expr$trans[1,][4]
## DE by transcript
results_transcripts <-  stattest(bg_filted, feature='transcript', covariate='group', getFC=TRUE, meas='FPKM')
results_genes <-  stattest(bg_filted, feature='gene', covariate='group', getFC=TRUE, meas='FPKM')

#results_transcripts <- arrange(results_transcripts, pval)
#results_genes <-  arrange(results_genes, pval)
#prepare for result ourput;gene
#here you can insert some filter_method
#result_ballowGene=subset(bg_filted, "ballgown::geneIDs(bg_filted) %in% results_transcripts[,2]",genomesubset=TRUE)
#result_ballowGene=subset(bg_filted, "ballgown::geneIDs(bg_filted) %in% results_transcripts[,2]",genomesubset=TRUE)
colnames(results_genes)[2]="gene_id"
colnames(results_transcripts)[2]="t_id"
Output_frame_gene=merge(bg_filted@expr$trans,results_genes)
Output_frame_trans=merge(bg_filted@expr$trans,results_transcripts)
Output_frame_gene=arrange(Output_frame_gene,pval)
Output_frame_trans <- arrange(Output_frame_trans, pval)

##for transcription
#result_ballow=subset(bg_filted, "ballgown::geneIDs(bg_filted) %in% result_genes[,2]",genomesubset=TRUE)
#output_frame=merge(result_genes,for_output@expr$trans)
#output_frame <- arrange(output_frame, pval)
### Add gene name
#results_transcripts<-data.frame(seqinfo=seqinfo(ballgown::geneNames(bg_filt)),genename=ballgown::geneNames(bg_filt),transcriptname=ballgown::transcriptNames(bg_filt),transcriptIDs=ballgown::transcriptIDs(bg_filt), stat_results
#results_transcripts <- data.frame(geneNames=ballgown::geneNames(bg_chrX_filt),
#          geneIDs=ballgown::geneIDs(bg_chrX_filt), results_transcripts)
#
### Sort results from smallest p-value
#results_transcripts <- arrange(results_transcripts, pval)
#results_genes <-  arrange(results_genes, pval)
#
### Write results to CSV
#write.csv(results_transcripts, "chrX_transcripts_results.csv", row.names=FALSE)
#write.csv(results_genes, "chrX_genes_results.csv", row.names=FALSE)
#
### Filter for genes with q-val <0.05
#subset(results_transcripts, results_transcripts$qval <=0.05)
#subset(results_genes, results_genes$qval <=0.05)
