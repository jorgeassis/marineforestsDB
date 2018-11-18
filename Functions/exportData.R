
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Exports available data to a text delimited file
## https://github.com/jorgeassis
##
## Example:
## dataset <- extractDataset("fanCorals",TRUE)
## exportData(dataset,taxa="Paramuricea clavata",status="accepted",type="shp",file="myfile")
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------


exportData <- function(data,taxa,status,type,file) {
  
  packages.to.use <- c("sp","raster","rgdal")
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  if( missing(taxa)) { taxa <- NULL }
  if( missing(status)) { status <- NULL }
  if( missing(file)) { stop("A filename must be provided") }
  if( missing(type)) { type <- "csv" }
  
  if( !is.null(status) & status != "accepted" & status != "unaccepted" ) { stop("Status must be accepted or unaccepted")  }
  if( type != "csv" & type != "shp" ) { stop("Status must be csv or shp")  }
  
  if( ! is.null(status) ) {  
    
    if( status == "accepted" ) { 
      
      if( length(which(dataset$acceptedSpeciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
      data <- data[ which(data$acceptedSpeciesName == taxa) ,] 
    }
    if( status != "accepted" ) { 
      
      if( length(which(dataset$speciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
      data <- data[ which(data$speciesName == taxa) ,] }
    
  }
  
  if(type == "csv") {
    write.table(data,file=file, na = "NA", dec = ".", row.names = FALSE, col.names = TRUE)
    
  }
  if(type == "shp") {
    
    main.results.sp <- SpatialPointsDataFrame(data.frame(Lon=as.numeric(as.character(data$decimalLongitude)),Lat=as.numeric(as.character(data$decimalLatitude))),data)   
    crs(main.results.sp) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
    writeOGR(main.results.sp, ".", file, driver="ESRI Shapefile",overwrite_layer=TRUE)
    
  }
}
