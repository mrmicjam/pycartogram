
#include <stdio.h>
#include <stdlib.h>

#include "cart.h"

#define OFFSET 0.005



/* Function to read population data into the array rho.  Returns 1 if there
 * was a problem, zero otherwise */

int loadpopcython(double *inpop, double **rho, int xsize, int ysize)
{
  int ix,iy;
  int i = 0;
  double mean;
  double sum=0.0;

   for (iy=0; iy<ysize; iy++) {
    for (ix=0; ix<xsize; ix++) {
      i = iy + (ix * ysize);
      sum += inpop[i];
      rho[ix][iy] = inpop[i];
    }
  }

  mean = sum/(xsize*ysize);
  for (iy=0; iy<ysize; iy++) {
    for (ix=0; ix<xsize; ix++) {
      rho[ix][iy] += OFFSET*mean;
    }
  }

  return 0;
}

void numpy_test(double *inpop, int size){
    int i;
    for (i=0; i < size; i++){
        printf("%g\n", inpop[i]);
    }
}