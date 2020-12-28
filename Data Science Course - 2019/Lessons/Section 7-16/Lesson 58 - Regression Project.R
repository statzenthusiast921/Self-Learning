#Lesson 58 - Linear Regression Project

#1.) Load the auto dataset
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
auto=read.csv("auto-mpg.csv")

#2.) Make some charts to display variables' behaviors
tableplot(auto)
pairs(auto)
unique(auto$model.year)

ggplot(data=auto,aes(y=auto$mpg,x=as.factor(auto$model.year)))+geom_boxplot(aes(col=as.factor(auto$model.year)))
plot(auto$acceleration,auto$mpg)
plot(as.numeric(auto$horsepower),auto$mpg)


#3.) Simple Linear Regression
mod1=lm(auto$mpg~auto$acceleration)
summary(mod1)

#Plot Regression line
lmplot=ggplot(data=auto,aes(x=acceleration,y=mpg))+geom_point()
lmplot=lmplot+geom_smooth(method='lm',col='red')
lmplot+geom_smooth()

#red - regression line
#blue - smoothed line

#Plot residuals vs. fitted
plot(mod,which=1,pch=11)

