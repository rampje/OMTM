library(httr)
library(jsonlite)
library(lubridate)

# access News API (https://newsapi.org/) to get headline articles
news.API.key <- "3ea7ac10835f464bafa4852873b21408"

sources <- c("associated-press","bbc-news","bloomberg","business-insider",
             "buzzfeed","cnbc","cnn","google-news","independent","reuters",
             "the-economist", "the-huffington-post","the-new-york-times",
             "the-wall-street-journal", "the-washington-post","time","usa-today")

requestLinks <- paste0("https://newsapi.org/v1/articles?source=", 
                      sources,"&apiKey=", news.API.key) 
# for sorting: "&sortBy=latest"
allData <- vector("list", length(sources))
for(x in 1:length(sources)){
    news.source <- GET(requestLinks[x])
    news.source <- content(news.source)
    news.source <- fromJSON(toJSON(news.source))
    allData[[x]] <- data.frame(news.source)
}

# 'time magazine' has diff data structure
allData[[16]]$articles.publishedAt <- NULL
allData[[16]]$articles.author <- NULL

for(x in 1:length(allData)){
  allData[[x]] <- data.frame(sapply(allData[[x]], as.character),
                             stringsAsFactors = FALSE)
}
# merge all
allData %>%
  Reduce( function(df1, df2) full_join(df1, df2), .) ->
allData

# not 100% vetted
allData$articles.publishedAt <- ymd_hms(allData$articles.publishedAt)

allData$TrumpFlag <- as.numeric(grepl("trump", tolower(allData$articles.title)))

write.csv(allData, "TrumpNewsCoverage.csv", row.names = FALSE)
# 2017-03-05T20:52:49Z <- 3:52pm est