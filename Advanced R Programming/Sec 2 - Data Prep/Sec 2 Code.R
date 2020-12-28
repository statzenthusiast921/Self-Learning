#Advanced R Programming Course
#Section 2 Code for Data Preparation
#Date: 10/12/20
#----------------------------------------------#
#Set working directory
setwd("/Users/jonzimmerman/Desktop/Udemy Courses/Advanced R Programming/Sec 2 - Data Prep")

#Load data
#Basic: fin <- read.csv("P3-Future-500-The-Dataset.csv")
#want all empty character strings to be replaced with NAs
fin <- read.csv("P3-Future-500-The-Dataset.csv",na.strings = c(""))

head(fin)
tail(fin,20)

str(fin)
summary(fin)

#Changing from non-factor to factor
fin$ID <- factor(fin$ID)
fin$Inception <- factor(fin$Inception)
str(fin)
summary(fin)

#Factor Variable Trap (FVT)
#when converting from factor to non-factor

#Converting into Numerics For Characters
a <- c("12","13","14","12","12")
a
class(a)

b <- as.numeric(a)
class(b)

#Converting into Numerics For Factors

z <- factor(c("12","13","14","12","13"))
z
class(z)
typeof(z)

y <- as.numeric(z)
y
typeof(y)

#------------------------------------------#
#Correct way to convert

#1.) Convert to character
#2.) Convert to numeric

x <-as.numeric(as.character(z))
x
typeof(x)
class(x)


#FVT Example --> convert to numeric from factor for profit gives wrong #s
head(fin)
str(fin)
#fin$Profit <-factor(fin$Profit)

#fin$Profit <-as.numeric(fin$Profit)
head(fin$Profit)


#----------GSUB AND SUB FUNCTIONS----------#
#sub replaces first instance
#gsub replaces all instances

#gsub(pattern,replacement,location)

fin$Expenses <- gsub(" Dollars","",fin$Expenses)
fin$Expenses <- gsub(",","",fin$Expenses)

head(fin)
str(fin)

fin$Revenue <- gsub("$","",fin$Revenue)
#dollar sign is special character in R --> doesnt get replaced

#Create escape sequence with \\ --> removes special characters
fin$Revenue <- gsub("\\$","",fin$Revenue)

head(fin)

fin$Revenue <- gsub(",","",fin$Revenue)
fin$Growth <- gsub("%","",fin$Growth)
head(fin)
str(fin)

#Convert character variables to numeric
fin$Expenses <- as.numeric(fin$Expenses)
fin$Growth <- as.numeric(fin$Growth)
str(fin)

fin2=fin
fin$Revenue <- as.numeric(fin2$Revenue)
fin$Revenue <- as.numeric(fin$Revenue)
str(fin)


#What is an NA?
NA
?NA

TRUE == FALSE
TRUE == 5
TRUE == 1
FALSE == 4
FALSE == FALSE
FALSE == 0
NA == TRUE
#NA == NA

#can not compare NA to anything else including another NA


#Locating Missing Data
head(fin,24)
fin[!complete.cases(fin),]

str(fin)
#<NA> --> factors
#NA --> not factors


#----------Filtering: using which() for non-missing data----------#
fin[fin$Revenue == 9746272,]
#extra NA rows because NAs in revenue

#finds indices were condition is true
which(fin$Revenue == 9746272)

#pass this into the filter
fin[which(fin$Revenue == 9746272),]

head(fin)
fin[fin$Employees==45,]
fin[which(fin$Employees==45),]


#----------Filtering: using is.na() for missing data----------#
head(fin)
#fin[fin$Expenses == NA,]  --> can not compare anything to NAs

a <-c(1,24,543,NA,76,45,NA)
is.na(a)


fin[is.na(fin$Expenses),]


#----------Removing records with missing data--------#
fin_backup <- fin

fin[!complete.cases(fin),]
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),] #opposite
fin <-fin[!is.na(fin$Industry),]
dim(fin)
#498  11


#----------Resetting the dataframe index----------#
head(fin,20)
#rows 14 and 15 deleted, row ids didnt adjust

