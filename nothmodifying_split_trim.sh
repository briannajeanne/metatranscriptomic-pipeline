###------------------------    inputs   ----------------------------------------###
#$1 working_dir
#$2 R1
#$3 R2
#$4 prefix

### ----------------------      variables    -----------------------------------###
cd $1
pathKR="kraken2"
pathBR="/data/programs/Bracken/bracken"
pathKRextract="/data/programs/KrakenTools/extract_kraken_reads.py"
dbKR="/data/databases/kraken2/k2_pluspf_20210127/"
pathCL="/data/programs/miniconda3/bin/clumpify.sh"
pathTR="/data/programs/miniconda3/bin/trimmomatic"
pathPY="python"

taxID_hg="9606"
taxID_bac="2"
taxID_fungus="4751"
taxID_virus="10239"
taxID_COVID="2697049"

mkdir -p fastq_processed/
mkdir -p kr_reports/
mkdir -p fastq_notHg/
mkdir -p fastq_Hg/
mkdir -p logs/
mkdir -p QC/
mkdir -p kr_reports_modified/

###----------------------------------------------------------------------------------------------###
###------------------------------- pre-processing -----------------------------------------------###
###----------------------------------------------------------------------------------------------###

R1_dedup=`echo fastq_processed/ $4 _dedup_1.fastq | sed 's/ //g'`
R2_dedup=`echo fastq_processed/ $4 _dedup_2.fastq | sed 's/ //g'`

## dedup
$pathCL \
in=$2 in2=$3 \
out=$R1_dedup out2=$R2_dedup \
dedupe=t

R1_pair=`echo fastq_processed/ $4 _dedup-paired_1.fastq | sed 's/ //g'`
R2_pair=`echo fastq_processed/ $4 _dedup-paired_2.fastq | sed 's/ //g'`
R1_unpair=`echo fastq_processed/ $4 _dedup-unpaired_1.fastq | sed 's/ //g'`
R2_unpair=`echo fastq_processed/ $4 _dedup-unpaired_2.fastq | sed 's/ //g'`

## trim
$pathTR PE -phred33 \
$R1_dedup $R2_dedup \
$R1_pair $R1_unpair \
$R2_pair $R2_unpair \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36


###-----------------------------------------------------------------------------------------------###
###--------------------------  download, total kraken2, bracken  ---------------------------------###
###-----------------------------------------------------------------------------------------------###
kr_report_total=`echo kr_reports/ $4 total_report.kraken2 | sed 's/ //g'`
kr_output_total=`echo kr_reports/ $4 total_output.kraken2 | sed 's/ //g'`
kr_log_total=`echo logs/ $4 total_kraken2.log | sed 's/ //g'`

## run Kraken2 total
#/data/miniconda3/bin/kraken2 --db $dbKR --report $kr_report_total --paired $R1_pair $R2_pair --threads $4 --gzip-compressed > $kr_output_total 2> $kr_log_total
$pathKR --db $dbKR --report $kr_report_total --paired $R1_pair $R2_pair > $kr_output_total 2> $kr_log_total

#count the read length and round to the nearest 50, this is for the bracken k-mer input
length=`zcat $2 | head -4 | sed -n '1~4s/^@/>/p;2~4p' | grep -v ">" | wc -m | awk '{print int(($1/50)+0.5)*50}'`

br_report_total=`echo kr_reports/ $4 total_report.bracken | sed 's/ //g'`
br_output_total=`echo kr_reports/ $4 total_output.bracken | sed 's/ //g'`
br_log_total=`echo logs/ $4 total_bracken.log | sed 's/ //g'`

#bracken to summarize the unfiltered dataset
$pathBR -d $dbKR -i $kr_report_total -o $br_output_total -w $br_report_total -r $length 1>> $br_log_total

###------------------------------------------------------------------###
###---------------- split fastqs ------------------------------------###
###------------------------------------------------------------------###


#human
hg1=`echo fastq_Hg/ $4 _hg_taxID-9606_1.fastq | sed 's/ //g'`
hg2=`echo fastq_Hg/ $4 _hg_taxID-9606_2.fastq | sed 's/ //g'`
$pathPY $pathKRextract -k $kr_output_total -1 $R1_pair -2 $R2_pair -o $hg1 -o2 $hg2 -t $taxID_hg -r $kr_report_total --include-children --fastq-output

#bacteria
b1=`echo fastq_notHg/ $4 _bac_taxID-2_1.fastq | sed 's/ //g'`
b2=`echo fastq_notHg/ $4 _bac_taxID-2_2.fastq | sed 's/ //g'`
$pathPY $pathKRextract -k $kr_output_total -1 $R1_pair -2 $R2_pair -o $b1 -o2 $b2 -t $taxID_bac -r $kr_report_total --include-children --fastq-output

#fungus
f1=`echo fastq_notHg/ $4 _fungus_taxID-4751_1.fastq | sed 's/ //g'`
f2=`echo fastq_notHg/ $4 _fungus_taxID-4751_2.fastq | sed 's/ //g'`
$pathPY $pathKRextract -k $kr_output_total -1 $R1_pair -2 $R2_pair -o $f1 -o2 $f2 -t $taxID_fungus -r $kr_report_total --include-children --fastq-output

#virus
v1=`echo fastq_notHg/ $4 _virus_taxID-10239_1.fastq | sed 's/ //g'`
v2=`echo fastq_notHg/ $4 _fungus_taxID-10239_2.fastq | sed 's/ //g'`
$pathPY $pathKRextract -k $kr_output_total -1 $R1_pair -2 $R2_pair -o $v1 -o2 $v2 -t $taxID_virus -r $kr_report_total --include-children --fastq-output

#COVID
c1=`echo fastq_notHg/ $4 _COVID_taxID-2697049_1.fastq | sed 's/ //g'`
c2=`echo fastq_notHg/ $4 _COVID_taxID-2697049_2.fastq | sed 's/ //g'`
python $pathKRextract -k $kr_output_total -1 $R1_pair -2 $R2_pair -o $c1 -o2 $c2 -t $taxID_COVID -r $kr_report_total --include-children --fastq-output


#not human
nhg1=`echo fastq_notHg/ $4 _NOT-hg_taxID-9606_1.fastq | sed 's/ //g'`
nhg2=`echo fastq_notHg/ $4 _NOT-hg_taxID-9606_2.fastq | sed 's/ //g'`
python $pathKRextract -k $kr_output_total -1 $R1_pair -2 $R2_pair -o $nhg1 -o2 $nhg2 -t $taxID_hg -r $kr_report_total --exclude --fastq-output
