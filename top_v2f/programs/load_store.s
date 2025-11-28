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
	j _start