#Scrape data from Wikipedia
#Date: 11.20.20
#---------------------------------#
install.packages("tidyverse")
library(tidyverse)
library(rvest)

#Get data
url <- "https://en.wikipedia.org/wiki/COVID-19_pandemic_by_country_and_territory"
html_data <- read_html(url)

#Want to get the table

df_raw <- html_data %>%
          html_node("#thetable") %>% # hash looks for unique ID
          html_table() %>%
          as_tibble(.name_repair = "unique") # fixes error with duplicate column names

#Clean the data
df_clean<-df_raw %>%
            select(location=2,cases=3,deaths=4,recovered=5) %>% # only keep the 2nd, 3rd, 4th, and 5th columns
            slice(-((n()-1):n())) %>% #remove last two rows, negative number removes row
            mutate(location = location %>% str_remove_all("\\[.+")) %>%#removes square brackets and everything that follows it
            mutate_at(c("cases","deaths","recovered"),function(x){
              x %>% str_remove_all(",") %>% as.integer() #get rid of commas and convert to integers
            })


