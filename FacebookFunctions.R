library(Rfacebook)
library(dplyr)
library(data.table)

cleanTags <- function(htmlString) gsub("<.*?>", "", htmlString)

ExtractPosts <- function(postPage, indexRange){
  
  posts <- vector("list", length(indexRange))
  for(x in indexRange){
    #Error in if (n.comments >= 500) { : missing value where TRUE/FALSE needed
    posts[[x]] <- getPost(postPage$id[x], token,
                          n.likes = postPage$likes_count[x], 
                          n.comments = postPage$comments_count[x])
  }
  posts
}

ExtractPostData <- function(postList, type="all"){
  if(type == "likes"){
    # initialize ID column
    pd <- lapply(postList, "[[", 1)
    postIDs <- sapply(pd, function(x) x$id)
    # fetch likes data
    pld <- lapply(postList, "[[", 2)
    
    postLengths <- unlist(sapply(pld, nrow))
    
    pld <- data.table::rbindlist(pld)
    
    pld$id <- rep(postIDs, postLengths)
    pld$from_id <- as.numeric(pld$from_id)
    
    pld
    
  } else if(type == "comments"){
    # initialize ID column
    pd <- lapply(postList, "[[", 1)
    postIDs <- sapply(pd, function(x) x$id)
    #fetch comments data
    pcd <- lapply(postList, "[[", 3)
    
    postLengths <- unlist(sapply(pcd, nrow))
    
    pcd <- data.table::rbindlist(pcd)
    
    pcd$id <- rep(postIDs, postLengths)
    pcd$from_id <- as.numeric(pcd$from_id)
    
    pcd
    
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