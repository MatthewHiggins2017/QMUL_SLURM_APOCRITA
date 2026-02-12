#!/bin/bash
#SBATCH -J multi_core_job     # Job name
#SBATCH -o %x.o%j             # Output file
#SBATCH -n 12                  # Request 12 cores
#SBATCH -t 2:0:0              # Request 2 hours runtime
#SBATCH --mem-per-cpu=4G      # 4GB per core = 48GB total

# Load required modules
module load samtools
module load minimap2 


# Create Temporary Directory for this job on scratch 
mkdir -p /gpfs/scratch/${USER}/SLURM_Example_2

# Move to the temporary directory 
cd /gpfs/scratch/${USER}/SLURM_Example_2

# Download Reference
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/836/945/GCF_000836945.1_ViralProj14044/GCF_000836945.1_ViralProj14044_genomic.fna.gz

gunzip GCF_000836945.1_ViralProj14044_genomic.fna.gz

# Download Reads 
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR112/098/SRR11283998/SRR11283998_1.fastq.gz

# Map reads to reference using minimap2
minimap2 -x map-ont -t ${SLURM_NTASKS} -a GCF_000836945.1_ViralProj14044_genomic.fna SRR11283998_1.fastq.gz | samtools view -bS - > aligned.bam

echo "Job completed successfully"