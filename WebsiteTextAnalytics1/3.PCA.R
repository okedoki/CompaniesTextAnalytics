trainDataPCAModel <- prcomp(t(trainMatrix), center = TRUE)
trainDataPCA <- trainDataPCAModel$x[, 1:7];
testDataPCA <- predict(trainDataPCAModel, t(testMatrix))[,1:7]