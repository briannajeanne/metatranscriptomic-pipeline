###------------------------    inputs   ----------------------------------------###
#$1 working_dir
#$2 R1
#$3 R2
#$4 prefix

### ----------------------      variables    -----------------------------------###
cd $1

###--------------------- kraken variables ---------------------------------------###
kr_report_total=`echo kr_reports/ $4 total_report.kraken2 | sed 's/ //g'`
kr_output_total=`echo kr_reports/ $4 total_output.kraken2 | sed 's/ //g'`
kr_log_total=`echo logs/ $4 total_kraken2.log | sed 's/ //g'`

br_report_total=`echo kr_reports/ $4 total_report.bracken | sed 's/ //g'`
br_output_total=`echo kr_reports/ $4 total_output.bracken | sed 's/ //g'`
br_log_total=`echo logs/ $4 total_bracken.log | sed 's/ //g'`

echo "kr_report_total: $kr_report_total"
###---------------- report.tab -------------------------------###
#use long format to avoid NAs, can read into R and convert to short with dplyr
#sample \t percent of reads at level \t  sum of reads at and below \t reads at this level \t taxiD \t name

br_out=`echo kr_reports_modified/ $4 _to-combine-brreport.tab | sed 's/ //g'`
cat $br_report_total | awk '{print $1"\t"$0}' | sed 's/ /_/g' | sed 's/__//g' | awk '{print $1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' | awk -v var=$4 '{print var"\t"$0}' >> $br_out

kr_out=`echo kr_reports_modified/ $4 _to-combine-krreport.tab | sed 's/ //g'`
cat $kr_report_total |awk '{print $1"\t"$0}' | sed 's/ /_/g' | sed 's/__//g' |awk '{print $1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}'| awk -v var=$4 '{print var"\t"$0}'  >> $kr_out


###---------------- what level are things being assigned ---------------###
level_out=`echo QC/ $4 _combined-taxreads.tab | sed 's/ //g'`

cat $kr_report_total | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$NF}' |\
awk '{print substr($4,1,1)"\t"$3}' | sort -k 1,1b |\
groupBy -g 1 -c 2 -o sum | awk -v var=$4 '{print var"\t"$0}' >> $level_out


###--- assigned/unassigned kr
map=`cat $kr_report_total | awk '{if (($4 == "R")) print $1}'`
unmap=`cat $kr_report_total | awk '{if (($4 == "U")) print $1}'`
outmap=`echo QC/ $4 kr-assigned.tab | sed 's/ //g'`

echo $4 $map $unmap | sed 's/ /\t/g' > $outmap

