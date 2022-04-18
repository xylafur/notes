import collections.abc as abc

# These ABCs describe the interfaces for dictionaries
my_dict = {}
print(isinstance(my_dict, abc.Mapping))
print(isinstance(my_dict, abc.MutableMapping))


# Set defaults will return the value for the given key if the key exists, otherwise it will add
# the key and the given value to the dict and then return that value
my_dict.setdefault('missing', []).append(1)
print(my_dict)
my_dict.setdefault('missing', []).append(2)
print(my_dict)

# The same behavior mentioned above can also be accomplished with a defaultdict type
import collections
my_defaultdict = collections.defaultdict(list)
my_defaultdict['key1'].append('value1')
my_defaultdict['key2'].append('value2')
print(my_defaultdict)

defaultdict2 = collections.defaultdict(str)
print(f"'{defaultdict2['key1']}'")

defaultdict3 = collections.defaultdict(int)
defaultdict3['int1'] += 1
print(defaultdict3)
