#Advanced R Programming Course
#Section 3 Code on Lists
#Date: 10/15/20
#----------------------------------------------#

#Deliverable: a list with the following components
#1.) Character: Machine name
#2.) Vector: (min,mean,max) utilization for the month (excluding unknown hours)
#3.) Logical: Has utilization ever fallen below 90% TRUE/FALSE
#4.) Vector: all hours where utilization is unknown (NAs)
#5.) Dataframe: For this machine
#6.) Plot: for all machines

#Set working directory
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Advanced R Programming/Sec 3 - Lists")
#Load data
util <- read.csv("P3-Machine-Utilization.csv")
dim(util)
#3600   3
head(util,12)
str(util)
summary(util)

#Derive utilization
util$Utilization = 1 - util$Percent.Idle
head(util,12)

#Handling Date-Time Formats in R
tail(util)
#first column is the day
?POSIXct
#stores time as seconds passed since start of 1970

util$PosixTime <- as.POSIXct(util$Timestamp,format="%d/%m/%Y %H:%M")
head(util)
summary(util)

#Rearrange columns in data frame
util$Timestamp <-NULL
util <-util[,c(4,1,2,3)]
head(util,12)


#----------What is a list?----------#

#like a vector but contain elements of any type
summary(util)
RL1 <- util[util$Machine=="RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

#Vector: (min,mean,max) utilization for the month (excluding unknown hours)
util_status_rl1 <-c(min(RL1$Utilization,na.rm = TRUE),
                    mean(RL1$Utilization,na.rm = TRUE),
                    max(RL1$Utilization,na.rm = TRUE))
util_status_rl1
#Logical: Has utilization ever fallen below 90% TRUE/FALSE
length(which(RL1$Utilization < 0.90)) > 0


util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0
util_under_90_flag

list_rl1 <- list("RL1",util_status_rl1,util_under_90_flag)
list_rl1

#----------Naming components of a list----------#
list_rl1
names(list_rl1)
#NULL

names(list_rl1) <- c("Machine","Stats","LowThreshold")
list_rl1

#Option 2:
rm(list_rl1)

list_rl1 <- list(Machine="RL1",Stats=util_status_rl1,LowThreshold=util_under_90_flag)
list_rl1

#----------Extracting Components of a list----------#
#three ways 
#1.) [] --> will always return a list
#2.) [[]] --> will return the actual object
#3.) $ --> same as [[]] but prettier

list_rl1
list_rl1[1] #list
list_rl1[[1]] #vector
list_rl1$Machine #vector

list_rl1[2]
class(list_rl1)
class(list_rl1[2])
class(list_rl1[[1]])
typeof(list_rl1[[2]])

typeof(list_rl1$Stats)


#How would you access the 3rd element of the vector (max util)?
list_rl1$Stats[3]
list_rl1[[2]][3]


#----------Adding and deleting list components----------#
list_rl1

list_rl1[4] <- "New Information"
list_rl1

#Another way to add a component - via the $
#we will add:
#vector all hour where utilization is unknown (NAs)

list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization),"PosixTime"]
list_rl1


#Remove component - NULL method

list_rl1[4] <-NULL
list_rl1
#Notice: numertion has shifted
list_rl1[4]

#Add another component:
#Dataframe: for this machine
list_rl1$Data <- RL1
list_rl1

summary(list_rl1)
str(list_rl1)


#----------Subsetting a list----------#
list_rl1[[4]][1]
list_rl1$UnknownHours[1]

list_rl1[1:2]
list_rl1[1:3]
list_rl1[c(1,4)]
sublist_rl1 <- list_rl1[c("Machine","Stats")]
sublist_rl1

sublist_rl1[[2]][2]

#Double square brackets are NOT for subsetting!!!
list_rl1[[1:3]]
#error: recursive indexing failed at level 2



#----------Building a time series plot----------#
library(ggplot2)

p <- ggplot(data=util)+geom_line(aes(x=PosixTime,y=Utilization,
                                     color=Machine),size=1.2)+
  facet_grid(Machine~.)+geom_hline(yintercept = 0.90,color="Gray",size=1.2,
                                   linetype=3)
p

myplot=p
list_rl1$Plot <-myplot
list_rl1
summary(list_rl1)
str(list_rl1)
