## ---------------------------
## Script name: phylo_dechloro.R
## Purpose of script: Phylogenetic tree for dechloromonas
## Author: McKenna Farmer
## Date Created: 2022-10-26
## ---------------------------
## Notes:
##
##
## ---------------------------

# packages
library(ggplot2)
library(MetBrewer)
library(dplyr)
library(qiime2R)
library(ggtree)

# read in
tree_qza <- read_qza("~/GitHub/calumet_s2ebpr/data/phylotrees/dechloro/rooted_tree_dechloro_all.qza")
tree <- tree_qza$data

rm(tree_qza)

# --------
# used to make a name column with nicely formatted labels in excel, sending back to R
label_mod <- tree$tip.label
write.csv(label_mod, "labels1.csv")

dechloro_df <- read.csv("./data/phylotrees/dechloro/dechloro_df.csv")

labels <- read_csv("./data/phylotrees/dechloro/labels1.csv")

loc_summary <- dechloro_df %>%
  filter(Abundance>0) %>%
  group_by(location,OTU) %>%
  tally() %>%
  pivot_wider(id_cols=OTU,names_from=location,values_from=n)

labels <- left_join(labels, loc_summary, by=c("newick_label"="OTU"))

write.csv(labels, "./data/phylotrees/dechloro/labels2.csv")

rm(dechloro_df)

# make column manually for locations then read in

# ------

labels <- read.csv("./data/phylotrees/dechloro/labels2.csv")

labels$locations <- factor(labels$locations,
                           levels=c("All locations","Control only","RAS only","EBPR only","Reference"))

ggtree(tree) %<+% labels +
  geom_nodepoint(aes(subset=tree$node.label>=0.9),shape=10) +
  geom_nodepoint(aes(subset=tree$node.label<0.9 & tree$node.label>0.5)) +
  geom_tiplab(aes(label=name),hjust=-0.02) +
  geom_tippoint(aes(shape=locations,color=locations),size=3) +
  scale_shape_manual(values=c(18,0,1,2,4), name="Location") +
  scale_color_manual(values=met.brewer("Java", 5), name="Location") +
  geom_treescale(x=0,y=25,width=0.05) +
  theme(legend.position=c(0.1,0.70)) + xlim(NA, 0.4)

ggsave("./data/phylotrees/dechloro/tree.tiff",units="in",height=5,width=8)


