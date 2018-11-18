
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Set of functions in R language to facilitate extraction, listing and visualization of occurrence records. 
## https://github.com/jorgeassis
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

# ------------------------------------------------

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

# ------------------------------------------------

listData <- function(data,taxa,status) {
  
  if( missing(taxa)) { taxa <- NULL }
  if( missing(status)) { status <- NULL }
  
  packages.to.use <- c("shiny")
  
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
      data <- data[ which(data$speciesName == taxa) ,] }
    
  }
  
  options(warn=0)
  
  shinyApp(
    ui = fluidPage(
      title = "Examples of DataTables",
      DT::dataTableOutput('tbl')),
    server = function(input, output) {
      output$tbl = DT::renderDataTable(
        data, options = list( pageLength = 10, lengthMenu = c(10, 50, 100, 1000)) ) # , filter = 'top'
    } )
  
}

# ------------------------------------------------

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

# ------------------------------------------------

listTaxa <- function() {

  options(warn=-1)
  
  packages.to.use <- c("shiny")
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/listOfTaxa.csv?raw=true"
  
  download.file(file.to.download,destfile=paste0(tempdir(),"/MFTempFileLTaxa.csv"))
  data <- read.table(file=paste0(tempdir(),"/MFTempFileLTaxa.csv"),header=TRUE,sep=";")
  file.remove(paste0(tempdir(),"/MFTempFileLTaxa.csv"))
  
  mydata <- as.matrix(data)
  
  packages.to.use <- c("shiny")
  
  options(warn=0)
  print(
  shinyApp(
    ui = fluidPage(
      title = "Examples of DataTables",
      DT::dataTableOutput('tbl')),
    server = function(input, output) {
      output$tbl = DT::renderDataTable(
        mydata, options = list( pageLength = 10, lengthMenu = c(10, 50, 100, 1000)) ) # , filter = 'top'
    } )
  )

}

# ------------------------------------------------
