#Lesson 32: Horizontal Barplots and Histograms Part 3

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
ps_fb=read.csv("pseudo_facebook.csv",header=TRUE)
titanic=read.csv("titanic_train.csv",header=TRUE)

#Horizontal Bar plots
barplot(ps_fb$likes,main="Bar plot for likes",horiz=TRUE,col="green")
barplot(ps_fb$dob_month,main="2nd Bar plot",horiz=TRUE)

#PLOT FUNCTION
plot(titanic$Age)
plot(ps_fb$likes,type='o')
plot(ps_fb$likes,ylim=c(0,100))
plot(density(ps_fb$likes))
