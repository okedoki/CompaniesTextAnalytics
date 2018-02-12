library(e1071)
library(tm)
library(dplyr)

performTmFunctions <- function(websiteText, inputTdm) {
    #Create a document for each website
    #websiteDoc <- Corpus(VectorSource(websiteText))
    myReader <- readTabular(mapping = list(content = "Text"))
    websiteDoc <- VCorpus(DataframeSource(websiteText), readerControl = list(reader = myReader))

    #Remove qqpbreakqq?
    skipWords <- function(x) removeWords(x, c(stopwords("english"), "qqpbreakqq"))
    #tmFuncs <- list(content_transformer(tolower), removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    tmFuncs <- list(removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    websiteDoc <- tm_map(websiteDoc, FUN = tm_reduce, tmFuns = tmFuncs)

    if (missing(inputTdm)) {
        TermDocumentMatrix(websiteDoc, control = list(wordLengths = c(3, 7)))
    } else {
        TermDocumentMatrix(websiteDoc, control = list(dictionary = Terms(inputTdm), wordLengths = c(3, 7)))
    }

}

websitesFile <- 'Output\\MergedCompaniesData.txt';
classificationFullData <- read.table(websitesFile, sep = '\t', header = T, fill = T, stringsAsFactors = FALSE, quote = "");
#take out the trash
classificationFullData <-  classificationFullData[,1:6]
#classificationFullData <- mergedData
#dim(classificationFullData) 
trainData <- classificationFullData %>% sample_n(550, replace = FALSE)
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
