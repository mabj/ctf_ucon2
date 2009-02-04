/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 03 - Format - Difficulty level 03
*        Author: Marcos Alvares   <marcos.alvares gmail>
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK    0
#define ERRO -1

#define BUFFER_SIZE 400
#define FORMAT_SIZE 100

// #define DEBUG 1

void __print_sw_title (char *sw_name);
void __format_param(char *output, char *param);
void __create_tag (char *id);
char tag[10];

int main (int argc, char *argv[]) {
  char buffer[BUFFER_SIZE];
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }
  
  strncpy(tag, argv[0], 10);
  __format_param(buffer, argv[1]);

  #ifdef DEBUG
    printf("%s",buffer);
  #endif
  printf("\n Shut your fucking face, uncle fucka! \n");

  return OK;
}

void __format_param(char *output, char *param) {
  char buffer[BUFFER_SIZE];
  memset(buffer, '\0',BUFFER_SIZE);
  snprintf(buffer, (FORMAT_SIZE - 2), "::. Param is %50s", param);
  buffer[FORMAT_SIZE - 1] = '\0';
  sprintf(output, buffer);
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <password>\n\n", sw_name);
}

void __bang_function() {
  __create_tag(tag);
  printf("\n +-+ Bang ! +-+ \n");
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
