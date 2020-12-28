#Chapter 3 - Analyzing Word and Document Frequency: tf-dfs

#Calculate tf and tf-idf for Jane Austen novels
library(dplyr)
library(janeaustenr)
library(tidytext)

book_words=austen_books() %>%
  unnest_tokens(word,text) %>%
  count(book, word, sort=TRUE) %>%
  ungroup()

total_words=book_words %>%
  group_by(book) %>%
  summarize(total=sum(n))

book_words=left_join(book_words,total_words)

book_words

#Look at distribution of n/total for each novel (tf)
library(ggplot2)

ggplot(book_words,aes(n/total,fill=book))+
  geom_histogram(show.legend=FALSE)+
  xlim(NA,0.0009)+
  facet_wrap(~book,ncol=2,scales="free_y")

#Examine Zipf's law - freq word appears 
#is inversely proportional to its rank

freq_by_rank= book_words %>%
  group_by(book) %>%
  mutate(rank=row_number(),
         'term frequency'=n/total)

freq_by_rank


#Visualize Zipf's law (inverse proportional 
#relationship with rank on x-axis and tf on y-axis)

freq_by_rank %>% 
  ggplot(aes(rank, `term frequency`, color = book)) + 
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()

#Let's see what the exponent of the power law is 
#for the middle section of the rank range

rank_subset=freq_by_rank %>%
  filter(rank<500,
         rank>10)
lm(log10(`term frequency`)~log10(rank),data=rank_subset)


#Let's plot this fitted power law with the data from
#previous example to see how it looks
freq_by_rank %>% 
  ggplot(aes(rank, `term frequency`, color = book)) + 
  geom_abline(intercept = -0.62, slope = -1.1, color = "gray50", linetype = 2) +
  geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
  scale_x_log10() +
  scale_y_log10()
  
#Use bind_tf_idf function
book_words = book_words %>%
  bind_tf_idf(word,book,n)

book_words


#Let's look at terms with high 
#tf-idf in Jane Austen's works
book_words %>%
  select(-total) %>%
  arrange(desc(tf_idf))

#IDF CALCULATION CHECK
# natural log of (# docs / # of docs containing word)
logb(6,base=exp(1))
#1.791759
logb((6/2),base=exp(1))
#1.098612

#Visualize high tf-idf words
book_words %>%
  arrange(desc(tf_idf)) %>%
  mutate(word=factor(word,levels=rev(unique(word)))) %>%
  group_by(book) %>%
  top_n(15) %>%
  ungroup %>%
  ggplot(aes(word,tf_idf,fill=book))+
  geom_col(show.legend=FALSE)+
  labs(x=NULL,y="tf-idf")+
  facet_wrap(~book,ncol=2,scales="free")+
  coord_flip()


#######################################
##### Let's look at physics books #####
#######################################

library(gutenbergr)
physics= gutenberg_download(c(37729, 14725, 13476, 5001), 
                              meta_fields = "author")

physics_words=physics %>%
  unnest_tokens(word,text) %>%
  count(author,word,sort=TRUE) %>%
  ungroup()

physics_words
plot_physics= physics_words %>%
  bind_tf_idf(word, author, n) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  mutate(author = factor(author, levels = c("Galilei, Galileo",
                                            "Huygens, Christiaan", 
                                            "Tesla, Nikola",
                                            "Einstein, Albert")))
plot_physics %>% 
  group_by(author) %>% 
  top_n(15, tf_idf) %>% 
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(word, tf_idf, fill = author)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~author, ncol = 2, scales = "free") +
  coord_flip()

#Filter out some words

library(stringr)
physics %>%
  filter(str_detect(text,"AK")) %>%
  select(text)


#Remove some less meaningful words

mystopwords=tibble(word = c("eq", "co", "rc", "ac", "ak", "bn", 
                               "fig", "file", "cg", "cb", "cm"))
physics_words=anti_join(physics_words, mystopwords, by = "word")
plot_physics= physics_words %>%
  bind_tf_idf(word, author, n) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  group_by(author) %>% 
  top_n(15, tf_idf) %>%
  ungroup() %>%
  mutate(author = factor(author, levels = c("Galilei, Galileo",
                                            "Huygens, Christiaan",
                                            "Tesla, Nikola",
                                            "Einstein, Albert")))
ggplot(plot_physics, aes(word, tf_idf, fill = author)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~author, ncol = 2, scales = "free") +
  coord_flip()
