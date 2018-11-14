require(readr)
download.file("https://github.com/jorgeassis/marineforestsDB/blob/master/Data/SeagrassesPrunned.zip?raw=true",destfile="MFTempFile.zip")
myData <- read_csv("MFTempFile.zip")
file.remove("MFTempFile.zip")
