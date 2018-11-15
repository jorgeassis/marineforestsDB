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
## marineEcoregions <- "path to marine ecoregions shapefile"
## occurrences <- data.frame(Lon=c(-1.616312,-4.571766,-5.792875,-4.487367,-1.610729,-1.613608,-1.613608,-1.613608,-1.613608,-1.265241,1.46231,1.46231),Lat=c(43.42488,53.21599,35.78211,48.37753,43.42285,49.64333,49.64333,49.64333,49.64333,49.66931,41.16866,41.16866))
## ecologicalNicheAndEcoregions(occurrences,level=3)
##
## Spalding, M. D. et al. Marine Ecoregions of the World: A Bioregionalization of Coastal and Shelf Areas. Bioscience 57, 573–583 (2007).
## 
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

ecologicalNicheAndEcoregions <- function(records,level) {

    packages.to.use <- c("raster","rgeos","sp","rgdal","sdmpredictors")
    
    options(warn=-1)
    
    for(package in packages.to.use) {
      if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
      if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
      if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
      library(package, character.only = TRUE)
    }
    
    rasters.mahalanobis  <- load_layers(c("BO2_tempmin_ss","BO2_tempmax_ss","BO2_ppmin_ss","BO2_salinitymin_ss","BO2_phosphatemin_ss"))
    
    ecoregions <- shapefile(marineEcoregions)
    
      if( level == 1 ) {
        
        ecoregions.shp <- unionSpatialPolygons(ecoregions,ecoregions$RLM_CODE)
        eco.names <- names(ecoregions.shp)
        
      }
      if( level == 2 ) {
        
        ecoregions.shp <- unionSpatialPolygons(ecoregions,ecoregions$PROV_CODE)
        eco.names <- names(ecoregions.shp)
        
      }
      if( level == 3 ) {
        
        ecoregions.shp <- unionSpatialPolygons(ecoregions,ecoregions$ECO_CODE)
        eco.names <- names(ecoregions.shp)
        
      }
      
      data.points <- records
      
      df <- rasters.mahalanobis
      df <- extract(df,data.points)
      
      df[ df[,1] > mean(df[,1],na.rm=T),1] <- mean(df[,1],na.rm=T)
      df[ df[,2] < mean(df[,2],na.rm=T),2] <- mean(df[,2],na.rm=T)
      
      m_dist <- mahalanobis(df[, 1:ncol(df)], colMeans(df[, 1:ncol(df)],na.rm=T), cov(df[, 1:ncol(df)],use="pairwise.complete.obs"))
      
      if( TRUE %in% ( m_dist != "e" ) ) { 
        
        df <- cbind(df,round(m_dist, 2))
        df <- cbind(df, df[,ncol(df)] >= as.vector(quantile(m_dist, probs = c(0.95),na.rm=T)))
        
        # plot(df[,1:2],col=c("Red","Grey")[df[,ncol(df)]+1])
        
        climatic.outliers <- data.points[which(df[,ncol(df)] == 1),1]
        climatic.insiders <- data.points[which(df[,ncol(df)] == 0),1]
        
        coordinates(data.points) <- c("Lon","Lat")
        crs(data.points) <- crs(ecoregions.shp)
        
        results <- cbind(extract(ecoregions.shp,data.points),data.frame(data.points))
        
        na <- results[is.na(results$poly.ID),]$fid
        
        polys.outliers <- unique(results[results$fid %in% climatic.outliers,]$poly.ID)
        polys.insiders <- unique(results[results$fid %in% climatic.insiders,]$poly.ID)
        
        polys.outliers <- polys.outliers[!is.na(polys.outliers)]
        polys.insiders <- polys.insiders[!is.na(polys.insiders)]

        adjacent.pairs <- gTouches(ecoregions.shp, byid=TRUE)
        
        outliers <- numeric()
        insiders <- numeric()
        
        insiders <- results[ results$poly.ID %in% polys.insiders,]$fid
        
        for( poly in polys.outliers) {
          
          if( (length(results[results$poly.ID %in% poly,]$fid) < 10 ) & ! TRUE %in% ( c(eco.names[poly],names(which(adjacent.pairs[poly,]))) %in% eco.names[polys.insiders]) ) {  
            
            outliers <- c(outliers,results[results$poly.ID %in% poly,]$fid)
            
          }
        }
        
        outliers <- unique(outliers)
        insiders <- unique(insiders)
        
        outliers <- outliers[!outliers %in% na]
        insiders <- insiders[!insiders %in% na]
      } else { outliers <- NULL; insiders <- NULL ; na <- NULL  }
      
      return(list(unsuitable=outliers,ids.suitable=insiders,undetermined=na))

}


      
