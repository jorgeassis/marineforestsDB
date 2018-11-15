## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Extract Light and Oxygen thresholds
## https://github.com/jorgeassis
##
## Example:
## worldLandMass <- "path to OpenStreetMap shaplefile"
## worldcoastLine <- "path to OpenStreetMap shaplefile"
## occurrences <- data.frame(Lon=c(-1.616312,-4.571766,-5.792875,-4.487367,-1.610729,-1.613608,-1.613608,-1.613608,-1.613608,-1.265241,1.46231,1.46231),Lat=c(43.42488,53.21599,35.78211,48.37753,43.42285,49.64333,49.64333,49.64333,49.64333,49.66931,41.16866,41.16866))
## recordsOverLand(occurrences)
##
## worldLandMass and worldcoastLine files copyrighted of OpenStreetMap contributors and available from https://www.openstreetmap.org
## OpenStreetMap data is licensed under the Open Data Commons Open Database License (ODbL).
## 
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------


recordsOverLand <- function(records) {
      
    packages.to.use <- c("raster","rgeos","sp")
    
    options(warn=-1)
    
    for(package in packages.to.use) {
      if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
      if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
      if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
      library(package, character.only = TRUE)
    }
    
    world <- shapefile(worldLandMass)
    world <- rgeos::gBuffer(world, byid=TRUE, width=0)
    coast.line <- shapefile(worldcoastLine)
      
    data.points <- occurrences
    data.points.geo <- occurrences
    coordinates(data.points.geo) <- c("Lon","Lat")
    crs(data.points.geo) <- crs(world)
    
    land.t <- crop(world,extent(data.points.geo) + c(-1,+1,-1,+1))
    coast.line.t <- crop(coast.line,extent(data.points.geo) + c(-1,+1,-1,+1))
    coast.line.t <-  as.data.frame(as(coast.line.t, "SpatialPointsDataFrame"))
    
    over.land <- sp::over(data.points.geo, land.t)
    over.land <- as.vector(sapply(over.land[,1],function(x) { ifelse(is.na(x),1,-1)}))
    
    data.points.dist <- as.matrix(data.points,ncol=2)[,c("Lon","Lat")]
    coast.line.dist <- as.matrix(data.frame(Lon=coast.line.t[,5],Lat=coast.line.t[,6]))
    
    distances <- data.frame()
    
    for (d in 1:nrow(matrix(data.points.dist,ncol=2))) {
      
      if( over.land[d] != 1 ) {
        
        distance <- spDists(matrix(matrix(data.points.dist,ncol=2)[d,],ncol=2),coast.line.dist , longlat=TRUE)
        distances <- c(distances,apply(distance,1,min))
        
      } else {
        distances <- c(distances,0)        
      }
    }
    
    results <- data.frame(fid = 1:nrow(data.points),
                          OnLand = sapply(results$OnLand,function(x){ ifelse(x == -1, TRUE,FALSE)}),
                          Distance = as.vector(unlist(distances)),
                          stringsAsFactors = FALSE)
    results[results[,3] == 0,3] <- NA
    
    options(warn=0)
    return(results)
  
}


