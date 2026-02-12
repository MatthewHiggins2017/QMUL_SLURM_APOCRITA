#!/bin/bash
#SBATCH -J my_first_job       # Job name
#SBATCH -o %x.o%j             # Output file: jobname.o<jobid>
#SBATCH -e %x.e%j             # Error file: jobname.e<jobid>
#SBATCH -n 1                  # Request 1 core
#SBATCH -t 0:5:0              # Request 5 minutes runtime
#SBATCH --mem-per-cpu=1G      # Request 1GB RAM

# Print some information
echo "Job started at: $(date)"
echo "Running on node: $(hostname)"
echo "Job ID: ${SLURM_JOB_ID}"

# Simulate some work (wait for 60 seconds)
echo "Sleeping for 60 seconds..."
sleep 60

echo "Job completed at: $(date)"