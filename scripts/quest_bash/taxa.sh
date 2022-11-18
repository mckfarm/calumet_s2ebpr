#!/bin/bash
#SBATCH --job-name="taxa"
#SBATCH -A p31629
#SBATCH -p normal
#SBATCH -t 24:00:00
#SBATCH -N 1
#SBATCH --mem=10G
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=mckennafarmer2023@u.northwestern.edu
#SBATCH --output=taxa.out
#SBATCH --error=taxa.err

module purge all
module load qiime2/2021.11

# fasttree
qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences /projects/p31629/calumet/qiime/rep_seqs_dada2.qza \
--o-alignment /projects/p31629/calumet/qiime/aligned_rep_seqs_dada2.qza \
--o-masked-alignment /projects/p31629/calumet/qiime/masked_aligned_rep_seqs_dada2.qza \
--o-tree /projects/p31629/calumet/qiime/unrooted_tree.qza \
--o-rooted-tree /projects/p31629/calumet/qiime/rooted_tree.qza

# taxonomy
qiime feature-classifier classify-sklearn \
--i-classifier /projects/b1052/shared/qiime/midas_4.8.1_classifier.qza \
--i-reads /projects/p31629/calumet/qiime/rep_seqs_dada2.qza \
--o-classification /projects/p31629/calumet/qiime/taxonomy.qza

qiime metadata tabulate --m-input-file /projects/p31629/calumet/qiime/taxonomy.qza \
--o-visualization /projects/p31629/calumet/qiime/taxonomy.qzv
