###------------------------    inputs   ----------------------------------------###
#$1 working_dir
#$2 R1
#$3 R2
#$4 prefix

### ----------------------      variables    -----------------------------------###
cd $1
#--------------------------------------------------------------------------------------------###
###------------------------------- pre-processing -----------------------------------------------###
###----------------------------------------------------------------------------------------------###
##OG
cR1=`zcat -f $2 | wc -l | awk '{print $1/4}'`

##dedup
R1_dedup=`echo fastq_processed/ $4 _dedup_1.fastq | sed 's/ //g'`
R2_dedup=`echo fastq_processed/ $4 _dedup_2.fastq | sed 's/ //g'`

cR1_dedup=`cat $R1_dedup | wc -l | awk '{print $1/4}'`

##trimmed pair
R1_pair=`echo fastq_processed/ $4 _dedup-paired_1.fastq | sed 's/ //g'`
R2_pair=`echo fastq_processed/ $4 _dedup-paired_2.fastq | sed 's/ //g'`

cR1_pair=`cat $R1_pair | wc -l | awk '{print $1/4}'`

#trimmed unpair
R1_unpair=`echo fastq_processed/ $4 _dedup-unpaired_1.fastq | sed 's/ //g'`

cR1_unpair=`cat $R1_unpair | wc -l | awk '{print $1/4}'`


# writing to an output in long format 
out=`echo QC/ $4 _fastq-count.txt | sed 's/ //g'`

echo "$4 original $cR1" | sed 's/ /\t/g' > $out 
echo "$4 dedup $cR1_dedup" | sed 's/ /\t/g' >> $out 
echo "$4 trimmed-pair $cR1_pair" | sed 's/ /\t/g' >> $out 
echo "$4 trimmed-unpair $cR1_unpair" | sed 's/ /\t/g' >> $out 


