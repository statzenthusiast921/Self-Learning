#Lesson 38: More GGPLOT 2 Commands
library(readxl)
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
lungcap=read_excel("LungCapData.xls")

dim(lungcap)

#First portion shows what were graphing
#Second portion shows what kind of chart were making

#Chart #1: Barplot with intensity levels displayed by Age
ggplot(data=lungcap,aes(x=Smoke,y=LungCap,fill=Age))+geom_bar(stat="identity",position="dodge")

#Chart #2: removing fill argument just makes two boring bars
ggplot(data=lungcap,aes(x=Smoke,y=LungCap))+geom_bar(stat="identity",position="dodge")

#Chart #3: same as first chart but the addition of coord_flip argument 
#makes chart horizontal
ggplot(data=lungcap,aes(x=Smoke,y=LungCap,fill=Age))+geom_bar(stat="identity",position="dodge")+coord_flip()


ggplot(data=lungcap,aes(x=Gender,y=LungCap,fill=Age))+geom_boxplot()
ggplot(data=lungcap,aes(x=LungCap,fill=Age))+geom_density()
