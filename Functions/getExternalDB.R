## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Get occurrence data from Ocean Biogeographic Information System and Global Biodiversity Information Facility
## https://github.com/jorgeassis
##
## Example:
## taxonName <- "Saccorhiza polyschides"
## getExternalDB(taxonName)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

getExternalDB <- function(name) {

packages.to.use <- c("robis","dismo")

options(warn=-1)

for(package in packages.to.use) {
  if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
  if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
  if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
  library(package, character.only = TRUE)
}


temp.results <- data.frame()

tryCatch( my_occs <- occurrence(scientificname = name ) , error=function(e) { error <- TRUE })

if( exists("my_occs") ) { if( nrow(my_occs) == 0 ) { my_occs <- data.frame() } }

if( ! exists("my_occs") ) { my_occs <- data.frame() }

if( nrow(my_occs) > 0) {
  
  my_occs <- subset(my_occs, my_occs$decimalLongitude !=0 & my_occs$decimalLatitude !=0)
  
  if( ! is.null(my_occs$rightsHolder) ) {
    
    my_occs <- my_occs[ is.na(my_occs$rightsHolder) ,]
    
  }
  
  if( nrow(my_occs) > 0) {
    
    OriginalSource <- ""
    if( is.null(my_occs$occurrenceID)) { OriginalSourceID <- ""} else { OriginalSourceID <- my_occs$occurrenceID }
    if( is.null(my_occs$depth)) { depths <- NA} else { depths <- my_occs$depth }
    if( is.null(my_occs$minimumDepthInMeters)) { minimumDepthInMeters <- ""} else { minimumDepthInMeters <- my_occs$minimumDepthInMeters }
    if( is.null(my_occs$maximumDepthInMeters)) { maximumDepthInMeters <- ""} else { maximumDepthInMeters <- my_occs$maximumDepthInMeters }
    if( is.null(my_occs$coordinateUncertaintyInMeters)) { coordinateUncertaintyInMeters <- ""} else { coordinateUncertaintyInMeters <- my_occs$coordinateUncertaintyInMeters }
    if( is.null(my_occs$occurrenceRemarks)) { Notes <- ""} else { Notes <- my_occs$occurrenceRemarks }
    if( is.null(my_occs$locality)) { SiteName <- ""} else { SiteName <- my_occs$locality }
    if( is.null(my_occs$yearcollected)) { years <- ""} else { years <- my_occs$yearcollected }
    
    temp.results <- rbind(temp.results,
                          data.frame(Species= name,
                                     Lon=my_occs$decimalLongitude,
                                     Lat=my_occs$decimalLatitude,
                                     CoordinateUncertaintyInMeters=coordinateUncertaintyInMeters,
                                     SiteName=SiteName,
                                     Country=rep("",nrow(my_occs)),
                                     Depth=depths,
                                     DepthRangeMin=minimumDepthInMeters,
                                     DepthRangeMax=maximumDepthInMeters,
                                     DateYear=years,
                                     OriginalSource=OriginalSource,
                                     Notes=Notes,
                                     SourceRefType="Ocean Biogeographic Information System" ,
                                     stringsAsFactors=FALSE) )
    
  }
  
}

if( exists("my_occs") ) { rm(my_occs) }

tryCatch( my_occs <- gbif(strsplit(as.character(name), " ")[[1]][1], strsplit(as.character(name), " ")[[1]][2], geo=T, removeZeros=T ) , error=function(e) { error <- TRUE })

if( exists("my_occs") ) { if( is.null(my_occs) ) { my_occs <- data.frame() } }

if( ! exists("my_occs") ) { my_occs <- data.frame() }

if( ! is.null(my_occs$lat) & nrow(my_occs) > 0 ) {
  
  my_occs <- subset(my_occs, lat !=0 & lon !=0)
  
  if( !is.null(my_occs$accessRights) ) {
    
    my_occs <- my_occs[is.na(my_occs$accessRights) | my_occs$accessRights == "Free usage",]
    
  }
  
  if( nrow(my_occs) > 0 ) {
    
    if( is.null(my_occs$depth)) { depths <- NA} else { depths <- my_occs$depth }
    if( is.null(my_occs$year)) { years <- NA} else { years <- my_occs$year }
    if( is.null(my_occs$coordinateUncertaintyInMeters)) { coordinateUncertaintyInMeters <- ""} else { coordinateUncertaintyInMeters <- my_occs$coordinateUncertaintyInMeters }
    if( is.null(my_occs$gbifID)) { OriginalSource <- ""} else { OriginalSource <- paste0("https://www.gbif.org/occurrence/",my_occs$gbifID) }
    if( is.null(my_occs$gbifID)) { OriginalSourceID <- ""} else { OriginalSourceID <- my_occs$gbifID }
    if( is.null(my_occs$occurrenceRemarks)) { Notes <- ""} else { Notes <- my_occs$occurrenceRemarks }
    if( is.null(my_occs$locality)) { SiteName <- ""} else { SiteName <- my_occs$locality }
    if( is.null(my_occs$fullCountry)) { Country <- ""} else { Country <- my_occs$fullCountry }
    if( is.null(my_occs$year)) { years <- ""} else { years <- my_occs$year }
    
    temp.results <- rbind(temp.results,
                          data.frame(Species= name,
                                     Lon=my_occs$lon,
                                     Lat=my_occs$lat,
                                     CoordinateUncertaintyInMeters=coordinateUncertaintyInMeters,
                                     SiteName=SiteName,
                                     Country=Country,
                                     Depth= depths ,
                                     DepthRangeMin=rep(NA,nrow(my_occs)) ,
                                     DepthRangeMax=rep(NA,nrow(my_occs)) ,
                                     DateYear=years,
                                     OriginalSource=OriginalSource,
                                     Notes=Notes,
                                     SourceRefType="Global Biodiversity Information Facility" ,
                                     stringsAsFactors=FALSE))
    
  }
  
  
}

if( exists("my_occs") ) { rm(my_occs) }
  
options(warn=0)

return(temp.results)
  
}

