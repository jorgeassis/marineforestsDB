## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## List data available in a map
## https://github.com/jorgeassis
##
## Example:
## dataset <- extractDataset("fanCorals",TRUE)
## listDataMap(dataset,taxa="Paramuricea clavata",status="accepted",radius=2,color="Black",zoom=2)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

listDataMap <- function(data,taxa,status,radius,color,zoom) {
  
  zoom.define <- TRUE
  
  if( missing(radius)) { radius <- 2 }
  if( missing(color)) { color <- "black" }
  if( missing(zoom)) { zoom.define <- FALSE }
  if( missing(taxa)) { taxa <- NULL }
  if( missing(status)) { status <- NULL }
  
  packages.to.use <- c("shiny","leaflet")
  
  options(warn=-1)
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  if( ! is.null(status) ) {  
    
    if( status == "accepted" ) { 
      
      if( length(which(dataset$acceptedSpeciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
      
      data <- data[ which(data$acceptedSpeciesName == taxa) ,] 
      
      }
    if( status != "accepted" ) { 
      
      if( length(which(dataset$speciesName == taxa)) == 0 ) { stop("Taxa not found in dataset") }
  
      data <- data[ which(data$speciesName == taxa) ,] 
    
    }
    
  }
  
  species.name <- unlist(data$speciesName)
  species.status <- unlist(data$status)
  species.wormsid <- data$aphiaID
  
  temp.record.site <- data$locality
  temp.record.country <- data$country
  temp.record.year <- data$year
  temp.record.depth <- data$depth
  temp.record.reference <- data$originalSourceType
  temp.record.reference.id <- data$originalSource
  
  popup = paste0(
                 paste0("Species: <i>", species.name,"</i><br>"),
                 paste0("aphiaID: ", species.wormsid,"<br>"),
                 paste0("Status: ", species.status,"<br>"),
                 paste0("<hr noshade size='1'/>"),
                 ifelse( temp.record.site != "" & ! is.na(temp.record.site), paste0("Site: ", temp.record.site , " (",temp.record.country ,")","<br>"), as.character("") ),
                 ifelse( !is.na(temp.record.year), paste0("Year: ", temp.record.year , "<br>"), as.character("") ),
                 ifelse( !is.na(temp.record.depth), paste0("Depth: ", temp.record.depth , "<br>"), as.character("") ),
                 paste0(temp.record.reference , ": ",temp.record.reference.id ,"","<br>")
                 
  )
  
  epsg3006 <- leafletCRS(crsClass = "L.Proj.CRS", code = "EPSG:4326",
                         proj4def = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0",
                         resolutions = 2^(13:-1), # 8192 down to 0.5
                         origin = c(0, 0)
  )
  
  data <- as.matrix(data)
  
  if( zoom.define ) { m <- leaflet() %>% setView(lng=mean(as.numeric(data[,"decimalLongitude"])),lat=mean(as.numeric(data[,"decimalLatitude"])),zoom=zoom)  }
  if(! zoom.define ) { m <- leaflet()  }
  
  m <- addTiles(m)
  m <- addCircleMarkers(m, 
                        lng=as.numeric(data[,"decimalLongitude"]), 
                        lat=as.numeric(data[,"decimalLatitude"]), 
                        popup= popup , 
                        radius = radius, 
                        color = color , 
                        stroke = FALSE, 
                        fillOpacity = 0.5 )
    
  options(warn=0)
  
  return(m)
  
}
