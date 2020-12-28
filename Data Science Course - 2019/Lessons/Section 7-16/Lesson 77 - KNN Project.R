#Lesson 77 - KNN Project

#1.) Load Processed Cleveland Dataset

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
hd=read.delim("processed.cleveland.data",sep=',')
dim(hd)
#302  14
head(hd)
colnames(hd)=c(
  "age",
  "sex",
  "cp",
  "rbp",
  "chol",
  "fbs",
  "recg",
  "max.hr",
  "angina",
  "oldpeak",
  "slope",
  "major.vessels",
  "thal",
  "output"
)
View(hd)
str(hd)

#2.) Perform data visualizations
View(hd)
ggplot(data=hd,aes(y=hd$age,x=as.factor(hd$output)))+geom_boxplot(aes(col=as.factor(hd$output)))
ggplot(data=hd,aes(y=hd$rbp,x=as.factor(hd$output)))+geom_boxplot(aes(col=as.factor(hd$output)))
ggplot(data=hd,aes(y=hd$chol,x=as.factor(hd$output)))+geom_boxplot(aes(col=as.factor(hd$output)))
ggplot(data=hd,aes(y=hd$max.hr,x=as.factor(hd$output)))+geom_boxplot(aes(col=as.factor(hd$output)))
ggplot(data=hd,aes(y=hd$oldpeak,x=as.factor(hd$output)))+geom_boxplot(aes(col=as.factor(hd$output)))

#3.) Break data up into training and test datasets
set.seed(100)
hd$random=runif(nrow(hd),0,1)
trainingdata=hd[which(hd$random<=0.8),]
testdata=hd[which(hd$random>0.8),]
c(nrow(trainingdata),nrow(testdata))
#244  58

#4.) Normalize the datasets
View(trainingdata)
dim(trainingdata)
str(trainingdata)
trainingdata$major.vessels=as.numeric(trainingdata$major.vessels)
trainingdata$thal=as.numeric(trainingdata$thal)
testdata$major.vessels=as.numeric(testdata$major.vessels)
testdata$thal=as.numeric(testdata$thal)


train.normed=scale(as.data.frame(trainingdata[,-14]))
test.normed=scale(as.data.frame(testdata[,-14]))
View(train.normed)
View(test.normed)

#5.) Run the KNN algorithm 
library(class)
model1=knn(train=train.normed,test=test.normed,cl=trainingdata$output,k=10)
summary(model1)

k10=100*sum(testdata$output==model1)/NROW(testdata$output)
k10
confusionMatrix(table(model1,testdata$output))


model2=knn(train=train.normed,test=test.normed,cl=trainingdata$output,k=5)
summary(model2)

k5=100*sum(testdata$output==model2)/NROW(testdata$output)
k5
confusionMatrix(table(model1,testdata$output))


model3=knn(train=train.normed,test=test.normed,cl=trainingdata$output,k=3)
summary(model3)

k3=100*sum(testdata$output==model3)/NROW(testdata$output)
k3
confusionMatrix(table(model3,testdata$output))


model4=knn(train=train.normed,test=test.normed,cl=trainingdata$output,k=15)
summary(model4)

k15=100*sum(testdata$output==model4)/NROW(testdata$output)
k15
confusionMatrix(table(model4,testdata$output))
