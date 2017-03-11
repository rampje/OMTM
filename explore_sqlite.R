library(RSQLite)
library(sqldf)
library(tidyverse)
g <- glimpse

db <- dbConnect(RSQLite::SQLite(), dbname="omtm.sqlite")

dbListFields(db, "fbPosts")

likedata <- dbGetQuery(db, "SELECT from_name,
                                   likes_count,
                                   created_time,
                                   type,
                                   message
                            FROM fbPosts")


likedata$created_time <- ymd_hms(likedata$created_time)

write.csv(likedata, "likedata.csv", row.names = FALSE)
