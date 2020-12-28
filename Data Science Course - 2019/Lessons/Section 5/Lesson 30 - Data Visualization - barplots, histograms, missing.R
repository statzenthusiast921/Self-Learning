#Lesson 30: Data Visualization - Historgram vs. Barplot, Plotting Missing Values

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
titanic=read.csv("titanic_train.csv",header=TRUE)
head(titanic)
dim(titanic)

#Plots vs. Histograms
#Plots: Gap between bars
#Histograms: No gaps between bars
#Both use bars but plots used for comparison of variables
#Histogram used for displaying frequencies

#Ex: Compare female vs. male - USE Plots
#Ex: Display numerical distribution of quantity - USE Historgrams

str(titanic)
install.packages("Amelia")
library(Amelia)


missmap(titanic,main="Missing values")