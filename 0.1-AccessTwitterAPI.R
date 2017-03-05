library(twitteR)
library(ROAuth)
library(httr)
library(lubridate)
library(dplyr)

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
trumpsTweets$dayCreated <- wday(trumpsTweets$created, label = T)

references <- regmatches(trumpsTweets$tweet,
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
write.csv(trumpsTweets, "D:/Projects/trump-analysis/trump.csv", row.names = FALSE)
# ------


links <- regmatches(trumpsTweets$tweet,
                    gregexpr(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)",
                             trumpsTweets$tweet))