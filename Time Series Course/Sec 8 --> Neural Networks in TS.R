#Neural Networks in Time Series - 03.11.2020
#General Idea: If you many input values to get one output value
#thats basically a linear regression

#NN has hidden layer(s) between input and output values

#NNAR - Neural Network Autoregression Model
#p lagged values as input
#k nodes are present in hidden layer as nodes
#Output --> NNAR(p,k)

#NNAR --> Neural Network Autogression Model on Seasonal Dataset
#p lagged values as input
#k nodes are present
#Seasonal: NNAR(p,P,k)

#P --> seasonal lag

#Number of input values (p) is selected with information criteria (eg: AIC)
#Seasonal lag (P) can be set manually or default of P=1 is used

#Neural net models have a random component
#-->Run the model several times (20 or more)
#Aggregate the results (eg: mean or median) of the repetitions to
#get the final result

#Remove trend component before modeling
#NNs do not do well with data w/ trends

setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Time Series Course")
data=read.csv(file="original031120.csv")
dim(data)
#1041   3
head(data)
frequency(data)

#----------Implementation of NNs in R----------#
#Function: nnetar()
myts=ts(data$watt,frequency=288)
plot(myts)
#clear seasonality

set.seed(34)
library(forecast)
fit=nnetar(myts)
#default arguments: 1 seasonal lag, 20 repetitions, 1 hidden layer

#computationally expensive to calculate intervals for all 400 points --> so thats why PI=F
nnetforecast=forecast(fit,h=400,PI=F)
library(ggplot2)
autoplot(nnetforecast)

#Model: NNAR(14,1,8)
#last 14 lags 
#1 seasonal lags
#8 nodes (or neurons) in hidden layer
#M(frequency)=288


#----------Implementing an External Regressor - MVT NN----------#
#Feeding multiple variables into NNAR models
#a.) variables have to be numeric (no factors or characters)
#b.) variable + external regressor (unidirectional effect)

#Using an external regressor in NN
fit2=nnetar(myts,xreg=data$appliances)


#When ever you use external reg for forecasting you also need
#the variable values for forecast period without reg data present 
#you cannot get the forecast

#Defining the vector which we want to forecast
y=rep(2,times=12*10)

nnetforecast=forecast(fit2,xreg=y,PI=F)
library(ggplot2)

autoplot(nnetforecast)
#you can add multiple external regressors using the xreg model and c()

