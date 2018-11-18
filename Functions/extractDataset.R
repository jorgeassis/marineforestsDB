## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Imports available data to R environment
## https://github.com/jorgeassis
##
## Example:
## dataset <- extractDataset("fanCorals",TRUE)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

extractDataset <- function(group,pruned) {
  
  if( missing(group)) { stop("A group must be especifyed (e.g., fanCorals, browAlgae or seagrasses)") }
  if( missing(pruned)) { stop("Pruned argument must be especifyed (e.g., TRUE or FALSE )") }
  
  if( group != "seagrasses" & group != "browAlgae" & group != "fanCorals") { stop("A valid group must be especifyed (e.g., fanCorals, browAlgae or seagrasses)")}
  if( pruned != TRUE & pruned != FALSE ) { stop("Pruned argument must be TRUE or FALSE")}

  options(warn=-1)
  
  packages.to.use <- c("readr","utils")
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  options(warn=0)
  
  if( pruned ) { 
    
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataSeagrassesPruned.csv.zip?raw=true" }
    if( group == "browAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataBrownAlgaePruned.csv.zip?raw=true" }
    if( group == "fanCorals" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataFanCoralsPruned.csv.zip?raw=true" }
  }
  if( ! pruned ) { 
    
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataSeagrasses.csv.zip?raw=true" }
    if( group == "browAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataBrownAlgae.csv.zip?raw=true" }
    if( group == "fanCorals" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataFanCorals.csv.zip?raw=true" }
    
  }
  
  download.file(file.to.download,destfile=paste0(tempdir(),"/MFTempFile.zip"))
  myData <- read_csv(paste0(tempdir(),"/MFTempFile.zip"))
  file.remove(paste0(tempdir(),"/MFTempFile.zip"))
  return(myData)
  
}
