#Lesson 14
v1=c(1,2,3)
v2=c(4,5,6)
c1=v1*v2
c2=v1+v2


b=c(TRUE,FALSE,TRUE)

#Make a list
x=list(v1,c1,v2,3)
x
class(x)

#Let's create a list containing a vector, matrix, and a list
new.list=list(c("Joe","Jack","Jenny"),matrix(c(28000,25000,220000,100,500,800),nrow=2),
              list("x",12.3))
print(new.list)

#Manipulation - Give names to the elements in the list
names(new.list)=c("Names","Numbers","Random")
print(new.list)


#Access the first element of the list
print(new.list[1])
print(new.list$Names)

print(new.list[3])

#Add an element at end of list
new.list[2]="New Player"
print(new.list[4])
print(new.list)


#Remove the element
new.list[3]=NULL
new.list
