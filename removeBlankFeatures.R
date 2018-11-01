### Compare mz/rt from blanks to mz/rt from samples
### https://stackoverflow.com/questions/53097977/conditional-setdiff-all-to-all-on-two-columns-from-two-dataframes-with-a-numer/53099878#53099878

### This script will remove the features found in blank samples from 'normal' samples

df <- read.csv("removeBlanksFromSamples.csv") ### list of mz/rt features in blanks and samples
df1 <- df$Blanks %>% as.factor %>% as.character
df2 <- df$Samples %>% as.factor %>% as.character

### Remove the ones found in Blanks from Samples.

df1 <- df1[which(df1 != "")]

df1_mz <- sub(".*M *(.*?) *T.*", "\\1", df1) %>% as.numeric
df2_mz <- sub(".*M *(.*?) *T.*", "\\1", df2) %>% as.numeric

df1_rt <- sapply(strsplit(df1,"T"),function(x) x[2])
df2_rt <- sapply(strsplit(df2,"T"),function(x) x[2])

df1 <- data.frame(df1_mz, df1_rt)
df2 <- data.frame(df2_mz, df2_rt)

df1$df1_rt %<>% as.factor %>% as.character %>% as.numeric
df2$df2_rt %<>% as.factor %>% as.character %>% as.numeric

### First solution -- careful here, df1 should be probably replaced with 'df2', because df1 is blank features which must be removed from df2
df1$remove <- rep("No", nrow(df1))
for(i in 1:nrow(df1)){
  for(j in 1:nrow(df2)){
    if(data.table::inrange(df1$df1_mz[i], df2$df2_mz[j] - 0.01, df2$df2_mz[j] + 0.01) && 
       data.table::inrange(df1$df1_rt[i], df2$df2_rt[j] - 10, df2$df2_rt[j] + 10)) {
      df1$remove[i] <- "remove"
    }
  }
}