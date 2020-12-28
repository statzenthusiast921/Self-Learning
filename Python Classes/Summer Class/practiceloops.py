#Practice

# Python program to illustrate
# while loop
count = 0
while (count < 3):
    count = count + 1
    print("Hello Geek")
    print(count)

#Loop to see how long it takes to
#save up for Tesla
total=35000
count=0
while (total>0):
    total=total-7500
    count=count+1
    print(total)
    print(count)

# Python program to illustrate
# combining else with while
count = 0
while (count < 3):
    count = count + 1
    print("Hello Geek")
else:
    print("In Else Block")


#Count up to 100 and then something changes
count=0
while (count<100):
    count=count+3.67
    print("Not Ready")
else:
    print("Let's party!")


# Python program to illustrate
# Iterating over a list
print("List Iteration")
l = ["geeks", "for", "geeks"]
for i in l:
    print(i)

l=[2,"HOT",4,"THIS"]
for i in l:
    print(i)


# Python program to illustrate
# nested for loops in Python
for i in range(1, 5):
    for j in range(i):
         print(i, end=' ')
    print()

# Prints all letters except 'e' and 's'
for letter in 'geeksforgeeks':
    if letter == 'e' or letter == 's':
         continue
    print 'Current Letter :', letter
    var = 10
