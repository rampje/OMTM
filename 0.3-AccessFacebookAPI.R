library(Rfacebook)
library(dplyr)
library(jsonlite)
source("creds.R")
ExtractPostData <- function(postList, type="all"){
  if(type == "likes"){
    pld <- lapply(postList, "[[", 2)
    pld %>% Reduce(function(df1, df2) full_join(df1, df1), .)
  
    } else if(type == "comments"){
    pcd <- lapply(postList, "[[", 3)
    pcd %>% Reduce(function(df1, df2) full_join(df1, df1), .)
    } else {
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
}
cleanTags <- function(htmlString) gsub("<.*?>", "", htmlString)

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





















#getLikes("10154905720087605", token)


# search groups 
trumpGroups <- searchGroup("DonaldTrump", token)

