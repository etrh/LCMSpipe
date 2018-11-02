library(lme4)
library(multcomp)

mmMetab <- read.csv("QC/PeakIntensityMatrix_MIXEDMODEL.csv", check.names = F)
names(mmMetab)[1] <- "Features"

mmMetab <- melt(mmMetab, id.vars = c("Features"))
names(mmMetab)[2] <- "Sample"
names(mmMetab)[3] <- "Intensity"

mmGroups <- read.csv("QC/Mixed_Model_Groups.csv", check.names = F) %>% t
colnames(mmGroups) <- mmGroups[1,]
mmGroups <- as.data.frame(mmGroups[-1,])

mmDF <- merge(mmMetab, mmGroups, by.x = "Sample", by.y = "row.names")

m1 <- lme4::lmer(Intensity ~ TYPE + GENDER + DAY + (1|ID) + (1|LCMSRUN), data = mmDF, REML = FALSE)
m0 <- lme4::lmer(Intensity ~ GENDER + DAY + (1|ID) + (1|LCMSRUN), data = mmDF, REML = FALSE)

res <- anova(m1, m0)
summary(m1)$coefficients

c2d <- mmDF
c2d$interactions <- with(c2d, interaction(TYPE, GENDER, DAY, sep = "x"))
m1c <- lme4::lmer(Intensity ~ interactions + (1|ID) + (1|LCMSRUN), data = c2d, REML = FALSE)
ll <- multcomp::glht(m1c, linfct = mcp(interactions = "Tukey"))
summary_ll <- summary(ll)
summary_m1c <- summary(m1c)
rownames(summary_m1c$coefficients)
