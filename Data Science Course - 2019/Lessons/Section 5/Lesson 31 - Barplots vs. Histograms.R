#Lesson 31: Barplots vs. Histograms Part 2

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
ps_fb=read.csv("pseudo_facebook.csv",header=TRUE)

#Initial Analysis of Dataset
head(ps_fb)
dim(ps_fb)


colnames(ps_fb)

#Let's make a Barplot
barplot(ps_fb)
#should result in error - since we passed through entire dataset
str(ps_fb)

barplot(ps_fb$likes,main="Bar plot for likes",col="red")
barplot(titanic$age)

#Histogram much better for this situation
hist(ps_fb$likes)
hist(titanic$age)

