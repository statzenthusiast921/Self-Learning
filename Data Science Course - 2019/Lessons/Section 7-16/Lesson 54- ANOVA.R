#Lesson 54 - ANOVA
library(dplyr)
library(ggplot2)
library(readxl)
library(psych)
install.packages("car")
library(car)
install.packages("zip")
library(zip)
library(foreign)
library(nlme)
install.packages("onewaytests")
library(onewaytests)
install.packages("tabplot")
library(tabplot)
install.packages("MASS")
library(MASS)
install.packages("rcompanion")
library(rcompanion)
install.packages("WRS2")
library(WRS2)


#Load the data and check it out
data=read.csv(url("https://raw.githubusercontent.com/vivekv73/LogReg/master/PLXSELL.csv"))
dim(data)
head(data)
colnames(data)
str(data)
View(data)
summary(data)


#Visualize entire dataset
tableplot(data)

#Visualize with boxplot
ggplot(data=data,aes(y=data$BALANCE,x=data$OCCUPATION))+geom_boxplot(aes(col=data$OCCUPATION))+labs(title="Boxplot of Balance for all occupation types")


#Normality Test
#select subset of 5000 rows
fivethd=data[1:5000,]


shapiro.test()
unique(data$OCCUPATION)
subset1=subset(fivethd,fivethd$OCCUPATION=="PROF")
subset2=subset(fivethd,fivethd$OCCUPATION=="SAL")
subset3=subset(fivethd,fivethd$OCCUPATION=="SELF_EMP")
subset4=subset(fivethd,fivethd$OCCUPATION=="SENP")
shapiro.test(subset1$BALANCE)
shapiro.test(subset2$BALANCE)
shapiro.test(subset3$BALANCE)
shapiro.test(subset4$BALANCE)

#Test of Equal Variance
leveneTest(data$BALANCE~data$OCCUPATION,data=data)

#ANOVA Model
ANOVA=aov(data$BALANCE~data$OCCUPATION,data=data)
summary(ANOVA)

#Post-HOC test
tukey_HSD=TukeyHSD(ANOVA)
tukey_HSD
plot(tukey_HSD)


###############
#Two Way ANOVA#
###############
anova2way=aov(data$BALANCE~data$OCCUPATION+data$GENDER+data$OCCUPATION*data$GENDER)
summary(anova2way)

tukey_hsd2=TukeyHSD(anova2way)
tukey_hsd2
plot(tukey_hsd2)


#interaction plot
interaction.plot(data$GENDER,data$OCCUPATION,data$BALANCE)
