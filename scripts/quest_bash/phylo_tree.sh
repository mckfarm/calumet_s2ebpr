#!/bin/bash
#SBATCH --job-name="phylotree"
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH --mem=1G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu
#SBATCH --output=phylo.out
#SBATCH --error=phylo.err

module purge all
module load qiime2/2021.11

# make sequences into qiime artifact
qiime tools import \
  --input-path /projects/p31629/calumet/qiime/dechloro_all.fna \
  --output-path /projects/p31629/calumet/qiime/dechloro_all.qza \
  --type 'FeatureData[Sequence]'

# fasttree
qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences /projects/p31629/calumet/qiime/dechloro_all.qza \
--o-alignment /projects/p31629/calumet/qiime/aligned_dechloro_all.qza \
--o-masked-alignment /projects/p31629/calumet/qiime/masked_aligned_dechloro_all.qza \
--o-tree /projects/p31629/calumet/qiime/unrooted_tree_dechloro_all.qza \
--o-rooted-tree /projects/p31629/calumet/qiime/rooted_tree_dechloro_all.qza

# export
# qiime tools export \
#   --input-path  /projects/p31629/calumet/qiime/unrooted_tree_dechloro_all.qza \
#   --output-path /projects/p31629/calumet/qiime/unrooted_tree_dechloro_all.nwk
