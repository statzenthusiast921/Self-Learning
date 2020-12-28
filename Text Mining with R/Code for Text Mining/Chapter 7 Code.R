#Chapter 7 Code

#Use lubridate package to convert string timestamps to date-time objects
#and initially take a look at our tweeting patterns overall
install.packages("lubridate")
library(lubridate)
library(ggplot2)
library(dplyr)
library(readr)

setwd("/Desktop/Text Mining with R/Raw Data")
tweets_julia=read_csv("https://raw.githubusercontent.com/dgrtwo/tidy-text-mining/master/data/tweets_julia.csv")
dim(tweets_julia)
#13091  10
tweets_dave=read_csv("https://raw.githubusercontent.com/dgrtwo/tidy-text-mining/master/data/tweets_dave.csv")
dim(tweets_dave)
#4174   10

tweets=bind_rows(tweets_julia %>%
                   mutate(person="Julia"),
                 tweets_dave %>%
                   mutate(person="David")) %>%
  mutate(timestamp=ymd_hms(timestamp))


#Compare tweeting frequency and history
ggplot(tweets, aes(x = timestamp, fill = person)) +
  geom_histogram(position = "identity", bins = 20, show.legend = FALSE) +
  facet_wrap(~person, ncol = 1)

#Tidy up the data
library(tidytext)
library(stringr)

#Remove retweets
#mutate() removes links and cleans out some characters (eg: &)

replace_reg1="https://t.co/[A-Za-z\\d]+|"
replace_reg2="http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https"
replace_reg=paste0(replace_reg1,replace_reg2)
unnest_reg="([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
tidy_tweets=tweets %>%
  filter(!str_detect(text,"^RT")) %>%
  mutate(text=str_replace_all(text,replace_reg,"")) %>%
  unnest_tokens(word, text,token="regex",pattern=unnest_reg) %>%
  filter(!word %in% stop_words$word,str_detect(word,"[a-z]"))

#Calculate word frequencies per person
frequency=tidy_tweets %>%
  group_by(person) %>%
  count(word,sort=TRUE) %>%
  left_join(tidy_tweets %>%
              group_by(person) %>%
              summarise(total=n())) %>%
  mutate(freq=n/total)
frequency

library(tidyr)
frequency=frequency %>%
  select(person, word, freq) %>%
  spread(person,freq) %>%
  arrange(Julia, David)
frequency

