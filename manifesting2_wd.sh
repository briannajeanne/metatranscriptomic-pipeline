#tab-delim manifest with R1,R2,prefix,batch
manifest=$1
working=$2

script1="/data/scripts/nothmodifying_split_trim.sh"
script2="/data/scripts/fq_count.sh"
script3="/data/scripts/kraken_summary_levels.sh"
script4="/data/scripts/kraken_summary_taxID.sh"

### activate virtual envs
#conda create --name krsummary_workspace1 -y
#conda activate krsummary_workspace1 -y

date > progress

## run scripts
while read p; do
R1=`echo $p | awk '{print $1}'`
R2=`echo $p | awk '{print $2}'`
pre=`echo $p | awk '{print $3}'`
final=`echo "*/* $pre *" | sed 's/ //g'`

echo " " >> progress
$script1 $working $R1 $R2 $pre
echo "$script1 $working $R1 $R2 $pre" >> progress
$script2 $working $R1 $R2 $pre
echo "$script2 $working $R1 $R2 $pre" >> progress
$script3 $working $R1 $R2 $pre
echo "$script3 $working $R1 $R2 $pre" >> progress
$script4 $working $R1 $R2 $pre
echo "$script4 $working $R1 $R2 $pre" >> progress
ls -lt $final |wc -l >> progress
ls -lt $final >> progress
echo " " >> progress
done < $manifest


fastqc fastq*/*
gzip fastq*/*.fastq
#conda deactivate
