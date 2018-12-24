# Title     : diff-expression analysis
# Objective : expression analysis
# Created by: yaohuan
# Created on: 2018/9/9
#!/usr/bin/env Rscript

#!/usr/bin/env Rscript
# run this in the output directory for rnaseq_pipeline.sh
# passing the pheno data csv file as the only argument
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
# assume no output directory argument was given to rnaseq_pipeline.sh
}

library(ballgown)
library(RSkittleBrewer)
library(genefilter)
library(dplyr)
library(devtools)

bg <- ballgown(dataDir = pheno_data_file, samplePattern="YH")
bg_filted <- subset(bg, "rowVars(texpr(bg)) > 1", genomesubset=TRUE)
pData(bg) = data.frame(id=sampleNames(bg), group=c(1,1,1,0,0))
#For circRNA-seq Data should nornolize first for DE analysis
GAPDH=subset(bg,"gene_name=='GAPDH'")
norno_value=texpr(GAPDH)[1,]
a=t(norno_value*t(texpr(bg_filted))*10000)

for(i in seq(1,length(sampleNames(bg)))){
       bg_filted@expr$trans[,9+i*2]=a[,i]
 }

bg_filted@expr$trans[,11]=a[,1]
bg_filted@expr$trans[,13]=a[,2]
.
.
bg_filted@expr$trans[,19]=a[,5]
#bg_filted@expr$trans[1,][4]
## DE by transcript
results_transcripts <-  stattest(bg_chrX_filt, feature='transcript', covariate='group', getFC=TRUE, meas='FPKM')
results_gene <-  stattest(bg_chrX_filt, feature='gene', covariate='group', getFC=TRUE, meas='FPKM')

#results_transcripts <- arrange(results_transcripts, pval)
#results_genes <-  arrange(results_genes, pval)
#prepare for result ourput;gene
result_ballowGene=subset(bg_filted, "ballgown::geneIDs(bg_filted) %in% result_genes[,2]",genomesubset=TRUE)
volName(result_ballowGene)[1]=""
output_frame=merge(result_genes,result_genes@expr$trans)
output_frame <- arrange(output_frame, pval)

#for transcription
result_ballow=subset(bg_filted, "ballgown::geneIDs(bg_filted) %in% result_genes[,2]",genomesubset=TRUE)
output_frame=merge(result_genes,for_output@expr$trans)
output_frame <- arrange(output_frame, pval)
## Add gene namei
library(ballgown)
library(RSkittleBrewer)
library(genefilter)
library(dplyr)
library(devtools)
bg <- ballgown(dataDir = pheno_data_file, samplePattern="YH")
pData(bg) = data.frame(id=sampleNames(bg), group=c(1,1,1,0,0,0))
bg_filted <- subset(bg, "rowVars(texpr(bg)) > 1", genomesubset=TRUE)

results_transcripts <-  stattest(bg_filted, feature='transcript', covariate='group', getFC=TRUE, meas='FPKM')
results_genes <-  stattest(bg_filted, feature='gene', covariate='group', getFC=TRUE, meas='FPKM')

colnames(results_genes)[2]="gene_id"
colnames(results_transcripts)[2]="t_id"
Output_frame_gene=merge(bg_filted@expr$trans,results_genes)
Output_frame_trans=merge(bg_filted@expr$trans,results_transcripts)
Output_frame_gene=arrange(Output_frame_gene,pval)
Output_frame_trans <- arrange(Output_frame_trans, pval)
