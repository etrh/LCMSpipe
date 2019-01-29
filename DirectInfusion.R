file.prof <- list.files("~/pbio/LC-MS/Data/Direct_Infusion_V7/", recursive = FALSE, full.names = TRUE)
file.prof <- file.prof[-grep(file.prof, pattern = "MeOH")]

dir.create("CombinedSpectra")
for(i in 1:length(file.prof)){
  
  prof.files <- readMSData(file.prof[i], pdata = NULL, mode = "onDisk")
  spec <- Spectra(spectra(prof.files))
  
  #conSpec <- consensusSpectrum(spec, timeDomain = F)
  comSpec <- combineSpectra(spec, timeDomain = F, mzd = 0.01, weighted = FALSE)
  #comSpecWeighted <- combineSpectra(spec, timeDomain = F, mzd = 0.01, weighted = T)
  
  writeMSData(object = as(comSpec, "MSnExp"), file = paste0("CombinedSpectra/combined_", basename(file.prof[i])))
  #writeMSData(object = as(comSpecWeighted, "MSnExp"), file = "V7_Weighted_combinedSpectrum.mzML")
  
}

#combSpec <- readMSData("V7_combinedSpectrum.mzML", pdata = NULL, mode = "onDisk")
#combSpecWeighted <- readMSData("V7_Weighted_combinedSpectrum.mzML", pdata = NULL, mode = "onDisk")

msw <- MSWParam(scales = c(1, 4, 9), nearbyPeak = TRUE, winSize.noise = 500, SNR.method = "data.mean", snthresh = 10, verboseColumns = TRUE, peakThr = 1000)
peaks <- findChromPeaks(combSpec, param = msw)
peaksWeighted <- findChromPeaks(combSpecWeighted, param = msw)

chromPeaks(peaks)
chromPeaks(peaksWeighted)