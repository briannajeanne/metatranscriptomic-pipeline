###------------------------    inputs   ----------------------------------------###
#$1 working_dir
#$2 R1
#$3 R2
#$4 prefix

cd $1
manifest="/data/databases/taxid_list"

###--------------------- kraken variables ---------------------------------------###
kr_report_total=`echo kr_reports/ $4 total_report.kraken2 | sed 's/ //g'`
kr_output_total=`echo kr_reports/ $4 total_output.kraken2 | sed 's/ //g'`
kr_log_total=`echo logs/ $4 total_kraken2.log | sed 's/ //g'`

br_report_total=`echo kr_reports/ $4 total_report.bracken | sed 's/ //g'`
br_output_total=`echo kr_reports/ $4 total_output.bracken | sed 's/ //g'`
br_log_total=`echo logs/ $4 total_bracken.log | sed 's/ //g'`

###-------------------   kraken2 scripts --------------------------------------------###
out1=`echo kr_reports_modified/ $4 _virallist_report.kraken2 | sed 's/ //g'`
echo -n > $out1

while read p; do
tax=`echo $p | awk '{print $1}'`
count=`cat $kr_report_total | awk '{print $1"\t"$0}' | sed 's/ /_/g' | sed 's/__//g' |awk '{print $1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' | awk -v var=$tax '{if ($5 == var) print $0}'| wc -l`
#echo "tax ID $tax"
#echo "count = $count"

   if [ $count == 0 ]
   then
#      echo "no"
      echo "$4 NA NA NA NA $tax NA" | sed 's/ /\t/g' >> $out1 
   else
#      echo "true"
      cat $kr_report_total | awk '{print $1"\t"$0}' | sed 's/ /_/g' | sed 's/__//g' |awk '{print $1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' | awk -v var=$tax '{if ($5 == var) print $0}'| awk -v var=$4 '{print var"\t"$0}' >> $out1
   fi
continue
done < $manifest

###----------------------------- bracken ----------------------------------###
###-------------------   run scripts --------------------------------------------###
out=`echo kr_reports_modified/ $4 _virallist_report.bracken | sed 's/ //g'`
echo -n > $out

while read p; do
tax=`echo $p | awk '{print $1}'`
count=`cat $br_report_total | awk '{print $1"\t"$0}' | sed 's/ /_/g' | sed 's/__//g' |awk '{print $1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' | awk -v var=$tax '{if ($5 == var) print $0}'| wc -l`
#echo "tax ID $tax"
#echo "count = $count"

   if [ $count == 0 ]
   then
#      echo "no"
      echo "$4 NA NA NA NA $tax NA" | sed 's/ /\t/g' >> $out 
   else
#      echo "true"
      cat $br_report_total | awk '{print $1"\t"$0}' | sed 's/ /_/g' | sed 's/__//g' |awk '{print $1"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' | awk -v var=$tax '{if ($5 == var) print $0}'| awk -v var=$4 '{print var"\t"$0}' >> $out
   fi
continue
done < $manifest

