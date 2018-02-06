library(tm)
library(dplyr)
library("SnowballC")


performTmFunctions <- function(websiteText) {
    #Create a document for each website
    #websiteDoc <- Corpus(VectorSource(websiteText))
    myReader <- readTabular(mapping = list(content = "Text", id = "Id"))
    websiteDoc <- VCorpus(DataframeSource(websiteText), readerControl = list(reader = myReader))

    #Remove qqpbreakqq?
    skipWords <- function(x) removeWords(x, c(stopwords("english"), "qqpbreakqq"))
    #tmFuncs <- list(content_transformer(tolower), removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    tmFuncs <- list(removePunctuation, removeNumbers, stripWhitespace, skipWords, stemDocument)
    websiteDoc <- tm_map(websiteDoc, FUN = tm_reduce, tmFuns = tmFuncs)

    TermDocumentMatrix(websiteDoc)
    #Read for testing
    # websiteDoc[[1]][1]
}

#1.Read from file and preprocessing. 1 and 2 is inspired by https://www.springboard.com/blog/text-mining-in-r/

websitesFile <- 'websitesdata.txt';
websiteDataFrame <- read.table(websitesFile, sep = '\t', header = F, fill = TRUE, stringsAsFactors = FALSE);

#deleting of not usefull fields. 
websiteDataFrame <- websiteDataFrame[, c(2:4, 6)]
names(websiteDataFrame) <- c('Host', 'Webpage', 'Title', 'Text')

#Take only first page from  each website
websiteDataFrame <- websiteDataFrame %>% distinct(Host, .keep_all = TRUE) %>% mutate(Id = 50:57) %>% select(Id, Host, Text, Title)

#websitesText <- websiteDataFrame[, 'Text']
TDWebsitesData <- performTmFunctions(websiteDataFrame)
m <- as.matrix(TDWebsitesData)









#2. Term documents and word of cloud

#m <- as.matrix(dtmWebsiteDoc)
#v <- sort(rowSums(m), decreasing = TRUE)
#d <- data.frame(word = names(v), count = v)

#head(d,50)


# Generate the WordCloud

#Ggplotversion
#library(ggplot2)
#library(ggrepel)

#ggplot(data = d) +
#aes(x = 1, y = 1, size = count, label = word, col = count) +
#geom_text_repel(segment.size = 0, force = 100, segment.color = NA) +
#scale_size(range = c(1, 15), guide = FALSE) +
#scale_y_continuous(breaks = NULL) +
#scale_x_continuous(breaks = NULL) +
#labs(x = '', y = '') +
#theme_classic()

#Wordcloud 
#library(wordcloud)
#wordcloud(d$word, d$count, scale = c(5, 0.5), max.words = 200, random.order = FALSE, rot.per = 0.6, use.r.layout = FALSE, colors = brewer.pal(8, 'Dark2'));