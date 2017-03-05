library(httr)
library(js)

NYT.API.KEY <- "a919761536464c89a098987879ad4177"
myapp <- oauth_app(appname = "nytimes", key=NYT.API.KEY)

"https://api.nytimes.com/svc/search/v2/articlesearch.json"

apiSearch <- 'function(x){
  var url = "https://api.nytimes.com/svc/search/v2/articlesearch.json";
  url += "?" + $.param({
  "api-key": "a919761536464c89a098987879ad4177",
  "q": "trump",
  "sort": "newest"
  });
  $.ajax({
  url: url,
  method: "GET",
}).done(function(result) {
  console.log(result);
}).fail(function(err) {
  throw err;
})'



###

url <- paste0("https://api.nytimes.com/svc/search/v2/articlesearch.json")

a <- GET(url)
a <- content(a)

