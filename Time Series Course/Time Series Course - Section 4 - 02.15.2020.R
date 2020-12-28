#Time Series Course Section 4 - 02.14.2020
#Time Series Vectors and Lags
lynx
time(lynx)
#we get the corresponding time components to
#each value (timestamp - essentially the x axis)
#Order might also be specified by a vector which
#has a UNiqueID attached to the variable
#Order needs to be meaningful without randomness
#NON-MEANINGFUL: vector of body measurements taken randomly
#from a pop
#MEANINGFUL: monthly temperature data
#seasonal pattern
#changing the order of valules corrupts info
#ts() can attach a time stamp to a vector

#What is a lag?
length(lynx)
#114
#lag_n=(y_n) - (y_t-n)
#lynx has length of 114
#t shows position of a value in the time series
#last obs=y_114
#y114=3396
#Lag1= (y_114) - (y_113)=3396-2657
#Lag2= (y_114) - (y_112)=3396-1590
#Time lag is the gap between two observations

mean(lynx)
#1538.018
median(lynx)
#771
plot(lynx)
#several peaks in data - cycles of approx. 9 years
#peaks are short - most of the obs are well below peaks
#high peaks affect average but not median
sort(lynx)[c(57,58)]
quantile(lynx)
quantile(lynx,prob=seq(0,1,length=11),type=5)