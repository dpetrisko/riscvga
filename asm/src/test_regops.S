.section .text

.globl _start
_start:

# Status: [...]

# Initialize Registers
addi x1, x0, 5    # x1 <- 5
addi x2, x0, -1   # x2 <- -1
addi x3, x0, 9    # x3 <- 9
addi x4, x0, 156  # x4 <- 156
addi x5, x0, -45  # x5 <- -45
addi x6, x0, 123  # x6 <- 123
addi x7, x0, 4    # x7 <- 4

# Status: [0, 5, -1, 9, 156, -45, 123, 4, ...]

# Test ADD - add: rd <- rs1 + rs2
add x8,  x1, x2 # x8  <- 4
add x9,  x3, x5 # x9  <- -36
add x10, x4, x6 # x10 <- 279

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, ...]

# Test SLT - slt: rd <- 1 if rs1 < rs2 else 0
slt x11, x1, x2 # x11 <- 0
slt x12, x2, x1 # x12 <- 1

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, ...]

# Test SLTU - sltu: rd <- 1 if $unsigned(rs1) < $unsigned(rs2) else 0
sltu x13, x2, x1 # x13 <- 0
sltu x14, x1, x2 # x14 <- 1

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, ...]

# Test AND - and: rd <- rs1 & rs2
and x15, x4, x6 # x15 <- 24

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, ...]

# Test OR - or: rd <- rs1 | rs2
or x16, x4, x6 # x16 <- 255

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, 255, ...]

# Test XOR - xor: rd <- rs1 ^ rs2
xor x17, x5, x2 # x17 <- 44

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, 255, 44, ...]

# Test SLL - sll: rd <- rs1 << $unsigned(rs2[4:0])
sll x18, x3, x1 # x18 <- 288

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, 255, 44, 288, ...]

# Test SRL - srl: rd <- (0) rs1 >> $unsigned(rs2[4:0])
srl x19, x5, x7 # x19 <- 0x0FFFFFFD

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, 255, 44, 288, 0x0FFFFFFD, ...]

# Test SUB - sub: rd <- rs1 - rs2
sub x20, x4, x6 # x20 <- 33

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, 255, 44, 288, 0x0FFFFFFD, 33, ...]

# Test SRA - sra: rd <- (sign) rs1 >>> $unsigned(rs2[4:0])
sra x21, x5, x2 # x21 <- -1

# Status: [0, 5, -1, 9, 156, -45, 123, 4, 4, -36, 279, 0, 1, 0, 1, 24, 255, 44, 288, 0x0FFFFFFD, 33, -1, ...]


