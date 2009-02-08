/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 01 - Format - Difficulty level 01
*        Author: Marcos Alvares   <marcos.alvares gmail>
*                Gustavo Pimentel <gusbit gmail>
*/


// WARN: TENTATIVA DE FAZER COM QUE O USUARIO EXPLORE TODO O ADDRESS SPACE A
// PROCURA DE ALGUMA INFORMACAO. ACHAR UMA FORMA DE FAZER ISSO SEM QUE O USUARIO
// CONSIGA A INFORMACAO ATRAVES DE UM STRINGS OU UM OBJDUMP TENTAMOS COLOCAR
// ALGUM MODULO PARA OFUSCACAO (ROT13).

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK    0
#define ERRO -1

char passwd[20] = "uC0nS3cur17y";
char *strnlen (char *str);
int __strnlen (int ch);
void __print_sw_title (char *sw_name);
void __create_tag (char *id);

int main (int argc, char *argv[]) {

  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  printf(argv[1]);

  if(! strncmp(argv[1], strnlen(passwd), strlen(passwd))) {
    __create_tag(argv[0]);
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\n Shut your fucking face, uncle fucka! \n");
  }

  return OK;
}

char *strnlen (char *str) {
  int i;
  for (i = 0; i < strlen(str); i++) {
    str[i] = __strnlen((int) str[i]);
  }
  return str;
}

// Function written by Michael Schroeder
int __strnlen (int ch) {
  int b;
  return ((b=64^ch&223)&&b<27?ch&96|(b+12)%26+1:ch);
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <password>\n\n", sw_name);
}

void __create_tag (char *id) {
  FILE *fd;
  char *tag_name = (char *)malloc(38 * sizeof(char));
  memset(tag_name, '\0', 38);
  snprintf(tag_name,34, "./score/%s_response", id);
  fd = fopen(tag_name, "w");
  if (fd != NULL) fclose(fd);
}
