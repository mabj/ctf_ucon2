/*
*  challenge_02.c is a piece of uCon 2009 Capture The Flag code
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
*        Challenge 02 - Stack - Difficulty level 02
*        Author: Marcos Alvares <marcos.alvares gmail>
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK    0
#define ERRO -1

void __print_sw_title (char *sw_name);
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
    printf("\n Shut your fucking face, uncle fucka! \n");
  }

  return OK;
}

int __lets_play (char *param) {
  int i = 0;
  char buffer[2];

  for(i = 0; i < strlen(param); i++) {
    if (i % 2)
      buffer[i] = param[rand() % strlen(param)];
    else
      buffer[i] = '\0';
  }

  if ((int) buffer < 0)
    return 0;

  return 1;
}

void __print_sw_title (char *sw_name) {
  printf(" ----------- [%s] ----------- \n", sw_name);
  printf(" ::. Usage: %s <arg>\n\n", sw_name);
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
