/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 01 - Format - Difficulty level 02
*        Author: Marcos Alvares   <marcos.alvares gmail>
*                Gustavo Pimentel <gusbit gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);
void __create_tag (char *id);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  int overwrite_param = 0;

  printf(argv[1]);

  if (overwrite_param > 0) {
    __create_tag(argv[0]);
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    printf("\nShut your fucking face, uncle fucka! \n");
  }

  return OK;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <parameters>\n\n", sw_name);
}

void __create_tag (char *id) {
  FILE *fd;
  char *tag_name = (char *)malloc(38 * sizeof(char));
  memset(tag_name, '\0', 38);
  snprintf(tag_name,34, "./score/%s_response", id);
  fd = fopen(tag_name, "w");
  if (fd != NULL) fclose(fd);
}
