#### Load direct infusion data with multiple scans ####

file.prof <- list.files("~/pbio/LC-MS/Data/Direct_Infusion_V7/", recursive = FALSE, full.names = TRUE)
file.prof <- file.prof[-grep(file.prof, pattern = "MeOH")]

### Combine scans and write to new mzML files ####
dir.create("CombinedSpectra")
for(i in 1:length(file.prof)){
  
  prof.files <- readMSData(file.prof[i], pdata = NULL, mode = "onDisk")
  spec <- Spectra(spectra(prof.files))
  
  #conSpec <- Spectra(consensusSpectrum(spectra(prof.files), timeDomain = F))
  comSpec <- combineSpectra(spec, timeDomain = F, mzd = 0.001, weighted = FALSE, ppm = 1)
  #comSpecWeighted <- combineSpectra(spec, timeDomain = F, mzd = 0.01, weighted = T)
  
  writeMSData(object = as(comSpec, "MSnExp"), file = paste0("CombinedSpectra/combined_", basename(file.prof[i])))
  #writeMSData(object = as(comSpecWeighted, "MSnExp"), file = "V7_Weighted_combinedSpectrum.mzML")
  
}

#### Load combined spectra ####
combSpec <- readMSData(list.files("CombinedSpectra/", full.names = TRUE, pattern = ".mzML"), pdata = NULL, mode = "onDisk")
#combSpecWeighted <- readMSData("V7_Weighted_combinedSpectrum.mzML", pdata = NULL, mode = "onDisk")

#### Detect peaks ####

msw <- MSWParam(scales = c(1, 4, 9), nearbyPeak = TRUE, winSize.noise = 500, SNR.method = "data.mean", snthresh = 10, verboseColumns = TRUE, peakThr = 1000)
peaks <- findChromPeaks(combSpec, param = msw)
#peaksWeighted <- findChromPeaks(combSpecWeighted, param = msw)

chromPeaks(peaks)
#chromPeaks(peaksWeighted)

peaks$sample_group <- rep("V7", length(file.prof))

#### Peak grouping ####
mzcparam <- MzClustParam(sampleGroups = peaks$sample_group, ppm = 1, minFraction = 0.6)
peaks_mzClust <- groupChromPeaks(peaks, param = mzcparam)

### Plot all identified peaks ####
for(i in 1:length(featureDefinitions(peaks_mzClust)$peakidx)){
  ## Get the peaks belonging to the first, second, third, etc. feature
  pks <- chromPeaks(peaks_mzClust)[featureDefinitions(peaks_mzClust)$peakidx[[i]], ]
  
  ## Define the m/z range
  mzr <- c(min(pks[, "mzmin"]) - 0.001, max(pks[, "mzmax"]) + 0.001)
  
  ## Subset the object to the m/z range
  peaks_mzClust_sub <- filterMz(peaks_mzClust, mz = mzr)
  
  ## Extract the mz and intensity values
  mzs <- mz(peaks_mzClust_sub, bySample = TRUE)
  ints <- intensity(peaks_mzClust_sub, bySample = TRUE)
  
  ## Plot the data
  png(paste0("CombinedSpectra/", paste(rownames(featureDefinitions(peaks_mzClust))[i]), ".png"), width = 10, height = 7, units = "in", res = 400)
  plot(3, 3, pch = NA, xlim = range(mzs), ylim = range(ints), main = paste(rownames(featureDefinitions(peaks_mzClust))[i]),
       xlab = "m/z", ylab = "intensity")
  ## Define colors
  cols <- rep("#ff000080", length(mzs))
  #cols[peaks_mzClust_sub$sample_group == "V7"] <- "#0000ff80"
  tmp <- mapply(mzs, ints, cols, FUN = function(x, y, col) {
    points(x, y, col = col, type = "l")
  })
  dev.off()
}

#### Fill in missing peaks from raw data ####
peaks_filled <- fillChromPeaks(peaks_mzClust, param = FillChromPeaksParam())

### Extract peak information ####
peaks_features <- featureValues(peaks_filled, value = "into") ### Extract peak areas
ftD <- as.data.frame(featureDefinitions(peaks_filled))
ftMZ <- ftD[,"mzmed", drop = F]

peaks_mzs <- merge(peaks_features, ftMZ, by = "row.names")
rownames(peaks_mzs) <- peaks_mzs$mzmed
peaks_mzs <- peaks_mzs[,-which(names(peaks_mzs) %in% c("Row.names", "mzmed"))]

write.csv(x = peaks_mzs, file = "Direct_Infusion_V7_Peaks.csv")