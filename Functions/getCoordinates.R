## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Get coordinates in decimal degrees by address
## https://github.com/jorgeassis
##
## Example:
## addressName <- "Universidade do Algarve, Campus de Gambelas, 8005-139 Faro"
## getTaxonomyWorms(addressName)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

getCoordinates <- function(address) {
    
    packages.to.use <- c("RCurl","RJSONIO")
    
    options(warn=-1)
    
    for(package in packages.to.use) {
      if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
      if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
      library(package, character.only = TRUE)
    }
    
    construct.geocode.url <- function(address, return.call = "json", sensor = "false") {
      
      root <- "http://www.mapquestapi.com/geocoding/v1/"
      u <- paste(root, "address?key=mpIx2AWq4Lj9R0mDbW1hNWrPe1Jju4X9&location=", address, sep = "")
      return(URLencode(u))
    }
    
    u <- construct.geocode.url(address)
    doc <- getURL(u)
    x <- fromJSON(doc,simplify = FALSE)
    lat <- x$results[[1]]$locations[[1]]$latLng$lat
    lng <- x$results[[1]]$locations[[1]]$latLng$lng
    
    options(warn=0)
    
    return(c(lat, lng))

}
