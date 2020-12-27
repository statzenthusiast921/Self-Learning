# Code from Session on Introduction to R

#########################################################################################

# DATA READING AND WRITING

data1  <- read.table("file1.txt", header = TRUE)
data2 <- read.table("file2.txt", header = TRUE, na.strings=".")
data3 <- read.table("file3.txt", header = TRUE, sep=",")

data1$age

data <- matrix(scan("data.dat", n = 20*10), 20, 10, byrow = TRUE)

# http://faculty.missouri.edu/~micheasa/stat7110/datasets/
A1<-read.table("http://faculty.missouri.edu/~micheasa/stat7110/datasets/fitness.dat", header=T)

read.csv("fuel.csv") 

library(gdata)
Data1.xls  <- read.xls("fuel.xls")
Data2.xls  <- read.xls("IsThereASantaClaus.xls")

library(foreign) 
Data.spss <- read.spss("HSB500.SAV",  to.data.frame = TRUE)
Data.spss

library(foreign) 
Data.stata <- read.dta("guyer.dta")
Data.stata

library(sas7bdat) 
Data.sas1 <- read.sas7bdat("airline.sas7bdat")
Data.sas1

library(SASxport) 
Data.sas2 <- read.xport("test2.xpt")
Data.sas2

A1<-read.table("http://faculty.missouri.edu/~micheasa/stat7110/datasets/fitness.dat", header=T)
write(t(A1),file="writeoutput.csv", ncolumns=7)
write(t(A1),file="writeoutput.txt", ncolumns=7)


#####################################################################################################

# DESCRIPTIVE STATISTICS AND MATRIX OPERATIONS

data1  <- read.table("CARS93.DAT")
summary(data1)
sd(data1$V4)
var(data1$V4)
cor(data1$V4, data1$V5,method = "pearson")
cor.test(data1$V4, data1$V5,method = "pearson")

sort(data1$V4) # sort in ascending order
rev(sort(data1$V4)) # sort in descending order

V <- c(1,5,6,7,9) # defining a vector.    
a<-rbind(c(1,1,1),c(2,2,2),c(3,3,3))
b<-rbind(c(1,2,3),c(1,2,3),c(1,2,3)) 
C <- a%*%b # Matrix multiplication. 
solve(C) # Matrix inverse.
c1 <- diag(5,10)
solve(c1)  
C[1,] #first row of matrix C.
C[,1] #first column of matrix C.

rbinom(100, 10, 0.3)
rpois(100, 5)
rnorm(100, mean = 10, sd = 3)
rgamma(50, shape=3,  scale = 2)
rt(100, 5)
rchisq(100, 5)
rbeta(100, 3, 2)


####################################################################################################

# PLOTS 

# Stem-n-leafs

x<-rpois(n=100,lambda=15) 
# 100 generated values from a poisson with lamda=15
x
stem(x)

# Boxplots

x=rnorm(100) # generate 100 values from a standard normal
y=rnorm(100,mean=0,sd=2) 
# generate 100 values from a normal with mean=0 and standard   deviation=2
# one and side by side boxplots with appropriate labels
boxplot(x) # one box plot
boxplot(x,y,names=c("Normal(0,1)","Normal(0,4)"), main="Side by Side Boxplots")

# Histograms

main.title="Histogram of a normal distribution"
par(mfcol=c(1,2), las=1) 
# tells R to split the graphics device into a matrix 1x2 (side by side plotting)
hist(x,ylim=c(0,35),xlim=c(-7,7),xlab="Normal(0,1)",main=main.title)
hist(y,ylim=c(0,35),xlim=c(-7,7),xlab="Normal(0,4)",main=main.title)   

#General Plotting in 2-d 

a<-scan("names.txt", list(Name="", Gender="", Age=0, Height=0, Weight=0),multi.line=T)
z<-data.frame(a)
par(mfrow=c(1,1))
plot(z$Age,z$Height,xlim=c(10,17),ylim=c(500,650))
symbols(z$Age,z$Height,circles=z$Weight,add=T)


#####################################################################################################

# T-TEST 

