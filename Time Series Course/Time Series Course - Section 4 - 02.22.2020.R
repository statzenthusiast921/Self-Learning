#Time Series Notes - 02.21.2020
#Basic Forecasting Methods
#Simple forecasting methods can outperform more advanced models in certain circumstances
#General rules:
#a.) For mostly or completely random data, simple methods work best
#b.) Advanced models exploit patterns (eg: seasonality, trends) better
#With stock or financial data - primitive models do well
# 3 models
#1.) Naive method
#a.) Naive - last observation carried forward method;
#    projects last observation into future
#    use naive() function in 'forecast' package
#    can be tweaked to fill a seasonal dataset

#b.) Average method
#    calculates mean of data and projects that into future
#    use the meanf() function from 'forecast' package
#c.) Drift method
#    calculate difference between first and last observation;
#    carries that increase into future
#    use function rwf() function from 'forecast' package
set.seed(95)
#contains 200 random normally distributed numbers, starting in yr 1818
myts=ts(rnorm(200),start(1818))
#no pattern
plot(myts)
#Use 3 methods and compare by forecasting data 20 years
library(forecast)
meanm=meanf(myts,h=20)
naivem=naive(myts,h=20)
driftm=rwf(myts,h=20,drift=T)
plot(meanm,plot.conf=F,main="")
lines(naivem$mean,col=123,lwd=2)
lines(driftm$mean,col=22,lwd=2)
legend("topleft",lty=1,col=c(4,123,22),
       legend=c("Mean method",
                "Naive method",
                "Drift method"))

#----------Model Comparison----------#
#Ideally --> determine difference between actual value and forecast (residual)
#Simplest method - scale dependent error - all models you want
#to compare need to be on the same scale (eg: MAE, RMSE)
#1.) Mean Absolute Error (MAE)
#mean of all differences between actual and forecasted absolute values
#(kind of like average of residuals)
#2.) Root Mean Squared Error
# sample standard deviation of differences between actual and
# forecasted values
#3.) Mean Absolute Scaled Error (MASE)
#measures forecast error compared to error of naive forecast
# 0<x<1
# x=1   --> naive forecast (always picing last value observed)
# x=0.5 --> model has double the prediction accuracy as naive last value approach
# x=1   --> model needs a lot of improvement
#4.) Mean Absolute Percentage Error (MAPE)
#measures difference of forecast errors and divides by actual observation
# does not allow for 0 values
# put more weight on extreme values and positive errors
# scale independent - you can use it to compare models of different datasets
#5.) Akaike Information Criterion (AIC)
# common measure in forecasting, statistical modeling/ML
# great to compare complexity of diff models
# penalizes more complex models
# lower AIC score is better

set.seed(95)
myts=ts(rnorm(200),start(1818))
#Make a training dataset
mytstrain=window(myts,start=1,end=170)
plot(mytstrain)

library(forecast)
meanm=meanf(mytstrain,h=30)
naivem=naive(mytstrain,h=30)
driftm=rwf(mytstrain,h=30,drift=T)
mytstest=window(myts,start=170)
accuracy(meanm,mytstest)
accuracy(naivem,mytstest)
accuracy(driftm,mytstest)


#----------Residuals----------#
# you want all patterns in model, only randomness should stay
# in residuals

# residuals should be the container of randomness (data you cannot
# explain in mathematical terms) --> ideally mean=0 and constant variance

# residuals should be uncorrelated --> normal distribution

# correlations can be extracted via modeling tools (eg: differencing)
# diff - ensures normal distribution (constant var) might be impossible
# in some case, transformations though might help

var(meanm$residuals)
#1.0124
mean(meanm$residuals)
#0.00000000000

naivewithoutNA=naivem$residuals
naivewithoutNA=naivewithoutNA[2:168]
var(naivewithoutNA)
#1.759
mean(naivewithoutNA)
#-0.0026

driftwithoutNA=driftm$residuals
driftwithoutNA=driftwithoutNA[2:168]
var(driftwithoutNA)
#1.759
mean(driftwithoutNA)
#-0.003


#Plot the residuals --> its normal
hist(driftm$residuals)

#Autocorrelation Plot
acf(driftwithoutNA)
#if several bars above or below threshold levels - then we have autocorrelation
#5 bars outside threshold - means model could be improved
#significant autocorrelation
#might need to use a transformation


#----------Stationarity----------#

#1.) Does the data have the same statistical properties throughout the ts?
#      eg: variance, mean, autocorrelation

# most analytical procedures in ts require stationary data
# if data lacks stationary - transformation can be applied to data
# to make it stationary or it can be changed via differencing

# differencing adjusts data according to the time spans tht differ in
# variance or mean (extensively used in ARIMA models)

#----------De-trending

# Many ts have a trend in it --> mean changes as a result of the trend,
# causes underestimated predictions

