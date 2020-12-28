#Sec 4 Code: Apply Family of Functions
#Date: 10/18/20
#------------------------------------------#
#Set working directory
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Advanced R Programming/Sec 4 - Apply Functions/Weather Data")

#Load data
Chicago <- read.csv("Chicago-F.csv",row.names=1)
NewYork <- read.csv("NewYork-F.csv",row.names=1)
Houston <- read.csv("Houston-F.csv",row.names=1)
SanFrancisco <- read.csv("SanFrancisco-F.csv",row.names=1)


#These are dataframes:
class(Chicago)
class(NewYork)
class(Houston)
class(SanFrancisco)

#Convert to matrix
Chicago <-as.matrix(Chicago)
NewYork <-as.matrix(NewYork)
Houston <-as.matrix(Houston)
SanFrancisco <-as.matrix(SanFrancisco)

#Put these all into a list
Weather <-list(Chicago=Chicago,NewYork=NewYork,Houston=Houston,SanFrancisco=SanFrancisco)
Weather

#Let's access Houston
Weather[[3]] #-->matrix
Weather[3] #--> new list

#----------Using apply()----------#
?apply
apply(Chicago,1,mean)
mean(Chicago["DaysWithPrecip",])

#Analyze one city
apply(Chicago,1,max)
apply(Chicago,1,min)
apply(Chicago,2,median)

#Compare cities
apply(Chicago,1,mean)
apply(NewYork,1,mean)
apply(Houston,1,mean)
apply(SanFrancisco,1,mean)
#This is deliverable 1, but there is a faster way

#-----Recreate the apply function with loops (advanced topic)-----#

Chicago
#Find mean of every row

#1.) Via Loops
output <-NULL #preparing an empty vector
for(i in 1:5){
  output[i]=mean(Chicago[i,])
}
output
names(output) <-rownames(Chicago)
output

#2.) Via apply function
apply(Chicago,1,mean)


#----------Using lapply()----------#
?lapply

#Example 1
Chicago
t(Chicago)
Weather
t(Weather$Chicago)

mynewlist=lapply(Weather, t) #t(Weather$Chicago), t(Weather$NewYork), ...
mynewlist

#Example 2
Chicago
rbind(Chicago,NewRow=1:12)

mynewlist2=lapply(Weather,rbind, NewRow=1:12)

#Example 3
?rowMeans

rowMeans(Chicago) #identical to apply(Chicago,1,mean)
mynewlist3=lapply(Weather,rowMeans)
mynewlist3

#Useful functions
#rowMeans
#colMeans
#rowSums
#colSums

#----------Combining lapply with the [] operator----------#
Weather

Weather[[1]][1,1]
Weather$Chicago[1,1] #-----> want this result for all lists

lapply(Weather,"[",1,1) #-----> average high temperature in january for all cities

lapply(Weather,"[",1,) #-----> grabs first row of every matrix

lapply(Weather,"[",,3) #-----> grabs March column for each matrix


#----------Adding your own functions----------#
lapply(Weather,rowMeans)
lapply(Weather,function(x) x[1,]) #created our own function that subsets first row

lapply(Weather,function(x) x[5,]) #-----> look at hours of sunlight

lapply(Weather,function(x) x[,12]) #-----> look at December

lapply(Weather,function(z) z[1,]-z[2,]) #diff between avg high and avg low

lapply(Weather,function(z) round((z[1,]-z[2,])/z[2,],2)) #diff between avg high and avg low

#----------Using sapply()----------#
?sapply
Weather

#AvgHigh_F for July:
lapply(Weather,"[",1,7)
sapply(Weather,"[",1,7)

#returns vector instead of list --> simplifying things

#AvgHigh_F for 4th quarter:
lapply(Weather,"[",1,10:12)
sapply(Weather,"[",1,10:12)

#returns matrix instead of a list --> simplifying things

#Another example:
lapply(Weather,rowMeans)
sapply(Weather,rowMeans)
round(sapply(Weather,rowMeans),2) #Deliverable #1

#Another example:
lapply(Weather,function(z) round((z[1,]-z[2,])/z[2,],2)) 
sapply(Weather,function(z) round((z[1,]-z[2,])/z[2,],2))  #Deliverable #2

#Simplify Argument
sapply(Weather,rowMeans,simplify=FALSE) #same as lapply()

#----------Nesting Apply Functions----------#
Weather
lapply(Weather,rowMeans)
Chicago

#Want to get row maxs --> no rowMax function to do that
apply(Chicago,1,max)

#Apply across whole list:
lapply(Weather,apply,1,max) 
sapply(Weather,apply,1,max) #Deliverable 3

sapply(Weather,function(x) apply(x,1,max)) # same thing



sapply(Weather,apply,1,min) #Deliverable 4


#----------VERY ADVANCED TUTORIAL: WHICH.MAX----------#
?which.max
Chicago[1,]
which.max(Chicago[1,])
which.min(Chicago[1,])

names(which.max(Chicago[1,]))

apply(Chicago,1,function(x) names(which.max(x)))

lapply(Weather,function(y) apply(y,1,function(x) names(which.max(x))))
sapply(Weather,function(y) apply(y,1,function(x) names(which.max(x))))

