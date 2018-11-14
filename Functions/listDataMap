## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## List data available in a map
## https://github.com/jorgeassis
##
## Example 1:
## pathToFile <- "/Volumes/Bathyscaphe/Biodiversity database/Data/Export/BrownAlgaePrunned.csv"
## taxonName <- "Saccorhiza polyschides"
## taxonStatus <- "accepted" # Options: [1] unaccepted [2] accepted [3] alternate representation
## listDataMap(pathToFile,taxonName,taxonStatus)
##
## Example 2:
## pathToFile <- "/Volumes/Bathyscaphe/Biodiversity database/Data/Export/BrownAlgaePrunned.csv"
## listDataMap(pathToFile,radius=2,color="red",zoom=10)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

listDataMap <- function(path,taxa,status,radius,color,zoom) {

zoom.define <- TRUE

if( missing(radius)) { radius <- 2 }
if( missing(color)) { color <- "black" }
if( missing(zoom)) { zoom.define <- FALSE }
if( missing(taxa)) { taxa <- NULL }
if( missing(status)) { status <- NULL }

packages.to.use <- c("shiny","readr","leaflet")

options(warn=-1)

for(package in packages.to.use) {
  if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
  if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
  if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
  library(package, character.only = TRUE)
}

data <- read_csv(path)

if( ! is.null(status) ) {  
  
  if( status == "accepted" ) { data <- data[ which(data$acceptedSpeciesName == taxa) ,] }
  if( status != "accepted" ) { data <- data[ which(data$speciesName == taxa) ,] }
  
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

popup = paste0(paste0("<hr noshade size='1'/>"),
               paste0("Species: <i>", species.name,"</i><br>"),
               paste0("aphiaID: ", species.wormsid,"<br>"),
               paste0("Status: ", species.status,"<br>"),
               ifelse( temp.record.site != "", paste0("Site: ", temp.record.site , " (",temp.record.country ,")","<br>"), "" ),
               ifelse( !is.na(temp.record.year), paste0("Year: ", temp.record.year , "<br>"), "" ),
               ifelse( !is.na(temp.record.depth), paste0("Depth: ", temp.record.depth , "<br>"), "" ),
               paste0(temp.record.reference , " ID: ",temp.record.reference.id ,"","<br>")
               
)

set.seed(42)

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

if(zoom.define) {   setView(m,lng=mean(data[,"decimalLongitude"]),lat=mean(data[,"decimalLatitude"]),zoom=zoom )  }

options(warn=0)

return(m)
  
}

