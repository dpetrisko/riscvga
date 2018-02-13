.globl _start
_start:

# Status: [...]

# Load branch addresses
jal x2, good_br1
addi x1 , x0, 0xDEADBEEF
addi x2 , x0, 0xDEADBEEF
jalr x3, x0, 0

good_br1:
addi x31, x0, 1
jalr x3, x2, 8
addi x30, x0, 2

# Status: Should not have DEADBEEF
# Status: [0, ..., 2, 1]

