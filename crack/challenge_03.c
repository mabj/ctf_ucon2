/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 03 - Crack - Difficulty level 02
*        Password - "uC0nf3rence"
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PASSWORD "uC0nf3renceP1st015"
#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  char *password = (char *) malloc ( sizeof(PASSWORD) * sizeof(char) );
  strncpy (password, argv[1], 12);
  if (! strncmp(PASSWORD, strcat(password, "\x50\x31\x73\x74\x30\x31\x35"), strlen(PASSWORD))) {
    // This space is reserved to grant privileges to a successful attack
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\n Shut your fucking face, uncle fucka! \n");
  }
  return OK;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <password>\n\n", sw_name);
}
