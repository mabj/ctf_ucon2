#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  int *a = (int *) malloc(2*sizeof(int));
  a[0] = 2;
  printf("\n[X] TESTE [X]\n");
  printf("20%n", a);
  printf("\n[%#x]\n", a[0]);
  return 0;
} // main
