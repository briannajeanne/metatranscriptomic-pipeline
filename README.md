
# Multi-Script Data Processing Workflow

This shell script is designed to process multiple sets of paired-end sequencing data using a series of scripts. The scripts included in this workflow handle tasks such as splitting, trimming, counting, and summarizing taxonomic information. The workflow is designed to work with a tab-delimited manifest file containing information about the input data, specifically the paths to the R1 and R2 fastq files, a prefix for output files, and a batch identifier.

## Prerequisites
- The following scripts must be available in the specified paths:
  - `nothmodifying_split_trim.sh`
  - `fq_count.sh`
  - `kraken_summary_levels.sh`
  - `kraken_summary_taxID.sh`
- Ensure that the necessary conda environment (`krsummary_workspace1`) is created and activated before running the script. You can uncomment the provided conda commands if needed.

## Usage
```bash
./manifesting2_wd.sh <manifest_file> <working_directory>
```
- `<manifest_file>`: Path to the tab-delimited manifest file with columns R1, R2, prefix, and batch.
- `<working_directory>`: Directory where the data processing will take place.

## Scripts
- **nothmodifying_split_trim.sh**: Splits and trims paired-end sequencing data.
- **fq_count.sh**: Counts the number of reads in fastq files.
- **kraken_summary_levels.sh**: Generates a summary of taxonomic information at different levels using Kraken.
- **kraken_summary_taxID.sh**: Generates a summary of taxonomic information based on taxonomic IDs using Kraken.

## Workflow Execution
1. Activate the conda environment (`krsummary_workspace1`).
2. Execute the specified scripts for each entry in the manifest file.
3. Perform additional steps like running FastQC on the processed data and compressing fastq files.
4. Deactivate the conda environment.

## Manifest File Format
The manifest file should be tab-delimited and contain the following columns:
- **R1**: Path to the R1 fastq file.
- **R2**: Path to the R2 fastq file.
- **prefix**: Prefix for output files.
- **batch**: Identifier for the batch.

## Example
```bash
./manifesting2_wd.sh my_manifest.txt /path/to/working/directory
```


---

# Sequencing Data Preprocessing and Taxonomic Classification for the first script called (nothmodifying_split_trim.sh)

This script is designed to preprocess paired-end sequencing data, perform deduplication, trimming, and taxonomic classification using Kraken2 and Bracken. The script splits the processed data into different taxonomic groups, such as human, bacteria, fungus, virus, COVID, and non-human.

## Inputs
- `$1`: Working directory
- `$2`: Path to the R1 fastq file
- `$3`: Path to the R2 fastq file
- `$4`: Prefix for output files

## Variables
- `pathKR`: Path to Kraken2 executable
- `pathBR`: Path to Bracken executable
- `pathKRextract`: Path to KrakenTools extract_kraken_reads.py script
- `dbKR`: Path to the Kraken2 database
- `pathCL`: Path to Clumpify script
- `pathTR`: Path to Trimmomatic script
- `pathPY`: Path to Python executable

### Taxonomic IDs
- `taxID_hg`: Human (taxID: 9606)
- `taxID_bac`: Bacteria (taxID: 2)
- `taxID_fungus`: Fungus (taxID: 4751)
- `taxID_virus`: Virus (taxID: 10239)
- `taxID_COVID`: COVID (taxID: 2697049)

## Output Directories
- `fastq_processed`: Deduplicated and trimmed fastq files
- `kr_reports`: Kraken2 classification reports
- `fastq_notHg`, `fastq_Hg`: Split fastq files based on taxonomic groups
- `logs`: Log files generated during processing
- `QC`: Quality control reports
- `kr_reports_modified`: Modified Kraken2 classification reports

## Workflow Steps

### Pre-processing
1. **Deduplication**: Removes duplicate reads.
2. **Trimming**: Trims low-quality bases and adapters.

### Taxonomic Analysis
3. **Kraken2 Total Classification**: Performs taxonomic classification of the entire dataset.
4. **Bracken**: Summarizes taxonomic information using Bracken.

### Data Splitting
5. **Human Reads**: Extracts reads classified as human (taxID 9606).
6. **Bacterial Reads**: Extracts reads classified as bacteria (taxID 2).
7. **Fungus Reads**: Extracts reads classified as fungus (taxID 4751).
8. **Virus Reads**: Extracts reads classified as virus (taxID 10239).
9. **COVID Reads**: Extracts reads classified as COVID (taxID 2697049).
10. **Non-Human Reads**: Extracts reads not classified as human.

## Usage
```bash
./nothmodifying_split_trim.sh <working_directory> <R1_fastq> <R2_fastq> <output_prefix>
```

## Notes
- Review and modify the paths to external tools and databases in the script to match your system.
- Ensure that taxonomic IDs are accurate for your specific analysis.
- Additional customization can be done based on specific requirements.

## License
This script is provided under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to adjust the content based on specific details or additional information you'd like to include in your README.

## Notes
- Review the scripts in the workflow to ensure they meet the requirements of your specific data processing needs.
- Verify that the specified conda environment is correctly set up with the required dependencies.
