#Getting data from an API
#Date: 12.02.20
#---------------------------------#
library(tidyverse)

url <- "https://groceries.asda.com/api/items/search?requestorigin=gi&storeid=4565&htmlassociationtype=0&listType=12&fromgi=gi&cacheable=true&productperpage=56&pagenum=1&keyword=yoghurt"
url <- "https://groceries.asda.com/api/items/search?requestorigin=gi&storeid=4565&htmlassociationtype=0&listType=12&fromgi=gi&cacheable=true&productperpage=56&pagenum=1&keyword=cookie"

data <- jsonlite::fromJSON(url)

items <- data$items


#Process - with client side rendered pages

#Right click-->Inspect Page--> Network-->XHR-->look for GET  method, find link

#this will be a good method for reading data into R without doing the annoying scraping methods


#---------- Example #2 ----------#
#look under the hood before scraping --> maybe data already in good format as API
