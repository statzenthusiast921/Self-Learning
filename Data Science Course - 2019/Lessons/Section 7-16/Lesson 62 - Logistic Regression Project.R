#Lesson 62 - Logistic Regression Project

#1.) Download and load the data
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
hep=read.csv("hepatitis.csv")
dim(hep)
head(hep)
str(hep)
colnames(hep)

#2.) Perform basic visualization
unique(hep$class)

hep$sex=as.factor(hep$sex)
hep$steroid=as.factor(hep$steroid)

ggplot(data=hep,aes(y=hep$sgot,x=hep$steroid))+
  geom_boxplot(aes(col=hep$steroid))

#3.) Handle missing values
hep=na.omit(hep)
dim(hep)

#4.) Run logistic regression
set.seed(100)
hep$random=runif(nrow(hep),0,1)
set.seed(100)
train=hep[which(hep$random<=0.8),]
test=hep[which(hep$random>0.8),]
c(nrow(train),nrow(test))


train$class=ifelse(train$class==1,1,0)
table(train$class)
test$class=ifelse(test$class==1,1,0)
table(test$class)


train.mod=glm(class~anorexia+spiders+bilirubin+albumin,data=train,family=binomial("logit"))
summary(train.mod)               


predict=predict(train.mod,type='response')
train$prediction2=predict


View(train)


#predictions are between 0 and 1 - to make confusion matrix, you convert to 0,1s
train$prediction.update=ifelse(train$prediction2>0.5,1,0)
View(train)

#Confusion Matrix
with(train,table(class,prediction.update))

#total obs
90+3+8+14

#num of incorrect obs
3+8

# Misclassification %age
11/115
#10%

test.prediction=predict(train.mod,test,type="response")
test$predicted=test.prediction
test$prediction.updated=ifelse(test.prediction>0.5,1,0)
View(test)

#Confusion Matrix
with(test,table(class,prediction.updated))

6/(20+6+1)

#22% misclassification - kinda close not really, 
# small dataset is the result of discrepancy

ROCpred=prediction(test.prediction,test$class)
ROCperf=performance(ROCpred,"tpr","fpr")
plot(ROCperf)
