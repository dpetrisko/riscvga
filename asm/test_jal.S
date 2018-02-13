.globl _start
_start:

# Status: [...]

# Load branch addresses
jal x1, good_br1
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

addi x11, x0, 0xDE
addi x12, x0, 0xDE

jalr x0, x2, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

addi x13, x0, 0xDE
addi x14, x0, 0xDE

good_br1:
addi x31, x31, 1
jalr x2, x1, 32
addi x30, x30, 2

# Status: Should not have 0xDE
# Status: [0, ..., 2, 1]

