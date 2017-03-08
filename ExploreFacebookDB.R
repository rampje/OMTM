library(RSQLite)
library(sqldf)
db <- dbConnect(RSQLite::SQLite(), dbname="facebook.sqlite")

posts <- dbGetQuery(db, "SELECT * FROM posts")
likes <- dbGetQuery(db, "SELECT * FROM postlikes")
comments <- dbGetQuery(db, "SELECT * FROM postcomments")

# unorganized exploration

a <- table(likes$from_id)
b <- table(comments$from_id)

plot(posts$likes_count, posts$comments_count)
# the video and photo with 100000 + likes are special
# the other 8 look like normy posts