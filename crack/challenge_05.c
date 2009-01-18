/*
* uCon Security Conference II - Recife Pernambuco Brazil - Feb 2009 
*        Challenge 05 - Crack - Difficulty level 01
*        Password Seed - "_1c0n__"
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define JOKER "_1p0a__"
#define TRUE  1
#define FALSE 0
#define OK    0
#define ERRO -1

char *__rot13 (char *str);
int __rot13_char (int ch);
void __print_sw_title (char *sw_name);

int main (int argc, char *argv[]) {
	if (argc != 2) {
		__print_sw_title(argv[0]);
		return ERRO;
	}

	if (! strncmp(JOKER, __rot13(argv[1]), strlen(JOKER))) {
		// This space is reserved to grant privileges to a successful attack
		printf("\n +-+ Bang ! +-+ \n");
	} else {
		printf("\n Shut your fucking face, uncle fucka! \n");
	}
	return OK;	
}

char *__rot13 (char *str) {
	int i;
	for (i = 0; i < strlen(str); i++) {
		str[i] = __rot13_char((int) str[i]);
	}
	return str;
}

// Function written by Michael Schroeder
int __rot13_char (int ch) {
	int b;
	return ((b=64^ch&223)&&b<27?ch&96|(b+12)%26+1:ch);
}

void __print_sw_title (char *sw_name) {
	printf(" ----------- [%s] ----------- \n", sw_name);
	printf(" ::. Usage: %s <password>\n\n", sw_name);
}
