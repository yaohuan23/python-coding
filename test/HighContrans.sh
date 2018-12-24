#!/usr/bin/env bash
PYTHON="/Applications/YH-work/python-coding/venv/bin/python2.7"
work_path="/Applications/YH-work/circRNA/circRNAPaperWriting/metadata"
#stastic the circular_RNA detected in one experiment
cd $work_path
echo "sample_name,circ_num" >circular_static.csv
for file in $(ls *.bed)
do
sample_name_temp=$(basename $file)
sample_name=${sample_name_temp%*sites.bed}
grep "circ_" ${sample_name_temp} >circular_${sample_name}.bed
sort -nr -k7 circular_${sample_name}.bed > circular_${sample_name}.sorted.bed
#rm ${sample_name}
$PYTHON /Applications/YH-work/python-coding/test/file_prepare.py -i circular_${sample_name}.sorted.bed \
-n ${sample_name}
$PYTHON /Applications/YH-work/python-coding/test/file_prepare.py -i ${sample_name}.txt -n ${sample_name}
circ_num=`wc -l circular_${sample_name}.sorted.bed`
#echo ${circ_num[0]}
rm circular_${sample_name}.sorted.bed
rm circular_${sample_name}.bed
#line_record=$sample_name,$circ_num
#echo $line_record
echo ${sample_name},${circ_num} >> circular_static.csv
#cut -f1 -d " " circular_static.csv >temp
#mv temp circular_static.csv
#rm circular*.bed
echo $sample_name
done
for file in $(ls *.txt)
do
$PYTHON /Applications/YH-work/python-coding/test/file_prepare.py -i circular_${sample_name}.txt \
-n ${sample_name}
done
#count the circular rna quality by Back splice junction reads found & try to plot the contribution of circular RNA

#circular_${sample_name}.sorted.bed



