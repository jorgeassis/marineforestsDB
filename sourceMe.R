
extractDataset <- function(group,prunned) {
 
  if( missing(group)) { group <- "all") }
  if( missing(prunned)) { prunned <- FALSE }
  
  if( group != "all" & group != "seagrasses" & group != "browAlgae" & group != "fanCorals" & ) { stop("Group must be 'all' OR 'seagrasses' OR 'browAlgae' OR 'fanCorals'")}
  if( prunned != TRUE & prunned != FALSE ) { stop("Prunned must be 'TRUE' OR 'FALSE'")}
  
  options(warn=-1)
  
  packages.to.use <- c("readr","utils")
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  options(warn=0)
  
  if( prunned ) { 
    
    if( group == "all" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/allPrunned.zip?raw=true" }
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/seagrassesPrunned.zip?raw=true" }
    if( group == "browAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/browAlgaePrunned.zip?raw=true" }
    if( group == "fanCorals" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/fanCoralsPrunned.zip?raw=true" }
    
  }
  if( !prunned ) { 
    
    if( group == "all" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/all.zip?raw=true" }
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/seagrasses.zip?raw=true" }
    if( group == "browAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/browAlgae.zip?raw=true" }
    if( group == "fanCorals" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/fanCorals.zip?raw=true" }
    
  }
  
  download.file(file.to.download,destfile="MFTempFile.zip")
  myData <- read_csv("MFTempFile.zip")
  file.remove("MFTempFile.zip")
  return(myData)
  
}
