#Multivariate Time Series - 03.08.2020
#Three Categories of Time Series Structure:

#1.) Univariate TS
#2.) TS with External Regressors
#3.) Multivariate TS

#category determines type of model you use
#trend, seasonality, or stationaity can be present in all 3

#1.) Univariate TS
#numeric vector with time stamp
#predictions based on patterns in data history
#predictions based on trend, seasonality
#what was true for that variable in the past, true in future
#no further external factors are considered

#2.) TS with Ext. Reg.
#usually 1 or 2 variables influence forecast variable
#ext. reg. -->influence is unidirectional
#meaning regressors do influence forecast variable
#most modeling tools can handle external regressors
#-->argument-->'xreg'
#ext. reg. must have the same length and time stamp as the model variable
#extended models -->ARIMAX

#3.) Multivariate TS
#time stamp with multiple variables
#influence is bidirectional: variable can potentially affect each other

#models must account for that influence
#availability of modeling tools and documentation is limited
#GO TO SOLUTION: Vector Autoregressive model (VAR)
#additional moving average extension: VARMA
#used for numeric multivariate ts
#variable types like categorical or factor make modeling an even more complex task:
#bottom-up or top-down models

#Choosing a Suitable Model Category:
#1.) How many variables are there?
#2.) Do variables influence each other?
#3.) What are the variable types?

#Univariate--> ARIMA, Exp Smoothing
#Univarariate w/ Reg --> ARIMAX, Neural Network, others
#MVT --> Numeric values --> VAR
#MVT --> Grouped values --> Bottom-up or top-down

#MVT ts should be stationary --> use augmented dickey fuller test to test for stationarity

#--------------------------------------------#

#Format Conversion into class 'mts'
#ts(data.frame) --> class 'mts'
#ts(matrix) --> class 'mts'

#Generating a random data frame
set.seed(40)
x=rnorm(100,1)
y=rnorm(100,30)
z=rnorm(100,500)
xyz=data.frame(x,y,z)
class(xyz)

#Converting a data farme into mts
mymts=ts(xyz,
         frequency=12,
         start=c(1940,4))

#Stanard exploratory tools
plot(mymts)
head(mymts)
class(mymts)

#Our further exercise dataset
class(EuStockMarkets)
head(EuStockMarkets)

#ONLY USE ONE OF 'MTS' OR 'vars' libraries --> they both have a VAR() function
#R will throw up an error if you try to use one when both libraries in use

#------------------------------------------------#

#Preparing for VAR model

#Stationarity is a prereq for VAR models
#1.) Data Prep
#2.) Stationarity test

#Augmented Dickey-Fuller test
#test should be performed separately on each column
#adf.test from library 'tseries' combined with apply() function

#Tresting for stationarity
library(tseries)

#Tseries-->standard test adf.test
apply(EuStockMarkets,2,adf.test)
#all pvalues >0.05 --> all columns non-stationary

#now we need to difference the entire dataset
#Differencing the whole mts
install.packages('MTS')
library(MTS)
stnry=diffM(EuStockMarkets)

#Retest 
apply(stnry,2,adf.test)
#all pvalues <0.05 --> no more diffencing needs, all columns stationary


#-------------------------------------_#
#VAR Model

#Variable Structure
#1.) Endogenous - input variables influenced by each other
#2.) Exogenous - input variables are NOT influenced by each other

#Requisites of VAR modeling:
#a.) endogenous data
#b.) continuous numeric variables

#each variable is a linear function of past lags of itself
#and past lags of the other variables

#VARMA Models for MTS
#VAR Structure + Moving Average

#Determining the Order of the Model
#1.) Calculate information criteria for number of lags
#2.) Select lowest

#Examples: AIC, BIC, HQ, FPE
#results might vary a lot
#AIC is usually the best

#Granger test for casuality
#any possible combo of variables
#requires stationary time series
#additional differencing step may be needed

#----------Let's implement a VAR model----------#
#VAR Modeling
plot.ts(stnry)

#Lag order identification
install.packages("vars")
library(vars)
VARselect(stnry,type="none",lag.max=10)
#gives you the best lag choice by Inf. Crit.
#stick with AIC since most people use this one
#so 9


#Creating a VAR model with vars
var.a=vars::VAR(stnry,
                lag.max=10,
                ic="AIC",
                type='none')
summary(var.a)

#----------Test for Correlation and Model Diagnostics----------#
#How much of pattern is captures by model?

#1.) Measuring the correlation left in the residuals
#optimizing the model as much as possible
#portmanteau test: function 'serial.test' from library 'vars'
#only objects of class VAR are accepted

#Residual Diagnostics
serial.test(var.a)
#pval >>> 0.0.5 --> indicates lots of correlation between residuals

#whenver you see this --> you should tweak model, change VAR lags, model type

#Tweaking the model:
#a.) Change VAR lags
#b.) Change the model type
#eg: VAR(9) model on differenced MTS

#Alternatives:
#a.) Add a second step of differencing
#b.) Get a logarithm of the data

#----------Granger Causality Test----------#

#Requirements of VAR Models
#1.) Identifying the Order
#use function VARselect() to identify lag number

#2.) Selecting the Variables
#variables having no influence on other variables
#are redundant in model

#Need to ask Question: Is there a correlation between components of model?
#---> Granger causality test is used to answer this question

#Granger Test for Causality
causality(var.a,cause=c("DAX"))
#we get 2 pvalues-->only focus on Granger
#significance in both tests
#pval<0.05 --> DAX does influence other variables, other 3 influence DAX as well

#Review:
#a.) Answers question - is there correlation bw variables?
#b.) Simplifying model by excluding irrelevant variables
#c.) Requires stationary MTS
#d.) test should be performed on all variables of MTS


#----------Forecasting w/ the VAR model----------#
#a.) the ts is differenced - no trend
#    forecast wont be of use without any mods because of (a)
#b.) forecasting complex models far into the future might provide unreliable results
#c.) bringing back the forecast result onto the original scale

#Forecasting VAR models
fcast=predict(var.a,n.ahead=25)
plot(fcast)

#cant see anything, forecast looks flat, also this is differenced data - scale doesnt make sense

#Forecasting the DAX index
DAX=fcast$fcst[1]
DAX

#Extracting the forecast column
x=DAX$DAX[,1]
x

#Have to grab last value of original DAX data and add back to undifferenced data
tail(EuStockMarkets)
#5473.72

#Invert the differencing, adding last value
x=cumsum(x)+5473.72

#adding data and forecast to one ts
DAXinv=ts(c(EuStockMarkets[,1],x),
          start=c(1991,130),frequency=260)

plot(DAXinv)
plot(DAXinv[1786:1885])

#Creating an advanced plot with visual separation
library(lattice)
library(grid)
library(zoo)

#Converting to object zoo
x=zoo(DAXinv[1786:1855])

#Advanced xyplot from lattice
xyplot(x, grid=TRUE, panel = function(x, y, ...){
  
  panel.xyplot(x, y, col="red", ...)
  
  grid.clip(x = unit(76, "native"), just=c("right"))
  
  panel.xyplot(x, y, col="green", ...) })


#Review:
#1.) Extracting relevant data
#2.) Reversing differenced ts
#3.) Concatenating data and the forecast
#4.) Plotting new ts object with 'lattice'