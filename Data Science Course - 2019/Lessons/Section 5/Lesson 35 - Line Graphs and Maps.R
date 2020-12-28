#Lesson 36 - Line Graphs and Maps
install.packages("RColorBrewer")
library(RColorBrewer)

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
infy=read.csv("INFY.csv")
head(infy)
dim(infy)
colnames(infy)
str(infy)
View(infy)

par(mfrow=c(1,1))
plot(High~Low,data=infy,type='l',main="High vs. Low",ylab="")
mtext(side=4,at=infy$Open[infy$Open],text="Open Price")

#adds another line to a graph
lines(infy$High~infy$Adj.Close,lwd=2,col="red")


install.packages("maps")
library(maps)
#Displays entire world
map()

map("france")
map("usa",fill=TRUE,col=heat.colors(256))
