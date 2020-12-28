#Time Series Udemy Course Sec. 3
#Date: 02/02/2020
#Who are you: Jon (me)
#--------------------------------

lynx
class(lynx)
#ts

#ts --> time series class
#its just a vector of values with a time stamp
#used for univariate time series
#models, graphs, functions, even packages(eg: forecast) wont work if not ts

#Extension of ts: mts class (multivariate)
#Class xts --> no regular spacing is required; often used for financial data (irregular)

#NOTE:ts class needs regular data, time stamp needs regular interval
#if one value missing, wont work

#Let's create a time series object - class ts
mydata=runif(n=50,min=10,max=45)
mydata

mytimeseries=ts(data=mydata,start=1956,frequency=4)
plot(mytimeseries)

#Check the class
class(mytimeseries)

#Check the timestamp
time(mytimeseries)

#Tweaking the Time Stamp
#what if data starts on 3rd month, 14th day
#use start and c()

#use the 'start=' argument with the concatenate function c()

#start=c(1956,3) --> makes the time stamp start at the third quarter
#of 1956 (if the frequency is 4)

#Refining the start argument
mytimeseries=ts(data=mydata,start=c(1956,3),frequency=4)
mytimeseries


#Time Stamp Combinations
#1.) Hourly measurements with daily patterns, start at 8am on first day
#   start=c(1,8),frequency=24
#2.) Measurements taken twice a day on workdays with weekly patterns,
#start at the first week
#   start=1, frequency=10
#   NA for holidays - regular spacing
#3.) Monthly measurements with yearly cycle --> frequency =12
#4.) Weekly measurements with yearly cycle --> frequency =52



#Exercise 1: Get a random walk (x) of 450 numbers (eg: rnorm(), runif())
set.seed(1)
mydata=runif(n=450,min=26,max=36)
#Exercise 2: Add time component (y): a monthly dataset starting in November 1914
mytimeseries=ts(data=mydata,start=c(1914,11),frequency=12)
mytimeseries

#Exercise 3: Get a plot of time series
plot(mytimeseries)

#Alternative plotting option
library(lattice)
xyplot.ts(mytimeseries)

#------------------------------------#
#Standard R Base plots
plot(nottem)

#Plot components
plot(decompose(nottem))

#Directly plotting a forecast of a model
install.packages("forecast")
library(forecast)
plot(forecast(auto.arima(nottem),h=5))

#If data is not classified as ts --> here's a
#plotting shortcut
vector=c(2418,2100,1580,1235,1412,738,1218,1821,1532,1199,1215)
plot.ts(vector)
#no conversion required

#Random walk
plot.ts(cumsum(rnorm(500)))
library(ggplot2)


#The ggplot equivalent to plot
autoplot(nottem)

#Ggplots work with different layers
autoplot(nottem)+ggtitle("Autoplot of Nottingham temperature data")

#Time series specific plots
ggseasonplot(nottem)
ggmonthplot(nottem)


#Exercise - Reproduce plot
library(forecast)

data=AirPassengers
seasonplot(AirPassengers,
           year.labels=TRUE,
           col=c("red","blue"),
           labelgap=0.35,
           type='l',
           bty='l',
           cex=0.75,
           main="Seasonal plot of dataset: AirPassengers")
#need to change color, no dots, label each line, title


#German Inflation Rates
mydata=scan()
plot.ts(mydata)
germaninfl=ts(mydata,start=c(2008,3),frequency=12)
plot(germaninfl)

#----------------------------------------------
#Irregular Time Series

#Interval between observations is not fixed
#Reasons: inappropriate data collection, hard/software errors,
#         nature of data is irregular

#Most modeling techniques require regular time series
#most of the rools are not able to handle differing
#gaps between the observations --> arima, smoothing

#Possible solution: aggregating the data at a particular unit of time
#   Min 1 observation per unit
#   Some info will be lost

#Dataset: irregular_sensor
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Time Series Course")
data=as.data.frame(read.csv("irregular-sensor.csv",header=FALSE))
dim(data)
head(data)

class(data$V1)
class(data$V2)

library(zoo)

#Irregular time series - multiple measurements on same day 
#and some weird gaps between measurements
#we need to standardize the dataset

#Method 1 - removing the time component
library(tidyr)
irreg.split=separate(data,col=V1,into=c("date","time"),
                     sep=8,remove=T)
irreg.split


#using only the date
sensor.date=strptime(irreg.split$date,'%m/%d/%y')

#Creating a data frame for orientation
irregts.df=data.frame(date=as.Date(sensor.date),
                      measurement=data$V2)

#Getting a zoo object
library(zoo)
irreg.date=zoo(irregts.df$measurement,order.by=irregts.df$date)
irreg.date

#Regularzing with aggregate
ag.irregtime=aggregate(irreg.date,as.Date,mean)
ag.irregtime

length(ag.irregtime)
#16 - original data had 25 rows, but now we have 16 
#dataset is now regular
#one observation per day

#Method 2 - date and time component kept
sensor.date1=strptime(data$V1,
                      '%m/%d/%y %I:%M %p')

#the last p is for PM vs. AM
#help section for function explains all
sensor.date1

#Create zoo object
irreg.dates1=zoo(data$V2,order.by=sensor.date1)
irreg.dates1
plot(irreg.dates1)


#Regularizing with aggregate
ag.irregtime1=aggregate(irreg.dates1,as.Date,mean)
ag.irregtime1
plot(ag.irregtime1)

myts=ts(ag.irregtime1)
plot(myts)


#------------------------------------------------
#Working with Missing Values/NAs and Outliers
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Time Series Course")
mydata=as.data.frame(read.csv("ts-NAandOutliers.csv",header=TRUE))
dim(mydata)
head(mydata)

#Convert 2nd column to ts
myts=ts(mydata$mydata)
myts

summary(myts)
#5 NAs

plot(myts)
#plots that look like --> you should be very suspicious
#4 potential outliers
#5 NAs
#9/250 = 3.6% corrupted observations

#Outlier detection library
#library(tsoutliers), tso()
#library(forecast), tsoutliers()

#Automatic detection of outliers
library(forecast)
myts1=tsoutliers(myts)
myts1
plot(myts)


#Missing Data Imputation
#adding a replacement value instead of missing ones
library(zoo)
myts.NAlocf=na.locf(myts)
myts.NAfill=na.fill(myts,33)
myts.NAfill

#Standard NA method in package forecast
myts.NAinterp=na.interp(myts)
myts.NAinterp

#Cleaning NA and outliers
mytsclean=tsclean(myts)
plot(mytsclean)
summary(mytsclean)
#no NAs