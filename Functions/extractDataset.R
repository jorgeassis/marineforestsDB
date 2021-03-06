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
  
  if( missing(group)) { stop("A group must be especifyed (e.g., brownAlgae or seagrasses)") }
  if( missing(pruned)) { stop("Pruned argument must be specifyed (e.g., TRUE or FALSE )") }
  
  if( group != "seagrasses" & group != "brownAlgae") { stop("A valid group must be especifyed (e.g., brownAlgae or seagrasses)")}
  if( pruned != TRUE & pruned != FALSE ) { stop("Pruned argument must be specifyed as TRUE or FALSE")}
  
  options(warn=-1)
  
  packages.to.use <- c("readr","utils","DT")
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  options(warn=0)
  
  if( pruned ) { 
    
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataSeagrassesPruned.RData.zip?raw=true" }
    if( group == "brownAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataBrownAlgaePruned.RData.zip?raw=true" }
    
    if( group == "seagrasses" ) {  file.name <- "dataSeagrassesPruned.RData" }
    if( group == "brownAlgae" ) {  file.name <- "dataBrownAlgaePruned.RData" }
    
    if( group == "seagrasses" ) {  file.name.obj <- "finalDataBaseSPruned" }
    if( group == "brownAlgae" ) {  file.name.obj <- "finalDataBaseBPruned" }
    
  }
  
  if( ! pruned ) { 
    
    if( group == "seagrasses" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataSeagrasses.RData.zip?raw=true" }
    if( group == "brownAlgae" ) {  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/dataBrownAlgae.RData.zip?raw=true" }
    
    if( group == "seagrasses" ) {  file.name <- "dataSeagrasses.RData" }
    if( group == "brownAlgae" ) {  file.name <- "dataBrownAlgae.RData" }
    
    if( group == "seagrasses" ) {  file.name.obj <- "finalDataBaseS" }
    if( group == "brownAlgae" ) {  file.name.obj <- "finalDataBaseB" }
    
  }
  
  download.file(file.to.download,destfile=paste0(tempdir(),"/MFTempFile.zip"))
  unzip(paste0(tempdir(),"/MFTempFile.zip"),exdir=tempdir(),overwrite=TRUE)
  
  load(paste0(tempdir(),"/",file.name))
  myData <- get(file.name.obj)
  
  file.remove(paste0(tempdir(),"/MFTempFile.zip"))
  file.remove(paste0(tempdir(),"/",file.name))
  return(myData)
  
}
