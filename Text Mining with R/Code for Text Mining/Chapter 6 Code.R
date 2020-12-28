#Chapter 6 Code
library(topicmodels)

data("AssociatedPress")
AssociatedPress

#set a seed so that the output of the model is predictable
ap_lda=LDA(AssociatedPress,k=2,control=list(seed=1234))
ap_lda

#generate list of terms with corresponding probabilities
#and topic for which they would belong
library(tidytext)
ap_topics=tidy(ap_lda,matrix="beta")
ap_topics

#find top 10 terms that are most common within each topic
library(ggplot2)
library(dplyr)

ap_top_terms=ap_topics %>%
  group_by(topic) %>%
  top_n(10,beta) %>%
  ungroup() %>%
  arrange(topic,-beta)

ap_top_terms %>%
  mutate(term=reorder(term,beta)) %>%
  ggplot(aes(term,beta,fill=factor(topic)))+
  geom_col(show.legend=FALSE)+
  facet_wrap(~topic,scales="free")+
  coord_flip()

#filter for relatively common words such as those that
#have a B great than 1/1000 in at least one topic
library(tidyr)
beta_spread=ap_topics %>%
  mutate(topic=paste0("topic",topic)) %>%
  spread(topic,beta) %>%
  filter(topic1>0.001|topic2>0.001) %>%
  mutate(log_ratio=log2(topic2/topic1))

beta_spread

#words with the greatest differences between two topics
beta_spread %>%
  group_by(direction = log_ratio > 0) %>%
  top_n(10, abs(log_ratio)) %>%
  ungroup() %>%
  mutate(term = reorder(term, log_ratio)) %>%
  ggplot(aes(term, log_ratio)) +
  geom_col() +
  labs(y = "Log2 ratio of beta in topic 2 / topic 1") +
  coord_flip()

#Document-Topic Probabilities
#besides estimating each topic as a mixture of words, LDA
#also models each document as a mixture of topics

ap_documents=tidy(ap_lda,matrix="gamma")
ap_documents

#each value is an estimated proportion of words from that
#document that are generated from that topic

#check for most common words in documents
tidy(AssociatedPress) %>%
  filter(document==6) %>%
  arrange(desc(count))

#Example: The Great Library Heist
titles=c("Twenty Thousand Leagues under the Sea","The War of the Worlds",
         "Pride and Prejudice","Great Expectations")
library(gutenbergr)
books=gutenberg_works(title %in% titles) %>%
  gutenberg_download(meta_fields = "title")

library(stringr)
#divide into documents, each representing one chapter
reg=regex("^chapter ",ignore_case = TRUE)
by_chapter=books %>%
  group_by(title) %>%
  mutate(chapter=cumsum(str_detect(text,reg))) %>%
  ungroup() %>%
  filter(chapter>0) %>%
  unite(document,title,chapter)

#split into words
by_chapter_word=by_chapter %>%
  unnest_tokens(word,text)

#find document-word counts
word_counts=by_chapter_word %>%
  anti_join(stop_words) %>%
  count(document,word,sort=TRUE) %>%
  ungroup()

word_counts

chapters_dtm=word_counts %>%
  cast_dtm(document,word,n)
chapters_dtm

chapters_lda=LDA(chapters_dtm,k=4,control=list(seed=1234))
chapters_lda

chapter_topics=tidy(chapters_lda,matrix="beta")
chapter_topics

#find the top 5 terms within each topic
top_terms=chapter_topics %>%
  group_by(topic) %>%
  top_n(5,beta) %>%
  ungroup() %>%
  arrange(topic,-beta)

top_terms

library(ggplot2)
top_terms %>%
  mutate(term=reorder(term,beta)) %>%
  ggplot(aes(term,beta,fill=factor(topic)))+
  geom_col(show.legend=FALSE)+
  facet_wrap(~topic,scales="free")+
  coord_flip()

#Per Document Classificiation
chapters_gamma=tidy(chapters_lda,matrix="gamma")
chapters_gamma

chapters_gamma <- chapters_gamma %>%
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE)
chapters_gamma

#reorder titles in order of topic 1, topic 2, etc. 
#before plotting
chapters_gamma %>%
  mutate(title=reorder(title,gamma*topic)) %>%
  ggplot(aes(factor(topic),gamma))+
  geom_boxplot()+
  facet_wrap(~title)

#Great Expectations got classified to other books, 
# let's investigate

chapter_classifications=chapters_gamma %>%
  group_by(title,chapter) %>%
  top_n(1,gamma) %>%
  ungroup()
chapter_classifications

#compare each to the "consensus" topic for each book 
#and see which were most often misidentified
book_topics=chapter_classifications %>%
  count(title,topic) %>%
  group_by(title) %>%
  top_n(1,n) %>%
  ungroup() %>%
  transmute(consensus=title,topic)

chapter_classifications %>%
  inner_join(book_topics,by="topic") %>%
  filter(title!=consensus)

#By-Word Assignments: augment
assignments=augment(chapters_lda,data=chapters_dtm)
assignments


#find out which words were incorrectly classified
assignments=assignments %>%
  separate(document,c("title","chapter"),sep="_",convert=TRUE) %>%
  inner_join(book_topics,by=c(".topic"="topic"))
assignments

#make a confusion matrix
install.packages("scales")
library(scales)

assignments %>%
  count(title, consensus, wt = count) %>%
  group_by(title) %>%
  mutate(percent = n / sum(n)) %>%
  ggplot(aes(consensus, title, fill = percent)) +
  geom_tile() +
  scale_fill_gradient2(high = "red", label = percent_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.grid = element_blank()) +
  labs(x = "Book words were assigned to",
       y = "Book words came from",
       fill = "% of assignments")

#most commonly mistaken words
wrong_words=assignments %>%
  filter(title!=consensus)
wrong_words

wrong_words %>%
  count(title,consensus,term,wt=count) %>%
  ungroup() %>%
  arrange(desc(n))


word_counts %>%
  filter(word=="flopson")
#LDA algorithm is stochastic, and it can accidentally
#land on a topic that spans multiple books

library(dplyr)
library(tidytext)
library(stringr)
library(ggplot2)
theme_set(theme_light())

install.packages("mallet")
library(mallet)
# create a vector with one string per chapter
collapsed <- by_chapter_word %>%
  anti_join(stop_words, by = "word") %>%
  mutate(word = str_replace(word, "'", "")) %>%
  group_by(document) %>%
  summarize(text = paste(word, collapse = " "))
# create an empty file of "stopwords"
file.create(empty_file <- tempfile())
docs <- mallet.import(collapsed$document, collapsed$text, empty_file)