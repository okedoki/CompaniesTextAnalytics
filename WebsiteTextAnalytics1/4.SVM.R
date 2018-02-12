svmFit <- svm(trainDataPCA, industryCodesTrain, kernel = "linear", type = "C")
svmPred <- predict(svmFit, testDataPCA)


#Calculate confusionMatrix
#confusionMatrixSVM <- table(pred = svmPred, true = industryCodesTest)
#ClassificationError
industryCodesTest <- factor(industryCodesTest, levels = levels(svmPred))
classificationErrorSVM <- 1 - sum(svmPred == industryCodesTest) / length(svmPred)