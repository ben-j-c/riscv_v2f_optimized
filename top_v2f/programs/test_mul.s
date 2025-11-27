.data
val_a: .word 3
val_b: .word 4

.text
.globl _start
_start:
	la x1, val_a
	la x2, val_b
	lw x1, 0(x1)
	lw x2, 0(x2)
	mul x3, x1, x2
	mulh x3, x1, x2
	mulhsu x3, x1, x2
	mulhu x3, x1, x2
	j _start

