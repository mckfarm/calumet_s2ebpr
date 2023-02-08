## ---------------------------
## Script name: plotting.R
## Purpose of script: plotting defaults for S2EBPR manuscript
## Author: McKenna Farmer
## Date Created: 2022-09-14
## ---------------------------
## Notes:
##
##
## ---------------------------

# output path
outpath_figures <- file.path("results","figures")
## format outpath in ggsave like this
## outpath_figures %>% file.path(NAME)

# phases of carbon dosing
phases <- data.frame(x1=ymd("2021-04-19"),
                     x2=ymd("2021-07-14"),
                     x3=ymd("2021-09-07"))

theme_perf <- theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

# plot defaults

scale_x_main <- scale_x_date(
  breaks="2 months",
  date_labels="%b %y",
  limits=c(ymd("2021-02-22"),ymd("2021-12-31"))
)

scale_x_control <- scale_x_date(
  breaks="1 months",
  date_labels="%b %y",
  limits=c(ymd("2021-09-01"),ymd("2021-12-15"))
)

dosing_lines <- list(
  geom_vline(xintercept=phases$x1, color="grey"),
  geom_vline(xintercept=phases$x2, color="grey"),
  geom_vline(xintercept=phases$x3, color="grey")
)


fill_basins <- scale_fill_manual(
  limits = c("test","ras","control"),
  labels = c("EBPR basin","RAS fermenter","Nitrification basin"),
  values = met.brewer("Moreau", 3)
)

color_basins <- scale_color_manual(
  limits = c("test","ras","control"),
  labels = c("EBPR basin","RAS fermenter","Nitrification basin"),
  values = met.brewer("Moreau", 3)
)

color_inf_eff <- scale_color_manual(
  limits = c("primary_eff","test","control"),
  labels = c("Primary effluent", "EBPR basin", "Nitrification basin"),
  values = met.brewer("Egypt", 3)
)

shape_basins <- scale_shape_manual(
  limits = c("test","ras","control"),
  labels = c("EBPR basin","RAS fermenter","Nitrification basin"),
  values = c(15,16,17)
)

shape_carbon <- scale_shape_manual(
  limits = c("y","n"),
  labels = c("Dosing on","Dosing off"),
  values = c(16,17)
)

scale_x_basins <- scale_x_discrete(
  limits=c("test","ras","control"),
  labels=c("EBPR basin","RAS fermenter","Nitrification basin")
)

scale_x_basins_short <- scale_x_discrete(
  limits=c("test","ras","control"),
  labels=c("EBPR","RAS","Nit.")
)

fill_compare <- scale_fill_manual(
  limits = c("control","test"),
  labels = c("Nitrification basin","EBPR basin"),
  values = met.brewer("Lakota", 2),
  name = "Location"
)

color_compare <- scale_color_manual(
  limits = c("control","test"),
  labels = c("Nitrification basin","EBPR basin"),
  values = met.brewer("Lakota", 2),
  name = "Location"
)

theme_comp <- theme(legend.position="none",
                    axis.text.x = element_text(size = 9))

labels_comp <- labeller(Genus = c("Ca_Accumulibacter" = "Ca. Accumulibacter",
                                  "Tetrasphaera" = "Tetrasphaera",
                                  "Dechloromonas" = "Dechloromonas",
                                  "Ca_Obscuribacter" = "Ca. Obscuribacter",
                                  "Ca_Competibacter" = "Ca. Competibacter",
                                  "Defluviicoccus" = "Defluviicoccus",
                                  "Ca_Contendobacter" = "Ca. Contendobacter",
                                  "Propionivibrio" = "Propionivibrio"))

scale_fill_paogao <- scale_fill_manual(
  values = met.brewer("Cross",8),
  limits = c("Ca_Accumulibacter","Tetrasphaera","Dechloromonas", "Ca_Obscuribacter",
             "Ca_Competibacter","Defluviicoccus", "Ca_Contendobacter","Propionivibrio"),
  labels = c("Ca. Accumulibacter","Tetrasphaera","Dechloromonas","Ca. Obscuribacter",
             "Ca. Competibacter","Defluviicoccus", "Ca. Contendobacter","Propionivibrio"))


scale_fill_paogao_select <- scale_fill_manual(
  values = met.brewer("Cross",5),
  limits = c("Ca_Accumulibacter","Tetrasphaera","Dechloromonas",
             "Ca_Competibacter","Defluviicoccus"),
  labels = c("Ca. Accumulibacter","Tetrasphaera","Dechloromonas",
             "Ca. Competibacter","Defluviicoccus"))


labels_basins <- labeller(location = c("control"="Nitrification basin",
                                    "ras"="RAS fermenter",
                                    "test"="EBPR basin"))


color_box_carbon <-
  scale_fill_manual(values=met.brewer("Benedictus",4,direction=-1))


asv_dechloro <- c("8717744be592c8beffade9c24a1887b2",
                  "56de9f39ed1fcd41057cef79f44af687")
