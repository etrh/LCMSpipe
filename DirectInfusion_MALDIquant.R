library(MALDIquant)

profile.files <- MALDIquantForeign::importMzMl(path = "~/phome/FatMouse/mzML/+/Samples/")

plot(profile.files[[1]])

spectra <- transformIntensity(profile.files, method = "sqrt")
spectra <- calibrateIntensity(spectra, method = "TIC")

spectra20hWs <- alignSpectra(spectra,
                        halfWindowSize = 20,
                        SNR = 2,
                        tolerance = 0.001,
                        warpingMethod = "lowess")

spectra8hWs <- alignSpectra(spectra,
                             halfWindowSize = 8,
                             SNR = 2,
                             tolerance = 0.001,
                             warpingMethod = "lowess")

samples20hWS <- factor(sapply(spectra20hWs, function(x){basename(metaData(x)$file)}))

avgSpectraMean20hWs <- averageMassSpectra(spectra20hWs, labels = samples20hWS, method = "mean")
avgSpectraSum20hWs <- averageMassSpectra(spectra20hWs, labels = samples20hWS, method = "sum")

noise <- estimateNoise(avgSpectraMean20hWs[[1]])
plot(avgSpectraMean20hWs[[1]], xlim=c(4000, 5000), ylim=c(0, 0.002))

peaks20hWS <- detectPeaks(avgSpectraMean20hWs, method = "MAD", halfWindowSize = 20, SNR = 5)

plot(avgSpectraMean20hWs[[1]], xlim=c(200, 400))
points(peaks20hWS[[1]], col="red", pch=4)

binnedpeaks20hWS <- binPeaks(peaks20hWS, tolerance = 0.001)
filteredpeaks <- filterPeaks(binnedpeaks20hWS, minFrequency = 0.1)

featureMatrix <- intensityMatrix(filteredpeaks, avgSpectraMean20hWs)
