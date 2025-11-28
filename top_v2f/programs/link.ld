OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
	RAM (rwx) : ORIGIN = 0x0000, LENGTH = 64K
	VRAM(rw) : ORIGIN = 0x40000, LENGTH = 64K
}

SECTIONS
{
	.text : {
		. = ALIGN(4);
		*(.text)
	} > RAM

	.data : {
		. = 0x8800;
		. = ALIGN(4);
		*(.data)
	} > RAM

	.bss : {
		. = ALIGN(4);
		*(.bss)
	} > RAM

	.vram : {
		. = ALIGN(4);
		*(.vram)
	} > VRAM

	PROVIDE(_stack_top = ORIGIN(RAM) + LENGTH(RAM));
}