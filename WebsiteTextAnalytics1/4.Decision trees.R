library(rpart)

trainDataPreprocessed <- apply(trainDataPreprocessed, 2, as.factor)

decisionFit <- rpart(industryCodesTrain~.,
               data = data.frame(cbind(trainDataPreprocessed, industryCodesTrain)),
               method = "class")
decisionPred <- predict(decisionFit, data.frame(testDataPreprocessed), type = "class")


#Calculate confusionMatrix
#confusionMatrixSVM <- table(pred = svmPred, true = industryCodesTest)
#ClassificationError
#industryCodesTest <- factor(industryCodesTest, levels = levels(svmPred))
classificationErrorSVM <- 1 - sum(decisionPred == industryCodesTest) / length(decisionPred)