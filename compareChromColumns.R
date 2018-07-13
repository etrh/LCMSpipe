C18_peaks <- read.csv("~/pbio/LC-MS/Analysis/TestNovéExtrakce_180710/C18_analysis/C18_PeakIntensityMatrix_MetaboAnalyst_ESI+.csv", 
                      colClasses = c(NA, rep("NULL",7)))
C30_peaks <- read.csv("~/pbio/LC-MS/Analysis/TestNovéExtrakce_180710/C30_analysis/C30_PeakIntensityMatrix_MetaboAnalyst_ESI+.csv", 
                      colClasses = c(NA, rep("NULL",7)))

C18_peaks <- C18_peaks[-1,,drop=F]
C30_peaks <- C30_peaks[-1,,drop=F]

dplyr::`%>%` -> `%>%`

C18_mzs <- sub(".*M *(.*?) *T.*", "\\1", C18_peaks$X) %>% as.numeric
C30_mzs <- sub(".*M *(.*?) *T.*", "\\1", C30_peaks$X) %>% as.numeric