#Option #1
rownames(fin) <-1:nrow(fin)
tail(fin)

#Option #2
#rownmaes(fin) <-NULL


#----------Replacing Missing Data: Factual Analysis----------#
fin[!complete.cases(fin),]

fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City=="New York","State"] <- "NY"

#Check:
fin[c(11,377),]

fin[is.na(fin$State) & fin$City=="San Francisco","State"] <- "CA"
fin[c(82,265),]


#----------Replacing Missing Data: Median Imputation----------#
fin[!complete.cases(fin),]

#median for entire dataset
median(fin[,"Employees"],na.rm=TRUE)
#56

#Only look at industry = retail rows
med_empl_retail=median(fin[fin$Industry=="Retail","Employees"],na.rm=TRUE)
med_empl_retail
#28

fin[is.na(fin$Employees) & fin$Industry=="Retail","Employees"] <-med_empl_retail


med_empl_fs=median(fin[fin$Industry=="Financial Services","Employees"],na.rm=TRUE)
med_empl_fs
#80

fin[is.na(fin$Employees) & fin$Industry=="Financial Services","Employees"] <-med_empl_fs


#----------Replacing Missing Data: Median Imputation Part 2----------#
fin[!complete.cases(fin),]

med_growth_constr <- median(fin[fin$Industry=="Construction","Growth"],na.rm=TRUE)
med_growth_constr
#10

fin[is.na(fin$Growth) & fin$Industry=="Construction",]
fin[is.na(fin$Growth) & fin$Industry=="Construction","Growth"] <-med_growth_constr
fin[8,]

#----------Replacing Missing Data: Median Imputation Part 2----------#
med_rev_contr <-median(fin[fin$Industry=="Construction","Revenue"],na.rm=TRUE)
med_rev_contr
#9055058

fin[is.na(fin$Revenue) & fin$Industry=="Construction",]
fin[is.na(fin$Revenue) & fin$Industry=="Construction","Revenue"] <-med_rev_contr
fin[!complete.cases(fin),]


#Expenses
#Be careful here.  Only for certain ones
#We don't want to replace that one that's by itself (because then that row won't add up)

med_exp_const <- median(fin[fin$Industry=="Construction","Expenses"],na.rm=TRUE)
med_exp_const
#4506976

#add the check on profit so you dont impute a value where it could be calculated directly
fin[is.na(fin$Expenses) & fin$Industry=="Construction" & is.na(fin$Profit),]
fin[is.na(fin$Expenses) & fin$Industry=="Construction","Expenses"] <-med_exp_const
fin[!complete.cases(fin),]

#----------Replacing Missing Data: Deriving Values----------#
#Profit = Revenue - Expenses
#Expenses = Revenue - Profit
fin[is.na(fin$Profit),"Profit"]
fin[is.na(fin$Profit),"Profit"] <-fin[is.na(fin$Profit),"Revenue"] - fin[is.na(fin$Profit),"Expenses"]
fin[c(8,42),]


fin[!complete.cases(fin),]
fin[is.na(fin$Expenses),"Expenses"]
fin[is.na(fin$Expenses),"Expenses"] <- fin[is.na(fin$Expenses),"Revenue"] - fin[is.na(fin$Expenses),"Profit"]
fin[15,]

fin[!complete.cases(fin),]


#----------Visualization----------#
#1.) Scatterplot classified by industry showing revenue, expenses, and profit
#2.) Scatterplot that includes industry trends for expenses-revenue relationship
#3.) Boxplots showing growth by industry

library(ggplot2)
#Plot #1
p <- ggplot(data=fin)+geom_point(aes(x=Revenue,y=Expenses,colour=Industry,size=Profit))
p

#Plot #2
d <- ggplot(data=fin,aes(x=Revenue,y=Expenses,colour=Industry))+
     geom_point()+
     geom_smooth(fill=NA,size=1.2)
d

#Plot #3
f <- ggplot(data=fin,aes(x=Industry,y=Growth,color=Industry))+
     geom_boxplot(size=1)
f

#Extra
f+geom_jitter()+
  geom_boxplot(size=1,alpha=0.5,outlier.color = NA)
