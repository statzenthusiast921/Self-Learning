#Name: Jon Zimmerman
#Date Last Edited: 01/24/2020
#Purpose: TS Load Data

#---------------------------------------------------------------------------------------#
setwd("C:\\Users\\Jon Zimmerman\\Desktop")
myts=read.csv("ITstore-bidaily.csv",sep=";")
dim(myts)
#143  2
colnames(myts)[which(names(myts)=="X1")]="Time"
colnames(myts)[which(names(myts)=="X203")]="Value"

#2 obs per day
#Convert counts to time series
mycounts=ts(myts$Value,start=1,frequency=12)

#Visualization
plot(mycounts,ylab="Customer Counts",xlab="Weeks")


#Bidaily Plots - 12 total - single time units within season pattern
install.packages("forecast")
library(forecast)
monthplot(mycounts,labels=1:12,xlab="Bidaily Units")


#Season Plot - compare seasons - used to compare seasonal units (12 business weeks)
seasonplot(mycounts,season.labels=F,xlab="")

#No-trend in dataset, but clear seasonal pattern
#Need to fit a model that captures seasonality
#Simple models are excluded

#Choosing Suitable Model
#1.) Exponential smoothing 
#2.) Seasonal ARIMA

#Simplicity of data means comlicated models would be overkill, 
#simple method would be too primitive

#Seasonal ARIMA based on linear assumption
#forecast will be constant for fhe forecasted weeks
#data doesnt show any exponential character
#no trend is present

#Model forecast
plot(forecast(auto.arima(mycounts)))
