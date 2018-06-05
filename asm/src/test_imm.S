.section .text
.globl _start
_start:

# Status: [...]

# Test ADDI - addi: rd <- rs1 + imm
nop 
addi x0, x0, 10  # Shouldn't have an effect
addi x1, x0, 5   # x1 <-  5
addi x2, x0, -1  # x2 <- -1
addi x3, x2, -13 # x3 <- -14

# Status: [0, 5, -1, -14, ...]

# Test SLTI - slti: rd <= 1 if rs1 < imm else 0
slti x4, x1, 6  # x4 <- 1
slti x5, x1, 4  # x5 <- 0

# Status: [0, 5, -1, -14, 1, 0, ...]

# Test SLTIU - sltiu: rd <= 1 if (unsigned) rs1 < (unsigned) imm
sltiu x6, x3, 0xFFFFFFF3    # x7 <- 1
sltiu x7, x3, 0             # x6 <- 0

# Status: [0, 5, -1, -14, 1, 0, 1, 0, ...]

# Test ANDI - andi: rd <- rs1 & imm
andi x8, x1, 17  # x8 <- 1

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, ...]

# Test ORI - ori: rd <- rs1 & imm
ori x9, x1, 145  # x9 <- 149

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, ...]

# Test XORI - xori: rd <- rs1 ^ imm
xori x10, x9, 189 # x10 <- 40

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, 40, ...]

# Test SLLI - slli: rd <- rs1 << imm & (0)
slli x11, x10, 4 # x11 <- 640

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, 40, 640, ...]

# Test SRLI - srli: rd <- (0) & rs1 >> imm
srli x12, x3, 16 # x12 <- 0x0000FFFF

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, 40, 640, 65535, ...]

# Test SRAI - srai: rd <- (sign) & rs1 >> imm
srai x13, x3, 1 # x13 <- 0xFFFFFFF9

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, 40, 640, 65535, 0xFFFFFFF9, ...]

# Test LUI - lui: rd <- {imm, 12'b0}
lui x14, 0x12345 # x14 <- 0x12345000

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, 40, 640, 65535, 0xFFFFFFF9, 0x12345000, ...]

# Test AUIPC - auipc: rd <- {imm, 12'b0} + pc
auipc x15, 0  # x15 <- 56
auipc x16, 10  # x16 <- 41020

# Status: [0, 5, -1, -14, 1, 0, 1, 0, 1, 149, 40, 640, 65535, 0xFFFFFFF9, 0x12345000, 56, 41020, ...]

# Status: [0x0, 0x5 , 0xFFFFFFFF, 0xFFFFFFF2, 0x1, 0x0, 0x1, 0x0, 
#          0x1, 0x95, 0x28, 0x280, 0xFFFF, 0xFFFFFFF9, 0x12345000, 0x38,
#	   0xA03C, ...]
