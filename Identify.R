mzRTdf <- read.csv("~/PRIMUS/data/83_BIOINFORMATICS/Ashkan/Else/Fat_mouse/Nuvit_Plasma_15min/Statistics/MixedModel_PeakIntensityMatrix.csv")
names(mzRTdf)[1] <- "mzRT"

mzRTdf.mzs <- as.numeric(sub(".*M *(.*?) *T.*", "\\1", mzRTdf$mzRT))

significant_features_mz <- mzRTdf.mzs

### Run the chunk named 'Metabolite Identification using MassBank of North America' from Main_Pipeline.Rmd

mzRT.identified <- lapply(identified, 
                          function(z){
                            lapply((z$compound), 
                                   function(x){
                                     x$names[[1]]$name}) %>% unlist %>% paste(collapse = "; ")
                            }) %>% unlist

mzRTdf$`MassBank (mz tolerance = 0.25 Da)` <- mzRT.identified

### Run the identification with Metlin script



mzRTdf$METLIN