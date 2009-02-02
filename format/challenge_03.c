/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 03 - Format - Difficulty level 02
*        Author: Marcos Alvares   <marcos.alvares gmail>
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK    0
#define ERRO -1

#define BUFFER_SIZE 100

void __print_sw_title (char *sw_name);
void __print_param(char *param);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  __print_param(argv[1]);

  if(! argv) {
    // This space is reserved to grant privileges to a successful attack
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\n Shut your fucking face, uncle fucka! \n");
  }

  return OK;
}

void __print_param(char *param) {
  char buffer[BUFFER_SIZE];
  memset(buffer, '\0', BUFFER_SIZE);
  snprintf(buffer, BUFFER_SIZE - 1, param);
  printf("\n[%s]\n", buffer);
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <password>\n\n", sw_name);
}

