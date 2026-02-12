
#include "sys_device.h"

static void print_str(const char *str)
{
	while (*str != '\0') {
		VRAM_LINE_DEVICE_PUTC(*str);
		str++;
	}
}

void main()
{
	const char *str = "hello world! :)";
	print_str(str);
}