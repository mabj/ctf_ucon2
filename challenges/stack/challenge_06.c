/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 06 - Stack - Difficulty level 03
*        Author: Gustavo Pimentel <gusbit gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK 	0
#define ERROR	-1

void __print_sw_title (char *sw_name);
char *__copy_str (char *dst, char *src);
void __copy_arg2buf (char *argv);
void __process_args (char *argv);
void __print_str (char *argv[]);
void __create_tag (char *id);

int main (int argc, char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERROR;
  }
  else {
    __print_str(argv);
  }

  return OK;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <arg>\n\n", sw_name);
}

char *__copy_str (char *dst, char *src) {
  if (strlen(src) > 256) {
    exit(ERROR);
  }

  char *p = dst;

  while (*src != '\0') {
    *p++ = *src++;
  }

  *p = '\0';
  return dst;
}

void __copy_arg2buf (char *argv) {
  char buffer[256];

  memset(buffer, '\0', sizeof(buffer));
  __copy_str(buffer, argv);
}

void __process_args (char *argv) {
  int canary = 0xdeadbeef;

  __copy_arg2buf(argv);

  if (canary != 0xdeadbeef) {
    exit(ERROR);
  }
}

void __print_str (char *argv[]) {
  if (argv) {
    __process_args(argv[1]);
    printf("\nShut your fucking face, uncle fucka! \n");
  } else {
    __create_tag(argv[0]);
    printf("\n +-+ Bang ! +-+ \n");
  }
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
