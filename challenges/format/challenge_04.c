/*
*  challenge_04.c is a piece of uCon 2009 Capture The Flag code
*  Copyright (C) 2002 Marcos Alvares <marcos.alvares@gmail.com>
*
*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 3, or (at your option)
*  any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*
*
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
  char *tag_name = (char *)malloc(24 * sizeof(char));
  memset(tag_name, '\0', 24);
  snprintf(tag_name,24, "./%s.tag", id);
  fd = fopen(tag_name, "w");
  if (fd != NULL) {
    fprintf(fd, "Bang!!\n");
    fclose(fd);
  } else {
    printf("[!] Error on open a challenge tag file.\n");
  }
}

