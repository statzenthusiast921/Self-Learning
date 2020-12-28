#Lesson 71: CART Implementation
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data/")
bcw=read.delim("breast-cancer-wisconsin.data",header=FALSE,sep=",")
dim(bcw)
head(bcw)
View(bcw)

#Get them libraries 
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)
install.packages("rattle")
library(rattle)
library(RColorBrewer)
library(ggplot2)
library(data.table)
library(scales)
library(ROCR)
install.packages("ineq")
library(ineq)
library(tabplot)
install.packages("xlsx")
library(xlsx)

#Get them names
colnames(bcw)=c(
  "code",
  "Clump.Thickness",
  "Uniformity.of.Cell.Size",
  "Uniformity.of.Cell.Shape",
  "Marginal.Adhesion",
  "Single.Epithelial.Cell.Size",
  "Bare.Nuclei",
  "Bland.Chromatin",
  "Normal.Nucleoli",
  "Mitoses",
  "Class")

View(bcw)
#structure of data
str(bcw)
#print total number of NAs in the data
sum(is.na(bcw))
#0

summary(bcw)
#Make a few charts
#1.
ggplot(data=bcw,aes(y=bcw$Uniformity.of.Cell.Shape,x=bcw$Bare.))+
  geom_boxplot(aes(col=bcw$Bare.Nuclei))
#2.
g=ggplot(data=bcw,aes(bcw$Uniformity.of.Cell.Size))
g+geom_bar()
#3.
g=ggplot(data=bcw,aes(bcw$Bare.Nuclei))
g+geom_bar()

### Create training and test datasets ###
set.seed(100)
bcw$random=runif(nrow(bcw),0,1)
trainingdata=bcw[which(bcw$random<=0.8),]
testdata=bcw[which(bcw$random>0.8),]
c(nrow(trainingdata),nrow(testdata))
#555  144

#CART
r.ctrl=rpart.control(minsplit = 50,minbucket = 10,cp=0.02,xval=10)
m1=rpart(Class~.,data=bcw,method="class",control=r.ctrl)
m1
summary(m1)

#minsplit = number of observations that must exist in node for split
#to be attempted (eg: we chose 50 since n=799, but we wouldnt't choose
# 50 if n was = 100)

#lower nodes should have fewer observations than nodes higher
#or closer to start

#node), split. n, loss, yval, (yprob)
#node) = the node number
#split = name of variable/attribute used for split
#n = number of data elements in this node
#loss = presence of non-target elements in this stage
#yval = label assigned to a node
#yprob = displays the proportion of 0 and 1 class

fancyRpartPlot(m1,uniform=TRUE,cex=0.4)

#to find out how well the tree performs
printcp(m1)

#cp indicates the classification error
#nsplit displays the split node at which classification error is encountered

#rel error column displays that classification keeps going down as number of splits
#goes up

#xerror indicates X-Validation error, if there is overfitting, error will go up
#want to choose cp value with lowest rel error (pruning)

#pruning
ptree=prune(m1,cp=0.16,"CP")
printcp(ptree)
fancyRpartPlot(ptree,uniform=TRUE,main="Pruned Classification Tree")


#scoring
trainingdata$predict.class=predict(ptree,trainingdata,type='class')
trainingdata$predict.score=predict(ptree,trainingdata,type='prob')

#predict.score.1 columns gives prob of record =1
#predict.score.0 columns gives prob of record =0
head(trainingdata)
View(trainingdata)


pred=prediction(trainingdata$predict.score[,2],(trainingdata$Class))
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

#classification error
with(trainingdata, table(Class,predict.class))
auc
KS
gini

#classifcation error
(11+31)/(11+31+332+181)
#7.6%

########################################
# Now let's generalize to test dataset #
########################################
nrow(testdata)

#scoring the test/holdout sample
testdata$predict.class=predict(ptree,testdata,type='class')
testdata$predict.score=predict(ptree,testdata,type='prob')

View(testdata)

pred=prediction(testdata$predict.score[,2],testdata$Class)
perf=performance(pred,"tpr","fpr")
KS=max(attr(perf,"y.values")[[1]]-attr(perf,'x.values')[[1]])
auc=performance(pred,"auc");
auc=as.numeric(auc@y.values)

gini=ineq(testdata$predict.score[,2],type="Gini")
with(testdata,table(Class,predict.class))
(11)/(11+85+48)
#7.6%
# THE MODEL IS GOOD!

#Performance metrics - should be above 50% and higher = better
auc
KS
gini
