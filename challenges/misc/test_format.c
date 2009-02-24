/*
*  test_format.c is a piece of uCon 2009 Capture The Flag code
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
*/

#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]) {
  char *a = (char *) malloc(10*sizeof(char));
  int i;
  for (i = 0; i < 10; i++) a[i] = '\0';
  
  
  printf("aAAA%n", a);
  
  printf("\n[%s]\n",a);
  return 1;
}
