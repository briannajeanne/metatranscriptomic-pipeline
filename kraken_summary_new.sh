
###------------------------    inputs   ----------------------------------------###
#$1 working_dir
#$2 R1
#$3 R2
#$4 prefix

### ----------------------      variables    -----------------------------------###
cd $1
#pathKR="/data/miniconda3/bin/kraken2"
#pathBR="/data/Bracken/bracken"
#pathKRextract="/data/KrakenTools/extract_kraken_reads.py"
#dbKR="k2_pluspf_20210517"

taxID_hg="9606"
taxID_bac="2"
taxID_fungus="4751"
taxID_virus="10239"
taxID_COVID="2697049"

#mkdir -p fastq_processed/
#mkdir -p kr_reports/
#mkdir -p fastq_notHg/
#mkdir -p fastq_Hg/
#mkdir -p logs/
#mkdir -p QC/

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

br_out=`echo kr_reports/ $4 _to-combine-brreport.tab | sed 's/ //g'`
cat $br_report_total |sed 's/ /_/g' | sed 's/__//g'| \
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$NF}' | awk -v var=$4 '{print var"\t"$0}' >> $br_out

kr_out=`echo kr_reports/ $4 _to-combine-krreport.tab | sed 's/ //g'`
cat $kr_report_total |sed 's/ /_/g' | sed 's/__//g'| \
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$NF}' | awk -v var=$4 '{print var"\t"$0}' >> $kr_out


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

###------------------ only viral information ----------------------###
#if there are no viruses then this will error out and not continue
#instead of working out loop just don't put anything after this

out_d=`echo QC/ $4 kr_domains.tab | sed 's/ //g'`
e=`cat $kr_report_total | awk '{if (($5 == "2759")) print $0}' | sed 's/ /_/g'`
b=`cat $kr_report_total | awk '{if (($5 == "2")) print $0}' | sed 's/ /_/g'`
v=`cat $kr_report_total | awk '{if (($5 == "10239")) print $0}' | sed 's/ /_/g'`
c=`cat $kr_report_total | awk '{if (($5 == "2697049")) print $0}' | sed 's/ /_/g'`

#same for euk
file_len=`cat $e | wc -l`
if [ $file_len == 0 ]
then
   echo "$4 2759 NA" | sed 's/ /\t/g' >> $out_d
else
   echo "$4 $e" | sed 's/ /\t/g' >> $out_d
fi

### same for bacteria
file_len=`cat $b | wc -l`
if [ $file_len == 0 ]
then
   echo "$4 2 NA" | sed 's/ /\t/g' >> $out_d
else
   echo "$4 $b" | sed 's/ /\t/g' >> $out_d
fi

#same for viruses 
file_len=`cat $v | wc -l`
if [ $file_len == 0 ]
then
   echo "$4 10239 NA" | sed 's/ /\t/g' >> $out_d
else
   echo "$4 $v" | sed 's/ /\t/g' >> $out_d
fi

##same for covid
file_len=`cat $c | wc -l`
if [ $file_len == 0 ]
then
   echo "$4 2697049 NA" | sed 's/ /\t/g' >> $out_d
else
   echo "$4 $c" | sed 's/ /\t/g' >> $out_d
fi

