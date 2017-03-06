library(Rfacebook)
library(jsonlite)
source("creds.R")

token <- fbOAuth(app_id, app_secret)


# took about 7 minutes to run
trumpsPage <- getPage("DonaldTrump", token, n = 2000)
# 8 minutes to run
nytPage <- getPage("nytimes", token , n = 2000)




post <- getPost(trumpsPage$id[1], token)

#getLikes("10154905720087605", token)


# search groups 
trumpGroups <- searchGroup("DonaldTrump", token)

