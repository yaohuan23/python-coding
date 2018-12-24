#!usr/bin/bash

factor=`wc -l /data1/qwu/xufeng/mapping/ba/d0/process/ba_d0.r.short | cut -f 1 -d " "`


mfactor=$((factor/1000000))
awk '{printf "%s\t%d\t%d\t%.2f\n",$1,$2,$3,($4/'$mfactor*10')}'  /data1/qwu/xufeng/mapping/ba_d0.r_rpk.wig | egrep -v "chrM" > /data1/qwu/xufeng/mapping/ba/d0/process/ba_d0.r_rpkm.wig

