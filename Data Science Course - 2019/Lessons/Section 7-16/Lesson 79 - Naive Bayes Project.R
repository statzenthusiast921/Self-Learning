#Lesson 79 - Naive Bayes Project

#1.) Find and load your own dataset
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
titanic=read.csv("titanic_train.csv",header=TRUE)
dim(titanic)
#891 12
head(titanic)
str(titanic)
unique(titanic$Survived)
#1=Spam
#0=Not Spam
table(titanic$Survived)
dim(titanic)
titanic=titanic[,2:12]
titanic$Survived=as.factor(titanic$Survived)
titanic$Pclass=as.factor(titanic$Pclass)
titanic$Age=as.factor(titanic$Age)
titanic$SibSp=as.factor(titanic$SibSp)
titanic$Parch=as.factor(titanic$Parch)
titanic$Fare=as.factor(titanic$Fare)

#3.) Perform data visualizations
ggplot(data=spam,aes(y=titanic$Pclass,x=as.factor(titanic$Survived)))+geom_boxplot(aes(col=as.factor(titanic$Survived)))
ggplot(data=spam,aes(y=titanic$Age,x=as.factor(titanic$Survived)))+geom_boxplot(aes(col=as.factor(titanic$Survived)))
ggplot(data=spam,aes(y=titanic$SibSp,x=as.factor(titanic$Survived)))+geom_boxplot(aes(col=as.factor(titanic$Survived)))
ggplot(data=spam,aes(y=titanic$Parch,x=as.factor(titanic$Survived)))+geom_boxplot(aes(col=as.factor(titanic$Survived)))
histogram(titanic$Sex,titanic$Survived)
plot(table(titanic$Sex,titanic$Survived))

#4.) Split data into Training and Test datasets
set.seed(100)
titanic$random=runif(nrow(titanic),0,1)
train=titanic[which(titanic$random<=0.8),]
test=titanic[which(titanic$random>0.8),]
c(nrow(train),nrow(test))
#703 108

#5.) Run Naive Bayes
library(e1071)
naive.classifier=naiveBayes(Survived~.,data=titanic)
print(naive.classifier)

#6.) Create confusion matrix
train$predict.Survived=predict(naive.classifier,train,type="class")
with(train,table(Survived,predict.class))
View(train)

library(caret)
confusionMatrix(with(train,table(Survived,predict.Survived)))

test$predict.Survived=predict(naive.classifier,test,type="class")
confusionMatrix(with(test,table(Survived,predict.Survived)))

#7.) Write a few sentences about probabilities and performance of models

#Of the passengers who survived, 68% were female and 32% were male.  
#Of the passengers were passed, 15% were female and 85% were male.

#Training Model: 93% accuracy
#Test Model: 95% accuracy



