## ---------------------------
## Script name: phylotree_prep_dechloro.R
## Purpose of script: Extract sequences of interest from Midas db files
## Author: McKenna Farmer
## Date Created: 2022-10-26
## ---------------------------
## Notes:
##
##
## ---------------------------

library(Biostrings)
library(readr)
library(dplyr)
library(qiime2R)
library(phyloseq)

# read in
# midas
midas_seqs <- readDNAStringSet("./data/QIIME Fasta file MiDAS 4.8.1.fa")
midas_taxonomy <- read_csv("./data/midas_taxonomy.csv")

# seqs
physeq <- qza_to_phyloseq(
  features ="./qiime_outputs/table_dada2.qza",
  tree ="./qiime_outputs/rooted_tree.qza",
  taxonomy ="./qiime_outputs/taxonomy.qza",
  metadata = "./data/16S_metadata.txt")

asvs <- readDNAStringSet("./qiime_outputs/rep_seqs_dada2.fasta")

physeq@refseq <- asvs

# parsing
# subset to dechloromonas
physeq_dechloro <- subset_taxa(physeq, Genus=="Dechloromonas")

# extract dechloro sequences
dechloro_seqs <- physeq_dechloro@refseq
writeXStringSet(dechloro_seqs, "dechloro_seqs.fasta")


# picking reference seqs from midas - take first seq
phosphoritropha <- midas_taxonomy %>%
  filter(species=="Ca_Dechloromonas_phosphoritropha")
phosphoritropha <- phosphoritropha[1:2,]

phosphoritropha_ref_seqs <- midas_seqs[names(midas_seqs) %in% phosphoritropha$id]

phosphorivorans <- midas_taxonomy %>%
  filter(species=="Ca_Dechloromonas_phosphorivorans")
phosphorivorans <- phosphorivorans[1:2,]

phosphorivorans_ref_seqs <- midas_seqs[names(midas_seqs) %in% phosphorivorans$id]



# combining into a fasta
writeXStringSet(phosphoritropha_ref_seqs, "phosphoritropha.fasta")
writeXStringSet(phosphorivorans_ref_seqs, "phosphorivorans.fasta")


# manually add these to a reference_seqs.fasta file
# also add reference sequences from NCBI 16S dataset
# now reimport these sequences and trim all to region of interest 500-950 (515-926)
# ref_seqs <- readDNAStringSet("./data/phylotrees/dechloro/reference_seqs.fa")

