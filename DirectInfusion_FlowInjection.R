library(proFIA)

plasSet <- proFIAset("~/pbio/LC-MS/Data/Direct_Infusion_V7/Samples/", ppm = 1, 
                     parallel = TRUE, noiseEstimation = TRUE, graphical = TRUE)

plotSamplePeaks(plasSet)
