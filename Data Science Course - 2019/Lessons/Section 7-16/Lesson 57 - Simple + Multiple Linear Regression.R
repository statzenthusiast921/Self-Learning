#Lesson 57: Simple Linear Regression

library(car)
library(ggplot2)
library(tabplot)
install.packages("corrplot")
library(corrplot)
library(scatterplot3d)
library(dplyr)


#Load the data and check it out
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
auto=read.csv("auto-mpg.csv")
dim(auto)
head(auto)
str(auto)
summary(auto)

par(mfrow=c(1,2))
hist(auto$mpg)
hist(auto$displacement)

tableplot(auto[,-9])
pairs(auto)

par(mfrow=c(1,1))
ggplot(data=auto,aes(y=auto$weight,x=auto$mpg))+geom_boxplot(aes(col=mpg))+labs(title="Boxplot for Weight by Mpg")
plot(auto$weight,auto$mpg)
plot(auto$mpg,auto$wight)


#Regression
mod=lm(mpg~weight,data=auto)
summary(mod)


#Plot Regression line
lmplot=ggplot(data=auto,aes(x=weight,y=mpg))+geom_point()
lmplot=lmplot+geom_smooth(method='lm',col='red')
lmplot+geom_smooth()

#red - regression line
#blue - smoothed line

#Plot residuals vs. fitted
plot(mod,which=1,pch=11)


#Multiple Linear Regression
mod2=lm(mpg~weight+displacement+acceleration,data=auto)
summary(mod2)


new.auto=auto[,1:5]
head(new.auto)
new.auto$horsepower=as.numeric(new.auto$horsepower)
new.auto$cylinders=as.numeric(new.auto$cylinders)
str(new.auto)


# Cool looking correlation plot
cor.plot=cor(as.matrix(new.auto))
corrplot(cor.plot)
corrplot(cor.plot,method="number")

#Plot Residuals vs. Fitted
plot(mod2,pch=16,which=1)

