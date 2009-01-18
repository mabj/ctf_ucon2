/*
* uCon Security Conference II - Recife Pernambuco Brazil - Feb 2009 
*        Challenge 01 - Stack - Difficulty level 01
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);

int main (int argc , char *argv[]) {
  char buffer[2];

  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  strcpy((char *)buffer, argv[1]);

  if (buffer < 0) {
    // This space is reserved to grant privileges to a successful attack
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\n Shut your fucking face, uncle fucka! \n");
  }

  return OK;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <arg>\n\n", sw_name);
}
