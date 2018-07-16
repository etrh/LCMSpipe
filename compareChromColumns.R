C18_peaks <- read.csv("~/pbio/LC-MS/Analysis/TestNovéExtrakce_180710/C18_analysis/C18_PeakIntensityMatrix_MetaboAnalyst_ESI+.csv", 
                      colClasses = c(NA, rep("NULL",7)))
C30_peaks <- read.csv("~/pbio/LC-MS/Analysis/TestNovéExtrakce_180710/C30_analysis/C30_PeakIntensityMatrix_MetaboAnalyst_ESI+.csv", 
                      colClasses = c(NA, rep("NULL",7)))

C18_peaks <- C18_peaks[-1,,drop=F]
C30_peaks <- C30_peaks[-1,,drop=F]

dplyr::`%>%` -> `%>%`

C18_mzs <- sub(".*M *(.*?) *T.*", "\\1", C18_peaks$X) %>% as.numeric
C30_mzs <- sub(".*M *(.*?) *T.*", "\\1", C30_peaks$X) %>% as.numeric

mz_tolerance <- 0.05
C18_mzs[!data.table::inrange(C18_mzs, C30_mzs - mz_tolerance, C30_mzs + mz_tolerance)] -> in_C18_NOT_in_C30
C30_mzs[!data.table::inrange(C30_mzs, C18_mzs - mz_tolerance, C18_mzs + mz_tolerance)] -> in_C30_NOT_in_C18


## Statistics

summary(in_C18_NOT_in_C30)
summary(in_C30_NOT_in_C18)

quantile(in_C18_NOT_in_C30)
quantile(in_C30_NOT_in_C18)

C18_vs_C30 <- data.frame(mass = c(in_C18_NOT_in_C30, in_C30_NOT_in_C18),
                         column = c(rep("C18", length(in_C18_NOT_in_C30)), rep("C30", length(in_C30_NOT_in_C18))))

ggplot(C18_vs_C30, aes(x = column, y = mass, fill = column)) + geom_boxplot() -> C18_C30_boxplot

mu <- plyr::ddply(C18_vs_C30, "column", summarise, grp.mean = mean(mass))

ggplot(C18_vs_C30, aes(x = mass, color = column, fill = column)) +
  geom_histogram(position = "identity", alpha = 0.5) +
  geom_vline(data = mu, aes(xintercept = grp.mean, color = column),
             linetype = "dashed") +
  scale_color_manual(values = c("#999999", "#E69F00", "#56B4E9")) +
  scale_fill_manual(values = c("#999999", "#E69F00", "#56B4E9")) +
  labs(title = "Masses detected by C18 and C30", x = "Masses", y = "Count") +
  theme_classic() -> C18_C30_histogram

ggplot(C18_vs_C30, aes(x = mass, color = column, fill = column)) +
  geom_histogram(aes(y = ..density..), position = "identity", alpha = 0.5) +
  geom_density(alpha = 0.6) +
  geom_vline(data = mu, aes(xintercept = grp.mean, color = column),
             linetype = "dashed")+
  scale_color_manual(values = c("#999999", "#E69F00", "#56B4E9"))+
  scale_fill_manual(values = c("#999999", "#E69F00", "#56B4E9"))+
  labs(title = "C18 vs. C30 LC-MS Columns",x = "Masses", y = "Density")+
  theme_classic() -> C18_C30_density_histogram

ggsave(filename = "C18_C30_Boxplot.png", plot = C18_C30_boxplot, device = "png", width = 15, height = 7, units = "in", dpi = 800)
ggsave(filename = "C18_C30_histogram.png", plot = C18_C30_histogram, device = "png", width = 15, height = 7, units = "in", dpi = 800)
ggsave(filename = "C18_C30_density_histogram.png", plot = C18_C30_density_histogram, device = "png", width = 15, height = 7, units = "in", dpi = 800)