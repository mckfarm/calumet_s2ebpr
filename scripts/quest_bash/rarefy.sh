#!/bin/bash
#SBATCH --job-name="rarefy"
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 05:00:00
#SBATCH -N 1
#SBATCH --mem=1G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu
#SBATCH --output=rare.out
#SBATCH --error=rare.err

module purge all
module load qiime2/2021.11

qiime diversity core-metrics-phylogenetic \
--i-table /projects/p31629/calumet/qiime/table_dada2.qza \
--i-phylogeny /projects/p31629/calumet/qiime/rooted_tree.qza \
--p-sampling-depth 16000 \
--m-metadata-file /projects/p31629/calumet/qiime/metadata.txt \
--output-dir /projects/p31629/calumet/qiime/core-metrics-results-16000
