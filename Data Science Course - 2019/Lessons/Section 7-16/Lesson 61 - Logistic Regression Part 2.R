#Lesson 61, 62 - Logistic Regression Part 2, 3 
library(ggplot2)

#final weight for all occupation types
ggplot(data=income.orig,aes(y=income.orig$final.weight,x=income.orig$occupation))+
  geom_boxplot(aes(col=income.orig$occupation))

#final weight for all occupation types - change NAs to factors
ggplot(data=income.orig,aes(y=income.orig$final.weight,x=income.orig$occupation))+
  geom_boxplot(aes(col=income.orig$occupation.new))

#final weight for all occupation types - change NAs to factors
ggplot(data=income.orig,aes(y=income.orig$final.weight,x=income.orig$education))+
  geom_boxplot(aes(col=income.orig$education))


#Histogram for Relationship - do each chunk together
g=ggplot(income.orig,aes(income.orig$relationship))
g+geom_bar()
###########################################################
g+geom_bar(aes(weight=income.orig$relationship))
g+geom_bar()



##################################################
#list=false to ensure that resultant is not in the form of a list
#replacing less than and more than 50000 with 0 and 1
#always select random values/rows for training and test datasets

library(plyr)
library(dplyr)

income.orig$final.class=revalue(income.orig$final.class,c(" >50K"="1"))
income.orig$final.class=revalue(income.orig$final.class,c(" <=50K"="0"))
View(income.orig)
summary(income.orig)


#create data partition - training/testing datasets
install.packages("caret")
library(caret)
set.seed(101)
income_sampling=createDataPartition(income.orig$final.class,p=0.80,list=FALSE)

#another way to break data up into training and testing datasets
income.orig$random=runif(nrow(income.orig),0,1)
View(income.orig)

#Make training and test datasets
set.seed(100)
train=income.orig[which(income.orig$random<=0.8),]
test=income.orig[which(income.orig$random>0.8),]
c(nrow(train),nrow(test))

#THE LOGISTIC REGRESSION MODEL
income.model=glm(final.class~sex+age+workclass+final.weight+education+occupation+country,data=train,family=binomial("logit"))
summary(income.model)

income.model2=glm(final.class~sex+age+workclass+final.weight+education+occupation,data=train,family=binomial("logit"))
summary(income.model2)
plot(income.model2)


#After training model - look at confusion matrix
#Predict values
predict=predict(income.model2,type='response')
train$prediction=predict
#error because of NAs - so we gotta drop NAs

income.WoNA=na.omit(train)
prediction=predict(income.model,type="response")
income.WoNA$prediction=prediction
View(income.WoNA)


#predictions are between 0 and 1 - to make confusion matrix, you convert to 0,1s
income.WoNA$prediction.update=ifelse(prediction>0.5,1,0)
View(income.WoNA)

#Confusion Matrix
with(income.WoNA,table(final.class,prediction.update))

#total obs
16910+1245+3495+2529
#24179

#incorrect obs
3495+1245
#4740

# % of incorrect obs
4740/24179

#80% of classification is correct :)


#Let's come back to the test dataset
#Get Test predictions from Trained Model
income.test=na.omit(test)
test.prediction=predict(income.model,income.test,type="response")
income.test$predicted=test.prediction
income.test$prediction.updated=ifelse(test.prediction>0.5,1,0)
View(income.test)

#Confusion Matrix
with(income.test,table(final.class,prediction.updated))

#total obs
4176+323+827+657

#incorrect obs
827+323

# % of incorrect obs
1150/5983

# 19% misclassification
# training and test datasets perform similarly

#####################################################
#ROC Curve-Receiver operating characteristic
#it is used for evaluating performance
# tpr vs. fpr
#tpr=sensitivity & recall
install.packages("ROCR")
library(ROCR)
ROCpred=prediction(test.prediction,income.test$final.class)
ROCperf=performance(ROCpred,"tpr","fpr")
plot(ROCperf)
nrow(income.test)

