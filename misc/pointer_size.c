#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]) {
	printf("char\t\t[%d]\n", sizeof(char));
	printf("unsigned int \t[%d]\n", sizeof(unsigned int));
	printf("long \t\t[%d]\n", sizeof(long));
        printf("lhebs \t\t[%d]\n", sizeof(0xffffffff));
	printf("unsigned long \t[%d]\n", sizeof(unsigned long));
	printf("char \t\t[%d]\n", sizeof(char *));
	printf("int * \t\t[%d]\n", sizeof(int *));
	printf("float * \t[%d]\n", sizeof(float *));
	printf("long * \t\t[%d]\n", sizeof(long *));
	
}

