# Calumet S2EBPR Collaboration

## Repo structure
📁 data - performance data and misc files from pilot  
📁 qiime_outputs - output files from QIIME2 workflow  
📁 results - output files and figures from analysis  
📁 scripts - QIIME2 and analysis scripts  
 
## 16S analysis workflow  

### Programs and computing resources:  
- 16S rRNA amplicon sequence analysis using QIIME2 2021.11 performed on Northwestern Quest computing cluster
- Some commands performed in interactive job and activate the module in Quest - module load qiime2/2021.11
- Scripts were run using a batch submission on Quest
- Data analysis using R locally

### QIIME2 workflow:  
1) create manifest file
- grabbed list of files from Quest then edited in excel and saved as manifest.csv

2) import paired end reads - these will be output as demultiplexed since they are imported with the manifest file  
```
qiime tools import --input-path /projects/p31629/calumet/qiime/manifest.csv \
--input-format PairedEndFastqManifestPhred33 \
--output-path /projects/p31629/calumet/qiime/reads.qza \
--type SampleData[PairedEndSequencesWithQuality]
```

3) trim primers  
```
qiime cutadapt trim-paired --i-demultiplexed-sequences /projects/p31629/calumet/qiime/reads.qza  \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r CCGYCAATTYMTTTRAGTTT \
--p-error-rate 0.1 \
--p-overlap 3 \
--o-trimmed-sequences /projects/p31629/calumet/qiime/reads_trimmed.qza
```
error rate and overlap are default parameters - written out in the command for informational purposes  


4) visualize read quality  
```
qiime demux summarize --i-data /projects/p31629/calumet/qiime/reads.qza  \
--o-visualization /projects/p31629/calumet/qiime/readquality_raw.qzv

qiime demux summarize --i-data /projects/p31629/calumet/qiime/reads_trimmed.qza  \
--o-visualization /projects/p31629/calumet/qiime/readquality_trimmed.qzv
```

5) dada2
- denoise and trim
- trimming is based on read quality statistics from the previous step - keep sequences with average read quality of >30
- this command creates three files: dada2 quality filtering table (stats), data table of read info that can be coupled to metadata (table), and a list of amplicon sequence variants that will be used for blast or other commands (rep_seqs)


6) process dada2 outputs
- List ASVs (to keep in case I want to blast later)
- Show dada2 denoising stats

```
qiime feature-table tabulate-seqs \
--i-data /projects/p31629/calumet/qiime/rep_seqs_dada2.qza \
--o-visualization /projects/p31629/calumet/qiime/rep_seqs_dada2.qzv

qiime metadata tabulate --m-input-file /projects/p31629/calumet/qiime/stats_dada2.qza \
--o-visualization /projects/p31629/calumet/qiime/stats_dada2.qzv
```

remove T30 sample since it didnt return many reads
```
qiime feature-table filter-samples \
--i-table /projects/p31629/calumet/qiime/table_dada2_raw.qza \
--p-min-frequency 10000 \
--o-filtered-table /projects/p31629/calumet/qiime/table_dada2.qza

qiime feature-table filter-seqs \
--i-data /projects/p31629/calumet/qiime/rep_seqs_dada2_raw.qza \
--i-table /projects/p31629/calumet/qiime/table_dada2.qza \
--o-filtered-data /projects/p31629/calumet/qiime/rep_seqs_dada2.qza
```

7) create phylogenetic tree with mafft & assign taxonomy with taxa.sh
- make phylogenetic tree
- assign taxonomy

8) visualize alpha rarefaction curve
- this is performed to confirm that the alpha diversity plateaus over time
```
qiime diversity alpha-rarefaction \
--i-table /projects/p31629/calumet/qiime/table_dada2.qza \
--i-phylogeny /projects/p31629/calumet/qiime/rooted_tree.qza \
--o-visualization /projects/p31629/calumet/qiime/alpha_rarefaction.qzv \
--p-max-depth 10000
```

9) save QIIME outputs locally
- at minimum you need rooted_tree.qza, table_dada2.qza, taxonomy.qza, and stats_dada2.qzv
- I also saved the visualization files along the way (read quality, taxonomy, )

10) use R on local computer to perform data analysis
- key steps of R script include filtering eukaryotic sequences and rarefaction
