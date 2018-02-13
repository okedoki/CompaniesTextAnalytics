trainDataPCAModel <- prcomp(trainMatrix, center = TRUE)
trainDataPCA <- trainDataPCAModel$x[, 1:7];
testDataPCA <- predict(trainDataPCAModel, testMatrix)[, 1:7]


trainDataPreprocessed <- trainDataPCA
testDataPreprocessed <- testDataPCA