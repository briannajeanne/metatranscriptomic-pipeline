#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#bash Miniconda3-latest-Linux-x86_64.sh
conda install -c bioconda/label/cf201901 kraken2 -y
conda install -c bioconda/label/cf201901 bbmap -y 
conda install -c bioconda/label/cf201901 trimmomatic -y
conda install -c bioconda/label/cf201901 bedtools -y
conda install -c anaconda git -y
git clone https://github.com/jenniferlu717/KrakenTools.git
git clone https://github.com/jenniferlu717/Bracken.git
git clone https://github.com/DerrickWood/kraken2.git
#wget https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_20210517.tar.gz
#tar -xf k2_pluspf_20210517.tar.gz
