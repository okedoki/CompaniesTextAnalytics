library(tm)
performTmFunctions <- function(websiteText, inputTdm) {
    #Create a document for each website
    #websiteDoc <- Corpus(VectorSource(websiteText))
    myReader <- readTabular(mapping = list(content = "Text"))
    websiteDoc <- VCorpus(DataframeSource(websiteText), readerControl = list(reader = myReader))

    #Temporary
    replaceIjToY <- content_transformer(function(x) gsub("ij", "y", x))
    websiteDoc <- tm_map(websiteDoc, replaceIjToY)
    #Remove qqpbreakqq?
    skipWords <- function(x) removeWords(x, c(stopwords("english"), "qqpbreakqq"))
    #tmFuncs <- list(content_transformer(tolower), removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    tmFuncs <- list(removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    websiteDoc <- tm_map(websiteDoc, FUN = tm_reduce, tmFuns = tmFuncs)

    #if (missing(inputTdm)) {
    #DocumentTermMatrix(websiteDoc, control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE), wordLengths = c(4, 9)))
    #} else {
    #DocumentTermMatrix(websiteDoc, c = list(dictionary = Terms(inputTdm), weighting = function(x) weightTfIdf(x, normalize = FALSE),  wordLengths = c(4, 9)))
    #}


    if (missing(inputTdm)) {
        DocumentTermMatrix(websiteDoc, control = list(wordLengths = c(4, 9)))
    } else {
        DocumentTermMatrix(websiteDoc, c = list(dictionary = Terms(inputTdm), wordLengths = c(4, 9)))
    }
}

#Train
trainDataTDM <- performTmFunctions(trainData)
#trainDataTDM <- removeSparseTerms(trainDataTDM, 0.8)

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