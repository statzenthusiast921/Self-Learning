#Lesson 26: Missing Data Analysis
#Upload data
#Getting Started
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data")

#Load in data
titanic_train=read.csv("titanic_train.csv")
dim(titanic_train)
head(titanic_train)
View(titanic_train)


#in order to treat blank strings as NA, specify na.strings="NA" or empty string
titanicdna=read.csv("titanic_train.csv",na.strings=c("NA",""))
View(titanicdna)

#The is.na function is used to denote which index of the attribute contains
#the NA value.  Here, we apply it to the Age attribute first:
is.na(titanicdna$Age)

#sums number of missing values (where value=TRUE)
sum(is.na(titanicdna$Age))

str(titanicdna)

dim(titanicdna)[1]
length(titanicdna$Age)

# %age of missing values
sum(is.na(titanicdna$Age))/length(titanicdna$Age)


summary(titanicdna)


#Use na.rm=TRUE to calculate mean without NAs
mnAge=mean(titanicdna$Age,na.rm=TRUE)
mnAge

#Creates new column with mean imputed for NAs
Ageupdated=mutate(titanicdna,Ageupdated=ifelse(is.na(Age),mnAge,Age))
View(Ageupdated)
View(titanicdna)

Embarkedupdated=mutate(titanicdna,Embarkedupdated=ifelse(is.na(Embarked),"S",Embarked))
sum(is.na(titanicdna$Embarked))
sum(is.na(titanicdna$Embarkedupdatedx))
summary(Embarkedupdated)
