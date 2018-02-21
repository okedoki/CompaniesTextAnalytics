trainDataPCAModel <- prcomp(trainMatrix, center = TRUE)
trainDataPCA <- trainDataPCAModel$x[, 1:12];
testDataPCA <- predict(trainDataPCAModel, testMatrix)[, 1:12]


trainDataPreprocessed <- trainDataPCA
testDataPreprocessed <- testDataPCA