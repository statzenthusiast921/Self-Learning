#Lesson 73 - Random Forest Implementation

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
heart.dis=read.delim("processed.cleveland.data",sep=',')
dim(heart.dis)
head(heart.dis)
colnames(heart.dis)=c(
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
View(heart.dis)
str(heart.dis)


summary(heart.dis)
sum(is.na(heart.dis))

#Divide data into training and test datasets
set.seed(100)
heart.dis$random=runif(nrow(heart.dis),0,1)
trainingdata=heart.dis[which(heart.dis$random<=0.8),]
testdata=heart.dis[which(heart.dis$random>0.8),]
c(nrow(trainingdata),nrow(testdata))

#RANDOM FOREST
install.packages("randomForest")
library(randomForest)

#ntree=number of forests/samples
#mtry=number of variables/columns to be used for each forest/node
#nodesize=similar to minbucket(terminal node)
#importance=which variable is more important than others

random.heart=randomForest(as.factor(output)~.,data=trainingdata,
                          ntree=50,mtry=3,nodesize=10,
                          importance=TRUE)

#as.factor used since we are classifying obs
#OOB=out of bag
#we have 50 trees which means that there are 50 models.  
# All obs wont be in each model
#missing values are called out of bag
#out of bag values are used as testing set by model
#model will use these OOBs to predict class of these obs
#OOB is the mean prediction error on each training sample using OOB value
print(random.heart)
#OOB estimate of error rate: 42.62%


#number 50 is kind of arbitrary - so let's do this:
#plots error rates by number of trees used for each value of output and OOB

#plot to tell us optimum number of trees
plot(random.heart, main="Error Rates for Random Forest Models")
legend("topright",c("OOB","1","2","3","4"),text.col=1:6,lty=1:3,col=1:3)

#find point where line of OOB is lowest - choose either 10 or 40 trees

#same information as the table - use it to find exact lowest 
#error rates - 40 is correct
random.heart$err.rate

#List the importance of the variables
importantvariables=round(randomForest::importance(random.heart),2)
importantvariables[order(importantvariables[,5],decreasing=TRUE),]


#variable with highest mean-decrease-gini is the best variable = max.hr


#Tuning Random Forest - used for finding optimum value of mtry
tune.forest=tuneRF(x=trainingdata,
                   y=as.factor(trainingdata$output),
                   mtryStart = 3,
                   ntreeTry=50,
                   improve=0.0001,
                   trace=TRUE,
                   plot=TRUE,
                   doBest = TRUE,
                   nodesize=10,
                   importance=TRUE)
#ignore the error - just remove improve
tune.forest=tuneRF(x=trainingdata,
                   y=as.factor(trainingdata$output),
                   mtryStart = 3,
                   ntreeTry=50,
                   trace=TRUE,
                   plot=TRUE,
                   doBest = TRUE,
                   improve=TRUE,
                   nodesize=10,
                   importance=TRUE
                   )

#mtry =12 and 15 produces least amount OOB error
#this object is currently carrying the optimized version of our RF model
tune.forest$importance

#HIGHEST MEANDECREASEGINI=output


#Predict
trainingdata$predict.class=predict(tune.forest,trainingdata,type='class')
trainingdata$predict.score=predict(tune.forest,trainingdata,type='prob')
View(trainingdata)

sum(trainingdata$output)/nrow(trainingdata)

#KS, AUC, gini cannot be calculated in this case because output variable is not binary

#Classification Error
with(trainingdata,table(output,predict.class))

#add predict class for test data set


#LESSON 74 - Random Forest Implementation
#going to handle output variable and read in RF on that
#we can not evaluate performance of model since output variable ranges from 0 to 4

#need to reload file
heart.dis=read.delim("processed.cleveland.data",sep=',')
dim(heart.dis)
head(heart.dis)
str(heart.dis)
heart.dis$output=as.factor(heart.dis$output)
colnames(heart.dis)=c(
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

??model_matrix
dummy.data=model.matrix(~.,data=heart.dis)
heart.dis.updated=cbind(heart.dis,dummy.data)
View(dummy.data)
View(heart.dis.updated)
dim(heart.dis.updated)

#Divide data into training and test datasets
set.seed(100)
heart.dis.updated$random=runif(nrow(heart.dis.updated),0,1)
trainingdata=heart.dis.updated[which(heart.dis.updated$random<=0.8),]
testdata=heart.dis.updated[which(heart.dis.updated$random>0.8),]
c(nrow(trainingdata),nrow(testdata))

#Do the random forest
random.heart=randomForest(as.factor(output1)~.,data=trainingdata,
                          ntree=50,mtry=3,nodesize=10,
                          importance=TRUE)
# Get rid of duplicate columns
View(trainingdata)
trainingdata=subset(trainingdata,select=-c(15,16))
dim(trainingdata)
#244  38
trainingdata=subset(trainingdata,select=-c(37,38))


random.heart=randomForest(as.factor(output1)~.,data=trainingdata,
                          ntree=50,mtry=3,nodesize=10,
                          importance=TRUE)


print(random.heart)
#OOB estimate of error rate: 8.2%



#plots error rates by number of trees used for each value of output and OOB

#plot to tell us optimum number of trees
plot(random.heart, main="Error Rates for Random Forest Models")
legend("topright",c("OOB","0","1"),text.col=1:6,lty=1:3,col=1:3)

#find point where line of OOB is lowest - choose either 10 or 40 trees

#same information as the table - use it to find exact lowest 
random.heart$err.rate
dim(random.heart$err.rate)
min(random.heart$err.rate[,1])

#50 trees is the optimal value


#List the importance of the variables
importantvariables=round(randomForest::importance(random.heart),2)
importantvariables[order(importantvariables[,3],decreasing=TRUE),]


#variable with highest mean-decrease-gini is the best variable = output


#Tuning Random Forest - used for finding optimum value of mtry
tune.forest=tuneRF(x=trainingdata,
                   y=as.factor(trainingdata$output),
                   mtryStart = 3,
                   ntreeTry=50,
                   trace=TRUE,
                   plot=TRUE,
                   doBest = TRUE,
                   improve=TRUE,
                   nodesize=10,
                   importance=TRUE
)

#mtry =12 and 15 produces least amount OOB error
#this object is currently carrying the optimized version of our RF model
tune.forest$importance

#HIGHEST MEANDECREASEGINI=output


#Predict
trainingdata$predict.class=predict(tune.forest,trainingdata,type='class')
trainingdata$predict.score=predict(tune.forest,trainingdata,type='prob')
View(trainingdata)


#KS, AUC, gini cannot be calculated in this case because output variable is not binary

#Classification Error
with(trainingdata,table(output,predict.class))
pred=prediction(trainingdata$predict.score[,2],(trainingdata$output1))
perf=performance(pred,"tpr","fpr")
KS=max(attr(perf,'y.values')[[1]]-attr(perf,'x.values')[[1]])
#KS: statistical indictor for CART models -  value of 40 or above good 
#but we should target higher value

KS
auc=performance(pred,"auc");
auc
auc=as.numeric(auc@y.values)
#gini is computed on probability column
gini=ineq(trainingdata$predict.score[,2],type="Gini")
plot(perf)
