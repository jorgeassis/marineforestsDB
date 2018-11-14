# marineforestsDB
**A fine-tuned global distribution dataset of marine forest species**
<br>
J. Assis, E. Fragkopoulou, Frade, D., Neiva, J., A. Oliveira, D. Abecasis, E.A. Serrão
<br>
<br>
**Abstract**
<br>
Species distribution records are a prerequisite to follow climate-induced range shifts across space and time, yet, data collection can be costly and time consuming. Synthesizing information from various sources, such as peer-reviewed literature, herbaria, repositories and citizen science is challenging, as data are scattered, may comprise thematic and taxonomic errors and there are no standardized formats to enable interoperability. 
<br>
<br>
To address this gap, we gathered ~1,5 million records of 2166 important marine ecosystem structuring species of fan corals, large brown algae and seagrasses. We provide a curated dataset, taxonomically standardized, dereplicated and treated according to the physiological and biogeographical trait of species. Specifically, a flagging system was developed to sign potentially biased records occurring on land, in regions with limiting light or oxygen, or outside ecological niches and dispersal capacities. Experts were further consulted to validate the accuracy of records, relatively to the known distributional range of species. 
<br>
<br>
Here we provide a set of functions in R language to to facilitate extraction, listing, visualization and management of occurrence records. The functions are detailed in Table 3 and can be easily installed by entering the following line into the command prompt:

1. source("https://raw.githubusercontent.com/jorgeassis/marineforestsDB/master/sourceMe.R")



require(readr)
download.file("https://github.com/jorgeassis/marineforestsDB/blob/master/Data/SeagrassesPrunned.zip?raw=true",destfile="MFTempFile.zip")
myData <- read_csv("MFTempFile.zip")
file.remove("MFTempFile.zip")

