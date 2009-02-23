#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STACK_PROTECTION

typedef unsigned int uint;
unsigned int safe_eip = 0;

void __smash_the_stack (char *params);
unsigned long __get_ebp(void);

int main (int argc, char *argv[]) {
	if (argc != 2) {
		printf("\n::. Test smashing the stack .::\n");
		printf("   usage: %s <params>\n", argv[0]);
		exit(1);
	}

	__smash_the_stack (argv[1]);
	return 0;
}

void __smash_the_stack (char *params) {
  #ifdef STACK_PROTECTION
    unsigned long canary[1];
    canary[0] = 0x11111111;
  #endif
  char buffer[20];
  strcpy(buffer, params);


  #ifdef STACK_PROTECTION
    printf("%#x\n\n", canary);
    if (*canary != 0x11111111) {
      printf("the base stack has been modified\n");
      exit(0);
    }
  #endif
//   exit(0);
}

int check_canary (unsigned long *address, unsigned long value) {
}


unsigned long __get_ebp(void) {
	__asm__("movl %ebp, %eax");
}
