library(RSQLite)
library(sqldf)
db <- dbConnect(RSQLite::SQLite(), dbname="facebook.sqlite")

posts <- dbGetQuery(db, "SELECT * FROM posts")
likes <- dbGetQuery(db, "SELECT * FROM postlikes")
comments <- dbGetQuery(db, "SELECT * FROM postcomments")

# unorganized exploration

plot(posts$likes_count, posts$comments_count)
# the video and photo with 100000 + likes are special
# the other 8 look like normy posts


dbSendQuery(db,"INSERT INTO posts values(1,2,3,4,5,6,7,8,9,10)")

dbGetQuery(db, "SELECT * FROM posts")