#plot frequencies
library(scales)
ggplot(frequency, aes(Julia, David)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red")


##COMPARING WORD USAGE
# Restrict data to 2016
tidy_tweets <- tidy_tweets %>%
  filter(timestamp >= as.Date("2016-01-01"),
         timestamp < as.Date("2017-01-01"))

#Use str_detect() to remove Twitter usernames
#Count how many times each person uses each word 
#Keep words used more than 10 times
word_ratios <- tidy_tweets %>%
  filter(!str_detect(word, "^@")) %>%
  count(word, person) %>%
  group_by(word) %>%
  filter(sum(n) >= 10) %>%
  ungroup() %>%
  spread(person, n, fill = 0) %>%
  mutate_if(is.numeric, funs((. + 1) / (sum(.) + 1))) %>%
  mutate(logratio = log(David / Julia)) %>%
  arrange(desc(logratio))
word_ratios

#Arrange by Descending Log Ratio
word_ratios %>%
  arrange(abs(logratio))

#Which words are most likely to be from Julia  vs. David's account?
word_ratios %>%
  group_by(logratio < 0) %>%
  top_n(15, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  ylab("log odds ratio (David/Julia)") +
  scale_fill_discrete(name = "", labels = c("David", "Julia"))

#CHANGES IN WORD USE
#Which words have we tweeted about at a higher or lower rate
#as time has passed?

#Define a new time variable that defines unit of time each tweet was posted
#Use floor_date() from lubridate to do this

#Define time bins and count word frequencies
words_by_time <- tidy_tweets %>%
  filter(!str_detect(word, "^@")) %>%
  mutate(time_floor = floor_date(timestamp, unit = "1 month")) %>%
  count(time_floor, person, word) %>%
  group_by(person, time_floor) %>%
  mutate(time_total = sum(n)) %>%
  group_by(person, word) %>%
  mutate(word_total = sum(n)) %>%
  ungroup() %>%
  rename(count = n) %>%
  filter(word_total > 30)
words_by_time

#Use nest() from tidyr to make a data frame with a list colummn
#that contains smaller data frames for each word
nested_data <- words_by_time %>%
  nest(-word, -person) 
nested_data

#Use map() from purrr library to apply modeling procedure to each dataset
library(purrr)
nested_models <- nested_data %>%
  mutate(models = map(data, ~ glm(cbind(count, time_total) ~ time_floor, ., 
                                  family = "binomial")))
nested_models

#Use map() and tidy() from broom package to pull out slopes
library(broom)
slopes <- nested_models %>%
  unnest(map(models, tidy)) %>%
  filter(term == "time_floor") %>%
  mutate(adjusted.p.value = p.adjust(p.value))


#find most important slopes. Which words have changed in frequency 
#at a moderately significant level in our tweets?

top_slopes <- slopes %>% 
  filter(adjusted.p.value < 0.05) %>%
  select(-statistic,-p.value)
top_slopes


#Plot the use of these words for both David 
#and Julia over this year of tweets
words_by_time %>%
  inner_join(top_slopes, by = c("word", "person")) %>%
  filter(person == "David") %>%
  ggplot(aes(time_floor, count/time_total, color = word)) +
  geom_line(size = 1.3) +
  labs(x = NULL, y = "Word frequency")

words_by_time %>%
  inner_join(top_slopes, by = c("word", "person")) %>%
  filter(person == "Julia") %>%
  ggplot(aes(time_floor, count/time_total, color = word)) +
  geom_line(size = 1.3) +
  labs(x = NULL, y = "Word frequency")

#FAVORITE AND RETWEETS
tweets_julia=read_csv("https://raw.githubusercontent.com/dgrtwo/tidy-text-mining/master/data/juliasilge_tweets.csv")
dim(tweets_julia)
#3209   6
tweets_dave=read_csv("https://raw.githubusercontent.com/dgrtwo/tidy-text-mining/master/data/drob_tweets.csv")
dim(tweets_dave)
#3201   6

tweets <- bind_rows(tweets_julia %>% 
                      mutate(person = "Julia"),
                    tweets_dave %>% 
                      mutate(person = "David")) %>%
  mutate(created_at = ymd_hms(created_at))

#Use unnest_tokens() to transform these tweets to a tidy dataset
#Remove all retweets and replies 
tidy_tweets <- tweets %>% 
  filter(!str_detect(text, "^(RT|@)")) %>%
  mutate(text = str_remove_all(text, replace_reg)) %>%
  unnest_tokens(word, text, token = "tweets", strip_url = TRUE) %>%
  filter(!word %in% stop_words$word,
         !word %in% str_remove_all(stop_words$word, "'"))
tidy_tweets

#Look at number of time each of our tweets was retweeted
totals <- tidy_tweets %>% 
  group_by(person, id) %>% 
  summarise(rts = first(retweets)) %>% 
  group_by(person) %>% 
  summarise(total_rts = sum(rts))
totals

#Median retweets
word_by_rts <- tidy_tweets %>% 
  group_by(id, word, person) %>% 
  summarise(rts = first(retweets)) %>% 
  group_by(person, word) %>% 
  summarise(retweets = median(rts), uses = n()) %>%
  left_join(totals) %>%
  filter(retweets != 0) %>%
  ungroup()
word_by_rts %>% 
  filter(uses >= 5) %>%
  arrange(desc(retweets))

#plot the words that have the highest median retweets for each account
word_by_rts %>%
  filter(uses >= 5) %>%
  group_by(person) %>%
  top_n(10, retweets) %>%
  arrange(retweets) %>%
  ungroup() %>%
  mutate(word = factor(word, unique(word))) %>%
  ungroup() %>%
  ggplot(aes(word, retweets, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ person, scales = "free", ncol = 2) +
  coord_flip() +
  labs(x = NULL, 
       y = "Median # of retweets for tweets containing each word")

#Which words led to more favorites?  Are they different 
#than the words that lead to more retweets?
totals <- tidy_tweets %>% 
  group_by(person, id) %>% 
  summarise(favs = first(favorites)) %>% 
  group_by(person) %>% 
  summarise(total_favs = sum(favs))
word_by_favs <- tidy_tweets %>% 
  group_by(id, word, person) %>% 
  summarise(favs = first(favorites)) %>% 
  group_by(person, word) %>% 
  summarise(favorites = median(favs), uses = n()) %>%
  left_join(totals) %>%
  filter(favorites != 0) %>%
  ungroup()

word_by_favs %>%
  filter(uses >= 5) %>%
  group_by(person) %>%
  top_n(10, favorites) %>%
  arrange(favorites) %>%
  ungroup() %>%
  mutate(word = factor(word, unique(word))) %>%
  ungroup() %>%
  ggplot(aes(word, favorites, fill = person)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ person, scales = "free", ncol = 2) +
  coord_flip() +
  labs(x = NULL, 
       y = "Median # of favorites for tweets containing each word")
