svmFit <- svm(trainDataPreprocessed, industryCodesTrain, kernel = "linear", type = "C")
svmPred <- predict(svmFit, testDataPreprocessed)


#Calculate confusionMatrix
#confusionMatrixSVM <- table(pred = svmPred, true = industryCodesTest)
#ClassificationError
classificationErrorSVM <- 1 - sum(svmPred == industryCodesTest) / length(svmPred)