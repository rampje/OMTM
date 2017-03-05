library(twitteR)
library(ROAuth)
library(httr)
library(lubridate)

cleanFun <- function(htmlString) gsub("<.*?>", "", htmlString)

# retrieval and processing of Trump's Tweet data

# Set API Keys
api_key <- "ILZof5KEeOJqGsmBOZ3sWqlk4"
api_secret <- "CeydSs6AIzQEAH7w6DnVnqAmdYRLaWmV9yo47uxAxGlNPeYy8x"
access_token <- "838147378922340352-cu9GDw4XlNp7LVYYPyFOdMqPNq9KLbn"
access_token_secret <- "NwcfOivECg44mRYLjc5hLQCN6ooANaMVxziKP7d4VnrS6"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

FetchTweets <- userTimeline("realDonaldTrump", n = 1000)

trumpsTweets <- data.frame(
  "tweet" = sapply(FetchTweets, function(x) x$text),
  "created" = sapply(FetchTweets, function(x) as.character(x$created)),
  "favorited" = sapply(FetchTweets, function(x) x$favoriteCount),
  "retweeted" = sapply(FetchTweets, function(x) x$retweetCount),
  stringsAsFactors = FALSE
)

trumpsTweets$created <- lubridate::ymd_hms(trumpsTweets$created)
trumpsTweets$created <- trumpsTweets$created - 5*60*60 # puts in est time

# for initial tableau exploration
write.csv(trumpsTweets, "D:/Projects/trump-analysis/trump.csv", row.names = FALSE)

