#Lesson 39: Lattice Graphs and Scatter3d plots
CTDF=read.csv(url("https://raw.githubusercontent.com/luckystar9111/Random-Forest/master/DEV_SAMPLE.csv"))
dim(CTDF)
colnames(CTDF)
head(CTDF)
str(CTDF)

#Balance by Occupation (4 factor levels)
ggplot(data=CTDF,aes(y=CTDF$Balance))+geom_boxplot(aes(col=Occupation))

data("iris")
head(iris)

install.packages("lattice")
library(lattice)

#creates scatterplot, each point is different color based on Species
xyplot(Sepal.Length~Sepal.Width,data=iris,groups=Species)

barchart(Sepal.Length+Sepal.Width+Petal.Length~Species,data=iris)
barchart(Sepal.Length+Sepal.Width+Petal.Length~Species,data=iris,auto.key=list(column=3))
barchart(Sepal.Length+Sepal.Width+Petal.Length~Species,data=iris,stack=TRUE)


setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
titanic=read.csv("titanic_train.csv",header=TRUE)
dim(titanic)
head(titanic)

barchart(Age~Survived|Sex,data=titanic)
histogram(~Age|Sex,data=titanic)
histogram(~Age|Sex+Survived,data=titanic)

densityplot(~Age|Sex,data=titanic)
bwplot(~Age|Sex+Survived,data=titanic)
bwplot(~Age,data=titanic)


###########################################################
install.packages("scatterplot3d")
library(scatterplot3d)

#Cool 3d graphs
scatterplot3d(x=iris$Sepal.Length,y=iris$Sepal.Width,z=iris$Species)

scatterplot3d(x=iris$Sepal.Length,y=iris$Sepal.Width,z=iris$Species,pch=16)
scatterplot3d(x=iris$Sepal.Length,y=iris$Sepal.Width,z=iris$Species,pch=16,highlight.3d=TRUE,col.axis="blue",col.grid="lightblue")
