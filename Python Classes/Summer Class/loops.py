#Loops

#For Loops

for i in range(10000):
    print(i)



#While Loop (takes into account condition(s))
i=0
while i<7:
    print(i)
    i+=1 #i=i+1

#For Loop Example 1:
#Write a function xyz() that appends the numbers 0 through 4
#to a list l using a for loop, then returns the list
def xyz():
    l=[]
    for i in range(5):
        l.append(i)
    return(l)

#Intermeidate For Loop Example #2:
#Write a function xyz(l) that loops through the list l, and then
#returns the sum of all the elements in the list
def xyz(l):
    sum=0
    for i in l:
        sum=sum+i
    return(sum)

#Advanced For Loop Example #3:
#Write a function xyz(l) that loops through a list,
#and returns "Bingo" if it finds the number 7,
#and "no" if it doesn't
def xyz(l):
    for i in l:
        if i==7:
            return "Bingo"
    return "no"

#While Loops Example #4:
#Write a function xyz(l) that appends the numbers
#from 10 to 0 to a list l using a while loop
def xyz():
    l=[]
    i=10
    while (i<=10 and i>=0):
        l.append(i)
        i=i-1
    return(l)

#Intermediate While Loop Example #5:
#Write a function xyz(a) that loops through the
#numbers 0 through a, and returns "Jackpot" if
#it finds the number 777 and if it doesnt, return
#"Try again"
def xyz(a):
    i = 0
    while i < a:
        i=i+1
        if i == 777:
            return 'Jackpot'
    return 'Try again'
