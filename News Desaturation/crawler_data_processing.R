library(jsonlite)
library(tidyverse)
library(tm)

source_file <- paste0("D:/Projects/OMTM/News Desaturation/",
                      "news_04032017_1538.json")

news <- fromJSON(source_file, flatten = TRUE)

titles <- unlist(news$title)

titles <- gsub("\n", "", titles)
titles <- trimws(titles)
titles <- titles[!titles %in% c(""," ")]

numwords_titles <- map_dbl(gregexpr("\\S+", titles), length)

remove_titles <- titles[numwords_titles < 4]

titles <- titles[!(titles %in% remove_titles)]

titles_df <- data.frame(
  "title" = titles,
  "flag" = rep(0, length(titles)),
  stringsAsFactors = F
)

# View(remove_df) to manually find rows that should have flag = 0

filter_titles <- titles_df$title[c(18,27,65,83,86,102,126,147:149,
                    157:159,179,188,190,201,208:210,212,
                    232,240,246,251,259:266,275,277:278,
                    287:292,320:321,335:337,344:350,353,
                    365, 366, 367, 371,390:391,396:398,414,
                    431:433,450, 468,469, 475, 477,522,
                    549:550,582:584,607:609,628,642:644,676,
                    680,712:714,729:731,742:747,784,816,
                    840:841,850,852,865,871:872,877:880,
                    887,893:904,908:917,934,935,949,958,
                    974,991:994,998:1003,1009:1031)]
                    


full_titles <- titles_df$title[!(titles_df$title %in% filter_titles)]

clean_titles <- tolower(full_titles)
clean_titles <- removePunctuation(clean_titles)
clean_titles <- removeWords(clean_titles, stopwords("en"))

all_words <- paste(clean_titles, collapse = " ")
all_words <- map(all_words, function(x) strsplit(x, " "))
all_words <- unlist(all_words)
all_words <- all_words[nchar(all_words) > 2]

View(data.frame(table(all_words)))
