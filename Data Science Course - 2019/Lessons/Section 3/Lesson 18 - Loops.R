#Lesson 18: Loops


#FOR LOOP - Example 1
for (i in c(1:5)){
  print(i)
}


#FOR LOOP - Example 2
a=c(1:5)

for (i in a) {
  print(i)
}

#FOR LOOPS - Example 3
for (v in c(1:7)){
  if (v<=5)
    print(v)
  else(
    print("I'm Done")
  )
}


###################################
install.packages("corpcor")
library(corpcor)
install.packages("GPArotation")
library(GPArotation)
install.packages("psych")
library(psych)
library(ggplot2)
install.packages("ggfortify")
library(ggfortify)
install.packages("nFactors")
library(nFactors)
library(dplyr)
install.packages("expm")
library(expm)
install.packages("Hmisc")
library(Hmisc)


#Load in adult data file
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019")
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

#FOR LOOP with dataset - Example 4
for (i in income.orig$age) {
  print(i)
}

r=income.orig[6,]
r

for (i in r) {
  print(i)
}

#WHILE LOOP - Example 5
r=500
while (r!=495){
  print("this is my")
}

#keeps running - creates infinite loop - kills memory of system
#will continue to run until condition = TRUE (it will never be (as is))

#WHILE LOOP - Example 6
r=1
while (r<6){
 print(r)
  r=r+1
}


