#Lesson 70:  Tree Models

#Decision trees can be used for both classification and regression (but mostly classification)
#each tree has split points - nodes

#CART= classification and regression tree

#1.) CART is a decision tree algorithm
#2.) Operates on basis of impurity
#3.) Uses gini index to determine the impurity

#assume there are 2 labeled classes, presence of 2 labeled class indicates
#that the data is not completely pure, if we separate data and each dataset
#has only 1 labeled data class, that will be the pure dataset

#Example of 2 classes could be default and non-default in case of
#loan dataset

#To create splits or determine purity, you use gini index of the node

#After identifying the class, usually a dataset will have 1 labeled 
#class and multiple variables, to determine which variable (independent)
#is the strongest variable, you calculate gini gain for each variable

#Gini index= 1- ((target obs - total obs in the model)^2 +
#                (remaining obs in node - total obs in node)^2)

#Gini gain = gini overall - gini split criteria/class/obs

#Greedy algorithm: algorithm that tries to make best choice based on its
#inherent design and locally optimum design

#for example: we use gini index which selects the variable with the
#highest gini gain for split
