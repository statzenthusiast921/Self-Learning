#Lesson 69 - K-Means Clustering Project

#1.) Load data and perform K-means clustering
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019/Data/")
kmeansdata=read.csv("kmeansdata.csv",header=TRUE)
head(kmeansdata)
dim(kmeansdata)
#11500  180

#print total number of NAs in data
sum(is.na(kmeansdata))

#print the columns with NAs in data
colnames(kmeansdata)[colSums(is.na(kmeansdata))>0]

#check if any factors in the dataset
str(kmeansdata)

class(kmeansdata$X98)
class(kmeansdata$X)
head(kmeansdata[,1:5])

kmeansdata.adj=kmeansdata[,-1]
dim(kmeansdata.adj)
#11500  179

#Scale the data
scaled.k=scale(kmeansdata.adj)
View(scaled.k)


#Now, let's choose the optimal number of clusters for this data since
#we have checked for missing data, gotten rid of factors, and scaled the data
install.packages("NbClust")
library(NbClust)
set.seed(100)
nc.kmeansdata=NbClust(kmeansdata[,-1],distance="euclidean",method="kmeans")
#takes too long to run

#K-Means
kdata=kmeans(x=scaled.k,centers=5,nstart=10)
kdata



library(cluster)
clusplot(scaled.k,kdata$cluster,color=TRUE,shade=TRUE,labels=2,lines=1)


kmeansdata$Clusters=kdata$cluster
View(kmeansdata)
unique(kmeansdata$Clusters)
table(kmeansdata$Clusters)

aggr=aggregate(kmeansdata[,-1],list(kmeansdata$Clusters),mean)
profile.updated=data.frame(Cluster=aggr[,1],
                           Freq=as.vector(table(kmeansdata$Clusters)),
                           aggr[,-1])
View(profile.updated)
