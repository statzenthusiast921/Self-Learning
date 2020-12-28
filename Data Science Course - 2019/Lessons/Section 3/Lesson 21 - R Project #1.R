#R Project #1 (L22) 

#1. How do you find more information about a function in R/Rstudio?
?summary
?glm

#2. How do you install packages in Rstudio?
install.packages("ggplot2")
library(ggplot2)

#3. Load an Excel file in RStudio.
setwd("/Users/jonzimmerman/Desktop/OT Data Analysis")
install.packages("readxl")
library(readxl)
OT_data=read_excel("OrangeTheoryData.xlsx",sheet=1)

#4. Load a data set and save it as a matrix.
OT_data2=as.matrix(OT_data)

#5. Write a command to find out the class of a dataset.
class(OT_data2)

#6. Write a few data types in R.
unique(OT_data$Splat)
new=as.vector(OT_data$Splat)
class(new)
new=as.numeric(OT_data$Splat)
class(new)


#7. Create a variable with a number
a=5

#8. Create a string variable
poop="poop"
poop
Amelia_is="pretty"

#9. Print variables created in last two questions
print(poop)
print(a)
print(Amelia_is)

#10. Create 2 numerical vectors
a=c(1,2,3)
b=c(4,5,6)
class(a)
class(b)

#11. Create an object and multiply the 2 vectors created in last question
c=a*b
c

#12. Create a list with 5 elements in R.
d=list("a","b","c","d",5)
class(d)

#13. Assign names to the elements in the list
names(d)=c("1st","2nd","3rd","Fourth","Fuck you")
d

#14.  Access the first and fourth element in the list created in #12.
d[1]
d[4]

#15. Remove an element from the list created in #12.
d[5]=NULL
d

#16. Load dataframe in RStudio.  
setwd("/Users/jonzimmerman/Desktop/SASUniversityEdition/myfolders")
LocationData=read_excel("Location.xlsx",sheet=1)
dim(LocationData)
LocationData
class(LocationData)
colnames(LocationData)=c("City1","State2","Measure3","POC4")
colnames(LocationData)
LocationData

#17. Create a new object with a column and first 5 rows 
#    selected from dataframe created in question 16.

new=LocationData[1:5,1]
new


#18. Create a vector and an if-else block where the else block is executed.
x=0
if(x>0){
  x+5
}else{
  x-100
}

#19. Create a for loop to print numbers up to 5.
for (i in 1:5) {
  print(i)
}

#20. Create a while loop to count to 6.

i=1
while (i<7){
  print(i)
  i=i+1
}
