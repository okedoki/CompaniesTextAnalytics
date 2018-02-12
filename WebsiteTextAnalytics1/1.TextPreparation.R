library(tm)
library(dplyr)
library("SnowballC")




#1.Read data file and preprocessing. 
websitesFile <- 'Input\\WebsitesData.txt';
websiteDataFrame <- read.table(websitesFile, sep = ',', header = F, fill = TRUE, stringsAsFactors = FALSE);

#deleting of not usefull fields. 
websiteDataFrame <- websiteDataFrame[, c(2:4, 6)]
names(websiteDataFrame) <- c('Host', 'Webpage', 'Title', 'Text')

#Take only first page from  each website
websiteDataFrame <- websiteDataFrame %>% distinct(Host, .keep_all = TRUE) %>% filter(!(Title == "null" | Title == "" | Text == "null" | Text == "")) %>% select(Host, Webpage, Text, Title)

#2.Read companies info and merge
companiesCodesFile <- 'Input\\CompaniesCodes.txt';
companiesCodeDataFrame <- read.table(companiesCodesFile, sep = '\t', header = F, fill = T, stringsAsFactors = FALSE, skipNul = TRUE, quote = "");
companiesCodeDataFrame <- companiesCodeDataFrame %>% select(V2, CompanyCode = V3, CompanyCodeDescription = V4) %>% filter(!(CompanyCode == "null" | CompanyCode == "" | CompanyCode == "null" | CompanyCode == "" | V2 == "null" | V2 == ""))
#write.table(companiesCodeDataFrame, "Output\\websiteDataCheck.txt", sep = ",", row.names = FALSE)

#3. Join companies data and webdata
mergedData <- websiteDataFrame %>% inner_join(companiesCodeDataFrame, by = c("Webpage" = "V2")) %>% filter(!(CompanyCode == "null" | CompanyCode == "" | CompanyCode == "null" | CompanyCode == "" | Webpage == "null" | Webpage == "")) %>% distinct(Webpage, .keep_all = TRUE)

#Write resulted dataframe to the disk for future processing
write.table(mergedData, "Output\\MergedCompaniesData.txt", sep = ",", row.names = FALSE)






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