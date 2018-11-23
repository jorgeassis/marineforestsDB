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
## subsetDataset(dataset,taxa="Paramuricea clavata",status="accepted")
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

subsetDataset <- function(data,taxa,status) {
  
  if( missing(data)) { stop("A dataset must be provided. Use extractDataset() function") }
  if( missing(taxa)) { stop("A taxa name must be provided") }
  if( missing(status)) { status <- "accepted" }
  
  if( status == "accepted" ) { 
    
    if( length(which(dataset$acceptedSpeciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
    data <- data[ which(data$acceptedSpeciesName == taxa) ,] 
  }
  if( status != "accepted" ) { 
    
    if( length(which(dataset$speciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
    data <- data[ which(data$speciesName == taxa) ,] 
    
  }
  
  return(data)
  
}
