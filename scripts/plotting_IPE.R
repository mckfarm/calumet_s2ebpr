## ---------------------------
## plotting defaults for IPE presentation
## ---------------------------

# output path
outpath_figures <- file.path("results", "IPE", "figures")

## format outpath in ggsave like this
## outpath_figures %>% file.path(NAME)

# phases of carbon dosing
phases <- data.frame(x1=ymd("2021-04-19"),
                     x2=ymd("2021-07-14"),
                     x3=ymd("2021-09-07"))


asv_dechloro <- c("8717744be592c8beffade9c24a1887b2",
                  "56de9f39ed1fcd41057cef79f44af687")



# plot defaults

scale_x_month <- scale_x_date(
  breaks="1 months",
  date_labels="%b %y")

dosing_lines <- list(
  geom_vline(xintercept=phases$x3, color="grey")
)


scale_fill_carbon <- scale_fill_manual(
  values = c("maroon", "royalblue"),
  limits = c("OFF", "ON"))



labels_paogao <- labeller(Genus = c("Ca_Accumulibacter" = "Ca. Accumulibacter",
                                  "Tetrasphaera" = "Tetrasphaera",
                                  "Dechloromonas" = "Dechloromonas",
                                  "Ca_Competibacter" = "Ca. Competibacter"))

scale_fill_paogao <- scale_fill_manual(
  values = met.brewer("Cross", 4),
  limits = c("Ca_Accumulibacter", "Tetrasphaera", "Dechloromonas",
             "Ca_Competibacter"),
  labels = c("Ca. Accumulibacter", "Tetrasphaera", "Dechloromonas",
             "Ca. Competibacter"))

