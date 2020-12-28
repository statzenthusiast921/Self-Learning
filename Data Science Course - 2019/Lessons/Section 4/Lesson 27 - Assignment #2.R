#Lesson 27: Assignment #2

#1.) Select Age colummn and create an object from Titanic dataset
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")
titanicdna=read.csv("titanic_train.csv",na.strings=c("NA",""))
head(titanicdna)

Agecol=titanicdna$Age
Agecol

#2.) Select embarked column and apply filter to create a subset where
#    embarked value ==S.

SEMB=subset(titanicdna,titanicdna$Embarked=="S")
dim(titanicdna)
dim(SEMB)

#3.) Find out the percentage of missing values in the dataset.
summary(titanicdna)
sum(is.na(titanicdna)==FALSE)
sum(is.na(titanicdna)==TRUE)
dim(titanicdna)

sum(is.na(titanicdna)==TRUE)/(sum(is.na(titanicdna)==FALSE)+sum(is.na(titanicdna)==TRUE))


#4. Create a new column for age and replace missing values
NewImputedData=mutate(titanicdna,Ageupdated=ifelse(is.na(Age),mnAge,Age))
summary(NewImputedData$Ageupdated)
summary(titanicdna$Age)

#5.) What is the mean fare?
summary(titanicdna$Fare)[4]
