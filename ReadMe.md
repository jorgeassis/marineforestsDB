# A fine-tuned global distribution dataset of marine forests

J. Assis, E. Fragkopoulou, D. Frade, J. Neiva, A. Oliveira, D. Abecasis, S. Faugeron, E.A. Serrão

### Abstract

Species distribution records are a prerequisite to follow climate-induced range shifts across space and time. However, synthesizing information from various sources such as peer-reviewed literature, herbaria, digital repositories and citizen science initiatives is not only costly and time consuming, but also challenging, as data may contain thematic and taxonomic errors and generally lack standardized formats. We address this gap for important marine ecosystem-structuring species of large brown algae and seagrasses. 

We gathered distribution records from various sources and provide a fine-tuned dataset with ~2.8 million dereplicated records, taxonomically standardized for 682 species, and considering important physiological and biogeographical traits. Specifically, a flagging system was implemented to sign potentially incorrect records reported on land, in regions with limiting light conditions for photosynthesis, and outside the known distribution of species, as inferred from the most recent published literature. 

We document the procedure and provide a dataset in tabular format based on Darwin Core Standard (DwC), alongside with a set of functions in R language for data management and visualization.

<br>
![alt text](https://github.com/jorgeassis/marineforestsDB/raw/master/Data/mainFigure1.png "Main Figure")
Figure 1. Dataset of marine forest species of brown algae (orders Fucales, Laminariales and Tilopteridales). Red and gray circles depict raw and fine-tuned (unbiased) data, respectively.

![alt text](https://github.com/jorgeassis/marineforestsDB/raw/master/Data/mainFigure2.png "Main Figure")
Figure 2. Dataset of marine forest species of seagrasses (families Cymodoceaceae, Hydrocharitaceae, Posidoniaceae and Zosteraceae). Red and gray circles depict raw and fine-tuned (unbiased) data, respectively.

<br>

### R functions for data management and visualization

We provide a set of functions in R language to facilitate extraction, listing and visualization of occurrence records. The functions can be easily installed by entering the following line into the command prompt:

source("https://raw.githubusercontent.com/jorgeassis/marineforestsDB/master/sourceMe.R")

<br>
Table. List of functions available for management and visualization.
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

1. dataset <- extractDataset("brownAlgae",pruned=TRUE)<br>
2. getTaxonomyWorms("Laminaria digitata")<br>
3. listData(dataset,taxa="Laminaria digitata",status="accepted")<br>
4. listDataMap(dataset,taxa="Laminaria digitata",status="accepted",radius=2,color="Black",zoom=2)<br>
5. exportData(dataset,taxa="Laminaria digitata",status="accepted",type="csv",file="myfile.csv")

<br>

1. listTaxa()
2. dataset <- extractDataset("seagrasses",pruned=TRUE)<br>
3. getTaxonomyWorms("Zostera marina")<br>
4. listData(dataset,taxa="Zostera marina",status="unaccepted")<br>
5. listDataMap(dataset,taxa="Zostera marina",status="unaccepted",radius=3,color="Black",zoom=2)<br>
6. exportData(dataset,taxa="Zostera marina",status="unaccepted",type="shp",file="myfile")

<br>

1. dataset <- extractDataset("brownAlgae",pruned=TRUE)<br>
2. getTaxonomyWorms("Laminaria digitata")<br>
3. myDataFrame <- subsetDataset(dataset,taxa="Laminaria digitata",status="accepted")

<br>

### License

The content on this repository is licensed under a [Creative Commons Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/).

<br>

### Appropriate credits

Assis, J., Fragkopoulou, E., Frade, D., Neiva, J., Oliveira, A., Abecasis, D., Faugeron, A., Serrão, E.A. (2019) A fine-tuned global distribution dataset of marine forests.
