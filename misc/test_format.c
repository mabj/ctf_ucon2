#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]) {
  char *a = (char *) malloc(10*sizeof(char));
  int i;
  for (i = 0; i < 10; i++) a[i] = '\0';
  
  
  printf("aAAA%n", a);
  
  printf("\n[%s]\n",a);
  return 1;
}
