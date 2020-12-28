#Time Series Analysis and Forecasting - 02.27.2020

#Determining the Method of Forecasting
#1.) Qualitative Forecasting Methods
# if no data is available, the forecast is based on judegement of experts

#2.) Quantitative Forecasting Methods
# forecast is based on historical data and analytics

# Quantitiative Models
# a.) Linear Models: Simple Models, Exponential Smoothing, ARIMA, Seasonal Decomposition
# b.) NonLin Models: Neural Nets, Support Vector Machines, Clustering

#Simple Linear Models: LOCF, Drift, Mean, 
#a.) use them to model random data with no pattern
#b.) benchmark for other models

#Exponential Smoothing
#trend and seasonality are key determinants
#can put more weight on recent obs

#ARIMA models
# explains patterns in data based on autoregression

# ARIMA(2,1,2)
#2 steps of autogression
#1 step of differencing
#2 steps of moving average

#Seasonal Decompoisition
# dataset needs to be seasonal or at least have a frequency
# min number of 2 seasonal cycles

#############################################
#Non-Linear Models

#Neural Nets
#tried to model the brain's neuron system
#input vector is compressed to several layers
#usually leads to autoregressive model
#each layer consists of multiple neurons
#weight of importance may be ascribed to each neuron
#amount of required layers is specified by dataset

#SVMs
#not as common

#Clustering
#library: kml


#THESE ARE THE MAIN TYPES OF MODELS YOU WILL COME ACROSS IN TIME SERIES
#most of the time it will be a linear model that is best


#######################################
#Decomposing Time Series - Lecture 2
#seasonal decomposition decomposes the seasonal time series 
#data to its components

#you divide data into trend, seasonlity, and remainder (random data)

#Additive Method: adds components up, constant seasonal component
#Multiplicative Method: multiples components

#Drawbacks of Seas. Decomp.:
#1.) N/A values
#2.) slow to catch sudden changes
#3.) constant seasonality

#Example of Decomposing Time Series
plot(nottem)
#we can use an additive model because the amplitude (up and down) is constant
#peaks stay roughly in one line, no trend

frequency(nottem)
#12
length(nottem)
#240 (20*12)

decompose(nottem,type='additive')
#Plots each component of the time series
plot(decompose(nottem, type='additive'))

#Same plot but from ggplot, looks a little nicer
autoplot(decompose(nottem, type='additive'))


#Alternatively the function stl could be used
plot(stl(nottem, s.window='periodic'))

#Seasonal adjustment
mynottem=decompose(nottem,'additive')
class(mynottem)

#we are subtracting the seasonal element
nottemadjusted=nottem-mynottem$seasonal


#getting a plot
plot(nottemadjusted)
#lacks clear seasonal interval - looks like random ts, no trend

#as a comparison - lets plot seasonal componenet
plot(mynottem$seasonal)

#a stl forecast from package forecast
library(forecast)
plot(stlf(nottem,method='arima'))


#Exercise - Seasonal Decomposition

#1.) Get plot of dataset 'AirPassengers', describe dataset
plot(AirPassengers)

#definitely trend
#definitely seasonality
#non-constant variance
frequency(AirPassengers)
#12

#2.) Set up two decomposition models with decompose() 
#    a. Additive model - mymodel1
#    b. Multiplicative model - mymodel2

mymodel1=decompose(AirPassengers,'additive')
mymodel2=decompose(AirPassengers,'multiplicative')

#3.) Plot and compare 2 models
plot(mymodel1)
#constant increase over time - trend, some pattern left in remainder, 
#not a good sign - want all patterns to be in model
plot(mymodel2)
#similar to mymodel1


#4.) Produce and plot a ts of seasonality adjusted mymodel1
#compare to original dataset
plot(mymodel1$trend+mymodel1$random)
#wanted to pull seasonality out of data

#this confirms seasonal part of model needs improvement
#no clear answer - we need a more complex model




#02.28.2020 --> Smoothing the data

#getting the dataset closer to the center by evening out the highs/lows
#decreasing the impact of extreme values
#Classic example of smoother: Simple Moving Average

#How does it work?
#Define number of obs to use and take average
#Period = successive values of a time series

library("TTR")
x=c(1,2,3,4,5,6,7)
SMA(x,n=3)
#NA NA 2 3 4 5 6
#not enough data for calculation - only when we had 3 values 
#can a SMA be calcualted

lynxsmoothed=SMA(lynx,n=4)
lynxsmoothed

#we can compare the smoothed vs. the original lynx data
par(mfrow=c(2,1))
plot(lynx)
plot(lynxsmoothed)
par(mfrow=c(1,1))

#change n to longer period to get more smoothing effects
#higher n --> less white noise


#Exponential Smoothing
#describe ts with 3 parameters:
#1.) Error: additive, multiplicative (x>0)
#2.) Trend - non-present, additive, multiplicative
#3.) Seasonality - non-present, additive, multiplicative

#Values are either summed up, multiplied, or omitted

#Parameters can be mixed - eg: additive trend with multiplicative seasonlity:
#Multiplicative Holt-Winters Model

#Expon. Smooth --> recent data is given more weight than older obs
#1.) Simple Exponential Smoothing --> ses() : for datasets without trend and seasonality
#2.) Holt linear exponential smoothing model --> holt() : for datasets with a trend and w/out seasonlity
#3.) Holt Winters seasonal exponential smoothing --> hw(): for data with both trend and seasonal component

#Above models are set manually
#Automated model selection via ets() --> R chooses the best model

#Smoothing coefficients manage weighting based on the timestamp
#reactive model relies heavily on recent data - high coefficient ~1
#smooth model - low coefficient ~0\

#Coefficient:
#alpha = initial level
#beta = trend
#gamma = seasonality
# phi = damped parameter

library(forecast)

etsmodel=ets(nottem)
etsmodel
#ETS(A,N,A)
#error, trend, seasonality
#additive, no trend, additive seasonlity

plot(nottem,lwd=3)
lines(etsmodel$fitted,col="red")
#fitted values are pretty close to original obs -->ets function did a good job

#Plotting the forecast
plot(forecast(etsmodel,h=12))
plot(forecast(etsmodel,h=12,level=95))
#Manually setting the ets model
etsmodmult=ets(nottem,model="MZM")
etsmodmult


#Plot as comparison
plot(nottem,lwd=3)
lines(etsmodmult$fitted,col="red")
