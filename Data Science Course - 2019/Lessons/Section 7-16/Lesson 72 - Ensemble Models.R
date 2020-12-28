#Lesson 72 - Ensemble Models

#Ensemble techniques refer to use of multiple sets of algorithms to reduce
#variance and achieve better prediction

#instead of running model once, checking parameters, adjusting number of trees, etc.
#you will find optimum range through model

#two types of ensemble models: 
#1.) Bagging
#2.) Bootstrap aggregation

#1.) Bagging uses majority voting for classification models and average value
# for regression models

#2.) Boosting or in simple words - random sampling; used with weak learners

#BOOSTING
# resampling where weight of variables is accounted for:
# Example:
# a. Pop size=25
# b. Create 10 samples from this
# c. Calculate mean of each sample
# d. Calculate average of all means

#BAGGING
# ensemble technique used to reduce variance with other algorithms like CART;
# typically used when you are looking to use decision tree methods

# Example:
# a.) Pop Size=25
# b.) Create 10 samples from this with replacement
# c.) Use CART method on these samples
# d.) Calculate average of all predictions

#RANDOM FOREST

#ensemble-bagging technique
#supervised machine learning technique
#random forest is a classifier

#1.) You set the number of trees you want to create
#2.) You set the number of variables you want to use for consideration
#3.) Final output (class) is based on voting for classification

#R does not support more than 53 variables in random forest implementation;
#if a certain data element doesn't make it to the subsets, it is called
#out of bag dataset
# NO PRUNING IN RANDOM FOREST MODELS!


#Example: Structure of dataset
#14 variables (columns)
#10 obs (rows)

#1.) Let's specify 6 decision trees & 3 variables for our Random Forest
#2.) Note observation may be repeated in a sample as Random Forest samples with replacement
#3.) Different independent variables may be used for modeling in diff samples
#4.) Final class is based on voting

#CART = entire dataset is sampled
#RF = trees with limited number of variables and rows (many datasets used for resampling)