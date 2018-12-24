import numpy as nm
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
def getjunc_matrix(inputfile):
    Filebedfile=open(str(inputfile),'r')
    record_matrix = []
    for line in Filebedfile:
        line=line.strip()
        line_matrix=line.split("\t")
        line_junction_num=int(line_matrix[6])
        record_matrix.append(line_junction_num)
    Filebedfile.close()
    return record_matrix
def juncstatic(bedfile,step):
    bedfile=str(bedfile)
    step=int(step)
    rownum=1
    result_hash={}
    result_matrix=[]
    junum_max=0
    record_matrix=[]
    Filebedfile=open(bedfile,'r')
    for line in Filebedfile:
        line=line.strip()
        line_matrix=line.split("\t")
        #chrom,start,end,name,n_reads,strand,n_uniq,best_qual_A,best_qual_B,spliced_at_begin,spliced_at_end,tissues,tiss_counts,edits,anchor_overlap=line.split("\t")
        line_junction_num=int(line_matrix[6])
        record_matrix.append(line_junction_num)
        #Here the file is soted by uniq junction reads
        if rownum==1:
            junum_max=int(line_matrix[6])
            for cutoff_num in range(junum_max, 0, step):
                result_hash[cutoff_num] = 0
        rownum=rownum+1
        for i in range(junum_max,0,step):
            if i >= line_junction_num:
                #print line_matrix[6]
                #print i
                result_hash[i] = result_hash[i] + 1
    #Filebedfile.close()
    for j in range(junum_max,0,step):
        result_matrix.append(result_hash[j])
    #plotDistrubution(record_matrix)
    Filebedfile.close()
    return [result_matrix,record_matrix]

def plotDistrubution(result_matrix,samplename):
    #print samplename[0]
    png_name= str("/Applications/YH-work/circRNA/circRNAPaperWriting/metadata/" + "dis" + samplename[0])
    plot_matrix=result_matrix
    fig = plt.figure()
    ax=fig.add_subplot(111)
    #ax = fig.add_subplot(111)
    ax.boxplot(plot_matrix)
    plt.savefig(png_name)