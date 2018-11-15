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
## occurrences <- data.frame(Lon=c(-1.616312,-4.571766,-5.792875,-4.487367,-1.610729,-1.613608,-1.613608,-1.613608,-1.613608,-1.265241,1.46231,1.46231),Lat=c(43.42488,53.21599,35.78211,48.37753,43.42285,49.64333,49.64333,49.64333,49.64333,49.66931,41.16866,41.16866))
## lightAndOxygenThreshold(occurrences)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

lightAndOxygenThreshold <- function(records) {

packages.to.use <- c("raster","sdmpredictors")

options(warn=-1)

for(package in packages.to.use) {
  if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
  if( package == "robis" & ! "robis" %in% rownames(installed.packages()) ) { devtools::install_github("iobis/robis") }
  if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
  library(package, character.only = TRUE)
}

raster.light <- load_layers("BO2_lightbotmin_bdmax")
raster.o2 <- calc(stack(load_layers(c("BO2_dissoxmin_bdmin","BO2_dissoxmean_bdmin","BO2_dissoxmax_bdmin",
                                      "BO2_dissoxmin_bdmean","BO2_dissoxmean_bdmean","BO2_dissoxmax_bdmean",
                                      "BO2_dissoxmin_bdmax","BO2_dissoxmean_bdmax","BO2_dissoxmax_bdmax"))),max)
rasters <- stack(raster.o2,raster.light) 
names(rasters) <- c("raster.o2","raster.light")
colnames(records) <- c("Lon","Lat")
coordinates(records) <- c("Lon","Lat")
results <- extract(rasters,records)
  
options(warn=0)
return(results)
  
}

