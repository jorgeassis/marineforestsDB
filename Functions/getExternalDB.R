## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Get occurrence data from Ocean Biogeographic Information System and Global Biodiversity Information Facility
## https://github.com/jorgeassis
##
## Example:
## taxonName <- "Saccorhiza polyschides"
## getExternalDB(taxonName)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

getExternalDataObis(taxonName)
getExternalDataINaturalist(taxonName)
getExternalDataGbif(taxonName)


## ------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------

getExternalDataINaturalist <- function(taxa) {
  
  require(rinat)
  
  if( missing(taxa)) { errormessage("no taxa (Worms name) introduced.") }
  
    if( exists("my_occs_inatu") ) { rm(my_occs_inatu) }
    
    tryCatch( my_occs_inatu <- get_inat_obs(query=taxa) , error=function(e) { error <- TRUE })
    
    if( exists("my_occs_inatu") ) { if( nrow(my_occs_inatu) == 0 ) { my_occs_inatu <- data.frame() } }
    
    if( ! exists("my_occs_inatu") ) { my_occs_inatu <- data.frame() }
    
    if( nrow(my_occs_inatu) > 0) {
      
      my_occs_inatu <- subset(my_occs_inatu, my_occs_inatu$longitude !=0 & my_occs_inatu$latitude !=0)
      my_occs_inatu <- my_occs_inatu[my_occs_inatu$scientific_name == taxa,]
      
    }
    
    if( nrow(my_occs_inatu) > 0) {
      
      my_occs_inatu <- data.frame(my_occs_inatu,year=substr(my_occs_inatu$observed_on, 1, 4),month=substr(my_occs_inatu$observed_on, 6, 7),day=substr(my_occs_inatu$observed_on, 9, 10))
      
      df <- my_occs_inatu
      
    }
  
  return(df)
  
}

# ---------------------------------------------------------------------------------------------------------------

getExternalDataObis <- function(taxa) {
  
  if( missing(taxa)) { errormessage("no taxa (Worms name) introduced.") }
  
    require(robis)
  
    if( exists("my_occs_obis") ) { rm(my_occs_obis) }
    
    tryCatch( my_occs_obis <- occurrence(scientificname = taxa ) , error=function(e) { error <- TRUE })
    
    if( exists("my_occs_obis") ) { if( nrow(my_occs_obis) == 0 ) { my_occs_obis <- data.frame() } }
    
    if( ! exists("my_occs_obis") ) { my_occs_obis <- data.frame() }
    
    if( nrow(my_occs_obis) > 0) {
      
      my_occs_obis <- subset(my_occs_obis, my_occs_obis$decimalLongitude !=0 & my_occs_obis$decimalLatitude !=0)
      
    }
    
    if( nrow(my_occs_obis) > 0) {
      
      my_occs_obisInfo <- my_occs_obis$dataset_id
      my_occs_obisInfo <- unique(my_occs_obis$dataset_id)
      
      for(z in 1:length(my_occs_obisInfo) ) {
        
        error <- TRUE
        errortrials <- 0
        
        while(error & errortrials < 10) {
          error <- FALSE
          errortrials <- errortrials + 1
          tryCatch(  z.Res <- RJSONIO::fromJSON(paste0("https://api.obis.org/v3/dataset/",my_occs_obisInfo[z])) , error=function(e) { error <- TRUE })
        }
        
        if(!error) {  
          
          institutionCode <- my_occs_obis[my_occs_obis$dataset_id == my_occs_obisInfo[z],"institutionCode"]
          collectionCode <- my_occs_obis[my_occs_obis$dataset_id == my_occs_obisInfo[z],"collectionCode"]
          
          my_occs_obis[my_occs_obis$dataset_id == my_occs_obisInfo[z],"accessRights"] <- z.Res$results[[1]]$intellectualrights
          
          z.Res <- paste0( z.Res$results[[1]]$citation,
                           " ",
                           ifelse(!is.na(institutionCode) | !is.null(institutionCode) , institutionCode , ""),
                           " ",
                           ifelse(!is.na(collectionCode) | !is.null(collectionCode) , collectionCode , ""),
                           " (Available: Ocean Biogeographic Information System. Intergovernmental Oceanographic Commission of UNESCO. www.iobis.org. Accessed: ", Sys.time())
          
          my_occs_obis[my_occs_obis$dataset_id == my_occs_obisInfo[z],"bibliographicCitation"] <- z.Res
          
        }
        
      }
      
      df <- my_occs_obis
      
    }
    
  return(df)
  
}

# ---------------------------------------------------------------------------------------------------------------

