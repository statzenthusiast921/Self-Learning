#Lesson 60 - Logistic Regression

#Load in adult data file
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
income.orig=read.delim("adult.data",header=FALSE,sep=',',na.strings=c(""," "," ?","NA"))
dim(income.orig)
head(income.orig)

colnames(income.orig)
colnames(income.orig)=c(
  "age",
  "workclass",
  "final.weight",
  "education",
  "education.num",
  "marital.status",
  "occupation",
  "relationship",
  "race",
  "sex",
  "capital.gain",
  "capital.loss",
  "hours.per.week",
  "country",
  "final.class"
)
colnames(income.orig)
View(income.orig)
str(income.orig)
sum(is.na(income.orig))
#check which columns have missing values
colnames(income.orig)[colSums(is.na(income.orig))>0]

summary(income.orig)

install.packages("mice")
library(mice)

#displays table with NA
md.pattern(income.orig)


#verify number of NAs
sum(is.na(income.orig$workclass))
sum(is.na(income.orig$country))
sum(is.na(income.orig$occupation))


#Convert NA to "None" - new factor level
library(forcats)
workclass.new=fct_expand(income.orig$workclass,na_level='None')
income.orig$workclass.new=workclass.new

country.new=fct_explicit_na(income.orig$country, na_level="None")
income.orig$country.new=country.new

occupation.new=fct_explicit_na(income.orig$occupation, na_level="None")
income.orig$occupation.new=occupation.new

#Dependent Level = Final Class
library(ggplot2)
