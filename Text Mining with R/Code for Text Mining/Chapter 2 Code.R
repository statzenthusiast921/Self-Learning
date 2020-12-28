set.seed(10)


# plot the features (without stopwords) from Obama's inaugural addresses
dfmat1 <- dfm(corpus_subset(data_corpus_inaugural, President == "Obama"),
              remove = stopwords("english"), remove_punct = TRUE) %>%
  dfm_trim(min_termfreq = 3)

# basic wordcloud
textplot_wordcloud(dfmat1)


# plot in colors with some additional options
textplot_wordcloud(dfmat1, rotation = 0.25,
                   color = rev(RColorBrewer::brewer.pal(10, "RdBu")))
# other display options
col <- sapply(seq(0.1, 1, 0.1), function(x) adjustcolor("#1F78B4", x))
textplot_wordcloud(dfmat1, adjust = 0.5, random_order = FALSE,
                   color = col, rotation = FALSE)


# comparison plot
dfmat2 <- dfm(corpus_subset(data_corpus_inaugural, President %in% c("Washington","Obama", "Trump")),
              remove = stopwords("english"), remove_punct = TRUE, groups = "President") %>%
  dfm_trim(min_termfreq = 3)

textplot_wordcloud(dfmat2, comparison = TRUE, max_words = 300,
                   color = c("blue", "red"))