getExternalDataGbif <- function(taxa) {
  
  if( missing(taxa)) { errormessage("no taxa (Worms name) introduced.") }
  
  if( exists("my_occs_gbif") ) { rm(my_occs_gbif) }
  
  nRecords <- gbif(strsplit(as.character(taxa), " ")[[1]][1], strsplit(as.character(taxa), " ")[[1]][2], geo=T, removeZeros=T , download=FALSE )
  
  if( nRecords > 300 ) {
    
    seqListing <- seq(0,nRecords,by =300)
    if(max(seqListing) < nRecords) { seqListing <- c(seqListing,nRecords) }
    parallelChunks <- data.frame(from = seqListing[-length(seqListing)], to = c(seqListing[-c(1,length(seqListing))] -1 , nRecords ) )
    
    Cluster <- makeCluster( 1 ) 
    registerDoParallel(Cluster)
    
    my_occs_gbif <- foreach(ch=1:nrow(parallelChunks), .verbose=FALSE, .packages=c("dismo","data.table","dplyr")) %dopar% { 
      
      tmpfile <- paste(tempfile(), ".json", sep = "")
      
      if(exists("test")) { rm(test) }
      
      error <- TRUE
      while(error) {
        
        tryCatch( test <- download.file(paste0("http://api.gbif.org/v1/occurrence/search?scientificname=",strsplit(as.character(taxa.i), " ")[[1]][1],"+",strsplit(as.character(taxa.i), " ")[[1]][2],"&offset=",parallelChunks[ch,1],"&limit=300"), tmpfile, quiet = TRUE) , error=function(e) { error <- TRUE })
        if(exists("test")) { error <- FALSE }
        
      }
      
      
      json <- scan(tmpfile, what = "character", quiet = TRUE, sep = "\n", encoding = "UTF-8")
      json <- chartr("\a\v", "  ", json)
      x <- jsonlite::fromJSON(json)
      r <- x$results
      r <- r[, !sapply(r, class) %in% c("data.frame", "list")]
      rownames(r) <- NULL
      
      return(r)
      
    }
    
    stopCluster(Cluster) ; rm(Cluster)
    
    if (length(my_occs_gbif) == 0) {
      my_occs_gbif <- data.frame()
    }
    if (length(my_occs_gbif) == 1) {
      my_occs_gbif <- my_occs_gbif[[1]]
    }
    if (length(my_occs_gbif) > 1) { my_occs_gbif <- do.call(bind, my_occs_gbif) }
    
  }
  
  if( nRecords <= 300 ) {
    
    tmpfile <- paste(tempfile(), ".json", sep = "")
    test <- try(download.file(paste0("http://api.gbif.org/v1/occurrence/search?scientificname=",strsplit(as.character(taxa.i), " ")[[1]][1],"+",strsplit(as.character(taxa.i), " ")[[1]][2],"&offset=",0,"&limit=300"), tmpfile, quiet = TRUE))
    
    json <- scan(tmpfile, what = "character", quiet = TRUE, sep = "\n", encoding = "UTF-8")
    json <- chartr("\a\v", "  ", json)
    x <- jsonlite::fromJSON(json)
    r <- x$results
    
    if( length(r) > 0) {
      
      r <- r[, !sapply(r, class) %in% c("data.frame", "list")]
      rownames(r) <- NULL
      my_occs_gbif <- r 
      
    }
    
  }
  
  if( exists("my_occs_gbif") ) { if( is.null(my_occs_gbif) ) { my_occs_gbif <- data.frame() } }
  
  if( ! exists("my_occs_gbif") ) { my_occs_gbif <- data.frame() }
  
  if( ! is.null(my_occs_gbif$decimalLatitude) & nrow(my_occs_gbif) > 0 ) {
    
    my_occs_gbif <- subset(my_occs_gbif, decimalLatitude !=0 & decimalLongitude !=0)
    
  }

  if( nrow(my_occs_gbif) > 0 ) {
    
    my_occs_gbif_all <- unique(my_occs_gbif$datasetKey)
    
    for(z in 1:length(my_occs_gbif_all) ) {
      
      z.Res <- gbif_citation(x=my_occs_gbif_all[z])
      
      my_occs_gbif[my_occs_gbif$datasetKey == my_occs_gbif_all[z] ,"accessRights"] <- ifelse(!is.null(z.Res$rights),z.Res$rights,"")
      
      z.Res <- z.Res$citation$citation
      
      my_occs_gbif[my_occs_gbif$datasetKey == my_occs_gbif_all[z],"bibliographicCitation"] <- z.Res
      
    }
    
    df <- my_occs_gbif
    
  }
  
  return(df)
  
}

# ---------------------------------------------------------------------------------------------------------------

