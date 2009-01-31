#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define WAIT_TIME 2

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
	return true;

}
void error_usage(char* program_name) {
}

bool id_registered(char* id) {
	FILE *file = NULL;
	printf("Checking if ID is valid...\n");
	sleep(WAIT_TIME);
	//TODO
	//fclose(file);
	return true;
}

bool id_tagged(char* id) {
	FILE *file = NULL;
	printf("Checking if this level was already tagged...\n");
	sleep(WAIT_TIME);
	//TODO
	//fclose(file);
	return false;
}

void tag_id(char* id) {
	FILE *file = NULL;
	printf("Tagging level now...\n");
	sleep(WAIT_TIME);
	//TODO
	//fclose(file);
	return;
}
