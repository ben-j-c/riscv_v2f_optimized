
#include "sys_device.h"

void main()
{
	for (int i = 0; i < 100; i++) {
		int offset = i % 8;
		VRAM_DISPLAY_SET(offset, i * i);
	}
}