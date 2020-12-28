#Lesson 20: Functions

#Create a function to print squares of numbers in sequence
new.function=function(a){
  for(i in 1:a){
    b=i^2
    print(b)
  }
}

#Call the function supplying 6 as the argument
new.function(6)


#Try one on your own
new.function=function(a,b){
  c=b
  for(i in 1:a){
    c=c+(c*0.0338)
    print(c)
  }
}

new.function(5,80000)
#Using Built-in Functions
summary(income.orig)
str(income.orig)
nrow(income.orig)
