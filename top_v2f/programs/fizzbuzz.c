#include <stdbool.h>

#include "sys_device.h"

static void print_str(const char *str)
{
	while (*str != '\0') {
		VRAM_LINE_DEVICE_PUTC(*str);
		str++;
	}
}

static char *int_to_string(char *dst, int len, int v)
{
	char *ret = dst + len - 1;
	*ret      = '\0';

	bool sign = false;
	if (v < 0) {
		sign = true;
		v    = -v;
	}
	do {
		ret--;
		int digit = v % 10;
		*ret      = '0' + digit;
		v         = v / 10;
	} while (v > 0);
	if (sign) {
		ret--;
		*ret = '-';
	}

	return ret;
}

static void clear()
{
	VRAM_LINE_DEVICE_CLEAR();
}

void main()
{
	for (int i = 0; i < 100; i++) {
		bool is_fizz = i % 3 == 0;
		bool is_buzz = i % 5 == 0;
		if (is_fizz || is_buzz) {
			clear();
		}
		if (is_fizz) {
			print_str("Fizz");
		}
		if (is_buzz) {
			print_str("Buzz");
		}
		if (!is_fizz && !is_buzz) {
			char digits[16];
			int_to_string(digits, sizeof(digits), i);
			clear();
			print_str(digits);
		}
	}
}