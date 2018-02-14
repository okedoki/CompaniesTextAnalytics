library(class) # KNN model

knnPred <- knn(trainDataPreprocessed, testDataPreprocessed, industryCodesTrain)


#Calculate confusionMatrix
#confusionMatrixSVM <- table(pred = svmPred, true = industryCodesTest)
#ClassificationError
classificationErrorKnn <- 1 - sum(knnPred == industryCodesTest) / length(knnPred)