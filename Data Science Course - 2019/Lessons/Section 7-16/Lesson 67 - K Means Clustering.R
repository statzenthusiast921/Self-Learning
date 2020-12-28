#Lesson 67 - K Means Clustering

#data reduction technique - looking at smaller subset of N
#compare to PCA where we look at smaller subset of columns
#then use subsets for further analysis

#unsupservised machine learning technique
#can not be used for predictive modeling

#with PCA - can not use any output for predictive modeling
#same with K-Means - can only use output for further analysis

#K-means is partioning, non-hierarchical clustering technique

#initial K - number of clusters, is an arbitrary number which you 
#need to use based on data and your domain experience

#from there you iteratively develop your model & arrive at a
#optimized value for K

#we use PCA or K-means clustering when we have too much information
#and we dont know how to proceed with it

#imagine you are a marketing statistician with a dataset of 1 Million rows
#you will not realistically target 1 Million people, so its easier
#to segment data into clusters

#output for PCA and K-means is used for further analysis that is later
#used for predictive modeling

#based on the squared distance from the center of the cluster 
#(Euclidean distance)

#k-means focus on reducing the variance within each cluster

#we need to continue iteration until there is more movement of 
#data points from 1 cluster to another

#less impacted by outliers

#when movmement of individual data elements stops, it is called point
#of convergence

#centroids are the center of clusters in K-mean

#when you set a value for K - the algorithm will create k number of
#centroids.

#then it will compute distance bteween the centroid and data points 
#around it.  Data points which are closer to each other will go in 
#the same cluster.  Euclidean distance used.

#It is an iterative process and you need to continue experimenting with it 
#until you reach a point where there is no more movement of data points
#from 1 cluster to another.  "Converging"

#PROS: computationally faster than hierachical clustering algorithm; less
#      impacted by outliers

#CONS: number of clusters are arbitrarily selected
