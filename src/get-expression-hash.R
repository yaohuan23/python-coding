#!/usr/bin/env Rscript
## ----loadmethods, echo=FALSE, message=FALSE, warning=FALSE---------------
args=commandArgs(T)
if (! length(args) >= 1){
print("you should input the dir where your ballow data saved!")
}
library(ballgown)
data_directory = args[1] # automatically finds ballgown's installation directory
data_directory = gsub('( )','',data_directory)
# examine data_directory:
#data_directory
pre_hash_file=paste(data_directory,"/ballow_trans_hash.csv",sep='')
print(pre_hash_file)
# make the ballgown object:
bg = ballgown(dataDir=data_directory, samplePattern='YH', meas='all')
#bg
#
### ----struct--------------------------------------------------------------
#structure(bg)$exon
#structure(bg)$intron
#structure(bg)$trans
#
### ----getexpr-------------------------------------------------------------
#transcript_fpkm = texpr(bg, 'FPKM')
#transcript_cov = texpr(bg, 'cov')
whole_tx_table = texpr(bg, 'all')
#exon_mcov = eexpr(bg, 'mcov')
#junction_rcount = iexpr(bg)
#whole_intron_table = iexpr(bg, 'all')
#gene_expression = gexpr(bg)
#
### ----pData---------------------------------------------------------------
#pData(bg) = data.frame(id=sampleNames(bg), group=c(1,1,1,0,0))
#
### ----indexex-------------------------------------------------------------
#exon_transcript_table = indexes(bg)$e2t
#transcript_gene_table = indexes(bg)$t2g
#head(transcript_gene_table)
#phenotype_table = pData(bg)
write.csv(whole_tx_table,pre_hash_file)
