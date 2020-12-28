#05.18.2020
# Artificial Neural Network


#Install Theano
#pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git

#open source numerical computation library --> can run on cpu (main processor) and gpu (graphic processor - more powerful, more cores);

#Installing TensorFlow
#Install TensorFlow from the website: https://www.tensorflow.org/versions/r0.11/get_started

#open source numerical computational library, developed by Google, under Apache2 license
# these 2 libraries used mainly for research purposes, used for neural network


# Installing Keras
# Enter the following command in a terminal (or anaconda prompt for Windows users): 
# conda install -c conda-forge keras

#used for building deep learning neural network models (combines purposes of Theano and TensorFlow)
#need lots of lines of code for both Theano and TensorFlow, but a lot less with Keras
# Part 1 - Data Preprocessing


#ALL WE NEED TO DO IS LOAD THIS IN TERMINAL: conda install -c conda-forge keras



# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('Churn_Modelling.csv')
X = dataset.iloc[:, 3:13].values
y = dataset.iloc[:, 13].values

# Encoding categorical data - make categories into numbers
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X_1 = LabelEncoder()
X[:, 1] = labelencoder_X_1.fit_transform(X[:, 1])
labelencoder_X_2 = LabelEncoder()
X[:, 2] = labelencoder_X_2.fit_transform(X[:, 2])]


#create dummy variables 
onehotencoder = OneHotEncoder(categorical_features = [1])
X = onehotencoder.fit_transform(X).toarray()

#remove one dummy variable so we have n-1 dummy variables
#take all rows and all columns except 2nd column
X = X[:, 1:]

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

# Feature Scaling - need it to ease all the calculations
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Part 2 - Now let's make the ANN!

# Importing the Keras libraries and packages
import keras
from keras.models import Sequential
from keras.layers import Dense

# Initialising the ANN
classifier = Sequential()

# Adding the input layer and the first hidden layer- 11 nodes for each of the independent variables
#11/2= 5.5 ~ 6 nodes for first hidden layer
classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu', input_dim = 11))

# Adding the second hidden layer
classifier.add(Dense(units = 6, kernel_initializer = 'uniform', activation = 'relu'))

# Adding the output layer - 1 node in output layer
classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))

# Compiling the ANN
classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy'])

# Fitting the ANN to the Training set
classifier.fit(X_train, y_train, batch_size = 10, epochs = 100)

# Part 3 - Making the predictions and evaluating the model

# Predicting the Test set results
y_pred = classifier.predict(X_test)
y_pred = (y_pred > 0.5)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)