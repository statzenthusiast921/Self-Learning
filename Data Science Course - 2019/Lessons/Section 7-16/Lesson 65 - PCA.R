#Lesson 65 - PCA

#PCA only works with numerical columns

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
ca.arry=read.delim("arrhythmia.data",header=FALSE,sep=",")
dim(ca.arry)
#452  280
View(ca.arry)

#impute na instead of ?
#cant impute NA directly if it is present in factors

ca.arry=read.delim("arrhythmia.data",header=FALSE,sep=",",na.strings=c("?"," ","NA"))
View(ca.arry)
str(ca.arry)
summary(ca.arry)

#pairs(ca.arry,gap=0,pch=21)
#dont run this code above - should take ~30 min to finish

library(corpcor)
corrmatrix=cor(ca.arry,na.rm=TRUE)
#drop columns with NAs

#print names of columns with NAs
colnames(ca.arry)[colSums(is.na(ca.arry))>0]

#drop columns
ca.arry.updated=ca.arry[,-c(11:15)]

#try correlation matrix again
corrmatrix=cor(ca.arry.updated,use="complete.obs")
ca.zero=subset(ca.arry.updated,select=colSums(ca.arry.updated)>0)
View(ca.zero)
cormatrix=cor(ca.zero,use="complete.obs")
cormatrix

#Plot correlations
library(corrplot)
corrplot(cormatrix)


#This information is not helping us - need to reduce dimensions

pc=princomp(ca.zero,cor=TRUE,scores=TRUE)
summary(pc)
dim(ca.zero)
#452  211
#same # of components as columns

plot(pc)
plot(pc,type='l')
attributes(pc)


pc$loadings
pc$scores

#Run a regression with scores from principal components
log_reg=glm(V2~pc$scores[,1]+pc$scores[,2],data=ca.zero,family=binomial("logit"))
summary(log_reg)

#Formally run a principal component regression

#use this method when running regression on data that suffers 
#from severe multicollinearity

#reduces variance, but adds bias

#un-standardize after regression and interpret new results (yes theres bias, but we
#hope the added benefit of smaller variance makes it worth it)
install.packages("pls")
library(pls)

pcr.m=pcr(V2~pc$scores[,1]+pc$scores[,2],data=ca.zero,scale=TRUE,validation='CV')
pcr.m2=pcr(V2~.,data=ca.arry,scale=TRUE,validation="CV")
summary(pcr.m)
validationplot(pcr.m)
