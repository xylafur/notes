import math

#Electro statics
eo = 8.854187817 * 10**-12
k = 1 / (4 * math.pi * eo)

qe = -1.6*10**-19 
qp = -qe

#magnetic
mo = 4 * math.pi * 10 ** -7

#gravitiational
g = 9.81

#cross product function
cross = lambda v1, v2: (v1[1]*v2[2] - v2[1]*v1[2], v1[0]*v2[2] - v2[0]*v1[2], v1[0]*v2[1] - v2[0]*v1[1])
