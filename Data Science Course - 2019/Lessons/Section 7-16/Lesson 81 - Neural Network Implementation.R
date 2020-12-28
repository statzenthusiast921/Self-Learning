#Lesson 81 - Neural Network Implementation
install.packages("neuralnet")
library(neuralnet)
library(data.table)
library(scales)
library(caret)

#Load the dataset
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
income.orig=read.delim("adult.data",header=FALSE,sep=',',na.strings=c(""," "," ?","NA"))
head(income.orig)
dim(income.orig)
#32561  15

#Name the columns
colnames(income.orig)=c(
  "age",
  "workclass",
  "final.weight",
  "education",
  "education.num",
  "marital-status",
  "occupation",
  "relationship",
  "race",
  "sex",
  "capital.gain",
  "capital.loss",
  "hours.per.week",
  "country",
  "final.class"
)
#Look at the dataset
View(income.orig)
#Investigate the structure
str(income.orig)
#Print total number of NAs
sum(is.na(income.orig))
#4262

#Print the columns with NAs in the dataset
colnames(income.orig)[colSums(is.na(income.orig))>0]
summary(income.orig)

#Deal with the missing values
library(mice)
#Display table of missing values
md.pattern(income.orig)

#Verify number of NAs
sum(is.na(income.orig$workclass))
sum(is.na(income.orig$country))
sum(is.na(income.orig$occupation))

summary(income.orig)

#Take missing values and change to "None"
library(forcats)
workclass.new=fct_explicit_na(income.orig$workclass,na_level="None")
income.orig$workclass.new=workclass.new

country.new=fct_explicit_na(income.orig$country,na_level = "None")
income.orig$country.new=country.new

occupation.new=fct_explicit_na(income.orig$occupation,na_level = "None")
income.orig$occupation.new=occupation.new

str(income.orig)
View(income.orig)

#Neural networks only work with numeric data so we have to convert factors to dummies
occ.matrix=model.matrix(~occupation.new-1,data=income.orig)
income.orig=data.frame(income.orig,occ.matrix)

library(plyr)
library(dplyr)
str(income.orig)

income.orig$final.class=revalue(income.orig$final.class,c(" >50K"="1"))
income.orig$final.class=revalue(income.orig$final.class,c(" <=50K"="0"))

#Make Training and Test Datasets
set.seed(100)
income.orig$random=runif(nrow(income.orig),0,1)
train=income.orig[which(income.orig$random<=0.8),]
test=income.orig[which(income.orig$random>0.8),]
c(nrow(train),nrow(test))
#26144  6417

#Neural Network - GO!
nn1=neuralnet(formula=as.numeric(final.class)~occupation.new.Adm.clerical+
                                              occupation.new.Armed.Forces+
                                              occupation.new.Craft.repair+
                                              occupation.new.Exec.managerial+
                                              occupation.new.Handlers.cleaners+
                                              occupation.new.Prof.specialty+
                                              occupation.new.Other.service+
                                              occupation.new.Sales+
                                              occupation.new.Transport.moving+
                                              occupation.new.Farming.fishing+
                                              occupation.new.Machine.op.inspct+
                                              occupation.new.Tech.support+
                                              occupation.new.Protective.serv+
                                              occupation.new.Priv.house.serv+
                                              age,
              data=train,
              hidden=c(5,2),
              err.fct="sse",
              linear.output=FALSE,
              lifesign="full",
              lifesign.step=10,
              threshold=0.01,
              stepmax=2000
)


#Hidden refers to number of neurons in each hidden layer (right now (5,2) means
# 5 neurons in first layer, 2 in second layer) - usually sq.rt of num of columns and so on

#err.fct is basically a loss function
#linear.output=TRUE model will work as regression network (output will be continuous),
#linear.output=FALSE model will work for classification

#lifesign.step prints results after 10 iterations
#threshold needs to be set to make sure errors are not very low
#stepmax is maximum number of iterations we will run, if you dont set it, model will run forever 
#2000 is optimal number

#finished after 37 iterations
#if you get an error that the model did not converge its okay since its kind of a black box
plot(nn1)

nn1$result.matrix

#Assign the probabilities to the Dev sample
train$Prob=nn1$net.result[[1]]
View(train)

#The distribution of the estimated probabilities
quantile(train$Prob,c(0,1,5,10,25,50,75,90,95,98,99,100)/100)
boxplot(train$Prob)

#Results are not what we wanted - pretty much no variation in probabilities

#Rebuilding the model by scaling the independent variables
str(income.orig)
#build the neural net model by scaling the variable
scaled.data=subset(income.orig,
                   select=c("occupation.new.Adm.clerical",
                            "occupation.new.Armed.Forces",
                            "occupation.new.Craft.repair",
                            "occupation.new.Exec.managerial",
                            "occupation.new.Handlers.cleaners",
                            "occupation.new.Prof.specialty",
                            "occupation.new.Other.service",
                            "occupation.new.Sales",
                            "occupation.new.Transport.moving",
                            "occupation.new.Farming.fishing",
                            "occupation.new.Machine.op.inspct",
                            "occupation.new.Tech.support",
                            "occupation.new.Protective.serv",
                            "occupation.new.Priv.house.serv",
                            "age"))
