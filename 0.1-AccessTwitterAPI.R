library(twitteR)
library(ROAuth)
library(httr)
library(lubridate)
library(dplyr)
source("creds.R")
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
cleanFun <- function(htmlString) gsub("<.*?>", "", htmlString)
FetchTweets <- function(twitterName){
  getTweets <- userTimeline(twitterName, n = 1000)
  
  userData <- data.frame(
      "tweet" = sapply(getTweets, function(x) x$text),
      "created" = sapply(getTweets, function(x) as.character(x$created)),
      "favorited" = sapply(getTweets, function(x) x$favoriteCount),
      "retweeted" = sapply(getTweets, function(x) x$retweetCount),
      stringsAsFactors = FALSE
    )
  userData$created <- lubridate::ymd_hms(userData$created)
  userData$created <- userData$created - 5*60*60 # puts in est time
  userData$dayCreated <- wday(userData$created, label = T)
  userData
}

trumpsTweets <- FetchTweets("realDonaldTrump")

references <-  regmatches(trumpsTweets$tweet,
                          gregexpr("@[[:alnum:]]+",trumpsTweets$tweet))

# pipe sandwich
references %>% 
  unlist %>% table %>% 
  sort(decreasing = TRUE) ->
references 

top3 <- names(references[1:3])

trumpsTweets$nytFlag <- as.numeric(grepl(top3[1], trumpsTweets$tweet))
trumpsTweets$cnnFlag <- as.numeric(grepl(top3[2], trumpsTweets$tweet))
trumpsTweets$foxFlag <- as.numeric(grepl(top3[3], trumpsTweets$tweet))

# for initial tableau exploration (3/5)
write.csv(trumpsTweets, "D:/Projects/OMTM/trump.csv", row.names = FALSE)
# ------

pence <- FetchTweets("vp")
write.csv(pence, "D:/Projects/OMTM/pence.csv", row.names = FALSE)



links <- regmatches(trumpsTweets$tweet,
                    gregexpr(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)",
                             trumpsTweets$tweet))
