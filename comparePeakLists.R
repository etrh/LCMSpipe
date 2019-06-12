library(data.table)
options(digits = 10)

a <- scan("~/venn/Agilent_C18_Positive.csv", sep=',', what = "", quiet = TRUE) %>% sub(".*M *(.*?) *T.*", "\\1", .) %>% as.numeric
b <- scan("~/venn/DHB_rapiflex_POS.csv", sep=',', what = "", quiet = TRUE) %>% as.numeric
c <- scan("~/venn/FIA_POS.csv", sep=',', what = "", quiet = TRUE) %>% as.numeric
d <- scan("~/venn/MALDI_POS.csv", sep=',', what = "", quiet = TRUE) %>% as.numeric

#### pairwise

mz_tolerance <- 0.01

a[data.table::inrange(a, b - mz_tolerance, b + mz_tolerance)] %>% length
b[data.table::inrange(b, a - mz_tolerance, a + mz_tolerance)] %>% length

a[data.table::inrange(a, c - mz_tolerance, c + mz_tolerance)] %>% length
c[data.table::inrange(c, a - mz_tolerance, a + mz_tolerance)] %>% length

a[data.table::inrange(a, d - mz_tolerance, d + mz_tolerance)] %>% length
d[data.table::inrange(d, a - mz_tolerance, a + mz_tolerance)] %>% length

b[data.table::inrange(b, c - mz_tolerance, c + mz_tolerance)] %>% length
c[data.table::inrange(c, b - mz_tolerance, b + mz_tolerance)] %>% length

b[data.table::inrange(b, d - mz_tolerance, d + mz_tolerance)] %>% length
d[data.table::inrange(d, b - mz_tolerance, b + mz_tolerance)] %>% length

c[data.table::inrange(c, d - mz_tolerance, d + mz_tolerance)] %>% length
d[data.table::inrange(d, c - mz_tolerance, c + mz_tolerance)] %>% length



compareMasses <- function(L, names, mz_tolerance){
  
  #create list with vectors
  #l <- list( a,b,c,d )
  #names(l) <- c("Agilent_C18_Positive", "DHB_rapiflex_POS", "FIA_POS", "MALDI_POS")
  
  l <- L
  names(l) <- names
  
  #create data.table to work with
  DT <- rbindlist( lapply(l, function(x) {data.table( value = x)} ), idcol = "group")
  #add margins to each value
  DT[, `:=`( id = 1:.N, start = value - mz_tolerance, end = value + mz_tolerance ) ]
  #set keys for joining
  setkey(DT, start, end)
  #perform overlap-join
  result <- foverlaps(DT,DT)
  
  #cast, to check how the 'hits' each id has in each group (a,b,c,d)
  answer <- dcast( result, 
                   group + value ~ i.group, 
                   fun.aggregate = function(x){ x * 1 }, 
                   value.var = "i.value", 
                   fill = NA )
  
  #get your final answer
  #set columns to look at (i.e. the names from the earlier created list)
  cols = names(l)
  #keep the rows without NA (use rowSums, because TRUE = 1, FALSE = 0 )
  #so if rowSums == 0, then columns in the vactor 'cols' do not contain a 'NA'
  final <- answer[ rowSums( is.na( answer[ , ..cols ] ) ) == 0, ]
  finalRes <- final[,-c(1,2)]
  commonMzs <- finalRes[!duplicated(finalRes),]
  commonMzs
}






#### For Lukas' poster


eulerr::venn(c("LC-MS" = 68,
               "MRMS-FIA" = 366,
               "MRMS-MALDI" = 327,
               "MALDI-TOF" = 9,
               "LC-MS&MRMS-FIA" = 6,
               "LC-MS&MRMS-MALDI" = 2,
               "MRMS-FIA&MRMS-MALDI" = 23, "MRMS-FIA&MALDI-TOF" = 1)) %>% plot





eulerr::venn(c("LC-MS" = 5218,  "MRMS-FIA" = 6682, "MRMS-MALDI" = 5246,"MALDI-TOF" = 982,
               "LC-MS&MALDI-TOF" = 110, "LC-MS&MRMS-FIA" = 1365, "LC-MS&MRMS-MALDI" = 1116, "MALDI-TOF&MRMS-FIA" = 268, 
               "MALDI-TOF&MRMS-MALDI" = 233, "MRMS-FIA&MRMS-MALDI" = 1148, "LC-MS&MALDI-TOF&MRMS-FIA&MRMS-MALDI" = 53, 
               "LC-MS&MALDI-TOF&MRMS-FIA" = 105, "LC-MS&MALDI-TOF&MRMS-MALDI" = 55, "MALDI-TOF&MRMS-FIA&MRMS-MALDI" = 294, "LC-MS&MRMS-FIA&MRMS-MALDI" = 924 )) %>% plot
