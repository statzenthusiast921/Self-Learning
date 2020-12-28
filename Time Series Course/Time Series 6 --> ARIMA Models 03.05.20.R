#03.05.20 --> ARIMA Models

#ARIMA(p.d.q)

#AR --> Autoregressive part: p
#I  --> Integreation, degree of differencing: d
#MA --> Moving average part: q

#Calculating the AR and MA parts require a stationary time series

#manual differencing with diff()

#How to calculate the three parameters:

#1.) arima() --> estimates parameters by using ACF and PACF plots
#2.) auto.arima() --> calculate parameters automatically and choose suitable model

#When to use ARIMA model?
#1.) flexible, very general model
#2.) not great for seasonal datasets (better to use exponential smoothing or seasonal decomposition)

#How to read an ARIMA model?

#1.) Summation of lags = autoregressive part
#2.) Summation of forecasting errors = moving average part
#3.) coefficient: determines importance of specific lag
#eg: AR(1) or ARIMA(1,0,0) --> first order lag of AR
#eg: AR(2) or ARIMA(2,0,0) --> second order AR --> interested in lags 1 and 2
#eg: MA(1) or ARIMA(0,0,1) --> first order MA

#What does the model look like?

# AR(1) OR ARIMA(1,0,0) --> Y_t = c + p(Y_t-1) + e_t

#ARMA(1,1) or ARIMA(1,0,1) --> Y_t = c + p(Y_t-1) + p(e_t-1) + e_t

#Random Walk --> ARIMA(0,1,0)
#Differencing --> Y_t - Y_t-1 = c + e_t

#ARIMA sometimes referred to as Box-Jenkins 


#---------------------------------------------------------#
plot(lynx)
library(forecast)

#Gets us ACF and PACF plots
tsdisplay(lynx)

#ACF - several lags outside range
#PACF - first 2 lags outside range - at least AR(2)
#top plot tells us if we need differencing --> we need diff with non-stat ts
#statistcal properties change over time is what happens with non-stat

auto.arima(lynx)
#ARIMA(2,0,2)

#Mean=1544.4039 --> same as intercept

#Seasonal ARIMA models
#ARIMA(p,d,q) (P,D,Q)

#lowercase for standard model parameters
#uppercase for seasonal model parameters
#if non-seasonal, upper case parameters not present

auto.arima(lynx,trace=T)
#trace argument gives you multiple models to choose from

#truncate argument allows you to discard part of your data if you think it doesn't matter

#DO THIS --> Recommended setting
auto.arima(lynx,trace=T,stepwise=F,approximation=F)
#we get an even lower AICc with ARIMA(4,0,0)

#compare ic against old ARIMA model (2,0,2) --> 
#ic for ARIMA(4,0,0) is lower than ARIMA (2,0,2)


# ARIMA Notes 03.06.2020
#Lynx dataset: ARIMA(2,0,0)
#same as ARMA(2,0) and AR(2)
#Autoregressive model explains the future by regressing on the past:
#a.) goes back in time
#b.) checks its own results
#c.) performs a forecast
#AR(2) model
myarima=arima(lynx,order=c(2,0,0))
#Limitations and Bugs of arima() function:
#it does not compute constants if differencing is required
#no middle parameter - no differencing - so not an issue
myarima
#This is what the model looks like:
#Y_t = c + p1(Y_t-1) + p2(Y_t-2) + e_t
#p1= coefficient
#Y_t-1 = lag 1
#t= time in years
#y= amount of lynx trapped in year
#present year's catches = constant +
# (coefficient1*last years catches) +
# (coefficient2*2 years ago catches) +
# current error term
#Explain last obs values
tail(lynx)
# 3396 = c +1.147(2657)-0.599(1590) +e_t
#intercept = 1545.4458 = mean of model (NOT C the constant)
#We need to subtract this term (mean) from all autoregressive terms
#3396-1545.45
#2657-1545.45
#1590-1545.45
#Model actually needs to be written like this:
#(Y_t)-u = p1((Y_t-1)-u) + p2((Y_t-2)-u) + e_t
#What about the error term?
residuals(myarima)
#601.83 --> last obs (current value)
#Check the results:
# 3396 = c +1.147(2657)-0.599(1590) +e_t
#(Y_t)-u = p1((Y_t-1)-u) + p2((Y_t-2)-u) + e_t
#Model portion (RH):
(1.147*(2657-1545.45))+(-0.599*(1590-1545.5))+601.83
#1850.122
#Response portion(LH):
3396-1545.45
#1850.55

