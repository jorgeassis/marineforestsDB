## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## List data available in a dynamic table
## https://github.com/jorgeassis
##
## Example 1:
## pathToFile <- "/Volumes/Bathyscaphe/Biodiversity database/Data/Export/BrownAlgaePrunned.csv"
## taxonName <- "Saccorhiza polyschides"
## taxonStatus <- "accepted" # Options: [1] unaccepted [2] accepted [3] alternate representation
## listData(pathToFile,taxonName,taxonStatus)
##
## Example 2:
## pathToFile <- "/Volumes/Bathyscaphe/Biodiversity database/Data/Export/BrownAlgaePrunned.csv"
## listData(pathToFile)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------


listData <- function(path,taxa,status) {

  if( missing(taxa)) { taxa <- NULL }
  if( missing(status)) { status <- NULL }
  
packages.to.use <- c("shiny","readr")

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
