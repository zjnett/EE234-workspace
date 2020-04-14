#include <stdint.h>
#include <stdio.h>

extern void receive_string(char c1, char dest[], char c2, int max_size);
extern void send_string(char c, char src[]);

char unknown_string[128];

int main(void)
{
	// This makes me feel really dumb for what order my parameters are in. Oops.
	// (Basically: make r2 and r3 the ones that are used for value swapping, not r0).
	receive_string('\0', unknown_string, '\0', 127);
	send_string('\0', unknown_string);
	for(;;);	//stop at this point

	return 1;
}
