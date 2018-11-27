# A fine-tuned global distribution dataset of marine forests

J. Assis, E. Fragkopoulou, D. Frade, J. Neiva, A. Oliveira, D. Abecasis, S. Faugeron, E.A. Serrão

### Abstract

Species distribution records are a prerequisite to follow climate-induced range shifts across space and time, yet, synthesizing information from various sources such as peer-reviewed literature, herbaria collections, digital repositories and citizen science initiatives is costly, time consuming, and challenging, as data are scattered, may comprise thematic and taxonomic errors and generally lack standardized formats to enable interoperability. To address this gap, we gathered ~1.1 million records of 718 important marine ecosystem structuring species of large brown algae and seagrasses. 

We provide a curated dataset, taxonomically standardized, dereplicated and treated according to the physiological and biogeographical traits of species. Specifically, a flagging system was developed to sign potentially biased records occurring on land, in regions with limiting light conditions and outside ecological niches and dispersal capacities. Experts were consulted to validate the accuracy of records, relatively to the known distributional range of species. 

We document the procedure and provide a ready to use dataset, alongside with a set of functions in R language for data management and visualization.
<br>

![alt text](https://github.com/jorgeassis/marineforestsDB/raw/master/Data/mainFigure.png "Main Figure")

Figure. Records of marine forest species (a) through time, (b) per taxonomic group (brown algae: orders Fucales, Laminariales and Tilopteridales; seagrasses: families Cymodoceaceae, Hydrocharitaceae, Posidoniaceae and Zosteraceae) and (c) original data source. Orange circles depict occurrence records from the Global distribution of seagrasses62 dataset (version 6.0), available at http://data.unep-wcmc.org/datasets/7 with copyright licensed by UNEP and managed by UNEP-WCMC.

<br>

### R functions for data management and visualization

We provide a set of functions in R language to facilitate extraction, listing and visualization of occurrence records. The functions can be easily installed by entering the following line into the command prompt:

source("https://raw.githubusercontent.com/jorgeassis/marineforestsDB/master/sourceMe.R")

<br>
<br>
List of functions available for management and visualization:
<br>
<br>

Function | Description | Arguments
------------ | ------------- | -------------
extractDataset() | Imports data to R environment | group (character), pruned (logical)
listTaxa() | Lists available taxa | --
listData() | Lists data available in a dynamic table | extractDataset object name  (character), taxa (character), status (character)
listDataMap() | Lists data available in a map | extractDataset object name  (character), taxa (character), status (character),radius (integer), color (character), zoom (integer)
subsetDataset() | Subsets available data to a specific taxon | extractDataset object name (character), taxa (character), status (character)
exportData() | Exports available data to a text delimited file or shapefile (geospatial vector data for geographic information systems) | extractDataset object name (character), taxa (character), status (character), file type (character), file name (character)

<br>

### Example of main functions use

1. listTaxa()
2. dataset <- extractDataset("seagrasses",pruned=TRUE)<br>
3. getTaxonomyWorms("Zostera marina")<br>
4. listData(dataset,taxa="Zostera (Zostera) marina",status="accepted")<br>
5. listDataMap(dataset,taxa="Zostera (Zostera) marina",status="accepted",radius=3,color="Black",zoom=4)<br>
6. exportData(dataset,taxa="Zostera (Zostera) marina",status="accepted",type="shp",file="myfile")

<br>

1. dataset <- extractDataset("brownAlgae",pruned=TRUE)<br>
2. getTaxonomyWorms("Laminaria digitata")<br>
3. listData(dataset)<br>
4. listDataMap(dataset,taxa="Laminaria digitata",status="accepted",radius=2,color="Black",zoom=2)<br>
5. exportData(dataset,taxa="Laminaria digitata",status="accepted",type="csv",file="myfile.csv")

<br>

1. dataset <- extractDataset("brownAlgae",pruned=TRUE)<br>
2. getTaxonomyWorms("Laminaria digitata")<br>
3. myDataFrame <- subsetDataset(dataset,taxa="Laminaria digitata",status="accepted")

<br>

### License and credits 

Except where otherwise noted, the content on this repository is licensed under a [Creative Commons Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/).

Giving appropriate credit:

Assis, J., Fragkopoulou, E., Frade, D., Neiva, J., Oliveira, A., Abecasis, D., Faugeron, A., Serrão, E.A. (2018) A fine-tuned global distribution dataset of marine forests.
