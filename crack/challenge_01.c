/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 01 - Crack - Difficulty level 03
*        Password - "pa55uc0_"
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define JOKER "\x40\x53\x06\x03\x43\x52\x54\x3b\x34"
#define KEY   "023661dd4"
#define TRUE  1
#define FALSE 0
#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);
int __is_valid_pwd (char *pwd);
char *__obfuscation (char *pwd, char *key);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  if ( __is_valid_pwd(argv[1]) ) {
    // This space is reserved to grant privileges to a successful attack
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\n Shut your fucking face, uncle fucka! \n");
  }

  return OK;
}

int __is_valid_pwd (char *pwd) {
  if (! strncmp(JOKER, __obfuscation(pwd, KEY), 3) ) {
    return TRUE;
  }

  return FALSE;
}

char *__obfuscation (char *pwd, char *key) {
  int i;
  for (i = 0; i <= strlen(pwd); i++) {
    if(key[i] == '\0') break;
    pwd[i] = pwd[i] ^ key[i];
  }

  return pwd;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <password>\n\n", sw_name);
}
