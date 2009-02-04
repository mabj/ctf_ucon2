/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 04 - Stack - Difficulty level 02
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define STACK_PROTECTION
#define OK    0
#define ERRO -1

int __check_stack_integrity (unsigned int *canary);
int __lets_play (char *param);
void __print_sw_title (char *sw_name);
void __print_error_message();
unsigned int __generate_pseudo_random_canary_value();
unsigned int dynamic_canary_value = 0x0;
void __create_tag (char *id);

int main (int argc , char *argv[]) {
  if (argc != 2) {
    __print_sw_title(argv[0]);
    return ERRO;
  }

  if (__lets_play(argv[1])) {
    __create_tag(argv[0]);
    printf("\n +-+ Bang ! +-+ \n");
  } else {
    __print_error_message();
  }

  exit(0);
}

int __lets_play (char *param) {
  unsigned int canary[1];
  canary[0] = __generate_pseudo_random_canary_value();
  dynamic_canary_value = canary[0];

  char buffer[2];
  strcpy(buffer, param);

  if (__check_stack_integrity(canary) == ERRO) {
    __print_error_message();
    #ifdef DEBUG
      printf("[!] Canary Address:  [%#x] |  Canary Value:   [%#x]\n", canary, *canary);
      printf("[!] The base stack has been modified\n");
    #endif
    exit(1);
  }

  return 0;
}

int __check_stack_integrity (unsigned int *canary) {
  if (*canary != dynamic_canary_value)
    return ERRO;
  return OK;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <arg>\n\n", sw_name);
}

void __print_error_message() {
  printf("\n Shut your fucking face, uncle fucka! \n");
}

unsigned int __generate_pseudo_random_canary_value() {
  time_t time1;
  return (unsigned int)time(&time1);
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
