#Time Series Section 2: Working with Dates and Time
#Last Updated: February 1, 2020
#--------------------------------------
x=as.POSIXct("2019-12-15 11:45:34") #num of sec
y=as.POSIXlt("2019-12-15 11:45:34")

x
y
#same output

unclass(x)
unclass(y)

#Reference Time Point for POSIXCT - the birth second
#01-01-1970 00:00:00

#What does this number mean? (end of 2015)
(50*365*24*60*60)-(5.5*60*60)
#1576780200 - number of seconds

y$zone #extracting elements from POSIXlt
x$zone #not possible (number of seconds)

#another class based on days
x=as.Date("2019-12-15")
x
class(x)
unclass(x)


50*365-5 #(number of days since 1970) (does not consider leap years)

#Add on package
install.packages("chron")
library(chron)

x=chron("12/25/2019","23:34:09")
x
class(x)
unclass(x)

#REVIEW:
  
#R Base Classes:
#1.) POSIXct - passed seconds since birth second
#2.) POSIXlt - date and time components
#3.) Both POSIXct and POSIXlt account for date, time, and time zones
#4.) Date - passed days since the birth day

#Library 'chron"
#   practical usage without time zone

#Format Conversion from Strings to Date/Time

#1.) Date/Time without encoding is read as string
#2.) Function strptime() for converting strings to date time values

a=as.character(c("1993-12-30 23:45",
                 "1994-11-05 11:43",
                 "1992-03-09 21:54"))
class(a)
b=strptime(a,format="%Y-%m-%d %H:%M")
b
class(b)
#POSIXlt POSIXt

#Note: Strings to be converted need to be uniform in their format
#Note2: Encoding guide is included in help section of strptime()

#LUBRIDATE
#Convenient toolset for data/time handling
#Popular package for time series analysis and survival analysis
#Main uses:
#1.) Date and time based calculations
#2.) Advanced format converison
#3.) Changing the time zone
#4.) Checking for leap years

install.packages("lubridate")
library(lubridate)

#Different ways to input dates
ymd(19931123)
dmy(23111993)
mdy(11231993)

#Let's use time and date together
mytimepoint=ymd_hm("1993-11-23 11:23",tz="Europe/Prague")
mytimepoint
class(mytimepoint)

#Extracting the components
minute(mytimepoint)
day(mytimepoint)
hour(mytimepoint)
year(mytimepoint)
month(mytimepoint)

#Changing the time values within the object
hour(mytimepoint)=15
mytimepoint

#Available time zone (TZ) names
OlsonNames()

#Lets check which day our time point is
wday(mytimepoint)
wday(mytimepoint,label=T,abbr=F)

#Calculating which time our timepoint would be in time zone
with_tz(mytimepoint,tz="Europe/London")
mytimepoint
#1 hour difference

#Time intervals
time1=ymd_hm("1993-09-23 11:23", tz="Europe/Prague")
time2=ymd_hm("1995-11-02 15:23", tz="Europe/Prague")

#Getting the interval
myinterval=interval(time1,time2)
myinterval
class(myinterval)

#Exercise
a=c("1998,11,11","1983/01/23","1982:09:04","1945-05-09",
    19821224,"1974.12.03",19871210)
a=ymd(a,tz="CET")
a

#Creating a time vector - using different notations of input
b=c("22 4 5","04;09;45","11:9:56","23,15,12",
    "14 16 34", "8 8 23", "21 16 14")
b=hms(b)
b

f=rnorm(7,10)
f=round(f,digits=2)
f
date_time_measurement=cbind.data.frame(data=a,time=b,measurement=f)
date_time_measurement



#Calculations with Lubridate

#Time
minutes(7)

#Note that class "Period" needs integers
minutes(2.5)
#does not work

#Getting the duration
dminutes(3)
dminutes(3.5)

#How to add minutes and seconds
minutes(2)+seconds(5)
minutes(2)+seconds(75)

#Class "duration" to perform addition
as.duration(minutes(2)+seconds(75))

#Class 'period' - Entries for different units are NOT cumulative
#Class 'duration' - Entries for different units are cumulative


#Lubridate has many time classes: period or duration
#Which year was a lear year?
leap_year(2009:2014)

#Check difference between classes
ymd(20140101)+years(1)
ymd(20140101)+dyears(1)

#its the same

#Lets do the whole thing with a leap year
leap_year(2016)
ymd(20160101)+years(1)
ymd(20160101)+dyears(1)
#not the same

#Review:
#1.) Functions that result in class 'period' are added 
#    to the specified date part
# eg: year(1) = 1 year
# units are not cumulative

#2.) Functions that result in class 'duration' add the 
#    duration of the specified date part
#eg: dyear(1)=365 days
#unites are cumulative

#3.) Function leap_year() returns TRUE if specified year is a leap year

#Exercise:
#1.) Create the object x with a time zone CET and a given time point in 2014 
x=ymd_hm(tz="CET","1990-01-29 14:12")
#2.) Change the minute of x to 7 and check x in the same line of code
minute(x)=7
x
#3.) See what the time would be in London?
with_tz(x,tz="Europe/London")
#4.) Create another time point y in 2015 and get the 
#    difference between objects x and y?
y=ymd_hm(tz="CET","2015-05-18 04:40")
y
y-x
