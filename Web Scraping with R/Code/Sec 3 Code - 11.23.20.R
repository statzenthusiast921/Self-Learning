#Scrape Trustpilot
#Date: 11.23.20
#---------------------------------#
#install.packages("tidyverse")
library(tidyverse)
library(rvest)

url <- "https://www.trustpilot.com/review/udemy.com"

html_data <- read_html(url)
html_data

#lets get all elements on page with class 'review'
html_data %>%
  html_nodes(".review")

reviews <- html_data %>% html_nodes(".review")


#loop over each review and extract the info we need
review <- reviews[[1]]
review


#lets pull out content
review_id <- review %>% html_attr("id")

review %>% 
  html_node(".review-content__title") %>%
  html_text() %>%
  str_squish()

review_title <- review %>% 
                  html_node(".review-content__title") %>%
                  html_text() %>%
                  str_squish()

review_text <- review %>% 
                html_node(".review-content__text") %>%
                html_text() %>%
                str_squish()

review_stars <- review %>%
                  html_node(".review-content-header") %>%
                  html_node("img") %>%
                  html_attr("alt")

date_temp <- review %>%
              html_node(".review-content-header") %>%
              html_node("script") %>%
              html_text() %>%
              str_squish() %>%
              jsonlite::fromJSON()
date_temp$publishedDate
review_timestamp <- date_temp$publishedDate
review_timestamp

#Grab consumer info
consumer_id <-review %>%
                html_node(".consumer-information") %>%
                html_attr("href") %>%
                str_remove("/users/")

consumer_name <- review %>%
                  html_node(".consumer-information__name") %>%
                  html_text() %>%
                  str_squish()

consumer_review_count <- review %>%
                          html_node(".consumer-information__review-count") %>%
                          html_text() %>%
                          str_squish()




#lets combine everything into a tibble
tibble(review_id,
       review_title,
       review_text,
       review_stars,
       review_timestamp,
       consumer_id,
       consumer_name,
       consumer_review_count)


  
#Create a function to grab info from 1st page of Trustpilot
parse_review <- function(review){
  
  review_id <- review %>% html_attr("id")
  
  review %>% 
    html_node(".review-content__title") %>%
    html_text() %>%
    str_squish()
  
  review_title <- review %>% 
    html_node(".review-content__title") %>%
    html_text() %>%
    str_squish()
  
  review_text <- review %>% 
    html_node(".review-content__text") %>%
    html_text() %>%
    str_squish()
  
  review_stars <- review %>%
    html_node(".review-content-header") %>%
    html_node("img") %>%
    html_attr("alt")
  
  date_temp <- review %>%
    html_node(".review-content-header") %>%
    html_node("script") %>%
    html_text() %>%
    str_squish() %>%
    jsonlite::fromJSON()
  date_temp$publishedDate
  review_timestamp <- date_temp$publishedDate

  consumer_id <-review %>%
    html_node(".consumer-information") %>%
    html_attr("href") %>%
    str_remove("/users/")
  
  consumer_name <- review %>%
    html_node(".consumer-information__name") %>%
    html_text() %>%
    str_squish()
  
  consumer_review_count <- review %>%
    html_node(".consumer-information__review-count") %>%
    html_text() %>%
    str_squish()
  
  
  tibble(review_id,review_title,review_text,
         review_stars,review_timestamp,consumer_id,
         consumer_name,consumer_review_count)
  
}

#Map function loops first argument through function in 2nd argument, each run is a new row
map(reviews,parse_review)

df <- map_dfr(reviews,parse_review)


#All Pages
total_reviews <- html_data %>%
                  html_node(".headline__review-count") %>%
                  html_text() %>%
                  str_squish() %>%
                  as.integer()

total_pages <-ceiling(total_reviews/20)
total_pages

pb <- progress::progress_bar$new(total=total_pages)


all_reviews <- map_dfr(1:total_pages,function(page){
                pb$tick()
                url <- glue::glue("https://www.trustpilot.com/review/udemy.com?page={page}")
                html_data <- read_html(url)
                reviews <- html_data %>% html_nodes(".review")
                df <- map_dfr(reviews, parse_review)
                df
})

dim(all_reviews)

all_reviews <- all_reviews %>% distinct()
dim(all_reviews)


#Clean the df
clean_reviews <- all_reviews %>%
                  mutate(
                    review_stars = review_stars %>% str_extract_all("\\d") %>% unlist() %>% as.integer,
                    consumer_review_count = consumer_review_count %>% str_extract_all("\\d+") %>% unlist() %>% as.integer,
                    review_timestamp = review_timestamp %>% lubridate::ymd_hms())


