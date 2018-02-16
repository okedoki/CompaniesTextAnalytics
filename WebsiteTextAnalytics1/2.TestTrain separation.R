library(e1071)
library(tm)
library(dplyr)

performTmFunctions <- function(websiteText, inputTdm) {
    #Create a document for each website
    #websiteDoc <- Corpus(VectorSource(websiteText))
    myReader <- readTabular(mapping = list(content = "Text"))
    websiteDoc <- VCorpus(DataframeSource(websiteText), readerControl = list(reader = myReader))

    #Temporary
    replaceIjToY <- content_transformer(function(x) gsub("ij", "y", x))

    #Remove qqpbreakqq?
    skipWords <- function(x) removeWords(x, c(stopwords("english"), "qqpbreakqq"))
    #tmFuncs <- list(content_transformer(tolower), removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    tmFuncs <- list(replaceIjToY,removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    websiteDoc <- tm_map(websiteDoc, FUN = tm_reduce, tmFuns = tmFuncs)

    if (missing(inputTdm)) {
        DocumentTermMatrix(websiteDoc, control = list(wordLengths = c(4, 9)))
    } else {
        DocumentTermMatrix(websiteDoc, control = list(dictionary = Terms(inputTdm), wordLengths = c(4, 9)))
    }

}

websitesFile <- 'Output\\MergedCompaniesData.xlsx';

#File
#classificationFullData <- read.table(websitesFile, sep = ',', header = T, stringsAsFactors = FALSE, quote = "");

#XLSX
classificationFullData <- read.xlsx2(websitesFile, sheetName = "Sheet1", col.names = TRUE, row.names = TRUE, append = FALSE)

#take out the trash
classificationFullData <-  classificationFullData[,1:6]
#classificationFullData <- mergedData
#dim(classificationFullData) 
trainData <- classificationFullData %>% filter(CompanyCode != "") %>% sample_n(550, replace = FALSE)
testData <- anti_join(classificationFullData, trainData, by = "Host")

#Subselect trainData with factors that from testData
trainData <- trainData[trainData$CompanyCode %in% testData$CompanyCode,]
testData <- testData[testData$CompanyCode %in% trainData$CompanyCode,]
 #Train
trainDataTDM <- performTmFunctions(trainData)
trainMatrix <- as.matrix(trainDataTDM)
industryCodesTrain <- as.factor(trainData$CompanyCode)

#Test
#testData <- trainData

testDataTDM <- performTmFunctions(testData, trainDataTDM)
testMatrix <- as.matrix(testDataTDM)
industryCodesTest <- as.factor(testData$CompanyCode)
#test_m = factor(t(test_m), levels = c(t(train_m)))


trainDataPreprocessed <- trainMatrix
testDataPreprocessed <- testMatrix

#word of cloud and statistics
#fullMatrix <- rbind(trainMatrix, testMatrix)
#fullMatrixIndexies <- colSums(fullMatrix) / nrow(fullMatrix)
#fullMatrix <- fullMatrix[, fullMatrixIndexies > 0.05]
#dim(fullMatrix)

#library(wordcloud)
#wordcloud(colnames(fullMatrix), colSums(fullMatrix), scale = c(5, 0.5), max.words = 200, random.order = FALSE, rot.per = 0.6, use.r.layout = FALSE, colors = brewer.pal(8, 'Dark2'));