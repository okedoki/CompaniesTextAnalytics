

#default lib 
#library(rpart)
#trainDataPreprocessed <- apply(trainDataPreprocessed, 2, as.factor)
#decisionFit <- rpart(industryCodesTrain~.,
               #data = data.frame(cbind(trainDataPreprocessed, industryCodesTrain)),
               #method = "class")
#decisionPred <- predict(decisionFit, data.frame(testDataPreprocessed), type = "class")

#c50
library(C50)
decisionFit <- C5.0(x = trainDataPreprocessed, y = industryCodesTrain)
decisionPred <- predict(decisionFit, testDataPreprocessed, type = "class")

#Calculate confusionMatrix
#confusionMatrixSVM <- table(pred = svmPred, true = industryCodesTest)
#ClassificationError
#industryCodesTest <- factor(industryCodesTest, levels = levels(svmPred))
classificationErrorTrees <- 1 - sum(decisionPred == industryCodesTest) / length(decisionPred)