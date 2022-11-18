#!/bin/bash
#SBATCH --job-name="visual"
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 05:00:00
#SBATCH -N 1
#SBATCH --mem=1G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu
#SBATCH --output=viz.out
#SBATCH --error=viz.err

module purge all
module load qiime2/2021.11

qiime demux summarize --i-data /projects/p31629/calumet/qiime/reads.qza  \
--o-visualization /projects/p31629/calumet/qiime/readquality_raw.qzv

qiime demux summarize --i-data /projects/p31629/calumet/qiime/reads_trimmed.qza  \
--o-visualization /projects/p31629/calumet/qiime/readquality_trimmed.qzv
