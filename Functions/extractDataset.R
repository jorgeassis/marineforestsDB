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
 
  if( missing(group)) { group <- "all" }
  if( missing(pruned)) { pruned <- FALSE }
  
  if( group != "all" & group != "seagrasses" & group != "browAlgae" & group != "fanCorals") { stop("Group must be 'all' OR 'seagrasses' OR 'browAlgae' OR 'fanCorals'")}
  if( pruned != TRUE & pruned != FALSE ) { stop("Pruned must be 'TRUE' OR 'FALSE'")}
  
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
    
    if( group == "all" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/allPruned.zip?raw=true" }
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/seagrassesPruned.zip?raw=true" }
    if( group == "browAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/browAlgaePruned.zip?raw=true" }
    if( group == "fanCorals" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/fanCoralsPruned.zip?raw=true" }
  }
  if( ! pruned ) { 
    
    if( group == "all" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/all.zip?raw=true" }
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/seagrasses.zip?raw=true" }
    if( group == "browAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/browAlgae.zip?raw=true" }
    if( group == "fanCorals" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/fanCorals.zip?raw=true" }
    
  }
  
  download.file(file.to.download,destfile=paste0(tempdir(),"/MFTempFile.zip"))
  myData <- read_csv(paste0(tempdir(),"/MFTempFile.zip"))
  file.remove(paste0(tempdir(),"/MFTempFile.zip"))
  return(myData)
  
}
