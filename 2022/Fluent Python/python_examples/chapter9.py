def cache(func):
    mycache = {}
    def innerfunc(a, b):
        if (a, b) in mycache:
            print("Using cached value")
            return mycache[(a, b)]
        res = func(a, b)
        mycache[(a, b)] = res
        return res
    return innerfunc

@cache
def add(a, b):
    return a + b

print(add(1, 2))
print(add(1, 2))

b = 6
def f2(a):
    print(a)
    print(b)
    b = 9

# This causes an error!  Since we use b in the function, python uses the local version of b.  But we
# print it before we assign it, meaning that we used the local variable before it was defined!


def make_averager():
    count = 0
    total = 0

    def averager(new_value):
        # Nonlocal is needed here because we are assigning count and total below
        # Nonlocal tells python that these are "free variables"
        nonlocal count, total
        count += 1
        total += new_value
        return total / count

    return averager

avg = make_averager()
print(avg(0))
print(avg(10))


import time
def clock(func):
    cache = {}
    def clocked(*args):
        name = func.__name__
        arg_str = ", ".join(repr(arg) for arg in args)
        key = f"{name} ({arg_str})"

        # No result caching
        t0 = time.perf_counter()
        result = func(*args)
        elapsed = time.perf_counter() - t0

        if not key in cache:
            print(f"[{elapsed:0.8f}s] {name} ({arg_str}) -> {result!r}")
            cache[key] = (result, elapsed)

        # result caching
        #if not key in cache:
        #    t0 = time.perf_counter()
        #    result = func(*args)
        #    elapsed = time.perf_counter() - t0
        #    print(f"[{elapsed:0.8f}s] {name} ({arg_str}) -> {result!r}")

        #    cache[key] = (result, elapsed)
        #else:
        #    result = cache[key][0]

        return result
    return clocked

import functools
# You can just apply multiple decoratos like this...
@functools.cache
@clock
def fib(n):
    if n <= 0:
        return 0
    if n in [1, 2]:
        return 1
    return fib(n-1) + fib(n-2)

print(fib(10))
print(fib(20))
print(fib(30))
print(fib(40))
print(fib(50))
