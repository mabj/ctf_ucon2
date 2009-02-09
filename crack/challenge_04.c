/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 04 - Crack - Difficulty level 03
*        Password Seed - "_uC0n_"
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define JOKER "\x5f\x75\x43\x30\x6e\x5f\x00"
#define TRUE  1
#define FALSE 0
#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);
int __is_valid_dynamic_token (char *password);
void __create_tag (char *id);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  if ( __is_valid_dynamic_token(argv[1]) ) {
    __create_tag(argv[0]);
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\n Shut your fucking face, uncle fucka! \n");
  }

  return OK;
}

int __is_valid_dynamic_token (char *password) {
  char *token = (char *) malloc(30*sizeof(char));
  time_t time1;
  memset((char *)token, '\0', 30);
  sprintf(token, "%s_%d", JOKER, time(&time1));

  if (! strncmp(token, password, 18) ) {
    return TRUE;
  }

  return FALSE;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <password>\n\n", sw_name);
}

void __create_tag (char *id) {
  FILE *fd;
  char *tag_name = (char *)malloc(24 * sizeof(char));
  memset(tag_name, '\0', 24);
  snprintf(tag_name,24, "./%s.tag", id);
  fd = fopen(tag_name, "w");
  fprintf(fd, "Bang!!\n");
  if (fd != NULL) fclose(fd);
}
