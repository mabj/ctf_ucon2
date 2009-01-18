#include <stdlib.h>
#include <stdio.h>

int main (int argc, char *argv[]) {
	int i;
	for(i = 0; i <= atoi(argv[1]) - 1; i++)
	printf("[%d]\n\n", rand() % 20);
}
