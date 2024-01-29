
#batch01122021/  for first variable 
batch=$1
home=$2
cd $1
ls -1 fastq/* | grep "R1" | sed 's/.fastq.gz//'  | sed 's/fastq\///' | awk '{print $1" "$1" "$1}' | sed 's/R1_//' | sed 's/R1/R2/' | awk -v var=$batch '{print "fastq/"$3".fastq.gz\tfastq/"$2".fastq.gz\t"$1"\t"var}' > files.manifest
cd $2
