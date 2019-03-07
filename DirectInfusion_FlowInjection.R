library(proFIA)

plasSet <- proFIAset("~/pbio/LC-MS/Data/Direct_Infusion_V7/Samples/", ppm = 1, 
                     parallel = TRUE, noiseEstimation = TRUE, graphical = TRUE)

plotSamplePeaks(plasSet)

plasSet <- group.FIA(plasSet, ppmGroup = 5, fracGroup = 0.2)

plasSet <- makeDataMatrix(plasSet, maxo = FALSE)

plot(plasSet)

exportES <- exportExpressionSet(plasSet)
pt <- exportPeakTable(plasSet)
dm <- exportDataMatrix(plasSet)
vm <- exportVariableMetadata(plasSet)

write.csv(dm, file = "DI/DI_Peaks_MetaboAnalyst.csv")
