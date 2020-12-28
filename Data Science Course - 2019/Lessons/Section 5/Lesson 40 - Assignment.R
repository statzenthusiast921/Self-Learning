#Lesson 40 - Assignment

#1.) a. Load lung dataset into your session
#    b. Create histogram
#    c. Create bar chart
#    d. Create scatterplot

library(readxl)
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
lungcap=read_excel("LungCapData.xls")
colnames(lungcap)

hist(lungcap$Height)
barchart(lungcap$Height)
ggplot(data=lungcap,aes(x=Height,y=Age))+geom_point()


#2.) a.) Load iris dataset
#    b.) Create bwplot
#    c.) Create a 3d plot

data("iris")
dim(iris)
colnames(iris)
bwplot(~Petal.Length|Species,data=iris)
scatterplot3d(x=iris$Petal.Length,y=iris$Sepal.Width,z=iris$Species)


