#!/bin/bash
#SBATCH --job-name="dada2"
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 12:00:00
#SBATCH -N 1
#SBATCH --mem=20G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu
#SBATCH --output=dada2.out
#SBATCH --error=dada2.err

module purge all
module load qiime2/2021.11

qiime dada2 denoise-paired --verbose \
--i-demultiplexed-seqs /projects/p31629/calumet/qiime/reads_trimmed.qza \
--p-trunc-len-f 242 --p-trunc-len-r 200 \
--o-representative-sequences /projects/p31629/calumet/qiime/rep_seqs_dada2.qza \
--o-table /projects/p31629/calumet/qiime/table_dada2.qza \
--o-denoising-stats /projects/p31629/calumet/qiime/stats_dada2.qza
