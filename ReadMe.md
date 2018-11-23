# A fine-tuned global distribution dataset of marine forests

J. Assis, E. Fragkopoulou, D. Frade, J. Neiva, A. Oliveira, D. Abecasis, S. Faugeron, E.A. Serrão

### Abstract

Species distribution records are a prerequisite to follow climate-induced range shifts across space and time, yet, synthesizing information from various sources such as peer-reviewed literature, herbaria collections, digital repositories and citizen science initiatives is costly, time consuming, and challenging, as data are scattered, may comprise thematic and taxonomic errors and lack standardized formats to enable interoperability. 

To address this gap, we gathered ~1,5 million records of 2166 important marine ecosystem structuring species of fan corals, large brown algae and seagrasses. We provide a curated dataset, taxonomically standardized, dereplicated and treated according to the physiological and biogeographical traits of species. Specifically, a flagging system was developed to sign potentially biased records occurring on land, in regions with limiting light or oxygen concentrations, and outside ecological niches and dispersal capacities. Experts were consulted to validate the accuracy of records, relatively to the known distributional range of species. 

We document the procedure and provide a ready to use dataset, alongside with a set of functions in R language for data management and visualization.

<br>

![alt text](https://github.com/jorgeassis/marineforestsDB/raw/master/Data/mainFigure.png "Main Figure")

Figure. (a) Spatial distribution of marine forest records, with red and gray circles depicting pruned and unpruned records, respectively. Pruned records of (b) fan corals (subclass Octocorallia), (c) brown algae (orders Fucales, Laminariales and Tilopteridales) and (d) seagrasses (families Cymodoceaceae, Hydrocharitaceae, Posidoniaceae and Zosteraceae).

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
exportData() | Exports available data to a text delimited file or shapefile (geospatial vector data for geographic information systems) | extractDataset object name (character), taxa (character), status (character), file type (character), file name (character)

<br>

### Example of main functions use

1. listTaxa()
2. dataset <- extractDataset("fanCorals",pruned=TRUE)<br>
3. listData(dataset,taxa="Paramuricea clavata",status="accepted")<br>
4. listDataMap(dataset,taxa="Paramuricea clavata",status="accepted",radius=3,color="Black",zoom=4)<br>
5. exportData(dataset,taxa="Paramuricea clavata",status="accepted",type="shp",file="myfile")

<br>

1. dataset <- extractDataset("fanCorals",pruned=TRUE)<br>
2. listData(dataset)<br>
3. listDataMap(dataset,radius=2,color="Black",zoom=2)<br>
4. exportData(dataset,type="csv",file="myfile.csv")

<br>

### License and credits 

Except where otherwise noted, the content on this repository is licensed under a [Creative Commons Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/).

Giving appropriate credit:

Assis, J., Fragkopoulou, E., Frade, D., Neiva, J., Oliveira, A., Abecasis, D., Faugeron, A., Serrão, E.A. (2018) A fine-tuned global distribution dataset of marine forests.