nn.devscaled=scale(scaled.data)
#Add final class column to it
nn.devscaled=cbind(income.orig[15],nn.devscaled)
View(nn.devscaled)

#To decide number of neurons, take square root of number of columns

#Neural Network Take 2
nn2=neuralnet(formula=as.numeric(final.class)~occupation.new.Adm.clerical+
                occupation.new.Armed.Forces+
                occupation.new.Craft.repair+
                occupation.new.Exec.managerial+
                occupation.new.Handlers.cleaners+
                occupation.new.Prof.specialty+
                occupation.new.Other.service+
                occupation.new.Sales+
                occupation.new.Transport.moving+
                occupation.new.Farming.fishing+
                occupation.new.Machine.op.inspct+
                occupation.new.Tech.support+
                occupation.new.Protective.serv+
                occupation.new.Priv.house.serv+
                age,
              data=nn.devscaled,
              hidden=c(4,2),
              err.fct="sse",
              linear.output=FALSE,
              lifesign="full",
              lifesign.step=10,
              threshold=0.01,
              stepmax=2000
)

#Convergence happened at 50 iterations

weights1=nn2$weights
weights1
plot(nn2)

#Assign the probabilities to training 
nn.devscaled$Prob2=nn2$net.result[[1]]

#The distribution of the estimated probabilities
quantile(nn.devscaled$Prob,c(0,1,5,10,25,50,75,90,95,98,99,100)/100)
boxplot(nn.devscaled$Prob)
View(nn.devscaled)

#Check the Prob2 column - if model was perfect, we would get a bunch of really high and really
#low probabilities and we would assign higher (.999) to 1 and lower (.001) to 0.


#Assign 0/1 class based on certain threshold
nn.devscaled$Class=ifelse(nn.devscaled$Prob2>0.21,1,0)
with(nn.devscaled,table(final.class,as.factor(Class)))


#---------------------------------------------------------------------------#
#Lesson 82 - Neural Network Project

#1.) Try using different variables in neural network model (eg: workclass, education)

#Neural networks only work with numeric data so we have to convert factors to dummies
occ.matrix2=model.matrix(~workclass.new-1,data=income.orig)
income.orig=data.frame(income.orig,occ.matrix2)

occ.matrix3=model.matrix(~education-1,data=income.orig)
income.orig=data.frame(income.orig,occ.matrix3)

occ.matrix4=model.matrix(~marital.status-1,data=income.orig)
income.orig=data.frame(income.orig,occ.matrix4)

occ.matrix5=model.matrix(~race-1,data=income.orig)
income.orig=data.frame(income.orig,occ.matrix5)

set.seed(100)
income.orig$random=runif(nrow(income.orig),0,1)
train=income.orig[which(income.orig$random<=0.75),]
test=income.orig[which(income.orig$random>0.75),]
c(nrow(train),nrow(test))
#24505  8056


#Neural Network - GO!
nn_project1=neuralnet(formula=as.numeric(final.class)~
                workclass.new.State.gov+
                workclass.new.Self.emp.not.inc+
                workclass.new.Private+
                workclass.new.Federal.gov+
                workclass.new.Local.gov+
                workclass.new.Self.emp.inc+
                workclass.new.Without.pay+
                workclass.new.Never.worked+
                age,
              data=train,
              hidden=c(6,3),
              err.fct="sse",
              linear.output=FALSE,
              lifesign="full",
              lifesign.step=10,
              threshold=0.01,
              stepmax=2000
)

#Converged in 43 iterations
plot(nn_project1)



#Assign the probabilities to training 
train$Prob=nn_project1$net.result[[1]]

#The distribution of the estimated probabilities
quantile(train$Prob,c(0,1,5,10,25,50,75,90,95,98,99,100)/100)
boxplot(train$Prob)
View(train)

#Assign 0/1 class based on certain threshold
train$Class=ifelse(train$Prob>0.50,1,0)
with(train,table(final.class,as.factor(Class)))


#----------------------------------------------------------#
#Let's try one more time

#Neural Network - GO!
nn_project2=neuralnet(formula=as.numeric(final.class)~
                        race.White+
                        race.Black+
                        race.Asian.Pac.Islander+
                        race.Amer.Indian.Eskimo+
                        race.Other+
                        age,
                      data=train,
                      hidden=c(6,3),
                      err.fct="sse",
                      linear.output=FALSE,
                      lifesign="full",
                      lifesign.step=10,
                      threshold=0.01,
                      stepmax=2000
)

#Converged in 45 iterations
plot(nn_project2)



#Assign the probabilities to training 
train$Prob=nn_project2$net.result[[1]]

#The distribution of the estimated probabilities
quantile(train$Prob,c(0,1,5,10,25,50,75,90,95,98,99,100)/100)
boxplot(train$Prob)
View(train)

#Assign 0/1 class based on certain threshold
train$Class=ifelse(train$Prob>0.50,1,0)
with(train,table(final.class,as.factor(Class)))

