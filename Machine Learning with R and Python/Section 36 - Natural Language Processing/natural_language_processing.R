# Natural Language Processing

# Importing the dataset
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Machine Learning/Section 36 - Natural Language Processing")
dataset_original = read.delim('Restaurant_Reviews.tsv', quote = '', stringsAsFactors = FALSE)

# Cleaning the texts
# install.packages('tm')
# install.packages('SnowballC')
library(tm)
library(SnowballC)
corpus = VCorpus(VectorSource(dataset_original$Review))

#Let's look at the first review before we modify anything
as.character(corpus[[1]])


corpus = tm_map(corpus, content_transformer(tolower))
as.character(corpus[[1]])


corpus = tm_map(corpus, removeNumbers)
as.character(corpus[[841]])


corpus = tm_map(corpus, removePunctuation)
as.character(corpus[[1]])


corpus = tm_map(corpus, removeWords, stopwords())
as.character(corpus[[1]])
as.character(corpus[[841]])

#get the root of the word
corpus = tm_map(corpus, stemDocument)
as.character(corpus[[1]])
as.character(corpus[[841]])


corpus = tm_map(corpus, stripWhitespace)
as.character(corpus[[1]])
as.character(corpus[[841]])


# Creating the Bag of Words model
dtm = DocumentTermMatrix(corpus)

#get rid of some non-frequent words (only appear once in one review)
#will look at all sparse columns only keep 99% of them
dtm = removeSparseTerms(dtm, 0.999)

#we went from 1577 columns to 691



#--- Random Forest Classification Model ---#

dataset = as.data.frame(as.matrix(dtm))
dataset$Liked = dataset_original$Liked

# Importing the dataset
dataset = read.csv('Social_Network_Ads.csv')
dataset = dataset[3:5]

# Encoding the target feature as factor
dataset$Liked = factor(dataset$Liked, levels = c(0, 1))

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Liked, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fitting Random Forest Classification to the Training set
# install.packages('randomForest')
library(randomForest)
classifier = randomForest(x = training_set[-692],
                          y = training_set$Liked,
                          ntree = 10)

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-692])

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred)


#HW
#----Try other models to see if they get better prediction results----#
#----------------------------------------------------------#
#Attempt #1: Logistic Regression
# Fitting Logistic Regression to the Training set
classifier = glm(formula = training_set$Liked ~ .,
                 family = binomial,
                 data = training_set)

# Predicting the Test set results
prob_pred = predict(classifier, type = 'response', newdata = test_set[-692])
y_pred = ifelse(prob_pred > 0.5, 1, 0)

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred > 0.5)
cm
#55%
#----------------------------------------------------------#
#Attempt #2: KNN Classification
library(class)
y_pred = knn(train = training_set[, -692],
             test = test_set[, -692],
             cl = training_set[, 692],
             k = 5,
             prob = TRUE)

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred)
cm
#65%

#----------------------------------------------------------#
#Attempt #3: SVM Classification
library(e1071)
classifier = svm(formula = Liked ~ .,
                 data = training_set,
                 type = 'C-classification',
                 kernel = 'linear')

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-692])

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred)
cm
#80%
#----------------------------------------------------------#
#Attempt #4: Decision TREE Classification
library(rpart)
classifier = rpart(formula = Liked ~ .,
                   data = training_set)

# Predicting the Test set results
y_pred = predict(classifier, newdata = test_set[-692], type = 'class')

# Making the Confusion Matrix
cm = table(test_set[, 692], y_pred)
cm
#71%