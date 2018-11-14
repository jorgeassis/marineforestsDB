## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------
##
## A fine-tuned global distribution dataset of marine forest species
## J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
##
## Get taxonomy using WORMS
## https://github.com/jorgeassis
##
## Example:
## taxonName <- "Saccorhiza polyschides"
## getTaxonomyWorms(taxonName)
##
## -----------------------------------------------------------------------------------------------
## -----------------------------------------------------------------------------------------------

getTaxonomyWorms <- function(name) {

  packages.to.use <- "worms"
  
  options(warn=-1)
  
  for(package in packages.to.use) {
    if( ! package %in% rownames(installed.packages()) ) { install.packages( package ) }
    if( ! package %in% rownames(installed.packages()) ) { stop("Error on package instalation") }
    library(package, character.only = TRUE)
  }
  
  tryCatch( worms.query <- wormsbynames( name , verbose = FALSE )
            , error=function(e) { } )
  
  options(warn=0)
  
  if( exists("worms.query") ) { 

        cat('\n')
        cat('\n')
        cat('----------------------------------------------------------------------')
        cat('\n')
        cat('Processing taxonomy for', name )
        cat('\n')
        cat('\n')
        cat('\n')

        return(data.frame(
          aphiaID = worms.query$AphiaID,
          name = worms.query$scientificname,
          authority = worms.query$authority,
          status = worms.query$status,
          taxKingdom = worms.query$kingdom,
          taxPhylum = worms.query$phylum,
          taxClass = worms.query$class,
          taxOrder = worms.query$order,
          taxFamily = worms.query$family,
          taxGenus = worms.query$genus,
          revisionByWormsDate = Sys.Date(),
          acceptedAphiaID = worms.query$valid_AphiaID,
          acceptedName = worms.query$valid_name
        ))
      
  } else {         
    
    cat('\n')
    cat('\n')
    cat('----------------------------------------------------------------------')
    cat('\n')
    cat('Taxonomy for',name,'not found')
    cat('\n')
    cat('\n')
    cat('\n')
    
    }
}
