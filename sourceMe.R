
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
  
  if(zoom.define) {   setView(m,lng=mean(data[,"decimalLongitude"]),lat=mean(data[,"decimalLatitude"]),zoom=zoom )  }
  
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

# ------------------------------------------------

listTaxa <- function() {
  
  file.to.download <- "https://github.com/jorgeassis/marineforestsDB/blob/master/Data/listOfTaxa.csv"
  
  download.file(file.to.download,destfile="MFTempFile.zip")
  myData <- read.csv("MFTempFile.zip")
  file.remove("MFTempFile.zip")
  return(myData)
 
 }

# ------------------------------------------------
