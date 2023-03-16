#!/bin/bash
#SBATCH --job-name="mobileog_db_sbatch"
#SBATCH --partition=cpu2022,synergy,cpu2019,cpu2021
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=14
#SBATCH --time=7-00:00:00
#SBATCH --mem=60G
#SBATCH --output=mobileog_db_sbatch.%A.out
#SBATCH --error=mobileog_db_sbatch.%A.err

# Get the bashrc information for conda.
source ~/.bashrc

# Activate the conda environment.
conda activate mobileogdb_env

# The number of cpus for mobileogdb.
mobileogdb_num_threads=14

output_dir="/work/sycuro_lab/kevin/mobileog_db"
mkdir -p $output_dir

genome_fasta_infile="/work/sycuro_lab/kevin/dominant_lactobacillus_genomes/L_iners_pullulanase_blastn/NCBI_L_iners_cultured_isolates/blast_files/GCF_010748955.1.fa"

mobileog_db_diamond_infile="/bulk/IMCshared_bulk/shared/dbs/mobileOG-db/mobileOG-db-beatrix-1.6.dmnd"

mobileog_db_metadata_infile="/bulk/IMCshared_bulk/shared/dbs/mobileOG-db/mobileOG-db-beatrix-1.6-All.csv"

filename=$(basename $genome_fasta_infile | sed 's/\.fa\|\.fasta\|\.fna//g')

protein_fasta_infile="${output_dir}/${filename}.faa"

#prodigal -i ${genome_fasta_infile} -p meta -a ${protein_fasta_infile}

# Number of Diamond Alignments to Report
kvalue=15

# Maximum E-score
escore=1e-20

# Percent of query coverage.
queryscore=80

# Percent of Identical Matches of samples
pidentvalue=30

diamond blastp -q ${protein_fasta_infile} --db ${mobileog_db_diamond_infile} --outfmt 6 stitle qseqid pident bitscore slen evalue qlen sstart send qstart qend -o "${output_dir}/${filename}.tsv" --threads ${mobileogdb_num_threads} -k ${kvalue} -e ${escore} --query-cover ${queryscore} --id ${pidentvalue}


#python mobileOGs-pl-kyanite.py --o ${sample} --i ${sample}.tsv -m ${METADATA}

