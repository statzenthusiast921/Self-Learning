# String Methods

s="abcdef"

print(s[0])

#outputs a


#substring
print(s[0:3])

#outputs abc
#up to but not including d

#subsets first 4 and skips by 2: ac
print(s[0:4:2])


#Basic String Methods
print(s.find('c'))
#will return index of c

#returns 2

#Replaces first argument with second argument
print(s.replace('d','z'))

#count occurrences of argument
print(s.count('e'))


#reverse String
print(s[::-1])
