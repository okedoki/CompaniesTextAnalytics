naiveBayesFit <- naiveBayes(trainDataPreprocessed, industryCodesTrain, laplace = 1)
naiveBayesPred <- predict(naiveBayesFit, testDataPreprocessed)


#Calculate confusionMatrix
#confusionMatrixSVM <- table(pred = svmPred, true = industryCodesTest)
#ClassificationError
#industryCodesTest <- factor(industryCodesTest, levels = levels(svmPred))
classificationErrorSVM <- 1 - sum(naiveBayesPred == industryCodesTest) / length(naiveBayesPred)