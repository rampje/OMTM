library(httr)
library(jsonlite)

# access news API to get headline articles
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

unlistThese <- c("articles.author","articles.title","articles.description",
                "articles.url","articles.urlToImage","articles.publishedAt")

for(x in 1:length(sources)){
  if(x == 16) {} else{
  allData[[x]] <- data.frame(sapply(allData[[x]], as.character),
                             stringsAsFactors = FALSE)
  }
}

# Reduce method not working. need to do manually
df1 <- allData[[1]]
df2 <- allData[[2]]
df3 <- allData[[3]]
df4 <- allData[[4]]
df5 <- allData[[5]]
df6 <- allData[[6]]
df7 <- allData[[7]]
df8 <- allData[[8]]
df9 <- allData[[9]]
df10 <- allData[[10]]
df11 <- allData[[11]]
df12 <- allData[[12]]
df13 <- allData[[13]]
df14 <- allData[[14]]
df15 <- allData[[15]]
df16 <- allData[[16]]
df17 <- allData[[17]]
allDataTable <- full_join(df1,df2)
allDataTable <- full_join(allDataTable,df3)
allDataTable <- full_join(allDataTable,df4)
allDataTable <- full_join(allDataTable,df5)
allDataTable <- full_join(allDataTable,df6)
allDataTable <- full_join(allDataTable,df7)
allDataTable <- full_join(allDataTable,df8)
allDataTable <- full_join(allDataTable,df9)
allDataTable <- full_join(allDataTable,df10)
allDataTable <- full_join(allDataTable,df11)
allDataTable <- full_join(allDataTable,df12)
allDataTable <- full_join(allDataTable,df13)
allDataTable <- full_join(allDataTable,df14)
allDataTable <- full_join(allDataTable,df15)
allDataTable <- full_join(allDataTable,df16)
allDataTable <- full_join(allDataTable,df17)

# 2017-03-05T20:52:49Z <- 3:52pm est