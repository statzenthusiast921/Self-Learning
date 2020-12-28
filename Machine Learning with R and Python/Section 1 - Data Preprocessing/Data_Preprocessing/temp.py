# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file. THIS WILL BE THE TEMPLATE I USE FOR 
PREPROCESSING OF ML MODELS
"""

print("Hello world")


# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os


# Importing the dataset
os.getcwd()
os.chdir('/Users/jonzimmerman/Desktop/Udemy Courses/Machine Learning/Section 1 - Data Preprocessing/Data_Preprocessing')

dataset = pd.read_csv("Data.csv")
dataset.head()

#Need to distinguish matrix of features and response
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, 3].values


"""#Taking care of missing data
from sklearn.preprocessing import Imputer
imputer = Imputer(missing_values='NaN',strategy='mean',axis=0)
imputer = imputer.fit(X[:,1:3])
X[:,1:3] = imputer.transform(X[:,1:3])

#Encoding categorical data
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X = LabelEncoder()
X[:,0]=labelencoder_X.fit_transform(X[:,0])
onehotencoder=OneHotEncoder(categorical_features =[0])
X=onehotencoder.fit_transform(X).toarray()
labelencoder_y=LabelEncoder()
y=labelencoder_X.fit_transform(y)"""


# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

#Random state parameter similar to set.seed(0) in R


# Feature Scaling - model will have issues if predictors not on same scale
from sklearn.preprocessing import StandardScaler
sc_X = StandardScaler()
X_train = sc_X.fit_transform(X_train)
X_test  = sc_X.transform(X_test)
#dont need to feature scale response --> maintain 0/1 structure as is


sc_y = StandardScaler()
y_train = sc_y.fit_transform(y_train)