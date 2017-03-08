library(Rfacebook)
library(dplyr)
library(jsonlite)
source("creds.R")
ExtractPostData <- function(postList){
  pd <- lapply(postList, "[[", 1) 
  pd <- unlist(pd)
  
  postDataNames <- unique(names(pd))
  
  postDF <- data.frame(matrix(ncol = length(postDataNames),
                              nrow = length(postList)))
  
  names(postDF) <- postDataNames
  
  for(x in 1:ncol(postDF)){
    postDF[x] <- pd[names(pd)==names(postDF)[x]]
    
  }
  postDF
}

token <- fbOAuth(app_id, app_secret)

# don't run getPage willy nilly

# took about 7 minutes to run n = 2000
trumpsPage <- getPage("DonaldTrump", token, n = 2000)
# 8 minutes to run n = 2000
nytPage <- getPage("nytimes", token , n = 2000)


# this should be functionized with startingIndex arg
trumpsPosts <- vector("list", 5)
# 5 trump posts took 7 minutes, 32.3 mb list
for(x in 1:length(trumpsPosts)){
  trumpsPosts[[x]] <- getPost(trumpsPage$id[x], token,
                              n.likes = trumpsPage$likes_count[x], 
                              n.comments = trumpsPage$comments_count[x])
}














a1 %>%
  Reduce( function(df1, df2) full_join(df1, df1), .) ->
a2





#getLikes("10154905720087605", token)


# search groups 
trumpGroups <- searchGroup("DonaldTrump", token)

