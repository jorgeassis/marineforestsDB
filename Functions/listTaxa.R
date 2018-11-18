


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
