.section .vram
vram_display_panels:
.fill 8, 4, 0
vram_pixel_array:
.fill 256, 4, 0

.data
val_a: .word 3
val_b: .word 4
val_c: .word 255

.text
.globl _start
_start:
	la x1, val_a
	lb x2, 0(x1)
	lb x3, 4(x1)
	add x4, x2, x3
	sb x4, 8(x1)
	la x1, vram_display_panels
	li x10, 100
loop:
	sb x4, 0(x1)
	addi x4, x4, 1
	sb x4, 4(x1)
	addi x4, x4, 1
	sb x4, 8(x1)
	addi x4, x4, 1
	sb x4, 12(x1)
	addi x4, x4, 1
	sb x4, 16(x1)
	addi x4, x4, 1
	sb x4, 20(x1)
	addi x4, x4, 1
	sb x4, 24(x1)
	addi x4, x4, 1
	sb x4, 28(x1)
	addi x4, x4, 1
	blt x4, x10, loop
end:
	j end
