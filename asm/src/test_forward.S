.section .text
.globl _start
_start:

# Status: [...]

# Test ADDI - addi: rd <- rs1 + imm
addi x1, x0, 1 # x1 <- 1
addi x2, x1, 2 # x2 <- 3
addi x3, x1, 3 # x3 <- 4
nop
nop
nop
nop
nop
