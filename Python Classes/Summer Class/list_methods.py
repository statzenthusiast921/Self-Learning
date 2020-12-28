#List Methods

a=[1,2,3]
b=[4,5,6]

#combine lists
c=a+b
print(c)
#appends b on to a (total of 1 list)


#split function takes every space and
#add every element after delimeter
s='a b c d e f'
z=s.split()
print(z)

#outputs 1 list with 6 character values

if 'a' in z:
    print("A is in z")
else:
    print("A is not in z")

################################
if 'j' in z:
    print("J is in z")
else:
    print("J is not in z")

if 'j' not in z:
    print("J is not in z")
else:
    print("J is in z")


#LOOPS
for i in z:
    print(i)

#sort ascending
q=[4,5,3,2,7]
q.sort()
print(q)
q.reverse()
print(q)


print(q.count(3))

print(q.index(7))
print(q.index(2))
print(len(q))
print(min(q))
print(max(q))
