#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define WAIT_TIME 0
#define MIN_ID 1
#define MAX_ID 1000

bool input_sanitized(int argc, char** argv);
bool id_registered(char* id);
bool id_tagged(char* id);
void tag_id(char* id);

int main (int argc, char** argv)
{
	if (input_sanitized(argc, argv)) {
		if ( id_registered(argv[1])) {
			printf("[OK] ID is valid\n\n");

			if ( id_tagged(argv[1]) ) {
				printf("[EXITING] Level already tagged by you...\n\n");
				exit(EXIT_SUCCESS);
			} else {
				printf("[OK] Level not tagged by you\n\n");

				tag_id(argv[1]);
				printf("[OK] Level tagged\n\n");  
				exit(EXIT_SUCCESS);
			}
		} else {
			printf("[EXITING] ID is not valid\n\n");
			exit(EXIT_FAILURE);
		}
	} else {
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
	//an argv[1] exists
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
		//id must be inside the range MIN_ID and MAX_ID
		if (MIN_ID <= numeric_id && numeric_id <= MAX_ID) {
			//ok... inside the range
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

	char*  tags_file = "tags_file"; //TODO: Detect tags file  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	FILE* file = NULL;
	#define BUFFER_SIZE 10 
	char buffer[BUFFER_SIZE];
	printf("Checking if this level was already tagged...\n");
	sleep(WAIT_TIME);
	file = fopen(tags_file, "r");
	if (file != NULL) {
		//test file integrity
		while (fgets(buffer, BUFFER_SIZE, file) != NULL) {
			if ( strlen(buffer) != 5) {
				printf("[FAIL] Tag file corrupted! Contact the staff!\n");
				exit(EXIT_FAILURE);
			}
		}
		fseek(file, 0, SEEK_SET);
		while (fgets(buffer, BUFFER_SIZE, file) != NULL) {
			if ( strncmp(id, buffer, 4) == 0) {
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

	char* tags_file = "tags_file"; //TODO: Detect tags file <<<<<<<<<<<<<<<<<<<<<<<< 

	FILE *file = NULL;
	printf("Tagging level now...\n");
	sleep(WAIT_TIME);
	file = fopen(tags_file, "a");
	if (file != NULL) {
		fprintf(file, "%s\n", id);
		fclose(file);
	}
	return;
}
