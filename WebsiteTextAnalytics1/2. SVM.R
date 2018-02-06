library(e1071)

head(m)
industryCodes <- c(1, 2, 1, 1, 2, 2, 2, 1)


svmFit <- svm(t(m), industryCodes, kernel = "linear")