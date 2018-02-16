library(tm)
library(dplyr)
library("SnowballC")
library(xlsx)

readTableSkipInvalidRows <- function(filePath, correct_length, numFileLines) {
    #datafr
    i <- 0;
    library(plyr)
    file_con = file(filePath, "r")

    readingFunction <- function(k) {
        tryCatch({
        oneLine <- readLines(file_con, n = 1);
        line <- (strsplit(oneLine, ","))[[1]]
        if (length(line) == correct_length) {
            return(line)
        } else {
            cat(sprintf("Skipped line %s\n", line))
        }
        }, error = function(e) { sprintf("error") })
    }

    datafr <- ldply(1:numFileLines, readingFunction)
 
    close(file_con)

    datafr


}

#1.Read data file and preprocessing. 
websitesFile <- 'Input\\WebsitesData.txt';
#websiteDataFrame <- read.table(websitesFile, sep = ',', header = F, stringsAsFactors = FALSE, nrows = 3);
websiteDataFrame <- readTableSkipInvalidRows(websitesFile, 12, 313133)
#deleting of not usefull fields. 
websiteDataFrame <- websiteDataFrame[, c(2:4, 6)]
names(websiteDataFrame) <- c('Host', 'Webpage', 'Title', 'Text')
#write.table(head(websiteDataFrame,10000), "Output\\websiteDataFrame.txt", sep = ",", row.names = FALSE, quote = TRUE)
#Take only first page from  each website
websiteDataFrame <- websiteDataFrame %>% distinct(Host, .keep_all = TRUE) %>% filter(!(Host == "null" | Host == "" | Title == "null" | Title == "" | Text == "null" | Text == "")) %>% select(Host, Webpage, Text, Title)
#write.table(head(websiteDataFrame,100), "Output\\websiteDataFrame2.txt", sep = ",", row.names = FALSE, quote = TRUE)

#2.Read companies info and merge
companiesCodesFile <- 'Input\\CompaniesCodes.txt';
companiesCodeDataFrame <- read.table(companiesCodesFile, sep = '\t', header = F, fill = T, stringsAsFactors = FALSE, skipNul = TRUE, quote = "");
companiesCodeDataFrame <- companiesCodeDataFrame %>% select(V2, CompanyCode = V3, CompanyCodeDescription = V4) %>% filter(!(CompanyCode == "null" | CompanyCode == "" | CompanyCode == "null" | CompanyCode == "" | V2 == "null" | V2 == ""))
#write.table(companiesCodeDataFrame, "Output\\websiteDataCheck.txt", sep = ",", row.names = FALSE)

#3. Join companies data and webdata
mergedData <- websiteDataFrame %>% inner_join(companiesCodeDataFrame, by = c("Webpage" = "V2")) %>% filter(!(tolower(CompanyCode) == "null" | CompanyCode == "" | tolower(CompanyCodeDescription) == "null" | CompanyCodeDescription == "" | tolower(Webpage) == "null" | Webpage == "")) %>% distinct(Webpage, .keep_all = TRUE)

#Write resulted dataframe to the disk for future processing
#write.csv(mergedData, "Output\\MergedCompaniesData.txt", sep = ",", row.names = FALSE, quote = T)

#Use excel
write.xlsx(mergedData, "Output\\MergedCompaniesData.xlsx", sheetName = "Sheet1", col.names = TRUE, row.names = TRUE, append = FALSE)