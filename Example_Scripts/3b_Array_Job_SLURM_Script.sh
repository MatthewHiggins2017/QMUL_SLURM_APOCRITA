!/bin/bash
#SBATCH -J minimap2_array
#SBATCH -o array_logs/%x.o%A.%a
#SBATCH -e array_logs/%x.e%A.%a
#SBATCH -n 8
#SBATCH --mem-per-cpu=4G
#SBATCH -t 4:0:0
#SBATCH -a 1-4                # 4 samples (matches number of lines in sample_list.txt)

# Load required modules
module load minimap2
module load samtools

# Define working directory
WORK_DIR="/gpfs/scratch/${USER}/SLURM_Example_2"
mkdir -p ${WORK_DIR}

# Reference genome
REFERENCE="${WORK_DIR}/GCF_000836945.1_ViralProj14044_genomic.fna"

# Get the FTP URL for this task
FTP_URL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sample_list.txt)

# Extract sample name from URL (e.g., SRR29929219_1)
SAMPLE=$(basename ${FTP_URL} .fastq.gz)

# Define paths
FASTQ_FILE="${WORK_DIR}/${SAMPLE}.fastq.gz"
OUTPUT="${WORK_DIR}/${SAMPLE}.bam"

# Download FASTQ file
echo "Downloading ${SAMPLE}..."
wget -O ${FASTQ_FILE} ${FTP_URL}

# Run minimap2 and convert to BAM
echo "Processing ${SAMPLE}..."
minimap2 -t ${SLURM_NTASKS} -ax map-ont ${REFERENCE} ${FASTQ_FILE} | samtools view -bS - > ${OUTPUT}

echo "Completed ${SAMPLE}"