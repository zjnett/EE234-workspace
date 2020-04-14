#include "uart.h"

char unknown_string[128];

int main(void)
{
	configure_uart1();

	char test = uart1_getchar();
	printf("This is being executed from PC, received char: %c\n", test);

	uart1_sendchar('?'); // sends a question mark
	printf("\n");

	uart1_sendstr("String");
	printf("\n");

	char bufferclear = uart1_getchar(); // clear \n buffer from uart

	int chars_copied = uart1_getln(unknown_string, 128);
	printf("%s, %d characters copied\n", unknown_string, chars_copied);

	for(;;);	//stop at this point

	return 1;
}
