#Chapter 9 Code
library(dplyr)
library(tidyr)
library(purrr)
library(readr)


#Start by reading in all message from the 20news-bydate folder
#organized by subfolder with one file for each message
training_folder="data/20news-bydate/20news-bydate-train/"

#Define a function to read all files 
#from a folder into a data frame
read_folder=function(infolder){
  data_frame(file=dir(infolder,full.names=TRUE)) %>%
    mutate(text=map(file,read_lines)) %>%
    transmute(id=basename(file),text) %>%
    unnest(text)
}

#Use unnest() and map() to apply read_folder to each subfolder
raw_text <- tibble(folder = dir(training_folder, full.names = TRUE)) %>%
  unnest(map(folder, read_folder)) %>%
  transmute(newsgroup = basename(folder), id, text)
