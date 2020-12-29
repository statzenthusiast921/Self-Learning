# Artificial Neural Network

# Importing the dataset
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Machine Learning/Section 39 - Artificial Neural Networks (ANN)")
dataset = read.csv('Churn_Modelling.csv')
dataset = dataset[4:14]

# Encoding the categorical variables as factors
dataset$Geography = as.numeric(factor(dataset$Geography,
                                      levels = c('France', 'Spain', 'Germany'),
                                      labels = c(1, 2, 3)))
dataset$Gender = as.numeric(factor(dataset$Gender,
                                   levels = c('Female', 'Male'),
                                   labels = c(1, 2)))

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Exited, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature Scaling
training_set[-11] = scale(training_set[-11])
test_set[-11] = scale(test_set[-11])

# Fitting ANN to the Training set (neuralnet-->regressors)
#annet#-->only one hidden laye, deepnet--> good choice
install.packages("h2o") #--> efficiency, contains parameter tuning argument 
#that allows you to choose optimal model
library(h2o)

install.packages("deepnet")
library(deepnet)
nn=nn.train(as.matrix(training_set[-11]),as.matrix(training_set[11]),hidden=c(5,5),numepochs=100)
yy=nn.predict(nn,training_set[-11])
yhat=ifelse(yy>=0.5,1,0)
cm = table(training_set$Exited,yhat)
cm

sum(diag(cm))/sum(cm)






