library(Rfacebook)
library(dplyr)
library(jsonlite)
source("creds.R")
ExtractPosts <- function(postPage, indexRange){
  
  posts <- vector("list", length(indexRange))
  for(x in indexRange){
    posts[[x]] <- getPost(postPage$id[x], token,
                          n.likes = postPage$likes_count[x], 
                          n.comments = postPage$comments_count[x])
  }
  posts
}
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

# took about 7 minutes to run n = 2000
trumpsPage <- getPage("DonaldTrump", token, n = 2000)
# 8 minutes to run n = 2000
nytPage <- getPage("nytimes", token , n = 2000)




















#getLikes("10154905720087605", token)


# search groups 
trumpGroups <- searchGroup("DonaldTrump", token)

