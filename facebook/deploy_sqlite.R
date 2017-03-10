library(RSQLite)
library(sqldf)
library(lubridate)
source("creds.R")
source("FacebookFunctions.R")

# download facebook page data and write to db
fb_to_db <- function(dbConnection, fbPageName, authToken, dbTableName){
  message("Fetching data")
  
  page <- getPage(fbPageName, token, n = 2000)
  page$created_time <- ymd_hms(page$created_time)
  page$day_created <- day(page$created_time)
  page$dow_created <- wday(page$created_time)
  page$month_created <- month(page$created_time)
  page$created_time <- gsub(" UTC", "", page$created_time)
  
  message("Disconnect from db before writing ...")
  readline("Press enter to write table to db:")

  dbWriteTable(conn = dbConnection, name = dbTableName, 
               value = page, overwrite = TRUE)
}

# set up authentication token
token <- fbOAuth(app_id, app_secret)

# set up connection to sqlite db
db <- dbConnect(RSQLite::SQLite(), dbname="omtm.sqlite")

# ----------------------------------------------------------
#
# writing various tables to sqlite database
#
#--------------------------------------------------------------

# write fb data into db 
# ----------------------------------------------------------
fb_to_db(db, "DonaldTrump", token, "trump")
fb_to_db(db, "Breitbart", token, "breitbart")
fb_to_db(db, "FoxNews", token, "fox")
fb_to_db(db, "foxandfriends", token, "faf")
fb_to_db(db, "nytimes", token, "nyt")
fb_to_db(db, "washingtonpost", token, "wp")
fb_to_db(db, "cnn", token, "cnn")
fb_to_db(db, "bbcnews", token, "bbc")
fb_to_db(db, "TheEconomist", token, "economist")

# extract data from posts and write them into new db tables
# ----------------------------------------------------------
ExtractPostData(trumpsPosts) %>%
  dbWriteTable(conn = db, name = "posts", overwrite = TRUE)

ExtractPostData(trumpsPosts, type="likes") %>%
  dbWriteTable(conn = db, name = "postlikes", overwrite = TRUE)

ExtractPostData(trumpsPosts, type="comments") %>%
  dbWriteTable(conn = db, name = "postcomments", overwrite = TRUE)

dbDisconnect(db)