# One-sample t-test, data from a normal distribution

x<-rnorm(100,mean=15,sd=3)
t.test(x) # tests mean=0 at a=.05
t.test(x,mu=15,conf.level=.90)

#One-sample t-test, data from non-normal distributions, n large

y<-rpois(100,lambda=10)
t.test(y,mu=10,conf.level=.90)

z<-rbinom(150,size=10,prob=.8)
t.test(z,mu=7,conf.level=.95)

#Two independent samples t-test, data from normal distr

x<-rnorm(15,mean=3,sd=2)
y<-rnorm(30,mean=3.5,sd=3)
t.test(x, y, mu=0) # assuming un-equal variances (Welch-approx to df.)
t.test(x, y, mu=0,var.equal=T) # assuming equal variances

#Paired t-test

library(mvtnorm)
xy<-rmvnorm(15,mean=c(3,7),sigma=rbind(c(1,2.4),c(2.4,16))) 
# correlated data, using rho=.6
t.test(xy[,1],xy[,2], alternative="less", paired=T)

#Non parametric tests
x <- c(1.83,  0.50,  1.62,  2.48, 1.68, 1.88, 1.55, 3.06, 1.30)
y <- c(0.878, 0.647, 0.598, 2.05, 1.06, 1.29, 1.06, 3.14, 1.29)
wilcox.test(x, y, paired = TRUE, alternative = "greater")


x <- c(0.80, 0.83, 1.89, 1.04, 1.45, 1.38, 1.91, 1.64, 0.73, 1.46)
y <- c(1.15, 0.88, 0.90, 0.74, 1.21)
wilcox.test(x, y, alternative = "g")



#####################################################################################################

# CATEGORICAL VARIABLES 

# first create two factor objects (categorical variables)
c<-rbind(c(25,10),c(9,30))
dimnames(c)<-(list(c('Cat','Dog'),c('Dry','Wet')))
chisq.test(c) # test for independence 

fisher.test(c)


#####################################################################################################

# DISTRIBUTION ASSUMPTION CHECK 

# one sample normality check 

x <- rnorm(1000) 
ks.test(x,pnorm,0,1) # p-value not small implies normal
ks.test(x,pnorm,mean(x),sd(x)) # p-value not small implies normal

ks.test(x,pt,2) # p-value small implies not t-distribution
ks.test(x,pchisq,2) # p-value small implies not chisq-distribution

# two sample

x <- rnorm(90)
y <- rnorm(8, mean = 2.0, sd = 1)
ks.test(x, y) # testing the equality of distribution of x and y

x<-rnorm(100,3,2)
qqnorm(x)
qqline(x,col=2)

y<-rpois(15,20)
qqnorm(y)
qqline(y)

zz <- qqplot(x, y, plot = F) 
plot(zz) # plot it
abline(lm(zz$y~zz$x),col=3) # add the line from a least squares fitted regression line


######################################################################################################

# Linear Models/regressions

x<-seq(-15,100,length=100)
y<-x+rnorm(100,0,15)

fit<-lm(y~x)
summary(fit)

par(mfrow=c(2,2))
plot(fit)

resid<-residuals(fit)

# all three of these do the same thing
plot(resid)
plot(fit$residuals)
plot(residuals(fit))

# Checks for normality of residual
hist(resid)
qqnorm(resid)
qqline(resid)
ks.test(resid,mean(resid),sd(resid))


# Confidence Intervals 
par(mfrow=c(1,1))

plot(x,y)
points(x,fitted.values(fit),type="l",col=2)
cbounds<-predict(fit,se.fit=T,level=.90,interval="prediction")
points(x,cbounds$fit[,2],type="l",col=3)
points(x,cbounds$fit[,3],type="l",col=3)

cbounds<-predict(fit,se.fit=T,level=.90,interval="confidence")
points(x,cbounds$fit[,2],type="l",col=4)
points(x,cbounds$fit[,3],type="l",col=4)


