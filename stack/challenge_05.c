/*
* uCon Security Conference II - Recife / Pernambuco / Brazil - Feb 2009
*        Challenge 05 - Stack - Difficulty level 03
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define STACK_PROTECTION
#define AIR_SPACE_SIZE 20
#define OK    0
#define ERRO -1
#define DEBUG

int __check_stack_integrity (unsigned int *air_space);
int __lets_play (char *param);
void __print_sw_title (char *sw_name);
void __print_error_message();
unsigned int __generate_pseudo_random_canary_value();
unsigned int dynamic_canary_value = 0x0;
unsigned int *check_positions;
unsigned int *dynamic_canaries_value;
time_t time1;
int canary_quantity = 0;
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

void __fill_air_space (unsigned int *air_space) {
  int i;
  int canary_id;
  for (i = 0; i < (AIR_SPACE_SIZE * 3); i++ ) {
    air_space[rand()%AIR_SPACE_SIZE] = __generate_pseudo_random_canary_value();
  }
  
  canary_quantity = (((unsigned int)time(&time1) % AIR_SPACE_SIZE) + 1) ;
  check_positions = (unsigned int *) malloc(canary_quantity * sizeof(unsigned int));
  dynamic_canaries_value = (unsigned int *) malloc(canary_quantity * sizeof(unsigned int));
  #ifdef DEBUG
    printf("[+] Generating %d canaries\n", canary_quantity);
  #endif
  
  for (i = 0; i < canary_quantity; i++) {
    canary_id = ((unsigned int)time(&time1)+ (rand() % AIR_SPACE_SIZE)) % AIR_SPACE_SIZE;
    check_positions[i] = canary_id;
    dynamic_canaries_value[i] = air_space[canary_id];
    #ifdef DEBUG
      printf("\t[+] Canary -> id: %d\t address: %#x\t value: %#x\n", canary_id, &air_space[canary_id], air_space[canary_id]);
    #endif
    
  }
}

int __lets_play (char *param) {
  unsigned int air_space[AIR_SPACE_SIZE];
  __fill_air_space(air_space);

  char buffer[20];
  strcpy(buffer, param);

  if (__check_stack_integrity(air_space) == ERRO) {
    __print_error_message();
    #ifdef DEBUG
      printf("[!] The base stack has been modified\n");
    #endif
    exit(1);
  }

  return 0;
}

int __check_stack_integrity (unsigned int *air_space) {
  int i;
  for(i = 0; i < canary_quantity; i++)
    if (air_space[check_positions[i]] != dynamic_canaries_value[i])
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
  return (unsigned int)time(&time1) % (rand() % 0x1AFFAACC) ;
}

void __create_tag (char *id) {
  FILE *fd;
  char *tag_name = (char *)malloc(38 * sizeof(char));
  memset(tag_name, '\0', 38);
  snprintf(tag_name,34, "./score/%s_response", id);
  fd = fopen(tag_name, "w");
  if (fd != NULL) fclose(fd);
}
