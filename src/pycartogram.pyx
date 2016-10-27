"""
multiply.pyx
"""

import cython
from libc.stdlib cimport malloc, free

# import both numpy and the Cython declarations for numpy
import numpy as np
cimport numpy as np

# declare the interface to the C code
cdef extern int loadpop(double *inpop, double **rho, int xsize, int ysize)
cdef extern int loadpopcython(double *inpop, double **rho, int xsize, int ysize)
cdef extern int numpy_test(double *inpop, int size)
cdef extern double** cart_dmalloc(int xsize, int ysize)
cdef extern void cart_makews(int xsize, int ysize)
cdef extern void cart_transform(double **userrho, int xsize, int ysize)
cdef extern void cart_dfree(double **userrho)
cdef extern void creategrid(double *gridx, double *gridy, int xsize, int ysize)
cdef extern void cart_makecart(double *pointx, double *pointy, int npoints,
		   int xsize, int ysize, double blur)
cdef extern void cart_freews(int xsize, int ysize)


@cython.boundscheck(False)
@cython.wraparound(False)
def generate_warp(np.ndarray[double, ndim=2, mode="c"] input not None,
                  np.ndarray[double, ndim=2, mode="c"] gridx not None,
                  np.ndarray[double, ndim=2, mode="c"] gridy not None):
    """
    generate_warp (input, output, xsize, ysize)

    Takes a grid of data points with the shape [xsize][ysize]
    updates output that has the shape [(xsize+1) * (ysize+1)][2]

    param: input -- a 2-d numpy array of np.float64
    param: output -- a 2-d numpy array of np.float64
    """

    cdef int m, n
    cdef double **rho

    xsize, ysize = input.shape[0], input.shape[1]

    cart_makews(xsize,ysize)

    rho = cart_dmalloc(xsize,ysize)

    loadpopcython (&input[0,0], rho, xsize, ysize)

    # writes to a global variable fftrho in cart.c
    cart_transform(rho,xsize,ysize)
    cart_dfree(rho)

    creategrid(&gridx[0,0],&gridy[0,0],xsize,ysize)

    ##/* Make the cartogram */
    cart_makecart(&gridx[0,0],&gridy[0,0],(xsize+1)*(ysize+1),xsize,ysize,0.0)

    # cleanup mem
    cart_freews(xsize,ysize)

    return None

@cython.boundscheck(False)
@cython.wraparound(False)
def interp(np.ndarray[double, ndim=2] gx not None,
           np.ndarray[double, ndim=2] gy not None,
           int xsize,
           int ysize,
           double xin,
           double yin
           ):

    if ((xin<0.0) or (xin>=xsize) or (yin<0.0) or (yin>=ysize)):
        return (xin, yin)
    else:
        ix = int(round(xin))
        dx = int(round(xin - ix))
        iy = int(round(yin))
        dy = int(round(yin - iy))
        xout = (1-dx)*(1-dy)*gx[ix, iy] + dx*(1-dy)*gx[ix+1, iy]\
               + (1-dx)*dy*gx[ix, iy+1] + dx*dy*gx[ix+1, iy+1]
        yout = (1-dx)*(1-dy)*gy[ix, iy] + dx*(1-dy)*gy[ix+1, iy]\
               + (1-dx)*dy*gy[ix, iy+1] + dx*dy*gy[ix+1, iy+1]
        return (xout, yout)
