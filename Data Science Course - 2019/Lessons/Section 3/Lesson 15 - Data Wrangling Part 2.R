#Lesson 15: Data Wrangling Part 2
v1=c(1,2,3)
v2=c(4,5,6)
c1=v1*v2
c2=v1+v2
b=c(TRUE,FALSE,TRUE)

x=list(v1,c1,v2,3)

#Let's create a list containing a vector, matrix, and a list
new.list=list(c("Joe","Jack","Jenny"),matrix(c(28000,25000,220000,100,500,800),nrow=2),
              list("x",12.3))


#Merge the two lists
two.list=c(x,new.list)
length(x)
length(new.list)
length(two.list)


#Array is a vector with one or more dimensions
#An Array with two dimensions is the same as a matrix
#An array with three or more dimensions is like a data matrix


#Create two vectors of different lengths
v1.new=c(2,9,3)
v2.new=c(10,11,12,13)

#Create an array with these vectors
new.arr=array(c(v1.new,v2.new),dim=c(3,3,2))
print(new.arr)

#Create an array with these vectors
new.arr=array(c(v1.new,v2.new),dim=c(3,3,3))
print(new.arr)

#####################################################################
#Load in adult data file
setwd("/Users/jonzimmerman/Desktop/Data Science Course - 2019")
income.orig=read.delim("adult.data",header=FALSE,sep=',',na.strings=c(""," "," ?","NA"))
dim(income.orig)
head(income.orig)

colnames(income.orig)
colnames(income.orig)=c(
  "age",
  "workclass",
  "final.weight",
  "education",
  "education.num",
  "marital.status",
  "occupation",
  "relationship",
  "race",
  "sex",
  "capital.gain",
  "capital.loss",
  "hours.per.week",
  "country",
  "final.class"
)
colnames(income.orig)

#Show column
income.orig$age

#Create a new vector
new.vector=income.orig$education.num
View(income.orig)

#Get Education Num column
new.vector=income.orig[,5]
#select 5th column with all rows

#Select specific row or observation
new.vector=income.orig[20,5]
View(new.vector)

new.vector=income.orig[1:20,5]
View(new.vector)
