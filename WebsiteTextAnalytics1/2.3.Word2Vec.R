
# See tutorial: https://github.com/bmschmidt/wordVectors/blob/master/vignettes/introduction.Rmd
if (!require(wordVectors)) {
    if (!(require(devtools))) {
        install.packages("devtools")
    }
    devtools::install_github("bmschmidt/wordVectors")
}
library(wordVectors)

#
# Helper function to train a word2vec model from file.txt or load an existing one from file.bin.
#
word2vec <- function(fileName) {
    if (grepl('.txt', fileName, fixed = T)) {
        # Convert test.txt to test.bin.
        binaryFileName <- gsub('.txt', '.bin', fileName, fixed = T)
    }
    else {
        binaryFileName <- paste0(fileName, '.bin')
    }


    # Train word2vec model.
    if (!file.exists(binaryFileName)) {
        # Lowercase and setup ngrams.
        prepFileName <- 'temp.prep'
        prep_word2vec(origin = fileName, destination = prepFileName, lowercase = T, bundle_ngrams = 2)

        # Train word2vec model.
        model <- train_word2vec(prepFileName, binaryFileName, vectors = 200, threads = 4, window = 12, iter = 5, negative_samples = 0)

        # Cleanup.
        unlink(prepFileName)
    } else {
        model <- read.vectors(binaryFileName)
    }

    model
}


# Read text file.
doc <- readChar('article.txt', file.info('article.txt')$size)

# Remove stop-words.
stopwords_regex <- paste(stopwords('en'), collapse = '\\b|\\b')
stopwords_regex <- paste0('\\b', stopwords_regex, '\\b')
doc <- stringr::str_replace_all(doc, stopwords_regex, '')

# Write text file with stop-words removed.
cat(doc, file = "article2.txt", sep = "\n", append = TRUE)

# Train word2vec model and explore.
model <- word2vec('article2.txt')
model %>% closest_to("president")

# Cleanup.
unlink('article2.txt')

###
### Example 2: Large document.
###

# Train word2vec model and explore.
model <- word2vec('text8')
model %>% closest_to("communism")

# Plot similar terms to 'computer' and 'internet'.
computers <- model[[c("computer", "internet"), average = F]]

# model[1:3000,] here restricts to the 3000 most common words in the set.
computer_and_internet <- model[1:3000,] %>% cosineSimilarity(computers)

# Filter to the top 20 terms.
computer_and_internet <- computer_and_internet[
  rank(-computer_and_internet[, 1]) < 20 |
    rank(-computer_and_internet[, 2]) < 20,
  ]

plot(computer_and_internet, type = 'n')
text(computer_and_internet, labels = rownames(computer_and_internet))