#Lesson 37 - GGPLOT2

#ggplot function is used for larger complex data
#qplot is used for simpler datasets
install.packages("ggplot2")
library(ggplot2)

#ggplot2 comes with commands - qplot and ggplot
#geom_point() : creates scatterplot
#geom_line(): creates line chart
#geom_bar(): creates bar chart
#geom_boxplot(): creates boxplot
#geom_text(): writes text inside plot area

?qplot
#stands for quick plot

data("iris")
dim(iris)
qplot(Sepal.Length,Sepal.Width,data=iris,colour=Species)

install.packages("readxl")
library(readxl)
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
lungcap=read_excel("LungCapData.xls")
dim(lungcap)
head(lungcap)
colnames(lungcap)

#Create a height by age graph, with each point indicating gender by shape
qplot(lungcap$Age,lungcap$Height,data=lungcap,shape=as.factor(Gender))

#Creates another height by age graph
ggplot(data=lungcap,aes(x=Age,y=Height))+geom_bar(stat="identity",position="dodge",colour="blue",fill="gray")

#Uses same height by age scatterplot with linear regression model
#imposed on top of graph
sctplot=ggplot(data=lungcap,aes(x=Age,y=Height))+geom_point()
sctplot=sctplot+geom_smooth(method='lm',col="red")
sctplot+geom_smooth(col="green")
