### Read the start time of the LC-MS run from the raw data files

getRunOrder <- function(mzml.files){
  lapply(mzml.files, function(x){
    paste0(basename(x), 
           " --> ", 
           runInfo(openMSfile(x))$startTimeStamp %>% 
             sub(pattern = "T", replacement = " ") %>% 
             sub(pattern = "Z", replacement = "") %>% 
             as.character.Date())
  }
  ) %>% unlist %>% stringr::str_split_fixed(., " --> ", 2)
}