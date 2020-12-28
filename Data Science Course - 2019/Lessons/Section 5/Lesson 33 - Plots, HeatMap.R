#Lesson 33: Plot function with Heat Maps
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
titanic=read.csv("titanic_train.csv",header=TRUE)
ps_fb=read.csv("pseudo_facebook.csv",header=TRUE)


#In plot function, use one numeric and one factor - we get a boxplot

str(ps_fb)

#Tenure is numeric, Gender is factor
#boxplots are good for showcasing categories
plot(ps_fb$tenure~ps_fb$gender)
plot(tenure~likes,data=ps_fb)


#Load mtcars dataset
data("mtcars")
dim(mtcars)

#Make a heatmap
heatmap(as.matrix(mtcars),
        Rowv=NA,
        Colv=NA,
        col=heat.colors(4,alpha=1))
