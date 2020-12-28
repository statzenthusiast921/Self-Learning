#Lesson 24: Column Selection

#Upload data
#Getting Started
setwd("/Users/jonzimmerman/Desktop/OT Data Analysis")
install.packages("readxl")
library(readxl)
install.packages("dplyr")
library(dplyr)

#Load in data
OT_data=read_excel("OrangeTheoryData.xlsx",sheet=1)

#Subset data
select=select(OT_data,Splat:MaxHR)
dim(select)
head(select)
str(select)

#Filter data
filter=filter(OT_data,Splat<10)
dim(filter)
head(filter)
filter
