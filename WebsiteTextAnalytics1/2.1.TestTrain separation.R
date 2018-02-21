library(e1071)

library(dplyr)
library(xlsx)


websitesFile <- 'Output\\MergedCompaniesData.xlsx';

#File
#classificationFullData <- read.table(websitesFile, sep = ',', header = T, stringsAsFactors = FALSE, quote = "");

#XLSX
classificationFullData <- read.xlsx2(websitesFile, sheetName = "Sheet1", col.names = TRUE, row.names = TRUE, append = FALSE)

#take out the trash
classificationFullData <-  classificationFullData[,1:6]
#classificationFullData <- mergedData
#dim(classificationFullData) 
trainData <- classificationFullData %>% filter(CompanyCode != "") %>% sample_n(1250, replace = FALSE)
testData <- anti_join(classificationFullData, trainData, by = "Host")

#Subselect trainData with factors that from testData
trainData <- trainData[trainData$CompanyCode %in% testData$CompanyCode,]
testData <- testData[testData$CompanyCode %in% trainData$CompanyCode,]
 