#Chapter 5 Code

#Tidying DocumentTermMatrix Objects
library(tm)
install.packages("topicmodels")
library(topicmodels)
data("AssociatedPress",package="topicmodels")
AssociatedPress
#99% sparsity means 99% of document-word pairs are zero

terms=Terms(AssociatedPress)
head(terms)

#Convert DTM to tidy format
library(dplyr)
library(tidytext)

ap_td=tidy(AssociatedPress)
ap_td

#Perform sentiment analysis
ap_sentiments=ap_td %>%
  inner_join(get_sentiments("bing"),by=c(term="word"))
ap_sentiments

#Visualize which words from the AP articles most often 
#contributed to positive or negative sentiment
library(ggplot2)
ap_sentiments %>%
  count(sentiment,term,wt=count) %>%
  ungroup() %>%
  filter(n>=200) %>%
  mutate(n=ifelse(sentiment=="negative",-n,n)) %>%
  mutate(term=reorder(term,n)) %>%
  ggplot(aes(term,n,fill=sentiment))+
  geom_bar(stat="identity")+
  ylab("Contribution to sentiment")+
  coord_flip()


#Tidying dfm Objects
library(methods)
install.packages("quanteda")
library(quanteda)

data("data_corpus_inaugural",package="quanteda")
inaug_dfm=quanteda::dfm(data_corpus_inaugural,verbose=FALSE)
inaug_dfm

inaug_td=tidy(inaug_dfm)
inaug_td

inaug_tf_idf=inaug_td %>%
  bind_tf_idf(term,document,count) %>%
  arrange(desc(tf_idf))

inaug_tf_idf



#Pick four notable inaugural address and visualize
# the words most specific to each speech

speeches <- c("1933-Roosevelt", "1861-Lincoln",
              "1961-Kennedy", "2009-Obama")
inaug_tf_idf %>%
  filter(document %in% speeches) %>%
  group_by(document) %>%
  top_n(10, tf_idf) %>%
  ungroup() %>%
  mutate(term = reorder(term, tf_idf)) %>%
  ggplot(aes(term, tf_idf, fill = document)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ document, scales = "free") +
  coord_flip() +
  labs(x = "",
       y = "tf-idf")


#Extract year from each documents name and compute
#total number of words within each year

library(tidyr)
year_term_counts=inaug_td %>%
  extract(document,"year","(\\d+)",convert=TRUE) %>%
  complete(year,term,fill=list(count=0)) %>%
  group_by(year) %>%
  mutate(year_total=sum(count))

#Visualize how specific words changed in freq. over time
year_term_counts %>%
  filter(term %in% c("god", "america", "foreign", "union", "constitution", "freedom")) %>%
  ggplot(aes(year, count / year_total)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~ term, scales = "free_y") +
  scale_y_continuous(labels = scales::percent_format()) +
  ylab("% frequency of word in inaugural address")


#Casting Tidy Text Data into a Matrix
ap_td %>%
  cast_dtm(document,term,count)

#Cast table into dfm object
ap_td %>%
  cast_dfm(term,document,count)

#cast into a Matrix object
library(Matrix)
m=ap_td %>%
  cast_sparse(document,term,count)
class(m)
dim(m)

#Create a DTM of Jane Austen's books
library(janeaustenr)
austen_dtm=austen_books() %>%
  unnest_tokens(word,text) %>%
  count(book,word) %>%
  cast_dtm(book,word,n)

austen_dtm

#Tidying Corpus Objects with Metadata
data("acq")
acq

#get the first document
acq[[1]]

acq_td=tidy(acq)
class(acq_td)
acq_td
colnames(acq_td)

#find the most common words across 50 Reuters articles
acq_tokens=acq_td %>%
  select(-places) %>%
  unnest_tokens(word,text) %>%
  anti_join(stop_words,by="word")

#most common words
acq_tokens %>%
  count(word,sort=TRUE)

#tf-idf
acq_tokens %>%
  count(id,word) %>%
  bind_tf_idf(word,id,n) %>%
  arrange(desc(tf_idf))


#Example: Mining Financial Articles
install.packages("tm.plugin.webmining")
library('tm.plugin.webmining')
install.packages("purrr")
library(purrr)

company=c("Microsoft","Apple","Google","Amazon","Facebook",
          "Twitter","IBM","Yahoo","Netflix")
symbol=c("MSFT","AAPL","GOOG","AMZN","FB","TWTR","IBM",
         "YHOO","NFLX")
download_articles=function(symbol){
  WebCorpus(GoogleFinanceSource(paste0("NASDAQ:",symbol)))
}
stock_articles <- tibble(company = company,
                         symbol = symbol) %>%
  mutate(corpus = map(symbol, download_articles))
