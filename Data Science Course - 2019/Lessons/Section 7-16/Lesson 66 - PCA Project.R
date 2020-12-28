#Lesson 66 - PCA Project

#1.) Load IRIS Dataset
data("iris")
dim(iris)
#150  5
str(iris)
colnames(iris)

#2.) Explore some visualizations
pairs(iris,pch=21)

library(corpcor)
View(iris)
corrmatrix=cor(iris[,1:4])
corrmatrix
#Plot correlations
library(corrplot)
corrplot(corrmatrix)

iris_nums=iris[,1:4]



#3.) Principal Component Analysis
pc=princomp(iris_nums,cor=TRUE,scores=TRUE)
summary(pc)
