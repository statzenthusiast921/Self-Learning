#Lesson 68 - K-Means Clustering Implementation

setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data/")
water=read.delim("water-treatment.data",header=FALSE,sep=",",na.string=c("?"," ","NA"))
dim(water)
head(water)
View(water)

colnames(water)=c("Q-E","ZN-E","PH-E","DBO-E","DQO-E","SS-E","SSV-E","SED-E","COND-E",
                  "PH-P","DBO-P","SS-P","SSV-P","SED-P","COND-P","PH-D","DBO-D","DQO-D",
                  "SS-D","SSV-D",'SED-D',"COND-D","PH-S","DBO-S","DQO-S","SS-S","SSV-S",
                  "SED-S","COND-S","RD-DBO-P","RD-SS-P","RD-SED-P","RD-DBO-S","RD-DQO-S",
                  "RD-DBO-G","RD-DQO-G","RD-SS-G","RD-SED-G","percent")
View(water)

#print total number of NAs in data
sum(is.na(water))

#print the columns with NAs in data
colnames(water)[colSums(is.na(water))>0]


str(water)

#Let's look into the missing values
library(Amelia)
missmap(water)

#Scale function standardizes the value


scaled.water=scale(water)
#can not perform clustering with missing values or factors in dataset

#1.) Remove NAs or replace them
water[is.na(water)]=50
#2.) Get rid of factor column
scaled.water=scale(water[,-1])
View(scaled.water)

#Identifying the optimal number of clusters
install.packages("NbClust")
library(NbClust)
set.seed(100)
nc.water=NbClust(water[,-1],distance="euclidean",method="kmeans")
#it has chosen 3 clusters!

table(nc.water$Best.nc[1,])

barplot(table(nc.water$Best.nc[1,]),
        xlab="Number of Clusters",ylab="Number of Criteria",
        main="Number of Clusters Chosen by 26 Criteria")


#NOW LETS RUN THE K-MEANS ALGORITHM

kwater=kmeans(x=scaled.water,centers=3,nstart=10)

#nstart is number of iterations before clustering stops
#20-30 is usual number to choose for nstart

kwater

# MORE ANALYSIS
install.packages("fpc")
library(fpc)
plotcluster(scaled.water,kwater$cluster)
#this plot doesnt really tell us much

library(cluster)
clusplot(scaled.water,kwater$cluster,color=TRUE,shade=TRUE,labels=2,lines=1)
#shows a graph that looks like a venn-diagram allocating observations to clusters

#LETS GO BACK TO THE ORIGINAL DATASET
#add a new column "Cluster" and assign values of clusters to individual obs
water$Clusters=kwater$cluster
View(water)
unique(water$Clusters)
table(water$Clusters)

aggr=aggregate(water[,-1],list(water$Clusters),mean)
profile.updated=data.frame(Cluster=aggr[,1],
                           Freq=as.vector(table(water$Clusters)),
                           aggr[,-1])
View(profile.updated)
#shows table of clusters by columns in original data scale with means of each cluster

#now we can use this data to perform further analysis (perhaps - predictve modeling)

#lets say we create a subset of all values in cluster 1 then train logistic regression
#on this subset and then use this model to automatically assign/determine if new data
# will be assigned to 1 or not