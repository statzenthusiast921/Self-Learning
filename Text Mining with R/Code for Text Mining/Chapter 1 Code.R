###########################################
##### Chapter 1: The Tidy Text Format #####
###########################################

### The unnest_tokens function ###
text=c("Because I could not stop for Death -",
       "He kindly stopped for me -",
       "The Carriage held but just Ourselves -",
       "and Immortality")
text

#Put text into data frame
install.packages("dplyr")
library(dplyr)
text_df=data_frame(line=1:4,text=text)

text_df


# Break the text into individual tokens #
install.packages("tidytext")
library(tidytext)

text_df %>% unnest_tokens(word,text)
#word argument is the output column
#text is the input column


#########################################
########## JANE AUSTIN EXAMPLE ##########
#########################################

install.packages("janeaustenr")
library(janeaustenr)
install.packages("stringr")
library(stringr)

#Translate into tidy format
original_books=austen_books() %>% 
  group_by(book) %>%
  mutate(linenumber=row_number(),
         chapter=cumsum(str_detect(text,regex("^chapter [\\divxlc]",ignore_case=TRUE)))) %>%
  ungroup()

original_books

#Reconstruct in one-token-per-row format
tidy_books=original_books %>% unnest_tokens(word,text)
tidy_books

#Remove stop words (unnecesary words)
data(stop_words)

tidy_books=tidy_books %>% anti_join(stop_words)
tidy_books
#number of words per chapter
plot(table((tidy_books$chapter)))

#Find most common words in the book
tidy_books %>% count(word,sort=TRUE)

#Create a visualization
install.packages("ggplot2")
library(ggplot2)

tidy_books %>% count(word,sort=TRUE) %>%
  filter(n>600) %>%
  mutate(word=reorder(word,n)) %>%
  ggplot(aes(word,n))+
  geom_col()+
  xlab(NULL)+
  coord_flip()


### GUTENBERG EXAMPLES ###
install.packages("gutenbergr")
library(gutenbergr)

# Gather HG Wells Books
#1.) War of the Worlds 
#2.) The Invisible Man
#3.) The Time Machine
#4.) The Island of Doctor Moreau

#capture id nums
hgwells=gutenberg_download(c(35,36,5230,159))
tidy_hgwells=hgwells %>%
  unnest_tokens(word,text) %>%
  anti_join(stop_words)

#Most common words in HG Wells novels
tidy_hgwells %>%
  count(word,sort=TRUE)

#Gather Bronte books
#1.) Jane Eyre
#2.) Wuthering Heights
#3.) The Tenant of Wildfell Hall
#4.) Villette
#5.) Agnes Grey
bronte=gutenberg_download(c(1260,768,969,9182,767))
tidy_bronte=bronte %>%
  unnest_tokens(word,text) %>%
  anti_join(stop_words)
#Most common words in these novels?
tidy_bronte %>%
  count(word,sort=TRUE)


#Calculate frequency of each word in the works of Jane Austen, Bronte sisters, and HG Wells
install.packages("tidyr")
library(tidyr)
frequency <- bind_rows(mutate(tidy_bronte, author = "Brontë Sisters"),
                       mutate(tidy_hgwells, author = "H.G. Wells"), 
                       mutate(tidy_books, author = "Jane Austen")) %>% 
  mutate(word = str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(author, proportion) %>% 
  gather(author, proportion, `Brontë Sisters`:`H.G. Wells`)

#plot results
install.packages("scales")
library(scales)

#expect a warning about rows with missing values being removed
ggplot(frequency, aes(x = proportion, y = `Jane Austen`, color = abs(`Jane Austen` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Jane Austen", x = NULL)


#Quantify similarity/difference between these sets of word frequencies

cor.test(data = frequency[frequency$author == "Brontë Sisters",],
         ~ proportion + `Jane Austen`)

cor.test(data = frequency[frequency$author == "H.G. Wells",],
         ~ proportion + `Jane Austen`)
