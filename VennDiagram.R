#install.packages("eulerr")
library(eulerr)
library(dplyr)

pWidth <- 1920
pHeight <- 1200
dpi <- 250
fontSize <- 3000
destPath <- "~/PRIMUS/data/18_lab/MALDI Imaging/Scimax_Rapiflex/Venn"

fill.colors <- c("#53e007","#e02807","#07bfe0","#9407e0")


#### Significant Peaks ####
png(filename = paste0(destPath,"/SigPeaks.PNG"), 
    width = pWidth, height = pHeight, res = dpi, units = "px", pointsize = fontSize)
plot(fills = fill.colors,
  eulerr::venn(c("LC-MS" = 68,
                 "MRMS-MALDI" = 327,
                 "MRMS-FIA" = 366,
                 "MALDI-TOF" = 9,
                 "LC-MS&MRMS-FIA" = 6,
                 "LC-MS&MRMS-MALDI" = 2,
                 "MRMS-FIA&MRMS-MALDI" = 23, 
                 "MRMS-FIA&MALDI-TOF" = 1))
)
dev.off()



#### All Peaks ####
png(filename = paste0(destPath,"/AllPeaks.PNG"), 
    width = pWidth, height = pHeight, res = dpi, units = "px", pointsize = fontSize)
plot(fills = fill.colors,
  eulerr::venn(c("LC-MS" = 5218,
                 "MRMS-MALDI" = 5246,
                 "MRMS-FIA" = 6682, 
                 "MALDI-TOF" = 982,
                 "LC-MS&MALDI-TOF" = 110, 
                 "LC-MS&MRMS-FIA" = 1365, 
                 "LC-MS&MRMS-MALDI" = 1116, 
                 "MALDI-TOF&MRMS-FIA" = 268, 
                 "MALDI-TOF&MRMS-MALDI" = 233, 
                 "MRMS-FIA&MRMS-MALDI" = 1148, 
                 "LC-MS&MALDI-TOF&MRMS-FIA&MRMS-MALDI" = 53, 
                 "LC-MS&MALDI-TOF&MRMS-FIA" = 105, 
                 "LC-MS&MALDI-TOF&MRMS-MALDI" = 55, 
                 "MALDI-TOF&MRMS-FIA&MRMS-MALDI" = 294, 
                 "LC-MS&MRMS-FIA&MRMS-MALDI" = 924))
) 
dev.off()



#### Mixed Model Peaks ####
png(filename = paste0(destPath,"/MixedModel.PNG"), 
    width = pWidth, height = pHeight, res = dpi, units = "px", pointsize = fontSize)
eulerr::venn(c("LC-MS"=437, "MRMS-MALDI"=483, "MRMS-FIA"=677, "MALDI-TOF"=213,
               "LC-MS&MRMS-FIA"=18, 
               "LC-MS&MALDI-TOF"=1,
               "LC-MS&MRMS-MALDI"=14, 
               "MRMS-FIA&MALDI-TOF"=5,
               "MRMS-FIA&MRMS-MALDI"=19,
               "MALDI-TOF&MRMS-MALDI"=1,
               "LC-MS&MRMS-FIA&MALDI-TOF&MRMS-MALDI"=0,
               "LC-MS&MRMS-FIA&MALDI-TOF"=0,
               "LC-MS&MRMS-FIA&MRMS-MALDI"=2,
               "LC-MS&MALDI-TOF&MRMS-MALDI"=0,
               "MRMS-FIA&MALDI-TOF&MRMS-MALDI"=0)) %>% plot(fills = c("#53e007","#9407e0","#07bfe0","#e02807"))
dev.off()