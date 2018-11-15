
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## List data available in a dynamic table
## https://github.com/jorgeassis
##
## Example:
## dataset <- extractDataset("fanCorals",TRUE)
## exportData(dataset,taxa="Paramuricea clavata",status="accepted",file="myfile.csv")
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------


exportData <- function(data,taxa,status,file) {
  
  if( missing(taxa)) { taxa <- NULL }
  if( missing(status)) { status <- NULL }
  if( missing(file)) { stop("A filename must be provided") }
  
  options(warn=-1)
  
  if( ! is.null(status) ) {  
    
    if( status == "accepted" ) { 
      
      if( length(which(dataset$acceptedSpeciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
      data <- data[ which(data$acceptedSpeciesName == taxa) ,] 
      }
    if( status != "accepted" ) { 
      
      if( length(which(dataset$speciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
      data <- data[ which(data$speciesName == taxa) ,] }
    
  }
  
  write.csv(data,file=file,sep = "\t", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)
  
}