x <- c(18,23,25,35,65,54,34,56,72,19,23,42,18,39,37)
y <- c(202,186,187,180,156,169,174,172,153,199,193,174,198,183,178)
lm.heart<- lm(y ~ x) # plot the regression line
summary(lm.heart)
plot(x,y) # make a plot
abline(lm.heart)

resid <- resid(lm.heart) # residuals
ks.test(resid,mean(resid),sd(resid))

# Prediction
lm.pred <- predict(lm.heart)
lm.pred
predict(lm.heart,data.frame(x= c(50,60)))

#Diagnostic plots
par(mfrow=c(2,2))
plot(lm.heart)

#Confidence interval
predict(lm.heart,data.frame(x=sort(x)), level=.9, interval="confidence")


##############################################################################################

#ANOVA

a<-scan("names.txt", list(Name="", Gender="", Age=0, Height=0, Weight=0),multi.line=T)
ourdata<-data.frame(a)
height.level<-factor( cut(ourdata$Height,breaks=c(500,550,580,600), labels=c("Short","Normal","Tall")) )
age.factor<-factor(ourdata$Age)
aovfit<-aov(Weight~height.level+age.factor, data=ourdata)
summary(aovfit)


##############################################################################################

#LOGISTIC REGRESSION

library(rpart)
kyphosis<-kyphosis

fit.kyph<-glm(Kyphosis~Age+Number+Start,family=binomial,data=kyphosis)
summary(fit.kyph)


#Odd
exp(coef(fit.kyph))

#Diagnostic plots
par(mfrow=c(2,2))
plot(fit.kyph)


#################################################################################################

#MULTINOMIAL REGRESSION MODEL

#Import data 
cmcData <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/cmc/cmc.data", stringsAsFactors=FALSE, header=F)
colnames(cmcData) <- c("wife_age", "wife_edu", "hus_edu", "num_child", "wife_rel", "wife_work", "hus_occu", "sil", "media_exp", "cmc")
head(cmcData)

# convert numeric to factors 
cmcData$wife_edu <- factor(cmcData$wife_edu, levels=sort(unique(cmcData$wife_edu)))
cmcData$hus_edu <- factor(cmcData$hus_edu, levels=sort(unique(cmcData$hus_edu)))
cmcData$wife_rel <- factor(cmcData$wife_rel, levels=sort(unique(cmcData$wife_rel)))
cmcData$wife_work <- factor(cmcData$wife_work, levels=sort(unique(cmcData$wife_work)))
cmcData$hus_occu <- factor(cmcData$hus_occu, levels=sort(unique(cmcData$hus_occu)))
cmcData$sil <- factor(cmcData$sil, levels=sort(unique(cmcData$sil)))
cmcData$media_exp <- factor(cmcData$media_exp, levels=sort(unique(cmcData$media_exp)))
cmcData$cmc <- factor(cmcData$cmc, levels=sort(unique(cmcData$cmc)))

# Prepare Training and Test Data
set.seed(100)
trainingRows <- sample(1:nrow(cmcData), 0.7*nrow(cmcData))
training <- cmcData[trainingRows, ]
test <- cmcData[-trainingRows, ]

# Build multinomial model
library(nnet)
multinomModel <- multinom(cmc ~ ., data=training) # multinom Model
summary (multinomModel) # model summary

# Prediction, confusion matrix, misclassification error
predicted_scores <- predict (multinomModel, test, "probs") # predict on new data
predicted_class <- predict (multinomModel, test)
table(predicted_class, test$cmc)
mean(as.character(predicted_class) != as.character(test$cmc))


############################################################################################

#POWER  AND SAMPLE SIZE CALCULATION

library(pwr)
#For a one-way ANOVA comparing 5 groups, calculate the sample size needed in each 
#group to obtain a power of 0.80, when the effect size is moderate (0.25) and a 
#significance level of 0.05 is employed.

pwr.anova.test(k=5,f=.25,sig.level=.05,power=.8)

#What is the power of a one-tailed t-test, with a significance level of 0.01, 
#25 people in each group, and an effect size equal to 0.75?
  
pwr.t.test(n=25,d=0.75,sig.level=.01,alternative="greater")









              

