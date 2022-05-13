import collections

def _upper(key):
    try:
        return key.upper()
    except AttributeError:
        return key

# An example of a mixin class.  This is not meant to be instantiated, only meant to be subclassed
# by another object so that it can add some flavor to the other class
class UpperClassMixin:
    def __setitem__(self, key, item):
        super().__setitem__(_uper(key), item)

    def __getitem__(self, key):
        return super().__getitem__(_upper(key))

    def get(self, key, default=None):
        return super().get(_upper(key), default)

    def __contains__(self, key):
        return super().__contains__(_upper(key))

# Because of the way MRO works in python, the Mixin generally needs to appear as the first base
# class in the tuple of base classes
class UpperDict(UpperCaseMixin, collections.UserDict):
    pass

class UpperCounter(UpperCaseMixin, collections.Counter):
    pass