#MA(2) Model:
myarima=arima(lynx,order=c(0,0,2))
myarima
#This is what the model looks like:
#Y_t =c + p1(e_t-1) + p2(e_t-2) + e_t
#Y_t = present year's catches
#C = constant
#e_t-1 = error term 1 lag
#forecast terms have been replaced with residuals
#3396 - 1545.36 = (1.1407*e_t-1) + (0.4697*e_t-2) +e_t
residuals(myarima)
#need to take last three residuals
#Check the equation for MA(2)
(1.1407*844.72)+(0.4697*255.911)+766.83
#1850.604
3396-1545.37
#1850.63
#MATCHES!
#DIFFERENCING = subtract consecutive obs from each other
#FORECASTING = error terms and autoregressive terms need to be estimated prior to modelling
#-----------------------------------------------#
#Simulating ARIMA based ts with R
#arima.sim() --> generates time series based on provided ARIMA model
#Key step before you begin with any sort of simulations or randomly generate dataset:
#make it reproducible
#N argument = number of obs produced in ts
#make the n argument at least 1000

#specify the mean by adding numeric value
set.seed(123)
#Simulation of at least n=1000
asim=arima.sim(model =list(order=c(1,0,1),
                           ar=c(0.4),
                           ma=c(0.3)),n=1000)+10
plot(asim)
#NO TREND, NO SEASONALITY, NO OBVIOUS PATTERN
#Let's smooth the plot out more
library(zoo)
plot(rollmean(asim,50))
plot(rollmean(asim,25))
#seasonality or trend not present
#Let's check for stationarity
library(tseries)
adf.test(asim)
# Pval <0.05 --> STATIONARY
#no middle parameter - no differencing so that makes sense
#We need this plot to identify p and q parameters
library(forecast)
tsdisplay(asim)
#significance with first 2 lags for both ACF and PACF plots
#so maybe we could go up to a ARIMA(2,0,2), but we did start with ARIMA(1,0,1)
#Let's use auto.arima() to confirm
auto.arima(asim,trace=T,
           stepwise=F,
           approximation=F)
#output confirm ARIMA(1,0,1) and the mean 10
#ar1=0.3494 --> we started with 0.4
#ma1=0.3183 --> we started with 0.3
#so our simulation was modelled fairly close to what we started with
#depending on different criteria, we could end up with different model

#--------------------------------------------#
#Picking a function for ARIMA modeling
#ts analysts sometimes advise against using auto.arima() --> they may be biased
#arima() --> constant is not clacualted if a differencing step is required
#Arima() --> if middle parameter d in model --> this is the function to use
#ARIMA parameter selection
library(tseries)
adf.test(lynx)
#pval <0.05 --> STATIONARY --> middle parameter d =0
library(forecast)
tsdisplay(lynx)
#PACF is the indicator for AR part of model
#first two lags in PACF significant --> indicates we should first try ARIMA(2,0,0)
myarima=arima(lynx,order=c(2,0,0))
myarima
#check residuals --> should be no more autoregression in them
#residuals should be random, normally distributed
dev.off
checkresiduals(myarima)
#most important thing -->ACF
# shows significance lags 7,9, 19
#if sig. lags early --> clear model needs to be adjusted, this is a borderline case
#let's increase parameter p
myarima=arima(lynx,order=c(3,0,0))
checkresiduals(myarima)
#aicc --> increased -->disqualifies this model as better
#Try again
myarima=arima(lynx,order=c(4,0,0))
checkresiduals(myarima)
#aicc --> lowest --> clear improvement
#check residuals --> all lags within residuals --> autoregression seems to be eliminated
#residuals close to normally distributed
#Try one more time to make sure this is okay
myarima=arima(lynx,order=c(5,0,0))
checkresiduals(myarima)
#aicc --> higher, not improvement
#significant pval in ljung-box test --> no normal distribution of residuals
#THUS NOT IMPROVEMENT to AR(4)
#let's stick with AR(4) or ARIMA(4,0,0)

#NOW LET's SIMULATE an MA time series
set.seed(123)
myts=arima.sim(model=list(order=c(0,0,2),
                          ma=c(0.3,0.7)),
               n=1000)+10
adf.test(myts)
#pval<0.05 --> STATIONARY --> no differencing step, d=0
tsdisplay(myts)
#plenty of bars of PACF outside threshold
#ACF plot seems more reasonable - first 2 bars outside boundaries
#you start modeling parameters with fewer bars outside boundaries
#ACF --> indicates MA parameter
#PACF --> indicates AR parameter
#let's start with ACF
#let's start with order 2
myarima=Arima(myts,order=c(0,0,2))
myarima
#AICc=2828.28
checkresiduals(myarima)
#ljung-box test pval >0.5 --> normal residuals
#histogram fits normal distribution quite well
#only one lag on ACF outside of range
#can we improve this model with one more MA term?
myarima=Arima(myts,order=c(0,0,3))
myarima
#AICc=2829.87 -->HIGHER, NO!
checkresiduals(myarima)
#not much has changed, not an improvement
#let's confirm our result with auto.arima function
auto.arima(myts,trace=T,
           stepwise=F,
           approximation=F)
