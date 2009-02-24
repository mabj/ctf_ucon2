/*
*  marker.c is a piece of uCon 2009 Capture The Flag code
*  Copyright (C) 2002 Marcos Alvares <marcos.alvares@gmail.com>
*
*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2, or (at your option)
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
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>

#define WAIT_TIME 0
#define MIN_ID 0
#define MAX_ID 1000

/************************************************
 * NOTE!!!!                                     *
 * the tag files used must be in the directory  *
 * /ctf_ucon2/ to this program work             *
 ************************************************/


/* checks if the user provided just one argument
 * to the program. this argument must have 4 characters
 * in length.
 *
 * returns true if the input follow the rules above
 * and false if not.
 */
bool input_sanitized(int argc, char** argv);

/* checks if the id passed (the 4 characters string
 * cited above) is a valid id, i.e. is an integer between
 * the two limits MIN_ID and MAX_ID.
 *
 * id must be different than zero.
 *
 * returns true if the id follow the rules above
 * and false if not
 */
bool id_registered(char* id);

/* checks if an id is already tagged in the tag file.
 * the tag file take the login of the efective user running
 * this program.
 * it also sees if the tag file has only 4 char in length ids
 * in each line. if this check fails the program outputs a
 * a possible breach in the tags file.
 * if the file don't exist (the efective user is not an level
 * in the capture the flag) the program reports that the level
 * is not taggable and quit.
 * 
 * returns true if tagged and false if not.
 */
bool id_tagged(char* id);

/* tags the tag file if this is possible.
 * the tagging process ocurs only at the very end 
 * of the tag file (append only).
 * checks for the confirmation if the tag was written. if
 * some error occurred and the 5 characters (four of the 
 * id and one \n) were not written, it output a message
 * indicating a fail in the tagging process and quits.
 */
void tag_id(char* id);

/* check the uid and username running the program.
 * 
 * returns the user login.
 */
char* detect_tags_file(); 



/* checks the input: if the input is valid see if id is
 * a valid id (quit on the contrary)
 * check if the level was already tagged: if it was not tagged
 * tag now, if it was tagged just quit, if some error happens
 * print the apropriate message to the user 
 */
int main (int argc, char** argv)
{
	if (input_sanitized(argc, argv)) { //basic sanitization of input
		if ( id_registered(argv[1])) { //see if the id is valid
			printf("[OK] ID is valid\n\n");

			if ( id_tagged(argv[1]) ) { //check if already tagged
				printf("[EXITING] Level already tagged by you...\n\n");
				exit(EXIT_SUCCESS);
			} else {
				printf("[OK] Level not tagged by you\n\n");
				//tag level if not tagged
				tag_id(argv[1]);
				printf("[OK] Level tagged\n\n");  
				exit(EXIT_SUCCESS);
			}
		} else { //id is invalid
			printf("[EXITING] ID is not valid\n\n");
			exit(EXIT_FAILURE);
		}
	} else { //input is inapropriate
		printf("Usage: %s XXXX\n", argv[0]);
		printf("Where XXXX is your user ID\n\n");
		exit(EXIT_FAILURE);
	}
	exit(EXIT_SUCCESS);
}

bool input_sanitized(int argc, char** argv) {
	if (argc != 2) {
		return false;
	} 
	
	//an argv[1] exists is it NULL?
	if (argv[1] == NULL) {
		return false;
	}
	
	//argv[1] is not null so we look inside
	if (strlen(argv[1]) != 4) {
		return false;
	}

	//argv[1] has length of four characters
	return true; //is a good user input

}

bool id_registered(char* id) {
	int numeric_id = 0;
	printf("Checking if ID is valid...\n");
	sleep(WAIT_TIME);
	//all four chars of id must be digits
	if (isdigit(id[0]) && isdigit(id[1]) && isdigit(id[2]) && isdigit(id[3])) { 
		numeric_id = atoi(id);
		//id must be inside the range MIN_ID and MAX_ID and different than zero
		if (MIN_ID <= numeric_id && numeric_id <= MAX_ID && numeric_id != 0) {
			//ok... inside the range and not zero
			//is a valid id
			return true;
		} else {
			return false;
		}
	} else {
		//if one or more chars are not digits
		//id is invalid
		return false;
	}
}

bool id_tagged(char* id) {
	char file_name[30] = "/ctf_ucon2/";
	FILE* file = NULL;
	#define BUFFER_SIZE 10 
	char buffer[BUFFER_SIZE];
	printf("Checking if this level was already tagged...\n");
	sleep(WAIT_TIME);
	strcat(file_name, detect_tags_file());
	file = fopen(file_name, "r");
	if (file != NULL) {
		//test file integrity
		while (fgets(buffer, BUFFER_SIZE, file) != NULL) {
			if ( strlen(buffer) != 5) { //four chars for the id and one for the linefeed
				printf("[FAIL] Tag file corrupted! Contact the staff!\n");
				exit(EXIT_FAILURE);
			}
		}
		fseek(file, 0, SEEK_SET);
		while (fgets(buffer, BUFFER_SIZE, file) != NULL) {
			if ( strncmp(id, buffer, 4) == 0) { //see if the id passed exists in the file
				return true;
			}
		}

		//id not found in tags file
		fclose(file);
		return false;
	} else {
		printf("[FAIL] This is not a taggable level\n\n");
		exit(EXIT_FAILURE);
	}
}

void tag_id(char* id) {
	char file_name[30] = "/ctf_ucon2/";
	FILE *file = NULL;
	printf("Tagging level now...\n");
	sleep(WAIT_TIME);
	strcat(file_name, detect_tags_file());
	file = fopen(file_name, "a");
	if (file != NULL) {
		if ( fprintf(file, "%s\n", id) != 5) { //print the 4 chars ID and linefeed
			//if some error appeared in the writing process report the error
			printf("[FAIL] Failed to tag the level\n\n");
			exit(EXIT_FAILURE);
		} else {
			//ok... exactly 5 chars printed...
			//four are the id
			//the last is linefeed (\n)
		}
		fclose(file);
	}
	return;
}

char* detect_tags_file() {
	//get the uid
	unsigned int uid = getuid();
	//recover the login in the passwd file
	struct passwd* user_data = getpwuid(uid);
	return user_data->pw_name;
}       
