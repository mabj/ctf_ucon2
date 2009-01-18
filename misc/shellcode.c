
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int main () {
	int i = 0;
	char *a = "xxxxxxx\0";
	for (i = 0; i<= strlen(a); i++) {
		printf("[%#x]\n\n", a[i]);
	}
}
