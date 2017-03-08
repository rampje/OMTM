source("creds.R")
source("FacebookFunctions.R")

# set up authentication token
#token <- fbOAuth(app_id, app_secret)

#trumpsPage <- getPage("DonaldTrump", token, n = 2000)

# extract posts from trump page

trumpsPosts <- ExtractPosts(trumpsPage, 1:100)

# set up connection to sqlite db
db <- dbConnect(RSQLite::SQLite(), dbname="facebook.sqlite")

# extract data from posts and write them into new db tables
ExtractPostData(trumpsPosts) %>%
  dbWriteTable(conn = db, name = "posts", overwrite = TRUE)

ExtractPostData(trumpsPosts, type="likes") %>%
  dbWriteTable(conn = db, name = "postlikes", overwrite = TRUE)

ExtractPostData(trumpsPosts, type="comments") %>%
  dbWriteTable(conn = db, name = "postcomments", overwrite = T)

# utility functions
dbListTables(db)
dbListFields(db, "PostLikes")
dbGetQuery(db, "SELECT * FROM posts")
#dbRemoveTable(db, "table name")

dbDisconnect(db)