#Solution:
#1.) Test if you get stationarity if you de-trend the dataset -->
#    take the trend component out of the dataset --> trend stationarity

#2.) If the procedure is not enough then you can use differencing -->
#     difference stationarity

#3.) Unit-root tests tell whether there is a trend stationarity or a difference
# stationarity

#  the first difference goes from one period to the very next one (2 successive steps)

#1st difference is stationary and random --> you have a random walk (each value
# is a random step away from the previous value)

#1st difference is stationary but not completely random (eg: values are auto correlated)
# requires a more sophisticated model (eg: exponential smoothing, ARIMA)

x=rnorm(1000) #no-unit root, stationary
library(tseries)
adf.test(x)
#p-value < 0.01 --> reject null hypothesis of non-stationarity


plot(nottem)
plot(decompose(nottem))
adf.test(nottem)

y=diffinv(x)  #non-stationary
plot(y)
#mean and variance could be changing

adf.test(y)
#p-value =0.99 --> confirms what we saw in plot, non-stationary



#----------Autocorrelation----------X

#statistical term which describes the correlation (or lack thereof) in a ts
# tells you whether previous obs influence more recent ones 

#lags: steps on a time scale

#always want to find out whether or not autocorrelation is present

#autocorrelation NOT found in random walk

#Methods to get calculation of autocorrelation
#1.) acf() - autocorrelation function
     # shows autocorrelation between time lags in ts
#2.) pacf - partial autocorrelation function
#3.) Durbin-Watson test 
     # gets autocorrelation only of first order bewteen 1 time point and 
     # immediate successor


#To use DW test for autocorrelation

#a.) Must chop off first and last observations
#b.) this step will provide 1 lag difference

length(lynx)
#114
head(lynx)
head(lynx[-1])
head(lynx[-114])

library(lmtest)
dwtest(lynx[-114]~lynx[-1])
#pval<0.0001 --> auto correlation > 0
#--------------------------------#
#Let's contrast this procedure with randomly normal distributed dataset
x=rnorm(700)
dwtest(x[-700]~x[-1])
#pvalue=0.4904 --> no autocorrelation in dataset

length(nottem)
#240
dwtest(nottem[-240]~nottem[-1])
#pval<0.0001 --> autocorrelation present


#----------ACF and PACF functions----------#
#Autocorrelation --> correlation coefficient between different time points (lags) in ts
#Partial autocorrelation --> correlation coeff. adjusted for all shorter lags in ts
#ACF function used to identify moving average (MA) part of ARIMA model
#PACF function identifies values for autoregressive part (AR)

par(mfrow=c(2,1))
acf(lynx,lag.max=20)
pacf(lynx,lag.max=20)
# dont worry about first bar in ACF - autocorr with itself


#Example 2: Random normal data
par(mfrow=c(1,1))
acf(rnorm(500),lag.max=20)



#Exercise

#1.) Get data and plot it, examine data and plot
set.seed(54)
myts=ts(c(rnorm(50,34,10),
          rnorm(67,7,1),
          runif(23,3,14)))

#myts=log(myts)
plot(myts)

#2.) Set up 3 forecasting models with 10 steps into future
#    Use naive, mean, drift
library(forecast)
meanm=meanf(myts,h=10)
naivem=naive(myts,h=10)
driftm=rwf(myts,h=10,drift=T)



#3.) Get plot with three forecasts, legend, reassemble plot
plot(meanm,plot.conf=F,main="")
lines(naivem$mean,col=123,lwd=2)
lines(driftm$mean,col=22,lwd=2)
legend("bottomleft",lty=1,col=c(4,123,22),
       legend=c("Mean method",
                "Naive method",
                "Drift method"))

#4.) Which method looks most promising?
#not the mean method, probably naive - puts all weight on most recent obs

#5.) Get error measures and compare them, do results match plot?
length(myts)
#140
mytstrain=window(myts,start=1,end=112)
plot(mytstrain)

library(forecast)
#make forecasting periods same length as test set
meanm=meanf(mytstrain,h=28)
naivem=naive(mytstrain,h=28)
driftm=rwf(mytstrain,h=28,drift=T)
mytstest=window(myts,start=112)
accuracy(meanm,mytstest)
accuracy(naivem,mytstest)
accuracy(driftm,mytstest)

#naive model seems to be the best

#6.) Check all relevant statistical traits
#    mean =0, no autocorr in residuals, equal vari, standard residual distribution
plot(naivem$residuals)
mean(naivem$residuals[2:112])
hist(naivem$residuals)
shapiro.test(naivem$residuals)
acf(naivem$residuals[2:112])
#7.  Examine trend results - any fixes needed?
#   what is the easiest tool to improve the model?

#lets just log it

#8.  Perform the whole analysis with log transformation
# check if assumptions are met

#improvement seen in acf function