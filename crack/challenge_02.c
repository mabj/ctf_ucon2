/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 02 - Crack - Difficulty level 01
*        Password - "uC0nS3cur17y"
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PASSWORD "uC0nS3cur17y"
#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);
void __create_tag (char *id);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  if (! strncmp(PASSWORD, argv[1], strlen(PASSWORD))) {
    __create_tag(argv[0]);
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

void __create_tag (char *id) {
  FILE *fd;
  char *tag_name = (char *)malloc(18 * sizeof(char));
  memset(tag_name, '\0', 18);
  snprintf(tag_name,17, "%s_response", id);
  tag_name += 2;
  fd = fopen(tag_name, "w");
  if (fd != NULL) fclose(fd);
}
