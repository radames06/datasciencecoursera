library(httr)
library(xml2)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at 
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "a7c914c60ed8d62c1fc0",
                   secret = "5f2ce3348724d9ca6d69f9f66f02aeb84e75c66f")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://github.com/radames06/datasharing", gtoken)
stop_for_status(req)
content(req)

json1 <- content(req)
json2 <- jsonlite::fromJSON(toJSON(json1, force=T))

# OR:
req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
stop_for_status(req)
content(req)

#question 5
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
download.file(url, destfile = 'q5.for')
ds <- read.fwf('q5.for', width=c(10,9,4,9,4,9,4,9,4), skip = 4)