#auto.arima() gets to same conclusion
#simulation worked and we identified proper model
#may not be clear in real world, but in general its good practice to follow these steps:
#1.) Test for stationarity --> adf.test()
#2.) Test for autoregression --> acf(), pacf(), tsdisplay()
#3.) Set up ARIMA model
#4.) Check AICc
#5.) Check residuals
#6.) Adjust parameters based on results of steps 4 and 5
#7.) Optional: run auto.arima() on dataset to confirm results


#----------------ARIMA Notes 03.07.2020----------------#
#Rules for finding the right number of differencing steps
#Add +1 step to d if high numbers of significant lags are present in PACF
#this process avoids a high p parameter

#no further differencing is required if:
# non-significant 1st lag in PACF
# autocorrelation in PACF appears random

#What the order of 'd' tells about the data:
#0 --> stationary data (constant)
#1 --> trending data (constant trend)
#2 --> varying trend (no constant trend)

#Add +1 step to 'p' if PACF plot shows:
# a.) Positive significant lag 1
# b.) Sharp cutoff between significant and non-significant lags

#Add +1 step to 'q' if ACF plot shows:
# a.) negative significant lag 1
# b.) sharp cutoff between significant and non-significant lags

#AR and MAR correlate --> test them individually

#Add a differencing step 'd' if summation of coefficients (AR or MA)
# is close to 1

#------Rules for Identifying Seasonal Parameters-----#
#Get ACF and PACF plots for minimum 3 full seasonal cycles + extra buffer
#40 lags should give you reasonable picture

#Set D to 1 if strong seasonal pattern is present
#in general --> best not to use more than 1 diff step for seasonal D

#Add +1 to P if positive significant lag is present in all seasonal cycles
#Add +1 to Q if negative significant lag is present in all seasonal cycles

#Positive autocorrelation likely occurs:
#dataset with non-constant seasonal effect and no seasonal differencing

#------------------ARIMA Forecasting------------------#

myarima=auto.arima(lynx,stepwise=F,approximation=F)
myarima

#Forecast of 10 years
arimafore=forecast(myarima,h=10)
plot(arimafore)

#no seaonality, but forecast does capture trend

#See the forecasted values
arimafore$mean

#Plot last observations and the forecast
plot(arimafore,xlim=c(1930,1944))

#ETS for comparison
myets=ets(lynx)
etsfore=forecast(myets,h=10)

#Comparison plot for 2 models
library(ggplot2)
autoplot(lynx) +
  forecast::autolayer(
    etsfore$mean,
    series='ETS Model') +
  forecast::autolayer(
    arimafore$mean,
    series='ARIMA Model') +
  xlab('year') +
  ylab('Lynx Trappings') +
  guides(
    colour=guide_legend(
      title='Forecast Method'))+
  theme(
    legend.position=c(0.8,0.8))

#ARIMA model is better for this dataset
#maybe also look at model accuracy to confirm


#----------ARIMA with Explanatory Variables----------#
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Time Series Course")
cyprinidae=read.csv("original.csv",header=TRUE)
dim(cyprinidae)
#250  3
head(cyprinidae)

table(cyprinidae$predator_presence)
#FALSE  TRUE
#242    8

#Is there a correlation between the hormone concentration
#and the presence of the predatory fish?
library(ggplot2)
ggplot(cyprinidae,
       aes(y=concentration,
           x=X)) +
  geom_point() + 
  aes(color=predator_presence)

  
#high dots --> time points where predatory fish present
  
  
#Convert the variables into time series
x=ts(cyprinidae$concentration)
y=cyprinidae$predator_presence
y=ifelse(y==TRUE,1,0)
table(y)

#Create my ARIMA model
mymodel=auto.arima(x,xreg=y,
                   stepwise=F,
                   approximation=F)
mymodel
#zero parameter model --> constant mean model --> indicates hormone concentration constant over time as long as no predator present

#as soon as predator shows up --> concentration jumps up by 255 nanograms(whatever the unit is)

#Quick check of model quality
checkresiduals(mymodel)

#want to find all patterns in model, randomness in residuals

#Expected predator presence at future 10 time points
y1=c(1,1,0,0,0,0,1,0,1,0)

#Getting a forecast based on future predator
plot(forecast(mymodel,xreg=y1))
#Zoom in on the end
plot(forecast(mymodel,xreg=y1),xlim=c(230,260))
