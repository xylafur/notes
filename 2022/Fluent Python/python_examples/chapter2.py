from collections import abc

issubclass(tuple, abc.Sequence)
# True

issubclass(list, abc.MutableSequence)
# True

#MultibleSequence ABC is a subclass of the Sequence ABC; meaning lists are Sequences and
#MutableSequences, but tuples are not mutable

# Initializing a tuple with Generator Expression

symbols = '$¢£¥€¤'
tuple(ord(symbol) for symbol in symbols)
# (36, 162, 163, 165, 8364, 164)

import array
# We have to tell the array type that it will contain integers
array.array('I', (ord(symbol) for symbol in symbols))
# array('I', [36, 162, 163, 165, 8364, 164])

# You can use the * prefix operator to grab excess items when unpacking

a, b, *rest = range(5)
# a=0, b=1, rest=[2, 3, 4]

a, *body, c, d = range(5)
# a=0, body=[1, 2], c=3, d=4

l = [*range(5)]
#l=[0, 1, 2, 3, 4]

mylist = [6]
[val] = mylist
print(val)
#>>> 6

mynestedlist = [[5]]
[[val]] = mynestedlist
print(val)
#>>> 5

#there are two optional arguments to the sorted() function, key and reversed.  Key is how to sort
#the entries, it is a one argument functio that is applied to the entries before sorting them
fruits = ['grape', 'raspberry', 'apple', 'banana']

sorted(fruits, reverse=True)
# Sort by length of the strings
sorted(fruits, key=len)
sorted(fruits, key=len, reverse=True)

# There is a library with binary search built in in the 'bisect' python module
