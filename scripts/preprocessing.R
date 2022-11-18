## ---------------------------
## Script name: preprocessing.R
## Purpose of script: Parsing data before producing analysis and figures
## Author: McKenna Farmer
## Date Created: 2022-08-29
## ---------------------------
## Notes:
##
##
## ---------------------------

# package read in -----------
library(readxl)
library(qiime2R)
library(phyloseq)


# performance data parsing -------
path_performance <- file.path("data", "performance_data.xlsx")

test <- read_excel(path_performance, sheet="batteryA")
control <- read_excel(path_performance, sheet="batteryB")
prim_eff <- read_excel(path_performance, sheet="pe")
gto <- read_excel(path_performance, sheet="gto")
temp <- read_excel(path_performance, sheet="temp")

test$date <- as_date(test$date)
control$date <- as_date(control$date)
prim_eff$date <- as_date(prim_eff$date)
gto$date <- as_date(gto$date)
temp$date <- as_date(temp$date)

control$location <- "control"
test$location <- "test"
prim_eff$location <- "primary_eff"
gto$location <- "gto"
temp$location <- "air"

# liters per minute
test$flow_microC <- test$flow_microC * 3.785

control_melt <- melt(control,id.vars=c("date","location"))
test_melt <- melt(test,id.vars=c("date","location"))
prim_eff_melt <- melt(prim_eff,id.vars=c("date","location"))
gto_melt <- melt(gto,id.vars=c("date","location"))
temp_melt <- melt(temp,id.vars=c("date","location"))

perf_all <- bind_rows(control_melt,test_melt,prim_eff_melt,gto_melt,temp_melt)

write.csv(perf_all,file.path("data","performance_all.csv"), row.names=FALSE)


# microbiome ---------
physeq <- qza_to_phyloseq(
  features="./qiime_outputs/table_dada2.qza",
  tree="./qiime_outputs/rooted_tree.qza",
  taxonomy="./qiime_outputs/taxonomy.qza",
  metadata = "./data/16S_metadata.txt"
)

# removing eukaryotes
physeq <- subset_taxa(physeq, !Genus=="Mitochondria" & !Genus=="Chloroplast")

# relative abundance
rel <- transform_sample_counts(physeq, function(x) x*100/sum(x))

# save as df for downstream work

rel_df <- psmelt(rel)
rel_df$date <- mdy(rel_df$date)
rel_df$location <- factor(rel_df$location,levels=c("control","test","ras"))

write.csv(rel_df, outpath_figures %>% file.path("abundance_relative.csv"), row.names=FALSE)


# rarefaction
physeq2 <- rarefy_even_depth(physeq,sample.size=min(sample_sums(physeq)),
                             rngseed=1)

rarefy_level <- min(sample_sums(physeq2))
# save as df for downstream work
count_df <- psmelt(physeq2)
count_df$date <- mdy(count_df$date)
count_df$location <- factor(count_df$location,levels=c("control","test","ras"))

write.csv(count_df, outpath_figures %>% file.path("abundance_counts.csv"), row.names=FALSE)
