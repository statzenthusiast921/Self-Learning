#Lesson 78 - Naive Bayes
#simple model - kind of where "naive" comes from
#used for pattern recognition
#based on bayes thereom
#conditional probability model
#also a frequency based model
#faster in comparison to other models
#naive means that predictors are independent: eg: if someone with 2 legs, 6 foot tall,
#80 kg weight is classified as a man - that doesnt account for that fact that it could
#also be a woman (that's why its called naive)
#basically looks at all parameters and assumes all parameters are satisified
#eg: if something is shiny it has to be gold

#primarily used for spam filtering. recommender systems
#thats why you sometimes get stuff in spam folder that isn't spam - it doesn't
#account for additional factors or some kind of interaction

#used for many other kinds of classification

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
nursery=read.delim("nursery.data",sep=',',header=FALSE)
dim(nursery)
#129560 9
head(nursery)

colnames(nursery)=c(
  "parents",
  "has_nurs",
  "form",
  "children",
  "housing",
  "finance",
  "social",
  "health",
  "class"
)
head(nursery)

#Investigate data
View(nursery)
str(nursery)
summary(nursery)
#class is the dependent variable
sum(is.na(nursery))
#0

#Divide dataset into Training and Test Datasets
set.seed(100)
nursery$random=runif(nrow(nursery),0,1)
trainingdata=nursery[which(nursery$random<=0.8),]
testdata=nursery[which(nursery$random>0.8),]
c(nrow(trainingdata),nrow(testdata))
#10390  2570

print(table(nursery$class))
print(table(nursery$parents))



#Perform data visualizations
View(nursery)
histogram(nursery$class)
plot(nursery$class,col="lightblue")
table(nursery$class)
plot(table(nursery$has_nurs))

#all variables are equally distributed among thieir values - so we shall use all
#most cases we need to make plots to find out which variables are most important,
#then just use those in naive bayes classifier

#Let's do Naive Bayes
library(e1071)
naive.classifier=naiveBayes(class~.,data=nursery)
print(naive.classifier)
#gives you overall and conditional probabilities of classification into
#each class value

#scoring
trainingdata$predict.class=predict(naive.classifier,trainingdata,type="class")
with(trainingdata,table(class,predict.class))
View(trainingdata)

library(caret)
confusionMatrix(with(trainingdata,table(class,predict.class)))
#90% accuracy, 10% misclassification error rate

testdata$predict.class=predict(naive.classifier,testdata,type="class")
confusionMatrix(with(testdata,table(class,predict.class)))
#90% accuracy again

#WOOHOO!

#not complicated, fast model, can handle large datasets easily
