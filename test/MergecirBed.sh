#this script should run at a unix mechine
#!/usr/bin/env bash
PYTHON="/Applications/YH-work/python-coding/venv/bin/python2.7"
work_path="/Applications/YH-work/circRNA/circRNAPaperWriting/metadata"
filted_transfile="/Applications/YH-work/circRNA/circRNAPaperWriting/metadata/ballow_result-trans.csv"
cd $work_path
cat *.txt >merge.tmp
#merge the circRNA record(startsite & endsite)
sort -n -k3 merge.tmp|sort -n -k2 |sed 's/^chr//g' |sort -k1 -n |sed 's/^/chr/g' |cut -f1-3,6 |uniq >temp
mv temp merge.tmp
#awk '{print $0,"\t","circular_record"}' temp >merge.tmp
rm temp

cut -f3,5-6,4 -d"," $filted_transfile |sed '1d'|sort -n -k3 |sort -n -k2 |sed 's/^chr//g' |sort -k1 -n |sed 's/^/chr/g'|sed 's/,/\t/g' |cut -f1-3 >temp
#awk '{print $0,"","ballow_tran"}' temp > ballow_trans.vsc
#rm temp
#cat merge.tmp ballow_trans.vsc > circ_trans.bed
#sort -n -k3 circ_trans.bed|sort -n -k2 |sed 's/^chr//g' |sort -k1 -n |sed 's/^/chr/g' |uniq >temp
#mv temp circ_trans.bed
intersectBed -a merge.tmp -b  temp -wa -wb > pre-circ-ballow.gtf
#$PYTHON -i merge.tmp -n ${work_path}
