.data
.text
.globl _start

_start:
    li t0, 0              # i
    li t1, 30             # const 30

FOR: 
    bge t0, t1, END       # while (i < 30)
    addi t0, t0, 1        # i++

    j FOR

END:
    li a0, 0
    mv a0, t0

FOREVER:
    j FOREVER