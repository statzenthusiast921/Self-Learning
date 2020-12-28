# Natural Language Processing - 04.28.2020

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#use the tab delimited dataset
# no delimiters like quotes or commas getting in the way

# Importing the dataset
dataset = pd.read_csv('Restaurant_Reviews.tsv', delimiter = '\t', quoting = 3)
#value of 3 for quoting ignores double quotes


#Look at first review
dataset['Review'][0]


#Cleaning the first review
import re


import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
#download list of stop words

#look at first review
review=re.sub('[^a-zA-Z]',' ',dataset['Review'][0])


#For loop to break out words
corpus = []

for i in range(0,1000):
    review=re.sub('[^a-zA-Z]',' ',dataset['Review'][i])
    #dont want to remove any letters from a to z capital or lowercase
    review = review.lower()
    #make all letters lower case
    review=review.split()
    #break review out into list of words
    
    ps=PorterStemmer()
    review = [ps.stem(word) for word in review if not word in set(stopwords.words('english'))]
    #write for loop to check if words in list are stop words
    #loop also converts the words to stem words (eg: loved becomes love)
    
    #let put the words back together so its all in one string
    #the space in the beginning acts as a delimeter
    review=' '.join(review)
    corpus.append(review)

#Creating the Bag of Words Model

#create one column for each word , create table where each cell represents
# one word from each review (may or may not be there)
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features=1500)
#can do all of the above with this function


X=cv.fit_transform(corpus).toarray()
#add .toarray() to create a matrix
#WE CREATED A SPARSE MATRIX OF FEATURES (INDEPENDENT VARIABLES , MOSTLY 0s,
# 1s for when a word is found in review)

y=dataset.iloc[:,1].values
#dependent variable is the liked (yes/no) column
#all rows, 2nd column


#----------Copy and paste code from Naive Bayes section---------#

#Split dataset into training and test sets
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.20, random_state = 0)

#NO FEATURE SCALING

#Fitting Naive Bayes to Training Set
from sklearn.naive_bayes import GaussianNB
classifier=GaussianNB()
classifier.fit(X_train,y_train)

#Predicting the test set results
y_pred=classifier.predict(X_test)

#Making the confusion matrix
from sklearn.metrics import confusion_matrix()
cm=confusion_matrix(y_test,y_pred)


#----------Let's try a logistic regression model----------#

# Fitting Logistic Regression to the Training set
from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
cm


#----------Let's try a SVM model----------#
# Fitting SVM to the Training set
from sklearn.svm import SVC
classifier = SVC(kernel = 'linear', random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
cm


#----------Let's try a Decision Tree Model----------#

# Fitting Decision Tree Classification to the Training set
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'entropy', random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
cm


#----------Let's try a Random Forest model----------#

# Fitting Random Forest Classification to the Training set
from sklearn.ensemble import RandomForestClassifier
classifier = RandomForestClassifier(n_estimators = 10, criterion = 'entropy', random_state = 0)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
cm



#----------Let's try a K-Nearest Neighbors Classification Model----------#

# Fitting K-NN to the Training set
from sklearn.neighbors import KNeighborsClassifier
classifier = KNeighborsClassifier(n_neighbors = 5, metric = 'minkowski', p = 2)
classifier.fit(X_train, y_train)

# Predicting the Test set results
y_pred = classifier.predict(X_test)

# Making the Confusion Matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
cm




