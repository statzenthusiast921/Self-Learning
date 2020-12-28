#Chapter 8 Code

#Download JSON file and take a look at names of what is stored in metadata
install.packages("jsonlite")
library(jsonlite)
install.packages("curl")
library(curl)
metadata=fromJSON("https://data.nasa.gov/data.json")
names(metadata$dataset)

library(dplyr)
nasa_title <- tibble(id = metadata$dataset$`_id`$`$oid`, 
                     title = metadata$dataset$title)
nasa_title