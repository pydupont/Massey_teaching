# Pyrex sources to compute the laplacian.
# Some of this code is taken from numeric_demo.pyx
#
# Author: Prabhu Ramachandran <prabhu_r at users dot sf dot net>

import numpy

cdef extern from "math.h":
    double sqrt(double x)

cdef extern from "numpy/arrayobject.h":

    ctypedef int intp 

    ctypedef extern class numpy.dtype [object PyArray_Descr]:
        cdef int type_num, elsize, alignment
        cdef char type, kind, byteorder, hasobject
        cdef object fields, typeobj

    ctypedef extern class numpy.ndarray [object PyArrayObject]:
        cdef char *data
        cdef int nd
        cdef intp *dimensions
        cdef intp *strides
        cdef object base
        cdef dtype descr
        cdef int flags

    void import_array()

import_array()

def pyrexTimeStep(ndarray u, double dx, double dy):
    if chr(u.descr.type) <> "d":
        raise TypeError("Double array required")
    if u.nd <> 2:
        raise ValueError("2 dimensional array required")
    cdef int nx, ny
    cdef double dx2, dy2, dnr_inv, err
    cdef double *elem
    
    nx = u.dimensions[0]
    ny = u.dimensions[1]
    dx2, dy2 = dx**2, dy**2
    dnr_inv = 0.5/(dx2 + dy2)
    elem = <double *>u.data
    
    err = 0.0
    cdef int i, j
    cdef double *uc, *uu, *ud, *ul, *ur
    cdef double diff, tmp
    for i from 1 <= i < nx-1:
        uc = elem + i*ny + 1
        ur = elem + i*ny + 2
        ul = elem + i*ny
        uu = elem + (i+1)*ny + 1
        ud = elem + (i-1)*ny + 1
        
        for j from 1 <= j < ny-1:
            tmp = uc[0]
            uc[0] = ((ul[0] + ur[0])*dy2 +
                     (uu[0] + ud[0])*dx2)*dnr_inv
            diff = uc[0] - tmp
            err = err + diff*diff
            uc = uc + 1; ur = ur + 1;  ul = ul + 1
            uu = uu + 1; ud = ud + 1

    return sqrt(err)
